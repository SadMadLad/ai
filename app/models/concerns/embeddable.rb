module Embeddable
  extend ActiveSupport::Concern

  included do
    class_attribute :embeddable
    has_many :embeddings, as: :embeddable, dependent: :destroy
  end

  class_methods do
    def embeddings(model: nil)
      Embedding.where **{ embeddable_type: name.to_s, model: }.compact
    end

    def embed(records, embedding_models: %i[ deepseek_sm llama_sm ])
      raise ArgumentError, "Please set the embeddable first" if embeddable.blank?

      EmbeddingService.call(record: records, embedding_models:)
    end

    def embed_all(...)
      embed(self.all, ...)
    end

    def set_embeddable(name)
      self.embeddable = name.to_sym
    end

    def nearest_neighbors(record, embedding_model: :deepseek_sm, distance: "cosine")
      vector = record.embeddings.find_by(embedding_model:)

      neighbors(vector.embedding, embedding_model:, distance:).excluding(record)
    end

    def recommendations(query, embedding_model: :deepseek_sm, distance: "cosine")
      query_embedding = OllamaClient.new.embed(model: OllamaClient.embedding_models[embedding_model], text: query).first

      neighbors(query_embedding, embedding_model:, distance:)
    end

    def neighbors(query_embedding, embedding_model: :deepseek_sm, distance: "cosine")
      neighbor_ids = embeddings
        .public_send(embedding_model)
        .nearest_neighbors(:embedding, query_embedding, distance:)
        .pluck(:embeddable_id)

      where(id: neighbor_ids)
        .order(
          Arel.sql("array_position(ARRAY[#{neighbor_ids.join(',')}]::int[], id)")
        )
    end
  end

  def embed(embedding_models:)
    raise ArgumentError, "Please set the embeddable first" if self.class.embeddable.blank?

    embedding_models = Array(embedding_models)

    EmbeddingService.call(record: self, embedding_models:)
  end

  def nearest_neighbors(...)
    self.class.nearest_neighbors(self, ...)
  end
end
