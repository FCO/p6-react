use lib "lib";
use lib "samples/calculator";
use App;
use React::Slang;
use React::WSPlugin;

React::WSPlugin.serve: <App />
