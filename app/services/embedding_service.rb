class EmbeddingService < ApplicationService
  required_params :record, :embedding_models

  def call
    @client = OllamaClient.new
    @record = Array(@record)
    @embeddable_column = @record.first.embeddable_column

    process_records
  end

  private
    def process_records
      all_embeddings = @record.each_slice(2).map do |records|
        Parallel.map(records, in_threads: records.length) do |record|
          @embedding_models.each_slice(2).map do |embedding_models|
            embedding_data = Parallel.map(embedding_models, in_threads: embedding_models.length) do |embedding_model|
              embedding = @client.embed(model: OllamaClient.models[embedding_model], text: record[@embeddable_column]).first

              { embeddable: record, embedding:, embedding_model: }
            end
          end
        end
      end

      Embedding.create all_embeddings.flatten
    end
end
