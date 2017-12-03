use QAST:from<NQP>;
use Element;
use nqp;

sub create-element($type, *@data) is export {
    my %data = @data.classify: {$_ ~~ Pair ?? "pars" !! "children"};
    #say "Element.new: :$type, :pars({%data<pars>}), :children({%data<children> // []})";
    Element.new: :$type, :pars(%data<pars> // {}), :children(%data<children> // [])
}

sub create-pair($key, $value) is export {
    $key => $value
}

sub EXPORT {
    $*LANG.refine_slang: 'MAIN', role {
        token p6x-word {
            \w+
        }
        token p6x-attr {
            <p6x-attr-name=.p6x-word> '=' <p6x-value>
        }
        proto token p6x-value    {*                             }
        token p6x-value:sym<dbl> { '"' ~ '"' $<p6x-value>=<-[">]>*    }
        token p6x-value:sym<sim> { "'" ~ "'" $<p6x-value>=<-['>]>*    }
        token p6x-value:sym<wrd> { <p6x-value=.p6x-word>              }
        token p6x-value:sym<blk> { '{' ~ '}'<p6x-value=.pblock>       }

        rule p6x-inner-tag {
            <p6x-attr>* %% <.ws>
        }
        rule p6x-closing-tag($name) {
            '</' ~ '>' $name
        }

        rule p6x-text {
            <-[<>{}]>+
        }

        proto rule p6x-children {*}
        rule p6x-children:sym<tag> { <p6x-tag>  }
        rule p6x-children:sym<txt> { <p6x-text> }
        rule p6x-children:sym<blk> { '{' ~ '}' <pblock>}

        proto rule p6x-tag {*}
        rule p6x-tag:sym<unique> {
            '<' ~ '/>' [
                <!after '/'>
                <tag-name=.p6x-word>
                <p6x-inner-tag>
            ]
        }
        rule p6x-tag:sym<open-close> {
            [
                '<' ~ '>' [
                    <!after '/'>
                    <tag-name=.p6x-word>
                    <p6x-inner-tag>
                    <!before '/'>
                ]
            ] ~ ["</" ~ ">" $<tag-name>] <p6x-children>*
        }
        rule term:sym<p6x> {
            <p6x-tag>
        }
    },
    role {
        sub lk(Mu \h, \k) {
            nqp::atkey(nqp::findmethod(h, 'hash')(h), k)
        }

        method p6x-value:sym<dbl>(Mu $/) { $/.make: QAST::SVal.new: :value(lk($/, "p6x-value").Str)  }
        method p6x-value:sym<sim>(Mu $/) { $/.make: QAST::SVal.new: :value(lk($/, "p6x-value").Str)  }
        method p6x-value:sym<wrd>(Mu $/) { $/.make: lk($/, "p6x-value").made }
        method p6x-value:sym<blk>(Mu $/) { $/.make: lk($/, "p6x-value").made }

        method p6x-attr(Mu $/) {
            my $create-pair := $/.make: QAST::Op.new:
                :op<call>,
                :name<&create-pair>
            ;
            $create-pair.push:
                QAST::SVal.new:
                    :value(lk($/, "p6x-attr-name"))
            ;

            $create-pair.push: lk($/, "p6x-value").made;

            $/.make: $create-pair
        }

        method p6x-text(Mu $/) { $/.make: QAST::SVal.new: :value($/.Str) }

        method p6x-word(Mu $/) { $/.make: QAST::SVal.new: :value($/.Str) }

        method p6x-children:sym<tag>(Mu $/) {
            $/.make: lk($/, "p6x-tag").made
        }

        method p6x-children:sym<txt>(Mu $/) {
            $/.make: lk($/, "p6x-text").made
        }

        method p6x-children:sym<blk>(Mu $/) {
            $/.make: QAST::Op.new:
                :op<call>,
                lk($/, "pblock").made
        }

        sub tag(Mu $/) {
            my $tag-name    := lk($/, "tag-name").made;
            my $pars        := lk(lk($/, "p6x-inner-tag"), "p6x-attr");
            my $tag         := QAST::Op.new:
                :op<call>,
                :name<&create-element>,
                $tag-name
            ;
            for |$pars {
                $tag.push: $_.made
            }
            $tag
        }

        method p6x-tag:sym<open-close>(Mu $/) {
            my $children    := lk($/, "p6x-children");
            my $tag := tag $/;
            for |$children {
                $tag.push: $_.made
            }
            $/.make( $tag )
        }

        method p6x-tag:sym<unique>(Mu $/) {
            $/.make: tag $/
        }

        method term:sym<p6x>(Mu $/) {
            my $tag := lk($/, "p6x-tag");
            $/.make($tag.made)
        }
    }

    Map.new
}
