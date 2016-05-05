part of coUwiki;

class ObjectPath {
	String path;

	String get hashlessPath {
		if (path.startsWith("#")) {
			return path.replaceFirst("#", "");
		} else {
			return path;
		}
	}

	String get hashPath => "#" + hashlessPath;

	ObjectPath(this.path);

	ObjectPath.fromWindow() : this.path = window.location.hash;

	bool get isList => hashlessPath.toLowerCase().startsWith("list");

	List<String> get parts => hashlessPath.split("/");

	String get type {
		if (isList) {
			return parts[1];
		} else {
			return parts[0];
		}
	}

	String get id {
		if (isList) {
			return null;
		} else {
			return parts[1];
		}
	}

	String get category {
		if (!isList) {
			return null;
		} else if (parts.length > 2) {
			return parts[2];
		} else {
			return null;
		}
	}

	bool listContains(GameObject object) {
		if (!isList) {
			throw "This object path is not a list";
		} else {
			bool typeMatch = eqCi(this.type, object.type) || this.type == null;
			bool categoryMatch = eqCi(this.category, object.category) || this.category == null;
			return typeMatch && categoryMatch;
		}
	}

	@override
	String toString() => hashPath;

	@override
	int get hashCode => hashPath.hashCode;

	@override
	operator ==(ObjectPath other) => eqCi(this, other);
}