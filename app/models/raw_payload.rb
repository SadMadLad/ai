class RawPayload < ApplicationRecord
  include Embeddable

  set_embeddable :payload

  validates :payload, presence: true

  enum :payload_type, {
    html: "html",
    json: "json",
    text: "text",
    xml: "xml",
    csv: "csv"
  }
end
