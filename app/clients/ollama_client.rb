class OllamaClient < ApplicationClient
  delegate :chat, :complete, to: :@client

  MODELS = {
    gemma: "gemma3:4b",
    gemma_sm: "gemma3:1b",

    llama: "llama3.1:latest",
    llama_sm: "llama3.2:1b",

    deepseek_sm: "deepseek-r1:1.5b",
    deepseek_lg: "deepseek-r1:7b",

    qwen: "qwen2.5vl:3b",
    qwen_lg: "qwen2.5:7b",

    moondream_sm: "moondream:latest"
  }.with_indifferent_access.freeze

  def initialize(completion_model: :llama_sm, embedding_model: :llama_sm, options: {})
    @client = Langchain::LLM::Ollama.new(
      url: ENV["OLLAMA_API_BASE"],
      default_options: {
        embedding_model: embedding_models[embedding_model],
        completion_model: completion_models[completion_model],
        chat_model: completion_models[completion_models],
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

    def completion_models
      models.slice(:gemma_sm, :qwen, :gemma, :llama, :qwen_lg, :deepseek_lg, :deepseek_sm, :moondream_sm, :llama_sm)
    end

    def embedding_models
      models.slice(:gemma_sm, :qwen, :gemma, :llama, :qwen_lg, :deepseek_lg, :deepseek_sm, :moondream_sm, :llama_sm)
    end

    def tools_models
      models.slice(:llama, :qwen_lg, :llama_sm)
    end

    def vision_models
      models.slice(:qwen, :gemma, :moondream_sm)
    end
  end

  private
    %i[ models completion_models embedding_models tools_models vision_models ].each do |method_name|
      define_method(method_name) { self.class.public_send(method_name) }
    end
end
