SLighting = Core.class()

function SLighting:init(xtiny)
	xtiny.processingSystem(self) -- called once on init and every frames
end

function SLighting:filter(ent) -- tiny function
	return ent.lighting
end

function SLighting:onAdd(ent) -- tiny function
end

function SLighting:onRemove(ent) -- tiny function
end

function SLighting:process(ent, dt) -- tiny function
	if ent.timer then
		ent.delay += ent.timer * dt
		if ent.delay > ent.timerlimit then
			ent.sprite:setVisible(false)
			if ent.delay > ent.timerlimit + math.random(0, 100) then
				ent.sprite:setVisible(true)
				ent.delay = 0
			end
		end
	end
--	if ent.timer then
--		if ent.timer % (40 + math.random(5, 25)) == 0 then ent.sprite:setVisible(false)
--		elseif ent.timer % 45 == 0 then ent.sprite:setVisible(true)
--		end
--	end
end
