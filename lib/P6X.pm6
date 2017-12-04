use Element;
grammar P6X {
    token word {
        \w+
    }
    token attr:sym<pair> {
        <attr-name=.word> '=' <value>
    }
    token attr:sym<bool> {
        <attr-name=.word>
    }
    proto token value    {*                         }
    token value:sym<dbl> { '"' ~ '"' $<value>=.*?   }
    token value:sym<sim> { "'" ~ "'" $<value>=.*?   }
    token value:sym<wrd> { <value=.word>            }
    rule inner-tag {
        <name=.word>
        <attr>* %% <.ws>
    }
    rule closing-tag($name) {
        '</' ~ '>' $name
    }
    rule opening-tag {
        '<' ~ '>' <inner-tag>
    }

    rule text {
        <-[<>]>+
    }

    proto rule children {*}
    rule children:sym<tag> { <tag>  }
    rule children:sym<txt> { <text> }

    proto rule tag {*}
    rule tag:sym<unique> {
        '<' ~ '/>' <inner-tag>
    }
    rule tag:sym<open-close> {
        :my $name;
        ['<' ~ '>' <inner-tag> {$name = $<inner-tag><name>}] ~ <.closing-tag($name)>
        <children>*
    }
    rule TOP { <tag> }
}

class P6X::Action {
    method attr:sym<pair>($/) { make ~$<attr-name> => ~$<value><value> }
    method attr:sym<bool>($/) { make ~$<attr-name> => True }
    method tag:sym<open-close>($/) { self.tag: $/ }
    method tag:sym<unique>    ($/) { self.tag: $/ }
    method tag($/) {
        my $type        = ~$<inner-tag><name>;
        my %pars        = $<inner-tag><attr>.map: *.made;
        my @children    = $<children>.grep(*.defined).map: *.made;
        make Element.new: :$type, :%pars, :@children
    }
    method children:sym<tag>($/) {make $<tag>.made}
    method children:sym<txt>($/) {make ~$/}
    method TOP($/) { make $<tag>.made }
}

sub p6x(Str $p6x) is export { P6X.parse($p6x, :actions(P6X::Action)).made }
