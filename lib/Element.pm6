use Component;
use ComponentStore;
role Element::Plugin {}
class Element {
    has $.type      is required;
    has @.children;
    has %.pars;
    has %.theme;
    has @.plugins;
    has @!component-plugins handles add-component-plugin => "push";

    method TWEAK(|) {
        %!theme = %(%!pars<theme>:v);
        %!pars<theme>:delete;
    }

    proto method value(                 $ ) { *                         }
    multi method value(Component        $_) { self.value(.render, $_)   }
    multi method value(Element          $_) { .render                   }
    multi method value(Positional       $_) { |.map: {self.value($_)}   }
    multi method value(Any:U            $_) { Empty                     }
    multi method value(Block            $_) { .name                     }
    multi method value($ where * === False) { False                     }
    multi method value($ where * === True ) { True                      }
    multi method value(Any              $_) { .Str                      }

    proto method translate-key(         $ )    { *         }
    multi method translate-key("className")    { "class"   }
    multi method translate-key(Any      $_)    { $_        }

    method !attrs is hidden-from-backtrace {
        %!pars.kv.map(-> $name, $value {
            do given self.value($value) {
                when $_ === False {
                    ""
                }
                when $_ === True {
                    "{self.translate-key($name)}"
                }
                default {
                    "{self.translate-key($name)}='{$_}'"
                }
            }
        })
        .join: " "
    }

    method render {
        @!children.grep(*.defined).map: -> $item {$item.theme = |$item.theme, |%!theme if $item.^can("theme")}
        my $comp =  ComponentStore.components{$!type};
        if $comp ~~ Component {
            my %pars;
            for %!pars.kv -> \k, \v {
                %pars{k} := v<>
            }
            my $obj = $comp.new(|%pars, :%!theme, :@!children);
            $obj = self.?apply-component-plugin($obj) // $obj;
            $obj .= render-component;
            $obj = self.?apply-element-plugin($obj) // $obj;
            return $obj.render
        }
        qq:to/END/;
        <{$!type}{(" " if %!pars > 0) ~ self!attrs}>
        {
            @!children
                .grep(*.defined)
                .map({
                    my $obj = self.?apply-element-plugin($_) // $_;
                    self.value($obj)
                })
                .join("\n")
                .indent: 5
        }
        </$!type>
        END
    }
}
