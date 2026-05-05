import 'package:flutter/foundation.dart';

class FolderModel {
  final String name;
  final int fileCount;
  final String date;

  FolderModel(this.name, this.fileCount, this.date);
}

class FileModel {
  final String name;
  final String size;
  final String date;
  final String type; // 'pdf', 'image'

  FileModel(this.name, this.size, this.date, this.type);
}

class HomeViewModel extends ChangeNotifier {
  final List<FolderModel> folders = [
    FolderModel('Work Documents', 3, 'OCT 26, 2023'),
  ];

  final List<FileModel> recentFiles = [
    FileModel('Purchase Agreement.pdf', '1.2 MB', 'TODAY', 'pdf'),
    FileModel('Dinner Receipt.jpg', '450 KB', 'YESTERDAY', 'image'),
    FileModel('Tax Form 2023.pdf', '2.8 MB', 'OCT 24, 2023', 'pdf'),
  ];

  int get totalFiles => 1;

  void addFolder(String name) {
    folders.insert(0, FolderModel(name, 0, 'JUST NOW'));
    notifyListeners();
  }

  void renameFolder(FolderModel folder, String newName) {
    final index = folders.indexOf(folder);
    if (index != -1) {
      folders[index] = FolderModel(newName, folder.fileCount, folder.date);
      notifyListeners();
    }
  }

  void deleteFolder(FolderModel folder) {
    folders.remove(folder);
    notifyListeners();
  }

  void renameFile(FileModel file, String newName) {
    final index = recentFiles.indexOf(file);
    if (index != -1) {
      recentFiles[index] = FileModel(newName, file.size, file.date, file.type);
      notifyListeners();
    }
  }

  void deleteFile(FileModel file) {
    recentFiles.remove(file);
    notifyListeners();
  }

  void moveFileToFolder(FileModel file, FolderModel folder) {
    recentFiles.remove(file);
    final index = folders.indexOf(folder);
    if (index != -1) {
      folders[index] = FolderModel(folder.name, folder.fileCount + 1, folder.date);
    }
    notifyListeners();
  }

  void onCreateFolder() {
    // Deprecated, handled in UI
  }

  void onCameraTap() {
    // TODO: Implement camera tap logic
  }
}
