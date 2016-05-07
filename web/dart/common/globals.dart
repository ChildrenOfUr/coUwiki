part of coUwiki;

// Resource constants

final String ACHV_IMG = "img/achievements.png";
final String CURRANT_IMG = "img/currant.svg";
final String ENTITY_IMG = "img/entities.png";
final String ITEM_IMG = "img/items.png";
final String LOCATIONS_IMG = "img/locations.png";
final String SHRINE_IMG = "img/shrine.svg";
final String STREETS_IMG = "img/signpost.png";
final String SKILLS_IMG = "img/skills.png";

final String MIME_PNG = "image/png";

// Server connections

final String ENTITY_URL = "http://childrenofur.com/assets/staticEntityImages";
final String HUBIMG_URL = "http://childrenofur.com/assets/hubImages";
final String SERVER_URL = "http:///robertmcdermot.com:8181";
final String STREET_URL = "https://raw.githubusercontent.com/ChildrenOfUr/CAT422-glitch-location-viewer/master/locations";

// Global objects

Cache cache;
Data data;
UI ui;

/// Whether a page is requested
bool hashExists() => window.location.hash.length > 1;

/// Type of GameObject (used for listing)
enum GameObjectType {
	Achievement,
	Entity,
	GameObject,
	Hub,
	Item,
	Skill,
	Street
}