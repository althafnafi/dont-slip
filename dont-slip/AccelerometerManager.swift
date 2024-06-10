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
    weak var node: SKSpriteNode?
    
    var acceleration: CMAcceleration? // Store the latest accelerometer data
    
    init(node: SKSpriteNode?, sensitivity: CGFloat = 250.0) {
        self.node = node
        self.sensitivity = sensitivity
        self.motionManager = CMMotionManager()
    }

    func startAccelerometerUpdates() {
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 0.1
            motionManager.startAccelerometerUpdates(to: .main) { [weak self] (data, error) in
                guard let self = self, let data = data else { return }
                self.handleAccelerometerData(data)
            }
        }
    }

    private func handleAccelerometerData(_ data: CMAccelerometerData) {
        var updatedAcceleration: CMAcceleration
        
        // Determine device orientation
        let deviceOrientation = UIDevice.current.orientation
        
        // Adjust or negate acceleration based on orientation
        switch deviceOrientation {
        case .landscapeLeft:
            updatedAcceleration = CMAcceleration(x: -data.acceleration.y, y: data.acceleration.x, z: data.acceleration.z)
        case .landscapeRight:
            updatedAcceleration = CMAcceleration(x: data.acceleration.y, y: -data.acceleration.x, z: data.acceleration.z)
        default:
            updatedAcceleration = data.acceleration
        }
        
        self.acceleration = updatedAcceleration
        
        // Apply force to the green cube based on the adjusted or negated accelerometer data
        if let greenCube = node {
            greenCube.physicsBody?.applyForce(CGVector(dx: CGFloat(updatedAcceleration.x) * sensitivity, dy: 0))
        }
    }

}
