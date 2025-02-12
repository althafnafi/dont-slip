import SpriteKit
import GameKit
import GameplayKit

enum CollisionMask: UInt32 {
    case none = 0
    case ground = 1
    case ball = 2
    case coin = 4
    case object = 8
    case iceFuel = 16
}

class GameScene: SKScene, SKPhysicsContactDelegate {

    /*
     USED
     */
    
    // Entities
    var entityManager: EntityManager!
    var penguinEntity: Penguin?
    var penguinControls: PlayerControlComponent?
    var icebergEntity: Iceberg?
    
    // Const (GANTI YANG DISINI)
    let defaultSpawnInterval: TimeInterval = 2.0
    let defaultObstacleSpawnInterval: TimeInterval = 0.5
    let defaultCoinSpawnInterval: TimeInterval = 2.0
    let defaultIcebergMeltInterval: TimeInterval = 8.0
    let defaultIceFuelInterval: TimeInterval = 12.0
    var defaultIcebergFrictionLevel: Double = 0.0 // 0  - 0.5
    var defaultObstacleMassMultiplier: Double = 1.0 // 1 - 2
    
    // Time-stuff
    var spawnInterval: TimeInterval = 2.0
    var obstacleSpawnInterval: TimeInterval = 0.5
    var coinSpawnInterval: TimeInterval = 2.0
    var icebergMeltInterval: TimeInterval = 8.0
    var iceFuelInterval: TimeInterval = 12
    var jumpCooldown: TimeInterval = 0.5
    
    var lastSpawnTime: TimeInterval = 0
    private var lastUpdateTime: TimeInterval = 0
    
    // Constants
    private let restoringTorqueMult: CGFloat = 10.0
    private let dampingTorqueMult: CGFloat = 0.5
    private var gravMult: CGFloat = 1
    
    // Might change in the middle of the game
    var penguinMass: CGFloat = 0.1
    
    var accelSensitivity: CGFloat = 300
    var icebergFrictionLevel: Double = 0.0 // 0  - 0.5
    var obstacleMassMultiplier: Double = 1.0 // 1 - 2
    
    // States (booleans)
    var isPenguinOnGround = false // Flag to track if the green cube is on the ground
//    var isPenguinNotOnGround = true
    var gameOver: Bool = false
    var isPenguinGotFuel = false
    
    // Sound/Music
    
    // Coins
    var coinsLabel: SKLabelNode!
    var coinsCollected: Int = 0
    var currentActiveCoins: Int = 0
    var isLeftCoinActive = false
    var isRightCoinActive = false
    
    // Might change in the middle of the game
    var icebergWidth = UIScreen.main.bounds.width * 0.8
    
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
    var penguinNode: SKSpriteNode?
    var blueModalBackground: SKSpriteNode!
    
    var gameOverScoreLabel: SKLabelNode!
    var gameOverCoinsLabel: SKLabelNode!
    var gameOverLabel: SKSpriteNode!
    var restartButton: SKSpriteNode!
    var homeButton: SKSpriteNode!
    var scoreGameOverLabel: SKLabelNode!
    var highScoreGameOverLabel: SKLabelNode!
    var totalHighScoreLabel: SKLabelNode!
    var coinGameOverLabel: SKLabelNode!
    var totalLabel: SKLabelNode!
    var totalCoinsGameOverLabel: SKLabelNode!
    var coinImgOver: SKSpriteNode!
    var coinImgOver2: SKSpriteNode!
    
    var icebergStateSystem: IcebergSystem!
    
    // Load Audio
    let coinSound = SKAction.playSoundFileNamed("coin.mp3", waitForCompletion: false)
    let splashSound = SKAction.playSoundFileNamed("splash.mp3", waitForCompletion: false)
    let jumpSound = SKAction.playSoundFileNamed("jump.wav", waitForCompletion: false)
    let iceSound = SKAction.playSoundFileNamed("icefuel.mp3", waitForCompletion: false)
    let backgroundSound = SKAudioNode(fileNamed: "bg.mp3")
    
    override func sceneDidLoad() {
        // Setup physicsWorld bases
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        addBackgroundImage()
        // Setup accelerometer
        accelerometerManager = AccelerometerManager(node: penguinNode, sensitivity: accelSensitivity)
        setupEntities()
        defaultChangingVar()
        loadHighScore() // Load high score
        loadCoins()
        setupPointsLabel()
        setupScoreLabels() // Setup score labels
        startScoreTimer() // Start the score timer
        createEndlessWaves() // Create the wave animations
        difficultyUpdater()
//        showIceFuelPowerUp()

        self.addChild(backgroundSound)
    }
    
