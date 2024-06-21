//
//  ShaderComponent.swift
//  dont-slip
//
//  Created by mac.bernanda on 20/06/24.
//

import Foundation
import GameplayKit

class ShaderComponent: GKComponent {
    //    var node: SKSpriteNode?
    var currentShader: SKShader?
    
    init(node: SKSpriteNode) {
        //        self.node = node
        self.currentShader = nil
        super.init()
    }
    
    func applyShader(node: SKSpriteNode, shader: SKShader) {
        node.shader = shader
        currentShader = shader
    }
    
    func removeShader(node : SKSpriteNode) {
        node.shader = nil
        currentShader = nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
