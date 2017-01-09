part of coUwiki;

/**
 * Page with information about a single [GameObject].
 */
class Page {
	/// Element that holds the pages
	static final DivElement PAGE_CONTAINER = querySelector("#page-container");

	/// Open a page. Will append to the current display if clear is set to false.
	static void display(dynamic toDisplay, [bool clear = true]) {
		Element element;

		if (toDisplay is Element) {

			// Asked to display an Element, this is easy
			element = toDisplay;

		} else if (toDisplay is GameObject || toDisplay is Page) {

			// Asked to display a GameObject, run toPage() on it
			element = toDisplay.toPage();

		} else if (toDisplay is ObjectPath) {

			// Asked to display on ObjectPath
			if (toDisplay.isHome) {

				// If it's referring to the main page, display that
				element = UI.HOME_LIST;

			} else if (toDisplay.isList) {

				// If it's referring to a list, create the list and then run toPage() on it
				element = new ListPage.filter(toDisplay.typeRef, (GameObject object) =>
					toDisplay.listContains(object)).toPage();

			} else {

				// If it's referring to a GameObject, find it
				// and then go to the GameObject branch
				return display(GameObject.find(toDisplay.path));

			}

		} else if (toDisplay is String) {

			// If it's referring to a String, convert it to an ObjectPath
			// and then go to the ObjectPath branch.
			return display(new ObjectPath(toDisplay as String));

		} else {

			// Cannot display this type of object.
			// Considering how many types we CAN display,
			// this would be pretty much null.
			throw "Cannot display type ${toDisplay.runtimeType}";

		}

		Scrolling.save();

		setHash(toDisplay);

		if (clear) {
			PAGE_CONTAINER.children.clear();
		}

		PAGE_CONTAINER.append(element);

//		new Future.delayed(new Duration(milliseconds: 100)).then((_) => Scrolling.restore());

		Scrolling.restore();
	}
}