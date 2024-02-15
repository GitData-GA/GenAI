#' @noRd
genai.moonshot.class = R6Class(
  classname = "genai.moonshot",
  public = list(
    # Initialize method
    initialize = function(api, model, version, proxy = FALSE) {
      genai.moonshot.check(api, model, version, proxy)
      private$api = api
      private$model = model
      private$version = version
      private$proxy = proxy
    },
    # Chat generation
    chat = function(prompt,
                    verbose = FALSE,
                    config = list()) {
      genai.moonshot.chat(private,
                          prompt,
                          verbose,
                          config)
    },
    # Chat edit
    chat.edit = function(prompt,
                         message.to.edit,
                         verbose = FALSE,
                         config = list()) {
      genai.moonshot.chat.edit(private,
                               prompt,
                               message.to.edit,
                               verbose,
                               config)
    },
    # Convert chat history
    chat.history.convert = function(from.genai.object, to.genai.object) {
      genai.moonshot.chat.history.convert(private, to.genai.object)
    },
    # Export chat history
    chat.history.export = function() {
      genai.moonshot.chat.history.export(private)
    },
    # Import chat history
    chat.history.import = function(new.chat.history) {
      genai.moonshot.chat.history.import(private, new.chat.history)
    },
    # Print chat history
    chat.history.print = function(from = 1, to = NULL) {
      genai.moonshot.chat.history.print(private, from, to)
    },
    # Reset chat history
    chat.history.reset = function() {
      genai.moonshot.chat.history.reset(private)
    },
    # Save chat history
    chat.history.save = function(file.name) {
      genai.moonshot.chat.history.save(private, file.name)
    },
    # Text generation
    txt = function(prompt,
                   verbose = FALSE,
                   config = list()) {
      genai.moonshot.txt(private,
                         prompt,
                         verbose,
                         config)
    }
  ),
  private = list(
    api = NULL,
    model = NULL,
    version = NULL,
    proxy = FALSE,
    chat.history = listenv::listenv(
      messages = list(
        list(
          role = "system",
          content = "You are Kimi, an Artificial Intelligence Assistant powered by Moonshot AI, and you are better at conversations in Chinese and English. You will provide users with safe, helpful and accurate answers. At the same time, you will reject answers to questions about terrorism, racism, pornography, etc. Moonshot AI is a proper noun and cannot be translated into other languages."
        )
      )
    )
  )
)
