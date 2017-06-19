# ![](https://github.com/DmitrJuga/My2048/blob/master/My2048/Images.xcassets/AppIcon.appiconset/2048_app_icon-29@2x.png)  My 2048

**"My 2048"** - 2048 Clone Built with **Swift** and **SpriteKit**.

![](https://github.com/jamesjackson69/My2048/blob/English/screenshot1.png)
![](https://github.com/jamesjackson69/My2048/blob/English/screenshot2.png)


## Functionality

Simulated gameplay of the game 2048:
- the appearance of two random tiles ("2" or "4") at the beginning of the game;
- Shifting tiles with svaypami in any direction;
- "addition" of identical tiles;
- the appearance of a new tile ("2" or "4") in a random free cell after each move;
- the colors of the tiles correspond to the value in them and repeat the original game;
- animation when tiles appear and when "tiling" the tiles.

Restrictions: the account is not maintained, the achievement of the goal (2048) is not fixed.

## Technical details

- For rendering and animation, the ** SpriteKit ** framework is used (classes: `SKShapeNode` - field, tiles,` SKLabelNode` - values ​​in tiles, `SKScene`,` SKView`).
- Everything is implemented in the code, without the interface-builder.
- The implementation of the logic of the game is based on the State pattern (in the code - enum `TileState`).
- The `UISwipeGestureRecognizer` handler for shifting tiles.
- In the `Config` structure, the settings are set - the sizes and colors of all elements (including for each value in the tile).
- Auxiliary classes and extensions are used: `Matrix2D` is a two-dimensional array,` Matrix2D + Empties` is a `Matrix2D` extension for finding free positions,` UIColor + Hex` is an extension of `UIColor` for coloring by a hexadecimal number.
- App Icon (image from free web sources).
