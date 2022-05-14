import 'package:get/get.dart';
import 'package:user/models/businessLayer/apiHelper.dart';
import 'package:user/models/orderModel.dart';

class OrderController extends GetxController {
  APIHelper apiHelper = new APIHelper();
  List<Order> completedOrderList = [];
  List<Order> activeOrderList = [];
  var isDataLoaded = false.obs;
  var isDataLoaded1 = false.obs;
  var isDataLoaded2 = false.obs;
  var isDeleted = false.obs;



  var page = 1.obs;

  var isMoreDataLoaded = false.obs;
  var isRecordPending = true.obs;



  var page1 = 1.obs;
 
  var isMoreDataLoaded1 = false.obs;
  var isRecordPending1 = true.obs;

  deleteOrder(String cartId, String cancelReason) async {
    try {
      isDataLoaded2(false);
      await apiHelper.deleteOrder(cartId, cancelReason).then((result) async {

        if (result != null) {
          if (result.status == "1") {
            isDeleted(true);
            Get.snackbar(
              "Order Cancelled.",
              "",
              snackPosition: SnackPosition.BOTTOM,
            );
          } else {
            isDeleted(false);
            Get.snackbar(
              "Order Cancellation Failed.",
              "",
              snackPosition: SnackPosition.BOTTOM,
            );
          }
        }
      });
      isDataLoaded2(true);
      update();
    } catch (e) {
      print("Exception -  order_controller.dart - deleteOrder():" + e.toString());
    }
  }

  

  getActiveOrderList() async {
    try {
      isDataLoaded1(false);

      if (isRecordPending1.value == true) {
        isMoreDataLoaded1(true);

        if (activeOrderList.isEmpty) {
          page1.value = 1;
        } else {
          page1.value++;
        }

        await apiHelper.getActiveOrders(page1.value).then((result) async {
          if (result != null) {
            if (result.status == "1") {
              List<Order> _tList = result.data;
              if (_tList.isEmpty) {
                isRecordPending1(false);
              }
              activeOrderList.addAll(_tList);

              isMoreDataLoaded1(false);
            } else {
              activeOrderList = null;
            }
          }
        });
      }
      isDataLoaded1(true);
      update();
    } catch (e) {
      print("Exception -  order_controller.dart - getActiveOrderList():" + e.toString());
    }
  }


  getCompletedOrderHistoryList() async {
    try {
      isDataLoaded(false);

      if (isRecordPending.value == true) {
        isMoreDataLoaded(true);

        if (completedOrderList.isEmpty) {
          page.value = 1;
        } else {
          page.value++;
        }

        await apiHelper.getCompletedOrders(page.value).then((result) async {
          if (result != null) {
            if (result.status == "1") {
              List<Order> _tList = result.data;
              if (_tList.isEmpty) {
                isRecordPending(false);
              }
              completedOrderList.addAll(_tList);

              isMoreDataLoaded(false);
            } else {
              completedOrderList = [];
            }
          }
        });
      }
      isDataLoaded(true);
      update();
    } catch (e) {
      print("Exception -  order_controller.dart - getOrderHistoryList():" + e.toString());
    }
  }
}
