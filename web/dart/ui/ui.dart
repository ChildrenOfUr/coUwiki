part of coUwiki;

class UI {
	Search search;

	final DivElement HOME_LIST = new ListPage.set([
		new GameObject.fake("Regions", SIGNPOST2_IMG, (_) => Page.display("list/hub")),
		new GameObject.fake("Streets", SIGNPOST_IMG, (_) => Page.display("list/street")),
		new GameObject.fake("Items", BLENDER_IMG, (_) => Page.display("list/item")),
	]).toPage();

	UI() {
		// Set up search
		search = new Search();

		// Go to ininially requested page
		_goToCurrentHash();

		// Handle URL updates
		window.onHashChange.listen((_) => _goToCurrentHash());
	}

	void _goToCurrentHash() {
		if (hashExists()) {
			Page.display(new ObjectPath.fromWindow());
		} else {
			Page.display(HOME_LIST, Page.PAGE_CONTAINER.querySelector(".jumbotron") == null);
		}
	}
}