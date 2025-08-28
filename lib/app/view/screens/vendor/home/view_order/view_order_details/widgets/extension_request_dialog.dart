import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'duration_chip.dart';

Future<bool?> showExtensionDialog(
  BuildContext context, {
  required DateTime pickedDate,
  required DateTime currentDate,
  required TextEditingController reasonController,
}) {
  final addedDuration = pickedDate.difference(currentDate);
  const maxChars = 200;

  String _formatDuration(Duration d) {
    final parts = <String>[];
    if (d.inDays > 0) parts.add("${d.inDays}d");
    final hours = d.inHours.remainder(24);
    if (hours > 0) parts.add("${hours}h");
    final mins = d.inMinutes.remainder(60);
    if (mins > 0) parts.add("${mins}m");
    return parts.isEmpty ? "0m" : parts.join(" ");
  }

  final formattedDate = DateFormat('EEE, d MMM yyyy • HH:mm').format(pickedDate);

  return showDialog<bool>(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          final charCount = reasonController.text.length;
          final overLimit = charCount > maxChars;
          // final durationString = _formatDuration(addedDuration);

          Color counterColor;
          if (overLimit) {
            counterColor = Colors.red;
          } else if (charCount > (maxChars * 0.85)) {
            counterColor = Colors.orange;
          } else {
            counterColor = Colors.grey;
          }

          return AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            titlePadding: const EdgeInsets.all(20),
            contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
            title: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.brightCyan.withOpacity(.15),
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Icon(Icons.access_time, color: AppColors.brightCyan, size: 22),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    "Extension Request",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                  ),
                ),
                IconButton(
                  tooltip: "Close",
                  splashRadius: 20,
                  onPressed: () => Navigator.pop(context, false),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
            content: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      elevation: 0,
                      color: Theme.of(context).colorScheme.primary.withOpacity(.05),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "New delivery deadline",
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium
                                    ?.copyWith(letterSpacing: .3),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                formattedDate,
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              const SizedBox(height: 8),
                               Text(
                                "Requested extension:",
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
                              ),
                                 const SizedBox(height: 8),
                              Wrap(
                                spacing: 6,
                                runSpacing: -4,
                                children: [
                                  if (addedDuration.inDays > 0)
                                    DurationChip(
                                      label: "${addedDuration.inDays} days",
                                      leading: Icons.calendar_today_rounded,
                                    ),
                                  if (addedDuration.inHours.remainder(24) > 0)
                                    DurationChip(
                                      label: "${addedDuration.inHours.remainder(24)} hours",
                                      leading: Icons.schedule_rounded,
                                    ),
                                  if (addedDuration.inMinutes.remainder(60) > 0)
                                    DurationChip(
                                      label: "${addedDuration.inMinutes.remainder(60)} min",
                                      leading: Icons.timelapse_rounded,
                                    ),
                                  if (addedDuration.inMinutes == 0)
                                    DurationChip(
                                      label: "No change",
                                      leading: Icons.info_outline,
                                    ),
                                ],
                              ),
                              const SizedBox(height: 6),
                             
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: reasonController,
                      maxLength: maxChars,
                      minLines: 3,
                      maxLines: 5,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        labelText: "Reason (optional)",
                        alignLabelWithHint: true,
                        filled: true,
                        fillColor: Colors.white,
              
                       
                        counterText: "$charCount / $maxChars",
                        counterStyle: TextStyle(
                          fontSize: 12,
                          color: counterColor,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                        helperText: overLimit
                            ? "Too many characters"
                            : "Provide a clear, concise explanation (improves approval chances).",
                        helperStyle: TextStyle(
                          color: overLimit ? Colors.red : Colors.grey[600],
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                            color: overLimit
                                ? Colors.red
                                : Colors.grey.withValues(alpha: .4),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                            color: overLimit ? Colors.red : AppColors.brightCyan,
                            width: 1.4,
                          ),
                        ),
                        errorText: overLimit ? "Limit exceeded" : null,
                        suffixIcon: (charCount == 0 || overLimit)
                            ? null
                            : Icon(Icons.check_circle,
                                color: AppColors.brightCyan, size: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            actionsAlignment: MainAxisAlignment.spaceBetween,
            actions: [
              Center(
                child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  OutlinedButton.icon(
                  onPressed: () => Navigator.pop(context, false),
                  icon: const Icon(Icons.arrow_back_rounded, size: 18),
                  label: const Text("Cancel"),
                  style: OutlinedButton.styleFrom(
                    shape: const StadiumBorder(),
                  ),
                  ),
                  const SizedBox(width: 8),
                  FilledButton.icon(
                  onPressed: overLimit ? null : () => Navigator.pop(context, true),
                  icon: const Icon(Icons.send_rounded, size: 18),
                  label: const Text("Submit"),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.brightCyan,
                    foregroundColor: Colors.white,
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                    textStyle: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  ),
                ],
                ),
              ),
            ],
          );
        },
      );
    },
  );
}
