class Translation < BaseTransformation
  def initialize(translation)
    @translation = translation
  end

  def x(original)
    original.x + @translation.x
  end

  def y(original)
    original.y + @translation.y
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