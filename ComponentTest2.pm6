use Component;
use Styled;
use Slang;

component ItemStyle does Styled {
    method li is style is media("(min-width: 700px)") {
        "background-color: blue;"
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

