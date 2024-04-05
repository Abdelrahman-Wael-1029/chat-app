import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:open_file_plus/open_file_plus.dart';

void downlaodFile(String url, bool openAfterDownload) async {
  await FileDownloader.downloadFile(
    url: url,
    onProgress: (String? fileName, double progress) {},
    onDownloadCompleted: (String path) {
      if (openAfterDownload) OpenFile.open(path);
    },
    onDownloadError: (String error) {},
  );
}
