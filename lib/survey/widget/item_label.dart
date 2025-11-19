
import 'package:flutter/material.dart';
import 'package:flutter_rapid/flutter_rapid.dart';

import '../dto/field_dto.dart';

Widget ItemLabel(Field field) {
  return Container(
    width: double.infinity,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if( field.label != null)
          RichText(
            textAlign: TextAlign.left,
            text: TextSpan(
              text: field.serial!=null? '${field.serial!}. ${field.label!}': '${field.label!}',
              style:  const TextStyle(fontWeight: FontWeight.normal, fontSize: 16, color: Colors.black),
              children: <TextSpan>[
                if(field.required??false) const TextSpan(text: '*', style: TextStyle(color: Colors.red),),
              ],
            ),
          ),
          const SizedBox(height: 4,),
        ],
      ),
    ),
  ) ;
}

