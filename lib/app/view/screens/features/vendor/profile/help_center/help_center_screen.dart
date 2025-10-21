import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../../utils/app_colors/app_colors.dart';
import '../../../../../../utils/enums/status.dart';
import '../../../../../common_widgets/custom_appbar/custom_appbar.dart';
import '../../../../../common_widgets/custom_loader/custom_loader.dart';
import '../../../../../common_widgets/custom_text/custom_text.dart';
import 'controller/support_controller.dart';
import 'model/support_model.dart';
import '../../../../../../global/helper/extension/extension.dart';

class HelpCenterScreen extends StatelessWidget {
  HelpCenterScreen({super.key});

  final SupportController supportController = Get.put(SupportController());
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
        appBarContent: 'Support Chat',
        iconData: Icons.arrow_back,
        isIcon: false,
        onTap: () => Navigator.of(context).maybePop(),
      ),
      body: Obx(() {
        switch (supportController.rxRequestStatus.value) {
          case Status.loading:
            return const CustomLoader();
          case Status.internetError:
            return _ErrorWidget(
              message: 'No Internet Connection',
              onRetry: supportController.getAllSupportMessages,
            );
          case Status.error:
            return _ErrorWidget(
              message: 'Error loading messages',
              onRetry: supportController.getAllSupportMessages,
            );
          case Status.completed:
            final thread = supportController.supportThread.value;
            if (thread == null || thread.messages == null || thread.messages!.isEmpty) {
              // If error, show error widget instead of empty state
              if (supportController.rxRequestStatus.value == Status.error) {
                return _ErrorWidget(
                  message: 'Failed to load support history. Please try again.',
                  onRetry: supportController.getAllSupportMessages,
                );
              }
              return _EmptyState(onCreate: () => _showCreateSupportBottomSheet(context));
            }
            return Column(
              children: [
                _ChatHeader(thread: thread),
                Expanded(
                  child: _ChatMessages(
                    thread: thread,
                    scrollController: _scrollController,
                  ),
                ),
                _CreateSupportButton(onPressed: () => _showCreateSupportBottomSheet(context)),
              ],
            );
        }
      }),
    );
  }

  void _showCreateSupportBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        expand: false,
        builder: (_, __) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: _NewTicketForm(bottomSheetContext: ctx),
        ),
      ),
    );
  }
}

class _ChatHeader extends StatelessWidget {
  final SupportThread thread;
  const _ChatHeader({required this.thread});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.brightCyan.withValues(alpha: .1),
        border: Border(
          bottom: BorderSide(color: AppColors.borderColor.withValues(alpha: .3)),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: AppColors.brightCyan,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              Icons.support_agent,
              color: AppColors.white,
              size: 24.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: thread.latestSubject ?? 'Support Chat',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Container(
                      width: 8.w,
                      height: 8.h,
                      decoration: BoxDecoration(
                        color: thread.isDismissed == false ? Colors.green : Colors.grey,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    CustomText(
                      text: thread.isDismissed == false ? 'Active' : 'Closed',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.darkNaturalGray,
                    ),
                    SizedBox(width: 12.w),
                    Icon(Icons.access_time, size: 12.sp, color: AppColors.darkNaturalGray),
                    SizedBox(width: 4.w),
                    CustomText(
                      text: thread.updatedAt?.getDateTime() ?? '',
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.darkNaturalGray,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatMessages extends StatelessWidget {
  final SupportThread thread;
  final ScrollController scrollController;
  const _ChatMessages({required this.thread, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.white, AppColors.brightCyan.withValues(alpha: .05)],
        ),
      ),
      child: ListView.builder(
        controller: scrollController,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        itemCount: thread.messages!.length,
        itemBuilder: (context, index) {
          final message = thread.messages![index];
          return _MessageBubble(message: message);
        },
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final SupportMessage message;
  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
  final isVendor = message.sender == 'vendor';
  final isClient = message.sender == 'client';
  // Vendor and Client: right, Other: left
  final alignRight = isVendor || isClient;
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        mainAxisAlignment: alignRight ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!alignRight) _Avatar(isMenIcon: false),
          if (!alignRight) SizedBox(width: 8.w),
          Flexible(
            child: Column(
              crossAxisAlignment: alignRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  decoration: BoxDecoration(
                    gradient: alignRight
                        ? LinearGradient(colors: [AppColors.brightCyan, AppColors.brightCyan.withValues(alpha: .8)])
                        : isClient
                            ? LinearGradient(colors: [Colors.orange, Colors.deepOrange])
                            : LinearGradient(colors: [Colors.grey[200]!, Colors.grey[100]!]),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16.r),
                      topRight: Radius.circular(16.r),
                      bottomLeft: alignRight ? Radius.circular(16.r) : Radius.circular(4.r),
                      bottomRight: alignRight ? Radius.circular(4.r) : Radius.circular(16.r),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: (alignRight
                                ? AppColors.brightCyan
                                : isClient
                                    ? Colors.orange
                                    : Colors.grey)
                            .withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: CustomText(
                    text: message.message ?? '',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: alignRight ? AppColors.white : AppColors.black,
                    maxLines: 100,
                  ),
                ),
                SizedBox(height: 4.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: CustomText(
                    text: message.sentAt?.getDateTime() ?? '',
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.darkNaturalGray.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          if (alignRight) SizedBox(width: 8.w),
          if (alignRight) _Avatar(isMenIcon: true),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final bool isMenIcon;
  const _Avatar({required this.isMenIcon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32.w,
      height: 32.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isMenIcon
              ? [AppColors.brightCyan, AppColors.brightCyan.withValues(alpha: .7)]
              : [Colors.orange, Colors.deepOrange],
        ),
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: (isMenIcon ? AppColors.brightCyan : Colors.orange).withValues(alpha: .3),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(
        isMenIcon ? Icons.person : Icons.support_agent,
        color: AppColors.white,
        size: 18.sp,
      ),
    );
  }
}

class _CreateSupportButton extends StatelessWidget {
  final VoidCallback onPressed;
  const _CreateSupportButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      color: AppColors.white,
      child: SafeArea(
        top: false,
        child: Container(
          height: 40.h,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.brightCyan, AppColors.brightCyan.withValues(alpha: .8)],
            ),
            borderRadius: BorderRadius.circular(9.r),
          ),
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 0),
              minimumSize: Size(0, 0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9.r),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_circle_outline, color: AppColors.white, size: 17.sp),
                SizedBox(width: 8.w),
                CustomText(
                  text: 'Create New Support',
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NewTicketForm extends StatelessWidget {
  final BuildContext? bottomSheetContext;
  _NewTicketForm({this.bottomSheetContext});
  final SupportController supportController = Get.find();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _FormHeader(),
          SizedBox(height: 24.h),
          _SubjectField(controller: supportController.subjectController),
          SizedBox(height: 16.h),
          _MessageField(controller: supportController.messageController),
          SizedBox(height: 24.h),
          _SendButton(bottomSheetContext: bottomSheetContext),
        ],
      ),
    );
  }
}

class _FormHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.brightCyan, AppColors.brightCyan.withValues(alpha: .8)],
        ),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              Icons.support_agent,
              color: AppColors.white,
              size: 32.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: 'Create Support Ticket',
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.white,
                ),
                SizedBox(height: 4.h),
                CustomText(
                  text: 'We\'re here to help you 24/7',
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.white.withValues(alpha: .9),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SubjectField extends StatelessWidget {
  final TextEditingController controller;
  const _SubjectField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.subject, size: 20.sp, color: AppColors.brightCyan),
            SizedBox(width: 8.w),
            CustomText(
              text: 'Subject',
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
          ],
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'e.g., Query about account',
            hintStyle: TextStyle(color: AppColors.darkNaturalGray.withValues(alpha: .5)),
            filled: true,
            fillColor: AppColors.brightCyan.withValues(alpha: .05),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: AppColors.borderColor.withValues(alpha: .3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: AppColors.brightCyan, width: 2),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          ),
        ),
      ],
    );
  }
}

