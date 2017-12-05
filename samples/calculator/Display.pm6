use Component;
use Slang;

component Display {
    has Str $.value;
    method render {
        <div className="component-display">
            <div>
                {{$.value}}
            </div>
        </div>
    }
}
