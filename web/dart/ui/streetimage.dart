part of coUwiki;

/**
 * Handles the expanding street images on [Street] [Page]s.
 */
class StreetImageDisplay {
	/// TSID of the displayed street
	String tsid;

	/// Size of the street's "loading" image (px)
	Point<int> loadingImageSize;

	/// URL of the street's "loading" image
	String loadingImageUrl;

	/// Size of the street's "main" image (px)
	Point<int> mainImageSize;

	/// URL of the street's "main" image
	String mainImageUrl;

	/// Element containing the image and button
	Element parent;

	/// Toggle expand/collapse button
	ButtonElement button;

	/// Icon inside [button]
	Element buttonIcon;

	/// Weather the street is in expanded ("main") mode
	bool open;

	/// Allow waiting for the data to download
	Completer<StreetImageDisplay> ready = new Completer();

	/// Create for the given TSID
	StreetImageDisplay(String tsid) {
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

	/// Download the image data from GitHub
	Future<bool> _findData(String tsid) async {
		try {
			String json = await HttpRequest.requestCrossOrigin("${ServerUrl.STREET}/$tsid.json");
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

	/// Assemble the parent element
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

	/// Update the sizing for the current window
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

	/// Open or close
	void toggle() {
		if (open) {
			collapse();
		} else {
			expand();
		}
	}

	/// Close the element (display [loadingImageUrl])
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

	/// Open the element (display[mainImageUrl])
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