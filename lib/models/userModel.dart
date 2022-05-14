import 'dart:io';

class CurrentUser {
  int id;
  String name;
  String email;
  String emailVerifiedAt;
  String password;
  String rememberToken;
  String userPhone;
  String deviceId;
  String userImage;
  int userCity;
  int userArea;
  String otpValue;
  int status;
  double wallet;
  int rewards;
  int isVerified;
  int block;
  String regDate;
  int appUpdate;
  String facebookId;
  String referralCode;
  int membership;
  String memPlanStart;
  String memPlanExpiry;
  String createdAt;
  String updatedAt;
  String token;
  String fbId;
  File userImageFile;
  String appleId;
  int totalOrders;
  double totalSpend;
  double totalSaved;



  CurrentUser();

  CurrentUser.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'] != null ? int.parse('${json['id']}') : null;
      name = json['name'] != null ? json['name'] : null;
      email = json['email'] != null ? json['email'] : null;
      emailVerifiedAt = json['email_verified_at'] != null ? json['email_verified_at'] : null;
      password = json['password'] != null ? json['password'] : null;
      rememberToken = json['remember_token'] != null ? json['remember_token'] : null;
      userPhone = json['user_phone'] != null ? json['user_phone'] : null;
      deviceId = json['device_id'] != null ? json['device_id'] : null;
      userImage = (json['user_image'] != null && '${json['user_image']}' !='N/A') ? json['user_image'] : null;
      userCity = json['user_city'] != null ? int.parse(json['user_city'].toString()) : null;
      userArea = json['user_area'] != null ? int.parse(json['user_area'].toString()) : null;
      otpValue = json['otp_value'] != null ? json['otp_value'] : null;
      status = json['status'] != null ? int.parse('${json['status']}') : null;
      wallet = json['wallet'] != null ? double.parse('${json['wallet']}') : null;
      rewards = json['rewards'] != null ? int.parse('${json['rewards']}') : null;
      isVerified = json['is_verified'] != null ? int.parse('${json['is_verified']}') : null;
      block = json['block'] != null ? int.parse('${json['block']}') : null;
      regDate = json['reg_date'] != null ? json['reg_date'] : null;
      appUpdate = json['app_update'] != null ? int.parse('${json['app_update']}') : null;
      facebookId = json['facebook_id'] != null ? json['facebook_id'] : null;
      referralCode = json['referral_code'] != null ? json['referral_code'] : null;
      membership = json['membership'] != null ? int.parse('${json['membership']}') : null;
      memPlanStart = json['mem_plan_start'] != null ? json['mem_plan_start'] : null;
      memPlanExpiry = json['mem_plan_expiry'] != null ? json['mem_plan_expiry'] : null;
      createdAt = json['created_at'] != null ? json['created_at'] : null;
      updatedAt = json['updated_at'] != null ? json['updated_at'] : null;
      token = json['token'] != null ? json['token'] : null;
      totalOrders = json['total_orders'] != null ? int.parse('${json['total_orders']}') : null;
      totalSpend = json['total_spent'] != null ? double.parse('${json['total_spent']}') : null;
      totalSaved = json['total_save'] != null ? double.parse('${json['total_save']}') : null;
    } catch (e) {
      print("Exception - userModel.dart - User.fromJson():" + e.toString());
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id != null ? id : null,
        'name': name != null ? name : null,
        'email': email != null ? email : null,
        'email_verified_at': emailVerifiedAt != null ? emailVerifiedAt : null,
        'password': password != null ? password : null,
        'remember_token': rememberToken != null ? rememberToken : null,
        'user_phone': userPhone != null ? userPhone : null,
        'device_id': deviceId != null ? deviceId : null,
        'user_image': userImage != null ? userImage : null,
        'user_city': userCity != null ? userCity : null,
        'user_area': userArea != null ? userArea : null,
        'otp_value': otpValue != null ? otpValue : null,
        'status': status != null ? status : null,
        'wallet': wallet != null ? wallet : null,
        'rewards': rewards != null ? rewards : null,
        'is_verified': isVerified != null ? isVerified : null,
        'block': block != null ? block : null,
        'reg_date': regDate != null ? regDate : null,
        'app_update': appUpdate != null ? appUpdate : null,
        'facebook_id': facebookId != null ? facebookId : null,
        'referral_code': referralCode != null ? referralCode : null,
        'membership': membership != null ? membership : null,
        'mem_plan_start': memPlanStart != null ? memPlanStart : null,
        'mem_plan_expiry': memPlanExpiry != null ? memPlanExpiry : null,
        'created_at': createdAt != null ? createdAt : null,
        'updated_at': updatedAt != null ? updatedAt : null,
        'token': token != null ? token : null,
      };

  @override
  String toString() {
    return 'CurrentUser{id: $id, name: $name, email: $email, emailVerifiedAt: $emailVerifiedAt, password: $password, rememberToken: $rememberToken, userPhone: $userPhone, deviceId: $deviceId, userImage: $userImage, userCity: $userCity, userArea: $userArea, otpValue: $otpValue, status: $status, wallet: $wallet, rewards: $rewards, isVerified: $isVerified, block: $block, regDate: $regDate, appUpdate: $appUpdate, facebookId: $facebookId, referralCode: $referralCode, membership: $membership, memPlanStart: $memPlanStart, memPlanExpiry: $memPlanExpiry, createdAt: $createdAt, updatedAt: $updatedAt, token: $token, fbId: $fbId, userImageFile: $userImageFile, appleId: $appleId, totalOrders: $totalOrders, totalSpend: $totalSpend, totalSaved: $totalSaved}';
  }
}
