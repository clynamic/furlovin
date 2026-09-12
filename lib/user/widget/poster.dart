import 'package:furlovin/routing/routing.dart';
import 'package:material_ui/material_ui.dart';

class Poster extends StatelessWidget {
  const Poster({super.key, required this.name, required this.child});

  final String? name;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final String? target = name;
    if (target == null) return child;
    return InkWell(onTap: () => context.openUser(target), child: child);
  }
}
