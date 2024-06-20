//
//  PowerUp.swift
//  dont-slip
//
//  Created by Althaf Nafi Anwar on 13/06/24.
//

import Foundation
import SpriteKit
import GameplayKit

enum PowerUpType : UInt8 {
    case shield = 1
    case secondChance = 2
    
    var imageName: String {
        switch self {
        case .shield:
            return "shield"
        case .secondChance:
            return "secondChance"
        }
    }
}

class PowerUp: GKEntity {
    
    init(type: PowerUpType) {

        super.init()

        let spriteComponent = SpriteComponent(texture: SKTexture(imageNamed: type.imageName))
        addComponent(spriteComponent)

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
