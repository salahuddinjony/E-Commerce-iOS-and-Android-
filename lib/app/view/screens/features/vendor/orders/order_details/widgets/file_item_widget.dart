import 'package:flutter/material.dart';

class FileItemWidget extends StatelessWidget {
  final int index;
  final String fileName;
  final VoidCallback onRemove;

  const FileItemWidget({
    super.key,
    required this.index,
    required this.fileName,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          _getFileIcon(fileName),
          size: 16,
          color: Colors.blue.shade600,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            '${index + 1}. $fileName',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade700,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        InkWell(
          onTap: onRemove,
          child: Icon(
            Icons.remove_circle_outline,
            size: 16,
            color: Colors.red.shade400,
          ),
        ),
      ],
    );
  }

  IconData _getFileIcon(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
        return Icons.image;
      default:
        return Icons.insert_drive_file;
    }
  }
}