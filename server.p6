use lib ".";
use lib "lib";
use lib "samples/calculator";
use Server;
use Slang;

given Server.new {
    {
        use ComponentTest;
        .add-route: "/test",  <Parent />;
    }
    {
        use ComponentTest2;
        .add-route: "/test2", <UlList items={{["bla", "ble", "bli"]}} />;
    }
    {
        use App;
        .add-route: "/calculator", <App />;
    }
    .start
}

