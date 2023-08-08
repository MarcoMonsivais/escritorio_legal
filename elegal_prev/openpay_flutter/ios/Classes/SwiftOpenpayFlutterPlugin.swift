import Flutter
import UIKit
import Openpay

public class SwiftOpenpayFlutterPlugin: NSObject, FlutterPlugin {

  
  var openpay : Openpay!


  var sessionloaded:Bool = false;
  var sessionId:String = "";


   
  func successSessionID(sessionID: String) {
        sessionId = sessionID
        sessionloaded = true
  }


  func failSessionID(error: NSError) {
          sessionId = ""
        sessionloaded = true
  }




  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "openpay_flutter", binaryMessenger: registrar.messenger())
    let instance = SwiftOpenpayFlutterPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

 public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {

    sessionloaded = false;
   
        
    if (call.method.isEqual("getPlatformVersion")) {
       result("iOSes " + UIDevice.current.systemVersion)
     }else if(call.method.isEqual("getDeviceSessionId")){
        let arguments = call.arguments as! [String]
        
        let MERCHANT_ID:String = arguments[0]
        let API_KEY:String = arguments[0]

        if (openpay == nil){
            openpay = Openpay(withMerchantId: MERCHANT_ID, andApiKey: API_KEY, isProductionMode: false, isDebug: false)
        }
    
        openpay.createDeviceSessionId(successFunction: successSessionID, failureFunction: failSessionID)

        while(!sessionloaded){
          sleep(1)
        }

        
        result(sessionId)


    }
    else if(call.method.isEqual("validateCardCVV")){
        
    
  //      var cardNumber:String = call.argument("cardNumber")
  //       var cvv:String = call.argument("cvv")
        
        //var isValid:Bool = CardValidator.validateCVV(cvv, cardNumber)
        result(true);
    }

    
  }
}
