

import 'package:openpay_flutter/model/open_pay_base_model.dart';
import 'package:openpay_flutter/utils/openpay_client.dart';

abstract class OpenPayBaseService<T extends OpenPayBaseModel,R extends OpenPayBaseModel>
{

  OpenPayClient _httpClient;
  OpenPayClient get httpClient => _httpClient;
  String get resourceName;
  
  
  OpenPayBaseService(this._httpClient);
  
  String getEndpoint({String reference = null, String endpoint = null}){

    if (endpoint!=null) return endpoint;

    String url= "";        
    var merchandid =  _httpClient.apiMerchandId;
    url = "$merchandid/$resourceName" ;
    if (reference != null){
      url += "/$reference";
    }
    return url;
  }


Future<T> submit(T out, R entity,{String endpoint = null,String reference = null}) async {
    endpoint = getEndpoint(endpoint:endpoint, reference:reference);
    var response = await _httpClient.post(endpoint, entity);
    return Future<T>.value(out.fromJson(response) as T);

    

  }

  Future<T> create(R entity,{String endpoint = null}) async {
    endpoint = getEndpoint(endpoint:endpoint);
    var response = await _httpClient.post(endpoint, entity);
    return Future<T>.value(entity.fromJson(response) as T);

    

  }

  Future<T> update(R entity,{String endpoint = null}) async {
    endpoint = getEndpoint(endpoint:endpoint,reference:entity.id);
    var response = await _httpClient.put(endpoint, entity);
    return Future<T>.value(entity.fromJson(response) as T);
  }


  Future<T> get(T type, String reference,{String endpoint = null}) async {
    endpoint = getEndpoint(reference:reference,endpoint:endpoint);    
    var response = await _httpClient.get(endpoint);    
    return Future<T>.value(type.fromJson(response) as T);
  }


  Future<bool> delete(String reference,{String endpoint=null}){
    endpoint = getEndpoint(reference:reference,endpoint:endpoint);
    return _httpClient.delete(endpoint);
  }

  Future<List<T>> getList(T type,{String endpoint=null,Map<String,String> filters}) async {
    endpoint = getEndpoint(endpoint:endpoint);    
    String filterStr = "";
    if (filters!=null)
    filters.forEach((k,v) => filterStr == "" ? filterStr+= "?$k=$v" : filterStr+= "&$k=$v");    
    endpoint += filterStr;
    var response = await _httpClient.getList(endpoint);    
    var result = response.map((f) => type.fromJson(f) as T).toList();
    return result;        
  }




    
  
}
