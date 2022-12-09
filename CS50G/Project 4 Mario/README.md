# amWRit

# Super Mario Bros. Remake || CS50G

As part of learning through Harvard's CS50G "Introduction to Game Development" course, recreating the Super Mario Bros. game using Lua and LOVE2D.
Updates were made on the original source code provided by CS50, based on assignment specifications.

__LOVE 11.3__

# Assignment 4: “Super Mario Bros., The Key and Lock Update”

__Updates__

__Player drop on Solid Ground__
- Making sure that the player is spawned always from the column which is not empty so that when it falls, it drops on the solid ground.

__Lock and Key blocks__
- Spawn lock and key blocks
- The lock block can only be opened (by jump collision) when the player has consumed key block
- When the player consumes key block, show with an icon at the top
- When the player hits the lock block, make it disappear.

__Spawn Goal Post__
- When the lock block is opened using key by the player, indicate that the level is unlocked by a flag icon at the top.
- Also, spawn a goal post along with flag at the right end of the map.
- The goal post isn't spawned until lock block is opened.

__Next Level__
- When the player touches the flag in the goal post, the flag tweens and goes on the top of post.
- Then the level is changed/regenerated. As the level changes, the length of the map is increased.
