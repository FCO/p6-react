use Component;
use Slang;
use Todo;

component TodoList {
    has @.todos;

    method render {
        <table>
            {{
                do for @!todos -> % (Bool :$done, Str :$todo) {
                    <Todo done={{$done}} todo={{$todo}} />
                }
            }}
        </table>
    }
}
