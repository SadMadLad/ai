class RawPayloadsController < ApplicationController
  def index
    if params[:recommendation].present?
      query, embedding_model, distance = search_params.values_at(:query, :embedding_model, :distance)
      @raw_payloads = RawPayload.recommendations(query, embedding_model:, distance:)
    else
      @raw_payloads = RawPayload.all
    end
  end

  def search
  end

  private
    def search_params
      @search_params ||= params.require(:recommendation).permit(:query, :embedding_model, :distance)
    end
end
