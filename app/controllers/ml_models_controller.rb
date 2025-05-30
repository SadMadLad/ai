class MlModelsController < ApplicationController
  before_action :set_ml_model, only: %i[show predict]

  def index
    @ml_models = MlModel.all
  end

  def show
    @prediction_params = @ml_model.prediction_params
  end

  def predict
    @prediction = @ml_model.predict(prediction_params)
  end

  private
    def set_ml_model
      @ml_model = MlModel.find(params[:id])
    end

    def prediction_params
      params.require(:prediction).permit(*@ml_model.required_params)
    end
end
