use ThemeProvider;
use Component;
use Server;
use Styled;
use Slang;

component Item {
    has Str $.name;
    method render {
        <li>{{$.name}}</li>
    }
}

my @themes = {:color<black>}, {:color<red>};

component ItemTheme does Styled {
    method li is style {
        "color: {%.theme<color>};"
    }
}

component Test {
    has Str $.name is required;
    has Str @.list;
    method render {
        my $counter = 0;
        <div>
            <h1>
                Shopping List for {{$.name}}
            </h1>
            <ul>
                {{
                    do for @.list -> $item {
                        <ThemeProvider theme={{@themes[$counter++ % 2]}}>
                            <ItemTheme>
                                <Item name={{$item}} />
                            </ItemTheme>
                        </ThemeProvider>
                    }
                }}
            </ul>
        </div>
    }
}

component Parent {
    method render {
        <Test name="bla" list={{"Instagram", "WhatsApp", "Oculus", "FaceBook", "Google+"}} />
    }
}
