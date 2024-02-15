#' Moonshot AI Object Creation
#'
#' This function establishes a connection to a Moonshot AI model by providing essential parameters.
#'
#' @param api A character string representing the API key required for accessing the model.
#' @param model A character string representing the specific model.
#' @param version A character string representing the version of the chosen model.
#' @param proxy Optional. Default to \code{FALSE}. A boolean value indicating whether to use a
#' proxy for accessing the API URL. If your local internet cannot access the API, set this
#' parameter to \code{TRUE}.
#'
#' @return If successful, the function returns an moonshot object. If the API response
#' indicates an error, the function halts execution and provides an error message.
#'
#' @details Providing accurate and valid information for each argument is crucial for successful text
#' generation by the generative AI model. If any parameter is incorrect, the function responds with an
#' error message based on the API feedback. To view all supported generative AI models, use the
#' function \code{\link{available.models}}.
#'
#' Please refer to \code{https://platform.moonshot.cn/console/api-keys} for the API key.
#'
#' The API proxy service is designed to address the needs of users who hold a valid API key but find
#' themselves outside their home countries or regions due to reasons such as travel, work, or study
#' in locations that may not be covered by certain Generative AI service providers.
#'
#' Please be aware that although GenAI and its affiliated organization - GitData - do not gather user
#' information through this service, the server providers for GenAI API proxy service and the Generative
#' AI service providers may engage in such data collection. Furthermore, the proxy service cannot
#' guarantee a consistent connection speed. Users are strongly encouraged to utilize this service
#' with caution and at their own discretion.
#'
#' @seealso
#' \href{https://genai.gd.edu.kg/r/documentation/}{GenAI - R Package "GenAI" Documentation}
#'
#' \href{https://genai.gd.edu.kg/api/}{GenAI - Generative Artificial Intelligence API Proxy Service}
#'
#' \href{https://colab.research.google.com/github/GitData-GA/GenAI/blob/gh-pages/r/example/genai_moonshot.ipynb}{Live Demo in Colab}
#'
#' @examples
#' \dontrun{
#' # Please change YOUR_MOONSHOT_API to your own API key of Moonshot AI
#' Sys.setenv(MOONSHOT_API = "YOUR_MOONSHOT_API")
#'
#' all.models = available.models() %>% print()
#'
#' # Create an moonshot object
#' moonshot = genai.moonshot(api = Sys.getenv("MOONSHOT_API"),
#'                           model = all.models$moonshot$model[1],
#'                           version = all.models$moonshot$version[1],
#'                           proxy = FALSE)
#' }
#'
#' @export
genai.moonshot = function(api,
                          model,
                          version,
                          proxy = FALSE) {
  return (genai.moonshot.class$new(api,
                                   model,
                                   version,
                                   proxy))
}
