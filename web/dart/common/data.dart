part of coUwiki;

/**
 * Manages the downloading, parsing, and storing of JSON data from the server.
 */
class Data {
	/// Allow waiting for all data to download
	Completer<Data> load = new Completer();

	/// Stored data after downloading, categorized by type
	Map<GameObjectType, List<GameObject>> dataset = new Map();

	/// Stored world map edges (for GPS)
	List<Map<String, dynamic>> worldEdges = new List();

	/// Start caching and downloading data
	Data() {
		cache = new Cache();

		_loadAll().then((_) => load.complete(this));
	}

	/// Download and parse all data
	Future _loadAll() async {
		try {
			await _loadAchievements();
			await _loadEntities();
			await _loadItems();
			await _loadStreets();
			await _loadSkills();
			await _loadWorldEdges();
			cache.updateDate();
		} catch(e) {
			UI.showLoadError();
			throw e;
		}
	}

	/// Download and parse achivement data from the server's /listAchievements endpoint
	Future _loadAchievements() async {
		dataset[GameObjectType.Achievement] = new List();
		String json;

		if (cache.dataCurrent("achievements")) {
			json = cache.getData("achievements");
		} else {
			json = await HttpRequest.getString("${ServerUrl.SERVER}/listAchievements?token=$RS_TOKEN");
			cache.setData("achievements", json);
		}

		JSON.decode(json).values.forEach((Map<String, dynamic> achvData) {
			dataset[GameObjectType.Achievement].add(new Achievement(
				achvData["id"],
				achvData["name"],
				achvData["category"],
				achvData["imageUrl"],
				achvData["description"]
			));
		});
	}

	/// Download and parse entity data from the server's /entities/list endpoint
	Future _loadEntities() async {
		dataset[GameObjectType.Entity] = new List();
		String json;

		if (cache.dataCurrent("entities")) {
			json = cache.getData("entities");
		} else {
			json = await HttpRequest.getString("${ServerUrl.SERVER}/entities/list?token=$RS_TOKEN");
			cache.setData("entities", json);
		}

		JSON.decode(json).forEach((Map<String, dynamic> entityData) {
			dataset[GameObjectType.Entity].add(new Entity(
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

	/// Download and parse item data from the server's /getItems endpoint
	Future _loadItems() async {
		dataset[GameObjectType.Item] = new List();
		String json;

		if (cache.dataCurrent("items")) {
			json = cache.getData("items");
		} else {
			json = await HttpRequest.getString("${ServerUrl.SERVER}/getItems");
			cache.setData("items", json);
		}

		JSON.decode(json).forEach((Map<String, dynamic> itemData) {
			dataset[GameObjectType.Item].add(new Item(
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

	/// Download and parse street and hub data from the server's /getMapData endpoint
	Future _loadStreets() async {
		dataset[GameObjectType.Street] = new List();
		dataset[GameObjectType.Hub] = new List();

		String json;

		if (cache.dataCurrent("mapdata")) {
			json = cache.getData("mapdata");
		} else {
			json = await HttpRequest.getString("${ServerUrl.SERVER}/getMapData?token=$RS_TOKEN");
			cache.setData("mapdata", json);
		}

		JSON.decode(json)["streets"].forEach((String streetName, Map<String, dynamic> streetData) {
			dataset[GameObjectType.Street].add(new Street(
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
			dataset[GameObjectType.Hub].add(new Hub(
				hubId,
				hubData["name"],
				hubData["music"],
				hubData["players_have_letters"] ?? false,
				hubData["disable_eather"] ?? false,
				hubData["snowy_weather"] ?? false,
				hubData["physics"] ?? "normal"
			));
		});
	}

	/// Download and parse skill data from the server's /skills/list endpoint
	Future _loadSkills() async {
		dataset[GameObjectType.Skill] = new List();
		String json;

		if (cache.dataCurrent("skills")) {
			json = cache.getData("skills");
		} else {
			json = await HttpRequest.getString("${ServerUrl.SERVER}/skills/list?token=$RS_TOKEN");
			cache.setData("skills", json);
		}

		JSON.decode(json).forEach((Map<String, dynamic> skillData) {
			dataset[GameObjectType.Skill].add(new Skill(
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

	/// Download and parse the world graph from the json folder
	Future _loadWorldEdges() async {
		String json = await HttpRequest.getString("json/worldGraph.json");
		List<Map<String, dynamic>> edges = JSON.decode(json)["edges"];
		worldEdges = edges;
	}
}