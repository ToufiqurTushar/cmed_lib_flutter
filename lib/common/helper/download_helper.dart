import 'dart:isolate';
import 'dart:ui';

@pragma('vm:entry-point')
class DownloadHelper {
  static const downloadPortName = "downloader_send_port";

  @pragma('vm:entry-point')
  static void downloadCallback(String id, int status, int progress) {
    print('Callback on background isolate: task ($id) is in status ($status) and process ($progress)',);

    final SendPort? send = IsolateNameServer.lookupPortByName(downloadPortName);
    send?.send([id, status, progress]);
  }
}