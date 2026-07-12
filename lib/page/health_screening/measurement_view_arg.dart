import '../../common/dto/master_data_dto.dart';

class MeasurementViewArg {
  MeasurementViewArg({
      this.isSusasthoV2,
      this.isAuto,
      this.masterDataDTO,

  });
  bool? isSusasthoV2;
  bool? isAuto;
  MasterDataDTO? masterDataDTO;
}