import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'reusable_role_cards.dart';

class InputPage extends StatefulWidget {
  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  Map<String, String> spellPreferences = {
    "top1": "teleport",
    "top2": "flash",
    "jungle1": "smite",
    "jungle2": "flash",
    "middle1": "ignite",
    "middle2": "flash",
    "bottom1": "heal",
    "bottom2": "flash",
    "support1": "ignite",
    "support2": "flash",
  };

  @override
  void initState() {
    super.initState();
    _loadSpellData();
  }

  _loadSpellData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      spellPreferences.forEach((key, value) {
        spellPreferences[key] = (preferences.getString(key) ?? value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Summoners Spell Timer'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: ReusableRoleCard(
              roleName: 'Top',
              summoners1: spellPreferences['top1'],
              summoners2: spellPreferences['top2'],
            ),
          ),
        ],
      ),
    );
  }
}
