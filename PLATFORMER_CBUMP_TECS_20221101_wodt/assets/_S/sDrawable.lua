SDrawable = Core.class()

function SDrawable:init(xtiny, xcworld)
	xtiny.system(self) -- called only once on init (no update)
	self.cworld = xcworld -- cbump world
end

function SDrawable:filter(ent) -- tiny function
	return ent.spritelayer and ent.sprite
end

function SDrawable:onAdd(ent) -- tiny function
--	print("SActorsAI:onAdd")
	ent.spritelayer:addChild(ent.sprite)
end

function SDrawable:onRemove(ent) -- tiny function
--	print("SDrawable:onRemove")
	self.cworld:remove(ent) -- remove ent from cbump world on system removed (=dead)
	if ent.dokeep then
		ent.sprite:setAlpha(0.3)
	else
		ent.spritelayer:removeChild(ent.sprite) -- remove sprite from layer (or not)
	end
end
