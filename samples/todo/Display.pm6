use Component;
use TodoList;
use Entry;
use Slang;

component Display {
    method new(*%pars) {
        ::?CLASS.bless: :state{:todo[]}, |%pars
    }
    method render {
        my sub add-todo(%data) {
            my $todo = %data<fields><new-todo>;
            my @todo = |%.state<todo>.grep: *.defined;
            @todo.push: {:done(False), :$todo};
            my %new-state = |%.state, :@todo;
            self.set-state: %new-state;
        }
        <form onSubmit={{&add-todo}}>
            <TodoList todos={{ %.state<todo> }} /> <br />
            <Entry />
        </form>
    }
}
