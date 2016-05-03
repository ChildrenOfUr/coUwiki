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

		parent
			..append(
				new DivElement()
					..classes = ["row", "item-header"]
					..append(
						new ImageElement(src: iconUrl)
							..classes = ["col-xs-3", "img-responsive"]
					)
					..append(
						new ParagraphElement()
							..classes = ["col-xs-9", "lead"]
							..text = description
					)
			)
			..append(new HRElement());

		if (price == 0) {
			parent.append(makeAlert("warning", "This item is priceless"));
		} else {
			parent.append(makeAlert("warning", "Worth around $price currant${plural(price)}"));
		}

		parent.append(makeAlert("info", "Can fit $stacksTo in a stack"));

		if (isContainer) {
			parent.append(makeAlert("success", "Can hold $subSlots item${plural(subSlots)}"));
		}

		return parent;
	}
}