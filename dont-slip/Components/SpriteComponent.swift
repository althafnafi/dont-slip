//
//  SpriteComponent.swift
//  dont-slip
//
//  Created by Althaf Nafi Anwar on 13/06/24.
//

import Foundation
import SpriteKit
import GameplayKit

class SpriteComponent: GKComponent {
    
    // MARK: Properties
    
    let node: SKSpriteNode

    // MARK: Initializers
    
    init(texture: SKTexture) {
        node = SKSpriteNode(texture: texture, color: .white, size: texture.size())
        super.init()
    }
    
    init(node: SKSpriteNode) {
        self.node = node
        super.init()
    }
    
    func setPos(pos: CGPoint) {
        node.position = pos
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
