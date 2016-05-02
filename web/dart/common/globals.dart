part of coUwiki;

// Server connection

final String SERVER_URL = "http://server.childrenofur.com:8181";

// Local storage

final String CACHE_KEY = "coUwiki_cache";

final Storage LOCALSTORAGE = window.localStorage;

bool cacheCurrent() => LOCALSTORAGE["$CACHE_KEY date"] != null &&
		DateTime.parse(LOCALSTORAGE["$CACHE_KEY date"])
			.difference(new DateTime.now()).inDays < 7;

// Global objects

Data data;
UI ui;