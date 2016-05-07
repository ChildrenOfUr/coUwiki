part of coUwiki;

class Cache {
	final Storage LOCALSTORAGE = window.localStorage;
	final String CACHE_KEY = "coUwiki_cache";
	final String DATE_KEY = "date";
	final Duration EXPIRY = new Duration(days: 7);

	Cache() {
		if (getData("version") != RELEASE) {
			clear();
		}

		setData("version", RELEASE);
	}

	/// Set the last update to today (only after updating the data!)
	void updateDate() {
		/*
			Update the date of the last update only if the current date is old.
			We're assuming the data has been updated before this is called.
			This check is to prevent perpetually setting the date forward.
		 */
		if (!cacheCurrent()) {
			LOCALSTORAGE["$CACHE_KEY $DATE_KEY"] = new DateTime.now().toString();
		}
	}

	/// The cache has been updated within the EXPIRY period
	bool cacheCurrent() {
		return (LOCALSTORAGE["$CACHE_KEY $DATE_KEY"] != null) &&
			DateTime
				.parse(LOCALSTORAGE["$CACHE_KEY $DATE_KEY"])
				.difference(new DateTime.now())
				.compareTo(EXPIRY) <= 0;
	}

	/// The specified key exists in local storage
	bool dataExists(String key) {
		return (LOCALSTORAGE["$CACHE_KEY $key"] != null);
	}

	/// Cache is current and the specified key exists
	bool dataCurrent(String key) {
		return (cacheCurrent() && dataExists(key));
	}

	/// Get the specified data from local storage
	String getData(String key) {
		return (LOCALSTORAGE["$CACHE_KEY $key"]);
	}

	/// Update the specified data in local storage
	void setData(String key, String value) {
		LOCALSTORAGE["$CACHE_KEY $key"] = value;
	}

	/// Remove all wiki data from local storage
	void clear() {
		LOCALSTORAGE.forEach((String key, String value) {
			if (key.startsWith(CACHE_KEY)) {
				LOCALSTORAGE.remove(key);
			}
		});
	}
}