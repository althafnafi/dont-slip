//
//  GameScene.swift
//  nyoba-mini2
//
//  Created by Althaf Nafi Anwar on 10/06/24.
//
import SpriteKit
import GameplayKit

enum CollisionMask: UInt32 {
    case ground = 1
    case ball = 2
    case coin = 4
    case object = 8
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var spawnInterval: TimeInterval = 2.0
    var lastSpawnTime: TimeInterval = 0
    var lebarPlatform = UIScreen.main.bounds.width * 0.8
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime: TimeInterval = 0
    private var currentActiveCoins: Int = 0
    private var label: SKLabelNode?
    private var spinnyNode: SKShapeNode?
    
    /* Constants */
    private var groundCategory: UInt32 = 0b1 << 0 // 1
    private var ballCategory: UInt32 = 0b1 << 1 // 2
    private var coinCategory: UInt32 = 0b1 << 2 // 4
    
    private let restoringTorqueMult: CGFloat = 10.0
    private let dampingTorqueMult: CGFloat = 0.5
    private var gravMult: CGFloat = 1
    /* Constants */
    
    private var greenCube: SKSpriteNode? // the cube (penguin)
    
    private var pointsLabel: SKLabelNode! // Label to display points
    private var points: Int = 0
    
    private var coinsLabel : SKLabelNode!
    private var coinsCollected: Int = 0
    
    private var isGreenCubeOnGround = false // Flag to track if the green cube is on the ground
        
    private var gameOver: Bool = false
    
    // Scoring
    private var score: Int = 0
    private var highScore: Int = 0
    private var scoreLabel: SKLabelNode!
    private var highScoreLabel: SKLabelNode!
    
    private var totalCoins: Int = 0
    private var totalCoinsLabel: SKLabelNode!
    
    // Modality game over
    private var modalBackground: SKSpriteNode!
    private var bigContainer: SKSpriteNode!
    private var modalContainer: SKSpriteNode!
    private var buttonContainer: SKSpriteNode!
    private var scoreCoinContainer: SKSpriteNode!
    private var scoreContainer: SKSpriteNode!
    private var coinContainer: SKSpriteNode!
    private var highScoreContainer: SKSpriteNode!
    private var totalCoinContainer: SKSpriteNode!
    
    private var gameOverScoreLabel: SKLabelNode!
    private var gameOverCoinsLabel: SKLabelNode!
    private var gameOverLabel: SKLabelNode!
    private var restartButton: SKSpriteNode!
    private var homeButton: SKSpriteNode!
    private var scoreGameOverLabel: SKLabelNode!
    private var highScoreGameOverLabel: SKLabelNode!
    private var totalHighScoreLabel: SKLabelNode!
    private var coinGameOverLabel: SKLabelNode!
    private var totalLabel: SKLabelNode!
    private var totalCoinsGameOverLabel: SKLabelNode!
    
    func saveHighScore() {
        UserDefaults.standard.set(highScore, forKey: "HighScore")
    }

    func loadHighScore() {
        highScore = UserDefaults.standard.integer(forKey: "HighScore")
    }
    
    func saveCoins(){
        UserDefaults.standard.set(totalCoins, forKey: "TotalCoins")
    }
    
    func loadCoins(){
        totalCoins = UserDefaults.standard.integer(forKey: "TotalCoins")
    }

    func setupScoreLabels() {
        // Setup Score Label
        scoreLabel = SKLabelNode(text: "Score: \(score)")
        scoreLabel.fontSize = 48
        scoreLabel.fontColor = .white
        scoreLabel.horizontalAlignmentMode = .center
        scoreLabel.verticalAlignmentMode = .top
        scoreLabel.position = CGPoint(x: 0, y: self.size.height / 2 - 100)
        scoreLabel.zPosition = 100
        addChild(scoreLabel)
        
        // Setup High Score Label
        highScoreLabel = SKLabelNode(text: "High Score: \(highScore)")
        highScoreLabel.fontSize = 48
        highScoreLabel.fontColor = .yellow
        highScoreLabel.horizontalAlignmentMode = .center
        highScoreLabel.verticalAlignmentMode = .top
        highScoreLabel.position = CGPoint(x: 0, y: self.size.height / 2 - 150)
        highScoreLabel.zPosition = 100
        addChild(highScoreLabel)
    }
    
