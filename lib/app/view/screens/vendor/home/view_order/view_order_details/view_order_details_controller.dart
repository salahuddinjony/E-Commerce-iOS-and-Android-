import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local/app/services/api_client.dart';
import 'package:local/app/services/app_url.dart';
import 'package:local/app/view/screens/vendor/orders/models/custom_order_response_model.dart';

class ViewOrderDetailsController extends GetxController {
  ViewOrderDetailsController(this._initialOrder);

  final Order _initialOrder;

  final remainingTime = const Duration().obs;
  final pendingExtension = Rxn<Duration>();
  final order = Rxn<Order>();

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    order.value = _initialOrder;
    _setInitialRemainingTime();
    _startCountdownTimer();
  }

  void _setInitialRemainingTime() {
    final d = order.value?.deliveryDate;
    if (d != null) {
      final now = DateTime.now();
      final diff = d.toLocal().difference(now.toLocal());
      remainingTime.value = diff.isNegative ? Duration.zero : diff;
    } else {
      remainingTime.value = Duration.zero;
    }
  }

  void _startCountdownTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime.value.inSeconds <= 0) {
        timer.cancel();
      } else {
        remainingTime.value = remainingTime.value - const Duration(seconds: 1);
      }
    });
  }

  String twoDigits(int n) => n.toString().padLeft(2, '0');

  String formatDuration(Duration d) {
    final dDays = d.inDays;
    final dHours = d.inHours % 24;
    final dMinutes = d.inMinutes % 60;
    final dSeconds = d.inSeconds % 60;
    return "$dDays day(s), $dHours hour(s), $dMinutes minute(s), $dSeconds second(s)";
  }

  Future<void> pickAndRequestExtension(BuildContext context) async {
    // If an extension request already exists locally (or mapped from server), block UI.
    if (pendingExtension.value != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("An extension request is already pending.")),
      );
      return;
    }

    final now = DateTime.now().toLocal();
    final currentDeliveryDate = order.value?.deliveryDate?.toLocal() ?? now.add(remainingTime.value);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: currentDeliveryDate.isAfter(now) ? currentDeliveryDate : now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (pickedDate == null) return;
    if (!pickedDate.isAfter(currentDeliveryDate)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Select a date after current delivery: ${currentDeliveryDate.toString().split(' ').first}",
          ),
        ),
      );
      return;
    }

    // Only calculate when we are allowed to request.
    final addedDuration = pickedDate.difference(currentDeliveryDate);
    final addedDays = addedDuration.inDays;
    final addedHours = addedDuration.inHours % 24;
    final addedMinutes = addedDuration.inMinutes % 60;
    final addedSeconds = addedDuration.inSeconds % 60;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        final reasonController = TextEditingController();
        return StatefulBuilder(
          builder: (context, setState) {
            const maxChars = 200;
            final charCount = reasonController.text.length;
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Row(
          children: [
            const Icon(Icons.schedule_outlined),
            const SizedBox(width: 8),
            const Expanded(child: Text("Extension Request")),
          ],
              ),
              content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(.08),
            borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "New proposed delivery date:",
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 16),
                  const SizedBox(width: 6),
                  Text(
              "${pickedDate.toLocal().toString().split(' ').first}",
              style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                "Time to add:",
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const SizedBox(height: 4),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (addedDays > 0)
              _DurationChip(label: "$addedDays day${addedDays == 1 ? '' : 's'}"),
                  if (addedHours > 0)
              _DurationChip(label: "$addedHours hour${addedHours == 1 ? '' : 's'}"),
                  if (addedMinutes > 0)
              _DurationChip(label: "$addedMinutes min"),
                  if (addedSeconds > 0 && addedDays == 0 && addedHours == 0)
              _DurationChip(label: "$addedSeconds sec"),
                ],
              ),
            ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Reason (optional)",
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const SizedBox(height: 6),
              TextField(
                controller: reasonController,
                maxLines: 3,
                maxLength: maxChars,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
            hintText: "Add helpful context for review",
            filled: true,
            fillColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(.3),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            counterText: "$charCount / $maxChars",
                ),
              ),
              const SizedBox(height: 4),
              if (charCount > maxChars)
                Text(
            "Too long. Please shorten.",
            style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 12),
                ),
            ],
          ),
              ),
              actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              actions: [
            Row(
            children: [
              Expanded(
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pop(context, false),
                icon: const Icon(Icons.close, size: 18),
                label: const Text("Cancel"),
                style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                side: BorderSide(
                  color: Theme.of(context).colorScheme.outline.withOpacity(.6),
                ),
                foregroundColor: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              ),
              const SizedBox(width: 12),
              Expanded(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.check_circle_outline, size: 20),
                onPressed: charCount > maxChars
                  ? null
                  : () {
                    // TODO: pass reasonController.text to API body if needed.
                    Navigator.pop(context, true);
                  },
                label: const Text("Confirm"),
                style: ElevatedButton.styleFrom(
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                textStyle: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              ),
            ],
            ),
              ],
            );
          },
        );
      },
    );
    if (confirmed ?? false) {
      // Do NOT set pendingExtension here yet. Wait for API success.
      await _requestDeadlineExtension(context, pickedDate);
    }
  }

  void cancelExtensionRequest(BuildContext context) {
    pendingExtension.value = null;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Extension request cancelled.")),
    );
  }

  Future<void> _requestDeadlineExtension(BuildContext context, DateTime pickedDate) async {
    // Removed early local duplicate guard; pickAndRequestExtension already prevents this.

    final currentDelivery = order.value?.deliveryDate;
    if (currentDelivery == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No delivery date found.")),
      );
      return;
    }

    String two(int v) => v.toString().padLeft(2, '0');
    final newDateStr = "${pickedDate.year}-${two(pickedDate.month)}-${two(pickedDate.day)}";

    final body = {
      "lastDate": currentDelivery.toUtc().toIso8601String(),
      "newDate": newDateStr,
      "reason": null
    };

    final orderId = order.value?.id;
    if (orderId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Order ID missing.")),
      );
      return;
    }

    final url = "${ApiUrl.baseUrl}order/deadline-extend/request/$orderId";

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Sending extension request...")),
    );

    final res = await ApiClient.patchData(url, jsonEncode(body));

    String _extractError(dynamic body) {
      try {
        if (body is Map && body["error"] != null) return body["error"].toString();
        if (body is Map && body["message"] != null) return body["message"].toString();
        if (body is String) {
          final decoded = jsonDecode(body);
            if (decoded is Map && decoded["error"] != null) return decoded["error"].toString();
            if (decoded is Map && decoded["message"] != null) return decoded["message"].toString();
        }
      } catch (_) {}
      return "Request failed.";
    }

    if (res.statusCode == 200) {
      // Mark pending only now (difference between picked and current)
      final added = pickedDate.toLocal().difference(currentDelivery.toLocal());
      pendingExtension.value = added;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Extension request sent successfully.")),
      );

      // Optionally parse response to update order or a hasPendingExtension flag.
      try {
        // final decoded = jsonDecode(res.body);
        // Update order if backend returns new structure.
      } catch (_) {}
    } else {
      final msg = _extractError(res.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg)),
      );
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}

class _DurationChip extends StatelessWidget {
  final String label;
  const _DurationChip({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
      labelStyle: Theme.of(context).textTheme.bodySmall,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );
  }
}