SActorsAI = Core.class()

function SActorsAI:init(xtiny, xcworld)
	xtiny.processingSystem(self) -- called on init and every frames
	self.cworld = xcworld -- cbump world
end

function SActorsAI:filter(ent) -- tiny function
	return ent.actorAI
end

function SActorsAI:onAdd(ent) -- tiny function
--	print("SActorsAI:onAdd")
end

function SActorsAI:onRemove(ent) -- tiny function
--	print("SActorsAI:onRemove")
	self.cworld:remove(ent) -- remove ent from cbump world on system removed (=dead)
end

function SActorsAI:process(ent, dt) -- tiny function
	-- TODO add change ent direction if ent collides with walls, ... XXX
	if ent.x > ent.actorAI.startpositionx + ent.actorAI.dx then
		if ent.ispprojectile or ent.iseprojectile then ent.isdirty = true return end
		ent.isleft, ent.isright = true, false
	elseif ent.x < ent.actorAI.startpositionx - ent.actorAI.dx then
		if ent.ispprojectile or ent.iseprojectile then ent.isdirty = true return end
		ent.isleft, ent.isright = false, true
	end
end
