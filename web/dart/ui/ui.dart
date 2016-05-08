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

	static void showLoadError() {
		context[r"$"].apply(["#load-error"]).callMethod(
			"modal", [new JsObject.jsify(
			{"show": "true", "backdrop": "static"})]
		);
		querySelector("#load-retry").onClick.listen((_) => hardReload());
	}

	Search search;

	UI() {
		// Set up search
		search = new Search();

		// Go to initially requested page
		_goToCurrentHash();

		// Handle URL updates
		window.onHashChange.listen((_) => _goToCurrentHash());

		// Set copyright date
		querySelector(".copyright-years").text = " - ${new DateTime.now().year}";

		// Hide the loading screen
		document.body.classes.remove("loading");
	}

	void _goToCurrentHash() {
		window.scrollTo(window.scrollX, 0);
		search.closeTypeahead();

		ObjectPath current = new ObjectPath.fromWindow();
		if (!current.isHome) {
			Page.display(current);
		} else {
			Page.display(HOME_LIST, Page.PAGE_CONTAINER.querySelector(".jumbotron") == null);
		}
	}
}