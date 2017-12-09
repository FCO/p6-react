use Component;
use ComponentStore;
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

	proto method value(           $ ) { *                         }
    multi method value(Component  $_) { self.value(.render, $_)   }
    multi method value(Element    $_) { .render                   }
    multi method value(Positional $_) { |.map: {self.value($_)}   }
    multi method value(Any:U      $_) { Empty                     }
	multi method value(Block      $_) { .name                     }
    multi method value(Any        $_) { .Str                      }

	proto method translate-key(         $ )    { *         }
    multi method translate-key("className")    { "class"   }
    multi method translate-key(Any      $_)    { $_        }

    method !attrs is hidden-from-backtrace {
        %!pars.kv.map(-> $name, $value {
            "{self.translate-key($name)}='{self.value($value)}'"
        })
        .join: " "
    }

	method apply-plugins(+@plugins) {
		for @plugins {
			@!plugins.push: $_;
			@!children.grep(*.defined).map(*.?apply-plugins($_));
			self does $_
		}
		self
	}

    method render is hidden-from-backtrace {
        @!children.grep(*.defined).map: -> $item {$item.theme = |$item.theme, |%!theme if $item.^can("theme")}
        my $comp =  ComponentStore.components{$!type};
        if $comp ~~ Component {
            my %pars;
            for %!pars.kv -> \k, \v {
                %pars{k} := v<>
            }
            given $comp.new(|%pars, :%!theme, :@!children) {
				.apply-plugins(@!component-plugins);
				.add-element-plugin: |@!plugins;
				return .render-component.apply-plugins(@!plugins).render
			}
        }
        qq:to/END/;
        <{$!type}{(" " if %!pars > 0) ~ self!attrs}>
        {
            @!children.grep(*.defined).map({self.value($_)}).join("\n").indent: 5
        }
        </$!type>
        END
    }
}
