library coUwiki;

import "API_KEYS.dart";

import "dart:async";
import "dart:convert";
import "dart:html";
import "dart:math";
import "dart:js";

import "package:levenshtein/levenshtein.dart";

part "common/cache.dart";
part "common/data.dart";
part "common/globals.dart";
part "common/objectpath.dart";
part "common/util.dart";

part "objects/achievement.dart";
part "objects/entity.dart";
part "objects/gameobject.dart";
part "objects/hub.dart";
part "objects/item.dart";
part "objects/skill.dart";
part "objects/street.dart";

part "ui/listpage.dart";
part "ui/locations_page.dart";
part "ui/page.dart";
part "ui/search.dart";
part "ui/streetimage.dart";
part "ui/ui.dart";

Future main() async {
	window.onLoad.listen((_) async {
		data = await new Data().load.future;
		ui = new UI();
	});
}