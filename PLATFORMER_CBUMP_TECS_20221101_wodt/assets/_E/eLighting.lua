ELighting = Core.class()

function ELighting:init(xspritelayer, xparams)
	self.lighting = true
	self.spritelayer = xspritelayer
	-- params
	local params = xparams or {}
	params.texpath = xparams.texpath or nil
	params.x = xparams.x or 0
	params.y = xparams.y or 0
	params.width = xparams.width or nil
	params.height = xparams.height or nil
	params.rotation = xparams.rotation or 0
	params.r = xparams.r or 1
	params.g = xparams.g or 1
	params.b = xparams.b or 1
	params.alpha = xparams.alpha or 1
	params.timer = xparams.timer or nil
	params.timerlimit = xparams.timerlimit or nil
	-- sprite
	local tex = Texture.new(params.texpath)
	self.sprite = Bitmap.new(tex)
	local scalex, scaley = params.width/tex:getWidth(), params.height/tex:getHeight()
	self.sprite:setScale(scalex, scaley)
	self.sprite:setRotation(params.rotation)
	self.sprite:setColorTransform(params.r/255, params.g/255, params.b/255, params.alpha)
	tex = nil
	self.sprite:setPosition(params.x, params.y)
	-- fx
	self.delay = 0 -- common
	self.timer = params.timer
	self.timerlimit = params.timerlimit
end
