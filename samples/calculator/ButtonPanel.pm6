use Component;
use Slang;

component ButtonPanel {
	has &.handle-click;
    method render {
        <div className="component-button-panel">
            <div>
              <Button name="AC"  clickHandler={{&.handle-click}} />
              <Button name="+/-" clickHandler={{&.handle-click}} />
              <Button name="%"   clickHandler={{&.handle-click}} />
              <Button name="÷"   clickHandler={{&.handle-click}} orange=1 />
            </div>
            <div>
              <Button name="7" clickHandler={{&.handle-click}} />
              <Button name="8" clickHandler={{&.handle-click}} />
              <Button name="9" clickHandler={{&.handle-click}} />
              <Button name="x" clickHandler={{&.handle-click}} orange=1 />
            </div>
            <div>
              <Button name="4" clickHandler={{&.handle-click}} />
              <Button name="5" clickHandler={{&.handle-click}} />
              <Button name="6" clickHandler={{&.handle-click}} />
              <Button name="-" clickHandler={{&.handle-click}} orange=1 />
            </div>
            <div>
              <Button name="1" clickHandler={{&.handle-click}} />
              <Button name="2" clickHandler={{&.handle-click}} />
              <Button name="3" clickHandler={{&.handle-click}} />
              <Button name="+" clickHandler={{&.handle-click}} orange=1 />
            </div>
            <div>
              <Button name="0" clickHandler={{&.handle-click}} wide=1 />
              <Button name="." clickHandler={{&.handle-click}} />
              <Button name="=" clickHandler={{&.handle-click}} orange=1 />
            </div>
        </div>
    }
}

