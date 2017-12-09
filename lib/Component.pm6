use ComponentStore;
role Component {
    has %.state;
    has @.children;
    has %.theme;
    method apply-plugins(@plugins) {
        self does $_ for @plugins;
        self
    }
    method render() {...}
    method set-state(%!state) {
        self.after-set-state(self.render-component)
    }
    #method after-set-state($elem) {
    #    note "after-set-state: {$elem.perl}"
    #}
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
