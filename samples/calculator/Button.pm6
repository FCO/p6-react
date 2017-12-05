use Component;
use Slang;

component Button {
    has $.orange;
    has $.wide;
    has $.name;
    has &.handle-click;
    method render {
        sub handle-click {
            &!handle-click($.name);
        }

        my $class-name = "component-button";

        with $.orange {
            $class-name ~= " orange";
        }
        with $.wide {
            $class-name ~= " wide";
        }

        <div
            className={{$class-name}}
        >
            <button
                onClick={{&handle-click}}
            >
                {{$.name}}
            </button>
        </div>
    }
}

