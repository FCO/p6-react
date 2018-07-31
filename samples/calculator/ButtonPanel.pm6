use React::Component;
use React::Styled;
use React::Slang;

component ButtonPanelStyle does React::Styled {
    method main is style {
        qq:to/END/;
        background-color: #858694;
        display: flex;
        flex-direction: row;
        flex-wrap: wrap;
        flex: 1 0 auto;
        END
    }
    method child-div is style("> div") {
        qq:to/END/;
        width: 100%;
        margin-bottom: 1px;
        flex: 1 0 auto;
        display: flex;
        END
    }
}

component ButtonPanel {
    has &.handle-click;
    method render {
        <ButtonPanelStyle>
            <div>
              <Button name="AC"  clickHandler={{&.handle-click}} />
              <Button name="+/-" clickHandler={{&.handle-click}} />
              <Button name="%"   clickHandler={{&.handle-click}} />
              <Button name="/"   clickHandler={{&.handle-click}} orange />
            </div>
            <div>
              <Button name="7" clickHandler={{&.handle-click}} />
              <Button name="8" clickHandler={{&.handle-click}} />
              <Button name="9" clickHandler={{&.handle-click}} />
              <Button name="x" clickHandler={{&.handle-click}} orange />
            </div>
            <div>
              <Button name="4" clickHandler={{&.handle-click}} />
              <Button name="5" clickHandler={{&.handle-click}} />
              <Button name="6" clickHandler={{&.handle-click}} />
              <Button name="-" clickHandler={{&.handle-click}} orange />
            </div>
            <div>
              <Button name="1" clickHandler={{&.handle-click}} />
              <Button name="2" clickHandler={{&.handle-click}} />
              <Button name="3" clickHandler={{&.handle-click}} />
              <Button name="+" clickHandler={{&.handle-click}} orange />
            </div>
            <div>
              <Button name="0" clickHandler={{&.handle-click}} wide />
              <Button name="." clickHandler={{&.handle-click}} />
              <Button name="=" clickHandler={{&.handle-click}} orange />
            </div>
        </ButtonPanelStyle>
    }
}

