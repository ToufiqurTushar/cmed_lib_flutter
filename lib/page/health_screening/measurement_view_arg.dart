import '../../common/dto/master_data_dto.dart';

class MeasurementViewArg {
  MeasurementViewArg({
      this.isNestedRoute,
      this.isThemeV2,
      this.isAuto,
      this.masterDataDTO,
      this.heightUnit,
      this.heightInCm,
      this.heightInFeet,
      this.heightInInch,
      this.codeId,

  });
  bool? isNestedRoute;
  bool? isThemeV2;
  bool? isAuto;
  MasterDataDTO? masterDataDTO;
  String? heightUnit;
  double? heightInCm;
  String? heightInFeet;
  String? heightInInch;
  int? codeId;
}