#' Generate an empty chat history list for a Generative AI model
#'
#' This function establishes a connection to a Generative AI model by providing essential
#' parameters and generates an empty chat history list for the model.
#'
#' @param model.parameter A character vector containing the Generative AI service provider,
#' corresponding model, version, API key, and proxy status.
#'
#' @return If successful, a chat history list is generated for the Generative AI model.
#'
#' @details Providing accurate and valid information for each parameter is crucial
#' to ensure successful text generation by the Generative AI model. The chat history will be
#' modified by this function. If any of the provided parameters is incorrect, the function
#' will respond with an error message based on the information received from the API.
#' Use the function \code{available.models()} to see all supported Generative AI models.
#'
#' @examples
#' \dontrun{
#'  # Get available models
#'  models = available.models()
#' 
#'  # Connect to the model, replace API_KEY with your api key
#'  google.model = connect.genai("google",
#'                               models$google$model[1],
#'                               models$google$version[1],
#'                               "API_KEY",
#'                               FALSE)
#' 
#'  # Connect to the model, replace API_KEY with your api key
#'  openai.model = connect.genai("openai",
#'                               models$openai$model[1],
#'                               models$openai$version[1],
#'                               "API_KEY",
#'                               FALSE)
#'  # Setup an empty chat history
#'  google.history = chat.steup(google.model)
#'  print(google.history)
#' 
#'  openai.history = chat.steup(openai.model)
#'  print(openai.history)
#' }
#'
#' @export
chat.steup = function(model.parameter) {
  switch (model.parameter["provider"],
          google = {
            requestBody = list(contents = list())
            return (requestBody)
          },
          openai = {
            requestBody = list(model = model.parameter["model"],
                               messages = list(list(role = "system",
                                                    content = "You are a helpful assistant.")))
            return (requestBody)
          })
}
