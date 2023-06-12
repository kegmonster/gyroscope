import Flutter
import UIKit
import SensingKit

public class GyroscopePlugin: NSObject, FlutterPlugin {
    
    private var sensingKit: SensingKitLib?
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "gyroscope", binaryMessenger: registrar.messenger())
    let instance = GyroscopePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
 
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
        test()
    default:
      result(FlutterMethodNotImplemented)
    }
  }
    
    public func test(){
        sensingKit = SensingKitLib.shared()
        do{
            try  sensingKit?.register(SKSensorType.Gyroscope)
            try sensingKit?.subscribe(to: SKSensorType.Gyroscope, withHandler: { (sensorType, sensorData, error) in

                   if (error == nil) {
                       let gyro = sensorData as! SKGyroscopeData
                       print("b: \(gyro.csvString)")
                       do {
                           try self.sensingKit?.stopContinuousSensing(with:SKSensorType.Gyroscope)
                       }
                       catch {
                           // Handle error
                       }
                   }
                
               })
        }
        catch {
            // Handle error
        }
        // Start
        do {
            try sensingKit?.startContinuousSensing(with:SKSensorType.Gyroscope)
        }
        catch {
            // Handle error
        }

        // Stop
        
    }
}
