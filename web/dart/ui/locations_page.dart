part of coUwiki;

/**
 * Page that displays all the game [Street]s grouped by [Hub].
 *
 * Name    Image
 *         Street Street Street
 *         Street Street Street
 * ------------------------------------
 * (repeat)
*/
class LocationsPage extends Page {
	LocationsPage();

	DivElement toPage() {
		DivElement parent = new DivElement()
			..classes = ["row", "location-list"];

		Future _makeHub(Hub hub) async {
			// Name
			parent.append(new DivElement()
				..classes = ["col-xs-12", "col-sm-2"]
				..append(new AnchorElement(href: hub.path.toString())
					..text = hub.name));

			// Image
			parent.append(new DivElement()
				..classes = ["col-xs-12", "col-sm-10"]
				..append(new ImageElement(src: hub.iconUrl)
					..classes = ["img-thumbnail", "img-responsive"]));

			// Streets
			UListElement streetList = new UListElement()
				..classes = ["location-list-streets"];
			data.dataset[GameObjectType.Street].where((Street street) {
				return street.hubId == hub.id;
			}).toList().forEach((Street street) {
				streetList.append(new LIElement()
					..append(new AnchorElement(href: street.path.toString())
						..text = street.name));
			});
			parent.append(new DivElement()
				..classes = ["col-xs-12", "col-sm-10", "col-sm-offset-2"]
				..append(streetList));

			parent.append(new DivElement()
				..classes = ["col-xs-12"]
				..append(new HRElement()));
		}

		data.dataset[GameObjectType.Hub].forEach((Hub hub) {
			_makeHub(hub);
		});

		return parent;
	}
}