use Component;
use Slang;

component Button {
    method render {
        sub handle-click {
            self.setState: self.state;
        }

        my $class-name = "component-button";

        if $.props<orange>:exists {
            $class-name ~= " orange";
        }
        if $.props<wide>:exists {
            $class-name ~= " wide";
        }

        <div
            className={{$class-name}}
        >
            <button
                onClick={{&handle-click}}
            >
                {{$.props<name>}}
            </button>
        </div>
    }
}

