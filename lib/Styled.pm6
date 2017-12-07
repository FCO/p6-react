use Component;
use Element;

unit role Styled[Str $tag!];

has Str $!className = "styled-{$*PID.fmt: "%x"}-{now.fmt: "%x"}-{(++$).fmt: "%x"}";

method style {...}

method render {
    Element.new:
        :type<div>,
        :pars{
            :$!className
        },
        :children[
            Element.new(
                :type("style"),
                :pars{:type<text/css>},
                :children[
                    qq:to/END/
                    .$!className $tag \{
                    {self.style.indent: 5}
                    \}
                    END
                ],
            ),
            |self.children
        ]
}
