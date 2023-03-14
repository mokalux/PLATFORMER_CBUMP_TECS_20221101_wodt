-- beautify
--http://patorjk.com/software/taag/#p=display&f=Big&t=GIDEROS

-- plugins
require "scenemanager"
require "easing"

-- GLOBALS
-- fonts (see also composite font)
font00 = TTFont.new("fonts/Cabin-Regular-TTF.ttf", (12*10)//1)
font01 = TTFont.new("fonts/Cabin-Regular-TTF.ttf", (12*5.2)//1)
font02 = TTFont.new("fonts/Cabin-Regular-TTF.ttf", (12*4)//1)
font10 = TTFont.new("fonts/Cabin-Regular-TTF.ttf", (12*3)//1)

-- app
myappleft, myapptop, myappright, myappbot = application:getLogicalBounds()
myappwidth, myappheight = myappright - myappleft, myappbot - myapptop

if (application:getDeviceInfo() == "Windows" or application:getDeviceInfo() == "Win32") then
	if not application:isPlayerMode() then
		local sw, sh = application:get("screenSize") -- the user's screen size!
		application:set("windowTitle", "GIDEROS PLATFORMER CBUMP TECS")
		application:set("windowPosition", (sw - myappwidth) * 0.5, (sh - myappheight) * 0.4)
--		application:set("cursorPosition", 0, 0)
	end
end
