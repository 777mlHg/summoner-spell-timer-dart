import 'package:flutter/material.dart';
import 'package:summoner_spell_timer/role_icon.dart';
import 'package:summoner_spell_timer/spell_button.dart';
import 'constants.dart';

class ReusableRoleCard extends StatelessWidget {
  ReusableRoleCard({this.roleName, this.summoners1, this.summoners2});

  final String roleName;
  final String summoners1;
  final String summoners2;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Expanded(
              child: IconContent(
            iconImage: kRoles[roleName]['image'],
            text: kRoles[roleName]['name'],
          )),
          Expanded(
              child: SpellWidgets(
            spellName: summoners1,
            role: roleName.toLowerCase() + '1',
          )),
          Expanded(
              child: SpellWidgets(
            spellName: summoners2,
            role: roleName.toLowerCase() + '2',
          )),
        ],
      ),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Color(0xFFE9C46A),
      ),
    );
  }
}
