module CustomCops
  class YoutubeName < RuboCop::Cop::Cop
    MSG = "`YouTube` must be stylized as `Youtube`".freeze

    def on_send(node)
      add_offense(node, message: MSG) if node.receiver&.const_name&.include?("YouTube")
    end
  end
end
