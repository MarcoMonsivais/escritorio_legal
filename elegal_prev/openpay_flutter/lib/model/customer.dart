import 'package:openpay_flutter/model/address.dart';
import 'package:openpay_flutter/model/open_pay_base_model.dart';
import 'package:openpay_flutter/model/store.dart';

import 'package:json_annotation/json_annotation.dart';

part 'customer.g.dart';

@JsonSerializable(nullable: true)
class Customer  extends OpenPayBaseModel
    {
Customer({
       this.external_id,
       this.name,
       this.email,
		   this.last_name,
		   this.phone_number,
		   this.address,
		   this.status,
		   this.clabe,
		   this.balance,
		   this.creation_date,       
		   this.requires_account,
		   this.store
});

		   String external_id;
       String name;
       String email;
		   String last_name;
		   String phone_number;
      
		   Address address;
		   String status;
		   String clabe;      
		   double balance;      
		   DateTime creation_date;       
		   bool requires_account;      
		   Store store;

       factory Customer.fromJson(Map<String, dynamic> json) => _$CustomerFromJson(json);
       Customer fromJson(Map<String, dynamic> json) => _$CustomerFromJson(json);
        Map<String, dynamic> toJson() => _$CustomerToJson(this);
    }