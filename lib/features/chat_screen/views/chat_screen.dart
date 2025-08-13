import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:motogen/core/constants/app_colors.dart';
import 'package:motogen/features/chat_screen/model/chat_message.dart';
import 'package:motogen/features/chat_screen/viewmodels/chat_controller.dart';
import 'package:motogen/features/chat_screen/viewmodels/chat_notifier.dart';
import 'package:motogen/features/chat_screen/widgets/ai_loading_animation.dart';
import 'package:motogen/features/chat_screen/widgets/ai_message_bubble.dart';
import 'package:motogen/features/chat_screen/widgets/prompt_input.dart';
import 'package:motogen/features/chat_screen/widgets/suggestion_question.dart';
import 'package:motogen/features/chat_screen/widgets/user_message_bubble.dart';

class ChatScreen extends ConsumerWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatState = ref.watch(chatNotifierProvider);
    final controller = ref.watch(chatControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.blue50,
      body: Padding(
        padding: EdgeInsets.only(top: 20.h),
        child: Center(
          child: Column(
            children: [
              Text(
                "چت‌بات",
                style: TextStyle(
                  color: AppColors.blue500,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),

              if (chatState.messages.isEmpty) ...[
                Spacer(),
                Text(
                  "سوالات پیشنهادی",
                  style: TextStyle(
                    color: AppColors.blue500,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8.h),
                for (String question
                    in ref
                        .read(chatNotifierProvider.notifier)
                        .suggestionQuestions)
                  SuggestionQuestion(
                    prompt: question,
                    onPressed: () {
                      /*  ref.read(chatControllerProvider).textController.text =
                          question; */
                      ref
                          .read(chatNotifierProvider.notifier)
                          .sendUserMessage(question);
                    },
                  ),

                SizedBox(height: 9.h),
              ],

              if (chatState.messages.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    controller: controller.scrollController,
                    reverse: true,
                    itemCount:
                        chatState.messages.length +
                        (chatState.isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (chatState.isLoading && index == 0) {
                        return Padding(
                          padding: EdgeInsets.only(left: 23.w, bottom: 18.h),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: AiLoadingAnimation(),
                          ),
                        );
                      } else {
                        final messageIndex = chatState.isLoading
                            ? chatState.messages.length - index
                            : chatState.messages.length - 1 - index;
                        final message = chatState.messages[messageIndex];
                        return message.sender == MessageSender.user
                            ? UserMessageBubble(textMessage: message.text)
                            : AiMessageBubble(aiMessage: message.text);
                      }
                    },
                  ),
                ),

              PromptInput(
                controller: controller.textController,
                onSend: () {
                  final text = controller.textController.text.trim();
                  if (text.isEmpty) return;
                  ref.read(chatNotifierProvider.notifier).sendUserMessage(text);
                  controller.clearText();
                  Future.delayed(const Duration(milliseconds: 100), () {
                    controller.scrollController.animateTo(
                      0.0,
                      duration: Duration(milliseconds: 250),
                      curve: Curves.easeOut,
                    );
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
