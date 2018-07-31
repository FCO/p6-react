use Component;
use Slang;
use Todo;

component TodoList {
    has @.todos;
    has &.toggle;

    method render {
        <table>
            {{
                do for @!todos.grep(*.defined).kv -> UInt $index, % (Bool :$done, Str :$todo) {
                    <Todo done={{$done}} todo={{$todo}} toggle={{ &.toggle.assuming: $index }} />
                }
            }}
        </table>
    }
}
