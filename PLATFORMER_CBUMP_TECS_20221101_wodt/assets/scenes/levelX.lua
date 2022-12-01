LevelX = Core.class(Sprite)

function LevelX:init()
	self.isfullscreen = false
	-- cbump (cworld)
	local cbump = require "cbump"
	local cworld = cbump.newWorld()
	-- tiny ecs
	self.tiny = require "libs/tiny"
	self.tiny.world = self.tiny.world()
	-- some lists
	cworld.coins = {}
	cworld.nmes = {}
	cworld.projectiles = {}
	-- create the Tiled level (camera sprite for gcam, ground, deco, players, actors, ...)
	self.tiled_level = Tiled_Levels.new(cworld, self.tiny, tiled_levels[g_currentlevel])
	-- infos
	print("coins", #cworld.coins, "nmes", #cworld.nmes, "total", #cworld.coins+#cworld.nmes)
	-- an awesome camera (gcam by rrraptor)
	self.gcam = GCam.new(self.tiled_level.camera)
	self.gcam:setAutoSize(true)
	self.gcam:setAnchor(0.5, 0.42)
	self.gcam:setZoom(1)
	local gcamleft = 0
	local gcamtop = 0
	local gcamright = self.tiled_level.mapwidth - gcamleft
	local gcambottom = self.tiled_level.mapheight
	self.gcam:setBounds(gcamleft, gcamtop, gcamright, gcambottom)
	self.gcam:setDeadSize(64*1.5, 64*5, 64*0) -- w, h, height offset
	self.gcam:setSoftSize(64*4, 64*7) -- w, h
	self.gcam:setPredictMode(true)
	self.gcam:setPredictionSmoothing(64)
	self.gcam:setFollow(cworld.player1.sprite)
	self.gcam:setFollowOffsetY(64)
--	self.gcam:setDebug(true)
	self:addChild(self.gcam)
	-- I add the systems to the tiny world here so I can access the gcam
	self.tiny.world:add(
		SDrawable.new(self.tiny),
--	 	SDebugDraw.new(self.tiny),
		SPlayer1Control.new(self.tiny),
		SActorsAI.new(self.tiny, cworld), -- basic actors AI
		SCBumpDynamicBodies.new(self.tiny, cworld, self.gcam),
		SMotionAI.new(self.tiny, cworld), -- basic moving platforms AI
		SAnimation.new(self.tiny),
		SParticles.new(self.tiny),
		SLighting.new(self.tiny)
	)
	-- listeners
	self:addEventListener("enterBegin", self.onTransitionInBegin, self)
	self:addEventListener("enterEnd", self.onTransitionInEnd, self)
	self:addEventListener("exitBegin", self.onTransitionOutBegin, self)
	self:addEventListener("exitEnd", self.onTransitionOutEnd, self)
end

-- game loop
local dt
local timer = 0
function LevelX:onEnterFrame(e)
	dt = e.deltaTime
	timer += 1
	-- camera follows player1
	self.gcam:update(dt) -- e.deltaTime 1/60
	-- tiny world
	self.tiny.world:update(dt)
end

-- event listeners
function LevelX:onTransitionInBegin() self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self) end
function LevelX:onTransitionInEnd() self:myKeysPressed() end
function LevelX:onTransitionOutBegin() self:removeEventListener(Event.ENTER_FRAME, self.onEnterFrame, self) end
function LevelX:onTransitionOutEnd() end

-- app keys handler
function LevelX:myKeysPressed()
	self:addEventListener(Event.KEY_DOWN, function(e)
		if e.keyCode == KeyCode.BACK or e.keyCode == KeyCode.ESC then -- mobiles and desktops
			scenemanager:changeScene("menu", 1, transitions[2], easings[2])
		end
		-- modifier
		local modifier = application:getKeyboardModifiers()
		local alt = (modifier & KeyCode.MODIFIER_ALT) > 0
		-- switch full screen
		if (alt and e.keyCode == KeyCode.ENTER) or e.keyCode == KeyCode.F then
			self.isfullscreen = not self.isfullscreen
			application:setFullScreen(self.isfullscreen)
		end
	end)
end
