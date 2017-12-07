use Component;
use Element;

unit role Styled[Str $tag!];

has Str $!className = "styled-{$*PID.fmt: "%x"}-{now.fmt: "%x"}-{(++$).fmt: "%x"}";

method code {...}

method render {
    Element.new:
        :type<div>,
        :pars{
            :$!className
        },
        :children[
            Element.new(
                :type("style"),
                :children[
                    qq:to/END/
                    #$!className $tag \{
                    {self.code.indent: 5}
                    \}
                    END
                ],
            ),
            |self.children
        ]
}
