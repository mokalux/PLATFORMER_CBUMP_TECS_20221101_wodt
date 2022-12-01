Tiled_Levels = Core.class(Sprite)

function Tiled_Levels:init(xcworld, xtiny, xtiledlevel)
	-- will use the Tiled map size for the camera, parallax, ...
	self.mapwidth, self.mapheight = xtiledlevel.width * xtiledlevel.tilewidth,
		xtiledlevel.height * xtiledlevel.tileheight
--	print("map size "..self.mapwidth..", "..self.mapheight, "app size "..myappwidth..", "..myappheight, "in pixels.")
	-- gradient bg
	local gradientbg = Pixel.new(0xffffff, 1, self.mapwidth, self.mapheight*2) -- set a white color to start with
	gradientbg:setAnchorPoint(0.5, 0.5)
	gradientbg:setPosition(self.mapwidth/2, self.mapheight/2)
--	gradientbg:setColor(0x000000, 1, 0x333399, 1, 90) -- a 2 colors gradient set horizontally
	gradientbg:setColor(0xffaaff,2,0x55007f,1,0x062e3f,1,0x000000,1) -- a 4 colors gradient!
	-- camera
	self.camera = Sprite.new()
	-- game layers
	self.floor = Sprite.new()
	self.shapes_fg = Sprite.new()
	self.shapes_bg = Sprite.new()
	self.actors_fg = Sprite.new()
	self.actors_mg = Sprite.new()
	xcworld.projectileslayer = self.actors_mg
	self.actors_bg = Sprite.new()
	self.fg1_deco_frontB = Sprite.new()
	self.fg1_deco_frontA = Sprite.new()
	self.fg1_deco_base = Sprite.new()
	self.fg1_deco_backA = Sprite.new()
	self.fg1_deco_backB = Sprite.new()
	self.bg1_deco_frontB = Sprite.new()
	self.bg1_deco_frontA = Sprite.new()
	self.bg1_deco_base = Sprite.new()
	self.bg1_deco_backA = Sprite.new()
	self.bg1_deco_backB = Sprite.new()
	self.bg2_deco_frontB = Sprite.new()
	self.bg2_deco_frontA = Sprite.new()
	self.bg2_deco_base = Sprite.new()
	self.bg2_deco_backA = Sprite.new()
	self.bg2_deco_backB = Sprite.new()
	self.shadows = Sprite.new()
	self.lightings = Sprite.new()
	self.particles_fg = Sprite.new()
	self.particles_mg = Sprite.new()
	self.particles_bg = Sprite.new()
	-- order
	self.camera:addChild(gradientbg) -- sky
	self.camera:addChild(self.bg2_deco_backB)
	self.camera:addChild(self.bg2_deco_backA)
	self.camera:addChild(self.shapes_bg)
	self.camera:addChild(self.bg2_deco_base)
	self.camera:addChild(self.bg2_deco_frontA)
	self.camera:addChild(self.bg2_deco_frontB)
	self.camera:addChild(self.bg1_deco_backB)
	self.camera:addChild(self.bg1_deco_backA)
	self.camera:addChild(self.bg1_deco_base)
	self.camera:addChild(self.bg1_deco_frontA)
	self.camera:addChild(self.bg1_deco_frontB)
	self.camera:addChild(self.floor) -- only for physics (collisions)
	self.camera:addChild(self.shadows)
	self.camera:addChild(self.actors_bg)
	self.camera:addChild(self.particles_bg) -- can move up
	self.camera:addChild(self.actors_mg)
	self.camera:addChild(self.lightings)
	self.camera:addChild(self.particles_mg) -- can move up
	self.camera:addChild(self.actors_fg)
	self.camera:addChild(self.shapes_fg)
	self.camera:addChild(self.fg1_deco_backB)
	self.camera:addChild(self.fg1_deco_backA)
	self.camera:addChild(self.fg1_deco_base)
	self.camera:addChild(self.fg1_deco_frontA)
	self.camera:addChild(self.fg1_deco_frontB)
	self.camera:addChild(self.particles_fg) -- can move up
	-- final
	self:addChild(self.camera)
	-- put all the Tiled images in a table (this is a Tiled tileset not a Tiled tilemap!)
	-- Bits on the far end of the 32-bit global tile ID are used for tile flags (flip, rotate)
	local FLIPPED_HORIZONTALLY_FLAG = 0x80000000;
	local FLIPPED_VERTICALLY_FLAG   = 0x40000000;
	local FLIPPED_DIAGONALLY_FLAG   = 0x20000000;
	local tilesetimages = {}
	local tilesets = xtiledlevel.tilesets
	for i = 1, #tilesets do
		local tileset = tilesets[i]
		if tileset.name == "images" then -- your Tileset name here
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
	-- function to put objects in the worlds
	local function addToWorlds(g)
		xcworld:add(g, g.x, g.y, g.w, g.h)
		xtiny.world:addEntity(g)
		g = nil -- cleanup?
	end
