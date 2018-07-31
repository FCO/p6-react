use lib ".";
use lib "lib";
use lib "samples/calculator";
use React::Server;
use React::Slang;
use ComponentTest;
use ComponentTest2;
use App;

given React::Server.new {
    .add-route: "/test",        <Parent />;
    .add-route: "/test2",       <UlList items={{["bla", "ble", "bli"]}} />;
    .add-route: "/calculator",  <App />;
    .start
}

