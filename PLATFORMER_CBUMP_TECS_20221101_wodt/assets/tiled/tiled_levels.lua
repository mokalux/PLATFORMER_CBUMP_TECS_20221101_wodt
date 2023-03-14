Tiled_Levels = Core.class(Sprite)

function Tiled_Levels:init(xcworld, xtiny, xtiledlevel)
	-- Tiled map size
	self.mapwidth, self.mapheight =
		xtiledlevel.width * xtiledlevel.tilewidth,
		xtiledlevel.height * xtiledlevel.tileheight
	print("map size "..self.mapwidth..", "..self.mapheight, "app size "..myappwidth..", "..myappheight, "in pixels.")
	-- gradient bg
	local gradientbg = Pixel.new(0xffffff, 1, self.mapwidth, self.mapheight*2) -- set a white color to start with
	gradientbg:setAnchorPoint(0.5, 0.5)
	gradientbg:setPosition(self.mapwidth/2, self.mapheight/2)
--	gradientbg:setColor(0x55aaff,2, 0x55ffff,1, 0x5500ff,1, 0x5555ff,1) -- a 4 colors gradient!
	gradientbg:setColor(0x0abeff,1, 0x0,1, 90) -- a 2 colors gradient!
	-- camera
	self.camera = Sprite.new()
	-- game layers
	self.physics_floor = Sprite.new()
	self.physics_walls = Sprite.new()
	self.sensor_ladders = Sprite.new()
	self.physics_ptplatforms = Sprite.new()
	self.physics_mvplatforms = Sprite.new()
	self.sensor_springs = Sprite.new()
	self.actors_fg = Sprite.new()
	self.actors_mg = Sprite.new()
	self.actors_bg = Sprite.new()
	self.deco_shapes_ground02 = Sprite.new()
	self.deco_shapes_ground = Sprite.new()
	self.deco_shapes_path = Sprite.new()
	self.deco_images_2000 = Sprite.new()
	self.deco_images_1000 = Sprite.new()
	self.deco_images_0900 = Sprite.new()
	self.deco_images_0850 = Sprite.new()
	self.deco_images_0800 = Sprite.new()
	self.deco_images_0700 = Sprite.new()
	self.deco_shapes_grass = Sprite.new()
	self.deco_images_0500 = Sprite.new()
	self.deco_shadows_1000 = Sprite.new()
	self.deco_lightings_1000 = Sprite.new()
	self.deco_particles_1000 = Sprite.new()
	self.deco_particles_0900 = Sprite.new()
	self.deco_particles_0800 = Sprite.new()
	-- vfx/atmosphere
	local vfxbg01 = {}
	local vfxgameplay = {}
	vfxgameplay[#vfxgameplay + 1] = self.physics_floor
	vfxbg01[#vfxbg01 + 1] = self.physics_walls
	vfxgameplay[#vfxgameplay + 1] = self.sensor_ladders
	vfxgameplay[#vfxgameplay + 1] = self.physics_ptplatforms
	vfxgameplay[#vfxgameplay + 1] = self.physics_mvplatforms
	vfxgameplay[#vfxgameplay + 1] = self.sensor_springs
	vfxgameplay[#vfxgameplay + 1] = self.actors_fg
	vfxgameplay[#vfxgameplay + 1] = self.actors_mg
	vfxgameplay[#vfxgameplay + 1] = self.actors_bg
	vfxgameplay[#vfxgameplay + 1] = self.deco_shapes_ground02
	vfxgameplay[#vfxgameplay + 1] = self.deco_shapes_ground
	vfxgameplay[#vfxgameplay + 1] = self.deco_shapes_path
	vfxbg01[#vfxbg01 + 1] = self.deco_shapes_grass
	vfxbg01[#vfxbg01 + 1] = self.deco_images_2000
	vfxbg01[#vfxbg01 + 1] = self.deco_images_1000
	vfxbg01[#vfxbg01 + 1] = self.deco_images_0900
	vfxbg01[#vfxbg01 + 1] = self.deco_images_0850
	vfxbg01[#vfxbg01 + 1] = self.deco_images_0800
	vfxbg01[#vfxbg01 + 1] = self.deco_images_0700
	vfxbg01[#vfxbg01 + 1] = self.deco_images_0500
	for i = 1, #vfxbg01 do
--		vfxbg01[i]:setColorTransform(87/255, 87/255, 87/255, 1)
--		vfxbg01[i]:setColorTransform(170/255, 0/255, 255/255, 2)
		vfxbg01[i]:setColorTransform((255-100)/255, (255-100)/255, (255-100)/255, 1)
	end
	for i = 1, #vfxgameplay do
		vfxgameplay[i]:setColorTransform((255+75)/255, (255+25)/255, (255+25)/255, 1.2)
	end
	-- parallax
	local texpath="gfx/parallax/forest01.png"
	self.parallaxB3 = self:parallax(
		{
			posoffsetx=-64*1.5, posoffsety=64*0.9,
			texpath=texpath,
			scalex=3,
			extraw=8*16, extrah=0,
			texoffsetx=0, texoffsety=0,
			hexcolortransform=0x550000, hexcolortransformalpha=1,
		}
	)
	texpath="gfx/parallax/forest01.png"
	self.parallaxB2 = self:parallax(
		{
			posoffsetx=64, posoffsety=64*1.5,
			texpath=texpath,
			scalex=0.7,
			extraw=8*32, extrah=0,
			texoffsetx=0, texoffsety=0,
			hexcolortransform=0x2f8cad, hexcolortransformalpha=1.3,
		}
	)
	texpath="gfx/parallax/forest01.png"
	self.parallaxB1 = self:parallax(
		{
			posoffsetx=64, posoffsety=64*1.55,
			texpath=texpath,
			scalex=0.37,
			extraw=8*32, extrah=0,
			texoffsetx=0, texoffsety=0,
			hexcolortransform=0x46CCFF, hexcolortransformalpha=1.7,
		}
	)
	texpath = nil
	-- order
	self.camera:addChild(gradientbg) -- sky
--	if self.parallaxB3 then self.camera:addChild(self.parallaxB3) end
	if self.parallaxB2 then self.camera:addChild(self.parallaxB2) end
	if self.parallaxB1 then self.camera:addChild(self.parallaxB1) end
	self.camera:addChild(self.deco_lightings_1000)
	self.camera:addChild(self.deco_images_0500)
	self.camera:addChild(self.deco_shapes_grass)
	self.camera:addChild(self.deco_images_0700)
	self.camera:addChild(self.deco_images_0800)
	self.camera:addChild(self.deco_images_0850)
	self.camera:addChild(self.deco_images_0900)
	self.camera:addChild(self.deco_images_1000)
	self.camera:addChild(self.deco_shapes_path)
--	self.camera:addChild(self.deco_images_2000)
	self.camera:addChild(self.physics_ptplatforms)
	self.camera:addChild(self.physics_mvplatforms)
	self.camera:addChild(self.deco_images_2000)
	self.camera:addChild(self.actors_bg)
	self.camera:addChild(self.actors_mg)
	self.camera:addChild(self.actors_fg)
	self.camera:addChild(self.deco_shapes_ground)
	self.camera:addChild(self.deco_shapes_ground02)
	self.camera:addChild(self.deco_shadows_1000)
	self.camera:addChild(self.deco_particles_0800)
	self.camera:addChild(self.deco_particles_0900)
	self.camera:addChild(self.deco_particles_1000)
	if self.parallaxF1 then self.camera:addChild(self.parallaxF1) end
	-- final
	xcworld.projectileslayer = self.deco_shapes_ground02
	self.camera:addChild(self.physics_floor) -- only for physics (collisions)
	self.camera:addChild(self.physics_walls) -- only for physics (collisions)
	self.camera:addChild(self.sensor_ladders) -- only for physics (sensor)
	self.camera:addChild(self.sensor_springs) -- only for physics (collisions)
	self:addChild(self.camera) -- final
-- _______ _____ _      ______ _____  
--|__   __|_   _| |    |  ____|  __ \ 
--   | |    | | | |    | |__  | |  | |
--   | |    | | | |    |  __| | |  | |
--   | |   _| |_| |____| |____| |__| |
--   |_|  |_____|______|______|_____/ 
-- _____ __  __          _____ ______  _____   _______ ____  
--|_   _|  \/  |   /\   / ____|  ____|/ ____| |__   __/ __ \ 
--  | | | \  / |  /  \ | |  __| |__  | (___      | | | |  | |
--  | | | |\/| | / /\ \| | |_ |  __|  \___ \     | | | |  | |
-- _| |_| |  | |/ ____ \ |__| | |____ ____) |    | | | |__| |
--|_____|_|  |_/_/    \_\_____|______|_____/     |_|  \____/ 
-- _______       ____  _      ______ 
--|__   __|/\   |  _ \| |    |  ____|
--   | |  /  \  | |_) | |    | |__   
--   | | / /\ \ |  _ <| |    |  __|  
--   | |/ ____ \| |_) | |____| |____ 
--   |_/_/    \_\____/|______|______|
	-- Bits on the far end of the 32-bit global tile ID are used for tile flags (flip, rotate)
	local FLIPPED_HORIZONTALLY_FLAG = 0x80000000;
	local FLIPPED_VERTICALLY_FLAG   = 0x40000000;
	local FLIPPED_DIAGONALLY_FLAG   = 0x20000000;
	local tilesetimages = {} -- the table holding all Tiled images info (path, width, height)
	local tilesets = xtiledlevel.tilesets
	for i = 1, #tilesets do
		local tileset = tilesets[i]
		if tileset.name == "images" then -- your Tileset name here XXX
			local tiles = tileset.tiles
			for j = 1, #tiles do
--				tilesetimages[tiles[j].id+tileset.firstgid] = {
				tilesetimages[tiles[j].id+1] = { -- +1 because gid is id + 1
					path=tiles[j].image,
					width=tiles[j].width,
					height=tiles[j].height,
				}
			end
		end
	end
--  _____        _____   _____ ______   _______ _    _ ______   _______ _____ _      ______ _____    _      ________      ________ _      
-- |  __ \ /\   |  __ \ / ____|  ____| |__   __| |  | |  ____| |__   __|_   _| |    |  ____|  __ \  | |    |  ____\ \    / /  ____| |     
-- | |__) /  \  | |__) | (___ | |__       | |  | |__| | |__       | |    | | | |    | |__  | |  | | | |    | |__   \ \  / /| |__  | |     
-- |  ___/ /\ \ |  _  / \___ \|  __|      | |  |  __  |  __|      | |    | | | |    |  __| | |  | | | |    |  __|   \ \/ / |  __| | |     
-- | |  / ____ \| | \ \ ____) | |____     | |  | |  | | |____     | |   _| |_| |____| |____| |__| | | |____| |____   \  /  | |____| |____ 
-- |_| /_/    \_\_|  \_\_____/|______|    |_|  |_|  |_|______|    |_|  |_____|______|______|_____/  |______|______|   \/   |______|______|
	-- function to add objects to tECS and CBUMP worlds
	local function addToWorlds(xg)
		xcworld:add(xg, xg.x, xg.y, xg.w, xg.h)
		xtiny.worlds:addEntity(xg)
		xg = nil -- cleanup?
	end
	local layers = xtiledlevel.layers -- each Tiled layers (be it a group or a layer)
	for i = 1, #layers do
		local group = layers[i] -- current group (folder)
		local grouplayers -- layers in group
		local layer -- individual layer (in layers or grouplayers)
		local objects -- objects in layer
		local object -- individual object
		local myshape -- object shape
		local mytable -- per shape table
		local levelsetup -- common shapes settings
		-- gameplay
		local floorjumpbuffer = 36 -- 36, 32, for jump key, magik XXX
-- _____  _    ___     _______ _____ _____  _____          
--|  __ \| |  | \ \   / / ____|_   _/ ____|/ ____|   ___   
--| |__) | |__| |\ \_/ / (___   | || |    | (___    ( _ )  
--|  ___/|  __  | \   / \___ \  | || |     \___ \   / _ \/\
--| |    | |  | |  | |  ____) |_| || |____ ____) | | (_>  <
--|_|    |_|  |_|  |_| |_____/|_____\_____|_____/   \___/\/
--  _____ ______ _   _  _____  ____  _____   _____ 
-- / ____|  ____| \ | |/ ____|/ __ \|  __ \ / ____|
--| (___ | |__  |  \| | (___ | |  | | |__) | (___  
-- \___ \|  __| | . ` |\___ \| |  | |  _  / \___ \ 
-- ____) | |____| |\  |____) | |__| | | \ \ ____) |
--|_____/|______|_| \_|_____/ \____/|_|  \_\_____/ 
		if group.name == "PHYSICS_AND_SENSORS" then -- Tiled group (folder)
			grouplayers = group.layers
			for j = 1, #grouplayers do
				layer = grouplayers[j]
				if layer.name == "physics_floor" then -- transparent, only for collisions
					objects = layer.objects
					for j = 1, #objects do
						object = objects[j]
						myshape, mytable = nil, nil
						if object.name == "" then
							mytable = {}
						end
						levelsetup = {}
						if mytable then
							for k, v in pairs(mytable) do levelsetup[k] = v end
						end
						myshape = self:buildShapes(object, levelsetup)
						local g = EActor.new(self.physics_floor, {
							x=object.x, y=object.y, shape=myshape,
						})
						g.isfloor = true -- tECS id, IMPORTANT! XXX
						addToWorlds(g)
						-- ADDITIONAL EXTRA FLOOR FOR JUMP BUFFERING (sensor) XXX
						local extramargin = 0
						local extraobject = {}
						extraobject.shape = "rectangle"
						extraobject.x = object.x + extramargin
						extraobject.y = object.y - floorjumpbuffer
						extraobject.width = object.width - extramargin*2
						extraobject.height = floorjumpbuffer
						extraobject.rotation = 0
						mytable = {}
						myshape = self:buildShapes(extraobject, mytable)
						local g1 = EActor.new(self.physics_floor, {
							x=extraobject.x, y=extraobject.y, shape=myshape,
						})
						g1.isextrafloor = true -- tECS id, IMPORTANT! XXX
						addToWorlds(g1)
					end
				elseif layer.name == "physics_walls" then
					-- TODO
				elseif layer.name == "sensor_ladders" then
					objects = layer.objects
					for j = 1, #objects do
						object = objects[j]
						myshape, mytable = nil, nil
						mytable = {}
						myshape = self:buildShapes(object, mytable)
						local g = EActor.new(self.sensor_ladders, {
							x=object.x, y=object.y, shape=myshape,
						})
						g.isladder = true -- tECS id, IMPORTANT! XXX
						addToWorlds(g)
					end
				elseif layer.name == "physics_blocks" then
					objects = layer.objects
					for j = 1, #objects do
						object = objects[j]
						myshape, mytable = nil, nil
						mytable = {}
						myshape = self:buildShapes(object, mytable)
						local g = EActor.new(self.sensor_ladders, {
							x=object.x, y=object.y, shape=myshape,
						})
						g.isblock = true -- tECS id, IMPORTANT! XXX
						addToWorlds(g)
					end
				elseif layer.name == "physics_ptplatforms" then -- pass through platforms
					objects = layer.objects
					for j = 1, #objects do
						object = objects[j]
						myshape, mytable = nil, nil
						if object.name == "" then
							mytable = {
								texpath="tiled/levels/grounds/brown_qussair_granite.jpg",
								r=111/255, g=57/255, b=47/255,
							}
						end
						levelsetup = {}
						for k, v in pairs(mytable) do levelsetup[k] = v end
						myshape = self:buildShapes(object, levelsetup)
						local g = EActor.new(self.physics_ptplatforms, {
							x=object.x, y=object.y, shape=myshape,
						})
						g.isptpf = true -- tECS id, IMPORTANT! XXX
						addToWorlds(g)
						-- ADDITIONAL EXTRA FLOOR FOR JUMP BUFFERING (sensor) XXX
						local extramargin = 0
						local extraobject = {}
						extraobject.shape = "rectangle"
						extraobject.x = object.x + extramargin
						extraobject.y = object.y - floorjumpbuffer
						extraobject.width = object.width - extramargin*2
						extraobject.height = floorjumpbuffer
						extraobject.rotation = 0
						mytable = {}
						myshape = self:buildShapes(extraobject, mytable)
						local g1 = EActor.new(self.physics_ptplatforms, {
							x=extraobject.x, y=extraobject.y, shape=myshape, -- -96
						})
						g1.isextrafloor = true -- tECS id, IMPORTANT! XXX
						addToWorlds(g1)
					end
				elseif layer.name == "physics_mvplatforms" then -- moving platforms
					objects = layer.objects
					local xspeed
					local xjumpspeed
					for j = 1, #objects do
						object = objects[j]
						myshape, mytable = nil, nil
						local dx -- delta x destination
						local dy -- delta y destination
						local dstring = object.name -- xNNNyNNN
						if dstring:find("x") and not dstring:find("test") then -- filter out tests
							dx = tonumber(dstring:match("%d+")) -- find xNNN
							xspeed = 8*0.2
							dstring = dstring:gsub("x"..dx, "") -- delete xNNN so only yNNN remains if present
						end
						if dstring:find("y") and not dstring:find("test") then -- filter out tests
							dy = tonumber(dstring:match("%d+")) -- find yNNNN
							xjumpspeed = 8*0.2
						else
							dy = 1
							xjumpspeed = 0.01
						end
						mytable = {
							texpath="tiled/levels/grounds/cracked_gray_rock.jpg",
							r=111/255, g=57/255, b=47/255,
						}
						levelsetup = {}
						for k, v in pairs(mytable) do levelsetup[k] = v end
						myshape = self:buildShapes(object, levelsetup)
						local g = EActor.new(self.physics_mvplatforms, {
							x=object.x, y=object.y, shape=myshape,
							speed=xspeed, jumpspeed=xjumpspeed,
							dx=dx, dy=dy,
							motionai=true,
						})
						g.ismvpf = true -- tECS id, IMPORTANT! XXX
						addToWorlds(g)
						-- ADDITIONAL EXTRA FLOOR FOR JUMP BUFFERING (sensor) XXX
						local extraobject = {}
						extraobject.shape = "rectangle"
						extraobject.x = object.x
						extraobject.y = object.y - floorjumpbuffer - 8 -- linked, magik XXX
						extraobject.width = object.width
						extraobject.height = floorjumpbuffer + 8 -- linked, magik XXX
						extraobject.rotation = 0
						mytable = {}
						myshape = self:buildShapes(extraobject, mytable)
						local g1 = EActor.new(self.physics_mvplatforms, {
							x=extraobject.x, y=extraobject.y, shape=myshape,
							speed=xspeed, jumpspeed=xjumpspeed,
							dx=dx, dy=dy+floorjumpbuffer-8, -- linked
							motionai=true,
						})
						g1.isextramvpffloor = true -- tECS id, IMPORTANT! XXX
						addToWorlds(g1)
					end
				elseif layer.name == "sensor_springs" then
					objects = layer.objects
					for j = 1, #objects do
						object = objects[j]
						myshape, mytable = nil, nil
						if object.name == "" then
							mytable = {}
						end
						levelsetup = {}
						for k, v in pairs(mytable) do levelsetup[k] = v end
						myshape = self:buildShapes(object, levelsetup)
						local g = EActor.new(self.sensor_springs, {
							x=object.x, y=object.y, shape=myshape,
						})
						g.isspring = true -- tECS id, IMPORTANT! XXX
						addToWorlds(g)
					end
				end
			end
--          _____ _______ ____  _____   _____ 
--    /\   / ____|__   __/ __ \|  __ \ / ____|
--   /  \ | |       | | | |  | | |__) | (___  
--  / /\ \| |       | | | |  | |  _  / \___ \ 
-- / ____ \ |____   | | | |__| | | \ \ ____) |
--/_/    \_\_____|  |_|  \____/|_|  \_\_____/ 
		elseif group.name == "ACTORS" then -- Tiled group (folder)
			grouplayers = group.layers
			for j = 1, #grouplayers do
				layer = grouplayers[j]
				if layer.name == "actors_fg" then
					-- TODO
				elseif layer.name == "actors_mg" then
					objects = layer.objects
					for j = 1, #objects do
						object = objects[j]
						myshape, mytable = nil, nil
						if object.name == "player1" then
							xcworld.player1 = EPlayer1.new(self.actors_mg, object.x, object.y) -- layer
							xcworld:add(xcworld.player1, object.x, object.y, xcworld.player1.w, xcworld.player1.h)
							xtiny.worlds:addEntity(xcworld.player1) -- add to tiny worlds here!?
						elseif object.name == "nmeA" then
							local rand = math.random(0, 1) -- 0 or 1
							local rdokeep
							local randomlayer
							if rand == 0 then
								randomlayer = self.actors_bg
								rdokeep = true
							else
								randomlayer = self.actors_fg
								rdokeep = false
							end
							local g = EActor.new(randomlayer, {
								x=object.x, y=object.y,
								animtexpath="gfx/nmes/bug1_0001.png", cols=9, rows=9, animspeed=1/15,
								animations={
									{g_ANIM_DEFAULT, 1, 12},
									{g_ANIM_IDLE_R, 24, 70},
									{g_ANIM_WALK_R, 71, 81},
									{g_ANIM_RUN_R, 71, 81},
									{g_ANIM_ATTACK1_R, 1, 12},
									{g_ANIM_ATTACK2_R, 13, 24},
								},
								bodyw=108/2, bodyh=58,
								offsetx=108/4, offsety=58/2,
								defaultmass=0.1,
								speed=8*0.1, jumpspeed=0.1*8*16,
								dx=80,
								dokeep=rdokeep,
								health=math.random(5, 10)
							})
							g.isnme = true -- tECS id, IMPORTANT! XXX
							g.isactor = true -- tECS id, IMPORTANT! XXX
							g.shoottimer = 10
							xcworld.nmes[#xcworld.nmes + 1] = g -- add to nmes list
							addToWorlds(g)
						end
					end
				elseif layer.name == "actors_bg" then
					objects = layer.objects
					for j = 1, #objects do
						object = objects[j]
						myshape, mytable = nil, nil
						if object.name == "coinA" then
							local g = EActor.new(self.actors_bg, {
								x=object.x, y=object.y,
								animtexpath="gfx/collectibles/coin_20_x01.png", cols=6, rows=1,
								offsetx=9, offsety=10,
								animspeed=1/10, 
								animations={
									{g_ANIM_DEFAULT, 1, 6,}, -- animname, startat, endat
								},
								speed=8*0.05, jumpspeed=8*0.05,
								dx=32, dy=32,
								motionai=true,
							})
							g.iscollectible = true -- tECS id, IMPORTANT! XXX
							xcworld.coins[#xcworld.coins + 1] = g -- add to coins list
							addToWorlds(g)
						end
					end
				end
			end
-- _____  ______ _____ ____  
--|  __ \|  ____/ ____/ __ \ 
--| |  | | |__ | |   | |  | |
--| |  | |  __|| |   | |  | |
--| |__| | |___| |___| |__| |
--|_____/|______\_____\____/ 
		-- shapes, images, lights, shadows, ...
		elseif group.name == "DECO" then -- Tiled group (folder)
			-- local function
			local path = "tiled/levels/" -- path to images folder in Gideros
			local function parseImage(xobject, xlayer)
				-- vfx/atmosphere
--				xlayer:setColorTransform(85/255, 85/255, 127/255, 1)
				-- read flipping flags
				local flipHor = xobject.gid & FLIPPED_HORIZONTALLY_FLAG
				local flipVer = xobject.gid & FLIPPED_VERTICALLY_FLAG
				local flipDia = xobject.gid & FLIPPED_DIAGONALLY_FLAG
				-- clear the flags from gid so other information is healthy
				xobject.gid = xobject.gid & ~ (
					FLIPPED_HORIZONTALLY_FLAG | FLIPPED_VERTICALLY_FLAG | FLIPPED_DIAGONALLY_FLAG
				)
				local tex = Texture.new(path..tilesetimages[xobject.gid].path, false)
				local bitmap = Bitmap.new(tex)
				bitmap:setAnchorPoint(0, 1) -- because I always forget to modify Tiled objects alignment
				local scalex, scaley = xobject.width / tex:getWidth(), xobject.height / tex:getHeight() -- supports Tiled image scaling
				-- convert flags to gideros style
				if(flipHor ~= 0) then scalex = -scalex xobject.x -= tex:getWidth() * scalex end
				if(flipVer ~= 0) then scaley = -scaley xobject.y += tex:getHeight() * scaley end
				if(flipDia ~= 0) then -- not tested!
					scalex, scaley = -scalex, -scaley
					xobject.x -= tex:getWidth() * scalex
					xobject.y += tex:getHeight() * scaley
				end
				bitmap:setScale(scalex, scaley)
				bitmap:setPosition(xobject.x, xobject.y)
				bitmap:setRotation(xobject.rotation) -- image rotated in Tiled?
				-- addChild
				xlayer:addChild(bitmap)
				-- table
				xcworld.hidegfx[#xcworld.hidegfx + 1] = {bmp=bitmap, x=xobject.x, y=xobject.y}
--				print(#xcworld.hidegfx + 1)
			end
			-- process Tiled deco layers
			grouplayers = group.layers
			for j = 1, #grouplayers do
				layer = grouplayers[j]
				if layer.name == "deco_shapes_ground" then
					objects = layer.objects
					for j = 1, #objects do
						object = objects[j]
						myshape, mytable = nil, nil
						if object.name == "" then
							mytable = {
								texpath="tiled/levels/grounds/brown_qussair_granite.jpg",
								r=0.7, g=0.4, b=0.1, alpha=1,
							}
						end
						if mytable then
							levelsetup = {}
							for k, v in pairs(mytable) do levelsetup[k] = v end
							myshape = self:buildShapes(object, levelsetup)
							myshape:setPosition(object.x, object.y)
							self.deco_shapes_ground:addChild(myshape)
						end
					end
				elseif layer.name == "deco_shapes_ground02" then
					objects = layer.objects
					for j = 1, #objects do
						object = objects[j]
						myshape, mytable = nil, nil
						if object.name == "" then
							mytable = {
								color=0x3c220e,
							}
						end
						if mytable then
							levelsetup = {}
							for k, v in pairs(mytable) do levelsetup[k] = v end
							myshape = self:buildShapes(object, levelsetup)
							myshape:setPosition(object.x, object.y)
							self.deco_shapes_ground:addChild(myshape)
						end
					end
				elseif layer.name == "deco_shapes_path" then
					objects = layer.objects
					for j = 1, #objects do
						object = objects[j]
						myshape, mytable = nil, nil
						if object.name == "" then
							mytable = {
								texpath="tiled/levels/grounds/cracked_gray_rock.jpg",
								scalex=2,
								r=0.8, g=0.5, b=0.2, alpha=1,
								skewy=40, -- viva gideros!
							}
						end
						if mytable then
							levelsetup = {
							}
							for k, v in pairs(mytable) do levelsetup[k] = v end
							myshape = self:buildShapes(object, levelsetup)
							myshape:setPosition(object.x, object.y)
							self.deco_shapes_path:addChild(myshape)
						end
					end
				elseif layer.name == "deco_shapes_grass" then
					objects = layer.objects
					for j = 1, #objects do
						object = objects[j]
						myshape, mytable = nil, nil
						if object.name == "" then
							mytable = {
								color=0x7bb215,
							}
						end
						if mytable then
							levelsetup = {}
							for k, v in pairs(mytable) do levelsetup[k] = v end
							myshape = self:buildShapes(object, levelsetup)
							myshape:setPosition(object.x, object.y)
							self.deco_shapes_grass:addChild(myshape)
						end
					end
				elseif layer.name == "deco_images_2000" then
					objects = layer.objects
					for k = 1, #objects do parseImage(objects[k], self.deco_images_2000) end
				elseif layer.name == "deco_images_1000" then
					objects = layer.objects
					for k = 1, #objects do parseImage(objects[k], self.deco_images_1000) end
				elseif layer.name == "deco_images_0900" then
					objects = layer.objects
					for k = 1, #objects do parseImage(objects[k], self.deco_images_0900) end
				elseif layer.name == "deco_images_0850" then
					objects = layer.objects
					for k = 1, #objects do parseImage(objects[k], self.deco_images_0850) end
				elseif layer.name == "deco_images_0800" then
					objects = layer.objects
					for k = 1, #objects do parseImage(objects[k], self.deco_images_0800) end
				elseif layer.name == "deco_images_0700" then
					objects = layer.objects
					for k = 1, #objects do parseImage(objects[k], self.deco_images_0700) end
				elseif layer.name == "deco_images_0500" then
					objects = layer.objects
					for k = 1, #objects do parseImage(objects[k], self.deco_images_0500) end
				-- the following is TODO
				elseif layer.name == "deco_shadows_1000" then
					objects = layer.objects
					for k = 1, #objects do
						object = objects[k]
						myshape, mytable = nil, nil
						if object.name == "" then
							mytable = {
								color=0x000022,
							}
						end
						if mytable then
							levelsetup = {
								shapelinewidth=3,
							}
							for k, v in pairs(mytable) do levelsetup[k] = v end
							myshape = self:buildShapes(object, levelsetup)
							myshape:setPosition(object.x, object.y)
							self.deco_shadows_1000:addChild(myshape)
						end
					end
				elseif layer.name == "deco_lightings_1000" then -- fx, OK
					objects = layer.objects
					for k = 1, #objects do
						object = objects[k]
						myshape, mytable = nil, nil
						if object.name == "" then
							local g = ELighting.new(self.deco_lightings_1000, {
--								texpath="gfx/fx/rect1928.png", x=object.x, y=object.y,
--								texpath="gfx/fx/cone_light05 - Color Map.png", x=object.x, y=object.y,
								texpath="gfx/fx/point_light02 - Color Map.png", x=object.x, y=object.y,
								width=object.width, height=object.height, rotation=object.rotation,
								rotation=5,
--								r=255*1.5, g=255*1.5, b=255*0, alpha=0.3,
								r=255*1.5, g=255*1.5, b=255*1.5, alpha=1,
--								timer=10, timerlimit=60,
								timer=3, timerlimit=3,
							})
							xtiny.worlds:addEntity(g)
							g = nil -- cleanup?
						end
						if mytable then
							levelsetup = {
--								shapelinewidth=3,
							}
							for k, v in pairs(mytable) do levelsetup[k] = v end
							myshape = self:buildShapes(object, levelsetup)
							myshape:setPosition(object.x, object.y)
							self.deco_lightings_1000:addChild(myshape)
						end
					end
				elseif layer.name == "deco_particles_1000" then -- fx, OK
					objects = layer.objects
					for k = 1, #objects do
						object = objects[k]
						myshape, mytable = nil, nil
						if object.name == "" then
							--function EParticles:init(xspritelayer, xparticletexpath, x, y, xrangewidth, xrangeheight,
							--		xsize, xangle, xcolor, xalpha, xttl, xspeedX, xspeedY, xspeedAngular, xspeedGrowth,
							--		xtimer, xtimerlimit
							--	)
							local g = EParticles.new(
								self.deco_particles_1000, "gfx/fx/rain.png", object.x, object.y, object.width, object.height,
								256*0.5, -- xsize
								2, -- xangle
								0xffffff, 2, -- xcolor, alpha
								64*2, -- xttl
								0, 7, -- xspeedX, xspeedY
								0, 0, -- xspeedAngular, xspeedGrowth
								256, -- timer
								4 -- timerlimit
							)
							xtiny.worlds:addEntity(g)
							g = nil -- cleanup?
						end
					end
				elseif layer.name == "deco_particles_0900" then -- fx, OK
					objects = layer.objects
					for j = 1, #objects do
						object = objects[j]
						myshape, mytable = nil, nil
						if object.name == "" then
							local g = EParticles.new(
								self.deco_particles_0900, "gfx/fx/Dark-Bolt9.png",
								object.x, object.y, object.width, object.height,
								256*1, -- xsize
								0, -- xangle
								0xffffff, 0.04, -- xcolor, alpha
								64*4, -- xttl
								0, -0.05, -- xspeedX, xspeedY
								0.1, 0.1, -- xspeedAngular, xspeedGrowth
								60, -- timer
								3 -- timerlimit
							)
							xtiny.worlds:addEntity(g)
							g = nil -- cleanup?
						end
					end
				elseif layer.name == "deco_particles_0800" then -- fx, OK
					objects = layer.objects
					for j = 1, #objects do
						object = objects[j]
						myshape, mytable = nil, nil
						if object.name == "" then
							local g = EParticles.new(
								self.deco_particles_0800, "gfx/fx/Dark-Bolt1.png",
								object.x, object.y, object.width, object.height
							)
							xtiny.worlds:addEntity(g)
							g = nil -- cleanup?
						end
					end
				end
			end
		end
	end
end

-- colors functions
function Tiled_Levels:hex2rgb(hex) -- can be local
	local rgbtable = {}
	rgbtable.r, rgbtable.g, rgbtable.b =
		(hex >> 16 & 0xff) / 255, (hex >> 8 & 0xff) / 255, (hex & 0xff) / 255
	return rgbtable
end

function Tiled_Levels:rgb2hex(xr, xg, xb) -- unused
	local rgb = (xr * 0x10000) + (xg * 0x100) + xb
	return string.format("0x%06x", rgb)
end

function Tiled_Levels:parallax(xparams)
	local params = xparams or {}
	params.posoffsetx = xparams.posoffsetx or 0
	params.posoffsety = xparams.posoffsety or 0
	params.texpath = xparams.texpath or nil
	params.scalex = xparams.scalex or 1
	params.scaley = xparams.scaley or params.scalex
	params.extraw = xparams.extraw or 0
	params.extrah = xparams.extrah or 0
	params.texoffsetx = xparams.texoffsetx or 0
	params.texoffsety = xparams.texoffsety or 0
	params.hexcolortransform = xparams.hexcolortransform or 0xffffff
	params.hexcolortransformalpha = xparams.hexcolortransformalpha or 1
	params.parallaxalpha = xparams.parallaxalpha or 1
	local texture = Texture.new(
		params.texpath, false,
		{wrap=Texture.REPEAT, extend=false,}
	)
	local parallax = Pixel.new(texture)
	parallax:setTextureScale(params.scalex, params.scaley)
	parallax:setDimensions(
		self.mapwidth + 2 * params.extraw,
		texture:getHeight() * params.scaley
	)
	parallax:setTexturePosition(params.texoffsetx, params.texoffsety)
	local rgb = self:hex2rgb(params.hexcolortransform)
	parallax:setColorTransform(rgb.r, rgb.g, rgb.b, params.hexcolortransformalpha) -- can alpha fx here!
	parallax:setAlpha(params.parallaxalpha)
	parallax:setPosition(
		myappleft - params.extraw - params.posoffsetx,
		self.mapheight - parallax:getHeight() - params.posoffsety
	)
	return parallax
end

function Tiled_Levels:buildShapes(xobject, xlevelsetup)
	local myshape = nil
	local tablebase = {}
	if xobject.shape == "ellipse" then
		tablebase = {
			x=xobject.x, y=xobject.y,
			w=xobject.width, h=xobject.height, rotation=xobject.rotation,
		}
		for k, v in pairs(xlevelsetup) do tablebase[k] = v end
		myshape = Tiled_Shape_Ellipse.new(tablebase)
	elseif xobject.shape == "polygon" then
		tablebase = {
			x=xobject.x, y=xobject.y,
			coords=xobject.polygon, rotation=xobject.rotation,
		}
		for k, v in pairs(xlevelsetup) do tablebase[k] = v end
		myshape = Tiled_Shape_Polygon.new(tablebase)
	elseif xobject.shape == "polyline" then
		tablebase = {
			x=xobject.x, y=xobject.y,
			coords=xobject.polyline, rotation=xobject.rotation,
		}
		for k, v in pairs(xlevelsetup) do tablebase[k] = v end
		myshape = Tiled_Shape_Polygon.new(tablebase)
	elseif xobject.shape == "rectangle" then
		tablebase = {
			x=xobject.x, y=xobject.y,
			w=xobject.width, h=xobject.height, rotation=xobject.rotation,
		}
		for k, v in pairs(xlevelsetup) do tablebase[k] = v end
		myshape = Tiled_Shape_Rectangle.new(tablebase)
	else
		print("*** CANNOT PROCESS THIS SHAPE! ***", xobject.shape, xobject.name)
		return
	end

	return myshape
end
