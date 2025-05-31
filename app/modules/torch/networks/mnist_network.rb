module Torch
  module Networks
    # Neural Network for training MNIST dataset
    class MnistNetwork < ApplicationNetwork
      def initialize
        super

        @conv1 = conv2d(1, 32, 3, stride: 1)
        @conv2 = conv2d(32, 64, 3, stride: 1)

        @fc1 = linear(9216, 128)
        @fc2 = linear(128, 10)
      end

      def forward(x)
        x = @conv1.call(x)
        x = function :relu, x

        x = @conv2.call(x)
        x = function :max_pool2d, x, 2

        x = Torch.flatten(x, 1)

        x = @fc1.call(x)
        x = function :relu, x
        x = @fc2.call(x)

        function :log_softmax, x, 1
      end

      # Make a prediction about the image
      def predict(params)
        eval
        prediction = nil

        Torch.no_grad do
          params = self.class.input_preprocess(params)
          prediction = call(params)
          prediction = prediction.argmax(1, keepdim: true)

          prediction = prediction.flatten.to_i
        end

        prediction
      end

      class << self
        # Preprocesses a tempfile (image) and prepare it for prediction
        def input_preprocess(params)
          image = Vips::Image.new_from_file params[:input_image].path
          image = TorchVision::Transforms::F.resize(image, [28, 28])

          image = image.extract_band(0, n: 3) if image.bands > 3
          image = image.colourspace(:b_w)

          image = TorchVision::Transforms::F.to_tensor(image)
          image = TorchVision::Transforms::F.normalize(image, [ 0.1307 ], [ 0.3801 ])
          image.reshape(1, 1, 28, 28)
        end
      end
    end
  end
end
