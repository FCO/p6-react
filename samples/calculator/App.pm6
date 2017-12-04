use Component;
use Slang;
use Display;
use ButtonPanel;
use Button;

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

        <div className="component-app">
            <Display
                value={{$.state<next> or $.state<total> or '0'}}
            />
            <ButtonPanel
                clickHandler={{&handle-click}}
            />
        </div>
    }
}

say App.new.render.render
