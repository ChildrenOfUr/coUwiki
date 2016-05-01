part of coUwiki;

class GameObject {
	static GameObject find(String url) {
		String category = url.split("/")[0];
		String id = url.split("/")[1];
		return data.dataset[category].singleWhere((GameObject object) {
			return (object.id == id);
		});
	}

	String id;
	String name;
	String category;
	String iconUrl;

	GameObject(this.id, this.name, this.category, this.iconUrl);

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
}