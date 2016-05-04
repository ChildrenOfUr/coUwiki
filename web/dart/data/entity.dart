part of coUwiki;

class Entity extends GameObject {
	List<Map<String, dynamic>> states;
	String currentState;
	Map<String, List<String>> responses;
	List<String> sellItems;

	Entity(
		String id,
		String name,
		String category,
		this.states,
		this.currentState,
		this.responses,
		this.sellItems
	) : super(Entity, id, name, category, null) {
		if (category == "Shrine") {
			iconUrl = "img/shrine.svg";
		} else if (name.contains("Street Spirit")) {
			iconUrl = "img/currant.svg";
		} else {
			try {
				HttpRequest.request("$ENTITY_URL/$name.png");
			} catch(_) {
				iconUrl = "img/entity.png";
			}
		}
	}

	Map<String, dynamic> getState([String stateName]) {
		if (stateName == null) {
			return getState(currentState);
		}

		for (Map<String, dynamic> state in states) {
			if (state["stateName"] == stateName) {
				return state;
			}
		}

		return null;
	}

	DivElement toPage() {
		DivElement parent = super.toPage();

		// Image
		parent.append(
				new DivElement()
				..classes = ["entity-image", "center-block", "item-header"]
				..style.backgroundImage = "url(${getState()["url"]})"
				..style.backgroundSize = "${getState()["sheetWidth"]}px ${getState()["sheetHeight"]}px"
				..style.width = "${getState()["frameWidth"]}px"
				..style.height = "${getState()["frameHeight"]}px"
			);

		parent.append(new HRElement());

		// Responses
		if (responses != null && responses.length > 0) {
			parent.append(new HeadingElement.h2()
				..text = "Responses");
			responses.forEach((String action, List<String> options) {
				parent.append(new HeadingElement.h3()
					..text = action);
				options.forEach((String text) {
					parent.append(new Element.tag("blockquote")
						..text = text);
				});
			});
		}

		// Spritesheets
		TableElement spritesheets = new TableElement()
			..classes = ["table"];
		Element thead = new Element.tag("thead");
		states.first.keys.forEach((String key) => thead.append(new TableCellElement()..text = key));
		spritesheets.append(thead);
		states.forEach((Map<String, dynamic> state) {
			TableRowElement row = new TableRowElement();
			state.values.forEach((dynamic value) {
				row.append(new TableCellElement()
					..append(
						!value.toString().startsWith("http")
							? (new SpanElement()..text = value.toString())
							: (new AnchorElement(href: value.toString())..text = "Link")
					)
				);
			});
			spritesheets.append(row);
		});
		parent
			..append(new HeadingElement.h2()..text = "Assets")
			..append(
				new DivElement()
					..classes = ["table-responsive"]
					..append(spritesheets)
			);

		return parent;
	}
}