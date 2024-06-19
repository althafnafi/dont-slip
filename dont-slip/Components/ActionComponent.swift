//
//  ActionComponent.swift
//  dont-slip
//
//  Created by Althaf Nafi Anwar on 13/06/24.
//

import Foundation
import SpriteKit
import GameplayKit

// TODO: Not used currently, remove maybe (?)
class ActionComponent: GKComponent {
    
    // MARK: Properties
    
    var actions: [SKAction]
    var node: SKSpriteNode
    
    
    // MARK: Initializers
    init(node: SKSpriteNode) {
        actions = []
        self.node = node
        super.init()
    }
    
    func addAction(_ action: SKAction) {
        actions.append(action)
    }
    
    func runActions() {
        for action in actions {
            self.node.run(action)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
