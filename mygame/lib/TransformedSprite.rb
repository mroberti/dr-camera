class TransformedSprite
  attr_sprite

  def initialize(original, transformation)
    @original = original
    @transformation = transformation
  end

  %i[
    x y w h path angle a r g b source_x source_y source_w source_h tile_x tile_y tile_h tile_w flip_horizontally flip_vertically
    angle_anchor_x angle_anchor_y
  ].each do |method|
    define_method method do
      return original.send(method) unless transformation.respond_to? method

      transformation.send(method, original)
    end
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
  protected

  attr_reader :original, :transformation
end