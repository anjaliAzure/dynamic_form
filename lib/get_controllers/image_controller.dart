import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ImageController extends GetxController {
  RxMap<int, XFile> imageFileList = <int, XFile>{}.obs;
  RxList<bool?> imageVisible = <bool?>[].obs;
}
