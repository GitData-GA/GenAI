#' @noRd
genai.openai.class = R6Class(
  classname = "genai.openai",
  public = list(
    # Initialize method
    initialize = function(api, model, version, proxy = FALSE, organization.id = NULL) {
      genai.openai.check(api, model, version, proxy, organization.id)
      private$api = api
      private$model = model
      private$version = version
      private$proxy = proxy
      if (!is.null(organization.id) && is.character(organization.id)) {
        private$organization.id = organization.id
      }
    },
    # Chat generation
    chat = function(prompt,
                    verbose = FALSE,
                    config = list()) {
      genai.openai.chat(private,
                        prompt,
                        verbose,
                        config)
    },
    # Chat edit
    chat.edit = function(prompt,
                         message.to.edit,
                         verbose = FALSE,
                         config = list()) {
      genai.openai.chat.edit(private,
                             prompt,
                             message.to.edit,
                             verbose,
                             config)
    },
    # Convert chat history
    chat.history.convert = function(from.genai.object, to.genai.object) {
      genai.openai.chat.history.convert(private, to.genai.object)
    },
    # Export chat history
    chat.history.export = function() {
      genai.openai.chat.history.export(private)
    },
    # Import chat history
    chat.history.import = function(new.chat.history) {
      genai.openai.chat.history.import(private, new.chat.history)
    },
    # Print chat history
    chat.history.print = function(from = 1, to = NULL) {
      genai.openai.chat.history.print(private, from, to)
    },
    # Reset chat history
    chat.history.reset = function() {
      genai.openai.chat.history.reset(private)
    },
    # Save chat history
    chat.history.save = function(file.name) {
      genai.openai.chat.history.save(private, file.name)
    },
    # Image generation
    img = function(prompt,
                   verbose = FALSE,
                   config = list()) {
      genai.openai.img(private,
                       prompt,
                       verbose,
                       config)
    },
    # Text generation
    txt = function(prompt,
                   verbose = FALSE,
                   config = list()) {
      genai.openai.txt(private,
                       prompt,
                       verbose,
                       config)
    },
    # Text generation with image as input
    txt.image = function(prompt,
                         image.path,
                         verbose = FALSE,
                         config = list()) {
      genai.openai.txt.image(private,
                             prompt,
                             image.path,
                             verbose,
                             config)
    }
  ),
  private = list(
    api = NULL,
    organization.id = NULL,
    model = NULL,
    version = NULL,
    proxy = FALSE,
    chat.history = listenv::listenv(
      messages = list(
        list(
          role = "system",
          content = "You are a helpful assistant."
          )
        )
      )
  )
)
