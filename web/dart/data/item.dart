part of coUwiki;

class Item extends GameObject {
	String spriteUrl;
	String description;
	int price;
	int stacksTo;
	int iconNum;
	bool isContainer;
	int subSlots;
	Map<String, int> consumeValues;

	Item(
		String id,
		String name,
		String category,
		String iconUrl,
		this.spriteUrl,
		this.iconNum,
		this.description,
		this.price,
		this.stacksTo,
		this.subSlots,
		this.isContainer,
		this.consumeValues
	) : super(Item, id, name, category, iconUrl);

	DivElement toPage() {
		DivElement parent = super.toPage();

		parent.querySelector(".breadcrumb").children.insert(0,
			new LIElement()
				..text = type.toString()
		);

		parent.append(
			new DivElement()
				..classes = ["row"]
				..append(
					new DivElement()
						..classes = ["col-sm-3"]
						..append(new ImageElement(src: iconUrl)
							..classes = ["img-thumbnail"]
						)

				)
				..append(
					new DivElement()
						..classes = ["col-sm-9", "panel", "panel-default"]
						..append(
							new DivElement()
								..append(
									new DivElement()
										..classes = ["panel-body"]
										..text = description
								)
						)
				)
		);

		if (price == 0) {
			parent.append(makeAlert("warning", "This item is priceless"));
		} else {
			parent.append(makeAlert("warning", "Worth around $price currant${price == 1 ? "" : "s"}"));
		}

		parent.append(makeAlert("info", "Can fit $stacksTo in a stack"));

		if (isContainer) {
			parent.append(makeAlert("success", "Can hold $subSlots item${subSlots == 1 ? "" : "s"}"));
		}

		return parent;
	}
}