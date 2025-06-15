require "ruby_llm"

RubyLLM.configure do |config|
  config.ollama_api_base = "#{ENV["OLLAMA_API_BASE"]}/api"

  config.default_model = "llama3.2:1b"
  config.default_embedding_model = "llama3.2:1b"
  config.default_image_model = "gemma3:4b"
end
