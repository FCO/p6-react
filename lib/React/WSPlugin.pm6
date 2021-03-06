use React::Element;
use JSON::Fast;
use React::Slang;
use JavaScript;
use React::Component;
unit class React::WSPlugin;

my Sub %subs;

role WSPluginComponent {...}
role WSPluginElement {
    method apply-component-plugin(React::Component $comp) {
        $comp does WSPluginComponent
    }
    method apply-element-plugin(\element) {
        element does WSPluginElement
    }
    multi method value(Block $_) {
        my $name = "{.name}-{.WHERE.fmt: "%x"}-{$*PID.fmt: "%x"}-{now.fmt: "%x"}-{(++$).fmt: "%x"}";
        say $name;
        %subs{$name} = $_;
        qq|sendToProact("$name", event)|
    }
}

role WSPluginComponent {
    method apply-element-plugin(\element) {
        element does WSPluginElement
    }
    method after-set-state(React::Element $ele) {
        say "WSPluginComponent::after-set-state: {$ele}";
        my $html = $ele.render;
        say $html;
        emit $html
    }
}

method serve($elem) {
    use Cro::HTTP::Server;
    use Cro::HTTP::Router;
    use Cro::HTTP::Router::WebSocket;

    my $application = route {
        get -> {
            content 'text/html',
                (<html>
                    <head>
                        <JavaScript file="./ws.js" />
                    </head>
                    <body>
                        {{$elem}}
                    </body>
                </html> does WSPluginElement)
                .render
            ;
        }
        get -> "ws" {
            web-socket -> $incomming {
                supply {
                    whenever $incomming -> $msg {
                        my $msg-text = await $msg.body-text;
                        my %data = from-json $msg-text;
                        note "received: ", %data;
                        %subs{%data<func>}.(%data)
                    }
                }
            }
        }
    }

    # Create the HTTP service object
    my Cro::Service $service = Cro::HTTP::Server.new(
        :host('localhost'), :port(3000), :$application
    );

    # Run it
    $service.start;
    say "running...";

    # Cleanly shut down on Ctrl-C
    react whenever signal(SIGINT) {
        $service.stop;
        exit;
    }
}
