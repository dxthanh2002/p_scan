import 'package:flutter/material.dart';
import '../camera_scan/camera_scan_screen.dart';
import 'home_viewmodel.dart';
import 'create_folder/create_folder_dialog.dart';
import 'widgets/folder_actions_bottom_sheet.dart';
import 'file_option/file_actions_bottom_sheet.dart';
import 'file_option/move_to_folder_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeViewModel _viewModel = HomeViewModel();

  @override
  void initState() {
    super.initState();
    _viewModel.addListener(_onViewModelChange);
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChange);
    _viewModel.dispose();
    super.dispose();
  }

  void _onViewModelChange() {
    setState(() {}); // Rebuild UI when state changes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F7FA),
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          'Documents',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            letterSpacing: -0.5,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black),
            onPressed: () {
              Navigator.pushNamed(context, '/setting');
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        children: [
          // Stats & Actions Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'TOTAL: ${_viewModel.totalFiles} FILE',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.6,
                  color: Color(0xFF64748B), // slate-500
                ),
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  final folderName = await showDialog<String>(
                    context: context,
                    builder: (context) => const CreateFolderDialog(),
                  );
                  if (folderName != null && folderName.isNotEmpty) {
                    _viewModel.addFolder(folderName);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  elevation: 0,
                  shadowColor: Colors.black.withOpacity(0.04),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.create_new_folder, color: Colors.black),
                label: const Text(
                  'Create Folder',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Featured Folder Section
          const Text(
            'FOLDERS',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.6,
              color: Color(0xFF64748B), // slate-500
            ),
          ),
          const SizedBox(height: 16),
          ..._viewModel.folders.map((folder) => _buildFolderCard(folder)),
          
          const SizedBox(height: 24),
          
          // Recent Files Section
          const Text(
            'RECENT FILES',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.6,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 16),
          ..._viewModel.recentFiles.map((file) => _buildFileCard(file)),
          
          // Safe Area Bottom Padding
          const SizedBox(height: 80),
        ],
      ),
      floatingActionButton: SizedBox(
        width: 64,
        height: 64,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CameraScanScreen()),
            );
          },
          backgroundColor: const Color(0xFF2563EB), // blue-600
          elevation: 12,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
          child: const Icon(Icons.photo_camera, color: Colors.white, size: 32),
        ),
      ),
    );
  }

  Widget _buildFolderCard(FolderModel folder) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF8FAFC)), // slate-50
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC), // slate-50
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Icon(Icons.folder, color: Color(0xFF2563EB), size: 28),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  folder.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${folder.fileCount} FILES',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.6,
                    color: Color(0xFF2563EB),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  folder.date,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF94A3B8), // slate-400
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Color(0xFF94A3B8)),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => FolderActionsBottomSheet(
                  folder: folder,
                  onRename: (newName) {
                    _viewModel.renameFolder(folder, newName);
                  },
                  onDelete: () {
                    _viewModel.deleteFolder(folder);
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFileCard(FileModel file) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9), // slate-100
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(
              child: Icon(
                file.type == 'image' ? Icons.image : 
                file.type == 'pdf' ? Icons.picture_as_pdf : Icons.description,
                color: const Color(0xFF475569), // slate-600
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  file.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${file.size} • ${file.date}',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                    color: Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Color(0xFF94A3B8)),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => FileActionsBottomSheet(
                  file: file,
                  onRename: (newName) {
                    _viewModel.renameFile(file, newName);
                  },
                  onDelete: () {
                    _viewModel.deleteFile(file);
                  },
                  onOpen: () {
                    // TODO: Implement open
                  },
                  onMove: () async {
                    final selectedFolder = await Navigator.push<FolderModel>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MoveToFolderScreen(folders: _viewModel.folders),
                      ),
                    );
                    if (selectedFolder != null) {
                      _viewModel.moveFileToFolder(file, selectedFolder);
                    }
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
