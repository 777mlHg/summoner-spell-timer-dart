import 'dart:async';
import 'package:flutter/material.dart';
import 'package:summoner_spell_timer/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SpellWidgets extends StatefulWidget {
  SpellWidgets({this.spellName});
  final String spellName;
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

  void showOptions() {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();
    showMenu( 
      items: [
        PopupMenuItem( 
          child: FlatButton(
            onPressed: () {},
            child: Text(
              "Flat Button",
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

  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }

  _changeSpell(String spell, String position) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(position, spell);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: int spellCoolDown = kSpells[widget.spellName]['coolDown'];
    int spellCoolDown = 5;

    selectedSpell = widget.spellName;

    return SizedBox(
      height: 124,
      width: 72,
      child: Stack(
          alignment: Alignment.center,
          overflow: Overflow.clip,
          children: <Widget>[
            Image.asset(
              kSpells[selectedSpell]['image'],
            ),
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
              clipper: InvertedCircleClipper(),
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

class InvertedCircleClipper extends CustomClipper<Path> {
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
