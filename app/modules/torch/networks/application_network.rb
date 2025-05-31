module Torch
  module Networks
    # Base Network for Training
    class ApplicationNetwork < Torch::NN::Module
      # Constant later used to declare convenient methods for Neural Network layers
      # e.g., :conv2d is Torch::NN::Conv2d
      LAYERS = %i[conv2d linear].freeze

      class << self
        # Loads weights from a file into the neural network
        def load_dict(parameters_file)
          model = new
          model.load_state_dict Torch.load(parameters_file)

          model
        end

        # Needs to be overridden for each child class. Preprocesses the input to prepare for prediction
        def input_preprocess(input)
          raise NotImplementedError
        end
      end

      protected
        # Convenient function to call Torch::NN::Functional methods
        def function(name, ...)
          Torch::NN::F.public_send(name, ...)
        end

        # Used to declare convenient methods from the LAYERS constant
        def layer(name, ...)
          "Torch::NN::#{name.to_s.camelize}".constantize.new(...)
        end

        LAYERS.each do |layer_name|
          define_method(layer_name) do |*args, **kwargs, &block|
            layer(layer_name, *args, **kwargs, &block)
          end
        end
    end
  end
end
