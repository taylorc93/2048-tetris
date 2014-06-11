COLORS = ["#FFFF00", "#FF9900", "#FF0000", "#9900FF", "#0000FF", "#00FF00", "#000000"]
BOARD_WIDTH = 1200
BOARD_HEIGHT = 800
TILE_SIZE = 50

class window.CanvasRenderer
	constructor: (@canvas) ->
		@ctx = @canvas.getContext('2d')

	renderTile: (tile) ->
		@ctx.fillStyle = COLORS[tile.colorIndex]
		@ctx.fillRect(tile.x, tile.y, TILE_SIZE, TILE_SIZE)

	clear: ->
		@ctx.clearRect(0, 0, BOARD_WIDTH, BOARD_HEIGHT)