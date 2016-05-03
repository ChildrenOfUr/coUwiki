part of coUwiki;

/// Capitalize the first letter of a string
String ucfirst(String string) {
	return string.substring(0, 1).toUpperCase() + string.substring(1);
}

/// Clear cache and reload
void hardReload() {
	cache.clear();
	context["location"].callMethod("reload", [true]);
}

/// s if plural, empty string if not
String plural(num amount) {
	if (amount == 1) {
		return "";
	} else {
		return "s";
	}
}

/// String equals, case insensitive
bool eqCi(dynamic a, dynamic b) {
	return a.toString().toLowerCase() == b.toString().toLowerCase();
}

/// Update the URL
void setHash([dynamic hash]) {
	String hashString;

	if (hash == null) {
		hashString = "";
	} else if (hash is String) {
		hashString = hash;
	} else if (hash is GameObject) {
		hashString = hash.path.toString();
	} else if (hash is ObjectPath) {
		hashString = hash.toString();
	} else {
		hashString = "";
	}

	window.location.hash = hashString;
}