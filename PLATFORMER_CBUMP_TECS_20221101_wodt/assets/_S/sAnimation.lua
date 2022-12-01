SAnimation = Core.class()

function SAnimation:init(xtiny)
	xtiny.processingSystem(self) -- called once on init and every frames
end

function SAnimation:filter(ent) -- tiny function
	return ent.animation
end

function SAnimation:onRemove(ent) -- tiny function
	ent.animation = nil -- does something? XXX
end

local checkanim
function SAnimation:process(ent, dt) -- tiny function
--	checkanim = ent.animation.currentanim
--	if not ent.animation.anims[checkanim] then
--		checkanim = g_ANIM_DEFAULT -- default to g_ANIM_DEFAULT
--	end
	-- new luau ternary operator (no end at the end), it's 1 line and seems faster? XXX
	checkanim = if ent.animation.anims[ent.animation.currentanim] then ent.animation.currentanim else g_ANIM_DEFAULT

	ent.animation.animtimer = ent.animation.animtimer - dt
	if ent.animation.animtimer <= 0 then
		ent.animation.frame += 1
		ent.animation.animtimer = ent.animation.animspeed
		if checkanim == g_ANIM_JUMPUP_R or checkanim == g_ANIM_JUMPDOWN_R then -- new 20221129 XXX
			if ent.animation.frame > #ent.animation.anims[checkanim] then
				ent.animation.frame = #ent.animation.anims[checkanim]
			end
		else
			if ent.animation.frame > #ent.animation.anims[checkanim] then
				ent.animation.frame = 1
			end
		end
		ent.animation.bmp:setTextureRegion(ent.animation.anims[checkanim][ent.animation.frame])
	end
end
