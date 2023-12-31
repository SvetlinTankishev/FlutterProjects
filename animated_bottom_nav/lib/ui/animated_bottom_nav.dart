import 'package:flutter/material.dart';

class AnimatedBottomNav extends StatefulWidget {
  final int currentIndex;
  final List<BottomNavItem> items;
  final Function(int) onTap;

  const AnimatedBottomNav({
    super.key,
    required this.currentIndex,
    required this.items,
    required this.onTap,
  });

  @override
  State<AnimatedBottomNav> createState() => _AnimatedBottomNavState();
}

class _AnimatedBottomNavState extends State<AnimatedBottomNav>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<Offset>> _animations;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _controllers = List.generate(
        widget.items.length,
        (index) => AnimationController(
            duration: const Duration(milliseconds: 300), vsync: this));

    _animations = _controllers
        .map((controller) => Tween<Offset>(
              begin: const Offset(0, 0),
              end: const Offset(0, -0.1),
            ).animate(controller))
        .toList();

    _controllers[widget.currentIndex].value = 1.0;
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: widget.items.map(_buildNavItem).toList(),
      ),
    );
  }

  Widget _buildNavItem(BottomNavItem item) {
    int index = widget.items.indexOf(item);
    bool isSelected = widget.currentIndex == index;

    return GestureDetector(
      onTap: () => _handleNavItemTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        decoration: isSelected
            ? BoxDecoration(
                color: item.activeColor,
                borderRadius: BorderRadius.circular(30.0),
              )
            : null,
        child: SlideTransition(
          position: _animations[index],
          child: Icon(
            item.icon,
            color: isSelected ? Colors.white : item.inactiveColor,
          ),
        ),
      ),
    );
  }

  void _handleNavItemTap(int index) {
    setState(() {
      _controllers[widget.currentIndex].reverse();
      widget.onTap(index);
      _controllers[index].forward();
    });
  }
}

class BottomNavItem {
  final IconData icon;
  final Color activeColor;
  final Color inactiveColor;

  BottomNavItem({
    required this.icon,
    this.activeColor = Colors.blue,
    this.inactiveColor = Colors.grey,
  });
}
