TILE_SIZE = 50

class window.Tile
	constructor: (@row, @col) ->
		@x = @col * TILE_SIZE
		@y = @row * TILE_SIZE
		@colorIndex = 0
		@hasMoved = false
		@userCanMove = false
		@neighbors = [null, null, null] #left, bottom, right neighbors