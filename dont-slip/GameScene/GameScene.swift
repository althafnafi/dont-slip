//
//  GameScene.swift
//  nyoba-mini2
//
//  Created by Althaf Nafi Anwar on 10/06/24.
//

import SpriteKit
import GameplayKit

enum CollisionMask : UInt32 {
    case none = 0
    case ground = 1
    case ball   = 2
    case coin = 4
    case object = 8
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    /*
     USED
     */
    
    // Entities
    var entityManager: EntityManager!
    var penguinEntity: Penguin?
    var penguinControls: PlayerControlComponent?
    
    // Time-stuff
    var spawnInterval: TimeInterval = 2.0
    var obstacleSpawnInterval: TimeInterval = 2.0
    var coinSpawnInterval: TimeInterval = 2.0
    
    var lastSpawnTime: TimeInterval = 0
    var curTime : TimeInterval = 0
    private var lastUpdateTime : TimeInterval = 0
    var startTime : TimeInterval = 0
    
    // Constants
    private let restoringTorqueMult: CGFloat = 10.0
    private let dampingTorqueMult: CGFloat = 0.5
    private var gravMult: CGFloat = 1
    
    // Might change in the middle of the game
    var icebergWidth = UIScreen.main.bounds.width * 0.8
    var penguinMass: CGFloat = 0.04
    var accelSensitivity: CGFloat = 300
    
    // States (booleans)
    var isPenguinOnGround = false // Flag to track if the green cube is on the ground
    var gameOver: Bool = false
    
    // Sound/Music
    
    // Coins
    var coinsLabel : SKLabelNode!
    var coinsCollected: Int = 0
    var currentActiveCoins: Int = 0
    
    // Points
    internal var pointsLabel: SKLabelNode! // Label to display points
    internal var points: Int = 0
    
    // Accelerometer
    private var accelerometerManager: AccelerometerManager?
    

    /*
     NEED TO EDIT
     */
    
    // Scoring
    var score: Int = 0
    var highScore: Int = 0
    var scoreLabel: SKLabelNode!
    var highScoreLabel: SKLabelNode!

    var totalCoins: Int = 0
    var totalCoinsLabel: SKLabelNode!

    var greenCube: SKSpriteNode? // the cube (penguin)
    
    // Modality game over
    var modalBackground: SKSpriteNode!
    var bigContainer: SKSpriteNode!
    var modalContainer: SKSpriteNode!
    var buttonContainer: SKSpriteNode!
    var scoreCoinContainer: SKSpriteNode!
    var scoreContainer: SKSpriteNode!
    var coinContainer: SKSpriteNode!
    var highScoreContainer: SKSpriteNode!
    var totalCoinContainer: SKSpriteNode!
        
    var gameOverScoreLabel: SKLabelNode!
    var gameOverCoinsLabel: SKLabelNode!
    var gameOverLabel: SKLabelNode!
    var restartButton: SKSpriteNode!
    var homeButton: SKSpriteNode!
    var scoreGameOverLabel: SKLabelNode!
    var highScoreGameOverLabel: SKLabelNode!
    var totalHighScoreLabel: SKLabelNode!
    var coinGameOverLabel: SKLabelNode!
    var totalLabel: SKLabelNode!
    var totalCoinsGameOverLabel: SKLabelNode!
    
    override func sceneDidLoad() {
        // Setup physicsWorld bases
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        
        // Setup accelerometer
        self.accelerometerManager = AccelerometerManager(sensitivity: accelSensitivity)
        
//        setupEntities()
        
        loadHighScore() // Load high score
        
        loadCoins()
        
        setupPointsLabel()
        
        setupScoreLabels() // Setup score labels
        
        startScoreTimer() // Start the score timer
        
//        spawnGround()
        setupEntities()
        

    }
    
    // MARK: Setting up entities
    func setupEntities() {
        // Define EntityManager
        entityManager = EntityManager(scene: self)
        
        /* Iceberg setup */
        // Define the iceberg entity
        let iceberg = Iceberg(imageName: "iceberg",  entityManager: entityManager)
        // Add with entity manager
        entityManager.add(iceberg)
        
        /* Penguin: Pinjing Setup */
        let penguin = Penguin(
            imageName: "penguin",
            accelerometerManager: accelerometerManager,
            groundNode: iceberg.component(ofType: SpriteComponent.self)?.node,
            mass: penguinMass
        )
        
        print(penguin.component(ofType: SpriteComponent.self)?.node.physicsBody?.mass ?? "?")
        
        if let spriteComponent = penguin.component(ofType: SpriteComponent.self) {
            self.greenCube = spriteComponent.node
        }
        entityManager.add(penguin)
        penguinEntity = penguin
        
        penguinControls = getPenguinControls()
        
        /* Obstacles Setup */
        // Randomly spawns OBSTACLES
        randomlySpawnObjects(spawnerFunction: spawnObstacle, interval: obstacleSpawnInterval)
        
        /* Coins Setup */
        // Randomly spawns COINS
        randomlySpawnObjects(spawnerFunction: spawnCoin, interval: coinSpawnInterval)
        
    }
    
    func getPenguinControls() -> PlayerControlComponent? {
        if  let _ = penguinEntity?.component(ofType: SpriteComponent.self),
            let penguinControls = penguinEntity?.component(ofType: PlayerControlComponent.self) {
            print("getPenguinControls: got penguin controls :0")
            return penguinControls
        }
        
        print("getPenguinControls: failed to get penguin controls!")
        return nil
    }
    

    func checkGameOver() {
        guard let greenCube = greenCube else { return }
        if greenCube.position.y < -self.size.height / 2 { // Check if cube is below the visible screen
            gameOver = true
            totalCoins += coinsCollected
            saveCoins()
            currentActiveCoins = 0
            coinsCollected = 0

            // Stop the score timer
            removeAction(forKey: "scoreTimer")

            // Check and update high score
            if score > highScore {
                highScore = score
                saveHighScore()
            }
            showRestartButton()
        }
    }

    func showRestartButton() {
        if let symbolImage = UIImage(systemName: "arrow.counterclockwise.circle") {
            let texture = SKTexture(image: symbolImage)
            let restartButton = SKSpriteNode(texture: texture)
            restartButton.color = .red // Optional: if you want to apply tint color
            restartButton.size = CGSize(width: 60, height: 60) // Adjust size as needed
            restartButton.position = CGPoint(x: 0, y: 0)
            restartButton.name = "restartButton"
            self.addChild(restartButton)
        } else {
            print("Failed to create the SF Symbol image")
        }
    }

    
    func restartGame() {
        self.removeAllChildren()
        self.removeAllActions()
        
        score = 0
        gameOver = false
        
        sceneDidLoad() // Reinitialize the scene setup
    }
    
    override func update(_ currentTime: TimeInterval) {
        curTime = currentTime
        // Check game over state before running update logic
        if gameOver {
            return
        }
        
        if self.lastUpdateTime == 0 {
            self.lastUpdateTime = currentTime
        }
        
        let dt = currentTime - self.lastUpdateTime
        
        self.lastUpdateTime = currentTime
        
        // Update entities inside the entity manager
        entityManager.update(deltaTime: dt)
        
        // Update accelerometer
        accelerometerManager?.startAccelerometerUpdates()
        
        // Check if game over
        checkGameOver()
    }
    
   func resetTimers() {
       spawnInterval = 2.0
       obstacleSpawnInterval = 2.0
       coinSpawnInterval = 2.0
       }
}
