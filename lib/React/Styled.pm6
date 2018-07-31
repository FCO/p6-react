use React::Component;
use React::Element;

unit role React::Styled;

my role React::Style[$tag] {has $.style is rw = $tag}
multi trait_mod:<is>(Method $m, :$style!) is export {
    $m does React::Style[$style === True ?? $m.name !! $style];
}

my role React::WrappedBy[$wrap] {has $.wrapped-by is rw = $wrap}
multi trait_mod:<is>(Method $m, :$wrapped-by!) is export {
    $m does React::WrappedBy[$wrapped-by === True ?? $m.name !! $wrapped-by];
}

multi trait_mod:<is>(Method $m, :$media!) is export {
    trait_mod:<is>($m, :wrapped-by("@media $media"));
}

my UInt $id = 1;

has Str $!className = "{self.^name}-styled-{$*PID.fmt: "%x"}-{now.fmt: "%x"}-{($id++).fmt: "%x"}";

method render {
    my %wrap = self.^methods.grep(Style).classify: {.?wrapped-by // ""}
    React::Element.new:
        :type<div>,
        :pars{
            :$!className
        },
        :children[
            React::Element.new(
                :type("style"),
                :pars{:type<text/css>},
                :children[
                    |do for |%wrap{""}.grep(*.defined) -> $m {
                        my $tag = $m.style;
                        qq:to/END/
                        .{$!className}{$tag.starts-with("main") ?? $tag.substr(4) !! " $tag"} \{
                        {$m(self).indent: 5}
                        \}
                        END
                    },
                    |do for %wrap.keys.grep(* !~~ "").sort -> $wrap {
                        |do for |%wrap{$wrap}.grep(*.defined) -> $m {
                            my $tag = $m.style;
                            qq:to/END/
                            {$wrap} \{
                                .{$!className}{$tag.starts-with("main") ?? $tag.substr(4) !! " $tag"} \{
                                {$m(self).indent: 5}
                                \}
                            \}
                            END
                        }
                    }
                ],
            ),
            |self.children
        ]
}
