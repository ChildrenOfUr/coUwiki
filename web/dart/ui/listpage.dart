part of coUwiki;

class ListPage extends Page {
	List<GameObject> objects;

	/// Lists objects of one type
	/// where passing the object to the test function returns true
	ListPage.filter(dynamic type, Function test) {
		objects = data.dataset[type.toString().toLowerCase()].where((GameObject object) {
			return test(object);
		}).toList();
	}

	/// Lists all objects provided
	ListPage.set(this.objects);

	DivElement toPage() {
		DivElement parent = new DivElement()
			..classes = ["row", "object-list"];

		objects.forEach((GameObject object) {
			parent.append(
				new DivElement()
					..classes = ["col-sm-3", "listed-object"]
					..append(new ImageElement(src: object.iconUrl))
					..append(new SpanElement()..text = object.name)
					..onClick.first.then((_) => Page.display(object))
			);
		});

		return parent;
	}
}