part of coUwiki;

class GameObject {
	/// Find by any string path reference
	static GameObject find(dynamic url) {
		if (url is! ObjectPath && url is! String) {
			throw "Can only find GameObject by String or ObjectPath, not ${url.runtimeType}";
		}

		ObjectPath path = (url is ObjectPath ? url : new ObjectPath(url));
		try {
			return data.dataset[path.typeRef].singleWhere((GameObject object) {
				return (object.id == path.id);
			});
		} catch(_) {
			return null;
		}
	}

	/// Unique id
	String id;

	/// Displayed name
	String name;

	/// Sorting category (not type)
	String category;

	/// Primary icon image URL
	String iconUrl;

	/// Type (used for sorting, searching, listing, etc.)
	GameObjectType _type;

	/// Only used for fake objects.
	/// This runs when it is clicked and will be passed the MouseEvent.
	Function navigationHandler;

	/// Create a normal GameObject
	GameObject(GameObjectType type, this.id, this.name, this.category, this.iconUrl) : _type = type;

	/**
	 * Fake GameObjects are used for the initial homepage listing.
	 * They allow ListPage to be used to list anything.
	 */
	GameObject.fake(this.name, this.iconUrl, this.navigationHandler) : _type = GameObjectType.GameObject;

	/// Get the HTML element to display to the user when requested
	DivElement toPage() {
		DivElement parent = new DivElement()
			..classes.add("gameobject-${type.toLowerCase()}");

		// Title
		parent.append(
			new DivElement()
				..classes.add("page-header")
				..append(
					new HeadingElement.h1()
						..text = name
				)
		);

		// Category
		parent.append(
			new OListElement()
				..classes.add("breadcrumb")
				..append(
					new LIElement()
						..append(
							new AnchorElement(href: "#/list/${type.toLowerCase()}")
								..text = type.toString()
						)
				)
		);

		if (category != null) {
			parent.querySelector(".breadcrumb").append(
				new LIElement()
					..append(
						new AnchorElement(href: "#/list/${type.toLowerCase()}/${category.toLowerCase()}")
							..text = category
					)
			);
		}

		return parent;
	}

	/// Create a Bootstrap alert box with the specified color and text.
	/// Used for listing features of the object in toPage().
	DivElement makeAlert(String type, String message) {
		return new DivElement()
			..classes = ["alert", "alert-$type"]
			..text = message;
	}

	/// Get a path that could represent this object
	ObjectPath get path => new ObjectPath("${type.toLowerCase()}/$id");

	/// A string representing the GameObjectType
	String get type => typeString(_type);

	@override
	String toString() => "GameObject/$type/$id";
}