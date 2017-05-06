part of coUwiki;

Cache cache;
Data data;
UI ui;

/// Release (clears cache if this changes)
final String RELEASE = "1.0.2";

/// Bundled image URLs
class ImgRef {
	static final String ACHV = "img/achievements.png";
	static final String CURRANT = "img/currant.svg";
	static final String ENTITY = "img/entities.png";
	static final String ITEM = "img/items.png";
	static final String LOCATIONS = "img/locations.png";
	static final String SHRINE = "img/shrine.svg";
	static final String STREETS = "img/signpost.png";
	static final String SKILLS = "img/skills.png";
	static final String BLANK_MAP = "${ServerUrl.HUBIMG}/fake_island.jpg";
}

/// MIME type for downloaded PNG files
final String MIME_PNG = "image/png";

/// Server connections
class ServerUrl {
	static final String ENTITY = "//childrenofur.com/assets/staticEntityImages";
	static final String HUBIMG = "//childrenofur.com/assets/hubImages";
	static final String SERVER = "https://server.childrenofur.com:8181";
	static final String STREET = "https://raw.githubusercontent.com/ChildrenOfUr/CAT422-glitch-location-viewer/master/locations";
}

/// Types of GameObjects
/// This is used because compiled JS type names are converted to garbage.
enum GameObjectType {
	Achievement,
	Edge,
	Entity,
	GameObject,
	Hub,
	Item,
	Skill,
	Street
}
