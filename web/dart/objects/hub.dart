part of coUwiki;

class Hub extends GameObject {
	static Hub find(String id) {
		try {
			return data.dataset["hub"].singleWhere((Hub hub) {
				return hub.id == id;
			});
		} catch(_) {
			return null;
		}
	}

	String music;
	bool playersHaveLetters;
	bool disableWeather;
	bool snowyWeather;
	bool tripleJumping;

	Hub(
		String id,
		String name,
		this.music,
		this.playersHaveLetters,
		this.disableWeather,
		this.snowyWeather,
		this.tripleJumping
	) : super(GameObjectType.Hub, id, name, null, "$HUBIMG_URL/$name.jpg");

	DivElement toPage() {
		DivElement parent = super.toPage();

		parent.append(
			new ImageElement(src: iconUrl)
				..classes = ["img-thumbnail", "img-responsive", "center-block"]
		);
		parent.append(new HRElement());

		if (music != null) {
			parent.append(makeAlert("info", "This region plays the $music music."));
		}

		if (playersHaveLetters) {
			parent.append(makeAlert("info", "You'll get a random letter above your head here. Gather some friends and spell out a word!"));
		}

		if (disableWeather) {
			parent.append(makeAlert("warning", "There's a 0% chance of weather."));
		}

		if (snowyWeather) {
			parent.append(makeAlert("warning", "When it's raining, it snows here."));
		}

		if (!tripleJumping) {
			parent.append(makeAlert("danger", "You can't triple-jump."));
		}

		parent
			..append(new HRElement())
			..append(new HeadingElement.h2()..text = "Streets")
			..append(new ListPage.filter(GameObjectType.Street, (Street street) {
				return street.hubId == id;
			}).toPage());

		return parent;
	}
}