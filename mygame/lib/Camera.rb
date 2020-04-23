require 'lib/TransformedSprite.rb'
require 'lib/BaseTransformation.rb'
require 'lib/Translation.rb'
class Camera
	attr_accessor :x,:y,:path,:sprites,:width,:height,:visible_sprites

	
	def initialize(x,y,background,width,height)
		self.path = background
		self.sprites = []
		self.visible_sprites = []
		self.x = x 
		self.y = y
		self.width = width
		self.height = height
	end
  
	def render args
		# For the background repeating textures 9 way directional repeat
		tempX = (-self.x%(self.width))
		tempY = (-self.y%(self.height))
		args.render_target(:myTarget).sprites << [
			[tempX, tempY - (self.height), self.width, self.height, self.path],
			[tempX, tempY + (self.height), self.width, self.height, self.path],
			[tempX, tempY, self.width, self.height, self.path],
			[tempX + (self.width), tempY, self.width, self.height, self.path],
			[tempX - (self.width), tempY, self.width, self.height, self.path],
			[tempX + (self.width), tempY + (self.height), self.width, self.height, self.path],
			[tempX - (self.width), tempY - (self.height), self.width, self.height, self.path],
			[tempX + (self.width), tempY - (self.height), self.width, self.height, self.path],
			[tempX - (self.width), tempY + (self.height), self.width, self.height, self.path]
		  ]
	
		# For my items added via addlayer function
		# we need to concatenate all layers...I'll probably
		# redo this at some point.
		# In here, you could customize the rendering needed
		# by your particular project. These sprites could also
		# be custom sprite classes, derived from sprite to which 
		# you could apply logic and additional rendering, such
		# as labels, hitpoint bars, etc. 

		# This part is for culling sprites offscreen
		# Don't know how much value it provides but there
		# it is.
		totalArray = []
		for tempArray in self.sprites do
			totalArray = totalArray + tempArray
		end
		camera_rect = [self.x, self.y, 1280, 720]
		self.visible_sprites = nil
		self.visible_sprites = totalArray.select { |sprite| sprite.intersect_rect? camera_rect }

		# If down the road we expand to having
		# multiple layers, render types etc, modularize
		# the render call, which uses render targets
		renderTarget visible_sprites,args

		# We'll call the actual render target once
		# in case we want to add additional renders for
		# primitives, labels, etc.
		args.outputs.sprites << [0, 0, 1280, 720, :myTarget]

		# args.render_target(:myTarget).sprites << self.sprites
		totalSprites = 0
		for layer in self.sprites do
			totalSprites = totalSprites + layer.length
		# args.outputs.labels << [tempShip.x, tempShip.y, tempShip.my_label,-2, 1, 255, 255, 0, 200, 1 ]
		end
	end
	
	def renderTarget theArray,args
		for tempSprite in theArray do
			transform = Translation.new([-self.x,-self.y])
			# This should take the sprites from the camera
			# layers array, and output a copy that is shifted...
			args.render_target(:myTarget).sprites << (transform << tempSprite)
		end
	end

	def addSprites sprites
		self.sprites << sprites
	end

	def moveLeft
		self.x -= 10
	end

	def moveRight
		self.x += 10
	end

	def moveUp
		self.y += 10
	end

	def moveDown
		self.y -= 10
	end
	
	def renderPrimitives args
		# To-do
	end

	def renderLabels args
		# To-do
	end

	def serialize
		instance_variables.each_with_object({}) do |ivar, collector|
			collector[ivar] = instance_variable_get(ivar)
		end
	end

	def inspect
		serialize.to_s
	end

	def to_s
		serialize.to_s
	end
end