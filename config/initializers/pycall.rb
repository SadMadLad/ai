Rails.application.config.after_initialize do
  site = PyCall.import_module("site")
  site.addsitedir(ENV["POETRY_PACKAGES"])
end
