import 'package:battle_it_out/entities_localisation.dart';
import 'package:battle_it_out/interface/components/async_consumer.dart';
import 'package:battle_it_out/interface/components/padded_text.dart';
import 'package:battle_it_out/interface/components/searchbar/checkbox_search_bar.dart';
import 'package:battle_it_out/persistence/ancestry.dart';
import 'package:battle_it_out/persistence/skill/skill.dart';
import 'package:battle_it_out/persistence/skill/skill_group.dart';
import 'package:battle_it_out/providers/skill/skill_group_provider.dart';
import 'package:battle_it_out/providers/skill/skill_provider.dart';
import 'package:flutter/material.dart';

class EditAncestryScreen extends StatefulWidget {
  final Ancestry? ancestry;
  const EditAncestryScreen({super.key, this.ancestry});

  @override
  State<EditAncestryScreen> createState() => _EditAncestryScreenState();
}

class _EditAncestryScreenState extends State<EditAncestryScreen> {
  AncestryPartial ancestryPartial = AncestryPartial();
  List<Skill> skills = [];

  Future<void> getAsyncData() async {
    await widget.ancestry?.fetchSkills();
    await widget.ancestry?.fetchGroupSkills();
  }

  @override
  void initState() {
    super.initState();
    ancestryPartial = AncestryPartial.from(widget.ancestry);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: Text("${widget.ancestry != null ? "Edit" : "New"} Ancestry"),
      ),
      body: AsyncConsumer2<SkillGroupRepository, SkillRepository>(
        future: (skillGroupRepository, skillRepository) => getAsyncData(),
        builder: (SkillGroupRepository skillGroupRepository, SkillRepository skillRepository) {
          return ListView(shrinkWrap: true, padding: const EdgeInsets.all(10.0), children: [
            Center(child: LocalisedText("NAME", context, style: const TextStyle(fontSize: 24))),
            Container(
              alignment: Alignment.center,
              child: TextFormField(
                textAlign: TextAlign.center,
                initialValue: ancestryPartial.name != null ? ancestryPartial.name!.localise(context) : "",
                onChanged: (val) {},
                decoration: const InputDecoration(contentPadding: EdgeInsets.all(8)),
              ),
            ),
            SizedBox(
              height: 500,
              child: SearchBarCheckboxList(
                title: LocalisedText("SKILLS", context, style: const TextStyle(fontSize: 24)),
                items: [
                  ...skillRepository.items.map((Skill s) {
                    return CheckboxSearchListItem(
                        name: s.name.localise(context),
                        value: s,
                        img: 'assets/icon.png',
                        checked: widget.ancestry!.skills.contains(s));
                  }),
                  ...skillGroupRepository.items.map((SkillGroup s) {
                    return CheckboxSearchListItem(name: s.name.localise(context), value: s, img: 'assets/icon.png');
                  }),
                ],
              ),
            ),
          ]);
        },
      ),
      floatingActionButton: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
        if (widget.ancestry == null || !ancestryPartial.compareTo(widget.ancestry))
          FloatingActionButton(
            heroTag: "btn2",
            child: const Icon(Icons.save),
            onPressed: () {},
          ),
        const SizedBox(height: 10),
        if (widget.ancestry != null)
          FloatingActionButton(
            heroTag: "btn1",
            child: const Icon(Icons.delete),
            onPressed: () {},
          ),
      ]),
    );
  }
}
