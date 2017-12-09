use Element;
use JSON::Fast;
use Slang;
unit class WSPlugin;

my Sub %subs;

my role WSPluginElement {
    multi method value(Sub $_) {
        my $name = "{.name}-{$*PID.fmt: "%x"}-{now.fmt: "%x"}-{(++$).fmt: "%x"}";
        %subs{$name} = $_;
        qq|sendToProact("$name", event)|
    }
}

my role WSPluginComponent {
    method after-set-state(Element $ele) {
        say "role: ", $ele;
        emit $ele.render
    }
}

method serve($elem) {
    use Cro::HTTP::Server;
    use Cro::HTTP::Router;
    use Cro::HTTP::Router::WebSocket;

    my $root = $elem.clone;
    $root.apply-plugins: WSPluginElement;
    $root.add-component-plugin(WSPluginComponent);

    $elem.apply-plugins: WSPluginElement;
    my $application = route {
        get -> {
            content 'text/html',
                <html>
                    <head>
                        <JavaScript file="./ws.js" />
                    </head>
                    <body>
                        {{$root}}
                    </body>
                </html>
                .render
            ;
        }
        get -> "ws" {
            web-socket -> $incomming {
                supply {
                    whenever $incomming -> $msg {
                        my $msg-text = await $msg.body-text;
                        my %data = from-json $msg-text;
                        %subs{%data<func>}.(%data<event>)
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
