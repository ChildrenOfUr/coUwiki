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

/// GameObjectType to String
String typeString(GameObjectType type) {
	return type.toString().split(".")[1];
}

/// String to GameObjectType
GameObjectType stringType(String type) {
	try {
		return GameObjectType.values.singleWhere((GameObjectType t) {
			return (typeString(t).toLowerCase() == type);
		});
	} catch(_) {
		return null;
	}
}

/// Request a resource through CoU
String proxyImage(String type, String url) {
	if (type == null || url == null) {
		return null;
	}

	if (url.contains('childrenofur')) {
		return url;
	}

	return '//childrenofur.com/assets/$type/?url=$url';
}