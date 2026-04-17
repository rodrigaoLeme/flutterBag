abstract class UpdateAccount {
  Future<void> update({
    required UpdateAccountParams params,
    required String where,
  });
}

class UpdateAccountParams {
  final String? imageUrl;
  final String? email;
  final String? phone;
  final String? password;

  UpdateAccountParams({
    this.imageUrl,
    this.email,
    this.phone,
    this.password,
  });

  Map toMap() {
    Map params = {};
    if (imageUrl != null) {
      params['url_image'] = imageUrl;
    }
    if (email != null) {
      params['email'] = email;
    }
    if (phone != null) {
      params['phone'] = phone;
    }
    if (password != null) {
      params['password'] = password;
    }

    return params;
  }
}
