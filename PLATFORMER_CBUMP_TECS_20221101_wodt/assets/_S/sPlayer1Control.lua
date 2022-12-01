SPlayer1Control = Core.class()

function SPlayer1Control:init(xtiny)
	xtiny.system(self) -- called only once on init (no update)
end

function SPlayer1Control:filter(ent) -- tiny function
	return ent.isplayer1
end

function SPlayer1Control:onAdd(ent) -- tiny function
	self.player1 = ent
	stage:addEventListener(Event.KEY_DOWN, self.onKeyDown, self) -- is the stage best?
	stage:addEventListener(Event.KEY_UP, self.onKeyUp, self) -- is the stage best?
end

-- system functions
function SPlayer1Control:onKeyDown(e)
	-- move
	if e.keyCode == KeyCode.LEFT then self.player1.isleft = true end
	if e.keyCode == KeyCode.RIGHT then self.player1.isright = true end
	if e.keyCode == KeyCode.UP then self.player1.isup = true end
	if e.keyCode == KeyCode.DOWN then self.player1.isdown = true end
	-- actions
	if e.keyCode == KeyCode.W then self.player1.isaction1 = true end
end

function SPlayer1Control:onKeyUp(e)
	-- move
	if e.keyCode == KeyCode.LEFT then self.player1.isleft = false end
	if e.keyCode == KeyCode.RIGHT then self.player1.isright = false end
	if e.keyCode == KeyCode.UP then
		self.player1.isup = false
		self.player1.wasup = false -- prevent constant jumps
	end
	if e.keyCode == KeyCode.DOWN then
		self.player1.isdown = false
		self.player1.wasdown = false -- prevent constant going down ptpf
	end
	-- actions
	if e.keyCode == KeyCode.W then self.player1.isaction1 = false end
end
