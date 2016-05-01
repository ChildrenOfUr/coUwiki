part of coUwiki;

String ucfirst(String string) {
	return string.substring(0, 1).toUpperCase() + string.substring(1);
}

void hardReload() {
	context["location"].callMethod("reload", [true]);
}

DivElement makeAlert(String type, String message) {
	return new DivElement()
		..classes = ["alert", "alert-$type"]
		..text = message;
}