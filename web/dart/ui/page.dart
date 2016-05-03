part of coUwiki;

class Page {
	/// Element that holds the pages
	static final DivElement PAGE_CONTAINER = querySelector("#page-container");

	/// One-time initialization
	static void setupPages() {
		void _goToCurrentHash() {
			display(new ObjectPath.fromWindow());
		}

		// Go to ininially requested page
		if (hashExists()) {
			_goToCurrentHash();
		}

		// Handle URL updates
		window.onHashChange.listen((_) {
			if (hashExists() && !hashLock) {
				_goToCurrentHash();
			}

			hashLock = false;
		});
	}

	/// Open a page
	static void display(dynamic toDisplay, [bool clear = true]) {
		Element element;

		if (toDisplay is Element) {
			element = toDisplay;
		} else if (toDisplay is GameObject) {
			element = toDisplay.toPage();
		} else if (toDisplay is ObjectPath) {
			if (toDisplay.isList) {
				element = new ListPage.filter(toDisplay.type, (GameObject object) =>
					toDisplay.listContains(object)).toPage();
			} else {
				return display(GameObject.find(toDisplay.path));
			}
		} else if (toDisplay is String) {
			return display(new ObjectPath(toDisplay as String));
		} else {
			throw "Cannot display type ${display.runtimeType}";
		}

		setHash(toDisplay);

		if (clear) {
			PAGE_CONTAINER.children.clear();
		}

		PAGE_CONTAINER.append(element);
	}
}