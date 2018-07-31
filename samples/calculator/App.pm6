use React::Component;
use React::Slang;
use React::Styled;
use Display;
use ButtonPanel;
use Button;

component AppStyle does React::Styled {
    method main is style {
        qq:to/END/;
        display: flex;
        flex-direction: column;
        flex-wrap: wrap;
        height: 100%;
        END
    }
}

component App {
    method render {
        sub handle-click(Str $button-name) {
            self.setState: self.state;
        }
        say "aqui";

        <AppStyle>
            <Display
                value={{$.state<next> or $.state<total> or '0'}}
            />
            <ButtonPanel
                clickHandler={{&handle-click}}
            />
        </AppStyle>
    }
}
