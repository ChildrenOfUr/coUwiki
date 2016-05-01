part of coUwiki;

class Data {
	Completer<Data> load = new Completer();

	Map<String, List<GameObject>> dataset = new Map();

	Data() {
		try {
			_loadStreets().then((_) => load.complete(this));
		} catch(e) {
			window.console.error("Could not load data: $e");
			new Future.delayed(new Duration(seconds: 5)).then((_) {
				hardReload();
			});
		}
	}

	Future _loadStreets() async {
		dataset["streets"] = new List();
		dataset["regions"] = new List();
		String json = await HttpRequest.getString(
			"http://server.childrenofur.com:8181/getMapData?token=$RS_TOKEN"
		);

		Map<String, Map<String, dynamic>> tempStreets = JSON.decode(json)["streets"];
		tempStreets.forEach((String streetName, Map<String, dynamic> streetData) {
			dataset["streets"].add(new Street(
				streetData["tsid"],
				streetName,
				streetData["hub_id"],
				streetData["hidden"] ?? false,
				streetData["broken"] ?? false,
				streetData["mailbox"] ?? false,
				streetData["vendor"],
				streetData["shrine"]
			));
		});

		Map<String, Map<String, dynamic>> tempHubs = JSON.decode(json)["hubs"];
		tempHubs.forEach((String hubId, Map<String, dynamic> hubData) {
			dataset["regions"].add(new Hub(
				hubId,
				hubData["name"],
				hubData["music"],
				hubData["playersHaveLetters"] ?? false,
				hubData["disableWeather"] ?? false,
				hubData["snowyWeather"] ?? false,
				hubData["tripleJumping"] ?? true
			));
		});
	}
}