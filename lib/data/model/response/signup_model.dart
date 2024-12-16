class SignUpModel {
  String? gender;
  String? fullName;
  String? language;
  String? phone;
  String? email;
  String? referralCode;

  SignUpModel(
      {this.fullName,
      this.language,
      this.gender,
      this.phone,
      this.email = '',
      this.referralCode = ''});

  SignUpModel.fromJson(Map<String, dynamic> json) {
    fullName = json['full_name'];
    language = json['language'];
    gender = json['gender'];
    phone = json['phone'];
    email = json['email'];
    referralCode = json['referral_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['full_name'] = fullName;
    data['language'] = language;
    data['gender'] = gender;
    data['phone'] = phone;
    data['email'] = email;
    data['referral_code'] = referralCode;
    return data;
  }
}
