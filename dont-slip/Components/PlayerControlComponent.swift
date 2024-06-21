//
//  PlayerControlComponent.swift
//  dont-slip
//
//  Created by Althaf Nafi Anwar on 13/06/24.
//

import Foundation
import SpriteKit
import GameplayKit


class PlayerControlComponent: GKComponent {
    // MARK: Properties
    let accelManager: AccelerometerManager
    let spriteComponent: SpriteComponent
    
    // MARK: Initializers
    init(accelManager: AccelerometerManager, spriteComponent: SpriteComponent) {
        self.accelManager = accelManager
        self.spriteComponent = spriteComponent
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        moveBasedOnAccelerometer()
    }
    
    // MARK: Movement functions
    func jump() {
        
        guard let penguinBody = spriteComponent.node.physicsBody else {
            print("jump: errror defining penguinBody")
            return
        }
        
        // Apply force when jumping, enables side by side movement while mid-air
        guard let xComponent = accelManager.acceleration?.x else {
            print("jump: failed to get x accel component")
            return
        }
        
        let jumpImpulse = CGVector(dx: xComponent, dy: 25)
        penguinBody.applyImpulse(jumpImpulse)
        
    }
    
    // Function to handle movement in the x-direction based on accelero
    func moveBasedOnAccelerometer() {
        
        guard let penguinBody = spriteComponent.node.physicsBody else {
//            print("movePenguin: errror defining penguinBody")
            return
        }
        
        guard let adjustedAccel = accelManager.getAdjustedAccelData() else {
//            print("movePenguin: error getting adjusted accel data")
            return
        }
        
        // Apply force to move side by side
        penguinBody.applyForce(CGVector(dx: adjustedAccel.x, dy: 0))
        penguinBody.velocity.dx = CGFloat(adjustedAccel.x)
    }
}
