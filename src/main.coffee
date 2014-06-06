###
	Coffeescript file that controls game logic and canvas rendering
	Written by Connor Taylor
###
###										Constants										###
BOARD_WIDTH = 1200
BOARD_HEIGHT = 800
TILE_SIZE = 50
MAX_ROWS = BOARD_HEIGHT / TILE_SIZE
MAX_COLS = BOARD_WIDTH / TILE_SIZE

###										Classes											###
class CanvasRenderer
	constructor: (@canvas) ->
		@ctx = @canvas.getContext('2d')

	renderTile: (tile) =>
		@ctx.fillStyle = tile.color
		@ctx.fillRect(tile.x, tile.y, TILE_SIZE, TILE_SIZE)

	clear: ->
		@ctx.clearRect(0, 0, BOARD_WIDTH, BOARD_HEIGHT)


class Tile
	constructor: (@x, @y) ->
		@color = "rgb(255,165,0)"


class Board
	constructor: ->
		@tiles = []
		@renderer = new CanvasRenderer(document.getElementById('gameBoard'))

		x = Math.floor(Math.random() * MAX_COLS) * TILE_SIZE
		y = (MAX_ROWS - 1) * TILE_SIZE
		@tiles.push(new Tile(x, y))

	render: ->
		@renderer.clear()

		for tile in @tiles
			@renderer.renderTile(tile)

	moveLeft: ->
		for tile in @tiles
			tile.x -= TILE_SIZE if tile.x > 0
		@render()

	moveRight: ->
		for tile in @tiles
			tile.x += TILE_SIZE if tile.x < (BOARD_WIDTH - TILE_SIZE)
		@render()

	spacePressed: ->
		console.log('pressed spacebar')


### 							DOM rendering and events 								###

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
	console.log("next iter")
	board.render()

$ ->
	board.render()
	bindKeys()
	# setInterval(gameLoop, 250)

