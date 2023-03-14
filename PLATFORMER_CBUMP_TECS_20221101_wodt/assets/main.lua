-- game
tiled_levels = {}
--tiled_levels[1] = loadfile("tiled/levels/garden.lua")()
--tiled_levels[1] = loadfile("tiled/levels/tln.lua")()
tiled_levels[1] = loadfile("tiled/levels/rpgpp_lt_models_vgood.lua")()
g_currlevel = 1
g_gravity = 6 -- 9.8

-- anims, faster accessed via int than string
g_ANIM_DEFAULT = 1
g_ANIM_IDLE_L = 2
g_ANIM_IDLE_R = 3
g_ANIM_WALK_L = 4
g_ANIM_WALK_R = 5
g_ANIM_RUN_L = 6
g_ANIM_RUN_R = 7
g_ANIM_JUMPUP_L = 8
g_ANIM_JUMPUP_R = 9
g_ANIM_JUMPDOWN_L = 10
g_ANIM_JUMPDOWN_R = 11
g_ANIM_LADDERIDLE = 12
g_ANIM_LADDERUP = 13
g_ANIM_LADDERDOWN = 14
g_ANIM_WIN_L = 15
g_ANIM_WIN_R = 16
g_ANIM_ATTACK1_L = 17
g_ANIM_ATTACK1_R = 18
g_ANIM_ATTACK2_L = 19
g_ANIM_ATTACK2_R = 20
g_ANIM_LOSE1_L = 21
g_ANIM_LOSE1_R = 22
g_ANIM_LOSE2_L = 23
g_ANIM_LOSE2_R = 24
g_ANIM_STOMP_L = 25
g_ANIM_STOMP_R = 26

-- scene manager
scenemanager = SceneManager.new(
	{
		["menu"] = Menu,
		["levelX"] = LevelX,
	}
)
stage:addChild(scenemanager)
scenemanager:changeScene("levelX")

-- transitions & easings
transitions = {
	SceneManager.moveFromRight, -- 1
	SceneManager.moveFromLeft, -- 2
	SceneManager.moveFromBottom, -- 3
	SceneManager.moveFromTop, -- 4
	SceneManager.moveFromRightWithFade, -- 5
	SceneManager.moveFromLeftWithFade, -- 6
	SceneManager.moveFromBottomWithFade, -- 7
	SceneManager.moveFromTopWithFade, -- 8
	SceneManager.overFromRight, -- 9
	SceneManager.overFromLeft, -- 10
	SceneManager.overFromBottom, -- 11
	SceneManager.overFromTop, -- 12
	SceneManager.overFromRightWithFade, -- 13
	SceneManager.overFromLeftWithFade, -- 14
	SceneManager.overFromBottomWithFade, -- 15
	SceneManager.overFromTopWithFade, -- 16
	SceneManager.fade, -- 17
	SceneManager.crossFade, -- 18
	SceneManager.flip, -- 19
	SceneManager.flipWithFade, -- 20
	SceneManager.flipWithShade, -- 21
}
easings = {
	easing.inBack, -- 1
	easing.outBack, -- 2
	easing.inOutBack, -- 3
	easing.inBounce, -- 4
	easing.outBounce, -- 5
	easing.inOutBounce, -- 6
	easing.inCircular, -- 7
	easing.outCircular, -- 8
	easing.inOutCircular, -- 9
	easing.inCubic, -- 10
	easing.outCubic, -- 11
	easing.inOutCubic, -- 12
	easing.inElastic, -- 13
	easing.outElastic, -- 14
	easing.inOutElastic, -- 15
	easing.inExponential, -- 16
	easing.outExponential, -- 17
	easing.inOutExponential, -- 18
	easing.linear, -- 19
	easing.inQuadratic, -- 20
	easing.outQuadratic, -- 21
	easing.inOutQuadratic, -- 22
	easing.inQuartic, -- 23
	easing.outQuartic, -- 24
	easing.inOutQuartic, -- 25
	easing.inQuintic, -- 26
	easing.outQuintic, -- 27
	easing.inOutQuintic, -- 28
	easing.inSine, -- 29
	easing.outSine, -- 30
	easing.inOutSine, -- 31
}
