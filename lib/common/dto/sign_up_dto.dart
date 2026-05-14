class SignUpDTO {
  int? birthday;
  int? bloodGroup;
  CreatedBy? createdBy;
  bool? diabetic;
  String? email;
  String? firstName;
  int? gender;
  double? height;
  bool? hypertensive;
  String? lastName;
  int? nidNumber;
  String? password;
  String? phone;
  String? role;
  String? username;
  String? uuid;
  int? weight;
  int? divisionId;
  int? districtId;
  int? upzilaId;
  int? unionId;
  int? villageId;
  String? address;
  String? location;
  bool? selfRegistered;

  SignUpDTO(
      {this.birthday,
        this.bloodGroup,
        this.createdBy,
        this.diabetic,
        this.email,
        this.firstName,
        this.gender,
        this.height,
        this.hypertensive,
        this.lastName,
        this.nidNumber,
        this.password,
        this.phone,
        this.role,
        this.username,
        this.uuid,
        this.selfRegistered,
        this.address,
        this.location,
        this.divisionId,
        this.districtId,
        this.upzilaId,
        this.unionId,
        this.villageId,
        this.weight});

  SignUpDTO.fromJson(Map<String, dynamic> json) {
    birthday = json['birthday'];
    bloodGroup = json['blood_group'];
    createdBy = json['created_by'] != null
        ? CreatedBy.fromJson(json['created_by'])
        : null;
    diabetic = json['diabetic'];
    email = json['email'];
    firstName = json['first_name'];
    gender = json['gender'];
    height = json['height'];
    hypertensive = json['hypertesive'];
    lastName = json['last_name'];
    nidNumber = json['nid_number'];
    password = json['password'];
    phone = json['phone'];
    role = json['role'];
    username = json['username'];
    uuid = json['uuid'];
    weight = json['weight'];
    address = json['address'];
    location = json['location'];
    divisionId = json['divisionId'];
    districtId = json['districtId'];
    upzilaId = json['upzilaId'];
    unionId = json['unionId'];
    villageId = json['villageId'];
    selfRegistered = json['self_registered'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['birthday'] = birthday;
    data['blood_group'] = bloodGroup;
    if (createdBy != null) {
      data['created_by'] = createdBy!.toJson();
    }
    data['diabetic'] = diabetic;
    data['email'] = email;
    data['first_name'] = firstName;
    data['gender'] = gender;
    data['height'] = height;
    data['hypertesive'] = hypertensive;
    data['last_name'] = lastName;
    data['nid_number'] = nidNumber;
    data['password'] = password;
    data['phone'] = phone;
    data['role'] = role;
    data['username'] = username;
    data['uuid'] = uuid;
    data['weight'] = weight;
    data['address'] = address;
    data['location'] = location;
    data['divisionId'] = divisionId;
    data['districtId'] = districtId;
    data['upzilaId'] = upzilaId;
    data['unionId'] = unionId;
    data['villageId'] = villageId;
    data['self_registered'] = selfRegistered;
    return data;
  }
}

class CreatedBy {
  bool? accountNonExpired;
  bool? accountNonLocked;
  bool? admin;
  String? created;
  bool? credentialsNonExpired;
  bool? deleted;
  String? email;
  bool? enabled;
  String? firstName;
  int? id;
  String? lastName;
  String? lastUpdated;
  String? name;
  String? password;
  String? phone;
  List<int>? roleIdList;
  List<Roles>? roles;
  String? username;
  String? uuid;

  CreatedBy(
      {this.accountNonExpired,
        this.accountNonLocked,
        this.admin,
        this.created,
        this.credentialsNonExpired,
        this.deleted,
        this.email,
        this.enabled,
        this.firstName,
        this.id,
        this.lastName,
        this.lastUpdated,
        this.name,
        this.password,
        this.phone,
        this.roleIdList,
        this.roles,
        this.username,
        this.uuid});

  CreatedBy.fromJson(Map<String, dynamic> json) {
    accountNonExpired = json['accountNonExpired'];
    accountNonLocked = json['accountNonLocked'];
    admin = json['admin'];
    created = json['created'];
    credentialsNonExpired = json['credentialsNonExpired'];
    deleted = json['deleted'];
    email = json['email'];
    enabled = json['enabled'];
    firstName = json['firstName'];
    id = json['id'];
    lastName = json['lastName'];
    lastUpdated = json['lastUpdated'];
    name = json['name'];
    password = json['password'];
    phone = json['phone'];
    roleIdList = json['roleIdList'].cast<int>();
    if (json['roles'] != null) {
      roles = <Roles>[];
      json['roles'].forEach((v) {
        roles!.add( Roles.fromJson(v));
      });
    }
    username = json['username'];
    uuid = json['uuid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['accountNonExpired'] = accountNonExpired;
    data['accountNonLocked'] = accountNonLocked;
    data['admin'] = admin;
    data['created'] = created;
    data['credentialsNonExpired'] = credentialsNonExpired;
    data['deleted'] = deleted;
    data['email'] =  email;
    data['enabled'] = enabled;
    data['firstName'] = firstName;
    data['id'] = id;
    data['lastName'] = lastName;
    data['lastUpdated'] = lastUpdated;
    data['name'] = name;
    data['password'] = password;
    data['phone'] = phone;
    data['roleIdList'] = roleIdList;
    if (roles != null) {
      data['roles'] = roles!.map((v) => v.toJson()).toList();
    }
    data['username'] = username;
    data['uuid'] = uuid;
    return data;
  }
}

class Roles {
  bool? admin;
  String? created;
  bool? deleted;
  String? description;
  int? id;
  String? lastUpdated;
  String? name;
  List<Privileges>? privileges;
  bool? restricted;
  String? uuid;

  Roles(
      {this.admin,
        this.created,
        this.deleted,
        this.description,
        this.id,
        this.lastUpdated,
        this.name,
        this.privileges,
        this.restricted,
        this.uuid});

  Roles.fromJson(Map<String, dynamic> json) {
    admin = json['admin'];
    created = json['created'];
    deleted = json['deleted'];
    description = json['description'];
    id = json['id'];
    lastUpdated = json['lastUpdated'];
    name = json['name'];
    if (json['privileges'] != null) {
      privileges = <Privileges>[];
      json['privileges'].forEach((v) {
        privileges!.add(Privileges.fromJson(v));
      });
    }
    restricted = json['restricted'];
    uuid = json['uuid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['admin'] = admin;
    data['created'] = created;
    data['deleted'] = deleted;
    data['description'] = description;
    data['id'] = id;
    data['lastUpdated'] = lastUpdated;
    data['name'] = name;
    if (privileges != null) {
      data['privileges'] = privileges!.map((v) => v.toJson()).toList();
    }
    data['restricted'] = restricted;
    data['uuid'] = uuid;
    return data;
  }
}

class Privileges {
  List<String>? accessUrls;
  String? created;
  bool? deleted;
  String? description;
  int? id;
  String? label;
  String? lastUpdated;
  String? name;
  String? uuid;

  Privileges(
      {this.accessUrls,
        this.created,
        this.deleted,
        this.description,
        this.id,
        this.label,
        this.lastUpdated,
        this.name,
        this.uuid});

  Privileges.fromJson(Map<String, dynamic> json) {
    accessUrls = json['accessUrls'].cast<String>();
    created = json['created'];
    deleted = json['deleted'];
    description = json['description'];
    id = json['id'];
    label = json['label'];
    lastUpdated = json['lastUpdated'];
    name = json['name'];
    uuid = json['uuid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['accessUrls'] = accessUrls;
    data['created'] = created;
    data['deleted'] = deleted;
    data['description'] = description;
    data['id'] = id;
    data['label'] = label;
    data['lastUpdated'] = lastUpdated;
    data['name'] = name;
    data['uuid'] = uuid;
    return data;
  }
}
