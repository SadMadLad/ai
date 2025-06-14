class CreateRawPayloads < ActiveRecord::Migration[8.0]
  def change
    create_table :raw_payloads do |t|
      t.string :payload_type, null: false

      t.text :payload, null: false

      t.timestamps
    end
  end
end
