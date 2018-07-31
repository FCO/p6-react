use React::Component;

component React::ThemeProvider {
    method render {
        @!children.head;
    }
}
