use lib "lib";
use Component;
use Slang;
use WSPlugin;

component Number {
    has $.num;
    method render {
        <div>{{$.num}}</div>
    }
}

component Counter {
    method render {
        my sub on-click(|) {
            say self;
            self.set-state: {num => ($.state<num> // 0) + 1}
        }
        <div>
            Counter: <Number num={{$.state<num>}} />
            <button onClick={{&on-click}}>increment</button>
        </div>
    }
}

WSPlugin.serve: <Counter />
