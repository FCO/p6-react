use Component;
use Slang;

component Item {
	has $.name;
    method render {
        <li>{{$.name}}</li>
    }
}

component Test {
	has $.name;
	has $.list;
    method render {
        <div className="shopping-list">
            <h1>
                Shopping List for {{$.name}}
            </h1>
            <ul>
                {{
                    do for |$.list -> $item {
                        <Item name={{$item}} />
                    }
                }}
            </ul>
        </div>
    }
}

component Parent {
    method render {
        <Test name="bla" list={{"Instagram", "WhatsApp", "Oculus"}} />
    }
}

#say Test.new(props => {:name<1234>, :list["Instagram", "WhatsApp", "Oculus"]}).render.render;
say Parent.new.render.render;
