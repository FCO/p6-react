# p6-react

```
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
                }
            }}
        </ul>
    }
}

say UlList.new(props => {:items<bla ble bli>}).render.render
```

## running:

```
<ul>
     <li>
          bla
     </li>

     <li>
          ble
     </li>

     <li>
          bli
     </li>

</ul>
```
</ul>
