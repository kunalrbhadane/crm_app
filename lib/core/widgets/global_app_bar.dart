import 'package:flutter/material.dart';

class GlobalAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final String? titleText; // Helper for simple text titles
  final Color? backgroundColor;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final TextStyle? titleStyle;
  final double elevation;
  final IconThemeData? iconTheme;

  const GlobalAppBar({
    super.key,
    this.title,
    this.titleText,
    this.backgroundColor = const Color(0xFF4A89F5), // Default Blue
    this.actions,
    this.leading,
    this.centerTitle = false,
    this.titleStyle,
    this.elevation = 0,
    this.iconTheme,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: elevation,
      centerTitle: centerTitle,
      iconTheme: iconTheme,
      leading: leading,
      actions: actions,
      title: title ?? 
        (titleText != null 
          ? Text(
              titleText!, 
              style: titleStyle ?? const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              )
            ) 
          : null),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
