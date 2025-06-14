class Embedding < ApplicationRecord
  belongs_to :embeddable, polymorphic: true

  validates :embedding, presence: true, uniqueness: { scope: %i[ embedding_model embeddable_type embedding_model ] }

  enum :embedding_model, OllamaClient.embedding_models
end
