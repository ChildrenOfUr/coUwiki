part of coUwiki;

class Skill extends GameObject {
	/// Descriptions of what is gained at each level
	List<String> descriptions;

	/// How many points are needed for each level
	List<int> levels;

	/// The icons for each level
	List<String> iconUrls;

	/// Associated giants, index 0 is the primary giant
	List<String> giants;

	Skill(
		String id,
		String name,
		String category,
		this.descriptions,
		this.levels,
		this.iconUrls,
		this.giants
	) : super(GameObjectType.Skill, id, name, category, null) {
		iconUrl = proxyImage('skills', iconUrls.first);
	}

	@override
	DivElement toPage() {
		DivElement parent = super.toPage()
			..append(new HeadingElement.h2()..text = "Levels");

		// Levels
		for (int l = 0; l < min(levels.length, min(descriptions.length, iconUrls.length)); l++) {
			DivElement icon = new DivElement()
				..classes = ["media-left", "media-top", "skill-icon"]
				..append(
					new Element.a()
						..append(new ImageElement(src: proxyImage('skills', iconUrls[l]))
							..classes = ["media-object"]
						)
				);

			DivElement info = new DivElement()
				..classes = ["media-body"]
				..append(new HeadingElement.h4()
					..text = "Level ${l + 1}: ${levels[l + 1]} points"
					..classes = ["media-heading"]
				)
				..append(new ParagraphElement()..text = descriptions[l]);

			DivElement level = new DivElement()
				..classes = ["media"]
				..append(icon)
				..append(info);

			parent.append(level);
		}

		parent
			..append(new HRElement())
			..append(new HeadingElement.h2()..text = "Giant Affiliations");

		// Giants
		OListElement giantList = new OListElement()
			..classes = ["giant-affiliations"];
		giants.forEach((String giant) {
			giantList.append(new LIElement()..text = giant);
		});
		parent.append(giantList);

		return parent;
	}
}