import 'package:material_ui/material_ui.dart';

const Color scrimTop = Color(0x66000000);
const Color scrimShadow = Color(0xB3000000);

class TopScrim extends StatelessWidget {
  const TopScrim({super.key, this.height = 110});

  final double height;

  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: SizedBox(
      height: height,
      width: double.infinity,
      child: const DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [scrimTop, Color(0x00000000)],
          ),
        ),
      ),
    ),
  );
}

class ScrimBackButton extends StatelessWidget {
  const ScrimBackButton({super.key});

  @override
  Widget build(BuildContext context) => IconButton(
    tooltip: MaterialLocalizations.of(context).backButtonTooltip,
    onPressed: () => Navigator.maybePop(context),
    icon: const Icon(
      Icons.arrow_back,
      color: Colors.white,
      shadows: [Shadow(color: scrimShadow, blurRadius: 10)],
    ),
  );
}