--  _____        _____   _____ ______   _______ _    _ ______   _______ _____ _      ______ _____    _      ________      ________ _      
-- |  __ \ /\   |  __ \ / ____|  ____| |__   __| |  | |  ____| |__   __|_   _| |    |  ____|  __ \  | |    |  ____\ \    / /  ____| |     
-- | |__) /  \  | |__) | (___ | |__       | |  | |__| | |__       | |    | | | |    | |__  | |  | | | |    | |__   \ \  / /| |__  | |     
-- |  ___/ /\ \ |  _  / \___ \|  __|      | |  |  __  |  __|      | |    | | | |    |  __| | |  | | | |    |  __|   \ \/ / |  __| | |     
-- | |  / ____ \| | \ \ ____) | |____     | |  | |  | | |____     | |   _| |_| |____| |____| |__| | | |____| |____   \  /  | |____| |____ 
-- |_| /_/    \_\_|  \_\_____/|______|    |_|  |_|  |_|______|    |_|  |_____|______|______|_____/  |______|______|   \/   |______|______|
	local layers = xtiledlevel.layers -- each Tiled layers (be it a group or a layer)
	for i = 1, #layers do
		local group = layers[i] -- current group
		local grouplayers -- layers in group
		local layer -- individual layer (in layers or grouplayers)
		local objects -- objects in layer
		local object -- individual object
		local myshape -- object shape
		local mytable -- per shape table
		local levelsetup -- common shapes settings
		-- PHYSICS
		if group.name == "SHAPES_PHYSICS" then -- group
			grouplayers = group.layers
			for j = 1, #grouplayers do
				layer = grouplayers[j]
				if layer.name == "floor" then
					objects = layer.objects
					for j = 1, #objects do
						object = objects[j]
						myshape, mytable = nil, nil
						if object.name == "trp" then -- transparent for boundaries
							mytable = {}
						elseif object.name == "" then
							mytable = {
								texpath="tiled/levels/grounds/Metallic Assembly.jpg",
							}
						end
						levelsetup = {}
						for k, v in pairs(mytable) do levelsetup[k] = v end
						myshape = self:buildShapes(object, levelsetup)
						local g = EActor.new(self.floor, {
							x=object.x, y=object.y, shape=myshape,
						})
						g.isfloor = true -- ECS id, IMPORTANT! XXX
						addToWorlds(g)
					end
				elseif layer.name == "ladders" then
					objects = layer.objects
					for j = 1, #objects do
						object = objects[j]
						myshape, mytable = nil, nil
						if object.name == "" then
							mytable = {
								texpath="tiled/levels/grounds/brown_qussair_granite.jpg",
							}
						end
						levelsetup = {}
						for k, v in pairs(mytable) do levelsetup[k] = v end
						myshape = self:buildShapes(object, levelsetup)
						local g = EActor.new(self.floor, {
							x=object.x, y=object.y, shape=myshape,
						})
						g.isladder = true -- ECS id, IMPORTANT! XXX
						addToWorlds(g)
					end
				elseif layer.name == "ptplatforms" then -- pass through platforms
					objects = layer.objects
					for j = 1, #objects do
						object = objects[j]
						myshape, mytable = nil, nil
						if object.name == "" then
							mytable = {
								texpath="tiled/levels/grounds/cracked_gray_rock.jpg",
							}
						end
						levelsetup = {}
						for k, v in pairs(mytable) do levelsetup[k] = v end
						myshape = self:buildShapes(object, levelsetup)
						local g = EActor.new(self.floor, {
							x=object.x, y=object.y, shape=myshape,
						})
						g.isptpf = true -- ECS id, IMPORTANT! XXX
						addToWorlds(g)
					end
				elseif layer.name == "mvplatforms" then -- moving platforms
					objects = layer.objects
					for j = 1, #objects do
						object = objects[j]
						myshape, mytable = nil, nil
						local dx -- delta x destination
						local dy -- delta y destination
						local dstring = object.name -- xNNNyNNN
						if dstring:find("x") and not dstring:find("test") then -- filter out tests
							dx = tonumber(dstring:match("%d+")) -- find xNNN
							dstring = dstring:gsub("x"..dx, "") -- delete xNNN so only yNNN remains if present
						end
						if dstring:find("y") and not dstring:find("test") then -- filter out tests
							dy = tonumber(dstring:match("%d+")) -- find yNNNN
						end
						mytable = {
							texpath="tiled/levels/grounds/cracked_gray_rock.jpg",
						}
						levelsetup = {}
						for k, v in pairs(mytable) do levelsetup[k] = v end
						myshape = self:buildShapes(object, levelsetup)
						local g = EActor.new(self.floor, {
							x=object.x, y=object.y, shape=myshape,
							speed=8*0.2, jumpspeed=8*0.1,
							dx=dx, dy=dy,
							motionai=true,
						})
						g.ismvpf = true -- ECS id, IMPORTANT! XXX
						addToWorlds(g)
					end
				elseif layer.name == "springs" then
					objects = layer.objects
					for j = 1, #objects do
						object = objects[j]
						myshape, mytable = nil, nil
						if object.name == "" then
							mytable = {
								texpath="tiled/levels/grounds/cracked_gray_rock.jpg",
							}
						end
						levelsetup = {}
						for k, v in pairs(mytable) do levelsetup[k] = v end
						myshape = self:buildShapes(object, levelsetup)
						local g = EActor.new(self.floor, {
							x=object.x, y=object.y, shape=myshape,
						})
						g.isspring = true -- ECS id, IMPORTANT! XXX
						addToWorlds(g)
					end
				end
			end

		-- ACTORS
		elseif group.name == "ACTORS" then -- group
			grouplayers = group.layers
			for j = 1, #grouplayers do
				layer = grouplayers[j]
				if layer.name == "actors_fg" then
				elseif layer.name == "actors_mg" then
					objects = layer.objects
					for j = 1, #objects do
						object = objects[j]
						myshape, mytable = nil, nil
						if object.name == "player1" then
							xcworld.player1 = EPlayer1.new(self.actors_mg, object.x, object.y) -- layer
							xcworld:add(xcworld.player1, object.x, object.y, xcworld.player1.w, xcworld.player1.h)
							xtiny.world:addEntity(xcworld.player1) -- add to tiny world here!?
						elseif object.name == "nmeA" then
							local rand = math.random(0, 1) -- 0 or 1
							local randomlayer
							if rand == 0 then randomlayer = self.actors_bg
							else randomlayer = self.actors_fg
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
								speed=8*0.1, jumpspeed=8*0.1,
								dx=80,
							})
							g.isnme = true -- ECS id, IMPORTANT! XXX
							g.isactor = true -- ECS id, IMPORTANT! XXX
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
								speed=8*0.1, jumpspeed=8*0.1,
								dx=48, dy=128,
								motionai=true,
							})
							g.iscollectible = true -- ECS id, IMPORTANT! XXX
							xcworld.coins[#xcworld.coins + 1] = g -- add to coins list
							addToWorlds(g)
						end
					end
				end
			end

		-- SHAPES DECO
		elseif group.name == "SHAPES_DECO" then -- group
			grouplayers = group.layers
			for j = 1, #grouplayers do
				layer = grouplayers[j]
				if layer.name == "shapes_fg" then
					objects = layer.objects
					for j = 1, #objects do
						object = objects[j]
						myshape, mytable = nil, nil
						if object.name == "" then
							mytable = {
--								color=0xffff7f,
--								shapelinewidth=4, shapelinecolor=0xff00ff, -- you can uncomment me!
								texpath="tiled/levels/grounds/brown_qussair_granite.jpg",
								r=1, g=0.5, b=0.1, alpha=1,
							}
						end
						if mytable then
							levelsetup = {
								shapelinewidth=3, shapelinecolor=0x333333, -- you can uncomment me!
							}
							for k, v in pairs(mytable) do levelsetup[k] = v end
							myshape = self:buildShapes(object, levelsetup)
							myshape:setPosition(object.x, object.y)
							self.shapes_fg:addChild(myshape)
						end
					end
				elseif layer.name == "shapes_bg" then
					objects = layer.objects
					for j = 1, #objects do
						object = objects[j]
						myshape, mytable = nil, nil
						if object.name == "" then
							mytable = {
								color=0xffff7f,
								shapelinewidth=4, shapelinecolor=0xff00ff, -- you can uncomment me!
							}
						end
						if mytable then
							levelsetup = {
							}
							for k, v in pairs(mytable) do levelsetup[k] = v end
							myshape = self:buildShapes(object, levelsetup)
							myshape:setPosition(object.x, object.y)
							self.shapes_bg:addChild(myshape)
						end
					end
				end
			end

		-- IMAGES DECO
		elseif group.name == "IMAGES_DECO_BG" then -- group
			grouplayers = group.layers
			-- then parse the images
			local path = "tiled/levels/" -- path to images folder in Gideros
			local function parse(xobject, xlayer)
--				print(xobject.gid)
--				print(path..tilesetimages[xobject.gid].path)
				-- Read flipping flags
				local flipHor = xobject.gid & FLIPPED_HORIZONTALLY_FLAG
				local flipVer = xobject.gid & FLIPPED_VERTICALLY_FLAG
--				local flipDia = xobject.gid & FLIPPED_DIAGONALLY_FLAG
				-- Clear the flags from gid so other information is healthy
				xobject.gid = xobject.gid & ~ (
					FLIPPED_HORIZONTALLY_FLAG |
					FLIPPED_VERTICALLY_FLAG |
					FLIPPED_DIAGONALLY_FLAG
				)
				--
--				local tex = Texture.new(path..tilesetimages[xobject.gid].path, false)
				local tex = Texture.new(path..tilesetimages[xobject.gid].path, false)
				local bitmap = Bitmap.new(tex)
				bitmap:setAnchorPoint(0, 1) -- because I always forget to modify Tiled objects alignment
				local scalex, scaley = xobject.width / tex:getWidth(), xobject.height / tex:getHeight() -- image resized in Tiled?
				-- Convert flags to gideros style
				if(flipHor ~= 0) then scalex = -scalex xobject.x -= tex:getWidth() * scalex end
				if(flipVer ~= 0) then scaley = -scaley xobject.y += tex:getHeight() * scaley end
--				if(flipDia ~= 0) then print("dia") scalex, scaley = -scalex, -scaley end
				bitmap:setScale(scalex, scaley)
				bitmap:setPosition(xobject.x, xobject.y)
				bitmap:setRotation(xobject.rotation) -- image rotated in Tiled?
				--
				xlayer:addChild(bitmap)
			end
			-- images
			for j = 1, #grouplayers do
				layer = grouplayers[j]
				if layer.name == "bg1_deco_frontB" then
					self.bg1_deco_frontB:setColorTransform(29*1.5/255, 56*1.5/255, 79*1.5/255, 1)
					objects = layer.objects
					for k = 1, #objects do parse(objects[k], self.bg1_deco_frontB) end
				elseif layer.name == "bg1_deco_frontA" then
					self.bg1_deco_frontA:setColorTransform(29*1.5/255, 56*1.5/255, 79*1.5/255, 1)
					objects = layer.objects
					for k = 1, #objects do parse(objects[k], self.bg1_deco_frontA) end
				elseif layer.name == "bg1_deco_base" then
					self.bg1_deco_base:setColorTransform(29*1.5/255, 56*1.5/255, 79*1.5/255, 1)
					objects = layer.objects
					for k = 1, #objects do parse(objects[k], self.bg1_deco_base) end
				elseif layer.name == "bg1_deco_backA" then
					self.bg1_deco_backA:setColorTransform(29*1.5/255, 56*1.5/255, 79*1.5/255, 1)
					objects = layer.objects
					for k = 1, #objects do parse(objects[k], self.bg1_deco_backA) end
				elseif layer.name == "bg1_deco_backB" then
					self.bg1_deco_backB:setColorTransform(29/255, 56/255, 79/255, 1)
					objects = layer.objects
					for k = 1, #objects do parse(objects[k], self.bg1_deco_backB) end
				elseif layer.name == "bg2_deco_frontB" then
					self.bg2_deco_frontB:setColorTransform(29*1.5/255, 56*1.5/255, 79*1.5/255, 1)
					objects = layer.objects
					for k = 1, #objects do parse(objects[k], self.bg2_deco_frontB) end
				elseif layer.name == "bg2_deco_frontA" then
					self.bg2_deco_frontA:setColorTransform(29*1.5/255, 56*1.5/255, 79*1.5/255, 1)
					objects = layer.objects
					for k = 1, #objects do parse(objects[k], self.bg2_deco_frontA) end
				elseif layer.name == "bg2_deco_base" then
					self.bg2_deco_base:setColorTransform(29*1.5/255, 56*1.5/255, 79*1.5/255, 1)
					objects = layer.objects
					for k = 1, #objects do parse(objects[k], self.bg2_deco_base) end
				elseif layer.name == "bg2_deco_backA" then
					self.bg2_deco_backA:setColorTransform(29*1.5/255, 56*1.5/255, 79*1.5/255, 1)
					objects = layer.objects
					for k = 1, #objects do parse(objects[k], self.bg2_deco_backA) end
				elseif layer.name == "bg2_deco_backB" then
					self.bg2_deco_backB:setColorTransform(29/255, 56/255, 79/255, 1)
					objects = layer.objects
					for k = 1, #objects do parse(objects[k], self.bg2_deco_backB) end
				end
			end

		-- SHADOWS
		elseif group.name == "SHADOWS" then -- group
			grouplayers = group.layers
			for j = 1, #grouplayers do
				layer = grouplayers[j]
				if layer.name == "shadows" then
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
							self.shadows:addChild(myshape)
						end
					end
				end
			end

		-- LIGHTINGS
		elseif group.name == "LIGHTINGS" then -- group
			grouplayers = group.layers
			for j = 1, #grouplayers do
				layer = grouplayers[j]
				if layer.name == "lightings" then
					objects = layer.objects
					for k = 1, #objects do
						object = objects[k]
						myshape, mytable = nil, nil
						if object.name == "" then
							local g = ELighting.new(self.lightings, {
--								texpath="gfx/fx/rect1928.png", x=object.x, y=object.y,
								texpath="gfx/fx/cone_light05 - Color Map.png", x=object.x, y=object.y,
								width=object.width, height=object.height, rotation=object.rotation,
								r=255*1.5, g=255*1.5, b=255*0, alpha=0.3,
								timer=10, timerlimit=60,
							})
							xtiny.world:addEntity(g)
							g = nil -- cleanup?
						end
						if mytable then
							levelsetup = {
--								shapelinewidth=3,
							}
							for k, v in pairs(mytable) do levelsetup[k] = v end
							myshape = self:buildShapes(object, levelsetup)
							myshape:setPosition(object.x, object.y)
							self.lightings:addChild(myshape)
						end
					end
				end
			end

		-- PARTICLES
		elseif group.name == "PARTICLES" then -- group
			grouplayers = group.layers
			for j = 1, #grouplayers do
				layer = grouplayers[j]
				if layer.name == "particles_fg" then
					objects = layer.objects
					for k = 1, #objects do
						object = objects[k]
						myshape, mytable = nil, nil
						if object.name == "" then
							--xsize, xangle, xcolor, xalpha, xttl, xspeedX, xspeedY, xspeedAngular, xspeedGrowth, xtimer
							local g = EParticles.new(
								self.particles_fg, "gfx/fx/rain.png",
								object.x, object.y, object.width, object.height,
								256*0.5, -- xsize
								2, -- xangle
								0xffffff, 2, -- xcolor, alpha
								64*2, -- xttl
								0, 7, -- xspeedX, xspeedY
								0, 0, -- xspeedAngular, xspeedGrowth
								256, -- timer
								4 -- timerlimit
							)
							xtiny.world:addEntity(g)
							g = nil -- cleanup?
						elseif object.name == "fxx" then
							local g = EParticles.new(
								self.particles_fg, "gfx/fx/Bokeh.png",
								object.x, object.y, object.width, object.height,
								256*12, -- xsize
								0, -- xangle
								0xffffff, 0.2, -- xcolor, alpha
								64*8, -- xttl
								0, -0.05, -- xspeedX, xspeedY
								0, 0, -- xspeedAngular, xspeedGrowth
								3, -- timer
								20 -- timerlimit
							)
							xtiny.world:addEntity(g)
							g = nil -- cleanup?
						end
					end
				elseif layer.name == "particles_mg" then
					objects = layer.objects
					for j = 1, #objects do
						object = objects[j]
						myshape, mytable = nil, nil
						if object.name == "" then
							local g = EParticles.new(
								self.particles_mg, "gfx/fx/Dark-Bolt9.png",
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
							xtiny.world:addEntity(g)
							g = nil -- cleanup?
						end
					end
				elseif layer.name == "particles_bg" then
					objects = layer.objects
					for j = 1, #objects do
						object = objects[j]
						myshape, mytable = nil, nil
						if object.name == "" then
							local g = EParticles.new(
								self.particles_bg, "gfx/fx/Dark-Bolt1.png",
								object.x, object.y, object.width, object.height
							)
							xtiny.world:addEntity(g)
							g = nil -- cleanup?
						end
					end
				end
			end
		end
	end
end

function Tiled_Levels:buildShapes(xobject, xlevelsetup)
	local myshape = nil
	local tablebase = {}
	if xobject.shape == "ellipse" then
		tablebase = {
			x = xobject.x, y = xobject.y,
			w = xobject.width, h = xobject.height, rotation = xobject.rotation,
		}
		for k, v in pairs(xlevelsetup) do tablebase[k] = v end
		myshape = Tiled_Shape_Ellipse.new(tablebase)
	elseif xobject.shape == "polygon" then
		tablebase = {
			x = xobject.x, y = xobject.y,
			coords = xobject.polygon, rotation = xobject.rotation,
		}
		for k, v in pairs(xlevelsetup) do tablebase[k] = v end
		myshape = Tiled_Shape_Polygon.new(tablebase)
	elseif xobject.shape == "polyline" then
		tablebase = {
			x = xobject.x, y = xobject.y,
			coords = xobject.polyline, rotation = xobject.rotation,
		}
		for k, v in pairs(xlevelsetup) do tablebase[k] = v end
		myshape = Tiled_Shape_Polygon.new(tablebase)
	elseif xobject.shape == "rectangle" then
		tablebase = {
			x = xobject.x, y = xobject.y,
			w = xobject.width, h = xobject.height, rotation = xobject.rotation,
		}
		for k, v in pairs(xlevelsetup) do tablebase[k] = v end
		myshape = Tiled_Shape_Rectangle.new(tablebase)
	else
		print("*** CANNOT PROCESS THIS SHAPE! ***", xobject.shape, xobject.name)
		return
	end

	return myshape
end
