# resources :ml_models
class MlModelsController < ApplicationController
  before_action :set_ml_model, only: %i[show predict]

  # GET /ml_models
  def index
    @ml_models = MlModel.all
  end

  # GET /ml_models/:id
  def show
    @prediction_params = @ml_model.prediction_params
  end

  # POST /ml_models/:id/predict
  def predict
    @prediction = @ml_model.predict(prediction_params)
  end

  private
    # :nodoc:
    def set_ml_model
      @ml_model = MlModel.find(params[:id])
    end

    # :nodoc:
    def prediction_params
      params.require(:prediction).permit(*@ml_model.prediction_params.keys)
    end
end
