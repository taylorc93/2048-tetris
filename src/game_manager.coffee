BOARD_WIDTH = 1200
BOARD_HEIGHT = 800
TILE_SIZE = 50

MAX_ROWS = BOARD_HEIGHT / TILE_SIZE
MAX_COLS = BOARD_WIDTH / TILE_SIZE
MAX_X = BOARD_WIDTH - TILE_SIZE
MAX_Y = BOARD_HEIGHT - TILE_SIZE
MAX_COLOR_INDEX = 6
SPAWN_THRESHOLD = 5

class window.GameManager
	constructor: ->
		@tiles = for row in [0...MAX_ROWS]
			for col in [0...MAX_COLS]
				null
		@renderer = new CanvasRenderer(document.getElementById('gameBoard'))
		@ui = new UserInputLogger
		@spawn_counter = 0;

		row = MAX_ROWS - 1
		col = Math.floor(Math.random() * MAX_COLS)
		@tiles[row][col] = new Tile(row,col)

	render: ->
		@renderer.clear()
		count = 0
		for tile in @allTiles()
				@renderer.renderTile(tile)

	spawnTile: ->
		if @spawn_counter == SPAWN_THRESHOLD
			row = 0
			col = Math.floor(Math.random() * MAX_COLS)
			tile = new Tile(row,col)

			@tiles[row][col] = tile
			@updateNeighbors(tile)

			@spawn_counter = 0
		else
			@spawn_counter++

	updatePositions: ->
		for tile in @allTiles()
			if tile.y != MAX_Y && !tile.hasMoved

				if tile.neighbors[1] == null #has no tile below it
					row = tile.row
					col = tile.col

					@tiles[row][col] = null
					tile.row++
					tile.y += TILE_SIZE
					tile.hasMoved = true
					@tiles[row + 1][col] = tile
				else
					tile.userCanMove = true

		for tile in @allTiles()
				tile.hasMoved = false
				@updateNeighbors(tile)

		@moveLeft() if @ui.leftPressed
		@moveRight() if @ui.rightPressed
		@moveDown() if @ui.downPressed

	moveLeft: ->
		for tile in @allTiles()
			if tile.x != 0 && !tile.hasMoved
				row = tile.row
				col = tile.col

				if tile.neighbors[0] == null #has no tile to the left
					tile.col--
					tile.x -= TILE_SIZE
					tile.hasMoved = true
					@tiles[row][col - 1] = tile
					@tiles[row][col] = null
				else if tile.neighbors[0].colorIndex == tile.colorIndex
					if tile.colorIndex != MAX_COLOR_INDEX	
						@tiles[row][col - 1].colorIndex++
						@tiles[row][col - 1].hasMoved = true
						@tiles[row][col] = null
				else
					continue
		@render()
		@ui.leftPressed = false

	moveRight: ->
		for tile in @allTiles()
			if tile.x != MAX_X  && !tile.hasMoved
				row = tile.row
				col = tile.col

				if tile.neighbors[2] == null
					tile.col++
					tile.x += TILE_SIZE
					tile.hasMoved = true
					@tiles[row][col + 1] = tile
					@tiles[row][col] = null
				else if tile.neighbors[2].colorIndex == tile.colorIndex
					if tile.colorIndex != MAX_COLOR_INDEX	
						@tiles[row][col + 1].colorIndex++
						@tiles[row][col + 1].hasMoved = true
						@tiles[row][col] = null
				else
					continue
		@render()
		@ui.rightPressed = false

	moveDown: ->
		for tile in @allTiles()
			if tile.y != MAX_Y && !tile.hasMoved
				row = tile.row
				col = tile.col

				if tile.neighbors[1] == null
					tile.row++
					tile.y += TILE_SIZE
					tile.hasMoved = true
					@tiles[row + 1][col] = tile
					@tiles[row][col] = null
				else if tile.neighbors[1].colorIndex == tile.colorIndex
					if tile.colorIndex != MAX_COLOR_INDEX
						@tiles[row + 1][col].colorIndex++
						@tiles[row + 1][col].hasMoved = true
						@tiles[row][col] = null
				else
					continue
		@render()
		@ui.downPressed = false

	allTiles: ->
		allTiles = []
		for row in [0...MAX_ROWS]
			for col in [0...MAX_COLS]
				allTiles.push @tiles[row][col] if @tiles[row][col] != null
		return allTiles

	updateNeighbors: (tile)->
		row = tile.row
		col = tile.col

		tile.neighbors[0] = if col > 0 then @tiles[row][col - 1] else null
		tile.neighbors[1] = if row < MAX_ROWS - 1 then @tiles[row + 1][col] else null
		tile.neighbors[2] = if col < MAX_COLS - 1 then @tiles[row][col + 1] else null			

	spacePressed: ->
		console.log('pressed spacebar')
