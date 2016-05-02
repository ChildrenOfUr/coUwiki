part of coUwiki;

class Page {
	/// Element that holds the pages
	static final DivElement PAGE_CONTAINER = querySelector("#page-container");

	/// One-time initialization
	static void setupPages() {
		void _navToHash() {
			Page.display(window.location.hash.substring(1), true);
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
		GameObject object = (toDisplay is GameObject ? toDisplay : GameObject.find(toDisplay));

		if (!fromHash) {
			window.location.hash = object.hashUrl;
		}

		PAGE_CONTAINER
			..children.clear()
			..append(object.toPage());
	}
}