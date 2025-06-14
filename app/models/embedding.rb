class Embedding < ApplicationRecord
  belongs_to :embeddable, polymorphic: true

  validates :embedding_model, presence: true, uniqueness: { scope: %i[ embeddable_id embeddable_type ] }

  enum :embedding_model, OllamaClient.embedding_models
end
