import 'package:flutter/cupertino.dart';

import '../core/const_value_manager.dart';

class LampaderColorWidget extends StatelessWidget {
  const LampaderColorWidget({
    super.key,
    required this.isSelected,
    required this.color,
  });

  final bool isSelected;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return AnimatedContainer(
      duration:
          const Duration(milliseconds: ConstValueManager.durationColorWidget),
      width: ConstValueManager.widthColorWidget,
      height: isSelected ? size.height / 4.2 : size.height / 6,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(isSelected ? .5 : .25),
            color,
          ],
          begin: Alignment.topCenter,
        ),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(
            ConstValueManager.radiosColorWidget,
          ),
        ),
      ),
    );
  }
}
