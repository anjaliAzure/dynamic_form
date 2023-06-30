import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:signature/signature.dart';

class SignatureControllers extends GetxController {
  RxMap<int, bool?> signatureVisible = <int, bool?>{}.obs;
  RxMap<int, String?> imagePath = <int, String?>{}.obs;

  RxMap<int, SignatureController> controller = <int, SignatureController>{}.obs;

  setSignatureVisible(int id, bool? value) {
    signatureVisible[id] = value;
  }

  setSignatureImagePath(int id, String? value) {
    imagePath[id] = value;
  }

  Future<void> takePic(int id) async {
    final camera = (await availableCameras())[1];
    final controller =
        CameraController(camera, ResolutionPreset.low, enableAudio: false);
    try {
      await controller.initialize();
      //await Future.delayed(const Duration(seconds: 1));
      //await controller.setFlashMode(FlashMode.off);
      final image = await controller.takePicture();
      controller.dispose();
      setSignatureImagePath(id, image.path);
      //update();
    } catch (e) {
      log("Exception $e");
      controller.dispose();
    }
  }
}
