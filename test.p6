use Component;
use Slang;

component Item {
    has Str $.name;
    method render {
        <li>{{$.name}}</li>
    }
}

component Test {
    has Str $.name is required;
    has Str @.list;
    method render {
        <div className="shopping-list">
            <h1>
                Shopping List for {{$.name}}
            </h1>
            <ul>
                {{
                    do for @.list -> $item {
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

say Parent.new.render.render;
