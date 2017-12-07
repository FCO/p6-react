use Component;
use Styled;
use Slang;

component ButtonStyle does Styled {
    has Bool $.wide     = False;
    has Bool $.orange   = False;
    method div is style {
        qq:to/END/;
        display: inline-flex;
        width: {$.wide ?? "50%" !! "25%"};
        flex: 1 0 auto;
        END
    }
    method button is style {
        qq:to/END/;
            {
                $.orange
                    ?? "background-color: #F5923E; color: white;"
                    !! "background-color: #E0E0E0;"
            }
            border: 0;
            margin: 0 1px 0 0;
            flex: 1 0 auto;
            padding: 0;
            font-size: 70px;
        END
    }
    method last is style("div:last-child button") {
        qq:to/END/;
        margin-right: 0;
        END
    }
}

component Button {
    has Str     $.name;
    has         &.handle-click;
    has Bool    $.wide     = False;
    has Bool    $.orange   = False;
    method render {
        sub handle-click {
            &!handle-click($.name);
        }

        <ButtonStyle wide={{$.wide}} orange={{$.orange}}>
            <div>
                <button onClick={{&handle-click}}>
                    {{$.name}}
                </button>
            </div>
        </ButtonStyle>
    }
}

