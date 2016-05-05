part of coUwiki;

class Skill extends GameObject {
	List<String> descriptions;
	List<int> levels;
	List<String> iconUrls;
	List<String> giants;

	Skill(
		String id,
		String name,
		String category,
		this.descriptions,
		this.levels,
		this.iconUrls,
		this.giants
	) : super(Skill, id, name, category, null) {
		iconUrl = iconUrls.first;
	}

	DivElement toPage() {
		DivElement parent = super.toPage()
			..append(new HeadingElement.h2()..text = "Levels");

		// Levels
		for (int l = 0; l < min(levels.length, min(descriptions.length, iconUrls.length)); l++) {
			DivElement icon = new DivElement()
				..classes = ["media-left", "media-top", "skill-icon"]
				..append(
					new Element.a()
						..append(new ImageElement(src: iconUrls[l])
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