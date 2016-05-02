part of coUwiki;

class GameObject {
	static GameObject find(String url) {
		String type = url.split("/")[0];
		String id = url.split("/")[1];
		return data.dataset[type].singleWhere((GameObject object) {
			return (object.id == id);
		});
	}

	String id;
	String name;
	String category;
	String iconUrl;
	Type type;

	GameObject(this.type, this.id, this.name, this.category, this.iconUrl);

	DivElement toPage() {
		DivElement parent = new DivElement();

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
						..text = category
				)
		);

		return parent;
	}

	String get hashUrl {
		return "${type.toString().toLowerCase()}/$id";
	}
}