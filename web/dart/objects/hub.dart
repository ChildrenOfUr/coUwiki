part of coUwiki;

class Hub extends GameObject {
	/// Music that plays in this hub
	String music;

	/// Whether players will have bubble letters over them in this hub
	bool playersHaveLetters;

	/// True if weather is disabled here, false if weather will happen normally
	bool disableWeather;

	/// Whether it will snow here
	bool snowyWeather;

	/// Whether players can triple jump here
	String physics;

	Hub(
		String id,
		String name,
		this.music,
		this.playersHaveLetters,
		this.disableWeather,
		this.snowyWeather,
		this.physics
	) : super(GameObjectType.Hub, id, name, null, "${ServerUrl.HUBIMG}/$name.jpg");

	@override
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

		if (physics != "normal") {
			parent.append(makeAlert("warning", "You will experience $physics physics."));
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