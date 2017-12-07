use Component;
use Element;

unit role Styled;

my role Style {has $.style is rw}
multi trait_mod:<is>(Method $m, :$style!) is export {
    $m does Style;
    $m.style = $style === True ?? $m.name !! $style;
}

my UInt $id = 1;

has Str $!className = "{self.^name}-styled-{$*PID.fmt: "%x"}-{now.fmt: "%x"}-{($id++).fmt: "%x"}";

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
                    do for self.^methods.grep: Style -> $m {
                        my $tag = $m.style;
                        qq:to/END/
                        .{$!className}{$tag.starts-with("main") ?? $tag.substr(4) !! " $tag"} \{
                        {$m(self).indent: 5}
                        \}
                        END
                    }
                ],
            ),
            |self.children
        ]
}
