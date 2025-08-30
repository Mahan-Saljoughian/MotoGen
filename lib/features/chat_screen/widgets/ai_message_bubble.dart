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
    final theme = Theme.of(context);
    final aiChatColor = const Color(0xFFF7FBF1);
    final baseStyle = TextStyle(
      color: aiChatColor,
      letterSpacing: 0.3,
      height: 1.5.h,
    );
    TextStyle? heading(TextStyle? original, double size, FontWeight weight) =>
        original?.copyWith(
          color: aiChatColor,
          letterSpacing: 0.3,
          height: 1.5.h,
          fontSize: size,
          fontWeight: weight,
        );
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
                  constraints: BoxConstraints(maxWidth: 0.7.sw),
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
                      styleSheet: MarkdownStyleSheet.fromTheme(theme).copyWith(
                        p: baseStyle.copyWith(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        h1: heading(
                          theme.textTheme.headlineLarge,
                          16.sp,
                          FontWeight.w800,
                        ),
                        h2: heading(
                          theme.textTheme.headlineMedium,
                          16.sp,
                          FontWeight.w800,
                        ),
                        h3: heading(
                          theme.textTheme.headlineSmall,
                          14.sp,
                          FontWeight.w700,
                        ),
                        h4: heading(
                          theme.textTheme.titleLarge,
                          14.sp,
                          FontWeight.w700,
                        ),
                        h5: heading(
                          theme.textTheme.titleMedium,
                          12.sp,
                          FontWeight.w600,
                        ),
                        h6: heading(
                          theme.textTheme.titleSmall,
                          12.sp,
                          FontWeight.w600,
                        ),
                        listBullet: baseStyle,
                        tableHead: baseStyle.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 13.sp,
                          color: aiChatColor,
                        ),
                        tableBody: baseStyle.copyWith(
                          fontSize: 12.sp,
                          color: aiChatColor,
                        ),
                        tableCellsPadding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 6.h,
                        ),
                        tableBorder: TableBorder.all(
                          color: Colors.white,
                          width: 1,
                        ),

                        // QUOTES
                        blockquoteDecoration: const BoxDecoration(
                          color: Colors.transparent,
                        ),
                        blockquotePadding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        blockquote: baseStyle.copyWith(
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
