use HTTP::Easy::PSGI;
use React::Element;

unit class React::Server;

has React::Element %!end-points;


method add-route($path, Element $elem) {
    %!end-points{$path} = $elem;
}

method start(:$host = "localhost", :$port = 3000) {
    my $app = sub (%env) {
        return do with %!end-points{%env<PATH_INFO>} {
            [ 200, [ 'Content-Type' => 'text/html'  ], [ .render ] ];
        } else {
            [ 404, [ 'Content-Type' => 'text/plain' ], [ "not found" ]]
        }
    }

    say "Endpoints:";
    .indent(5).say for %!end-points.keys.sort;
    say "";

    my $http = HTTP::Easy::PSGI.new(:$port);
    $http.handle($app);
}
