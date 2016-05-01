part of coUwiki;

class Hub extends GameObject {
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
	) : super(id, name, "Region", "img/signpost.png");

	DivElement toPage() {
		DivElement parent = super.toPage();

		if (music != null) {
			parent.append(makeAlert("info", "This region plays the $music music."));
		}

		if (playersHaveLetters) {
			parent.append(makeAlert("info", "You'll get a random letter above your head here. Gather some friends and make a word!"));
		}

		if (disableWeather) {
			parent.append(makeAlert("warning", "There's no weather."));
		}

		if (snowyWeather) {
			parent.append(makeAlert("warning", "It snows instead of rains."));
		}

		if (!tripleJumping) {
			parent.append(makeAlert("danger", "You can't triple-jump."));
		}

		return parent;
	}
}