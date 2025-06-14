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
  "Bruce Lee",
  "The Last Dragon",
  "Kung Fu",
  "Urdu, Hindi and Bengali are also languages of all time.",
  "YouTube is a video streaming platform",
  "Is Cobalt the best computer language of all time?",
  "Time for some hardcore banking!",
  "Ninjutsu is even real? Or not? I can't say much",
  "Dragunov does Combat Sambo in Tekken. Was not aware.",
  "Is Khabib the greatest UFC fighter of all time?",
  "Rust is making big strides when it comes to tooling.",
  "The battle for fastest programming language of all time isn't new. Zig is currently leading."
].map { |text| { payload_type: "text", payload: text } }

raw_payloads = RawPayload.create raw_payloads
