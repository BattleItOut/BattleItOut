import 'package:battle_it_out/entities_localisation.dart';
import 'package:battle_it_out/interface/themes.dart';
import 'package:battle_it_out/state_container.dart';
import 'package:flutter/material.dart';

AppBar applicationBar(String title) {
  return AppBar(
    leading: Builder(
      builder: (BuildContext context) {
        final ScaffoldState scaffold = Scaffold.of(context);
        final ModalRoute<Object?>? parentRoute = ModalRoute.of(context);
        final bool hasEndDrawer = scaffold.hasEndDrawer;
        final bool canPop = parentRoute?.canPop ?? false;

        if (hasEndDrawer && canPop) {
          return const BackButton();
        } else {
          return const SizedBox.shrink();
        }
      },
    ),
    centerTitle: true,
    title: Text(title),
  );
}

Drawer settingsDrawer(context) {
  return Drawer(
    child: ListView(
      children: [
        const DrawerHeader(
          child: Text('Battle It Out'),
        ),
        ListTile(
          title: Text("SET_POLISH".localise(context)),
          onTap: () {
            StateContainer.of(context).setLocale(const Locale("pl", ""));
          },
        ),
        ListTile(
          title: Text("SET_ENGLISH".localise(context)),
          onTap: () {
            StateContainer.of(context).setLocale(const Locale("en", ""));
          },
        ),
      ],
    )
  );
}