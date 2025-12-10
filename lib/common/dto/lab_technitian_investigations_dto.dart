import 'dart:io';
import 'package:dio/dio.dart'; // This includes MultipartFile and FormData
import 'package:flutter/cupertino.dart';
import 'package:cmed_lib_flutter/common/helper/file_utils.dart';


class LabTechnitianInvestigationDto {
  LabTechnitianInvestigationDto({
    this.investigationId,
    this.name,
    this.testTypeCode,
    this.sampleId,
    this.fileUrl,
    this.status,
    this.id,
    this.uuid,
    this.createdAt,
    this.lastUpdated,
    this.createdById,
    this.updatedById,
    this.patientId,
    this.sampleCollectionPlace,
    this.referralInvestigationId,
    this.investigationReportStatus,
    this.isReportUploaded,
    this.localImagePath,
    this.file,
    this.sampleIdText,
    this.isDisabled,

  });

  LabTechnitianInvestigationDto.fromJson(dynamic json) {
    investigationId = json['investigationId'];
    name = json['investigationName'] ?? json['name'];
    testTypeCode = json['investigationType'] ?? json['test_type_code'];
    sampleId = json['sample_id'];
    fileUrl = json['file_link'] ?? json['file_url'];
    status = json['status'] ?? json['investigation_report_status'];
    investigationReportStatus = json['investigation_report_status'];
    id = json['id'];
    uuid = json['uuid'];
    createdAt = json['created_at'];
    lastUpdated = json['last_updated'];
    createdById = json['created_by_id'];
    updatedById = json['updated_by_id'];
    patientId = json['patient_id'];
    sampleCollectionPlace = json['sample_collection_place'];
    referralInvestigationId = json['referral_investigation_id'];
  }

  int? investigationId;
  String? name;
  String? testTypeCode;
  String? sampleId;
  String? fileUrl;
  String? status;
  int? id;
  String? uuid;
  int? createdAt;
  int? lastUpdated;
  int? createdById;
  int? updatedById;
  int? patientId;
  String? sampleCollectionPlace;
  int? referralInvestigationId;
  String? investigationReportStatus;
  bool? isReportUploaded;
  String? localImagePath;
  File? file;
  String? sampleIdText;
  bool? isDisabled;


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['investigationId'] = investigationId;
    map['investigationName'] = name;
    map['investigationType'] = testTypeCode;
    map['sample_id'] = sampleId;
    map['file_link'] = fileUrl;
    map['status'] = status;
    map['investigation_report_status'] = investigationReportStatus;
    map['id'] = id;
    map['uuid'] = uuid;
    map['created_at'] = createdAt;
    map['last_updated'] = lastUpdated;
    map['created_by_id'] = createdById;
    map['updated_by_id'] = updatedById;
    map['patient_id'] = patientId;
    map['sample_collection_place'] = sampleCollectionPlace;
    map['referral_investigation_id'] = referralInvestigationId;
    return map;
  }

  FormData? getFormData() {
    if (file == null) return null;
    String filename = FileUtils.getFileNameFromFile(file) ?? 'report_file_${DateTime.now().millisecond}';
    return FormData.fromMap({
      "key": "6d207e02198a847aa98d0a2a901485a5",
      "source": MultipartFile.fromFileSync(file!.path, filename: filename),
    });
  }


  String? getFilePath() {
    if (file == null) return null;
    return file?.path;
  }

  MultipartFile? getMultipartFile() {
    if (file == null) return null;
    return MultipartFile.fromFileSync(
      file!.path,
      filename: FileUtils.getFileNameFromFile(file) ?? 'report_file_${DateTime.now().millisecond}',
    );
  }


  String? getName(){
    return FileUtils.getFileNameFromFile(file) ?? 'report_file_${DateTime.now().millisecond}';
  }
}
