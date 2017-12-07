use Slang;
use Server;
use App;

given Server.new {
   .add-route: "/calculator", <App />;
   .start
}
