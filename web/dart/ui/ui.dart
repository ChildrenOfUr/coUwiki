part of coUwiki;

/**
 * Handles general interface things.
 */
class UI {
	/// List of fake [GameObject]s to display on load
	static final DivElement HOME_LIST = new ListPage.set([
		new GameObject.fake("Achievements", ImgRef.ACHV, (_) => Page.display("list/achievement")),
		new GameObject.fake("Entities", ImgRef.ENTITY, (_) => Page.display("list/entity")),
		new GameObject.fake("Items", ImgRef.ITEM, (_) => Page.display("list/item")),
		new GameObject.fake("Locations", ImgRef.LOCATIONS, (_) => Page.display(new LocationsPage())),
		new GameObject.fake("Regions", ImgRef.BLANK_MAP, (_) => Page.display("list/hub")),
		new GameObject.fake("Skills", ImgRef.SKILLS, (_) => Page.display("list/skill")),
		new GameObject.fake("Streets", ImgRef.STREETS, (_) => Page.display("list/street")),
	]).toPage();

	/// Open a message explaining why it won't load (server down?)
	static void showLoadError() {
		context[r"$"].apply(["#load-error"]).callMethod(
			"modal", [new JsObject.jsify(
			{"show": "true", "backdrop": "static"})]
		);
		querySelector("#load-retry").onClick.listen((_) => hardReload());
	}

	/// Search manager
	Search search;

	/// Initialize listeners
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

	/// Display what the current URL requests
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