import 'package:meta/meta.dart';

const String smilieSheet = '/themes/beta/img/sprite_smilies.png';

const double smilieSheetWidth = 134;
const double smilieSheetHeight = 175;

@immutable
class Smilie {
  const Smilie({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
  });

  final double x;
  final double y;
  final double width;
  final double height;
}

const Map<String, Smilie> smilies = {
  'angel': Smilie(x: 27, y: 47, width: 26, height: 28),
  'badhairday': Smilie(x: 0, y: 47, width: 26, height: 27),
  'cd': Smilie(x: 0, y: 24, width: 26, height: 22),
  'coffee': Smilie(x: 27, y: 0, width: 26, height: 20),
  'cool': Smilie(x: 0, y: 0, width: 26, height: 23),
  'crying': Smilie(x: 27, y: 147, width: 26, height: 23),
  'derp': Smilie(x: 108, y: 123, width: 26, height: 23),
  'dunno': Smilie(x: 81, y: 123, width: 26, height: 23),
  'embarrassed': Smilie(x: 54, y: 123, width: 26, height: 23),
  'evil': Smilie(x: 0, y: 147, width: 26, height: 28),
  'gift': Smilie(x: 27, y: 123, width: 26, height: 23),
  'huh': Smilie(x: 0, y: 123, width: 26, height: 23),
  'lmao': Smilie(x: 108, y: 99, width: 26, height: 23),
  'love': Smilie(x: 81, y: 99, width: 26, height: 23),
  'nerd': Smilie(x: 54, y: 99, width: 26, height: 23),
  'note': Smilie(x: 55, y: 148, width: 22, height: 23),
  'oooh': Smilie(x: 27, y: 99, width: 26, height: 23),
  'pleased': Smilie(x: 0, y: 99, width: 26, height: 23),
  'rollingeyes': Smilie(x: 108, y: 75, width: 26, height: 23),
  'sad': Smilie(x: 81, y: 75, width: 26, height: 23),
  'sarcastic': Smilie(x: 54, y: 75, width: 26, height: 23),
  'serious': Smilie(x: 27, y: 75, width: 26, height: 23),
  'sleepy': Smilie(x: 0, y: 75, width: 26, height: 23),
  'smile': Smilie(x: 108, y: 47, width: 26, height: 23),
  'teeth': Smilie(x: 81, y: 47, width: 26, height: 23),
  'tongue': Smilie(x: 54, y: 47, width: 26, height: 23),
  'veryhappy': Smilie(x: 108, y: 24, width: 26, height: 23),
  'whatever': Smilie(x: 79, y: 148, width: 26, height: 23),
  'wink': Smilie(x: 81, y: 24, width: 26, height: 23),
  'yelling': Smilie(x: 54, y: 24, width: 26, height: 23),
  'zipped': Smilie(x: 27, y: 24, width: 26, height: 23),
};
