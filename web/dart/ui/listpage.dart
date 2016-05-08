part of coUwiki;

/**
 * Page that lists multiple [GameObject]s
 */
class ListPage extends Page {
	/// List of objects to display on the page.
	List<GameObject> objects;

	/// Lists objects of one type
	/// where passing the object to the test function returns true
	ListPage.filter(GameObjectType type, Function test) {
		try {
			objects = data.dataset[type].where((GameObject object) {
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
		DivElement _makeListItem(dynamic img, String text, Function onClick) {
			DivElement listItem = new DivElement()
				..classes = ["col-xs-6", "col-sm-3", "col-lg-2", "listed-object"];

			if (img is String) {
				listItem.append(new ImageElement(src: img));
			} else if (img is Element) {
				listItem.append(img);
			}

			listItem
				..append(new SpanElement()..text = text)
				..onClick.listen((MouseEvent event) => onClick(event));
			return listItem;
		}

		DivElement parent = new DivElement()
			..classes = ["row", "object-list"];

		objects.forEach((GameObject object) {
			var image = (object is Entity && object.getState() != null)
				? object.getSpriteImage(fitTo: 80)
				: object.iconUrl;

			Function clickHandler = (_) {
				(object.navigationHandler != null)
					? object.navigationHandler(object)
					: Page.display(object);
			};

			parent.append(_makeListItem(image, object.name, clickHandler));
		});

		return parent;
	}

	/// Sort by name
	void _sort() {
		objects.sort((GameObject a, GameObject b) => a.name.compareTo(b.name));
	}
}