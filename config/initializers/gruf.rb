# frozen_string_literal: true

require 'gruf'

proto_dir = File.join(Rails.root, 'lib', 'proto')
$LOAD_PATH.unshift(proto_dir)

require 'app/proto/products_services_pb'

Gruf.configure do |c|
  c.interceptors.use(::Gruf::Interceptors::Instrumentation::RequestLogging::Interceptor, formatter: :logstash)
  c.error_serializer = Gruf::Serializers::Errors::Json
end
