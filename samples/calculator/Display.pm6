use Component;
use Styled;
use Slang;

component DisplayStyle does Styled {
    method div is style {
        qq:to/END/;
        background-color: #858694;
        color: white;
        text-align: right;
        font-weight: 200;
        flex: 0 0 auto;
        width: 100%;
        END
    }
    method child-div is style("> div") {
        qq:to/END/;
        font-size: 100px;
        padding: 20px 40px 0 20px;
        END
    }
}

component Display {
    has Str $.value;
    method render {

        <DisplayStyle>
            <div>
                {{$.value}}
            </div>
        </DisplayStyle>
    }
}
