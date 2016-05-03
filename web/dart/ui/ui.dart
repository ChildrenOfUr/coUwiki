part of coUwiki;

class UI {
	Search search;

	final DivElement HOME_LIST = new ListPage.set([
		new GameObject.fake("Regions", SIGNPOST_IMG, (_) => Page.display("list/hub")),
		new GameObject.fake("Streets", SIGNPOST_IMG, (_) => Page.display("list/street")),
		new GameObject.fake("Items", BLENDER_IMG, (_) => Page.display("list/item")),
	]).toPage();

	UI() {
		search = new Search();
		Page.setupPages();

		if (new ObjectPath.fromWindow().hashlessPath == "") {
			Page.display(HOME_LIST, false);
		}

		document.body.onKeyUp.listen((KeyboardEvent event) {
			if (event.keyCode == 27) {
				// Escape key
				Page.display(HOME_LIST);
			}
		});
	}
}