    // MARK: Setting up entities
    func setupEntities() {
        // Define EntityManager
        entityManager = EntityManager(scene: self)
        
        /* Iceberg setup */
        // Define the iceberg entity
        
        
        let iceberg = Iceberg(nodeName: "iceberg_100", entityManager: entityManager, state: IcebergStateComponent())
        
        icebergStateSystem = IcebergSystem(entityManager: entityManager)
        
        // Add with entity manager
        entityManager.add(iceberg)
        icebergEntity = iceberg
        
        /* Penguin: Pinjing Setup */
        let penguin = Penguin(
            imageName: "penguin",
            accelerometerManager: accelerometerManager,
            groundNode: iceberg.component(ofType: SpriteComponent.self)?.node,
            mass: penguinMass
        )
        
        penguinNode = penguin.component(ofType: SpriteComponent.self)?.node
        
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
        
        
        randomlySpawnObjects(spawnerFunction: spawnIceFuel, interval: iceFuelInterval)
    }
    
    func getPenguinControls() -> PlayerControlComponent? {
        if let _ = penguinEntity?.component(ofType: SpriteComponent.self),
           let penguinControls = penguinEntity?.component(ofType: PlayerControlComponent.self) {
            print("getPenguinControls: got penguin controls :0")
            return penguinControls
        }
        
        print("getPenguinControls: failed to get penguin controls!")
        return nil
    }
    
    func defaultChangingVar() {
        spawnInterval = defaultSpawnInterval
        obstacleSpawnInterval = defaultObstacleSpawnInterval
        coinSpawnInterval = defaultCoinSpawnInterval
        icebergMeltInterval = defaultIcebergMeltInterval
        iceFuelInterval = defaultIceFuelInterval
        icebergFrictionLevel = defaultIcebergFrictionLevel
        obstacleMassMultiplier = defaultObstacleMassMultiplier
    }
    
    func checkGameOver() {
        guard let greenCube = greenCube else { return }
        if greenCube.position.y < -self.size.height / 2 { // Check if cube is below the visible screen
            run(splashSound)
            gameOver = true
            totalCoins += coinsCollected
            saveCoins()
            currentActiveCoins = 0
            
            defaultChangingVar()

            // Stop the score timer
            removeAction(forKey: "scoreTimer")

            // Check and update high score
            if score > highScore {
                highScore = score
                saveHighScore()
            }
            // showRestartButton()
            showGameOverModal()
            coinsCollected = 0
            
            reportScoreToGameCenter(score: score)
        }
    }

    func reportScoreToGameCenter(score: Int) {
        if GKLocalPlayer.local.isAuthenticated {
            let leaderboardID = "dontslip" // Ganti dengan ID leaderboard Anda
            GKLeaderboard.submitScore(score, context: 0, player: GKLocalPlayer.local, leaderboardIDs: [leaderboardID]) { error in
                if let error = error {
                    print("Error reporting score to Game Center: \(error.localizedDescription)")
                } else {
                    print("Score successfully reported to Game Center")
                }
            }
        }
    }
    
    func restartGame() {
        self.removeAllChildren()
        self.removeAllActions()
        
        score = 0
        gameOver = false
        isPenguinGotFuel = false
        
        sceneDidLoad() // Reinitialize the scene setup
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Check game over state before running update logic
        if gameOver {
            return
        }
        
        if self.lastUpdateTime == 0 {
            self.lastUpdateTime = currentTime
        }
        
        let dt = currentTime - self.lastUpdateTime
        
        self.lastUpdateTime = currentTime
        
//        // ngasal
//        if !isPenguinOnGround,
//           let penguinNode = penguinEntity?.component(ofType: SpriteComponent.self)?.node
//        {
//            penguinNode.physicsBody?.allowsRotation = false
////            print("A:\n\(penguinNode.zRotation)")
//        }
//        
//        if isPenguinOnGround,
//           let icebergNode = icebergEntity?.component(ofType: SpriteComponent.self)?.node,
//           let penguinNode = penguinEntity?.component(ofType: SpriteComponent.self)?.node
//        {
//            penguinNode.physicsBody?.allowsRotation = true
//            penguinNode.zRotation = icebergNode.zRotation
////            print("A:\n\(penguinNode.zRotation) V \(icebergNode.zRotation)")
//        }
        
        // Update entities inside the entity manager
        entityManager.update(deltaTime: dt)
        
        // Update the IcebergStateSystem
        icebergStateSystem.setTimeLimit(timeLimit: icebergMeltInterval)
        icebergStateSystem.update(deltaTime: dt)
        
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
    
    func addBackgroundImage() {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        background.zPosition = -1 // Ensure the background is behind other nodes
        background.size = self.size // Scale the background to fit the screen size
        self.addChild(background)
    }
}
