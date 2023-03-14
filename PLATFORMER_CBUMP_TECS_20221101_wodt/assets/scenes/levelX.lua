LevelX = Core.class(Sprite)

function LevelX:init()
	self.isfullscreen = false
	-- cbump (cworld)
	local cbump = require "cbump"
	self.cworld = cbump.newWorld()
	-- tiny ecs
	self.tiny = require "libs/tiny"
	self.tiny.worlds = self.tiny.world()
	-- some lists
	self.cworld.coins = {}
	self.cworld.nmes = {}
	self.cworld.projectiles = {}
	self.cworld.hidegfx = {}
	-- create the Tiled level (camera sprite for gcam, ground, deco, players, actors, ...)
	self.tiled_level = Tiled_Levels.new(self.cworld, self.tiny, tiled_levels[g_currlevel])
	self.cworld.losescreen = Bitmap.new(Texture.new("gfx/fx/cone_light03 - Color Map.png"))
	self.cworld.losescreen:setAnchorPoint(0.5, 0.5)
--	self.cworld.losescreen:setPosition(myappwidth/2, myappheight/2)
	self.tiled_level.deco_particles_1000:addChild(self.cworld.losescreen)
	self.cworld.losescreen:setVisible(false)
	-- infos
	print("coins", #self.cworld.coins, "nmes", #self.cworld.nmes, "total", #self.cworld.coins+#self.cworld.nmes)
	-- an awesome camera (gcam by rrraptor)
	self.gcam = GCam.new(self.tiled_level.camera)
	self.gcam:setAutoSize(true)
	self.gcam:setAnchor(0.5, 0.6) -- (0.5, 0.42)
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
	self.gcam:setFollow(self.cworld.player1.sprite)
	self.gcam:setFollowOffsetY(64)
--	self.gcam:setDebug(true)
	self:addChild(self.gcam)
	-- I add the systems to the tiny worlds here so I can access the gcam
	self.tiny.worlds:add(
		SDrawable.new(self.tiny, self.cworld),
--	 	SDebugDraw.new(self.tiny),
		SPlayer1Control.new(self.tiny),
		SCBumpDynamicBodies.new(self.tiny, self.cworld, self.gcam),
		SMotionAI.new(self.tiny, self.cworld), -- basic moving platforms AI
		SAnimation.new(self.tiny),
		SParticles.new(self.tiny),
		SLighting.new(self.tiny)
	)
	-- mobile controller
	local mobile = MobileXv1.new(self.cworld.player1)
	self:addChild(mobile)
	-- listeners
	self:addEventListener("enterBegin", self.onTransitionInBegin, self)
	self:addEventListener("enterEnd", self.onTransitionInEnd, self)
	self:addEventListener("exitBegin", self.onTransitionOutBegin, self)
	self:addEventListener("exitEnd", self.onTransitionOutEnd, self)
end

-- game loop
local dt
local timer = 0
local camposx, camposy
local xmyappwidth = myappwidth * 1.5
function LevelX:onEnterFrame(e)
	dt = e.deltaTime
	timer += 1
	camposx, camposy = self.gcam.x, self.gcam.y
	-- camera follows player1
	self.gcam:update(dt) -- e.deltaTime 1/60
	-- tiny worlds
	self.tiny.worlds:update(dt)
	-- parallax
	if self.tiled_level.parallaxB3 then
		if g_currentlevel == 3 then
			self.tiled_level.parallaxB3:setTexturePosition(camposx*0.4, 0)
		else
			self.tiled_level.parallaxB3:setTexturePosition(camposx*0.19, 0)
		end
	end
	if self.tiled_level.parallaxB2 then
		if g_currentlevel == 3 then
			self.tiled_level.parallaxB2:setTexturePosition(timer*7, 0)
		else
			self.tiled_level.parallaxB2:setTexturePosition(camposx*0.2, 0)
		end
	end
	if self.tiled_level.parallaxB1 then
		if g_currentlevel == 3 then
			self.tiled_level.parallaxB1:setTexturePosition(-timer*10, 0)
		else
			self.tiled_level.parallaxB1:setTexturePosition(-camposx*0.25, 0)
		end
	end
	if self.tiled_level.parallaxF1 then self.tiled_level.parallaxF1:setTexturePosition(-camposx*0.5, 0) end
	-- perfs
	for i = 1, #self.cworld.hidegfx do
		if math.distance(camposx, camposy, self.cworld.hidegfx[i].x, self.cworld.hidegfx[i].y) > xmyappwidth then
			self.cworld.hidegfx[i].bmp:setVisible(false)
		else
			self.cworld.hidegfx[i].bmp:setVisible(true)
		end
	end
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
