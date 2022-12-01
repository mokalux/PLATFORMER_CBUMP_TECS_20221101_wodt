SParticles = Core.class()

function SParticles:init(xtiny)
	xtiny.processingSystem(self) -- called once on init and every frames
end

function SParticles:filter(ent) -- tiny function
	return ent.particles
end

function SParticles:onAdd(ent) -- tiny function
end

function SParticles:onRemove(ent) -- tiny function
	ent.particles = nil
end

function SParticles:process(ent, dt) -- tiny function
	ent.delay += ent.timer * dt
	if ent.delay > ent.timerlimit then -- here we can balance performance vs visual fx
		ent.sprite:addParticles({
			{
				x=math.random(ent.rangewidth), y=math.random(ent.rangeheight),
				size=ent.size, angle=ent.angle,
				color=ent.color, alpha=ent.alpha,
				ttl=ent.ttl,
				speedX=ent.speedX, speedY=ent.speedY, speedAngular=ent.speedAngular,
				speedGrowth=ent.speedGrowth,
			},
		})
		ent.delay = 0
	end
end
