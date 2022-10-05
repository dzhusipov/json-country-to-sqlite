import 'dart:convert';
import 'dart:io';

import 'package:pocketbase/pocketbase.dart';

String filePath = "assets/country.json";
final client = PocketBase('0.0.0.0:443');

readJsonFile() async {
  var input = await File(filePath).readAsString();
  var map = jsonDecode(input);

  for (int i = 0; i < map.length - 1; i++) {
    print(
        "${map[i]["id"]} ${map[i]["name"]} ${map[i]["emoji"]} ${map[i]["emojiU"]}");
    await client.records.create('country', body: {
      'country_id': map[i]["id"],
      'name': map[i]["name"],
      'emoji': map[i]["emoji"],
      'emojiU': map[i]["emojiU"],
    });

    var state = map[i]["state"];
    for (int j = 0; j < state.length; j++) {
      await client.records.create('state', body: {
        'state_id': state[j]["id"],
        'name': state[j]["name"],
        'country_id': state[j]["country_id"],
      });
      //print("${state[j]["id"]} ${state[j]["name"]} ${state[j]["country_id"]}");
      var city = state[j]["city"];
      for (int k = 0; k < city.length; k++) {
        await client.records.create('city', body: {
          'city_id': city[k]["id"],
          'name': city[k]["name"],
          'state_id': city[k]["state_id"],
        });
        //print("${city[k]["id"]} ${city[k]["name"]} ${city[k]["state_id"]}");
      }
    }
  }
}
