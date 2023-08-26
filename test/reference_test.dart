import 'dart:convert';
import 'dart:io';

import 'package:battle_it_out/persistence/attribute.dart';
import 'package:battle_it_out/persistence/character.dart';
import 'package:battle_it_out/persistence/skill/skill.dart';
import 'package:battle_it_out/persistence/talent/talent.dart';
import 'package:battle_it_out/utils/database_provider.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await DatabaseProvider.instance.connect(test: true);

  group('Links between attributes, skills and weapons: ', () {
    test('Start conditions', () async {
      Character character = await createTestCharacter();

      // Attribute
      Attribute attribute = character.attributes.firstWhere((attribute) => attribute.id == 1);
      expect(attribute.base, 34);
      expect(attribute.advances, 5);
      expect(attribute.getTotalValue(), 39);
      expect(attribute.getTotalBonus(), 3);

      // Skill
      Skill skill = character.skills.firstWhere((skill) => skill.id == 38);
      expect(skill.advances, 5);
      expect(skill.getTotalValue(), 44);

      // Talent
      Talent talent = character.talents.firstWhere((talent) => talent.id == 26);
      expect(talent.currentLvl, 1);
      expect(talent.getMaxLvl(), 3);

      // Weapon
      expect(character.meleeWeapons[0].getTotalSkillValue(), 44);
    });
    test('Increasing base value', () async {
      Character character = await createTestCharacter();

      // Attribute
      Attribute attribute = character.attributes.firstWhere((attribute) => attribute.id == 1);
      attribute.base++;
      expect(attribute.getTotalValue(), 40);
      expect(attribute.getTotalBonus(), 4);

      // Skill
      Skill skill = character.skills.firstWhere((skill) => skill.id == 38);
      expect(skill.getTotalValue(), 45);

      // Talent
      Talent talent = character.talents.firstWhere((talent) => talent.id == 26);
      expect(talent.getMaxLvl(), 4);

      // Weapon
      expect(character.meleeWeapons[0].getTotalSkillValue(), 45);
    });
    test('Increasing advance value', () async {
      Character character = await createTestCharacter();

      // Attribute
      Attribute attribute = character.attributes.firstWhere((attribute) => attribute.id == 1);
      attribute.advances += 11;
      expect(attribute.getTotalValue(), 50);
      expect(attribute.getTotalBonus(), 5);

      // Skill
      Skill skill = character.skills.firstWhere((skill) => skill.id == 38);
      expect(skill.getTotalValue(), 55);

      // Talent
      Talent talent = character.talents.firstWhere((talent) => talent.id == 26);
      expect(talent.getMaxLvl(), 5);

      // Weapon
      expect(character.meleeWeapons[0].getTotalSkillValue(), 55);
    });
    test('Increasing skill advance value', () async {
      Character character = await createTestCharacter();
      Skill skill = character.skills.firstWhere((skill) => skill.id == 38);

      skill.advances += 21;

      Attribute attribute = character.attributes.firstWhere((attribute) => attribute.id == 1);
      expect(attribute.getTotalValue(), 39);
      expect(attribute.getTotalBonus(), 3);

      // Skill
      skill = character.skills.firstWhere((skill) => skill.id == 38);
      expect(skill.getTotalValue(), 65);

      // Talent
      Talent talent = character.talents.firstWhere((talent) => talent.id == 26);
      expect(talent.getMaxLvl(), 3);

      // Weapon
      expect(character.meleeWeapons[0].getTotalSkillValue(), 65);
    });
  });
}

Future<Character> createTestCharacter() async {
  File file = File('assets/test/character_test.json');
  return await CharacterFactory().fromMap(jsonDecode(await file.readAsString()));
}
