# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

RawPayload.delete_all

raw_payloads = []

20.times do
  raw_payloads << Faker::Books::Dune.saying
  raw_payloads << Faker::Books::Dune.quote
  raw_payloads << Faker::Movies::TheRoom.quote
  raw_payloads << Faker::Movie.quote
  raw_payloads << Faker::Quote.famous_last_words
  raw_payloads << Faker::Quote.matz
  raw_payloads << Faker::Quote.robin
end

raw_payloads = raw_payloads.uniq.map do |payload|
  { payload_type: "text", payload: }
end

RawPayload.create(raw_payloads)
