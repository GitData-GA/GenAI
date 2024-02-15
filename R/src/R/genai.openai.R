#' OpenAI Object Creation
#'
#' This function establishes a connection to an OpenAI model by providing essential parameters.
#'
#' @param api A character string representing the API key required for accessing the model.
#' @param model A character string representing the specific model.
#' @param version A character string representing the version of the chosen model.
#' @param proxy Optional. Default to \code{FALSE}. A boolean value indicating whether to use a
#' proxy for accessing the API URL. If your local internet cannot access the API, set this
#' parameter to \code{TRUE}.
#' @param organization.id Optional. Default to \code{NULL}. A character string representing the
#' organization ID.
#'
#' @return If successful, the function returns an OpenAI object. If the API response
#' indicates an error, the function halts execution and provides an error message.
#'
#' @details Providing accurate and valid information for each argument is crucial for successful text
#' generation by the generative AI model. If any parameter is incorrect, the function responds with an
#' error message based on the API feedback. To view all supported generative AI models, use the
#' function \code{\link{available.models}}.
#'
#' Please refer to \code{https://platform.openai.com/api-keys} for the API key. Moreover, please refer
#' to \code{https://platform.openai.com/account/organization} for the optional organization ID.
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
#' \href{https://colab.research.google.com/github/GitData-GA/GenAI/blob/gh-pages/r/example/genai_openai.ipynb}{Live Demo in Colab}
#'
#' @examples
#' \dontrun{
#' # Please change YOUR_OPENAI_API to your own API key of OpenAI
#' Sys.setenv(OPENAI_API = "YOUR_OPENAI_API")
#'
#' # Oprional. Please change YOUR_OPENAI_ORG to your own organization ID for OpenAI
#' Sys.setenv(OPENAI_ORG = "YOUR_OPENAI_ORG")
#'
#' all.models = available.models() %>% print()
#'
#' # Create an OpenAI object
#' openai = genai.openai(api = Sys.getenv("OPENAI_API"),
#'                       model = all.models$openai$model[1],
#'                       version = all.models$openai$version[1],
#'                       proxy = FALSE,
#'                       organization.id = Sys.getenv("OPENAI_ORG"))
#' }
#'
#' @export
genai.openai = function(api,
                        model,
                        version,
                        proxy = FALSE,
                        organization.id = NULL) {
  return (genai.openai.class$new(api,
                                 model,
                                 version,
                                 proxy,
                                 organization.id))
}
