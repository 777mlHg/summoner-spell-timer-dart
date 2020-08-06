import 'dart:async';
import 'package:flutter/material.dart';
import 'package:summoner_spell_timer/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SpellWidgets extends StatefulWidget {
  SpellWidgets({this.spellName, this.role});
  final String spellName;
  final String role;
  @override
  _SpellWidgetsState createState() => _SpellWidgetsState();
}

class _SpellWidgetsState extends State<SpellWidgets> {
  var _tapPosition; //touch position for _storePosition
  bool isTimerActive =
      false; // variable check if the timer on this widget is already active
  Timer _timer;
  int _start;
  String selectedSpell;
  @override
  void initState() {
    super.initState();
  }

  /// starts timer
  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
      setState(() {
        isTimerActive = false;
      });
    } else {
      _timer = new Timer.periodic(
        oneSec,
        (Timer timer) => setState(
          () {
            if (_start < 1) {
              timer.cancel();
              _timer = null;
              isTimerActive = false;
            } else if (_start > 0 && !isTimerActive) {
              isTimerActive = true;
              _start = _start - 1;
            } else {
              _start = _start - 1;
            }
          },
        ),
      );
    }
  }

  /// stores tap position
  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }

  /// change spell in shared preference
  Future<String> _changeSpell(String spell, String position) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(position, spell);
    return spell;
  }

//TODO: remove this
  void printPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    print(preferences.getKeys());
    print(preferences.get('top1'));
    print(selectedSpell);
  }

  /// this function displays a list of popup items of summoner spells
  void showOptions() {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();
    showMenu(
      //list of options
      items: [
        PopupMenuItem(
          child: FlatButton(
            onPressed: () {
              setState(() {
                _changeSpell(kSpells['barrier']['name'], widget.role);
                selectedSpell = 'barrier';
                _start = 0;
              });
            },
            child: Text(
              "Barrier",
            ),
          ),
        ),
        PopupMenuItem(
          child: FlatButton(
            onPressed: () {
              setState(() {
                _changeSpell(kSpells['clarity']['name'], widget.role);
                selectedSpell = 'clarity';
                _start = 0;
              });
            },
            child: Text(
              "Clarity",
            ),
          ),
        ),
        PopupMenuItem(
          child: FlatButton(
            onPressed: () {
              setState(() {
                _changeSpell(kSpells['cleanse']['name'], widget.role);
                selectedSpell = 'cleanse';
                _start = 0;
              });
            },
            child: Text(
              "Cleanse",
            ),
          ),
        ),
        PopupMenuItem(
          child: FlatButton(
            onPressed: () {
              setState(() {
                _changeSpell(kSpells['exhaust']['name'], widget.role);
                selectedSpell = 'exhaust';
                _start = 0;
              });
            },
            child: Text(
              "Exhaust",
            ),
          ),
        ),
        PopupMenuItem(
          child: FlatButton(
            onPressed: () {
              setState(() {
                _changeSpell(kSpells['flash']['name'], widget.role);
                selectedSpell = 'flash';
                _start = 0;
              });
            },
            child: Text(
              "Flash",
            ),
          ),
        ),
        PopupMenuItem(
          child: FlatButton(
            onPressed: () {
              setState(() {
                _changeSpell(kSpells['ghost']['name'], widget.role);
                selectedSpell = 'ghost';
                _start = 0;
              });
            },
            child: Text(
              "Ghost",
            ),
          ),
        ),
        PopupMenuItem(
          child: FlatButton(
            onPressed: () {
              setState(() {
                _changeSpell(kSpells['heal']['name'], widget.role);
                selectedSpell = 'heal';
                _start = 0;
              });
            },
            child: Text(
              "Heal",
            ),
          ),
        ),
        PopupMenuItem(
          child: FlatButton(
            onPressed: () {
              setState(() {
                _changeSpell(kSpells['ignite']['name'], widget.role);
                selectedSpell = 'ignite';
                _start = 0;
              });
            },
            child: Text(
              "Ignite",
            ),
          ),
        ),
        PopupMenuItem(
          child: FlatButton(
            onPressed: () {
              setState(() {
                _changeSpell(kSpells['smite']['name'], widget.role);
                selectedSpell = 'smite';
                _start = 0;
              });
            },
            child: Text(
              "Smite",
            ),
          ),
        ),
        PopupMenuItem(
          child: FlatButton(
            onPressed: () {
              setState(() {
                _changeSpell(kSpells['teleport']['name'], widget.role);
                selectedSpell = 'teleport';
                _start = 0;
              });
            },
            child: Text(
              "Teleport",
            ),
          ),
        ),
      ],
      context: context,
      position: RelativeRect.fromRect(
          _tapPosition & Size(40, 40), // smaller rect, the touch area
          Offset.zero & overlay.size // Bigger rect, the entire screen
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int spellCoolDown = selectedSpell is String
        ? kSpells[selectedSpell]['coolDown']
        : kSpells[widget.spellName]['coolDown'];
    // int spellCoolDown = 5;

    return SizedBox(
      height: 124,
      width: 72,
      child: Stack(
          alignment: Alignment.center,
          overflow: Overflow.clip,
          children: <Widget>[
            Image.asset(selectedSpell is String
                ? kSpells[selectedSpell]['image']
                : kSpells[widget.spellName]['image']),
            Container(
                child: isTimerActive
                    ? CircularProgressIndicator(
                        value: (_start / spellCoolDown).toDouble(),
                        strokeWidth: 60,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Color.fromRGBO(147, 100, 145, 100)),
                      )
                    : null),
            Container(
                child: isTimerActive
                    ? Text(
                        "$_start",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      )
                    : null),
            ClipPath(
              clipper: InvertedClipper(),
              child: Container(
                color: Color(0xFFE9C46A),
              ),
            ),
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTapDown: _storePosition, // store the position of a tap
                  onTap: () {
                    _start = spellCoolDown;
                    startTimer();
                  },
                  onLongPress: showOptions, // long press show more options
                ),
              ),
            ),
          ]),
    );
  }
}

class InvertedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..addRect(Rect.fromCenter(
          center: Offset(size.width / 2, size.height / 2),
          width: 68,
          height: 68))
      ..addRect(
        Rect.fromLTWH(0.0, 0.0, size.width, size.height),
      )
      ..fillType = PathFillType.evenOdd;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
