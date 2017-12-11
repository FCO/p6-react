use Component;
use Styled;
use Slang;

component Todo {
    has Bool $.done = False;
    has Str  $.todo;
    has      &.toggle;

    method render {
        <tr>
            <td>
                <input type=checkbox checked={{ $.done }} onclick={{ &.toggle }} />
            </td>
            <td style={{ $.done ?? "text-decoration: line-through;" !! "" }}>
                {{$.todo}}
            </td>
        </tr>
    }
}
