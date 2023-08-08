import 'package:openpay_flutter/model/card.dart';
import 'package:openpay_flutter/services/open_pay_base_service.dart';
import 'package:openpay_flutter/utils/openpay_client.dart';

class CardService extends OpenPayBaseService<Card,Card> {
  
  OpenPayClient _client;

  CardService(OpenPayClient httpClient) : super(httpClient);  
    
  @override  
  String get resourceName => "customers";

  Future<List<Card>> getCustomerCards(String customerId){
    String endpoint = getEndpoint(reference:customerId);
    endpoint+="/cards";
    return  getList(Card(), endpoint:endpoint );              
  }

  Future<Card> getCustomerCard(String customerId, String cardId ){
    String endpoint = getEndpoint(reference:customerId);
    endpoint+="/cards/$cardId";
    return get(Card(),"",endpoint:endpoint);        
  }

  
  Future<Card> createCard(Card entity, {String endpoint = null})  {
    endpoint = getEndpoint(reference:entity.customer_id);
    endpoint+="/cards";
    return create(entity, endpoint:endpoint);
  }

Future<bool> removeCard(Card entity, {String endpoint = null})  {
    endpoint = getEndpoint(reference:entity.customer_id);
    endpoint+="/cards/${entity.id}.";
    return delete("", endpoint:endpoint);
  }






    

}