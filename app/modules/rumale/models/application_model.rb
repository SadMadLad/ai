module Rumale
  module Models
    class ApplicationModel
      class << self
        def save(path_to_save, model)
          File.open(path_to_save.to_s, 'wb') { |file| file.write(Marshal.dump(model)) }
        end

        def load(path_to_model)
          Marshal.load File.binread(path_to_model.to_s)
        end

        def input_preprocess(_params)
          raise NotImplementedError
        end

        def load_saved_model
          new(saved: true)
        end
      end
    end
  end
end