    func incrementScore() {
        score += 1
        scoreLabel.text = "Score: \(score)"
    }

    
    func startScoreTimer() {
        let wait = SKAction.wait(forDuration: 1.0)
        let incrementScore = SKAction.run { [weak self] in
            self?.incrementScore()
        }
        let sequence = SKAction.sequence([wait, incrementScore])
        let repeatForever = SKAction.repeatForever(sequence)
        run(repeatForever, withKey: "scoreTimer")
    }
    
    // Modality Game Over
    func showGameOverModal() {
        
        // Create background node to darken the screen
        modalBackground = SKSpriteNode(color: UIColor.black.withAlphaComponent(0.4), size: self.size)
        modalBackground.position = CGPoint(x: 0, y: 0)
        modalBackground.zPosition = 200
        addChild(modalBackground)
        
        // Biggest Container
        bigContainer = SKSpriteNode(color: UIColor.gray, size: CGSize(width: self.size.width * 0.5, height: self.size.height * 0.65))
        bigContainer.position = CGPoint(x: 0, y: 0)
        bigContainer.zPosition = 200
        addChild(bigContainer)
        
        // Create modal main content container
        modalContainer = SKSpriteNode(color: UIColor.brownn, size: CGSize(width: self.size.width * 0.5, height: self.size.height * 0.5))
        modalContainer.position = CGPoint(x: 0, y: (bigContainer.size.height - self.size.height * 0.5) / 2)
        modalContainer.zPosition = 201
        bigContainer.addChild(modalContainer)
        
        // Create button Container
        buttonContainer = SKSpriteNode(color: UIColor.purple, size: CGSize(width: bigContainer.self.size.width, height: self.size.height * 0.1))
        buttonContainer.position = CGPoint(x: 0, y: -(bigContainer.size.height - self.size.height * 0.1) / 2)
        buttonContainer.zPosition = 201
        bigContainer.addChild(buttonContainer)
        
        // "Game Over" label
        gameOverLabel = SKLabelNode(text: "GAME OVER")
        gameOverLabel.fontSize = 70
        gameOverLabel.fontColor = .white
        gameOverLabel.fontName = "Madness Hyperactive"
        gameOverLabel.position = CGPoint(x: 0, y: modalContainer.size.height / 4)
        gameOverLabel.zPosition = 202
        modalContainer.addChild(gameOverLabel)
        
        scoreCoinContainer = SKSpriteNode(color: UIColor.red, size: CGSize(width: modalContainer.size.width * 0.7, height: modalContainer.size.height * 0.6))
        scoreCoinContainer.position = CGPoint(x: 0, y: -50)
        scoreCoinContainer.zPosition = 202
        modalContainer.addChild(scoreCoinContainer)
        
        scoreContainer = SKSpriteNode(color: UIColor.blue, size: CGSize(width: scoreCoinContainer.size.width * 0.4, height: scoreCoinContainer.size.height * 0.9))
        scoreContainer.position = CGPoint(x: -125, y: 0)
        scoreContainer.zPosition = 203
        scoreCoinContainer.addChild(scoreContainer)
        
        // Create and configure score label
        gameOverScoreLabel = SKLabelNode(text: "Score")
        gameOverScoreLabel.fontSize = 36
        gameOverScoreLabel.fontColor = .white
        gameOverScoreLabel.fontName = "AlegreyaSansSC-Medium"
        gameOverScoreLabel.position = CGPoint(x: 0, y: 60)
        gameOverScoreLabel.zPosition = 204
        scoreContainer.addChild(gameOverScoreLabel)
        
        scoreGameOverLabel = SKLabelNode(text: "\(score)")
        scoreGameOverLabel.fontSize = 50
        scoreGameOverLabel.fontColor = .white
        scoreGameOverLabel.fontName = "AlegreyaSansSC-Bold"
        scoreGameOverLabel.position = CGPoint(x: 0, y: -10)
        scoreGameOverLabel.zPosition = 204
        scoreContainer.addChild(scoreGameOverLabel)
        
        highScoreGameOverLabel = SKLabelNode(text: "HIGHSCORE")
        highScoreGameOverLabel.fontName = "AlegreyaSansSC-Medium"
        highScoreGameOverLabel.fontSize = 20
        highScoreGameOverLabel.fontColor = .white
        highScoreGameOverLabel.position = CGPoint(x: 0, y: -50)
        highScoreGameOverLabel.zPosition = 204
        scoreContainer.addChild(highScoreGameOverLabel)
        
        totalHighScoreLabel = SKLabelNode(text: "\(highScore)")
        totalHighScoreLabel.fontName = "AlegreyaSansSC-ExtraBold"
        totalHighScoreLabel.fontSize = 20
        totalHighScoreLabel.fontColor = .white
        totalHighScoreLabel.position = CGPoint(x: 0, y: -80)
        totalHighScoreLabel.zPosition = 204
        scoreContainer.addChild(totalHighScoreLabel)
        
        
        // ----------------------------asdfasfsasafsafsafsafsa------------------------------------
        
        coinContainer = SKSpriteNode(color: UIColor.blue, size: CGSize(width: scoreCoinContainer.size.width * 0.4, height: scoreCoinContainer.size.height * 0.9))
        coinContainer.position = CGPoint(x: 125, y: 0)
        coinContainer.zPosition = 203
        scoreCoinContainer.addChild(coinContainer)
        
        // Create and configure coins label
        gameOverCoinsLabel = SKLabelNode(text: "Coin")
        gameOverCoinsLabel.fontName = "AlegreyaSansSC-Medium"
        gameOverCoinsLabel.fontSize = 36
        gameOverCoinsLabel.fontColor = .white
        gameOverCoinsLabel.position = CGPoint(x: 0, y: 60)
        gameOverCoinsLabel.zPosition = 204
        coinContainer.addChild(gameOverCoinsLabel)
        
        coinGameOverLabel = SKLabelNode(text: "+ \(coinsCollected)")
        coinGameOverLabel.fontName = "AlegreyaSansSC-Bold"
        coinGameOverLabel.fontSize = 50
        coinGameOverLabel.fontColor = .white
        coinGameOverLabel.position = CGPoint(x: 0, y: -10)
        coinGameOverLabel.zPosition = 204
        coinContainer.addChild(coinGameOverLabel)
        
        totalLabel = SKLabelNode(text: "TOTAL")
        totalLabel.fontName = "AlegreyaSansSC-Medium"
        totalLabel.fontSize = 20
        totalLabel.fontColor = .white
        totalLabel.position = CGPoint(x: 0, y: -50)
        totalLabel.zPosition = 204
        coinContainer.addChild(totalLabel)
        
        totalCoinsGameOverLabel = SKLabelNode(text: "\(totalCoins)")
        totalCoinsGameOverLabel.fontName = "AlegreyaSansSC-ExtraBold"
        totalCoinsGameOverLabel.fontSize = 20
        totalCoinsGameOverLabel.fontColor = .white
        totalCoinsGameOverLabel.position = CGPoint(x: 0, y: -80)
        totalCoinsGameOverLabel.zPosition = 204
        coinContainer.addChild(totalCoinsGameOverLabel)
        
        // Create restart button
        restartButton = SKSpriteNode(color: .red, size: CGSize(width: 300, height: buttonContainer.size.height))
        restartButton.position = CGPoint(x: buttonContainer.size.width / 2 - restartButton.size.width / 2, y: 0)
        restartButton.zPosition = 201
        restartButton.name = "restartButton"
        buttonContainer.addChild(restartButton)
        
        // Add a restart label to the button
        let restartLabel = SKLabelNode(text: "Restart")
        restartLabel.fontSize = 24
        restartLabel.fontColor = .white
        restartLabel.position = CGPoint(x: 0, y: -restartLabel.frame.size.height / 2)
        restartLabel.zPosition = 202
        restartButton.addChild(restartLabel)
        
        // Create home button (belom bisa ke home page)
        homeButton = SKSpriteNode(color: .red, size: CGSize(width: 300, height: buttonContainer.size.height))
        homeButton.position = CGPoint(x: -buttonContainer.size.width / 2 + restartButton.size.width / 2, y: 0)
        homeButton.zPosition = 201
        homeButton.name = "homeButton"
        buttonContainer.addChild(homeButton)
        
        // Add a home label to the button
        let homeLabel = SKLabelNode(text: "Home")
        homeLabel.fontSize = 24
        homeLabel.fontColor = .white
        homeLabel.position = CGPoint(x: 0, y: -restartLabel.frame.size.height / 2)
        homeLabel.zPosition = 202
        homeButton.addChild(homeLabel)
    }
    
