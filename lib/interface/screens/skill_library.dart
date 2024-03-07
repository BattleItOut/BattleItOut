import 'package:battle_it_out/entities_localisation.dart';
import 'package:battle_it_out/interface/components/async_consumer.dart';
import 'package:battle_it_out/interface/components/padded_text.dart';
import 'package:battle_it_out/interface/components/searchbar/list_search_bar.dart';
import 'package:battle_it_out/persistence/skill/skill.dart';
import 'package:battle_it_out/persistence/skill/skill_group.dart';
import 'package:battle_it_out/providers/skill_group_provider.dart';
import 'package:battle_it_out/providers/skill_provider.dart';
import 'package:flutter/material.dart';

class SkillLibrary extends StatelessWidget {
  const SkillLibrary({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AsyncConsumer2<SkillGroupProvider, SkillProvider>(builder: (
        SkillGroupProvider skillGroupProvider,
        SkillProvider skillProvider,
      ) {
        return ListView(shrinkWrap: true, padding: const EdgeInsets.all(10.0), children: [
          SizedBox(
            height: 1000,
            child: SearchList(
              title: LocalisedText("SKILLS", context, style: const TextStyle(fontSize: 24)),
              items: [
                ...skillProvider.items.map((Skill s) {
                  return SearchListItem(name: s.name.localise(context), value: s, img: 'assets/icon.png');
                }),
                ...skillGroupProvider.items.map((SkillGroup s) {
                  return SearchListItem(name: s.name.localise(context), value: s, img: 'assets/icon.png');
                }),
              ],
            ),
          ),
        ]);
      }),
    );
  }
}
