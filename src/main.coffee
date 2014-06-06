###
	Coffeescript file that controls game logic and canvas rendering
	Written by Connor Taylor
###

###										Constants										###

COLORS = ["#FFFF00", "#FF9900", "#FF0000", "#9900FF", "#0000FF", "#00FF00", "#000000"]
MAX_COLOR_INDEX = 6
BOARD_WIDTH = 1200
BOARD_HEIGHT = 800
TILE_SIZE = 50
MAX_ROWS = BOARD_HEIGHT / TILE_SIZE
MAX_COLS = BOARD_WIDTH / TILE_SIZE
MAX_X = BOARD_WIDTH - TILE_SIZE
MAX_Y = BOARD_HEIGHT - TILE_SIZE

###										Classes											###
class CanvasRenderer
	constructor: (@canvas) ->
		@ctx = @canvas.getContext('2d')

	renderTile: (tile) ->
		@ctx.fillStyle = COLORS[tile.colorIndex]
		@ctx.fillRect(tile.x, tile.y, TILE_SIZE, TILE_SIZE)

	clear: ->
		@ctx.clearRect(0, 0, BOARD_WIDTH, BOARD_HEIGHT)


class Tile
	constructor: (@x, @y) ->
		@colorIndex = 0
		@hasMoved = false


class Board
	constructor: ->
		@tiles = for x in [0...MAX_ROWS]
			for y in [0...MAX_COLS]
				null
		@renderer = new CanvasRenderer(document.getElementById('gameBoard'))

		row = MAX_ROWS - 1
		col = Math.floor(Math.random() * MAX_COLS)
		x = col * TILE_SIZE
		y = row * TILE_SIZE
		@tiles[row][col] = new Tile(x,y)

	render: ->
		@renderer.clear()

		count = 0
		for x in [0...MAX_ROWS]
			for y in [0...MAX_COLS]
				@renderer.renderTile(@tiles[x][y]) if @tiles[x][y] != null

	spawnTile: ->
		row = 0
		col = Math.floor(Math.random() * MAX_COLS)
		x = col * TILE_SIZE
		y = 0
		tile = new Tile(x,y)
		@tiles[row][col] = tile

	updatePositions: ->
		for row in [0...MAX_ROWS]
			for col in [0...MAX_COLS]

				tile = @tiles[row][col]
				if tile != null && tile.y != MAX_Y && !(tile.hasMoved)

					if @tiles[row + 1][col] == null
						@tiles[row][col] = null
						tile.y += TILE_SIZE
						tile.hasMoved = true
						@tiles[row + 1][col] = tile

		#reset hasMoved for each tile
		for row in [0...MAX_ROWS]
			for col in [0...MAX_COLS]
				@tiles[row][col].hasMoved = false if @tiles[row][col] != null


	moveLeft: ->
		for row in [0...MAX_ROWS]
			for col in [0...MAX_COLS]
				tile = @tiles[row][col]
				leftTile = @tiles[row][col - 1]

				if tile != null && tile.x != 0 && !tile.hasMoved
					if leftTile == null
						tile.x -= 50
						tile.hasMoved = true
						@tiles[row][col - 1] = tile
						@tiles[row][col] = null
					else if leftTile != null && leftTile.colorIndex == tile.colorIndex
						@tiles[row][col - 1].colorIndex++
						@tiles[row][col - 1].hasMoved = true
						@tiles[row][col] = null
					else
						continue

		@render()

	moveRight: ->
		for row in [0...MAX_ROWS]
			for col in [0...MAX_COLS]
				tile = @tiles[row][col]
				rightTile = @tiles[row][col + 1]

				if tile != null && tile.x != MAX_X  && !tile.hasMoved
					if rightTile == null
						tile.x += 50
						tile.hasMoved = true
						@tiles[row][col + 1] = tile
						@tiles[row][col] = null
					else if rightTile != null && rightTile.colorIndex == tile.colorIndex
						@tiles[row][col + 1].colorIndex++
						@tiles[row][col + 1].hasMoved = true
						@tiles[row][col] = null
					else
						continue
		@render()

	moveDown: ->
		for row in [0...MAX_ROWS]
			for col in [0...MAX_COLS]
				tile = @tiles[row][col]
				bottomTile = @tiles[row + 1][col]

				if tile != null && tile.y != MAX_Y && !tile.hasMoved
					if bottomTile == null
						tile.y += 50
						tile.hasMoved = true
						@tiles[row + 1][col] = tile
						@tiles[row][col] = null
					else if bottomTile != null && bottomTile.colorIndex == tile.colorIndex
						@tiles[row + 1][col].colorIndex++
						@tiles[row + 1][col].hasMoved = true
						@tiles[row][col] = null
					else
						continue

	spacePressed: ->
		console.log('pressed spacebar')


### 									Events and logic 								###

board = new Board

bindKeys = ->
	$(document).bind 'keydown', (e) ->
		switch e.which
			when 32 then board.spacePressed()
			when 37 then board.moveLeft()
			when 39 then board.moveRight()
			when 40 then board.moveDown()

gameLoop = ->
	#update tile shit
	board.updatePositions()
	board.spawnTile()
	board.render()

$ ->
	board.render()
	bindKeys()
	setInterval(gameLoop, 250)

