# frozen_string_literal:true

SimpleForm.setup do |config|
  # Wrappers configration
  config.wrappers :default do |b|
    b.use :html5
    b.use :placeholder
    b.use :label
    b.use :input, class: 'form-input', error_class: 'form__input--invalid'
  end

  # Default configuration
  config.generate_additional_classes_for = []
  config.default_wrapper                 = :default
  config.button_class                    = 'btn'
  config.label_text                      = ->(label, _, _) { label }
  config.error_notification_tag          = :div
  config.error_notification_class        = 'error_notification'
  config.browser_validations             = false
end
