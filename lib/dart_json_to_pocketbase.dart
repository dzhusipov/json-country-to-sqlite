import 'dart:convert';
import 'dart:io';

import 'package:pocketbase/pocketbase.dart';

String filePath = "assets/country.json";
final client = PocketBase('0.0.0.0:443');

readJsonFile() async {
  var input = await File(filePath).readAsString();
  var map = jsonDecode(input);

  for (int i = 0; i < map.length - 1; i++) {
    insertCountry(
        map[i]["id"], map[i]["name"], map[i]["emoji"], map[i]["emojiU"]);
    print(
        "${map[i]["id"]} ${map[i]["name"]} ${map[i]["emoji"]} ${map[i]["emojiU"]}");
    var state = map[i]["state"];
    for (int j = 0; j < state.length; j++) {
      insertState(state[j]["id"], state[j]["name"], state[j]["country_id"]);
      print("${state[j]["id"]} ${state[j]["name"]} ${state[j]["country_id"]}");
      var city = state[j]["city"];
      for (int k = 0; k < city.length; k++) {
        insertCity(city[k]["id"], city[k]["name"], city[k]["state_id"]);
        print("${city[k]["id"]} ${city[k]["name"]} ${city[k]["state_id"]}");
      }
    }
  }
}

insertCountry(int id, String name, String emoji, String emojiU) async {
  await client.records.create('country', body: {
    'country_id': id,
    'name': name,
    'emoji': emoji,
    'emojiU': emojiU,
  });
}

insertState(int id, String name, int countryId) async {
  await client.records.create('state', body: {
    'state_id': id,
    'name': name,
    'country_id': countryId,
  });
}

insertCity(int id, String name, int stateId) async {
  await client.records.create('city', body: {
    'city_id': id,
    'name': name,
    'state_id': stateId,
  });
}
