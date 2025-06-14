class EmbeddingService < ApplicationService
  required_params :record, :embedding_models

  BATCH_SIZE = 100

  def call
    @client = OllamaClient.new
    @embedding_models = Array(@embedding_models).uniq

    if single_record?
      process_single_record
    else
      process_multiple_records
    end
  end

  private
    def single_record?
      !@record.respond_to?(:length)
    end

    def process_single_record
      @embedding_models.each_slice(2).map do |embedding_models|
        embedding_data = Parallel.map(embedding_models, in_threads: embedding_models.length) do |embedding_model|
          embedding = @client.embed(model: OllamaClient.models[embedding_model], text: @record.public_send(embeddable)).first

          { embeddable: record, embedding:, embedding_model:}
        end
      end
    end

    def process_multiple_records
      embedding_data = @record.find_in_batches(batch_size: BATCH_SIZE).map do |records|
        @embedding_models.each_slice(2).map do |embedding_models|
          Parallel.map(embedding_models, in_threads: embedding_models.length) do |embedding_model|
            embeddings = @client.embed(model: OllamaClient.models[embedding_model], text: records.map(&:"#{embeddable}"))

            records.zip(embeddings).map { |record, embedding| { embeddable: record, embedding:, embedding_model: } }
          end
        end
      end

      Embedding.create embedding_data.flatten
    end

    def embeddable
      @embeddable ||= (single_record? ? @record : @record.first).embeddable
    end
end
