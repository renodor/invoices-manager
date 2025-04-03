# frozen_string_literal:true

Grover.configure do |config|
  config.options = {
    format: "A4",
    print_background: true,
    timezone: "Europe/Paris",
    wait_for_function: "document.fonts.ready",
    root_path: "#{`npm prefix -g`.strip}/lib"
  }
end
