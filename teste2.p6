use Component;
use Slang;

component Item {
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
                    <Item data={{$item}} />
                }
            }}
        </ul>
    }
}

say UlList.new(:items<bla ble bli>).render.render
