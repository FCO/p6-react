use Component;
use Slang;

component Item {
    method render {
        <li>
            {{$.props<data>}}
        </li>
    }
}

component UlList {
    method render {
        <ul>
            {{
                do for |$.props<items> -> $item {
                    <Item data={{$item}} />
                    #<Item />
                }
            }}
        </ul>
    }
}

say UlList.new(props => {:items<bla ble bli>}).render.render
