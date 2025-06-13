# frozen_string_literal: true

require "gruf"

proto_dir = File.join(Rails.root, "lib", "services")
$LOAD_PATH.unshift(proto_dir)

Dir["lib/services/*.rb"].each { |proto_file_service| require File.basename(proto_file_service) }

Gruf.configure do |c|
  c.default_client_host = ENV["GRPC_SERVER_URL"]
end
