import 'package:get/get.dart';

class CurrentPageController extends GetxController
{
  RxInt currentPage = 0.obs;
  RxInt totalPage = 0.obs;

  setCurrentPage(int page)
  {
    currentPage.value = page;
  }

  setTotalPage(int x)
  {
    totalPage.value = x;
  }

}