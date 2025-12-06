
<<<<<<< HEAD
=======
// import 'package:flutter/material.dart';

// class DotoriButton extends StatelessWidget {
//   final String text;
//   final VoidCallback onPressed;
//   final bool loading;
//   const DotoriButton({super.key, required this.text, required this.onPressed, this.loading=false});

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: double.infinity,
//       child: ElevatedButton(
//         onPressed: loading ? null : onPressed,
//         child: loading ? const SizedBox(width:16,height:16,child:CircularProgressIndicator(strokeWidth:2)) : Text(text),
//       ),
//     );
//   }
// }

// lib/widgets/dotori_button.dart

>>>>>>> clean-summary-2_flutter
import 'package:flutter/material.dart';

class DotoriButton extends StatelessWidget {
  final String text;
<<<<<<< HEAD
  final VoidCallback onPressed;
  final bool loading;
  const DotoriButton({super.key, required this.text, required this.onPressed, this.loading=false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        child: loading ? const SizedBox(width:16,height:16,child:CircularProgressIndicator(strokeWidth:2)) : Text(text),
      ),
=======
  final VoidCallback? onPressed;
  final bool loading;
  final bool outlined;
  final IconData? icon;

  /// 부모가 width를 관리하도록 변경된 안전한 버튼 위젯
  const DotoriButton({
    super.key,
    required this.text,
    this.onPressed,
    this.loading = false,
    this.outlined = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final btnChild = loading
        ? const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18),
                const SizedBox(width: 6),
              ],
              Text(
                text,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          );

    final elevatedStyle = ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );

    final outlinedStyle = OutlinedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      side: BorderSide(
        color: Colors.grey.shade400,
        width: 1.4,
      ),
    );

    ///  width: double.infinity 제거
    /// → 버튼 자체는 min width 유지
    /// → 전체폭 버튼이 필요하면 부모가 감싼다.
    if (outlined) {
      return OutlinedButton(
        onPressed: loading ? null : onPressed,
        style: outlinedStyle,
        child: btnChild,
      );
    }

    return ElevatedButton(
      onPressed: loading ? null : onPressed,
      style: elevatedStyle,
      child: btnChild,
>>>>>>> clean-summary-2_flutter
    );
  }
}
