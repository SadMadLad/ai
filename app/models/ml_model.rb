# Convenient Wrapper for querying neural networks eager loaded on Rails initialization, under <tt>config/initializers/ml_models.rb</tt>
class MlModel
  class << self
    # Query model based on symbols
    #
    # - <tt>args</tt>
    #   - <tt>id [String, Symbol]</tt>: Key value for ML_MODELS.
    #   - <tt>with_details [Boolean]
    # - returns <tt>[Nil, MlModelStruct]</tt>
    def find(id)
      ML_MODELS[id.to_sym]
    end

    # Enlist all the models
    # - returns
    def all
      ML_MODELS.values.map(&:details)
    end

    alias_method :[], :find
  end
end
