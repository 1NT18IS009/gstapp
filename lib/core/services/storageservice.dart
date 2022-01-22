import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;


class StorageService {
  Future<void> uploadFile(File file, String filename) async {
    var fileType = 'image';

    Reference storageReference;
    if (fileType == 'image') {
      storageReference =
          FirebaseStorage.instance.ref().child("tallyassist/$filename");
    }
    final UploadTask uploadTask = storageReference.putFile(file);
    final TaskSnapshot downloadUrl = (await uploadTask.whenComplete(() => null));
    final String url = (await downloadUrl.ref.getDownloadURL());
    print("URL is $url");
  }

  Future<void> downloadFile(String filename) async {
    var fileType = 'image';

    Reference storageReference;
    if (fileType == 'image') {
      storageReference =
          FirebaseStorage.instance.ref().child("tallyassist/$filename");
    }

    final String url = await storageReference.getDownloadURL();
    // final String uuid = Uuid().v1();
    await http.get(Uri.parse(url));
    final Directory systemTempDir = Directory.systemTemp;
    final File tempFile = File('${systemTempDir.path}/$filename');
    if (tempFile.existsSync()) {
      await tempFile.delete();
    }
    await tempFile.create();
    assert(await tempFile.readAsString() == "");

  }
}
