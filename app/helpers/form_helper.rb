module FormHelper
  def errors_for_field(model, field, options = {})
    options = {
      full: true,
    }.merge(options)
    if model.errors.has_key? field
      message_method = options[:full] ? "full_messages_for" : "messages_for"
      render partial: "partials/errors_for_field", locals: { messages: model.errors.send(message_method, field) }
    end
  end
end
