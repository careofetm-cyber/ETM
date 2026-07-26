import 'package:flutter/material.dart';
import 'package:etm_core/etm_core.dart';

class CompanyLogo extends StatelessWidget {
  final String? logoUrl;
  final String? companyName;
  final double size;
  final bool isCircular;
  final Color? backgroundColor;
  final Color? iconColor;

  const CompanyLogo({
    super.key,
    this.logoUrl,
    this.companyName,
    this.size = 48,
    this.isCircular = false,
    this.backgroundColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? AppColors.primaryLight;
    final fgColor = iconColor ?? AppColors.textInverse;

    if (logoUrl != null && logoUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(isCircular ? size / 2 : 8),
        child: Image.network(
          logoUrl!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _buildFallback(bgColor, fgColor),
        ),
      );
    }

    return _buildFallback(bgColor, fgColor);
  }

  Widget _buildFallback(Color bgColor, Color fgColor) {
    final initials = _getInitials();
    if (initials.isNotEmpty) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: bgColor,
          shape: isCircular ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: isCircular ? null : BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(
          initials,
          style: TextStyle(
            color: fgColor,
            fontSize: size * 0.4,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bgColor,
        shape: isCircular ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: isCircular ? null : BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Icon(
        Icons.directions_bus,
        size: size * 0.5,
        color: fgColor,
      ),
    );
  }

  String _getInitials() {
    if (companyName == null || companyName!.isEmpty) return '';
    final words = companyName!.trim().split(RegExp(r'\s+'));
    if (words.length >= 2) {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    }
    return words[0].substring(0, words[0].length.clamp(0, 2)).toUpperCase();
  }
}
