part of coUwiki;

/**
 * An easier way than String to store hash URLs.
 * Allows easy access to parts of the URL, as well as comparison.
 */
class ObjectPath {
	/// The base path (not standardized!)
	String path;

	/// Create from an existing string
	ObjectPath(this.path);

	/// Create from the current path being displayed
	ObjectPath.fromWindow() : this.path = window.location.hash;

	/// Returns the path without any preceding symbols
	String get hashlessPath {
		if (path.startsWith("#/")) {
			return path.replaceFirst("#/", "");
		} else if (path.startsWith("#")) {
			return path.replaceFirst("#", "");
		} else {
			return path;
		}
	}

	/// Returns the path with a preceding '#/'
	String get hashPath => "#/" + hashlessPath;

	/// Checks if the path refers to a list of objects
	bool get isList => hashlessPath.toLowerCase().startsWith("list");

	/// Checks if the path refers to nothing (homepage listing)
	bool get isHome => hashlessPath.length == 0;

	/// Get all the parts of the path
	List<String> get parts => hashlessPath.split("/");

	/// The type of [GameObject] referred to
	String get type {
		if (isList) {
			return parts[1];
		} else {
			return parts[0];
		}
	}

	/// [GameObjectType] of the [GameObject]
	GameObjectType get typeRef => stringType(type);

	/// The id of the GameObject referred to.
	/// Not present in lists.
	String get id {
		if (isList) {
			return null;
		} else {
			return parts[1];
		}
	}

	/// The category of the GameObject referred to.
	/// May not always be present for lists.
	String get category {
		if (!isList) {
			return null;
		} else if (parts.length > 2) {
			return parts[2];
		} else {
			return null;
		}
	}

	/// Whether this path refers to a list of objects containing an object.
	/// Will not work if the path refers to a single object.
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