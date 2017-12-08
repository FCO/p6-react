use Component;
class Element {
    has $.type      is required;
    has @.children;
    has %.pars;
    has %.theme;

    method TWEAK(|) {
        %!theme = %(%!pars<theme>:v);
        %!pars<theme>:delete;
    }

    method !value($_) is hidden-from-backtrace {
        when Component  { self!value(.render, $_)   }
        when Element    { .render                   }
        when Positional { |.map: {self!value($_)}   }
        when !.defined  { Empty                     }
        when Block      { .name                     }
        default         { .Str                      }
    }

    method !translate-key($_) is hidden-from-backtrace {
        when "className"    { "class"   }
        default             { $_        }
    }

    method !attrs is hidden-from-backtrace {
        %!pars.kv.map(-> $name, $value {
            "{self!translate-key($name)}='{self!value($value)}'"
        })
        .join: " "
    }

    method render is hidden-from-backtrace {
        @!children.grep(*.defined).map: -> $item {$item.theme = |$item.theme, |%!theme if $item.^can("theme")}
        my $comp =  MetamodelX::ComponentHOW.components{$!type};
        if $comp ~~ Component {
            my %pars;
            for %!pars.kv -> \k, \v {
                %pars{k} := v<>
            }
            return $comp.new(|%pars, :%!theme, :@!children).render-component.render
        }
        qq:to/END/;
        <{$!type}{(" " if %!pars > 0) ~ self!attrs}>
        {
            @!children.grep(*.defined).map({self!value($_)}).join("\n").indent: 5
        }
        </$!type>
        END
    }
}
