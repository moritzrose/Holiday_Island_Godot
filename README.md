* I used to play this game as a child and loved it! I wanted a challenge, so I figured, why not trying to rebuild it in Godot ? Feel free to express interest if you wanna participate :)

So far I am working on automated map generation - my idea was to have a height map, where every tile is defined by 4 corners. I checked out the tiles (I downloaded the programm and got all the graphics) and noticed, that they can be identified by a 2x2 Matrix. For example: 
          0 1 
          0 0 
is a unique identifier for a tile, that is flat one three corners, and elevated on the remaining corner. Next step is, to somehow render the tiles according to my height map and then somehow adjust the graphics according to the current height (water, sand, gras) 
