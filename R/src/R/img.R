#' Image Generation with Text as the Input
#'
#' This function establishes a connection to a generative AI model through a generative AI object.
#' It generates an image response based on the provided prompt.
#'
#' @param genai.object A generative AI object containing necessary and correct information.
#' @param prompt A character string representing the query for image generation.
#' @param verbose Optional. Default to \code{FALSE}. A boolean value determining whether or not to print
#' out the details of the image request.
#' @param config Optional. Default to \code{list()}. A list of configuration parameters for image generation.
#'
#' @return If successful, a image in \code{ggplot} format will be returned. If the API response indicates
#' an error, the function halts execution and provides an error message.
#'
#' @details Providing accurate and valid information for each argument is crucial for successful image
#' generation by the generative AI model. If any parameter is incorrect, the function responds with an
#' error message based on the API feedback. To view all supported generative AI models, use the
#' function \code{\link{available.models}}.
#'
#' This function is only available when using OpenAI's models.
#'
#' For \strong{OpenAI} models, available configurations are as follows. For more detail, please refer to
#' \code{https://platform.openai.com/docs/api-reference/images/create}.
#'
#' \itemize{
#'    \item \code{quality}
#'
#'    Optional. A character string. The quality of the image that will be generated. \code{hd} creates
#'    images with finer details and greater consistency across the image.
#'
#'    \item \code{size}
#'
#'    Optional. A character string. The size of the generated images. Must be one of \code{256x256},
#'    \code{512x512}, or \code{1024x1024} for \code{dall-e-2}. Must be one of \code{1024x1024}, \code{1792x1024}, or
#'    \code{1024x1792} for \code{dall-e-3} models.
#'
#'    \item \code{style}
#'
#'    Optional. The style of the generated images. Must be one of \code{vivid} or \code{natural}. Vivid causes
#'    the model to lean towards generating hyper-real and dramatic images. Natural causes the model to produce
#'    more natural, less hyper-real looking images.
#'
#'    \item \code{user}
#'
#'    Optional. A character string. A unique identifier representing your end-user, which can help OpenAI to monitor
#'    and detect abuse.
#' }
#'
#' @seealso
#' \href{https://genai.gd.edu.kg/r/documentation/}{GenAI - R Package "GenAI" Documentation}
#'
#' \href{https://colab.research.google.com/github/GitData-GA/GenAI/blob/gh-pages/r/example/img.ipynb}{Live Demo in Colab}
#'
#' @examples
#' \dontrun{
#' # Assuming there is a GenAI object named 'genai.model' supporting this
#' # function, please refer to the "Live Demo in Colab" above for real
#' # examples. The following examples are just some basic guidelines.
#'
#' # Method 1 (recommended): use the pipe operator "%>%"
#' generated.image = genai.model %>%
#'   img(prompt = "A very cute panda eating banboo.")
#' generated.image
#'
#' # Method 2: use the reference operator "$"
#' generated.image = genai.model$img(prompt = "A very cute sea otter on a rock.")
#' generated.image
#'
#' # Method 3: use the function img() directly
#' generated.image = img(genai.object = genai.model,
#'                       prompt = "A very cute bear.")
#' generated.image
#' }
#'
#' @export
img = function(genai.object,
               prompt,
               verbose = FALSE,
               config = list()) {
  genai.object$img(prompt,
                   verbose,
                   config)
}
