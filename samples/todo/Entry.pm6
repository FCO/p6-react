use Component;
use TodoList;
use Slang;

component Entry {
    has Str $.data;
    method render {
        <div>
            <input onkeyup={{ sub ($data) {say $data; $!data = $data} }} />
            <input type="submit" value="OK" />
        </div>
    }
}
