Menu = Core.class(Sprite)

function Menu:init()
	-- bg
	application:setBackgroundColor(0x12aaAA)
	local bgimg = Bitmap.new(Texture.new("gfx/ui/rpgpp_lt_models_vgood.png"))
	-- buttons
	self.selector = 1
	self.sound = Sound.new("audio/sfx_sounds_button1.wav") -- shared amongst ui buttons
	self.channelS = self.sound:play(0, nil, true) -- shared amongst ui buttons
	local pixelcolor = 0xaa5533 -- shared amongst ui buttons
	local pixelalphaup = 0.3 -- shared amongst ui buttons
	local pixelalphadown = 0.6 -- shared amongst ui buttons
	local textcolorup = 0x0909Bb -- shared amongst ui buttons
	local textcolordown = 0x45d1ff -- shared amongst ui buttons
	local mybtn = ButtonMonster.new({
		scalexup=1, scalexdown=1.2,
		pixelcolorup=pixelcolor, pixelalphaup=pixelalphaup, pixelalphadown=pixelalphadown,
		text="test level1", ttf=font01, textcolorup=textcolorup, textcolordown=textcolordown,
		isautoscale=false, pixelpaddingx=64*4.5, pixelpaddingy=64*1.5,
		channel=self.channelS, sound=self.sound, volume=self.volume,
	}, 1)
	local mybtn02 = ButtonMonster.new({
		scalexup=1, scalexdown=1.2,
		pixelcolorup=pixelcolor, pixelalphaup=pixelalphaup, pixelalphadown=pixelalphadown,
		text="test levelX", ttf=font01, textcolorup=textcolorup, textcolordown=textcolordown,
		isautoscale=false, pixelpaddingx=64*4.5, pixelpaddingy=64*1.5,
		channel=self.channelS, sound=self.sound, volume=self.volume,
	}, 2)
	mybtn02:setDisabled(true)
	-- positions
	mybtn:setPosition(1.5*myappwidth/2, 3.5*myappheight/10)
	mybtn02:setPosition(1.5*myappwidth/2, 5*myappheight/10)
	-- order
	self:addChild(bgimg)
	self:addChild(mybtn)
	self:addChild(mybtn02)
	-- btns table
	self.btns = {}
	self.btns[#self.btns + 1] = mybtn
	self.btns[#self.btns + 1] = mybtn02
	-- btns listeners
	for k, v in ipairs(self.btns) do
		v:addEventListener("clicked", function() self:goto() end) -- click event
		v.btns = self.btns -- ui navigation update
	end
	-- let's go!
	self:updateUiVfx()
	-- listeners
	self:addEventListener("enterBegin", self.onTransitionInBegin, self)
	self:addEventListener("enterEnd", self.onTransitionInEnd, self)
	self:addEventListener("exitBegin", self.onTransitionOutBegin, self)
	self:addEventListener("exitEnd", self.onTransitionOutEnd, self)
end

-- game loop
function Menu:onEnterFrame(e)
end

-- UI fx
function Menu:updateUiVfx()
	for k, v in ipairs(self.btns) do v.iskeyboard = true v:updateVisualState() end
end
function Menu:updateUiSfx()
	for k, v in ipairs(self.btns) do
		if k == self.selector then self.channelS = self.sound:play() self.channelS:setVolume(self.volume) end
	end
end

-- scenes ui keyboard navigation
function Menu:goto()
	for k, v in ipairs(self.btns) do
		if k == self.selector then
			if v.isdisabled then print("btn disabled!", k)
			elseif k == 1 then scenemanager:changeScene("levelX", 1, transitions[1], easings[2])
			elseif k == 2 then
			elseif k == 3 then
			elseif k == 4 then
			else print("nothing here!", k)
			end
		end
	end
end

-- event listeners
function Menu:onTransitionInBegin()
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
end
function Menu:onTransitionInEnd()
	self:myKeysPressed()
end
function Menu:onTransitionOutBegin()
	self:removeEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
end
function Menu:onTransitionOutEnd()
end

-- keys handler
function Menu:myKeysPressed()
	self:addEventListener(Event.KEY_DOWN, function(e)
		if e.keyCode == KeyCode.BACK or e.keyCode == KeyCode.ESC then -- mobiles and desktops
			application:exit()
		end
	end)
end
