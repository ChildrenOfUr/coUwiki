part of coUwiki;

class StreetImageDisplay {
	String tsid;

	Point<int> loadingImageSize;
	String loadingImageUrl;

	Point<int> mainImageSize;
	String mainImageUrl;

	Element parent;
	ButtonElement button;
	Element buttonIcon;

	bool open;

	Completer<StreetImageDisplay> ready = new Completer();

	StreetImageDisplay.auto(String tsid) {
		// Format TSID correctly (start with G)
		this.tsid = (tsid.startsWith("L") ? tsid.replaceFirst("L", "G") : tsid);

		window.onResize.listen((_) {
			scale();
		});

		_findData(this.tsid).then((_) {
			parent = _makeElement();
			ready.complete(this);
		});
	}

	Future<bool> _findData(String tsid) async {
		try {
			String json = await HttpRequest.requestCrossOrigin("$STREET_URL/$tsid.json");
			Map<String, dynamic> data = JSON.decode(json);

			loadingImageSize = new Point(data["loading_image"]["w"], data["loading_image"]["h"]);
			loadingImageUrl = data["loading_image"]["url"];

			mainImageSize = new Point(data["main_image"]["w"], data["main_image"]["h"]);
			mainImageUrl = data["main_image"]["url"];

			return true;
		} catch (e) {
			throw "Could not load street image data: $e";
		}
	}

	DivElement _makeElement() {
		buttonIcon = new Element.tag("i")
			..classes = ["fa", "fa-lg"];

		button = new ButtonElement()
			..classes = ["btn", "btn-default", "btn-lg"]
			..append(buttonIcon)
			..onClick.listen((_) => toggle());

		parent = new DivElement()
			..classes = ["street-image", "img-thumbnail"]
			..append(button);

		// Preload image. It is collapsed again after adding to scale.
		collapse();

		return parent;
	}

	void scale() {
		if (!ready.isCompleted) {
			return;
		}

		num scaleFactor;
		num scaledHeight;

		if (open) {
			scaleFactor = parent.clientWidth / mainImageSize.x;
			scaledHeight = mainImageSize.y * scaleFactor;
		} else {
			scaleFactor = parent.clientWidth / loadingImageSize.x;
			scaledHeight = loadingImageSize.y * scaleFactor;
		}

		parent.style.height = "${scaledHeight}px";
	}

	void toggle() {
		if (open) {
			collapse();
		} else {
			expand();
		}
	}

	void collapse() {
		open = false;
		parent.style.backgroundImage = "url($loadingImageUrl)";
		parent.classes.remove("open");
		button.classes.remove("active");
		buttonIcon.classes
			..add("fa-search-plus")
			..remove("fa-search-minus");
		scale();
	}

	void expand() {
		open = true;
		parent.style.backgroundImage = "url($mainImageUrl)";
		parent.classes.add("open");
		button.classes.add("active");
		buttonIcon.classes
			..add("fa-search-minus")
			..remove("fa-search-plus");
		scale();
	}
}