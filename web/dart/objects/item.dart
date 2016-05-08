part of coUwiki;

class Item extends GameObject {
	/// Image URL of spritesheet (1, 2, 3, 4)
	String spriteUrl;

	/// About the item
	String description;

	/// Currant cost of the item, 0 for "priceless"
	int price;

	/// How many can fit in a stack
	int stacksTo;

	/// How many icons are in the spriteUrl
	int iconNum;

	/// Whether the item can hold other items
	bool isContainer;

	/// How many items it can hold
	int subSlots;

	/// Energy, Mood, Img, etc. given when consumed
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
	) : super(GameObjectType.Item, id, name, category, iconUrl);

	@override
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
							..classes = ["col-xs-9", "lead", "text-justify"]
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

		if (consumeValues.length > 0) {
			parent
				..append(new HRElement())
				..append(new HeadingElement.h2()..text = "Consumable");

			if (consumeValues["energy"] != 0) {
				parent
					..append(
						new SpanElement()
							..classes = ["label", "label-danger"]
							..text = "${consumeValues["energy"]} energy"
					)
					..appendText(" ");
			}

			if (consumeValues["mood"] != 0) {
				parent
					..append(
						new SpanElement()
							..classes = ["label", "label-success"]
							..text = "${consumeValues["mood"]} mood"
					)
					..appendText(" ");
			}

			if (consumeValues["img"] != 0) {
				parent
					..append(
						new SpanElement()
							..classes = ["label", "label-info"]
							..text = "${consumeValues["img"]} iMG"
					)
					..appendText(" ");
			}
		}

		return parent;
	}
}