    override func sceneDidLoad() {
        // Setup
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -9.8 * gravMult)
        loadHighScore() // Load high score
        loadCoins()
        setupPointsLabel()
        setupScoreLabels() // Setup score labels
        startSpawning()
        startScoreTimer() // Start the score timer
        spawnGround()
    }
    
    func touchDown(atPoint pos: CGPoint) {
        print("touchDown")
        makeGreenCubeJump() // call function
    }
    
    func touchMoved(toPoint pos: CGPoint) {
    }
    
    func touchUp(atPoint pos: CGPoint) {
        print("touchUp \(pos)")
        //spawnPhysicsObject(posClicked: pos)
    }
    
    
    func spawnGround() {
        // Define the anchor node
        let anchorNode = SKNode()
        
        anchorNode.position = CGPoint(x: 0, y: 0)
        anchorNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 1, height: 1))
        anchorNode.physicsBody?.isDynamic = false // Anchor node is static
        
        // Define the ground node
        let ground = SKSpriteNode(color: .white, size: CGSize(width: UIScreen.main.bounds.width * 0.8, height: 35))
        ground.position = CGPoint(x: 0, y: 0) // Middle of the screen
        ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
        
        // Set up the physics body properties
        ground.physicsBody?.isDynamic = true // Allows the ground to move
        ground.physicsBody?.affectedByGravity = true // Allow the ground to be affected by gravity
        ground.physicsBody?.allowsRotation = true // Allows the ground to rotate
        
        // Set up the category and contact bitmasks
        ground.physicsBody?.categoryBitMask = groundCategory
        ground.physicsBody?.contactTestBitMask = ballCategory
        ground.physicsBody?.collisionBitMask = ballCategory | CollisionMask.object.rawValue
        
        // Set the restitution (bounciness)
        ground.physicsBody?.restitution = 0.2
        ground.physicsBody?.friction = 0
        
        // Create a spring joint to allow vertical movement and rotation
        let springJoint = SKPhysicsJointSpring.joint(withBodyA: anchorNode.physicsBody!, bodyB: ground.physicsBody!, anchorA: anchorNode.position, anchorB: ground.position)
        springJoint.frequency = 1.8 // Spring frequency
        springJoint.damping = 0.1 // Spring damping
        
        // Add the nodes to the scene
        self.addChild(anchorNode)
        self.addChild(ground)
        
        // Add the spring joint to the physics world
        self.physicsWorld.add(springJoint)
        
        // Add an action to the ground to apply restoring torque with damping
        let groundAction = SKAction.repeatForever(SKAction.customAction(withDuration: 0.1) { node, _ in
            if let physicsBody = node.physicsBody {
                let currentAngle = physicsBody.node?.zRotation ?? 0
                let angularVelocity = physicsBody.angularVelocity
                let restoringTorque = -currentAngle * self.restoringTorqueMult // Increased factor for faster restoration
                let dampingTorque = -angularVelocity * self.dampingTorqueMult // Damping factor to reduce oscillation
                physicsBody.applyTorque(restoringTorque + dampingTorque)
            }
        })
        
        ground.run(groundAction)
        spawnTestCube(ground: ground)
    }
    
    func spawnTestCube(ground: SKSpriteNode) {
        // Add a green cube on top of the middle of the ground
        let cubeSize = CGSize(width: 30, height: 30)
        let greenCube = SKSpriteNode(color: .green, size: cubeSize)
        greenCube.position = CGPoint(x: 0, y: ground.position.y + ground.size.height / 2 + cubeSize.height / 2)
        greenCube.physicsBody = SKPhysicsBody(rectangleOf: cubeSize)

        // Set up the cube's physics body properties
        greenCube.physicsBody?.isDynamic = true
        greenCube.physicsBody?.affectedByGravity = true
        greenCube.physicsBody?.allowsRotation = false
        
        // bug fixed (probably)
        greenCube.physicsBody?.categoryBitMask = ballCategory
        greenCube.physicsBody?.collisionBitMask = groundCategory | CollisionMask.object.rawValue
        greenCube.physicsBody?.contactTestBitMask = coinCategory

        // Add the cube to the scene
        self.addChild(greenCube)
        
        // Store reference to the greenCube
        self.greenCube = greenCube
    }
    
    // function to make the cube jump
    func makeGreenCubeJump() {
        guard isGreenCubeOnGround, let greenCube = greenCube, let physicsBody = greenCube.physicsBody else {
            return
        }
        
        // Apply an upward impulse to the green cube
        let jumpImpulse = CGVector(dx: 0, dy: 25)
        physicsBody.applyImpulse(jumpImpulse)
        
        // Set the flag to false since the cube is now in the air
        isGreenCubeOnGround = false
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        // Check if the green cube is in contact with the ground
        if (contact.bodyA.node == greenCube && contact.bodyB.categoryBitMask == groundCategory) ||
           (contact.bodyB.node == greenCube && contact.bodyA.categoryBitMask == groundCategory) {
            isGreenCubeOnGround = true
        }
        
        // Check if the green cube is in contact with a coin
        if (contact.bodyA.node == greenCube && contact.bodyB.categoryBitMask == coinCategory) ||
           (contact.bodyB.node == greenCube && contact.bodyA.categoryBitMask == coinCategory) {
            if let coin = contact.bodyA.node == greenCube ? contact.bodyB.node : contact.bodyA.node {
                coin.removeFromParent() // Remove the coin from the scene
                currentActiveCoins -= 1
                coinsCollected += 1
                print("Coin collected!")
                updatePointsLabel()
            }
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        // Check if the green cube is no longer in contact with the ground
        if (contact.bodyA.node == greenCube && contact.bodyB.categoryBitMask == groundCategory) ||
           (contact.bodyB.node == greenCube && contact.bodyA.categoryBitMask == groundCategory) {
            isGreenCubeOnGround = false
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameOver {
            for t in touches {
                let location = t.location(in: self)
                let nodes = self.nodes(at: location)
                if nodes.contains(where: { $0.name == "restartButton" }) {
                    restartGame()
                    return
                }
                // belom bisa balik ke home
                if nodes.contains(where: { $0.name == "homeButton" }) {
                    print("Home Button CLICKED")
                    restartGame()
                    return
                }
            }
        } else {
            for t in touches { self.touchDown(atPoint: t.location(in: self)) }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    // start to spawn falling obstacles
    func startSpawning() {
        let wait = SKAction.wait(forDuration: spawnInterval)
        let spawn = SKAction.run { [weak self] in
            self?.spawnObject()
            self?.spawnCoin()
        }
        let sequence = SKAction.sequence([wait, spawn])
        let repeatForever = SKAction.repeatForever(sequence)
        run(repeatForever)
    }

    // spawn falling obstacles on random position
    func spawnObject() {
        if gameOver {
            return // Stop spawning new objects
        }
        
        let object = SKSpriteNode(color: .red, size: CGSize(width: 30, height: 30))
        let xPosition = CGFloat.random(in: -320...lebarPlatform)
        object.position = CGPoint(x: xPosition, y: self.size.height)
        object.physicsBody = SKPhysicsBody(rectangleOf: object.size)
        object.physicsBody?.isDynamic = true
        object.physicsBody?.categoryBitMask = CollisionMask.object.rawValue
        object.physicsBody?.contactTestBitMask = CollisionMask.ball.rawValue
        object.physicsBody?.collisionBitMask = groundCategory | ballCategory | CollisionMask.object.rawValue
        addChild(object)

        // Reduce the spawn interval to increase difficulty over time
        spawnInterval = max(spawnInterval * 0.95, 0.5)
    }

    // Function to spawn a coin (gold box)
    func spawnCoin() {
        if gameOver || currentActiveCoins >= 2 {
            return // Stop spawning new objects
        }
        
        let coin = SKSpriteNode(color: .yellow, size: CGSize(width: 20, height: 20))
        let xPosition = CGFloat.random(in: -lebarPlatform / 2.5...lebarPlatform/2.5)
        let yPosition = CGFloat.random(in: self.size.height / 2 * 0.3...self.size.height / 2 * 0.4)
        coin.position = CGPoint(x: xPosition, y: yPosition)
        
        coin.physicsBody = SKPhysicsBody(rectangleOf: coin.size)
        coin.physicsBody?.isDynamic = false
        coin.physicsBody?.affectedByGravity = false // Coin will float
        coin.physicsBody?.categoryBitMask = coinCategory
        coin.physicsBody?.contactTestBitMask = ballCategory
        coin.physicsBody?.collisionBitMask = 0
        
        addChild(coin)
        currentActiveCoins += 1
        
        // Add "breathing" animation
        let scaleUp = SKAction.scale(to: 1.5, duration: 1)
        let scaleDown = SKAction.scale(to: 1.0, duration: 1.5)
        let breathingAnimation = SKAction.repeatForever(SKAction.sequence([scaleUp, scaleDown]))
        coin.run(breathingAnimation)
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
            //showRestartButton()
            showGameOverModal()
            coinsCollected = 0
        }
    }


//    func showRestartButton() {
//        if let symbolImage = UIImage(systemName: "arrow.counterclockwise.circle") {
//            let texture = SKTexture(image: symbolImage)
//            let restartButton = SKSpriteNode(texture: texture)
//            restartButton.color = .red // Optional: if you want to apply tint color
//            restartButton.size = CGSize(width: 60, height: 60) // Adjust size as needed
//            restartButton.position = CGPoint(x: 0, y: 0)
//            restartButton.name = "restartButton"
//            self.addChild(restartButton)
//        } else {
//            print("Failed to create the SF Symbol image")
//        }
//    }

    
    func restartGame() {
        self.removeAllChildren()
        self.removeAllActions()
        gameOver = false
        score = 0
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
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
        
        if currentTime - lastSpawnTime > spawnInterval {
            lastSpawnTime = currentTime
            spawnObject()
            spawnCoin() // Add this line to ensure coins spawn during the update cycle
        }
        
        checkGameOver()
    }
    
    /* Labels */
    func setupPointsLabel() {
        pointsLabel = SKLabelNode(text: "Coins: \(self.coinsCollected)")
        pointsLabel.fontSize = 48
        pointsLabel.fontColor = .white
        pointsLabel.horizontalAlignmentMode = .center
        pointsLabel.verticalAlignmentMode = .top
        pointsLabel.position = CGPoint(x: 0, y: -100)
        pointsLabel.zPosition = 100
        
        addChild(pointsLabel)
        
        // Setup Total Coin Label
        totalCoinsLabel = SKLabelNode(text: "Total Coins: \(totalCoins)")
        totalCoinsLabel.fontSize = 48
        totalCoinsLabel.fontColor = .yellow
        totalCoinsLabel.horizontalAlignmentMode = .center
        totalCoinsLabel.verticalAlignmentMode = .top
        totalCoinsLabel.position = CGPoint(x: 0, y: -150)
        totalCoinsLabel.zPosition = 100
        
        addChild(totalCoinsLabel)
    }
    
    func updatePointsLabel() {
        pointsLabel.text = "Coins: \(self.coinsCollected)"
    }
}
