use Component;
use Slang;

component JavaScript {
    has $.file;
    method render {
        <script type="text/Javascript">
            {{
                $!file.IO.lines
            }}
        </script>
    }
}
