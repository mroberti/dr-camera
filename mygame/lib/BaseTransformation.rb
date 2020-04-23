class BaseTransformation
  def <<(sprite)
    TransformedSprite.new(sprite, self)
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