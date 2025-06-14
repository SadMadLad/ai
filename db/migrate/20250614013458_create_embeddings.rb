class CreateEmbeddings < ActiveRecord::Migration[8.0]
  def change
    create_table :embeddings do |t|
      t.belongs_to :embeddable, polymorphic: true, null: false

      t.string :embedding_model
      t.vector :embedding, null: false

      t.timestamps
    end
  end
end
