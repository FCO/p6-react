use React::Slang;
use React::Server;
use App;

given React::Server.new {
   .add-route: "/calculator", <App />;
   .start
}
