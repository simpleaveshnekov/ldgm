class SubCategory {
  int catId;
  String title;
  String slug;
  String url;
  String image;
  int parent;
  int level;
  String description;
  int status;
  int addedBy;
  int taxType;
  String taxName;
  int taxPer;
  int txId;
  bool isSelected = false;

  SubCategory({this.isSelected});
  SubCategory.fromJson(Map<String, dynamic> json) {
    try {
      catId = json['cat_id'] != null ? int.parse(json['cat_id'].toString()) : null;
      title = json['title'] != null ? json['title'] : '';
      slug = json['slug'] != null ? json['slug'] : '';
      url = json['url'] != null ? json['url'] : '';
      image = json['image'] != null ? json['image'] : '';
      parent = json['parent'] != null ? int.parse(json['parent'].toString()) : null;
      level = json['level'] != null ? int.parse(json['level'].toString()) : null;
      description = json['description'] != null ? json['description'] : '';
      status = json['status'] != null ? int.parse(json['status'].toString()) : null;
      addedBy = json['added_by'] != null ? int.parse(json['added_by'].toString()) : null;
      taxType = json['tax_type'] != null ? int.parse(json['tax_type'].toString()) : null;
      taxName = json['tax_name'] != null ? json['tax_name'] : '';
      taxPer = json['tax_per'] != null ? int.parse(json['tax_per'].toString()) : null;
      txId = json['tx_id'] != null ? int.parse(json['tx_id'].toString()) : null;
    } catch (e) {
      print("Exception - subCategoryModel.dart - SubCategory.fromJson():" + e.toString());
    }
  }
}
