use Grammar::Tracer;
BEGIN $*LANG.refine_slang: 'MAIN',
    role P6X {
#grammar XML {
    token p6x-word {
        \w+
    }
    token p6x-attr {
        <p6x-word> '=' [
            | '"' ~ '"' $<p6x-value>=.*?
            | "'" ~ "'" $<p6x-value>=.*?
            | $<p6x-value=.p6x-word>
        ]
    }
    rule p6x-inner-tag {
        $<p6x-name>=<.p6x-word>
        <p6x-attr>* %% <.ws>
    }
    rule p6x-closing-tag($name) {
        '</' ~ '>' $name
    }
    rule p6x-opening-tag {
        '<' ~ '>' <p6x-inner-tag>
    }
    rule p6x-unique-tag {
        '<' ~ '/>' <p6x-inner-tag>
    }
    rule p6x-open-close-tag {
        :my $name;
        [<p6x-opening-tag> {$name = $<p6x-opening-tag><p6x-inner-tag><p6x-name>}] ~ <p6x-closing-tag($name)>
        $<p6x-inner> = [
            || <p6x-xml>+ $<p6x-post-data>=.*?
            || $<p6x-pre-data>=.+? <p6x-xml>+ $<p6x-post-data>=.*?
            || .*?
        ]
    }
    rule p6x-tag {
        || <p6x-unique-tag>
        || <p6x-open-close-tag>
    }
    rule p6x-xml {
        <p6x-tag>
    }
    token statement_control:sym<p6x> {
        <p6x-xml>
    }
    #rule TOP { <p6x-xml> }


    },
    role P6XActions {
                        method statement_control:sym<p6x> (Mu $/) {
                                say $/;
                                nextsame
                            }
                        }

        #say XML.parse: Q:to/END/;
        #<head>
        #    <body>
        #        bla
        #        <form>
        #            bla
        #        </form>
        #    </body>
        #</head>
#END
<br />
