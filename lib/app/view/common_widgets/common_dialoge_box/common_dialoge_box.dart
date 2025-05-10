import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommonDialogBox{
  static void showAboutUs(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding:  EdgeInsets.all(20.r),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text("About Us"),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Handle "About Us" tap
                    Navigator.pop(context);
                  },
                ),
                const Divider(),
                ListTile(
                  title: const Text("Privacy Policy"),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Handle "Privacy Policy" tap
                    Navigator.pop(context);
                  },
                ),
                const Divider(),
                ListTile(
                  title: const Text("Terms of Service"),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Handle "Terms of Service" tap
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}