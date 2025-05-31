Rails.application.config.after_initialize do
  ML_MODELS = {}

  MlModelStruct = Data.define(:model, :details, :prediction_params, :id) do
    delegate :predict, to: :model

    def required_params
      prediction_params.map(&:keys).flatten
    end
  end
  DetailStruct = Data.define(:title, :description)

  mnist_model_path = Rails.root.join("lib", "models", "mnist.pth").to_s

  ML_MODELS[:mnist] = Structs::MlModelStruct.new(
    Torch::Networks::MnistModel.load_dict(mnist_model_path),
    Structs::DetailStruct.new("MNIST", "Cool MNIST Model"),
    [ { input_image: :image } ],
    :mnist
  ) if File.exist?(mnist_model_path)

  ML_MODELS.freeze
end
