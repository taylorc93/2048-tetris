###
	Coffeescript file that controls game logic and canvas rendering
	Written by Connor Taylor
###

###										Constants										###

board = new GameManager

bindKeys = ->
	$(document).bind 'keydown', (e) ->
		switch e.which
			when 32 then board.ui.spacePressed = true
			when 37 then board.ui.leftPressed = true
			when 39 then board.ui.rightPressed = true
			when 40 then board.ui.downPressed = true

gameLoop = ->
	#update tile shit
	board.updatePositions()
	board.spawnTile()
	board.render()

$ ->
	board.render()
	bindKeys()
	setInterval(gameLoop, 60)

