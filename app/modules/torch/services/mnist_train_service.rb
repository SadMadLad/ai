module Torch
  # Module containing all the services for <tt>torch-rb</tt> networks.
  module Services
    # Service to train <tt>MnistModel</tt>, test, evaluate and save the weights of the model
    class MnistTrainService
      # :nodoc:
      def initialize
        @dataset_path = Rails.root.join("data")
        @model_save_path = Rails.root.join("lib", "models", "mnist.pth")
        @seed = 1
        @device = "cpu"
      end

      # :nodoc:
      def call
        set_seed
        train
        test
        save
      end

      private
        # :nodoc:
        def save
          Torch.save(model.state_dict, @model_save_path)
        end

        # :nodoc:
        def set_seed
          Torch.manual_seed(@seed)
        end

        # :nodoc:
        def train(epochs: 10)
          1.upto(epochs) do |epoch|
            model.train
            train_loader.each_with_index do |(data, target), batch_index|
              data, target = data.to(@device), target.to(@device)
              optimizer.zero_grad
              output = model.call(data)
              loss = Torch::NN::F.nll_loss(output, target)
              loss.backward
              optimizer.step

              if batch_index % 2 == 0
                puts "Train Epoch: %d [%5d/%d (%.0f%%)] Loss: %.6f" % [
                  epoch, batch_index * data.size(0), train_loader.dataset.size,
                  100.0 * batch_index / train_loader.size, loss.item
                ]
              end
            end
          end
        end

        # :nodoc:
        def test
          model.eval
          test_loss = 0
          correct = 0

          Torch.no_grad do
            test_loader.each do |data, target|
              data, target = data.to(@device), target.to(@device)
              output = model.call(data)

              test_loss = Torch::NN::F.nll_loss(output, target, reduction: "sum").item
              pred = output.argmax(1, keepdim: true)
              correct += pred.eq(target.view_as(pred)).sum.item
            end
          end

          test_loss /= test_loader.dataset.size

          puts "Test set: Average loss: %.4f, Accuracy: %d/%d (%.1f%%)\n\n" % [
            test_loss, correct, test_loader.dataset.size,
            100.0 * correct / test_loader.dataset.size
          ]
        end

        # :nodoc:
        def model
          @model ||= Torch::Models::MnistModel.new.to(@device)
        end

        # :nodoc:
        def optimizer(lr: 0.001)
          @optimizer ||= Torch::Optim::Adam.new(model.parameters, lr:)
        end

        # :nodoc:
        def scheduler(optimizer, step_size:, gamma: 0.7)
          @scheduler ||= Torch::Optim::LRScheduler::StepLR.new(optimizer, step_size:, gamma:)
        end

        # :nodoc:
        def train_loader
          @train_loader ||= dataset_loader(train: true)
        end

        # :nodoc:
        def test_loader
          @test_loader ||= dataset_loader(train: false)
        end

        # :nodoc:
        def dataset_loader(train:, download: true, shuffle: true, batch_size: 64)
          dataset = TorchVision::Datasets::MNIST.new(
            @dataset_path,
            train:,
            download:,
            transform: TorchVision::Transforms::Compose.new(
              [
                TorchVision::Transforms::ToTensor.new,
                TorchVision::Transforms::Normalize.new([ 0.1307 ], [ 0.3801 ])
              ]
            )
          )

          Torch::Utils::Data::DataLoader.new(dataset, batch_size:, shuffle:)
        end
    end
  end
end
