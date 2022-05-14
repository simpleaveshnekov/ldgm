class Varient {
  int storeId;
  int stock;
  int varientId;
  String description;
  int price;
  int mrp;
  String varientImage;
  String unit;
  int quantity;
  int dealPrice;
  String validFrom;
  String validTo;
  int cartQty;
  bool isFavourite = false;

  Varient();
  Varient.fromJson(Map<String, dynamic> json) {
    try {
      storeId = json['store_id'] != null ? int.parse(json['store_id'].toString()) : null;
      stock = json['stock'] != null ? int.parse(json['stock'].toString()) : null;
      varientId = json['varient_id'] != null ? int.parse(json['varient_id'].toString()) : null;
      description = json['description'] != null ? json['description'] : null;
      price = json['price'] != null ? double.parse(json['price'].toString()).round() : null;
      mrp = json['mrp'] != null ? double.parse(json['mrp'].toString()).round() : null;
      varientImage = json['varient_image'] != null ? json['varient_image'] : null;
      unit = json['unit'] != null ? json['unit'] : null;
      quantity = json['quantity'] != null ? int.parse(json['quantity'].toString()) : null;
      dealPrice = json['deal_price'] != null ? double.parse(json['deal_price'].toString()).round() : null;
      validFrom = json['valid_from'] != null ? json['valid_from'] : null;
      validTo = json['valid_to'] != null ? json['valid_to'] : null;
      cartQty = json['cart_qty'] != null ? int.parse(json['cart_qty'].toString()) : null;
      isFavourite = json['isFavourite'] != null && json['isFavourite'] == 'false' ? false : true;
    } catch (e) {
      print("Exception - varientModel.dart - Varient.fromJson():" + e.toString());
    }
  }
}
