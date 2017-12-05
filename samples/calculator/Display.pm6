use Component;
use Slang;

component Display {
	has $.value;
    method render {
        <div className="component-display">
            <div>
                {{$.value}}
            </div>
        </div>
    }
}
