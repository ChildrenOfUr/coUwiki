part of coUwiki;

class Street extends GameObject {
	String hubId;
	List<GameObject> contents;
	bool hidden;
	bool broken;
	bool hasMailbox;
	String vendor;
	String shrine;
	List<Map<String, dynamic>> entityCache;

	Street(
		String id,
		String name,
		this.hubId,
		this.hidden,
		this.broken,
		this.hasMailbox,
		this.vendor,
		this.shrine
	) : super(GameObjectType.Street, id, name, null, STREETS_IMG);

	DivElement toPage() {
		DivElement parent = super.toPage();
		parent.querySelector(".breadcrumb").append(
			new LIElement()
				..append(
					new AnchorElement(href: hub.path.toString())
						..text = hub.name
				)
			);

		parent.append(new DivElement()..id = "street-image");
		new StreetImageDisplay(this.id).ready.future.then((StreetImageDisplay image) {
			parent.querySelector("#street-image").replaceWith(image.parent);
			image.collapse();
		});

		parent.append(new HRElement());

		if (hasMailbox) {
			parent.append(makeAlert("info", "Mailbox"));
		}

		if (vendor != null) {
			parent.append(makeAlert("success", "$vendor Vendor"));
		}

		if (shrine != null) {
			parent.append(makeAlert("success", "Shrine to $shrine"));
		}

		if (hidden) {
			parent.append(makeAlert("warning", "This street is secret. You can't teleport to it."));
		}

		if (broken) {
			parent.append(makeAlert("danger", "This street is broken. Ask your pet rock for a free escape."));
		}

		DivElement entityParent = new DivElement();
		parent.append(entityParent);

		countEntities().then((Map<String, int> counts) {
			if (counts.length > 0) {
				UListElement entityList = new UListElement();
				entityParent
					..append(new HRElement())
					..append(new HeadingElement.h2()..text = "Featuring")
					..append(entityList);

				counts.forEach((String type, int number) {
					Entity entityBase = Entity.find(type);
					LIElement listItem = new LIElement();
					if (entityBase != null) {
						listItem.append(
							new AnchorElement(href: entityBase.path.toString())
								..text = entityBase.name
						);
					} else {
						listItem.appendText(type);
					}
					listItem.appendText(number > 1 ? " x $number" : "");
					entityList.append(listItem);
				});
			}
		});

		return parent;
	}

	String get tsidG {
		if (id.startsWith("L")) {
			return id.replaceFirst("L", "G");
		} else {
			return id;
		}
	}

	String get tsidL => tsidG.replaceFirst("G", "L");

	Hub get hub => Hub.find(hubId);

	Future<Map<String, int>> countEntities([bool excludeUnknown = false]) async {
		List<Map<String, dynamic>> entities = await getEntities();
		Map<String, int> counts = new Map();

		entities.forEach((Map<String, dynamic> entity) {
			String type = entity["type"];
			if (!excludeUnknown || (excludeUnknown && Entity.find(type) != null)) {
				counts[type] = (counts[type] != null ? counts[type] + 1 : 1);
			}
		});

		return counts;
	}

	Future<List<Map<String, dynamic>>> getEntities() async {
		if (entityCache != null) {
			return entityCache;
		} else {
			List<Map<String, dynamic>> result = new List();

			String json;
			try {
				json = await HttpRequest.getString("$SERVER_URL/getEntities?tsid=$tsidG&token=$RS_TOKEN");
			} catch(_) {
				return result;
			}
			result = JSON.decode(json)["entities"];

			entityCache = result;
			return result;
		}
	}
}