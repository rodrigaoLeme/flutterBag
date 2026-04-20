import 'dart:convert';

@Deprecated("Vamos utilizar o LoggedUser da V2 -> logged_user_v2.dart")
class LoggedUser {
  String? accessToken;
  String? email;
  bool? emailConfirmed;
  String? id;
  Person? person;
  String? personId;
  String? refreshToken;
  List<RefreshTokens>? refreshTokens;
  Roles? roles;
  List<UserEntity>? userEntity;
  String? userName;
  List<UserRoles>? userRoles;

  LoggedUser({this.accessToken, this.email, this.emailConfirmed, this.id, this.person, this.personId, this.refreshToken, this.refreshTokens, this.roles, this.userEntity, this.userName, this.userRoles});

  LoggedUser.fromJson(Map<String, dynamic> json) {
    accessToken = json['accessToken'];
    email = json['email'];
    emailConfirmed = json['emailConfirmed'];
    id = json['id'];
    person = json['person'] != null ? Person.fromJson(json['person']) : null;
    personId = json['person_Id'];
    refreshToken = json['refreshToken'];
    if (json['refreshTokens'] != null) {
      refreshTokens = <RefreshTokens>[];
      json['refreshTokens'].forEach((v) {
        refreshTokens!.add(RefreshTokens.fromJson(v));
      });
    }
    roles = json['roles'] != null ? Roles.fromJson(json['roles']) : null;
    if (json['userEntity'] != null) {
      userEntity = <UserEntity>[];
      json['userEntity'].forEach((v) {
        userEntity!.add(UserEntity.fromJson(v));
      });
    }
    userName = json['userName'];
    if (json['userRoles'] != null) {
      userRoles = <UserRoles>[];
      json['userRoles'].forEach((v) {
        userRoles!.add(UserRoles.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['accessToken'] = accessToken;
    data['email'] = email;
    data['emailConfirmed'] = emailConfirmed;
    data['id'] = id;
    if (person != null) {
      data['person'] = person!.toJson();
    }
    data['person_Id'] = personId;
    data['refreshToken'] = refreshToken;
    if (refreshTokens != null) {
      data['refreshTokens'] = refreshTokens!.map((v) => v.toJson()).toList();
    }
    if (roles != null) {
      data['roles'] = roles!.toJson();
    }
    if (userEntity != null) {
      data['userEntity'] = userEntity!.map((v) => v.toJson()).toList();
    }
    data['userName'] = userName;
    if (userRoles != null) {
      data['userRoles'] = userRoles!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  String toEncode() => json.encode(toJson());

  factory LoggedUser.fromEncode(String source) => LoggedUser.fromJson(json.decode(source));
}

class Person {
  Address? address;
  String? addressId;
  int? age;
  String? birthDate;
  CfessInfo? cfessInfo;
  String? cfessInfoId;
  String? cpf;
  String? createDate;
  String? email;
  int? gender;
  String? id;
  bool? isWhatsApp;
  String? landlineNumber;
  String? mobileNumber;
  String? name;
  String? rg;
  String? rgIssuingAuthority;

  Person({this.address, this.addressId, this.age, this.birthDate, this.cfessInfo, this.cfessInfoId, this.cpf, this.createDate, this.email, this.gender, this.id, this.isWhatsApp, this.landlineNumber, this.mobileNumber, this.name, this.rg, this.rgIssuingAuthority});

  Person.fromJson(Map<String, dynamic> json) {
    address = json['address'] != null ? Address.fromJson(json['address']) : null;
    addressId = json['addressId'];
    age = json['age'];
    birthDate = json['birthDate'];
    cfessInfo = json['cfessInfo'] != null ? CfessInfo.fromJson(json['cfessInfo']) : null;
    cfessInfoId = json['cfessInfoId'];
    cpf = json['cpf'];
    createDate = json['createDate'];
    email = json['email'];
    gender = json['gender'];
    id = json['id'];
    isWhatsApp = json['isWhatsApp'];
    landlineNumber = json['landlineNumber'];
    mobileNumber = json['mobileNumber'];
    name = json['name'];
    rg = json['rg'];
    rgIssuingAuthority = json['rgIssuingAuthority'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (address != null) {
      data['address'] = address!.toJson();
    }
    data['addressId'] = addressId;
    data['age'] = age;
    data['birthDate'] = birthDate;
    if (cfessInfo != null) {
      data['cfessInfo'] = cfessInfo!.toJson();
    }
    data['cfessInfoId'] = cfessInfoId;
    data['cpf'] = cpf;
    data['createDate'] = createDate;
    data['email'] = email;
    data['gender'] = gender;
    data['id'] = id;
    data['isWhatsApp'] = isWhatsApp;
    data['landlineNumber'] = landlineNumber;
    data['mobileNumber'] = mobileNumber;
    data['name'] = name;
    data['rg'] = rg;
    data['rgIssuingAuthority'] = rgIssuingAuthority;
    return data;
  }
}

class Address {
  String? city;
  bool? cityFromService;
  String? complement;
  Country? country;
  String? countryId;
  String? district;
  bool? districtFromService;
  String? id;
  int? latitudeCode;
  int? longitudeCode;
  String? number;
  Region? region;
  String? regionId;
  String? state;
  bool? stateFromService;
  String? street;
  bool? streetFromService;
  String? zipCode;

  Address({this.city, this.cityFromService, this.complement, this.country, this.countryId, this.district, this.districtFromService, this.id, this.latitudeCode, this.longitudeCode, this.number, this.region, this.regionId, this.state, this.stateFromService, this.street, this.streetFromService, this.zipCode});

  Address.fromJson(Map<String, dynamic> json) {
    city = json['city'];
    cityFromService = json['cityFromService'];
    complement = json['complement'];
    country = json['country'] != null ? Country.fromJson(json['country']) : null;
    countryId = json['countryId'];
    district = json['district'];
    districtFromService = json['districtFromService'];
    id = json['id'];
    latitudeCode = json['latitudeCode'];
    longitudeCode = json['longitudeCode'];
    number = json['number'];
    region = json['region'] != null ? Region.fromJson(json['region']) : null;
    regionId = json['regionId'];
    state = json['state'];
    stateFromService = json['stateFromService'];
    street = json['street'];
    streetFromService = json['streetFromService'];
    zipCode = json['zipCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['city'] = city;
    data['cityFromService'] = cityFromService;
    data['complement'] = complement;
    if (country != null) {
      data['country'] = country!.toJson();
    }
    data['countryId'] = countryId;
    data['district'] = district;
    data['districtFromService'] = districtFromService;
    data['id'] = id;
    data['latitudeCode'] = latitudeCode;
    data['longitudeCode'] = longitudeCode;
    data['number'] = number;
    if (region != null) {
      data['region'] = region!.toJson();
    }
    data['regionId'] = regionId;
    data['state'] = state;
    data['stateFromService'] = stateFromService;
    data['street'] = street;
    data['streetFromService'] = streetFromService;
    data['zipCode'] = zipCode;
    return data;
  }
}

class Country {
  String? id;
  String? name;
  String? nationality;

  Country({this.id, this.name, this.nationality});

  Country.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    nationality = json['nationality'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['nationality'] = nationality;
    return data;
  }
}

class Region {
  String? id;
  String? name;

  Region({this.id, this.name});

  Region.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}

class CfessInfo {
  String? cressRegion;
  String? id;
  String? registerNumber;

  CfessInfo({this.cressRegion, this.id, this.registerNumber});

  CfessInfo.fromJson(Map<String, dynamic> json) {
    cressRegion = json['cressRegion'];
    id = json['id'];
    registerNumber = json['registerNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cressRegion'] = cressRegion;
    data['id'] = id;
    data['registerNumber'] = registerNumber;
    return data;
  }
}

class RefreshTokens {
  String? expiryDate;
  String? token;
  int? tokenId;
  User? user;
  String? userId;

  RefreshTokens({this.expiryDate, this.token, this.tokenId, this.user, this.userId});

  RefreshTokens.fromJson(Map<String, dynamic> json) {
    expiryDate = json['expiryDate'];
    token = json['token'];
    tokenId = json['tokenId'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['expiryDate'] = expiryDate;
    data['token'] = token;
    data['tokenId'] = tokenId;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['userId'] = userId;
    return data;
  }
}

class User {
  String? accessToken;
  String? email;
  bool? emailConfirmed;
  String? id;
  Person? person;
  String? personId;
  String? refreshToken;
  List<String>? refreshTokens;
  Roles? roles;
  List<String>? userEntity;
  String? userName;
  List<String>? userRoles;

  User({this.accessToken, this.email, this.emailConfirmed, this.id, this.person, this.personId, this.refreshToken, this.refreshTokens, this.roles, this.userEntity, this.userName, this.userRoles});

  User.fromJson(Map<String, dynamic> json) {
    accessToken = json['accessToken'];
    email = json['email'];
    emailConfirmed = json['emailConfirmed'];
    id = json['id'];
    person = json['person'] != null ? Person.fromJson(json['person']) : null;
    personId = json['person_Id'];
    refreshToken = json['refreshToken'];
    refreshTokens = json['refreshTokens'].cast<String>();
    roles = json['roles'] != null ? Roles.fromJson(json['roles']) : null;
    userEntity = json['userEntity'].cast<String>();
    userName = json['userName'];
    userRoles = json['userRoles'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['accessToken'] = accessToken;
    data['email'] = email;
    data['emailConfirmed'] = emailConfirmed;
    data['id'] = id;
    if (person != null) {
      data['person'] = person!.toJson();
    }
    data['person_Id'] = personId;
    data['refreshToken'] = refreshToken;
    data['refreshTokens'] = refreshTokens;
    if (roles != null) {
      data['roles'] = roles!.toJson();
    }
    data['userEntity'] = userEntity;
    data['userName'] = userName;
    data['userRoles'] = userRoles;
    return data;
  }
}

class Roles {
  String? additionalProp1;
  String? additionalProp2;
  String? additionalProp3;

  Roles({this.additionalProp1, this.additionalProp2, this.additionalProp3});

  Roles.fromJson(Map<String, dynamic> json) {
    additionalProp1 = json['additionalProp1'];
    additionalProp2 = json['additionalProp2'];
    additionalProp3 = json['additionalProp3'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['additionalProp1'] = additionalProp1;
    data['additionalProp2'] = additionalProp2;
    data['additionalProp3'] = additionalProp3;
    return data;
  }
}

class UserEntity {
  String? appUserId;
  bool? current;
  Entity? entity;
  String? entityId;
  String? id;
  bool? isRecursive;
  User? user;

  UserEntity({this.appUserId, this.current, this.entity, this.entityId, this.id, this.isRecursive, this.user});

  UserEntity.fromJson(Map<String, dynamic> json) {
    appUserId = json['appUserId'];
    current = json['current'];
    entity = json['entity'] != null ? Entity.fromJson(json['entity']) : null;
    entityId = json['entityId'];
    id = json['id'];
    isRecursive = json['isRecursive'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['appUserId'] = appUserId;
    data['current'] = current;
    if (entity != null) {
      data['entity'] = entity!.toJson();
    }
    data['entityId'] = entityId;
    data['id'] = id;
    data['isRecursive'] = isRecursive;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class Entity {
  String? educationalInstitutionId;
  Address? address;
  String? addressId;
  String? alias;
  List<String>? childEntities;
  String? contactEmail;
  bool? disabled;
  String? entityCNPJ;
  int? entityCode;
  int? entityType;
  String? fullName;
  String? id;
  String? logoImage;
  String? name;
  String? parentEntity;
  String? parentEntityId;
  bool? serasaInteration;
  String? siteAddress;
  String? smtpHost;
  String? smtpPassword;
  String? smtpPort;
  String? smtpUser;
  String? weapiEndpoint;
  bool? sevenEduIntegration;

  Entity({this.educationalInstitutionId, this.address, this.addressId, this.alias, this.childEntities, this.contactEmail, this.disabled, this.entityCNPJ, this.entityCode, this.entityType, this.fullName, this.id, this.logoImage, this.name, this.parentEntity, this.parentEntityId, this.serasaInteration, this.siteAddress, this.smtpHost, this.smtpPassword, this.smtpPort, this.smtpUser, this.weapiEndpoint, this.sevenEduIntegration});

  Entity.fromJson(Map<String, dynamic> json) {
    educationalInstitutionId = json['educationalInstitutionId'];
    address = json['address'] != null ? Address.fromJson(json['address']) : null;
    addressId = json['addressId'];
    alias = json['alias'];
    childEntities = json['childEntities'].cast<String>();
    contactEmail = json['contactEmail'];
    disabled = json['disabled'];
    entityCNPJ = json['entityCNPJ'];
    entityCode = json['entityCode'];
    entityType = json['entityType'];
    fullName = json['fullName'];
    id = json['id'];
    logoImage = json['logoImage'];
    name = json['name'];
    parentEntity = json['parentEntity'];
    parentEntityId = json['parentEntityId'];
    serasaInteration = json['serasaInteration'];
    siteAddress = json['siteAddress'];
    smtpHost = json['smtpHost'];
    smtpPassword = json['smtpPassword'];
    smtpPort = json['smtpPort'];
    smtpUser = json['smtpUser'];
    weapiEndpoint = json['weapiEndpoint'];
    sevenEduIntegration = json['sevenEduIntegration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['educationalInstitutionId'] = educationalInstitutionId;
    if (address != null) {
      data['address'] = address!.toJson();
    }
    data['addressId'] = addressId;
    data['alias'] = alias;
    data['childEntities'] = childEntities;
    data['contactEmail'] = contactEmail;
    data['disabled'] = disabled;
    data['entityCNPJ'] = entityCNPJ;
    data['entityCode'] = entityCode;
    data['entityType'] = entityType;
    data['fullName'] = fullName;
    data['id'] = id;
    data['logoImage'] = logoImage;
    data['name'] = name;
    data['parentEntity'] = parentEntity;
    data['parentEntityId'] = parentEntityId;
    data['serasaInteration'] = serasaInteration;
    data['siteAddress'] = siteAddress;
    data['smtpHost'] = smtpHost;
    data['smtpPassword'] = smtpPassword;
    data['smtpPort'] = smtpPort;
    data['smtpUser'] = smtpUser;
    data['weapiEndpoint'] = weapiEndpoint;
    data['sevenEduIntegration'] = sevenEduIntegration;
    return data;
  }
}

class UserRoles {
  Role? role;
  String? roleId;
  User? user;
  String? userId;

  UserRoles({this.role, this.roleId, this.user, this.userId});

  UserRoles.fromJson(Map<String, dynamic> json) {
    role = json['role'] != null ? Role.fromJson(json['role']) : null;
    roleId = json['roleId'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (role != null) {
      data['role'] = role!.toJson();
    }
    data['roleId'] = roleId;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['userId'] = userId;
    return data;
  }
}

class Role {
  String? id;
  String? name;
  String? normalizedName;

  Role({this.id, this.name, this.normalizedName});

  Role.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    normalizedName = json['normalizedName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['normalizedName'] = normalizedName;
    return data;
  }
}
