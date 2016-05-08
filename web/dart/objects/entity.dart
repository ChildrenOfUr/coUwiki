part of coUwiki;

class Entity extends GameObject {
	/// Spritesheets
	List<Map<String, dynamic>> states;

	/// State the server set it to when creating
	String currentState;

	/// Phrases said by the entity, sorted by trigger action
	Map<String, List<String>> responses;

	/// Items the entity sells. Only relevant to vendors.
	List<String> sellItems;

	Entity(String id,
		String name,
		String category,
		this.states,
		this.currentState,
		this.responses,
		this.sellItems) : super(GameObjectType.Entity, id, name, category, null) {
		if (category == "Shrine") {
			iconUrl = ImgRef.SHRINE;
		} else if (name.contains("Street Spirit") || name.contains("Vendor")) {
			iconUrl = ImgRef.CURRANT;
		} else {
			try {
				// Check if there is a static entity image available
				HttpRequest.request("${ServerUrl.ENTITY}/$name.png", mimeType: MIME_PNG);
				iconUrl = Uri.encodeFull("${ServerUrl.ENTITY}/$name.png");
			} catch (_) {
				iconUrl = ImgRef.ENTITY;
			}
		}
	}

	/// Get the spritesheet requested, or the current one if not specified.
	Map<String, dynamic> getState([String stateName]) {
		if (stateName == null && currentState != null) {
			return getState(currentState);
		}

		if (states != null) {
			for (Map<String, dynamic> state in states) {
				if (state["stateName"] == stateName) {
					return state;
				}
			}
		}

		return null;
	}

	/// Get a sized, single sprite icon image.
	/// If state is set, it will be used, otherwise the server-set state.
	/// If fitTo is set (px), it will be scaled to fit in that dimension
	DivElement getSpriteImage({Map<String, dynamic> useState, int fitTo}) {
		Map<String, dynamic> state = useState ?? getState();

		if (state == null) {
			return null;
		}

		String normalBgSize = "${state["sheetWidth"]}px ${state["sheetHeight"]}px";
		String scaledBgSize;
		double newFrameWidth;
		double newFrameHeight;
		double fixMargin;

		if (fitTo != null) {
			// Find scale factor, comparing size with a single frame
			double scaleX = fitTo / state["frameWidth"];
			double scaleY = fitTo / state["frameHeight"];
			double scale = min(scaleX, scaleY);

			// Adjust background size based on frame scale
			double bgWidth = state["sheetWidth"] * scale;
			double bgHeight = state["sheetHeight"] * scale;
			scaledBgSize = "${bgWidth}px ${bgHeight}px";

			if (state["frameHeight"] > state["frameWidth"]) {
				newFrameWidth = scale * state["frameWidth"];
				fixMargin = (fitTo - newFrameWidth) / 2;
			} else if (state["frameWidth"] > state["frameHeight"]) {
				newFrameHeight = scale * state["frameHeight"];
				fixMargin = (fitTo - newFrameHeight) / 2;
			}
		}

		DivElement image = new DivElement()
			..classes = ["entity-image"]
			..style.backgroundImage = "url(${state["url"]})"
			..style.backgroundSize = scaledBgSize ?? normalBgSize
			..style.width = "${newFrameWidth ?? fitTo ?? state["frameWidth"]}px"
			..style.height = "${newFrameHeight ?? fitTo ?? state["frameHeight"]}px";

		// Center narrow sprites with margins
		if (fixMargin != null) {
			image.style
				..marginLeft = "${fixMargin}px"
				..marginRight = "${fixMargin}px";
		}

		return image;
	}

	@override
	DivElement toPage() {
		DivElement parent = super.toPage();

		// Image
		if (getState() != null) {
			parent
				..append(
					getSpriteImage()
						..classes.addAll(["center-block", "item-header"])
				)
				..append(new HRElement());
		}

		// Items
		if (sellItems != null && sellItems.length > 0) {
			parent.append(new HeadingElement.h2()
				..text = "Merchandise");
			DivElement items = new DivElement()
				..classes = ["item-box-list"];
			sellItems.forEach((String itemType) {
				Item item = GameObject.find("#/item/$itemType");
				items.append(
					new AnchorElement(href: item.path.toString())
						..classes = ["item-box"]
						..title = item.name
						..append(
							new ImageElement(src: item.iconUrl)
						)
				);
			});
			parent
				..append(items)
				..append(new HRElement());
		}

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

			parent.append(new HRElement());
		}

		// Spritesheets
		if (states != null) {
			TableElement spritesheets = new TableElement()
				..classes = ["table"];
			Element thead = new Element.tag("thead");
			states.first.keys.forEach((String key) => thead.append(new TableCellElement()
				..text = key));
			spritesheets.append(thead);
			states.forEach((Map<String, dynamic> state) {
				TableRowElement row = new TableRowElement();
				state.values.forEach((dynamic value) {
					row.append(new TableCellElement()
						..append(
							!value.toString().startsWith("http")
								? (new SpanElement()
								..text = value.toString())
								: (new AnchorElement(href: value.toString())
								..text = "Link")
						)
					);
				});
				spritesheets.append(row);
			});

			parent..append(
				new HeadingElement.h2()
					..text = "Assets"
			)
			..append(
				new DivElement()
					..classes = ["table-responsive"]
					..append(spritesheets)
			);
		}

		return parent;
	}
}