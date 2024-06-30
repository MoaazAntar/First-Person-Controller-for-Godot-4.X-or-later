# First Person Controller in Godot

## Introduction

This project is a First Person Controller built in Godot Engine 4.2.2. It includes functionalities such as movement, jumping, crouching, and sprinting. The project is designed to be a starting point for creating first-person games in Godot.

## Features

- **Movement:** Smooth and responsive player movement.
- **Jumping:** Simple jumping mechanic.
- **Crouching:** Ability to crouch with head cast detection to prevent standing under obstacles.
- **Sprinting:** Sprinting functionality with adjustable speed.
- **Mouse Look:** Intuitive mouse-based camera control.

## Usage

- **Movement:** Use `W`, `A`, `S`, `D` keys to move the player.
- **Jumping:** Press the `Space` key to jump.
- **Crouching:** Press the `C` key to crouch. Press again to stand up.
- **Sprinting:** Hold the `Shift` key to sprint.
- **Mouse Look:** Move the mouse to look around.

## Notes

- **IMPORTANT** If you want to adjust player's height [Capsule's height in CollisionShape3D.shape], do it in player.gd in the Inspector and **DON'T** forget to adjust HeadCast3D's position and it's shape's height, make sure the top matches the player's capsule
- The project is currently a basic implementation and may not include all edge cases.
- Ensure that you have the correct version of Godot Engine installed.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
