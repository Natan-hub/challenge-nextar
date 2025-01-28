import 'package:challange_nextar/utils/colors.dart';
import 'package:flutter/material.dart';

class FabMenuButton extends StatefulWidget {
  final Function() onPressed;
  final Function() onPressed2;

  const FabMenuButton({
    super.key,
    required this.onPressed,
    required this.onPressed2,
  });

  @override
  State<FabMenuButton> createState() => _FabMenuButtonState();
}

class _FabMenuButtonState extends State<FabMenuButton>
    with SingleTickerProviderStateMixin {
  late AnimationController animation;
  final menuIsOpen = ValueNotifier<bool>(false);

  @override
  void initState() {
    animation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    super.initState();
  }

  @override
  void dispose() {
    animation.dispose();
    super.dispose();
  }

  toggleMenu() {
    menuIsOpen.value ? animation.reverse() : animation.forward();
    menuIsOpen.value = !menuIsOpen.value;
  }

  @override
  Widget build(BuildContext context) {
    return Flow(
      clipBehavior: Clip.none,
      delegate: FabVerticalDelegate(animation: animation),
      children: [
        FloatingActionButton(
          heroTag: "fab_main",
          backgroundColor: AppColors.primary,
          child: AnimatedIcon(
            icon: AnimatedIcons.menu_close,
            progress: animation,
          ),
          onPressed: () => toggleMenu(),
        ),
        FloatingActionButton(
          heroTag: "fab_filter",
          onPressed: widget.onPressed,
          backgroundColor: AppColors.primary2,
          child: const Icon(Icons.filter_list_rounded),
        ),
        FloatingActionButton(
          heroTag: "fab_add",
          onPressed: widget.onPressed2,
          backgroundColor: AppColors.primary2,
          child: const Icon(Icons.add_rounded),
        ),
      ],
    );
  }
}

class FabVerticalDelegate extends FlowDelegate {
  final AnimationController animation;

  FabVerticalDelegate({required this.animation}) : super(repaint: animation);

  @override
  void paintChildren(FlowPaintingContext context) {
    const buttonSize = 56;
    const buttonRadius = buttonSize / 2;
    const buttonMargin = 10;

    final positionX = context.size.width - buttonSize;
    final positionY = context.size.height - buttonSize;

    final lastFabIndex = context.childCount - 1;

    for (int i = lastFabIndex; i >= 0; i--) {
      final y = positionY - ((buttonSize + buttonMargin) * i * animation.value);
      final size = (i != 0) ? animation.value : 1.0;

      context.paintChild(
        i,
        transform: Matrix4.translationValues(positionX, y, 0)
          ..translate(buttonRadius, buttonRadius)
          ..scale(size)
          ..translate(-buttonRadius, -buttonRadius),
      );
    }
  }

  @override
  bool shouldRepaint(covariant FlowDelegate oldDelegate) => false;
}
