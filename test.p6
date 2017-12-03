use Component;
use Element;
use Slang;
use P6X;

component Item {
    method render {
        p6x qq:to/END/;
        <li>{$.props<name>}</li>
        END
    }
}

component Test {
    method render {
        p6x qq:to/END/;
        <div className="shopping-list">
            <h1>
                Shopping List for {$.props<name>}
            </h1>
            <ul>
                {
                    do for |$.props<list> -> $item {
                        "<Item name={$item} />"
                    }
                }
            </ul>
        </div>
        END
    }
}

component Parent {
    method render {
        qq:p6x:to/END/;
        <Test name="bla" list={<Instagram WhatsApp Oculus>} />
        END
    }
}

say Test.new(props => {:name<1234>, :list["Instagram", "WhatsApp", "Oculus"]}).render.render;
#say Parent.new.render#.render;
