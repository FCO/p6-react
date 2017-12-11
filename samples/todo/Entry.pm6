use Component;
use TodoList;
use Slang;

component Entry {
    method render {
        <div>
            <input name="new-todo" />
            <input type="submit" value="OK" />
        </div>
    }
}
