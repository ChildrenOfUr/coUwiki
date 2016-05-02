library coUwiki;

import "dart:async";
import "dart:convert";
import "dart:html";
import "dart:math";
import "dart:js";
import "package:levenshtein/levenshtein.dart";
import "API_KEYS.dart";

part "common/globals.dart";
part "common/util.dart";
part "data/data.dart";
part "data/gameobject.dart";
part "data/hub.dart";
part "data/item.dart";
part "data/street.dart";
part "ui/page.dart";
part "ui/search.dart";
part "ui/ui.dart";

Future main() async {
	data = await new Data().load.future;
	ui = new UI();
	Page.setupPages();
}