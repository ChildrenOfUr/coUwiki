part of coUwiki;

class Search {
	static final String TYPEAHEAD_OPEN = "typeahead-open";

	TextInputElement input = querySelector("#search");
	DivElement typeahead;

	Search() {
		input.onKeyUp.listen((_) {
			makeTypeahead(getMatchingObjects(input.value.trim()));
		});
	}

	Map<String, List<GameObject>> getMatchingObjects(String needle) {
		Map<String, List<GameObject>> result = new Map();

		// No entry means no matches
		if (needle.length == 0) {
			return result;
		}

		// For each main game object type
		data.dataset.keys.forEach((String key) {
			// Find matches
			result[key] = data.dataset[key].where((GameObject object) {
				return levenshtein(object.name, needle, caseSensitive: false) <= 3
					|| object.name.toLowerCase().contains(needle.toLowerCase());
			}).toList();

			// Sort results in each category by relevance
			result[key].sort((GameObject a, GameObject b) {
				return levenshtein(a.name, needle, caseSensitive: false)
					 - levenshtein(b.name, needle, caseSensitive: false);
			});

			// Then only display the top 10
			result[key] = result[key].sublist(0, min(result[key].length, 10));
		});

		return result;
	}

	void makeTypeahead(Map<String, List<GameObject>> items) {
		closeTypeahead();

		if (items.length == 0) {
			return;
		}

		typeahead = new DivElement()..classes.add("typeahead");

		items.forEach((String category, List<GameObject> contents) {
			if (contents.length > 0) {
				UListElement section = new UListElement()
					..classes.add("section")
					..append(
						new LIElement()
							..text = ucfirst(category)
					);

					contents.forEach((GameObject object) {
						String displayName = object.name;

						LIElement item = new LIElement()
							..append(
								new DivElement()
									..classes = ["img"]
									..style.backgroundImage = "url(${object.iconUrl})"
							)
							..appendHtml(displayName)
							..onClick.first.then((_) {
								closeTypeahead(true);
								Page.display(object);
							});

						section.append(item);
					});

				typeahead.append(section);
			}
		});

		int yOffset = input.offsetTop + input.clientHeight + window.scrollY;
		typeahead.style
			..transform = "translate(${input.offsetLeft}px, ${yOffset}px)"
			..width = "${input.clientWidth + 2}px";
		document.body.append(typeahead);
		input.classes.add(TYPEAHEAD_OPEN);
	}

	void closeTypeahead([bool full = false]) {
		typeahead?.remove();
		input.classes.remove(TYPEAHEAD_OPEN);

		if (full) {
			input.value = "";
		}
	}
}