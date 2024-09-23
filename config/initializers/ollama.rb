OLLAMA_CLIENT = Ollama.new(
  credentials: { address: Figaro.env.OLLAMA_URL, basic_auth: "zeno:#{Figaro.env.OLLAMA_PASSWORD}" },
  options: { server_sent_events: false }
)
