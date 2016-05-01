part of coUwiki;

class Street extends GameObject {
	int hub;
	List<GameObject> contents;
	bool hidden;
	bool broken;
	bool hasMailbox;
	String vendor;
	String shrine;

	Street(
		String id,
		String name,
		this.hub,
		this.hidden,
		this.broken,
		this.hasMailbox,
		this.vendor,
		this.shrine
	) : super(id, name, "Street", "img/signpost.png");

	DivElement toPage() {
		DivElement parent = super.toPage();

		if (hasMailbox) {
			parent.append(makeAlert("info", "Mailbox"));
		}

		if (vendor != null) {
			parent.append(makeAlert("success", "$vendor vendor"));
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
}