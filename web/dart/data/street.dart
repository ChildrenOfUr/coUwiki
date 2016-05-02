part of coUwiki;

class Street extends GameObject {
	String hubId;
	List<GameObject> contents;
	bool hidden;
	bool broken;
	bool hasMailbox;
	String vendor;
	String shrine;

	Street(
		String id,
		String name,
		this.hubId,
		this.hidden,
		this.broken,
		this.hasMailbox,
		this.vendor,
		this.shrine
	) : super(Street, id, name, null, "img/signpost.png");

	DivElement toPage() {
		DivElement parent = super.toPage();

		parent.querySelector(".breadcrumb").append(
			new LIElement()
				..append(
					new AnchorElement(href: "#${hub.hashUrl}")
						..text = hub.name
				)
			);

		if (hasMailbox) {
			parent.append(makeAlert("info", "Mailbox"));
		}

		if (vendor != null) {
			parent.append(makeAlert("success", "$vendor Vendor"));
		}

		if (shrine != null) {
			parent.append(makeAlert("success", "Shrine to $shrine"));
		}

		if (hidden) {
			parent.append(makeAlert("warning", "This street is secret. You can't teleport to it."));
		}

		if (broken) {
			parent.append(makeAlert("danger", "This street is broken. Ask your pet rock for a free escape."));
		}

		return parent;
	}

	Hub get hub => Hub.find(hubId);
}