import 'package:flutter/material.dart';
import '../theme/app_theme.dart'; 

class CloudiaryCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final bool isActive;

  const CloudiaryCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20.0), 
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: isDark ? CloudiaryTheme.darkCardBg : CloudiaryTheme.lightCardBg,
        borderRadius: BorderRadius.circular(16.0), 
        border: Border.all(
          color: isDark ? CloudiaryTheme.darkBorder : CloudiaryTheme.lightBorder,
          width: 1.0, 
        ),
        boxShadow: isActive ? CloudiaryTheme.activeShadow : CloudiaryTheme.defaultShadow,
      ),
      child: child,
    );
  }
}