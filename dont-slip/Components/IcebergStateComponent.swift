//
//  IcebergStateComponent.swift
//  dont-slip
//
//  Created by mac.bernanda on 20/06/24.
//

import Foundation
import GameplayKit

class IcebergStateComponent: GKComponent {
    var states: [Int] = [100, 80, 60, 40, 20, 0]
    var currentStateIndex: Int = 0
    var timeSinceLastChange: TimeInterval = 0
    var images: [String] = ["iceberg_100", "iceberg_80", "iceberg_60", "iceberg_40", "iceberg_20", "done"]

    init(currentStateIndex : Int = 0, timeSinceLastChange : TimeInterval = 0) {
        self.currentStateIndex = currentStateIndex
        self.timeSinceLastChange = timeSinceLastChange
        super.init()
    }

    var currentState: Int {
        return states[currentStateIndex]
    }

    var currentImage: String {
        return images[currentStateIndex]
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
