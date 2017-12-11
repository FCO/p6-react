use Component;
use TodoList;
use Entry;
use Slang;

component Display {
    method render {
        my sub add-todo(%data) {
            CATCH {
                default {
                    .say;
                }
            }
            my $todo = %data<fields><new-todo>;
            say "adding: $todo";
            my @todo = |%!state<todo>;
            @todo.push: {:done(False), :$todo};
            self.set-state: (|%!state, :@todo).Hash;
            say "did set-state: ", %!state;
        }
        <form onSubmit={{&add-todo}}>
            <TodoList todos={{ %!state<todo> }} /> <br />
            <Entry />
        </form>
    }
}
