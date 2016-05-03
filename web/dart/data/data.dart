part of coUwiki;

class Data {
	Completer<Data> load = new Completer();

	Map<String, List<GameObject>> dataset = new Map();

	Data() {
		cache = new Cache();

		try {
			_loadAll().then((_) => load.complete(this));
		} catch(e) {
			window.console.error("Could not load data: $e");
			new Future.delayed(new Duration(seconds: 5)).then((_) {
				hardReload();
			});
		}
	}

	Future _loadAll() async {
		await _loadStreets();
		await _loadItems();

		cache.updateDate();
	}

	Future _loadStreets() async {
		dataset["street"] = new List();
		dataset["hub"] = new List();

		String json;
		
		if (cache.dataCurrent("mapdata")) {
			json = cache.getData("mapdata");
		} else {
			json = await HttpRequest.getString("$SERVER_URL/getMapData?token=$RS_TOKEN");
			cache.setData("mapdata", json);
		}

		JSON.decode(json)["streets"].forEach((String streetName, Map<String, dynamic> streetData) {
			dataset["street"].add(new Street(
				streetData["tsid"],
				streetName,
				streetData["hub_id"].toString(),
				streetData["map_hidden"] ?? false,
				streetData["broken"] ?? false,
				streetData["mailbox"] ?? false,
				streetData["vendor"],
				streetData["shrine"]
			));
		});

		JSON.decode(json)["hubs"].forEach((String hubId, Map<String, dynamic> hubData) {
			dataset["hub"].add(new Hub(
				hubId,
				hubData["name"],
				hubData["music"],
				hubData["players_have_letters"] ?? false,
				hubData["disable_eather"] ?? false,
				hubData["snowy_weather"] ?? false,
				hubData["triple_jumping"] ?? true
			));
		});
	}

	Future _loadItems() async {
		dataset["item"] = new List();
		String json;

		if (cache.dataCurrent("items")) {
			json = cache.getData("items");
		} else {
			json = await HttpRequest.getString("$SERVER_URL/getItems");
			cache.setData("items", json);
		}

		JSON.decode(json).forEach((Map<String, dynamic> itemData) {
			dataset["item"].add(new Item(
				itemData["itemType"],
				itemData["name"],
				itemData["category"],
				itemData["iconUrl"] ?? "",
				itemData["spriteUrl"] ?? "",
				itemData["iconNum"] ?? 4,
				itemData["description"] ?? "",
				itemData["price"] ?? 0,
				itemData["stacksTo"] ?? 1,
				itemData["subSlots"] ?? 0,
				itemData["isContainer"] ?? false,
				itemData["consumeValues"] ?? new Map()
			));
		});
	}
}