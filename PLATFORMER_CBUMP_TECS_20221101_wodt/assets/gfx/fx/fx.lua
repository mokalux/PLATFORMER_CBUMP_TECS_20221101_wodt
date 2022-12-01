-- *******************************************************************
-- *******************************************************************
Tiled_Flow = Core.class(Sprite)

function Tiled_Flow:init(xworld, xparams)
	-- params
	local params = xparams or {}
	params.tex = xparams.tex or nil
	params.w = xparams.w or 32
	params.h = xparams.h or 32
	params.alpha = xparams.alpha or 1
	params.scalex = xparams.scalex or 1
	params.scaley = xparams.scaley or 1
	params.rotation = xparams.rotation or 0
	params.flowspeedx = xparams.flowspeedx or nil
	params.flowspeedy = xparams.flowspeedy or nil
	params.rotationz = xparams.rotationz or nil
	params.anchorx = xparams.anchorx or 0.5
	params.anchory = xparams.anchory or 0.5
	params.anchorz = xparams.anchorz or 0.5
	-- img
	local tex = Texture.new(params.tex, false, {wrap = TextureBase.REPEAT})
	self.img = Pixel.new(tex, params.w, params.h)
	self.img:setAlpha(params.alpha)
	self.img:setScale(params.scalex, params.scaley)
	self.img:setRotation(params.rotation)
	tex = nil
	-- rotation
	self.m = Matrix.new()
	self.m:setAnchorPosition(params.anchorx, params.anchory, params.anchorz)
	-- debug
	if self.img then
		if xworld.isdebug then self.img:setAlpha(0.5) end
		self:addChild(self.img)
	end
	-- listeners?
	if params.flowspeedx or params.flowspeedy or params.rotationz then
		self.flowx, self.flowy, self.flowz = 0, 0, 0
		self.flowspeedx, self.flowspeedy, self.flowspeedz = params.flowspeedx, params.flowspeedy, params.rotationz
		self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
	end
end

function Tiled_Flow:onEnterFrame(e)
	self.flowx += self.flowspeedx or 0
	self.flowy += self.flowspeedy or 0
	self.flowz += self.flowspeedz or 0
	self.m:setRotationZ(math.cos(self.flowz))
--	self.m:setRotationZ(self.flowz)
	self.img:setTextureMatrix(self.m)
	self.img:setTexturePosition(self.flowx, self.flowy)
end

function Tiled_Flow:setPosition(xposx, xposy)
	if self.img then self.img:setPosition(xposx, xposy) end
end

-- *******************************************************************
-- *******************************************************************
Tiled_WindMill = Core.class(Sprite)

function Tiled_WindMill:init(xworld, xparams)
	-- params
	local params = xparams or {}
	params.tex = xparams.tex or nil
	params.scalex = xparams.scalex or 1
	params.scaley = xparams.scaley or 1
	params.rotationspeed = xparams.rotationspeed or 1
	-- img
	local tex = Texture.new(params.tex, false)
	self.img1 = Bitmap.new(tex)
	self.img1:setAnchorPoint(0.0328, 0.2889)
	self.img1:setScale(params.scalex, params.scaley)
	self.img2 = Bitmap.new(tex)
	self.img2:setAnchorPoint(0.0328, 0.2889)
	self.img2:setScale(params.scalex, params.scaley)
	self.img3 = Bitmap.new(tex)
	self.img3:setAnchorPoint(0.0328, 0.2889)
	self.img3:setScale(params.scalex, params.scaley)
	self.img4 = Bitmap.new(tex)
	self.img4:setAnchorPoint(0.0328, 0.2889)
	self.img4:setScale(params.scalex, params.scaley)
	tex = nil
	-- debug
	if xworld.isdebug then
		self.img1:setAlpha(0.5) self.img2:setAlpha(0.5)
		self.img3:setAlpha(0.5) self.img4:setAlpha(0.5)
	end
	self:addChild(self.img1) self:addChild(self.img2)
	self:addChild(self.img3) self:addChild(self.img4)
	-- listeners
	self.flow = 0
	self.rotationspeed = params.rotationspeed
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
end

function Tiled_WindMill:onEnterFrame()
	self.flow += self.rotationspeed
	self.img1:setRotation(self.flow + 0)
	self.img2:setRotation(self.flow + 90)
	self.img3:setRotation(self.flow + 180)
	self.img4:setRotation(self.flow + 270)
end

function Tiled_WindMill:setPosition(xposx, xposy)
	self.img1:setPosition(xposx, xposy)
	self.img2:setPosition(xposx, xposy)
	self.img3:setPosition(xposx, xposy)
	self.img4:setPosition(xposx, xposy)
