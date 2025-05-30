class MlModel
  class << self
    def find(id, with_details: true)
      ML_MODELS[id.to_sym]
    end

    def all
      ML_MODELS.values.pluck(:details)
    end

    alias_method :[], :find
  end
end
