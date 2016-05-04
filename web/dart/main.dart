library coUwiki;

import "API_KEYS.dart";

import "dart:async";
import "dart:convert";
import "dart:html";
import "dart:math";
import "dart:js";

import "package:levenshtein/levenshtein.dart";

part "common/cache.dart";
part "common/globals.dart";
part "common/objectpath.dart";
part "common/util.dart";

part "data/data.dart";
part "data/entity.dart";
part "data/gameobject.dart";
part "data/hub.dart";
part "data/item.dart";
part "data/street.dart";

part "ui/listpage.dart";
part "ui/page.dart";
part "ui/search.dart";
part "ui/streetimage.dart";
part "ui/ui.dart";

Future main() async {
	data = await new Data().load.future;
	ui = new UI();
}