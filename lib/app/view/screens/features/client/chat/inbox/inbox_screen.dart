import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:local/app/core/route_path.dart';
import 'package:local/app/global/helper/extension/extension.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/utils/app_constants/app_constants.dart';
import 'package:local/app/utils/app_strings/app_strings.dart';
import 'package:local/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:local/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:local/app/view/common_widgets/message_card/message_card.dart';
import 'package:local/app/view/common_widgets/bottom_navigation_bar/client_nav_bar/nav_bar.dart';
import 'package:local/app/view/screens/features/client/chat/inbox/controller/conversation_controller.dart';
import 'package:local/app/view/screens/features/client/chat/inbox/widgets/empty_conversations.dart';
import 'package:local/app/view/screens/features/client/chat/inbox/widgets/inbox_loader.dart';

class InboxScreen extends StatelessWidget {
  InboxScreen({super.key});

  final controller = Get.find<ConversationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      bottomNavigationBar: CustomNavBar(currentIndex: 2),
      appBar: const CustomAppBar(
        appBarContent: AppStrings.chatList,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: 'All Message',
              font: CustomFont.inter,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.darkNaturalGray,
            ),
            SizedBox(height: 16.h),
            Expanded(
              child: RefreshIndicator(
                color: AppColors.brightCyan,
                backgroundColor: AppColors.white,
                onRefresh: () async {
                  await controller.loadConversations();
                },
                child: Obx(
                  () {
                    final conversations = controller.conversationList;
                    // sort by updatedAt descending
                    conversations.sort((a, b) {
                      final aTime = controller.parseDate(a.updatedAt) ??
                          DateTime.fromMillisecondsSinceEpoch(0);
                      final bTime = controller.parseDate(b.updatedAt) ??
                          DateTime.fromMillisecondsSinceEpoch(0);
                      return bTime.compareTo(aTime);
                    });

                    if (controller.isLoading.value) {
                      return InboxLoader();
                    }

                    if (conversations.isEmpty) {
                      return EmptyConversations(controller: controller);
                    }
                    return ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: conversations.length,
                      itemBuilder: (context, index) {
                        final convo = conversations[index];
                        final hasMembers = convo.members.isNotEmpty;
                        final member = hasMembers ? convo.members.first : null;

                        final image= member?.profile?.id?.image ?? AppConstants.demoImage;
                        final receiverRole = member?.profile?.role ?? 'Unknown';
                        final receiverName = member?.profile?.id?.name ?? 'Unknown';
                        final senderId = member?.id ?? '';
                        final messageText =
                            convo.latestMessage?.toString() ?? '';
                        final lastdateTime = convo.updatedAt?.getDateTime();

                        return Padding(
                          padding: EdgeInsets.only(top: 10.h),
                          child: MessageCard(
                            imageUrl: image,
                            senderName: receiverName,
                            message: messageText,
                            lastMessageTime: lastdateTime,
                            onTap: () async {
                              debugPrint(
                                  'Tapped conversation ID: ${convo.id}\nSender ID: $senderId');
                              // open chat screen and wait until it's popped
                               context.pushNamed(
                                RoutePath.chatScreen,
                                extra: {
                                  'receiverRole': receiverRole,
                                  'receiverName': receiverName,
                                  'receiverImage': image,
                                  'conversationId': convo.id,
                                  'userId': senderId,
                                },
                              );
                              // refresh conversations to pick up lastMessage updates
                              try {
                                await controller.loadConversations();
                              } catch (_) {
                                controller.conversationList.refresh();
                              }
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
