import 'dart:io';

// import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

class FileHelper {
  static final ImagePicker _imagePicker = new ImagePicker();

  // pick image from gallery
  static pickImageFromGallery() async {
    PickedFile image = (await _imagePicker.getImage(
        source: ImageSource.gallery, imageQuality: 100));
    return new File(image.path);
  }

  // pick Image Using Camera
  static imageFromCamera() async {
    PickedFile image = (await _imagePicker.getImage(
        source: ImageSource.camera, imageQuality: 100));
    return new File(image.path);
  }

  // // pick a file
  // static pickFile() async {
  //   FilePickerResult result = await FilePicker.platform.pickFiles();
  //   if (result != null) {
  //     File file = File(result.files.single.path);
  //     return file;
  //   }
  // }
}