end

-- *******************************************************************
-- *** FX_Gradient = Core.class(Sprite) ***
-- *******************************************************************
FX_Gradient = Core.class(Sprite)

function FX_Gradient:init(xworld, xparams)
	-- params
	local params = xparams or {}
	params.tex = xparams.tex or nil
	params.scalex = xparams.scalex or 1
	params.scaley = xparams.scaley or params.scalex
	params.rotation = xparams.rotation or 0
	params.r = xparams.r or 1
	params.g = xparams.g or 1
	params.b = xparams.b or 1
	params.alpha = xparams.alpha or 1
	-- img
	local tex = Texture.new(params.tex)
	self.img = Bitmap.new(tex)
--	self.img:setAnchorPoint(0.5, 0.5)
	self.img:setScale(params.scalex, params.scaley)
--	self.img:setAlpha(params.alpha)
	self.img:setRotation(params.rotation)
	self.img:setColorTransform(params.r/255, params.g/255, params.b/255, params.alpha)
--	self.img:setColorTransform(0, 0, 0, 1)
--	self.img:setColorTransform(0.5, 0.1, 0, 1)
	self.img:setBlendMode(Sprite.ADD)
--	self.img:setBlendMode(Sprite.ALPHA)
--	self.img:setBlendMode(Sprite.NO_ALPHA)
--	self.img:setBlendMode(Sprite.MULTIPLY)
--	self.img:setBlendMode(Sprite.SCREEN)
	tex = nil
	-- debug
	if self.img then
		if xworld.isdebug then self.img:setAlpha(0.5) end
		self:addChild(self.img)
	end
end

function FX_Gradient:setPosition(xposx, xposy)
	if self.img then self.img:setPosition(xposx, xposy) end
end

-- *******************************************************************
-- *** FX_Gradient2 = Core.class(Sprite) ***
-- *******************************************************************
FX_Gradient2 = Core.class(Sprite)

function FX_Gradient2:init(xworld, xparams)
	-- params
	local params = xparams or {}
	params.tex = xparams.tex or nil
	params.width = xparams.width or nil
	params.height = xparams.height or nil
--	params.scalex = xparams.scalex or 1
--	params.scaley = xparams.scaley or params.scalex
	params.rotation = xparams.rotation or 0
	params.r = xparams.r or 1
	params.g = xparams.g or 1
	params.b = xparams.b or 1
	params.alpha = xparams.alpha or 1
	-- img
	local tex = Texture.new(params.tex)
	self.img = Bitmap.new(tex)
--	local scalex, scaley = tex:getWidth()/params.width, tex:getHeight()/params.height
	local scalex, scaley = params.width/tex:getWidth(), params.height/tex:getHeight()
	self.img:setScale(scalex, scaley)
--	self.img:setAlpha(params.alpha)
	self.img:setRotation(params.rotation)
	self.img:setColorTransform(params.r/255, params.g/255, params.b/255, params.alpha)
--	self.img:setColorTransform(0, 0, 0, 1)
--	self.img:setColorTransform(0.5, 0.1, 0, 1)
--	self.img:setBlendMode(Sprite.ADD)
--	self.img:setBlendMode(Sprite.ALPHA)
--	self.img:setBlendMode(Sprite.NO_ALPHA)
--	self.img:setBlendMode(Sprite.MULTIPLY)
--	self.img:setBlendMode(Sprite.SCREEN)
	tex = nil
	-- debug
	if self.img then
--		if xworld.isdebug then self.img:setAlpha(0.5) end
		self:addChild(self.img)
	end
end

function FX_Gradient2:setPosition(xposx, xposy)
	if self.img then self.img:setPosition(xposx, xposy) end
end

-- *******************************************************************
-- *******************************************************************
Tiled_GradientPane = Core.class(Sprite)

