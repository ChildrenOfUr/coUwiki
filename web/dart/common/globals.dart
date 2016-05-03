part of coUwiki;

// General constants

final String SIGNPOST_IMG = "img/signpost.png";
final String SIGNPOST2_IMG = "img/signpost_double.png";
final String BLENDER_IMG = "img/blender.png";

// Server connection

final String SERVER_URL = "http://server.childrenofur.com:8181";
final String STREET_URL = "https://raw.githubusercontent.com/ChildrenOfUr/CAT422-glitch-location-viewer/master/locations";
final String HUBIMG_URL = "http://childrenofur.com/assets/hubImages";

// Global objects

Cache cache;
Data data;
UI ui;

/// When we are updating the hash, don't trigger anything
bool hashLock = false;

/// Whether a page is requested
bool hashExists() => window.location.hash.length > 1;
