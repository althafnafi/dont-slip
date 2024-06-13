//
//  RestoringTorqueComponent.swift
//  dont-slip
//
//  Created by Althaf Nafi Anwar on 13/06/24.
//

import Foundation
import GameplayKit
import SpriteKit


class RestoringTorqueComponent: GKComponent {
    
    // MARK: Properties
    let node: SKSpriteNode
    let restoringMult: CGFloat
    let dampingMult: CGFloat
    let animationDuration: TimeInterval
    var restoringTorqueAction: SKAction

    // MARK: Initializers
    
    init(node: SKSpriteNode, restoringMult: CGFloat, dampingMult: CGFloat, animationDuration: TimeInterval) {
        self.node = node
        self.restoringMult = restoringMult
        self.dampingMult = dampingMult
        self.animationDuration = animationDuration
        
        self.restoringTorqueAction = RestoringTorqueComponent.getAction(
            node: node,
            restoringMult: restoringMult,
            dampingMult: dampingMult,
            animationDuration: animationDuration
        )
        
        super.init()
        
        // Run the animations
        node.run(restoringTorqueAction)
        
    }
    
    static func getAction(node: SKSpriteNode, restoringMult: CGFloat, dampingMult: CGFloat, animationDuration: TimeInterval) -> SKAction {
        
        let restoringTorqueAction = SKAction.repeatForever(SKAction.customAction(withDuration: 0.1) { node, _ in
            
            if let physicsBody = node.physicsBody {
                let currentAngle = physicsBody.node?.zRotation ?? 0
                let angularVelocity = physicsBody.angularVelocity
                let restoringTorque = -currentAngle * restoringMult // Increased factor for faster restoration
                let dampingTorque = -angularVelocity * dampingMult // Damping factor to reduce oscillation
                physicsBody.applyTorque(restoringTorque + dampingTorque)
            }
        })
        
        return restoringTorqueAction
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
