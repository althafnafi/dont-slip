# Don't Slip

**Don't Slip** is an obstacle course game where players control a penguin on a shrinking iceberg. The game uses device tilt and touch inputs to navigate through various challenges, collecting points and coins while avoiding obstacles.

## Table of Contents

- [Game Overview](#game-overview)
- [Gameplay Mechanics](#gameplay-mechanics)
  - [Player Movement](#player-movement)
  - [Increasing Difficulty](#increasing-difficulty)
  - [Obstacles and Interactions](#obstacles-and-interactions)
  - [Iceberg Behavior](#iceberg-behavior)
  - [Point and Coin Collection](#point-and-coin-collection)
  - [Power-ups](#power-ups)
- [Platform and Input](#platform-and-input)
- [Getting Started](#getting-started)
- [Credits](#credits)
- [License](#license)

## Game Overview

**Don't Slip** is a single-player game designed for iOS and iPadOS devices. Players must navigate a penguin on an iceberg, controlling its movements through device tilts and screen taps. The goal is to survive as long as possible, collecting points and coins, while avoiding obstacles that fall from above.

## Gameplay Mechanics

### Player Movement

- **Gravity Control:** Tilt the device to control the penguin’s position on the iceberg.
- **Jump Mechanism:** Tap the screen to make the penguin jump, avoiding obstacles.

### Increasing Difficulty

- **Progressive Challenge:** As the game progresses, obstacles appear more frequently, and the iceberg melts faster, increasing the game's difficulty level.

### Obstacles and Interactions

- **Random Falling Obstacles:** Obstacles fall from above at random intervals, hindering the penguin.
- **Obstacle Physics:** Obstacles react to the tilt of the iceberg, potentially pushing the penguin off.
- **Collision Dynamics:** The penguin can collide with obstacles, affecting its balance and position.
- **Obstacle Influence:** Falling obstacles can tilt the iceberg, adding to the challenge.

### Iceberg Behavior

- **Shrinking Iceberg:** The iceberg melts over time, reducing its surface area.
- **Player Constraints:** The penguin must keep moving and cannot stay in the center of the iceberg for too long.

### Point and Coin Collection

- **Time-Based Points:** Earn points based on how long the penguin stays on the iceberg.
- **Coin Collection:** Collect coins that appear randomly, which can be used to buy skins in the store.

### Power-ups

- **Iceberg Expansion:** Temporarily enlarges the iceberg, providing more space.
- **Shield/Second Chance:** Offers extra protection or a second chance if the penguin falls.
- **Ice Freeze:** Stops the iceberg from melting for a short period.
- **Obstacle Removal:** Removes all obstacles on the screen temporarily.

## Platform and Input

- **Platform:** iOS & iPadOS
- **Input:** Touch Input & Motion Input

## Getting Started

1. **Clone the repository:**
   ```sh
   git clone https://github.com/yourusername/dont-slip.git
   ```
2. **Navigate to the project directory:**
   ```sh
   cd dont-slip
   ```
3. **Install dependencies:**
   ```sh
   pod install
   ```
4. **Open the project in Xcode:**
   ```sh
   open DontSlip.xcworkspace
   ```
5. **Build and run the project on your iOS device or simulator.**

## Credits

**Don't Slip** was developed by CRTeam. Special thanks to all the contributors and testers.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

Enjoy playing **Don't Slip**! If you have any questions or feedback, feel free to open an issue or submit a pull request.
