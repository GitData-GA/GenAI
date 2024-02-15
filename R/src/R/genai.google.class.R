#' @noRd
genai.google.class = R6Class(
  classname = "genai.google",
  public = list(
    # Initialize method
    initialize = function(api, model, version, proxy = FALSE) {
      genai.google.check(api, model, version, proxy)
      private$api = api
      private$model = model
      private$version = version
      private$proxy = proxy
    },
    # Chat generation
    chat = function(prompt,
                    verbose = FALSE,
                    config = list()) {
      genai.google.chat(private,
                        prompt,
                        verbose,
                        config)
    },
    # Chat edit
    chat.edit = function(prompt,
                         message.to.edit,
                         verbose = FALSE,
                         config = list()) {
      genai.google.chat.edit(private,
                             prompt,
                             message.to.edit,
                             verbose,
                             config)
    },
    # Convert chat history
    chat.history.convert = function(from.genai.object, to.genai.object) {
      genai.google.chat.history.convert(private, to.genai.object)
    },
    # Export chat history
    chat.history.export = function() {
      genai.google.chat.history.export(private)
    },
    # Import chat history
    chat.history.import = function(new.chat.history) {
      genai.google.chat.history.import(private, new.chat.history)
    },
    # Print chat history
    chat.history.print = function(from = 1, to = NULL) {
      genai.google.chat.history.print(private, from, to)
    },
    # Reset chat history
    chat.history.reset = function() {
      genai.google.chat.history.reset(private)
    },
    # Save chat history
    chat.history.save = function(file.name) {
      genai.google.chat.history.save(private, file.name)
    },
    # Text generation
    txt = function(prompt,
                   verbose = FALSE,
                   config = list()) {
      genai.google.txt(private,
                       prompt,
                       verbose,
                       config)
    },
    # Text generation with image as input
    txt.image = function(prompt,
                         image.path,
                         verbose = FALSE,
                         config = list()) {
      genai.google.txt.image(private,
                             prompt,
                             image.path,
                             verbose,
                             config)
    }
  ),
  private = list(
    api = NULL,
    model = NULL,
    version = NULL,
    proxy = FALSE,
    chat.history = listenv::listenv(contents = list())
  )
)
