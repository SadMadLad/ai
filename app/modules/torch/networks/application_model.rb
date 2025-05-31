# Module of <tt>torch-rb</tt> gem.
module Torch
  # Module containing all the neural networks developed using <tt>torch-rb</tt>
  module Networks
    # Base Network for Training
    class ApplicationModel < Torch::NN::Module
      # Constant later used to declare convenient methods for Neural Network layers
      # e.g., <tt>:conv2d</tt> is <tt>Torch::NN::Conv2d</tt>
      LAYERS = %i[conv2d linear].freeze

      class << self
        # Loads weights from a file into the neural network
        #
        # - <tt>args</tt>
        #   - <tt>parameters_file [String]</tt>: Path to file to load weights to neural network
        # - returns instance of <tt>ApplicationNetwork</tt> with weights loaded
        def load_dict(parameters_file)
          model = new
          model.load_state_dict Torch.load(parameters_file)

          model
        end

        # :nodoc:
        def input_preprocess(input)
          raise NotImplementedError
        end
      end

      protected
        # Convenient function to call <tt>Torch::NN::Functional</tt> methods
        #
        # - <tt>args</tt>
        #   - <tt>name [String, Symbol]</tt>: Name of the function to call from <tt>Torch::NN::Functional</tt> class as singleton method (like softmax, relu etc.)
        # - returns output from the specified function from the passed through arguments
        def function(name, ...)
          Torch::NN::F.public_send(name.to_sym, ...)
        end

        # Used to declare convenient methods from the LAYERS constant
        #
        # - <tt>args</tt>
        #   - <tt>name [String, Symbol]</tt>: Name of the layer (like conv2d, linear etc.)
        # - returns an instance of <tt>Torch::NN::<LayerName></tt> with passed through arguments
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
