import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:motogen/core/constants/app_colors.dart';
import 'package:motogen/core/constants/app_icons.dart';
import 'package:url_launcher/url_launcher.dart';

class AiMessageBubble extends StatelessWidget {
  final String aiMessage;
  const AiMessageBubble({super.key, required this.aiMessage});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 17.h),
        child: Row(
          children: [
            SizedBox(width: 23.w),
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  constraints: BoxConstraints(maxWidth: 0.6.sw),
                  padding: EdgeInsets.only(
                    top: 7.h,
                    bottom: 7.h,
                    right: 16.w,
                    left: 16.w,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.blue400,
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: MarkdownBody(
                      data: aiMessage,
                      styleSheet:
                          MarkdownStyleSheet.fromTheme(
                            Theme.of(context),
                          ).copyWith(
                            p: TextStyle(
                              color: const Color(0xFFF7FBF1),
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.3,
                              height: 1.5,
                            ),
                            blockquoteDecoration: BoxDecoration(
                              color: Colors.transparent, // no background
                            ),
                            blockquotePadding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 4.h,
                            ),
                            blockquote: TextStyle(
                              color: const Color(0xFFF7FBF1),
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                      selectable: true,
                      onTapLink: (text, href, title) async {
                        if (href != null) {
                          final uri = Uri.parse(href);
                          if (!await launchUrl(
                            uri,
                            mode: LaunchMode.externalApplication,
                          )) {
                            throw 'Could not launch $uri';
                          }
                        }
                      },
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: -4.7.w,
                  child: SvgPicture.asset(
                    AppIcons.blueTailLeft,
                    width: 20.w,
                    height: 14.h,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
