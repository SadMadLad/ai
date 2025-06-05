# Rails.application.config.after_initialize do
#   ML_MODELS = {}

#   mnist_model_path = Rails.root.join("lib", "models", "mnist.pth").to_s
#   wine_quality_model_path = Rails.root.join("lib", "models", "random_forest_regressor.dat").to_s

#   ML_MODELS[:mnist] = Structs.model(
#     Torch::Models::MnistModel.load_dict(mnist_model_path),
#     Structs.details("MNIST", "Cool MNIST Model"),
#     { input_image: { type: :image, label: "Input Image" } },
#     :mnist
#   ) if File.exist?(mnist_model_path)

#   ML_MODELS[:wine_quality] = Structs.model(
#     Rumale::Models::WineQualityModel.load_saved_model,
#     Structs.details("Wine Quality", "Check Wine Quality"),
#     {
#       fixed_acidity: {
#         type: :number,
#         label: "Fixed Acidity"
#       },
#       volatile_acidity: {
#         type: :number,
#         label: "Volatile Acidity"
#       },
#       citric_acid: {
#         type: :number,
#         label: "Citric Acid"
#       },
#       residual_sugar: {
#         type: :number,
#         label: "Residual Sugar"
#       },
#       chlorides: {
#         type: :number,
#         label: "Chlorides"
#       },
#       free_sulfur_dioxide: {
#         type: :number,
#         label: "Free Sulfur Dioxide"
#       },
#       total_sulfur_dioxide: {
#         type: :number,
#         label: "Total Sulfur Dioxide"
#       },
#       density: {
#         type: :number,
#         label: "Density"
#       },
#       ph: {
#         type: :number,
#         label: "pH"
#       },
#       sulphates: {
#         type: :number,
#         label: "Sulphates"
#       },
#       alcohol: {
#         type: :number,
#         label: "Alcohol"
#       }
#     },
#     :wine_quality
#   )

#   ML_MODELS.freeze
# end
