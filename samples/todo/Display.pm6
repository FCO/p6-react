use Component;
use TodoList;
use Entry;
use Slang;

component Display {
    method TWEAK() {
        %!state = :todo[${:!done, :todo<Test>}], :entry(""), |%!state
    }
    method render {
        sub add-todo(|c) {
            say "==> {c}";
            my $todo = %!state<entry>;
            %!state<entry> = "";
            %!state<todo>.push: {:!done, :$todo}
        }
        <form onSubmit={{&add-todo}}>
            <TodoList todos={{ %!state<todo> }} /> <br />
            <Entry data={{%!state<entry>}} />
        </form>
    }
}
