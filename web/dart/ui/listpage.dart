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
		DivElement makeListItem(String imgSrc, String text, Function onClick) =>
			new DivElement()
				..classes = ["col-xs-6", "col-sm-3", "col-lg-2", "listed-object"]
				..append(new ImageElement(src: imgSrc))
				..append(new SpanElement()..text = text)
				..onClick.listen((MouseEvent event) => onClick(event));

		DivElement parent = new DivElement()
			..classes = ["row", "object-list"];

		objects.forEach((GameObject object) {
			parent.append(makeListItem(
				object.iconUrl, object.name,
				(MouseEvent event) {
					if (object.navigationHandler != null) {
						object.navigationHandler(event);
					} else {
						Page.display(object);
					}
				}
			));
		});

		return parent;
	}
}