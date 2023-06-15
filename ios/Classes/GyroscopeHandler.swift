//
//  GyroscopeHandler.swift
//  gyroscope
//
//  Created by Werner Rosemann on 2023/06/15.
//

import Foundation
import Flutter
import SensingKit

class GyroscopeHandler: NSObject {

    private var eventSink: FlutterEventSink?
    private var sensingKit: SensingKitLib?
    
    
    override init() {
        super.init()
        sensingKit = SensingKitLib.shared()
    }

    func startListening(rate: UInt, eventSink: @escaping FlutterEventSink) {
        self.eventSink = eventSink
        do{
            let config = SKGyroscopeConfiguration()
            config.sampleRate = rate
            try sensingKit?.register(SKSensorType.Gyroscope,with: config)
            try sensingKit?.subscribe(to: SKSensorType.Gyroscope, withHandler: { (sensorType, sensorData, error) in
                
                if let error = error {
                    // Handle the error
                    print("Gyroscope sensor error: \(error.localizedDescription)")
                    return
                }
                
                if let data = sensorData as? SKGyroscopeData {
                    // Handle gyroscope data
                    let x = data.rotationRate.x
                    let y = data.rotationRate.y
                    let z = data.rotationRate.z
                    
                    // Send the gyroscope data to Flutter
                    let gyroscopeData = [x, y, z]
                    self.eventSink?(gyroscopeData)
                }
                
            })
            try sensingKit?.startContinuousSensing(with: SKSensorType.Gyroscope)
        }catch{
            
        }

    }

    func stopListening() {
        do{
            try sensingKit?.startContinuousSensing(with: SKSensorType.Gyroscope)
        }catch{
            
        }
        eventSink = nil
    }

}
