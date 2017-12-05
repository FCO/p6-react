use Component;
use Slang;

component Item {
	has $.data;
    method render {
        <li>
            {{$.data}}
        </li>
    }
}

component UlList {
	has $.items;
    method render {
        <ul>
            {{
                do for |$.items -> $item {
                    <Item data={{$item}} />
                }
            }}
        </ul>
    }
}

say UlList.new(:items<bla ble bli>).render.render
