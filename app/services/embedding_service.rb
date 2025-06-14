class EmbeddingService < ApplicationService
  required_params :record, :embedding_models

  def call
    @client = OllamaClient.new

    embedding_data = @embedding_models.map do |embedding_model|
      embedding = @client.embed(model: OllamaClient.models[embedding_model], text: @record[embeddable_column]).first

      { embeddable: @record, embedding:, embedding_model: }
    end

    @record.embeddings.create! embedding_data
  end

  private
    def embeddable_column
      @record.embeddable_column
    end
end
