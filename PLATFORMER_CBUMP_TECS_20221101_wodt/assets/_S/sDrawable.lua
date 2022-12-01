SDrawable = Core.class()

function SDrawable:init(xtiny)
	xtiny.system(self) -- called only once on init (no update)
end

function SDrawable:filter(ent) -- tiny function
	return ent.spritelayer and ent.sprite
end

function SDrawable:onAdd(ent) -- tiny function
	ent.spritelayer:addChild(ent.sprite)
end

function SDrawable:onRemove(ent) -- tiny function
	ent.spritelayer:removeChild(ent.sprite) -- remove sprite from layer (or not)
end
