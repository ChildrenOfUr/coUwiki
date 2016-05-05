part of coUwiki;

class UI {
	static final DivElement HOME_LIST = new ListPage.set([
		new GameObject.fake("Achievements", ACHV_IMG, (_) => Page.display("list/achievement")),
		new GameObject.fake("Entities", ENTITY_IMG, (_) => Page.display("list/entity")),
		new GameObject.fake("Items", ITEM_IMG, (_) => Page.display("list/item")),
		new GameObject.fake("Regions", LOCATIONS_IMG, (_) => Page.display("list/hub")),
		new GameObject.fake("Skills", SKILLS_IMG, (_) => Page.display("list/skill")),
		new GameObject.fake("Streets", STREETS_IMG, (_) => Page.display("list/street"))
	]).toPage();

	Search search;

	UI() {
		// Set up search
		search = new Search();

		// Go to ininially requested page
		_goToCurrentHash();

		// Handle URL updates
		window.onHashChange.listen((_) => _goToCurrentHash());
	}

	void _goToCurrentHash() {
		window.scrollTo(window.scrollX, 0);
		search.closeTypeahead();

		if (hashExists()) {
			Page.display(new ObjectPath.fromWindow());
		} else {
			Page.display(HOME_LIST, Page.PAGE_CONTAINER.querySelector(".jumbotron") == null);
		}
	}
}