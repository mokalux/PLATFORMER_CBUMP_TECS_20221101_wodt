Tiled_Shape_Ellipse = Core.class(Sprite)

function Tiled_Shape_Ellipse:init(xparams)
	-- params
	local params = xparams or {}
	params.x = xparams.x or nil
	params.y = xparams.y or nil
	params.w = xparams.w or 32
	params.h = xparams.h or 32
	params.steps = xparams.steps or 32 -- 24
	params.color = xparams.color or nil
	params.r = xparams.r or 1
	params.g = xparams.g or 1
	params.b = xparams.b or 1
	params.alpha = xparams.alpha or 1
	params.texpath = xparams.texpath or nil
	params.istexpot = xparams.istexpot or nil
	params.isshape = xparams.isshape or (xparams.isshape == nil) -- default to true
	params.shapelinewidth = xparams.shapelinewidth or nil
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
	-- image
	local img
	local sin, cos = math.sin, math.cos
	if params.isshape then
		img = Shape.new()
		if params.shapelinewidth then
			img:setLineStyle(params.shapelinewidth, params.shapelinecolor, params.shapelinealpha)
		end
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
		for i = 0, 360, 360 / params.steps  do
			img:lineTo(
				(params.w / 2) + params.w / 2 * cos(^<i),
				(params.h / 2) + params.h / 2 * sin(^<i)
			)
		end
		img:endPath()
		img:setRotation(params.rotation)
		img:setAlpha(params.alpha)
		img:setColorTransform(params.r, params.g, params.b, params.alpha)
	elseif params.isbmp then
		if not params.texpath then print("!!!YOU MUST PROVIDE A TEXTURE FOR THE BITMAP!!!") return end
		local tex = Texture.new(params.texpath, false)
		img = Bitmap.new(tex)
		img:setAnchorPoint(0.5, 0.5)
		img:setScale(params.scalex, params.scaley)
		img:setRotation(params.rotation)
		params.w, params.h = img:getWidth(), img:getHeight()
		tex = nil
	elseif params.ispixel then
		if params.texpath then
			local tex = Texture.new(params.texpath, false, {wrap = TextureBase.REPEAT})
			img = Pixel.new(tex, params.w, params.h)
			img.ispixel = true
			img:setScale(params.scalex, params.scaley)
			img:setRotation(params.rotation)
			tex = nil
		else
			img = Pixel.new(0xff0000, 1, params.w, params.h)
			img.ispixel = true
			img:setScale(params.scalex, params.scaley)
			img:setRotation(params.rotation)
		end
	else
		print("!!! UNKNOWW ELIPSE SHAPE !!!")
	end

	self:addChild(img)
end
