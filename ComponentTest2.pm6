use Component;
use Styled;
use Slang;

component ItemStyle does Styled {
    method li is style is media("print") {
        qq:to/END/;
        background-color: blue;
        text-decoration: underline;
        END
    }
}

component LiItem {
    has Str $.data;
    method render {
        <ItemStyle>
            <li>
                {{$.data}}
            </li>
        </ItemStyle>
    }
}

component UlList {
    has Str @.items;
    method render {
        <ul>
            {{
                do for @.items -> $item {
                    <LiItem data={{$item}} />
                }
            }}
        </ul>
    }
}

