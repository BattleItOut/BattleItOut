import 'dart:convert';
import 'package:battle_it_out/persistence/wfrp_database.dart';
import 'package:flutter/services.dart';

import 'DTO/attribute.dart';
import 'DTO/profession.dart';
import 'DTO/race.dart';

class Character {
  String name;
  Race race;
  int subrace;
  Profession profession;
  Map<int, Attribute> attributes;
  // List<Skill> skills;
  // List<Talent> talents;
  // List<Trait> traits;

  Character({
    required this.name,
    required this.race,
    required this.subrace,
    required this.profession,
    required this.attributes});

  static Future<Character> create(String jsonPath, WFRPDatabase database) async {
    var json = await _loadJson(jsonPath);
    Character character = Character(
      name: json['name'],
      race: await Race.loadFromDatabase(id: json["race_id"], database: database),
      subrace: json['subrace_id'],
      profession: await Profession.loadFromDatabase(id: json["profession_id"], database: database),
      attributes: await database.getAttributesByRace(json["race_id"]));
    _updateAttributes(json, character);
    return character;
  }

  static void _updateAttributes(json, Character character) {
    for (var attributeMap in json['attributes']) {
      character.attributes[attributeMap["id"]]!.base = attributeMap["base"];
      character.attributes[attributeMap["id"]]!.advances = attributeMap["advances"];
    }
  }
  static _loadJson(String jsonPath) async {
    String data = await rootBundle.loadString(jsonPath);
    return jsonDecode(data);
  }
}