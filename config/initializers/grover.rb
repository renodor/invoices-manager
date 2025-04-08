# frozen_string_literal:true

unless ENV["ASSETS_PRECOMPILE"]
  Grover.configure do |config|
    config.options = {
      format: "A4",
      print_background: true,
      timezone: "Europe/Paris",
      wait_for_function: "document.fonts.ready",
      root_path: "/usr/local/lib"
    }
  end
end
