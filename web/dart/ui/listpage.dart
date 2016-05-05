part of coUwiki;

class ListPage extends Page {
	List<GameObject> objects;

	/// Lists objects of one type
	/// where passing the object to the test function returns true
	ListPage.filter(dynamic type, Function test) {
		try {
			objects = data.dataset[type.toString().toLowerCase()].where((GameObject object) {
				return test(object);
			}).toList();

			_sort();
		} catch(_) {
			Page.display(UI.HOME_LIST);
		}
	}

	/// Lists all objects provided
	ListPage.set(this.objects) {
		_sort();
	}

	DivElement toPage() {
		DivElement _makeListItem(String imgSrc, String text, Function onClick) =>
			new DivElement()
				..classes = ["col-xs-6", "col-sm-3", "col-lg-2", "listed-object"]
				..append(new ImageElement(src: imgSrc))
				..append(new SpanElement()..text = text)
				..onClick.listen((MouseEvent event) => onClick(event));

		DivElement parent = new DivElement()
			..classes = ["row", "object-list"];

		objects.forEach((GameObject object) {
			parent.append(_makeListItem(
				object.iconUrl, object.name,
				(_) => object.navigationHandler != null ? object.navigationHandler(object) : Page.display(object)
			));
		});

		return parent;
	}

	/// Sort by name
	void _sort() {
		objects.sort((GameObject a, GameObject b) => a.name.compareTo(b.name));
	}
}