import Flutter
import UIKit

public class GyroscopePlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
    
    private var gyroscopeHandler: GyroscopeHandler = GyroscopeHandler()
    private var eventSink : FlutterEventSink?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "gyroscope", binaryMessenger: registrar.messenger())
        let instance = GyroscopePlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        
        let eventChannel = FlutterEventChannel(name: "gyro_update_channel", binaryMessenger: registrar.messenger())
        eventChannel.setStreamHandler(instance)
    }
    
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getPlatformVersion":
            result("iOS " + UIDevice.current.systemVersion)
            break
        case "subscribe":
            let rate = (call.arguments as! [String:Any])["rate"]
            if (eventSink != nil){
                gyroscopeHandler.startListening(rate: rate as! UInt, eventSink: eventSink!)
                result(true)
            }
            else{
                print("eventChannel not ready")
                result(false)
            }
            break
        case "unsubscribe":
            gyroscopeHandler.stopListening()
            break
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        return nil
    }
    
    
}
