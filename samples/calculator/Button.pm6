use Component;
use Slang;

component Button {
    has Bool    $.orange    = False;
    has Bool    $.wide      = False;
    has Str     $.name;
    has         &.handle-click;
    method render {
        sub handle-click {
            &!handle-click($.name);
        }

        my $class-name = "component-button";

        if $.orange {
            $class-name ~= " orange";
        }
        if $.wide {
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

