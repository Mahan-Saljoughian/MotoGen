/*  import 'package:book_reminder/core/constants/app_icons.dart';
import 'package:book_reminder/providers/login_provider.dart';
import 'package:book_reminder/views/createAccountPage/widgets/custom_text_input.dart';
import 'package:book_reminder/views/widgets/custom_login_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as context;
import 'package:provider/provider.dart';

class LoginWithEmailPage extends StatefulWidget {
  const LoginWithEmailPage({Key? key}) : super(key: key);

  @override
  State<LoginWithEmailPage> createState() => _LoginWithEmailPageState();
}

class _LoginWithEmailPageState extends State<LoginWithEmailPage> {
  final TextEditingController emailController = TextEditingController();

  bool get isEmailValid => RegExp(r"^[\w\.\-]+@([\w\-]+\.)+[a-zA-Z]{2,}$").hasMatch(emailController.text);

  @override
  void initState() {
    super.initState();
    emailController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BrownColors.brown_50,
      appBar: AppBar(
        // background and elevation for clean look
        backgroundColor: BrownColors.brown_50,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black, size: 22.sp),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: SingleChildScrollView(
            // Keeps content centered even with keyboard
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 47.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Log in with Email',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24.sp, fontFamily: 'SFProDisplay'),
                  ),
                  SizedBox(height: 35.h),
                  Text(
                    'Email address',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: GreyColors.grey_600,
                      fontFamily: 'SFProDisplay',
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      CustomTextInput(controller: emailController, hintText: 'Email address', isPassword: false),
                      if (isEmailValid && emailController.text.isNotEmpty)
                        Padding(padding: EdgeInsets.only(right: 10.w), child: SvgPicture.asset(AppIcons.tickCircle)),
                    ],
                  ),
                  SizedBox(height: 18.h),

                  SizedBox(height: 25.h),
                  Center(
                    child: CustomLoginButton(
                      text: 'Log in',
                      onTap: () {
                        context.read<LoginProvider>().onLoginSecondTap(context, emailController.text.trim());
                      },
                      backgroundColor: VioletColors.violet_500,
                      textColor: VioletColors.violet_50,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
  */
