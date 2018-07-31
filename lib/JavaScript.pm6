use React::Component;
use React::Slang;

component JavaScript {
    has $.file;
    method render {
        <script type="text/JavaScript">
            {{
                $!file.IO.lines
            }}
        </script>
    }
}
