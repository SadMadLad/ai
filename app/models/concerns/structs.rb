# Collection of Structs beings used throughout the application
module Structs
  DetailStruct = Data.define(:title, :description)

  MlModelStruct = Data.define(:model, :details, :prediction_params, :id) do
    delegate :predict, to: :model

    def required_params
      prediction_params.map(&:keys).flatten
    end
  end
end
