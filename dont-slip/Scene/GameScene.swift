import SpriteKit
import GameplayKit

enum CollisionMask: UInt32 {
    case none = 0
    case ground = 1
    case ball = 2
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
    var curTime: TimeInterval = 0
    private var lastUpdateTime: TimeInterval = 0
    var startTime: TimeInterval = 0

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
    var coinsLabel: SKLabelNode!
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
        addBackgroundImage()
        // Setup accelerometer
        self.accelerometerManager = AccelerometerManager(sensitivity: accelSensitivity)

        loadHighScore() // Load high score
        loadCoins()
        setupPointsLabel()
        setupScoreLabels() // Setup score labels
        startScoreTimer() // Start the score timer
        setupEntities()
        createEndlessWaves() // Create the wave animations
    }

    // MARK: Setting up entities
    func setupEntities() {
        // Define EntityManager
        entityManager = EntityManager(scene: self)

        /* Iceberg setup */
        // Define the iceberg entity
        let iceberg = Iceberg(imageName: "iceberg", entityManager: entityManager)
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
        if let _ = penguinEntity?.component(ofType: SpriteComponent.self),
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

    // MARK: Wave Animation

    func createEndlessWaves() {
        let waveNode1 = SKShapeNode()
        waveNode1.strokeColor = .clear
        waveNode1.fillColor = .topwave
        waveNode1.lineWidth = 2
        waveNode1.zPosition = 1 // In front of iceberg
        self.addChild(waveNode1)
        
        // Create the second wave node with light blue color
        let waveNode2 = SKShapeNode()
        waveNode2.strokeColor = .clear
        waveNode2.fillColor = .midwave
        waveNode2.lineWidth = 2
        waveNode2.zPosition = 2 // In front of waveNode1
        self.addChild(waveNode2)
        
        // Create the third wave node with magenta color
        let waveNode3 = SKShapeNode()
        waveNode3.strokeColor = .clear
        waveNode3.fillColor = .basewave
        waveNode3.lineWidth = 2
        waveNode3.zPosition = 3 // In front of waveNode2
        self.addChild(waveNode3)
        
        let waveWidth = self.size.width * 2
        let wavePath = createWavePath(amplitude: 15, wavelength: 250, width: waveWidth)
        
        waveNode1.path = wavePath
        waveNode2.path = wavePath
        waveNode3.path = wavePath
        
        // Position the waves slightly below each other
        waveNode1.position = CGPoint(x: -670, y: -400)
        waveNode2.position = CGPoint(x: -670, y: -410)
        waveNode3.position = CGPoint(x: -670, y: -420)
        
        let moveDuration1: TimeInterval = 5
        let moveDuration2: TimeInterval = 10
        let moveDuration3: TimeInterval = 15
        
        let moveLeft1 = SKAction.moveBy(x: -self.size.width, y: 0, duration: moveDuration1)
        let moveReset1 = SKAction.moveBy(x: self.size.width, y: 0, duration: 0)
        let moveSequence1 = SKAction.sequence([moveLeft1, moveReset1])
        let moveForever1 = SKAction.repeatForever(moveSequence1)
        
        let moveLeft2 = SKAction.moveBy(x: -self.size.width, y: 0, duration: moveDuration2)
        let moveReset2 = SKAction.moveBy(x: self.size.width, y: 0, duration: 0)
        let moveSequence2 = SKAction.sequence([moveLeft2, moveReset2])
        let moveForever2 = SKAction.repeatForever(moveSequence2)
        
        let moveLeft3 = SKAction.moveBy(x: -self.size.width, y: 0, duration: moveDuration3)
        let moveReset3 = SKAction.moveBy(x: self.size.width, y: 0, duration: 0)
        let moveSequence3 = SKAction.sequence([moveLeft3, moveReset3])
        let moveForever3 = SKAction.repeatForever(moveSequence3)
        
        waveNode1.run(moveForever1)
        waveNode2.run(moveForever2)
        waveNode3.run(moveForever3)
    }
    
    func createWavePath(amplitude: CGFloat, wavelength: CGFloat, width: CGFloat) -> CGPath {
        let path = CGMutablePath()
        let waveHeight: CGFloat = self.size.height / 2
        
        // Start at the bottom left corner
        path.move(to: CGPoint(x: 0, y: 0))
        
        // Move up to the starting point of the wave
        path.addLine(to: CGPoint(x: 0, y: waveHeight))
        
        // Draw the wave
        for x in stride(from: 0, to: width, by: 5) { // Increased step size for better performance
            let y = amplitude * sin(x / wavelength * 2 * .pi) + waveHeight
            path.addLine(to: CGPoint(x: x, y: y))
        }
        
        // Move down to the bottom right corner
        path.addLine(to: CGPoint(x: width, y: 0))
        
        // Close the path to form a complete shape
        path.closeSubpath()
        
        return path
    }
    
    func addBackgroundImage() {
            let background = SKSpriteNode(imageNamed: "bg")
        background.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
            background.zPosition = -1 // Ensure the background is behind other nodes
            background.size = self.size // Scale the background to fit the screen size
            self.addChild(background)
        }

}
