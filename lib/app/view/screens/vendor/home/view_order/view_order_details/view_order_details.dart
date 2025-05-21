import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:local/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:local/app/view/common_widgets/custom_button/custom_button.dart';

class ViewOrderDetails extends StatefulWidget {
  const ViewOrderDetails({super.key});

  @override
  State<ViewOrderDetails> createState() => _ViewOrderDetailsState();
}

class _ViewOrderDetailsState extends State<ViewOrderDetails> {
  Duration remainingTime =
      const Duration(days: 1, hours: 20, minutes: 12, seconds: 40);
  Timer? _timer;

  Duration?
      _pendingExtension; // holds the currently requested extension duration

  @override
  void initState() {
    super.initState();
    _startCountdownTimer();
  }

  void _startCountdownTimer() {
    _timer?.cancel(); // Cancel any existing timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime.inSeconds <= 0) {
        timer.cancel();
      } else {
        setState(() {
          remainingTime = remainingTime - const Duration(seconds: 1);
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String twoDigits(int n) => n.toString().padLeft(2, '0');

  Future<void> _showDatePickerAndRequestExtension() async {
    final now = DateTime.now();
    final initialDate = now.add(remainingTime);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: initialDate,
      lastDate: now.add(const Duration(days: 365)),
    );

    if (pickedDate != null) {
      final currentDeliveryDate = now.add(remainingTime);
      if (pickedDate.isAfter(currentDeliveryDate)) {
        final addedDuration = pickedDate.difference(currentDeliveryDate);

        // Show confirmation dialog
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) {
            final addedDays = addedDuration.inDays;
            final addedHours = addedDuration.inHours % 24;
            final addedMinutes = addedDuration.inMinutes % 60;
            final addedSeconds = addedDuration.inSeconds % 60;

            return AlertDialog(
              title: const Text("Confirm Extension Request"),
              content: Text(
                "You want to request an extension of:\n"
                "$addedDays day(s), $addedHours hour(s), "
                "$addedMinutes minute(s), and $addedSeconds second(s).\n\n"
                "Vendor will review and accept your request soon.",
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text("Confirm"),
                ),
              ],
            );
          },
        );

        if (confirmed ?? false) {
          setState(() {
            _pendingExtension = addedDuration;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Extension request sent.")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text("Please select a date after current delivery date.")),
        );
      }
    }
  }

  void _cancelExtensionRequest() {
    setState(() {
      _pendingExtension = null;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Extension request cancelled.")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final days = remainingTime.inDays;
    final hours = remainingTime.inHours % 24;
    final minutes = remainingTime.inMinutes % 60;
    final seconds = remainingTime.inSeconds % 60;

    String formatDuration(Duration d) {
      final dDays = d.inDays;
      final dHours = d.inHours % 24;
      final dMinutes = d.inMinutes % 60;
      final dSeconds = d.inSeconds % 60;
      return "$dDays day(s), $dHours hour(s), $dMinutes minute(s), $dSeconds second(s)";
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        appBarContent: "Order Request",
        iconData: Icons.arrow_back,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Countdown Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CountdownBox(number: twoDigits(days), label: 'Days'),
                CountdownBox(number: twoDigits(hours), label: 'Hours'),
                CountdownBox(number: twoDigits(minutes), label: 'Min'),
                CountdownBox(number: twoDigits(seconds), label: 'Sec'),
              ],
            ),
            SizedBox(height: 25.h),

            // Show the pending extension request info if any
            if (_pendingExtension != null) ...[
              SizedBox(height: 25.h),
              Card(
                color: Colors.yellow[100],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Colors.orange, width: 1.5),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Extension request sent for:\n${formatDuration(_pendingExtension!)}\n"
                          "Vendor will review your request.",
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      TextButton(
                        onPressed: _cancelExtensionRequest,
                        child: const Text(
                          "Cancel Request",
                          style: TextStyle(color: Colors.red),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
            SizedBox(height: 25.h),

            CustomButton(
              isRadius: true,
              onTap: _showDatePickerAndRequestExtension,
              title: "Extend Delivery Date",
            ),
          ],
        ),
      ),
    );
  }
}

class CountdownBox extends StatelessWidget {
  final String number;
  final String label;

  const CountdownBox({super.key, required this.number, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.teal),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            number,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.teal,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          )
        ],
      ),
    );
  }
}
