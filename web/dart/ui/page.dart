part of coUwiki;

class Page {
	/// Element that holds the pages
	static final DivElement PAGE_CONTAINER = querySelector("#page-container");

	/// One-time initialization
	static void setupPages() {
		void _navToHash() {
			if (window.location.hash.toLowerCase().startsWith("#list")) {
				List<String> parts = window.location.hash.split("/");
				String type = parts[1];
				String category = (parts.length > 2 ? parts[2] : null);
				Page.display(new ListPage.filter(type, (GameObject object) {
					return (category == null || object.category.toLowerCase() == category.toLowerCase());
				}).toPage());
			} else {
				Page.display(window.location.hash.substring(1), true);
			}
		}

		// Go to any requested page
		if (window.location.hash != "") {
			_navToHash();
		}

		// Handle URL updates
		window.onHashChange.listen((_) {
			_navToHash();
		});
	}

	/// Open a page
	static void display(dynamic toDisplay, [bool fromHash = false]) {
		Element element;

		if (toDisplay is Element) {
			element = toDisplay;
		} else {
			GameObject object = (toDisplay is GameObject ? toDisplay : GameObject.find(toDisplay));
			element = object.toPage();

			if (!fromHash) {
				window.location.hash = object.hashUrl;
			}
		}

		PAGE_CONTAINER
			..children.clear()
			..append(element);
	}
}