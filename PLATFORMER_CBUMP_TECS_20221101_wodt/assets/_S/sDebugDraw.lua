SDebugDraw = Core.class()

function SDebugDraw:init(xtiny)
	xtiny.processingSystem(self) -- called once on init and every frames
end

function SDebugDraw:filter(ent) -- tiny function
	return ent.body or ent.isextrafloor or ent.isextramvpffloor or ent.isladder or ent.isspring or ent.isblock
end

function SDebugDraw:onAdd(ent) -- tiny function
	local pixel = Pixel.new(0x0, 1, ent.w, ent.h)
	if ent.body then
		pixel:setColor(0xffaa7f, 0.5)
	elseif ent.isextrafloor then
		pixel:setColor(0x5500ff, 0.5)
	elseif ent.isextramvpffloor then
		pixel:setColor(0xaaaa7f, 0.8)
	elseif ent.isladder then
		pixel:setColor(0xffaaff, 0.5)
	elseif ent.isblock then
		pixel:setColor(0xaa5500, 0.7)
	elseif ent.isspring then
		pixel:setColor(0x55aaff, 0.5)
	end
	ent.spritelayer:addChild(pixel)
	ent.bodyDraw = pixel
end

function SDebugDraw:onRemove(ent) -- tiny function
	ent.spritelayer:removeChild(ent.bodyDraw)
	ent = nil -- XXX ???
end

function SDebugDraw:process(ent, dt) -- tiny function
	ent.bodyDraw:setPosition(ent.x, ent.y)
end
