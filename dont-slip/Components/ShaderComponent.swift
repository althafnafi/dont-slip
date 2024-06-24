//
//  ShaderComponent.swift
//  dont-slip
//
//  Created by mac.bernanda on 20/06/24.
//

import Foundation
import GameplayKit

class ShaderComponent: GKComponent {
    var node: SKSpriteNode?
    
    init(node: SKSpriteNode) {
        self.node = node
        super.init()
    }
    
    func applyShader(shader: SKShader) {
        if let node = self.node {
            node.shader = shader
        }
    }
    
    func removeShader() {
        if let node = self.node {
            node.shader = nil
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
