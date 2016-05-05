part of coUwiki;

class Achievement extends GameObject {
	String description;

	Achievement(
		String id,
		String name,
		String category,
		String iconUrl,
		this.description
	) : super(GameObjectType.Achievement, id, name, category, iconUrl);

	DivElement toPage() {
		DivElement parent = super.toPage();

		parent
			..append(
				new ImageElement(src: iconUrl)
					..classes = ["img-responsive", "center-block"]
			)
			..append(new HRElement())
			..append(
				new ParagraphElement()
					..classes = ["lead", "text-justfy"]
					..text = description
			);

		return parent;
	}
}