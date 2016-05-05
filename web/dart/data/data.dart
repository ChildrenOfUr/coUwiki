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
		await _loadAchievements();
		await _loadEntities();
		await _loadItems();
		await _loadStreets();
		await _loadSkills();

		cache.updateDate();
	}

	Future _loadAchievements() async {
		dataset["achievement"] = new List();
		String json;

		if (cache.dataCurrent("achievements")) {
			json = cache.getData("achievements");
		} else {
			json = await HttpRequest.getString("$SERVER_URL/listAchievements?token=$RS_TOKEN");
			cache.setData("achievements", json);
		}

		JSON.decode(json).values.forEach((Map<String, dynamic> achvData) {
			dataset["achievement"].add(new Achievement(
				achvData["id"],
				achvData["name"],
				achvData["category"],
				achvData["imageUrl"],
				achvData["description"]
			));
		});
	}

	Future _loadEntities() async {
		dataset["entity"] = new List();
		String json;

		if (cache.dataCurrent("entities")) {
			json = cache.getData("entities");
		} else {
			json = await HttpRequest.getString("$SERVER_URL/entities/list?token=$RS_TOKEN");
			cache.setData("entities", json);
		}

		JSON.decode(json).forEach((Map<String, dynamic> entityData) {
			dataset["entity"].add(new Entity(
				entityData["id"],
				entityData["name"],
				entityData["category"],
				entityData["states"],
				entityData["currentState"],
				entityData["responses"],
				entityData["sellItems"]
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

	Future _loadSkills() async {
		dataset["skill"] = new List();
		String json;

		if (cache.dataCurrent("skills")) {
			json = cache.getData("skills");
		} else {
			json = await HttpRequest.getString("$SERVER_URL/skills/list?token=$RS_TOKEN");
			cache.setData("skills", json);
		}

		JSON.decode(json).forEach((Map<String, dynamic> skillData) {
			dataset["skill"].add(new Skill(
				skillData["id"],
				skillData["name"],
				skillData["category"],
				skillData["descriptions"],
				skillData["levels"],
				skillData["iconUrls"],
				skillData["giants"]
			));
		});
	}
}