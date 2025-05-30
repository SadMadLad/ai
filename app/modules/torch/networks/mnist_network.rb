module Torch
  module Networks
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
    end
  end
end
