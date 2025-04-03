import 'package:flutter/material.dart';

/// Custom app card widget
class AppCard extends StatelessWidget {
  /// Constructor
  const AppCard({
    Key? key,
    required this.child,
    this.onTap,
    this.padding,
    this.margin,
    this.color,
    this.borderRadius,
    this.elevation,
    this.width,
    this.height,
    this.borderColor,
  }) : super(key: key);

  /// Card content
  final Widget child;

  /// Optional tap handler
  final VoidCallback? onTap;
  
  /// Card padding
  final EdgeInsetsGeometry? padding;
  
  /// Card margin
  final EdgeInsetsGeometry? margin;
  
  /// Card background color
  final Color? color;
  
  /// Card border radius
  final BorderRadius? borderRadius;
  
  /// Card elevation
  final double? elevation;
  
  /// Card width
  final double? width;
  
  /// Card height
  final double? height;
  
  /// Card border color
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final effectiveRadius = borderRadius ?? BorderRadius.circular(16);
    
    Widget cardContent = Padding(
      padding: padding ?? const EdgeInsets.all(16),
      child: child,
    );
    
    if (width != null || height != null) {
      cardContent = SizedBox(
        width: width,
        height: height,
        child: cardContent,
      );
    }
    
    return Card(
      margin: margin ?? const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: effectiveRadius,
        side: borderColor != null 
            ? BorderSide(color: borderColor!)
            : BorderSide.none,
      ),
      color: color,
      elevation: elevation,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: effectiveRadius,
        child: cardContent,
      ),
    );
  }
}
