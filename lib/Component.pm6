role Component {
    has %.props;
    method render() {...}
}

class MetamodelX::ComponentHOW is Metamodel::ClassHOW {
    my %components;

    method new_type(|) {
        my \type = callsame();
		type.^add_role: Component;
		%components{type.^name} = type;
        type
    }

	method components { %components }
}

my package EXPORTHOW {
    package DECLARE {
		constant component = MetamodelX::ComponentHOW;
    }
}