class Embedding < ApplicationRecord
  belongs_to :embeddable, polymorphic: true

  validates :embedding_model, presence: true, uniqueness: { scope: %i[ embeddable_id embeddable_type ] }

  enum :embedding_model, OllamaClient.embedding_models

  class << self
    Embedding.embedding_models.keys.each do |embedding_model|
      define_method(embedding_model) { Embedding.where(embedding_model:) }
    end
  end
end
