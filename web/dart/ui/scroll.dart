part of coUwiki;

class Scrolling {
	/// Key for saving to local storage
	static final String KEY = "scrolling";

	/// Working set of page positions
	static Map<String, int> positions;

	/// Load positions from local storage
	static void readStore() {
		String json = cache.getData(KEY) ?? "{}";
		positions = JSON.decode(json);
	}

	/// Store the position of the current page
	static void save() {
		if (window.scrollY > 0) {
			ObjectPath path = new ObjectPath.fromWindow();
			positions[path.path] = window.scrollY;
			cache.setData(KEY, JSON.encode(positions));
		}
	}

	/// Scroll to the saved value for the current page
	static void restore() {
		ObjectPath path = new ObjectPath.fromWindow();
		window.scrollTo(0, positions[path.path] ?? 0);
	}
}