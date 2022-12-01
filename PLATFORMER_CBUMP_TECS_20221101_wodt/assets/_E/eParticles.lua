EParticles = Core.class()

function EParticles:init(xspritelayer, xparticletexpath, x, y, xrangewidth, xrangeheight,
		xsize, xangle, xcolor, xalpha, xttl, xspeedX, xspeedY, xspeedAngular, xspeedGrowth,
		xtimer, xtimerlimit
	)
	self.particles = true
	self.isdeco = true
	self.spritelayer = xspritelayer
	local particletexpath = Texture.new(xparticletexpath)
	self.sprite = Particles.new()
	self.sprite:setTexture(particletexpath)
	-- position
	self.x = x
	self.y = y
	self.sprite:setPosition(self.x, self.y)
	-- need to externalise
	self.rangewidth = xrangewidth
	self.rangeheight = xrangeheight
	self.size = xsize
	self.angle = xangle
	self.color = xcolor
	self.alpha = xalpha
	self.ttl = xttl
	self.speedX = xspeedX
	self.speedY = xspeedY
	self.speedAngular = xspeedAngular
	self.speedGrowth = xspeedGrowth
	self.delay = 0 -- common
	self.timer = xtimer
	self.timerlimit = xtimerlimit
end
