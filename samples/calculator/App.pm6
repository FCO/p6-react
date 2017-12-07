use Component;
use Slang;
use Display;
use ButtonPanel;
use Button;
use Styled;

component AppStyle does Styled {
    method div is style {
        qq:to/END/;
        display: flex;
        flex-direction: column;
        flex-wrap: wrap;
        height: 100%;
        END
    }
}

component App {
    method TWEAK(|) {
        given $.state {
            .<total>        = Nil;
            .<next>         = Nil;
            .<operation>    = Nil;
        }
    }

    method render {
        sub handle-click(Str $button-name) {
            self.setState: self.state;
        }

        <AppStyle>
            <div className="component-app">
                <Display
                    value={{$.state<next> or $.state<total> or '0'}}
                />
                <ButtonPanel
                    clickHandler={{&handle-click}}
                />
            </div>
        </AppStyle>
    }
}
