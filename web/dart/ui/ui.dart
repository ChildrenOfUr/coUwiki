part of coUwiki;

class UI {
	Search search;

	UI() {
		search = new Search();
		Page.setupPages();

		// Display initial category list
		Page.PAGE_CONTAINER.append(new ListPage.filter(Item, ((_) => new Random().nextBool())).toPage());
	}
}