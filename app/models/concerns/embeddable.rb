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

    def set_embeddable_column(name)
      raise ArgumentError, "Column must exist" unless column_names.include?(name.to_s)

      self.embeddable_column = name.to_sym
    end
  end

  def embed(embedding_models:)
    raise ArgumentError, "Please set the embeddable_column first" if self.class.embeddable_column.blank?

    embedding_models = Array(embedding_models)

    EmbeddingService.call(record: self, embedding_models:)
  end
end
