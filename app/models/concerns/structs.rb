# Collection of Structs beings used throughout the application
class Structs
  # Struct to store details about details of Machine Learning models
  DetailStruct = Data.define(:title, :description)

  # Struct to store model, details, parameters for making production and its identifier (id)
  MlModelStruct = Data.define(:model, :details, :prediction_params, :id) do
    delegate :predict, to: :model

    def required_params
      prediction_params.map(&:keys).flatten
    end
  end

  class << self
    def model(...)
      MlModelStruct.new(...)
    end

    def details(...)
      DetailStruct.new(...)
    end
  end
end
