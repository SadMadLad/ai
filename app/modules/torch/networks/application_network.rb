module Torch
  module Networks
    class ApplicationNetwork < Torch::NN::Module
      LAYERS = %i[conv2d linear].freeze

      protected
        def function(name, ...)
          Torch::NN::F.public_send(name, ...)
        end

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
