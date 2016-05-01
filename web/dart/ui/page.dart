part of coUwiki;

class Page {
	/// Element that holds the pages
	static final DivElement PAGE_CONTAINER = querySelector("#page-container");

	/// One-time initialization
	static void setupPages() {
		// Go to any requested page
		if (window.location.hash != "") {
			Page.display(window.location.hash.substring(1));
		}

		// Handle page requests
		new Service([ACTION_OPENPAGE], (String id) {
			window.location.hash = id;
			Page.display(id);
		});
	}

	/// Open a page
	static void display(dynamic toDisplay) {
		GameObject object = (toDisplay is GameObject ? toDisplay : GameObject.find(toDisplay));

		PAGE_CONTAINER
			..children.clear()
			..append(object.toPage())
			..hidden = false;
	}
}