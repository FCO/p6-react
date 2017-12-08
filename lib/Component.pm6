use ComponentStore;
role Component {
    has %.state;
    has @.children;
    has %.theme;
    method render() {...}
    method setState(%!state) {say "rerender"}
    method render-component {
        my \elem = self.render;
        elem.theme = %!theme;
        elem
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
