import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ImageController extends GetxController {
  RxMap<int, XFile> imageFileList = <int, XFile>{}.obs;
  RxMap<int, bool?> imageVisible = <int, bool?>{}.obs;

  setImageFileList(int id, XFile value) {
    imageFileList[id] = value;
  }

  setImageVisible(int id, bool? value) {
    imageVisible[id] = value;
  }
}
