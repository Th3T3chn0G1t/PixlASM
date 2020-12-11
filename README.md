[![Build Status](https://api.travis-ci.com/Th3T3chn0G1t/PixlASM.svg)](https://travis-ci.com/Th3T3chn0G1t/PixlASM)

[![GPLV3LOGO](https://www.gnu.org/graphics/gplv3-or-later.png)](https://www.gnu.org/licenses/gpl-3.0.txt)

Creating the same game with increasing complexity due to decreasing size limitations.

The current projection is for the following sizes to be developed:
- 512    Bytes: Complete
- 1   Kilobyte: Incomplete
- 4  Kilobytes: Incomplete
- 10 Kilobytes: Incomplete

The premise of all versions is controlling a square that leaves an impassable trail behind, meaning that the player must make use of special 'tiles' to navigate the map(s).

Total planned features - reductions will be made for smaller versions:
- Movement around a map in an attempt to reach a goal 'tile' using funtional 'tiles'
- Scrolling maps
- Sound
- 32-bit mode
- 640x480 resolutiom

## Compilation

At the moment use `./run` to execute the 512 byte version. In the future argv[1] will select the size
