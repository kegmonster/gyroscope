//
//  GyroscopeHandler.swift
//  gyroscope
//
//  Created by Werner Rosemann on 2023/06/15.
//

import Foundation
import Flutter
import CoreMotion

class GyroscopeHandler: NSObject {

    private var eventSink: FlutterEventSink?
    private let motionManager = CMMotionManager()
    private var initialOrientation: CMRotationRate?
    private var lastTimestamp: TimeInterval = 0
    private var currentPitch: Double = 0
    private var currentRoll: Double = 0
    private var currentYaw: Double = 0
    
    
    override init() {
        super.init()
    }

    func startListening(rate: UInt, eventSink: @escaping FlutterEventSink) {
        self.eventSink = eventSink
        
        if motionManager.isGyroAvailable {
            motionManager.gyroUpdateInterval = TimeInterval(1/rate) // Update interval in seconds
            
            motionManager.startDeviceMotionUpdates(to: OperationQueue.main) { [weak self] (gyroData, error) in
                guard let self = self else { return }
                
                if let error = error {
                    // Handle error if needed
                    print("Gyroscope sensor error: \(error.localizedDescription)")
                    return
                }
                
                if let rotationRate = gyroData?.rotationRate {
                    if (self.lastTimestamp == 0){
                        self.lastTimestamp = gyroData!.timestamp
                    }
                    else{
                        let timestamp = gyroData!.timestamp
                        
                        // calculate the time elapsed since the last gyroscope data
                        let deltaTime = timestamp - self.lastTimestamp
                        
                        // integrate the rotation rate to get the change in angles
                        let deltaPitch = rotationRate.x * deltaTime
                        let deltaRoll = rotationRate.y * deltaTime
                        let deltaYaw = rotationRate.z * deltaTime
                        
                        // update the current orientation angles
                        self.currentPitch += deltaPitch
                        self.currentRoll += deltaRoll
                        self.currentYaw += deltaYaw
        
                        //normalize
                        self.currentPitch = self.normalizeAngle(self.currentPitch)
                        self.currentRoll = self.normalizeAngle(self.currentRoll)
                        self.currentYaw = self.normalizeAngle(self.currentYaw)
                        
                        // Send the current orientation angles to Flutter
                        self.eventSink?([self.currentPitch, self.currentRoll, self.currentYaw])
                        
                        // Update the last timestamp
                        self.lastTimestamp = timestamp
                    }
                }
            }
        }
        
    }
    
    func normalizeAngle(_ angle: Double) -> Double {
        var normalizedAngle = angle
        
        // Normalize the angle
        while normalizedAngle <= -Double.pi {
            normalizedAngle += (2 * Double.pi)
        }
        
        while normalizedAngle > Double.pi {
            normalizedAngle -= (2 * Double.pi)
        }
        
        return normalizedAngle
    }

    func stopListening() {
        motionManager.stopGyroUpdates()
        currentYaw = 0
        currentRoll = 0
        currentPitch = 0
        eventSink = nil
    }

}
