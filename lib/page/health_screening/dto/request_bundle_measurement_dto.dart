
import 'measurement_dto.dart';

class RequestBundleMeasurementDto {
  RequestBundleMeasurementDto({
      this.agentId, 
      this.createdAt, 
      this.createdById, 
      this.customerLocalId, 
      this.gender, 
      this.hasServerIs, 
      this.lastUpdated, 
      this.uuid, 
      this.bundlesMeasurements, 
      this.occupiedServiceTrackingId, 
      this.occupiedServiceTrackingStateId,
      this.purchaserUserId,
      this.reportEmail, 
      this.id, 
      this.isSmsEnable, 
      this.userFullName, 
      this.userFullNameBn, 
      this.userId, 
      this.userPhoneNumber, 
      this.userUuid,});

  RequestBundleMeasurementDto.fromJson(dynamic json) {
    agentId = json['agent_id'];
    createdAt = json['created_at'];
    createdById = json['created_by_id'];
    customerLocalId = json['customer_local_id'];
    gender = json['gender'];
    hasServerIs = json['has_server_is'];
    lastUpdated = json['last_updated'];
    uuid = json['uuid'];
    if (json['bundles_measurements'] != null) {
      bundlesMeasurements = [];
      json['bundles_measurements'].forEach((v) {
        bundlesMeasurements?.add(MeasurementDTO.fromJson(v));
      });
    }
    occupiedServiceTrackingId = json['occupied_service_tracking_id'];
    occupiedServiceTrackingStateId = json['occupied_service_tracking_state_id'];
    purchaserUserId = json['purchaser_user_id'];
    reportEmail = json['report_email'];
    id = json['id'];
    isSmsEnable = json['is_sms_enable'];
    userFullName = json['user_full_name'];
    userFullNameBn = json['user_full_name_bn'];
    userId = json['user_id'];
    userPhoneNumber = json['user_phone_number'];
    userUuid = json['user_uuid'];
  }
  String? agentId;
  int? createdAt;
  int? createdById;
  String? customerLocalId;
  int? gender;
  bool? hasServerIs;
  int? lastUpdated;
  String? uuid;
  List<MeasurementDTO>? bundlesMeasurements;
  int? occupiedServiceTrackingId;
  int? occupiedServiceTrackingStateId;
  int? purchaserUserId;
  String? reportEmail;
  int? id;
  bool? isSmsEnable;
  String? userFullName;
  String? userFullNameBn;
  int? userId;
  String? userPhoneNumber;
  String? userUuid;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['agent_id'] = agentId;
    map['created_at'] = createdAt;
    map['created_by_id'] = createdById;
    map['customer_local_id'] = customerLocalId;
    map['gender'] = gender;
    map['has_server_is'] = hasServerIs;
    map['last_updated'] = lastUpdated;
    map['uuid'] = uuid;
    if (bundlesMeasurements != null) {
      map['bundles_measurements'] = bundlesMeasurements?.map((v) => v.toJson()).toList();
    }
    map['occupied_service_tracking_id'] = occupiedServiceTrackingId;
    map['occupied_service_tracking_state_id'] = occupiedServiceTrackingStateId;
    map['purchaser_user_id'] = purchaserUserId;
    map['report_email'] = reportEmail;
    map['id'] = id;
    map['is_sms_enable'] = isSmsEnable;
    map['user_full_name'] = userFullName;
    map['user_full_name_bn'] = userFullNameBn;
    map['user_id'] = userId;
    map['user_phone_number'] = userPhoneNumber;
    map['user_uuid'] = userUuid;
    return map;
  }

}