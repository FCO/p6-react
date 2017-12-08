use Component;
use Slang;

component LiItem {
    has Str $.data;
    method render {
        <li>
            {{$.data}}
        </li>
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

