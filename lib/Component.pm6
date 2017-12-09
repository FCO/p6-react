use ComponentStore;
role Component {
    has %.state;
    has @.children;
    has %.theme;
    has @.element-plugis handles add-element-plugin => "push";
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
        do given self.render {
            .theme = %!theme;
            .apply-plugins(@!element-plugis);
            $_
        }
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
