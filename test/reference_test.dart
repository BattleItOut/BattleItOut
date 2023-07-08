import 'dart:convert';
import 'dart:io';

import 'package:battle_it_out/persistence/dao/character_dao.dart';
import 'package:battle_it_out/persistence/entities/character.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('Links between attributes, skills and weapons: ', () {
    test('Start conditions', () async {
      Character character = await createTestCharacter();

      // Attribute
      expect(character.attributes[1]!.base, 34);
      expect(character.attributes[1]!.advances, 5);
      expect(character.attributes[1]!.getTotalValue(), 39);
      expect(character.attributes[1]!.getTotalBonus(), 3);

      // Skill
      expect(character.skills[38]!.advances, 5);
      expect(character.skills[38]!.getTotalValue(), 44);

      // Talent
      expect(character.talents[26]!.currentLvl, 1);
      expect(character.talents[26]!.getMaxLvl(), 3);

      // Weapon
      expect(character.getMeleeWeapons()[0].getTotalSkillValue(), 44);
    });
    test('Increasing base value', () async {
      Character character = await createTestCharacter();

      character.attributes[1]!.base++;
      expect(character.attributes[1]!.getTotalValue(), 40);
      expect(character.attributes[1]!.getTotalBonus(), 4);

      // Skill
      expect(character.skills[38]!.getTotalValue(), 45);

      // Talent
      expect(character.talents[26]!.getMaxLvl(), 4);

      // Weapon
      expect(character.getMeleeWeapons()[0].getTotalSkillValue(), 45);
    });
    test('Increasing advance value', () async {
      Character character = await createTestCharacter();

      character.attributes[1]!.advances += 11;
      expect(character.attributes[1]!.getTotalValue(), 50);
      expect(character.attributes[1]!.getTotalBonus(), 5);

      // Skill
      expect(character.skills[38]!.getTotalValue(), 55);

      // Talent
      expect(character.talents[26]!.getMaxLvl(), 5);

      // Weapon
      expect(character.getMeleeWeapons()[0].getTotalSkillValue(), 55);
    });
    test('Increasing skill advance value', () async {
      Character character = await createTestCharacter();

      character.skills[38]!.advances += 21;
      expect(character.attributes[1]!.getTotalValue(), 39);
      expect(character.attributes[1]!.getTotalBonus(), 3);

      // Skill
      expect(character.skills[38]!.getTotalValue(), 65);

      // Talent
      expect(character.talents[26]!.getMaxLvl(), 3);

      // Weapon
      expect(character.getMeleeWeapons()[0].getTotalSkillValue(), 65);
    });
  });
}

Future<Character> createTestCharacter() async {
  File file = File('assets/test/character_test.json');
  return await CharacterFactory().fromMap(jsonDecode(await file.readAsString()));
}
