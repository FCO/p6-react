use Component;
use Slang;

component Display {
    method render {
        <div className="component-display">
            <div>
                {{$.props<value>}}
            </div>
        </div>
    }
}
