use ComponentStore;
role Component::Plugin {
    method after-set-state($) {...}
}
role Component {
    has %.state;
    has @.children;
    has %.theme;
    method render() {...}
    method set-state(%!state) {
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
        $obj.theme = %!theme;
        $obj
    }
}

class MetamodelX::ComponentHOW is Metamodel::ClassHOW {
    method new_type(|) {
        my \type = callsame;
        type.^add_role: Component;
        ComponentStore.components{type.^name} = type;
        type
    }
}

my package EXPORTHOW {
    package DECLARE {
        constant component = MetamodelX::ComponentHOW;
    }
}
