use React::ComponentStore;
role React::Component::Plugin {
    method after-set-state($) {...}
}
role React::Component {
    has %.state;
    has @.children;
    has %.theme;
    method render() {...}
    method set-state(%state) {
        %!state = %state;
        say %!state;
        my $element = self.render-component;
        dd self;
        self.?after-set-state($element)
    }
    method recursively-apply-plugins-to-element($element) {
        for |$element.?children.grep: *.defined -> \child {
            self.recursively-apply-plugins-to-element(child);
        }
        do if $element.defined {
            self.?apply-element-plugin($element) // $element
        } else {
            $element
        }
    }
    method render-component {
        my $obj = self.render;
        $obj = self.recursively-apply-plugins-to-element: $obj;
        $obj.theme = %!theme if $obj.^can: "theme";
        $obj
    }
}

class MetamodelX::ComponentHOW is Metamodel::ClassHOW {
    method new_type(|) {
        my \type = callsame;
        type.^add_role: React::Component;
        React::ComponentStore.components{type.^name} = type;
        type
    }
}

my package EXPORTHOW {
    package DECLARE {
        constant component = MetamodelX::ComponentHOW;
    }
}
