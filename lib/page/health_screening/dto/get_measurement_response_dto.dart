import 'package:cmed_lib_flutter/page/health_screening/dto/measurement_dto.dart';

import '../../../common/base/base_get_response_dto.dart';

class GetMeasurementResponseDTO extends BaseGetResponseDTO {
  List<MeasurementDTO>? content;

  GetMeasurementResponseDTO(
      {this.content,
      pageable,
      totalElements,
      last,
      totalPages,
      size,
      number,
      sort,
      first,
      numberOfElements,
      empty});

  GetMeasurementResponseDTO.fromJson(Map<String, dynamic> json) {
    if (json['content'] != null) {
      content = <MeasurementDTO>[];
      json['content'].forEach((v) {
        content!.add(MeasurementDTO.fromJson(v));
      });
    }
    pageable =
        json['pageable'] != null ? Pageable.fromJson(json['pageable']) : null;
    totalElements = json['totalElements'];
    last = json['last'];
    totalPages = json['totalPages'];
    size = json['size'];
    number = json['number'];
    sort = json['sort'] != null ? Sort.fromJson(json['sort']) : null;
    first = json['first'];
    numberOfElements = json['numberOfElements'];
    empty = json['empty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (content != null) {
      data['content'] = content?.map((v) => v.toJson()).toList();
    }
    if (pageable != null) {
      data['pageable'] = pageable?.toJson();
    }
    data['totalElements'] = totalElements;
    data['last'] = last;
    data['totalPages'] = totalPages;
    data['size'] = size;
    data['number'] = number;
    if (sort != null) {
      data['sort'] = sort?.toJson();
    }
    data['first'] = first;
    data['numberOfElements'] = numberOfElements;
    data['empty'] = empty;
    return data;
  }

}
