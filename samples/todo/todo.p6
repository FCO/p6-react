use lib "lib";
use lib "samples/todo";
use Component;
use Slang;
use WSPlugin;
use Display;


WSPlugin.serve: <Display list={{ ${:!done, :todo("the first one")} }}/>
