Tiled_Shape_Rectangle = Core.class(Sprite)

function Tiled_Shape_Rectangle:init(xparams)
	-- params
	local params = xparams or {}
	params.x = xparams.x or nil
	params.y = xparams.y or nil
	params.w = xparams.w or nil
	params.h = xparams.h or nil
	params.rotation = xparams.rotation or nil
	params.color = xparams.color or nil
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
	params.data = xparams.data or nil
	params.value = xparams.value or nil
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
			img:setFillStyle(Shape.SOLID, params.color)
		else
			img:setFillStyle(Shape.NONE)
		end
		img:beginPath()
		img:moveTo(0, 0)
		img:lineTo(params.w, 0)
		img:lineTo(params.w, params.h)
		img:lineTo(0, params.h)
		img:lineTo(0, 0)
		img:endPath()
		img:setRotation(params.rotation)
		img:setAlpha(params.alpha)
		img:setColorTransform(params.r, params.g, params.b, params.alpha)
	elseif params.isbmp then
		if not params.texpath then print("!!!YOU MUST PROVIDE A TEXTURE FOR THE BITMAP!!!") return end
		local tex = Texture.new(params.texpath, false)
		img = Bitmap.new(tex)
		img.isbmp = true
		img.w, self.img.h = params.w, params.h
		if params.rotation < 0 then img:setAnchorPoint(0, 0.5) end
--		if params.rotation > 0 then img:setAnchorPoint(0, 0.5) end
		img:setScale(params.scalex, params.scaley)
		img:setRotation(params.rotation)
		img:setAlpha(params.alpha)
		tex = nil
	elseif params.ispixel then
		if params.texpath then
			local tex = Texture.new(params.texpath, false, {wrap = TextureBase.REPEAT})
			img = Pixel.new(tex, params.w, params.h)
			img.ispixel = true
			img.w, self.img.h = params.w, params.h
			img:setScale(params.scalex, params.scaley)
			if params.rotation < 0 then img:setAnchorPoint(0, -0.5) end
			if params.rotation > 0 then img:setAnchorPoint(0, 0.5) end
			img:setRotation(params.rotation)
			img:setAlpha(params.alpha)
			tex = nil
		else
			img = Pixel.new(params.color, 1, params.w, params.h)
			img.ispixel = true
			img.w, self.img.h = params.w, params.h
			img:setScale(params.scalex, params.scaley)
			img:setRotation(params.rotation)
			img:setAlpha(params.alpha)
		end
	else
		print("!!! UNKNOWW RECTANGLE SHAPE !!!")
	end

	self:addChild(img) -- of Sprite class
end