class _MessageField extends StatelessWidget {
  final TextEditingController controller;
  const _MessageField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.message_outlined, size: 20.sp, color: AppColors.brightCyan),
            SizedBox(width: 8.w),
            CustomText(
              text: 'Message',
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
          ],
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: controller,
          maxLines: 6,
          decoration: InputDecoration(
            hintText: 'Describe your issue in detail...',
            hintStyle: TextStyle(color: AppColors.darkNaturalGray.withValues(alpha: .5)),
            filled: true,
            fillColor: AppColors.brightCyan.withValues(alpha: .05),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: AppColors.borderColor.withValues(alpha: .3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: AppColors.brightCyan, width: 2),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          ),
        ),
      ],
    );
  }
}

class _SendButton extends StatelessWidget {
  final BuildContext? bottomSheetContext;
  _SendButton({this.bottomSheetContext});
  final SupportController supportController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
      width: double.infinity,
      height: 52.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: supportController.isSending.value
              ? [Colors.grey, Colors.grey]
              : [AppColors.brightCyan, AppColors.brightCyan.withValues(alpha:0.8)],
        ),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.brightCyan.withValues(alpha: .3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: supportController.isSending.value
            ? null
            : () async {
                final subject = supportController.subjectController.text.trim();
                final message = supportController.messageController.text.trim();
                if (subject.isEmpty || message.isEmpty) {
                  EasyLoading.showInfo('Subject and message cannot be empty');
                  return;
                }
                await supportController.sendSupportMessage();
                if (bottomSheetContext != null) {
                  Navigator.of(bottomSheetContext!).pop();
                }
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        child: supportController.isSending.value
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20.h,
                    width: 20.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  CustomText(
                    text: 'Sending...',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.send, color: AppColors.white, size: 20.sp),
                  SizedBox(width: 12.w),
                  CustomText(
                    text: 'Send Message',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ],
              ),
      ),
    ));
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onCreate;
  const _EmptyState({required this.onCreate});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(24.r),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.brightCyan.withValues(alpha: .1),
                        AppColors.brightCyan.withValues(alpha: .05),
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.support_agent,
                    size: 80.sp,
                    color: AppColors.brightCyan,
                  ),
                ),
                SizedBox(height: 24.h),
                CustomText(
                  text: 'No Support History',
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                ),
                SizedBox(height: 8.h),
                CustomText(
                  text: 'Create a support ticket to get started',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.darkNaturalGray,
                ),
              ],
            ),
          ),
        ),
        _CreateSupportButton(onPressed: onCreate),
      ],
    );
  }
}

class _ErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorWidget({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onRetry,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 60.sp,
              color: Colors.red,
            ),
            SizedBox(height: 16.h),
            CustomText(
              text: message,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.black,
            ),
            SizedBox(height: 8.h),
            CustomText(
              text: 'Tap to retry',
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.darkNaturalGray,
            ),
          ],
        ),
      ),
    );
  }
}
