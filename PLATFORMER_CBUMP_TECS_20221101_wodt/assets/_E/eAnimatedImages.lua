EAnimatedImages = Core.class()

function EAnimatedImages:init(xspritelayer, xtexpath, x, y)
	self.spritelayer = xspritelayer
	self.isdeco = true
	local texpath = xtexpath
	self.x = x
	self.y = y
	self.sx = math.random(20, 30) / 10 -- random size on x
	self.sy = self.sx
	self.flip = 1
	-- COMPONENTS
	-- ANIMATION
	--function CAnimation:init(xspritesheetpath, xcols, xrows, xanimspeed, bodyw, bodyh, xoffx, xoffy, sx, sy)
	self.animation = CAnimation.new(texpath, 11, 1, 1/20, 0, 0, 0, 0, self.sx, self.sy) -- less sensitive ;-) -- magik XX
	self.sprite = self.animation.sprite
	self.animation.sprite = nil -- free some memory?
	-- create animations
	--function CAnimation:createAnim(xanimname, xstart, xfinish)
	self.animation:createAnim(g_ANIM_DEFAULT, 1, 11) -- magik XXX
	self.animation.myanimsimgs = nil -- free some memory?
	-- test
	self.animation.currframe = math.random(#self.animation.anims[g_ANIM_DEFAULT])
--	print(self.animation.currframe) -- trying to start at different frames but doesn't work :-(
	self.sprite:setScale(self.sx, self.sy)
	self.sprite:setPosition(self.x, self.y)
end
