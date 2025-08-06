// import 'package:flutter/material.dart';

// class CustomButton extends StatelessWidget {
//   final String text;
//   final VoidCallback? onPressed;
//   final bool outlined;
//   final bool loading;

//   const CustomButton({
//     super.key,
//     required this.text,
//     this.onPressed,
//     this.outlined = false,
//     this.loading = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     if (outlined) {
//       return OutlinedButton(
//         onPressed: loading ? null : onPressed,
//         style: OutlinedButton.styleFrom(
//           side: BorderSide(color: Theme.of(context).primaryColor, width: 2),
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//           padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//         ),
//         child: loading
//           ? const SizedBox(
//               width: 20,
//               height: 20,
//               child: CircularProgressIndicator(strokeWidth: 2)
//             )
//           : Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
//       );
//     }

//     return ElevatedButton(
//       onPressed: loading ? null : onPressed,
//       child: loading
//         ? const SizedBox(
//             width: 20,
//             height: 20,
//             child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)
//           )
//         : Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
//     );
//   }
// }

import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool outlined;
  final bool loading;
  final IconData? icon;
  final bool gradient;
  final Color? color;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.outlined = false,
    this.loading = false,
    this.icon,
    this.gradient = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    if (outlined) {
      return _buildOutlinedButton(context);
    }

    if (gradient) {
      return _buildGradientButton(context);
    }

    return _buildElevatedButton(context);
  }

  Widget _buildGradientButton(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.gradientStart, AppTheme.gradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: loading ? null : onPressed,
          borderRadius: BorderRadius.circular(28),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (loading)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                else ...[
                  if (icon != null) ...[
                    Icon(icon, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOutlinedButton(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        border: Border.all(
          color: color ?? AppTheme.primaryColor,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(28),
        color: Colors.white,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: loading ? null : onPressed,
          borderRadius: BorderRadius.circular(28),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (loading)
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: color ?? AppTheme.primaryColor,
                    ),
                  )
                else ...[
                  if (icon != null) ...[
                    Icon(
                      icon,
                      color: color ?? AppTheme.primaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: color ?? AppTheme.primaryColor,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildElevatedButton(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: color ?? AppTheme.primaryColor,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: (color ?? AppTheme.primaryColor).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: loading ? null : onPressed,
          borderRadius: BorderRadius.circular(28),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (loading)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                else ...[
                  if (icon != null) ...[
                    Icon(icon, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
