use Element;
use JSON::Fast;
use Slang;
use JavaScript;
use Component;
unit class WSPlugin;

my Sub %subs;

role WSPluginComponent {...}
role WSPluginElement {
    method apply-component-plugin(Component $comp) {
        $comp but WSPluginComponent
    }
    method apply-element-plugin(\element) {
        element but WSPluginElement
    }
    multi method value(Block $_) {
        my $name = "{.name}-{$*PID.fmt: "%x"}-{now.fmt: "%x"}-{(++$).fmt: "%x"}";
        %subs{$name} = $_;
        qq|sendToProact("$name", event)|
    }
}

role WSPluginComponent {
    method apply-element-plugin(\element) {
        element but WSPluginElement
    }
    method after-set-state(Element $ele) {
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
                </html> but WSPluginElement)
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
        :host('localhost'), :port(2314), :$application
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
