import 'package:flutter/material.dart';
import '../home_viewmodel.dart';
import '../../shared/edit_modal.dart';
import '../../shared/confirm_delete_modal.dart';

class FileActionsBottomSheet extends StatelessWidget {
  final FileModel file;
  final Function(String) onRename;
  final VoidCallback onDelete;
  final VoidCallback onOpen;
  final VoidCallback onMove;

  const FileActionsBottomSheet({
    super.key,
    required this.file,
    required this.onRename,
    required this.onDelete,
    required this.onOpen,
    required this.onMove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 32),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
          // Drag handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          // Title and close button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Document Actions',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Color(0xFF64748B)),
                onPressed: () => Navigator.pop(context),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // File Info Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Icon(
                      file.type == 'image' ? Icons.image : 
                      file.type == 'pdf' ? Icons.picture_as_pdf : Icons.description,
                      color: const Color(0xFF64748B), 
                      size: 32
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        file.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${file.size} • ${file.date}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Actions List
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFF1F5F9)),
            ),
            child: Column(
              children: [
                _buildActionItem(
                  icon: Icons.edit_outlined,
                  text: 'Rename file',
                  onTap: () async {
                    Navigator.pop(context);
                    final newName = await showEditModal(
                      context,
                      title: 'Edit Name',
                      initialValue: file.name,
                    );
                    if (newName != null && newName.isNotEmpty) {
                      onRename(newName);
                    }
                  },
                ),
                _buildActionItem(
                  icon: Icons.visibility_outlined,
                  text: 'Open',
                  onTap: () {
                    Navigator.pop(context);
                    onOpen();
                  },
                ),
                _buildActionItem(
                  icon: Icons.drive_file_move_outline,
                  text: 'Move to',
                  onTap: () {
                    Navigator.pop(context);
                    onMove();
                  },
                ),
                _buildActionItem(
                  icon: Icons.delete_outline,
                  text: 'Delete file',
                  textColor: const Color(0xFFEF4444),
                  iconColor: const Color(0xFFEF4444),
                  onTap: () async {
                    Navigator.pop(context);
                    final shouldDelete = await showConfirmDeleteModal(
                      context,
                      title: 'Delete current file?',
                      content: 'Please confirm the deletion of the\ncurrent file',
                    );
                    if (shouldDelete == true) {
                      onDelete();
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Done Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Done',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildActionItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    Color textColor = const Color(0xFF334155),
    Color iconColor = const Color(0xFF64748B),
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 20),
            const SizedBox(width: 12),
            Text(
              text,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
