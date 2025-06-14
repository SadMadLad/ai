# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


raw_payloads = [
  "English is one of the languages of all time",
  "Bruce Lee",
  "The Last Dragon",
  "Kung Fu",
  "Urdu, Hindi and Bengali are also languages of all time."
].map { |text| { payload_type: "text", payload: text } }

raw_payloads = RawPayload.create raw_payloads
