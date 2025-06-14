module Embeddable
  extend ActiveSupport::Concern

  included do
    class_attribute :embeddable_column
    has_many :embeddings, as: :embeddable, dependent: :destroy
  end

  class_methods do
    def embeddings(model: nil)
      Embedding.where **{ embeddable_type: name.to_s, model: }.compact
    end

    def embed(records, embedding_models:)
      raise ArgumentError, "Please set the embeddable_column first" if embeddable_column.blank?

      EmbeddingService.call(record: records, embedding_models:)
    end

    def set_embeddable_column(name)
      raise ArgumentError, "Column must exist" unless column_names.include?(name.to_s)

      self.embeddable_column = name.to_sym
    end

    def neighbors(record, embedding_model:, distance: "euclidean")
      vector = record.embeddings.find_by(embedding_model:)

      embeddings
        .public_send(embedding_model)
        .nearest_neighbors(:embedding, vector.embedding, distance:)
        .includes(:embeddable)
        .excluding(vector)
        .map(&:embeddable)
    end
  end

  def embed(embedding_models:)
    raise ArgumentError, "Please set the embeddable_column first" if self.class.embeddable_column.blank?

    embedding_models = Array(embedding_models)

    EmbeddingService.call(record: self, embedding_models:)
  end

  def neighbors(...)
    self.class.neighbors(self, ...)
  end
end
