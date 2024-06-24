//
//  AccelerometerManager.swift
//  nyoba-mini2
//
//  Created by mac.bernanda on 10/06/24.
//

import Foundation
import CoreMotion
import SpriteKit
import CoreMotion

class AccelerometerManager {
    private var motionManager: CMMotionManager
    private var sensitivity: CGFloat
    private var node: SKSpriteNode?
    
    var acceleration: CMAcceleration? // Store the latest accelerometer data
    
    init(node: SKSpriteNode?, sensitivity: CGFloat = 250.0) {
        self.node = node
        self.sensitivity = sensitivity
        self.motionManager = CMMotionManager()
    }

    func startAccelerometerUpdates(multiplier: CGFloat = 1) {
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 0.1
            
            motionManager.startAccelerometerUpdates(to: .main) { [weak self] (data, error) in
                guard let self = self, let data = data else { return }
                self.handleAccelerometerData(data, multiplier: multiplier)
            }
        }
    }
    
    func startAccelerometerUpdates(sensitivity: CGFloat, multiplier: CGFloat = 1) {
        self.sensitivity = sensitivity
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 0.1
            
            motionManager.startAccelerometerUpdates(to: .main) { [weak self] (data, error) in
                guard let self = self, let data = data else { return }
                self.handleAccelerometerData(data, multiplier: multiplier)
            }
        }
    }
    
    func getAdjustedAccelData() -> CMAcceleration? {
        guard let accel = acceleration else {
            print("getAdjustedAccelData: error getting acceleration")
            return nil
            
        }
        return CMAcceleration(x: accel.x * sensitivity, y: accel.y * sensitivity, z: accel.z * sensitivity)
    }
    

    private func handleAccelerometerData(_ data: CMAccelerometerData, multiplier: CGFloat = 1) {
        sensitivity = sensitivity * multiplier
        // TODO: Handle device orientation (landscape)
//        var updatedAcceleration: CMAcceleration
        
        // Determine device orientation
//        let deviceOrientation = UIDevice.current.orientation
        
        // Adjust or negate acceleration based on orientation
//        switch deviceOrientation {
//        case .landscapeLeft:
//            print("lright")
//            updatedAcceleration = CMAcceleration(x: -data.acceleration.y, y: data.acceleration.x, z: data.acceleration.z)
//        case .landscapeRight:
//            print("lleft")
//            updatedAcceleration = CMAcceleration(x: data.acceleration.y, y: -data.acceleration.x, z: data.acceleration.z)
//        default:
//            print("selain")
//            updatedAcceleration = data.acceleration
//        }
        
        let updatedAcceleration = CMAcceleration(x: -data.acceleration.y, y: data.acceleration.x, z: data.acceleration.z)
        self.acceleration = updatedAcceleration
        
        // tambahin ini biar bisa dorong tipis2
        if let penguinNode = node {
            penguinNode.physicsBody?.applyForce(CGVector(dx: CGFloat(updatedAcceleration.x) * sensitivity, dy: CGFloat(updatedAcceleration.x) * sensitivity * 1.5))
        }
        
    }

}
