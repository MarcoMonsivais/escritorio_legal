

import 'package:openpay_flutter/model/card.dart';
import 'package:openpay_flutter/model/customer.dart';
import 'package:openpay_flutter/services/open_pay_base_service.dart';
import 'package:openpay_flutter/utils/openpay_client.dart';

class CustomerService extends OpenPayBaseService<Customer,Customer> {
  
  OpenPayClient _client;

  CustomerService(OpenPayClient httpClient) : super(httpClient);  
    

  
  
  @override  
  String get resourceName => "customers";

}