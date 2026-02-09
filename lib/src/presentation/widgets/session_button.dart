import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:keycloack_integrations/src/config/theme/colors.dart';

class SessionButton extends StatelessWidget {
  const SessionButton({
    super.key,
    required VoidCallback onPressed,
    required this.text,
    this.textSize,
  }) : _onPressed = onPressed;
  final VoidCallback _onPressed;
  final String text;
  final double? textSize;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _onPressed,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          height: 56.h,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColor.primary, Color(0xFF1A4A8C)],
            ),
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: AppColor.primary.withOpacity(0.4),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.key_rounded,
                    color: AppColor.white,
                    size: textSize ?? 16.sp,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: textSize ?? 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColor.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
