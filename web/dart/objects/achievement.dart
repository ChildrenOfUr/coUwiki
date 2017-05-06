part of coUwiki;

class Achievement extends GameObject {
	/// Description (how to earn)
	String description;

	Achievement(
		String id,
		String name,
		String category,
		String iconUrl,
		this.description
	) : super(GameObjectType.Achievement, id, name, category, iconUrl) {
		this.iconUrl = proxyImage('achievements', iconUrl);
	}

	@override
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