function Tiled_GradientPane:init(xparams)
	local params = xparams or {}
	params.width = xparams.width or nil
	params.height = xparams.height or nil
	params.type = xparams.type or ""
	params.gradientcolor1 = xparams.gradientcolor1 or nil
	params.gradientcolor1alpha = xparams.gradientcolor1alpha or nil
	params.gradientcolor2 = xparams.gradientcolor2 or nil
	params.gradientcolor2alpha = xparams.gradientcolor2alpha or nil
	params.gradientcolor3 = xparams.gradientcolor3 or nil
	params.gradientcolor3alpha = xparams.gradientcolor3alpha or nil
	params.gradientcolor4 = xparams.gradientcolor4 or nil
	params.gradientcolor4alpha = xparams.gradientcolor4alpha or nil
	params.angle = xparams.angle or 90 -- XXX
	-- uniform or gradient color pane (pixel)
	self.img = nil
	if params.type == "1colorgradient" then
		self.pixel1 = Pixel.new(0xFFFFFF, 1, params.width, params.height)
		self.pixel1:setColor(params.gradientcolor1, params.gradientcolor1alpha,
			params.gradientcolor2, params.gradientcolor2alpha,
			params.angle)
		self:addChild(self.pixel1)
	elseif params.type == "2colorsgradient" then
		self.pixel1 = Pixel.new(0xFFFFFF, 1, params.width/2.5, params.height)
		self.pixel2 = Pixel.new(0xFFFFFF, 1, params.width/2.5, params.height)
		self.pixel2:setX(params.width - self.pixel2:getWidth())
		self.pixel1:setColor(params.gradientcolor1, params.gradientcolor1alpha,
			params.gradientcolor2, params.gradientcolor2alpha,
			params.angle)
		self.pixel2:setColor(params.gradientcolor2, params.gradientcolor2alpha,
			params.gradientcolor1, params.gradientcolor1alpha,
			params.angle)
		self:addChild(self.pixel1)
		self:addChild(self.pixel2)
	elseif params.type == "4colorsgradient" then
		self.pixel1 = Pixel.new(0xFFFFFF, 1, params.width, params.height)
		self.pixel1:setColor(params.gradientcolor1, params.gradientcolor1alpha,
			params.gradientcolor2, params.gradientcolor2alpha,
			params.gradientcolor3, params.gradientcolor3alpha,
			params.gradientcolor4, params.gradientcolor4alpha)
		self:addChild(self.pixel1)
	else -- simple pane
		self.img = Pixel.new(params.gradientcolor1, params.gradientcolor1alpha, params.width, params.height)
		self:addChild(self.img)
	end
end

-- *******************************************************************
-- ****************              PARTICLES             ***************
-- *******************************************************************
local zmathsin, zmathcos, zmathrandom = math.sin, math.cos, math.random

function effectExplode(xs, xtex, xtexscale, x, y, xradius, xspeed, xnbparticles, xttl, xcolor)
	local p = Particles.new()
	p:setPosition(x, y)
	p:setTexture(xtex)
	p:setScale(xtexscale)
	xs:addChild(p)
	local parts = {}
	for i = 1, xnbparticles or 32 do
		local a = zmathrandom() * 6.3
--		local dx, dy = zmathsin(a), zmathcos(a)
		local dx, dy = zmathcos(a), zmathsin(a)
		local sr = zmathrandom() * xradius
		local px, py = dx * sr, dy * sr
		local ss = (xspeed or 1) * (1 + zmathrandom())
		table.insert(parts,
			{
				x = px, y = py,
--				size = 10 + zmathrandom() * 20,
				size = zmathrandom(xtexscale/2, xtexscale),
				color = xcolor,
				alpha = zmathrandom(0.5, 8),
				speedX = dx * ss,
				speedY = dy * ss,
				speedAngular = zmathrandom() * 4 - 2,
				decayAlpha = 0.95 + zmathrandom() * 0.04,
				ttl = xttl,
			}
		)
	end
	p:addParticles(parts)
	Core.yield(xttl) -- linked to ttl?
	p:removeFromParent()
end

function effectTrail(s, xtex, posx, posy, xscale, xspeedgrowth, xdecaygrowth,
		xcolor, xalpha, xdecayalpha, xangle, xnbparticles, xspeed, xttl)
	local p = Particles.new()
	p:setPosition(posx, posy)
	p:setTexture(xtex)
	p:setScale(xscale)
	s:getParent():addChild(p)
	local parts = {}
	for i = 1, xnbparticles or 1 do
		local a = xangle
		local dx, dy = zmathcos(a), zmathsin(a)
		local ss = xspeed * (0.75 + zmathrandom())
		table.insert(parts,
			{
				x = dx, y = dy,
				size = zmathrandom(xscale, xscale*2), speedGrowth = xspeedgrowth, decayGrowth = xdecaygrowth,
				color = xcolor, alpha=xalpha, decayAlpha = xdecayalpha,
				speedX = dx * ss, speedY = dy * ss,
				speedAngular = zmathrandom() * 8, -- zmathrandom() * 4 - 2,
				ttl = xttl,
			}
		)
	end
	p:addParticles(parts)
	Core.yield(xttl) -- linked to ttl?
	p:removeFromParent()
end
