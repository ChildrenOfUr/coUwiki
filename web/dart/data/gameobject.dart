part of coUwiki;

class GameObject {
	static GameObject find(String url) {
		ObjectPath path = new ObjectPath(url);
		try {
			return data.dataset[path.type].singleWhere((GameObject object) {
				return (object.id == path.id);
			});
		} catch(_) {
			return null;
		}
	}

	String id;
	String name;
	String category;
	String iconUrl;
	GameObjectType _type;
	Function navigationHandler;

	GameObject(GameObjectType type, this.id, this.name, this.category, this.iconUrl) : _type = type;

	GameObject.fake(this.name, this.iconUrl, this.navigationHandler) : _type = GameObjectType.GameObject;

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
							new AnchorElement(href: "#list/${type.toLowerCase()}")
								..text = type.toString()
						)
				)
		);

		if (category != null) {
			parent.querySelector(".breadcrumb").append(
				new LIElement()
					..append(
						new AnchorElement(href: "#list/${type.toLowerCase()}/${category.toLowerCase()}")
							..text = category
					)
			);
		}

		return parent;
	}

	DivElement makeAlert(String type, String message) {
		return new DivElement()
			..classes = ["alert", "alert-$type"]
			..text = message;
	}

	ObjectPath get path => new ObjectPath("${type.toString().toLowerCase()}/$id");

	String get type => _type.toString().split(".")[1];

	@override
	String toString() => "GameObject/$type/$id";
}