class OllamaClient < ApplicationClient
  delegate :summarize, to: :@client

  MODELS = {
    gemma: "gemma3:4b",
    llama: "llama3.1:latest",
    llama_sm: "llama3.2:1b",
    deepseek: "deepseek-r1:7b",
    deepseek_sm: "deepseek-r1:1.5b",
    qwen: "qwem2.5:7b"
  }.with_indifferent_access.freeze

  def initialize(model: :deepseek, options: {})
    @client = Langchain::LLM::Ollama.new(
      url: ENV["OLLAMA_API_BASE"],
      default_options: {
        embedding_model: MODELS[model],
        completion_model: model,
        chat_model: model,
        stream: true,
        options:
      }
    )
  end

  def embed(...)
    @client.embed(...).embeddings
  end

  class << self
    def models
      MODELS
    end

    def embedding_models
      models.slice(:llama, :llama_sm, :deepseek, :deepseek_sm)
    end
  end
end
