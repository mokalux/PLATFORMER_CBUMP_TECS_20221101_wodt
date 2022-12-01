Tiled_Shape_Polygon = Core.class(Sprite)

function Tiled_Shape_Polygon:init(xparams)
	-- params
	local params = xparams or {}
	params.x = xparams.x or nil
	params.y = xparams.y or nil
	params.coords = xparams.coords or nil
	params.color = xparams.color or nil -- hex
	params.r = xparams.r or 1
	params.g = xparams.g or 1
	params.b = xparams.b or 1
	params.alpha = xparams.alpha or 1
	params.texpath = xparams.texpath or nil
	params.istexpot = xparams.istexpot or nil
	params.isshape = xparams.isshape or (xparams.isshape == nil) -- default to true
	params.shapelinewidth = xparams.shapelinewidth or 0
	params.shapelinecolor = xparams.shapelinecolor or nil
	params.shapelinealpha = xparams.shapelinealpha or 1
	params.isbmp = xparams.isbmp or nil
	params.ispixel = xparams.ispixel or nil
	params.scalex = xparams.scalex or 1
	params.scaley = xparams.scaley or params.scalex
	params.skewx = xparams.skewx or 0 -- angle in degrees
	params.skewy = xparams.skewy or params.skewx -- angle in degrees
	params.rotation = xparams.rotation or 0
	params.data = xparams.data or nil
	params.value = xparams.value or nil
	-- first a function
	local pw, ph = 0, 0 -- the polygon dimensions
	local function sizes()
		-- calculate polygon width and height
		local minx, maxx, miny, maxy = 0, 0, 0, 0
		for k, v in pairs(params.coords) do
			--print("polygon coords", k, v.x, v.y)
			if v.x <= minx then minx = v.x end
			if v.y <= miny then miny = v.y end
			if v.x >= maxx then maxx = v.x end
			if v.y >= maxy then maxy = v.y end
		end
		pw, ph = maxx - minx, maxy - miny -- the polygon dimensions
	end
	-- image
	local img
	if params.isshape then
		img = Shape.new()
		img:setLineStyle(params.shapelinewidth, params.shapelinecolor, params.shapelinealpha) -- (width, color, alpha)
		if params.texpath then
			local tex
			if not params.istexpot then
				tex = Texture.new(params.texpath, false, {wrap = Texture.REPEAT, extend = false})
			else
				tex = Texture.new(params.texpath, false, {wrap = Texture.REPEAT})
			end
			local skewanglex = math.rad(params.skewx)
			local skewangley = math.rad(params.skewy)
			local matrix = Matrix.new(params.scalex, math.tan(skewanglex), math.tan(skewangley), params.scaley, 0, 0)
			img:setFillStyle(Shape.TEXTURE, tex, matrix)
			tex = nil
		elseif params.color then
			img:setFillStyle(Shape.SOLID, params.color, params.alpha)
		else
			img:setFillStyle(Shape.NONE)
		end
		img:beginPath()
		img:moveTo(params.coords[1].x, params.coords[1].y)
		for p = 2, #params.coords do
			img:lineTo(params.coords[p].x, params.coords[p].y)
		end
		img:closePath()
		img:endPath()
		img:setRotation(params.rotation)
		img:setAlpha(params.alpha)
		img:setColorTransform(params.r, params.g, params.b, params.alpha)
		self.w, self.h = img:getWidth(), img:getHeight()
	elseif params.isbmp then
		if not params.texpath then print("!!!YOU MUST PROVIDE A TEXTURE FOR THE BITMAP!!!") return end
		sizes() -- calculate polygon width and height
		local tex = Texture.new(params.texpath, false)
		img = Bitmap.new(tex)
		img.isbmp = true
		img.w, self.img.h = pw, ph
		img:setAnchorPoint(0.5, 0.5)
		if params.rotation > 0 then img:setAnchorPoint(0, 0.5) end
		if params.rotation < 0 then img:setAnchorPoint(0.5, 1) end
		img:setScale(params.scalex, params.scaley)
		img:setRotation(params.rotation)
		tex = nil
	elseif params.ispixel then
		if params.texpath then
			sizes() -- calculate polygon width and height
			local tex = Texture.new(params.texpath, false, {wrap = TextureBase.REPEAT})
			img = Pixel.new(tex, pw, ph)
			img.ispixel = true
			img.w, self.img.h = pw, ph
			img:setAnchorPoint(0, -0.5) -- 0.5, 0.5
			if params.rotation > 0 then img:setAnchorPoint(0, 0.5) end
			if params.rotation < 0 then img:setAnchorPoint(0.5, 1) end
			img:setScale(params.scalex, params.scaley)
			img:setRotation(params.rotation)
			img:setTexturePosition(0, 0)
			tex = nil
		else
			-- calculate polygon width and height
			local minx, maxx, miny, maxy = 0, 0, 0, 0
			for k, v in pairs(params.coords) do
				--print("polygon coords", k, v.x, v.y)
				if v.x < minx then minx = v.x end
				if v.y < miny then miny = v.y end
				if v.x > maxx then maxx = v.x end
				if v.y > maxy then maxy = v.y end
			end
			local pw, ph = maxx - minx, maxy - miny -- the polygon dimensions
			img = Pixel.new(params.color, 1, pw, ph)
			img.ispixel = true
			img.w, self.img.h = pw, ph
			img:setScale(params.scalex, params.scaley)
			img:setRotation(params.rotation)
		end
	else
		print("!!! UNKNOWW POLYGON SHAPE !!!")
	end

	self:addChild(img)
end
