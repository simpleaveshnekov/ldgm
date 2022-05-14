class ImageModel {
  String image;
  ImageModel();
  ImageModel.fromJson(Map<String, dynamic> json) {
    try {
      image = json['image'] != null ? json['image'] : '';
    } catch (e) {
      print("Exception - ImageModel.dart - ImageModel.fromJson():" + e.toString());
    }
  }
}
