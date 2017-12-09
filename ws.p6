use lib "lib";
use Component;
use Slang;
use JavaScript;
use WSPlugin;

component Number {
	has $.num;
	method render {
		<div>{{$.num}}</div>
	}
}

component Counter {
	method render {
		my sub on-click($data) {
			self.set-state: {num => ($.state<num> // 0) + 1}
		}
		<div>
			Counter: <Number num={{$.state<num>}} />
			<button onClick={{&on-click}}>increment</button>
		</div>
	}
}

WSPlugin.serve: <Counter />
