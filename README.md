# p6-react

```
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
