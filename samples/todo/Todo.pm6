use Component;
use Slang;

component Todo {
    has Bool $.done = False;
    has Str  $.todo;

    method render {
        <tr>
            <td>
                <input type=checkbox checked={{$!done ?? "checked" !! "no"}}>
                </input>
            </td>
            <td>
                {{$!todo}}
            </td>
        </tr>
    }
}
