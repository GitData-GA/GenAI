#' Set up and connect to a Generative AI model
#'
#' This function establishes a connection to a Generative AI model by providing essential
#' parameters such as the service provider, model, version, API key, and proxy status.
#'
#' @param provider A character string representing the Generative AI service provider
#' (e.g., \code{"google"}, \code{"openai"}).
#' @param model A character string representing the specific model offered by the selected
#' provider (e.g., \code{"gpt-3.5-turbo"}, \code{"gemini-pro"}).
#' @param version A character string representing the version of the chosen model.
#' @param api A character string representing the API key required for accessing the model.
#' @param proxy A boolean value indicating whether to use a proxy for accessing the API
#' URL (default is \code{FALSE}). If your local internet cannot access the APIs, set this
#' parameter to \code{TRUE}.
#'
#' @return If successful, the function returns a vector containing information about the
#' chosen Generative AI service provider, model, version, API key, and proxy status.
#' If the API response indicates an error, the function halts execution and provides
#' an error message.
#'
#' @details It is crucial to provide accurate and valid information for each parameter
#' to ensure a successful connection to the Generative AI model. If any of the provided
#' parameters are incorrect, the function will respond with an error message based on
#' the information received from the API. Use the function \code{available.models()} to
#' see all supported Generative AI models.
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
#'  google.model
#'  
#'  # Connect to the model, replace API_KEY with your api key
#'  openai.model = connect.genai("openai",
#'                               models$openai$model[1],
#'                               models$openai$version[1],
#'                               "API_KEY",
#'                               FALSE)
#'  openai.model
#' }
#'
#' @export
connect.genai = function (provider,
                          model,
                          version,
                          api,
                          proxy = FALSE) {
  json.data = jsonlite::fromJSON("https://genai.gd.edu.kg/model.json")
  provider = match.arg(provider, c(names(json.data)), several.ok = FALSE)
  model = match.arg(model, json.data[[provider]]$model, several.ok = FALSE)
  switch (provider,
          google = {
            version = match.arg(version, json.data$google$version, several.ok = FALSE)
            api.URL = ifelse(
              proxy,
              paste0(
                "https://api.genai.gd.edu.kg/google/",
                version,
                "/models/",
                model,
                "?key=",
                api
              ),
              paste0(
                "https://generativelanguage.googleapis.com/",
                version,
                "/models/",
                model,
                "?key=",
                api
              )
            )
            response = httr::GET(url = api.URL,
                                 httr::add_headers("Content-Type" = "application/json"))
            responseJSON = httr::content(response, "parsed")
            if (!is.null(responseJSON$error)) {
              stop(responseJSON$error$message)
            }
          },
          openai = {
            version = match.arg(version, json.data$openai$version, several.ok = FALSE)
            api.URL = ifelse(
              proxy,
              paste0(
                "https://api.genai.gd.edu.kg/openai/",
                version,
                "/models"
              ),
              paste0("https://api.openai.com/",
                     version, "/models")
            )
            response = httr::GET(
              url = api.URL,
              httr::add_headers(
                "Content-Type" = "application/json",
                "Authorization" = paste("Bearer", api)
              )
            )
            responseJSON = httr::content(response, "parsed")
            if (!is.null(responseJSON$error)) {
              stop(responseJSON$error$message)
            }
          })
  return (
    c(
      "provider" = provider,
      "model" = model,
      "version" = version,
      "api" = api,
      "proxy" = proxy
    )
  )
}
