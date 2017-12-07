use HTTP::Easy::PSGI;
use Element;

unit class Server;

has Element %!end-points;


method add-route($path, Element $elem) {
	%!end-points{$path} = $elem;
}

method start(:$host = "localhost", :$port = 3000) {
	my $app = sub (%env) {
		return do with %!end-points{%env<PATH_INFO>} {
			.note;
			[ 200, [ 'Content-Type' => 'text/html'  ], [ .render ] ];
		} else {
			[ 404, [ 'Content-Type' => 'text/plain' ], [ "not found" ]]
		}
	}

	my $http = HTTP::Easy::PSGI.new(:$port);
	$http.handle($app);
}
