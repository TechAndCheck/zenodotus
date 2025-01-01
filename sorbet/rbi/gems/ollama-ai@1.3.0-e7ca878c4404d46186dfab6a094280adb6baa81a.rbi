# typed: true

# DO NOT EDIT MANUALLY
# This is an autogenerated file for types exported from the `ollama-ai` gem.
# Please instead update this file by running `bin/tapioca gem ollama-ai`.


module Ollama
  class << self
    # source://ollama-ai//ports/dsl/ollama-ai.rb#7
    def new(*_arg0, **_arg1, &_arg2); end

    # source://ollama-ai//ports/dsl/ollama-ai.rb#11
    def version; end
  end
end

module Ollama::Controllers; end

class Ollama::Controllers::Client
  def initialize(config); end

  def chat(payload, server_sent_events: T.unsafe(nil), &callback); end
  def copy(payload, server_sent_events: T.unsafe(nil), &callback); end
  def create(payload, server_sent_events: T.unsafe(nil), &callback); end
  def delete(payload, server_sent_events: T.unsafe(nil), &callback); end
  def embeddings(payload, server_sent_events: T.unsafe(nil), &callback); end
  def generate(payload, server_sent_events: T.unsafe(nil), &callback); end
  def pull(payload, server_sent_events: T.unsafe(nil), &callback); end
  def push(payload, server_sent_events: T.unsafe(nil), &callback); end
  def request(path, payload = T.unsafe(nil), server_sent_events: T.unsafe(nil), request_method: T.unsafe(nil), &callback); end
  def safe_parse_json(raw); end
  def safe_parse_jsonl(raw); end
  def show(payload, server_sent_events: T.unsafe(nil), &callback); end
  def tags(server_sent_events: T.unsafe(nil), &callback); end

  class << self
    # source://comma/4.7.0/lib/comma/object.rb#7
    def comma_formats; end
  end
end

Ollama::Controllers::Client::ALLOWED_REQUEST_OPTIONS = T.let(T.unsafe(nil), Array)
Ollama::Controllers::Client::DEFAULT_ADDRESS = T.let(T.unsafe(nil), String)
Ollama::Controllers::Client::DEFAULT_FARADAY_ADAPTER = T.let(T.unsafe(nil), Symbol)
module Ollama::Errors; end

class Ollama::Errors::BlockWithoutServerSentEventsError < ::Ollama::Errors::OllamaError
  class << self
    # source://comma/4.7.0/lib/comma/object.rb#7
    def comma_formats; end
  end
end

class Ollama::Errors::OllamaError < ::StandardError
  def initialize(message = T.unsafe(nil)); end

  class << self
    # source://comma/4.7.0/lib/comma/object.rb#7
    def comma_formats; end
  end
end

class Ollama::Errors::RequestError < ::Ollama::Errors::OllamaError
  def initialize(message = T.unsafe(nil), request: T.unsafe(nil), payload: T.unsafe(nil)); end

  def payload; end
  def request; end

  class << self
    # source://comma/4.7.0/lib/comma/object.rb#7
    def comma_formats; end
  end
end

Ollama::GEM = T.let(T.unsafe(nil), Hash)