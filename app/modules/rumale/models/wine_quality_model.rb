module Rumale
  module Models
    class WineQualityModel < ApplicationModel
      def initialize(random_seed: 42, saved: false)
        @random_seed = random_seed
        @model = self.class.load(path_to_model) if saved
      end

      def train_and_evaluate
        x, x_test, y, y_test = dataset

        grid_search.fit(x, y)
        @model = grid_search.best_estimator

        predictions = @model.predict(x_test)
        avg_loss = (predictions - y_test).abs.mean

        Rails.logger.info "Average Absolute loss: #{avg_loss}"

        self.class.save(path_to_model, @model)
      end

      def predict(params)
        params = self.class.preprocess_input(params)
        params = Numo::DFloat[*params] if params.is_a?(Array)

        prediction = @model.predict params.reshape(1, 11)
        prediction.to_a.first
      end

      class << self
        def preprocess_input(params)
          params.values.map(&:to_f)
        end
      end

      private
        def path_to_dataset
          Rails.root.join("data", "wine-quality", "wine-quality.csv").to_s
        end

        def path_to_model
          Rails.root.join("lib", "models", "random_forest_regressor.dat")
        end

        def dataset
          x = CsvUtils.parse(path_to_dataset, [:to_f] * 12, col_sep: ";")
          x = Numo::DFloat[*x]

          x, y = x[true, 0..-2], x[true, -1]
          Rumale::ModelSelection.train_test_split(x, y, test_size: 0.2, random_seed: @random_seed)
        end

        def model
          @model ||= Rumale::Pipeline::Pipeline.new(steps: {
            scaler: Rumale::Preprocessing::StandardScaler.new,
            pca: Rumale::Decomposition::PCA.new(n_components: 7, random_seed: @random_seed),
            forest: Rumale::Ensemble::RandomForestRegressor.new(
              n_estimators: 10,
              criterion: "gini",
              max_depth: 3,
              max_leaf_nodes: 10,
              min_samples_leaf: 5,
              random_seed: @random_seed,
              n_jobs: -1,
            )
          })
        end

        def grid_search
          @grid_search ||= Rumale::ModelSelection::GridSearchCV.new(
            estimator: model,
            param_grid:,
            splitter:,
          )
        end

        def splitter
          @splitter ||= Rumale::ModelSelection::StratifiedKFold.new(n_splits: 5)
        end

        def param_grid
          @param_grid ||= {
            pca__n_components: [7],
            forest__n_estimators: [100],
            forest__max_depth: [7],
            forest__min_samples_leaf: [5]
          }
        end
    end
  end
end
