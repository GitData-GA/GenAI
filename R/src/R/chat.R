#' Chat Generation with Text as the Input
#'
#' This function establishes a connection to a generative AI model through a generative AI object.
#' It generates a chat response based on the provided prompt and stores it in the chat history along
#' with the generative AI object.
#'
#' @param genai.object A generative AI object containing necessary and correct information.
#' @param prompt A character string representing the query for chat generation.
#' @param verbose Optional. Default to \code{FALSE}. A boolean value determining whether or not to print
#' out the details of the chat request.
#' @param config Optional. Default to \code{list()}. A list of configuration parameters for chat generation.
#'
#' @return If successful, the most recent chat response will be returned. If the API response indicates
#' an error, the function halts execution and provides an error message.
#'
#' @details Providing accurate and valid information for each argument is crucial for successful chat
#' generation by the generative AI model. If any parameter is incorrect, the function responds with an
#' error message based on the API feedback. To view all supported generative AI models, use the
#' function \code{\link{available.models}}.
#'
#' In addition, this function modifies the chat history along with the generative AI object directly,
#' meaning the chat history is mutable. You can print out the chat history using the
#' function \code{\link{chat.history.print}} or simply use \code{verbose = TRUE} in this function. If you
#' want to edit a message, use the function \code{\link{chat.edit}}. To reset the chat history along with
#' the generative AI object, use the function \code{\link{chat.history.reset}}.
#'
#' For \strong{Google Generative AI} models, available configurations are as follows. For more detail,
#' please refer
#' to \code{https://ai.google.dev/api/rest/v1/HarmCategory},
#' \code{https://ai.google.dev/api/rest/v1/SafetySetting}, and
#' \code{https://ai.google.dev/api/rest/v1/GenerationConfig}.
#'
#' \itemize{
#'    \item \code{harm.category.dangerous.content}
#'
#'    Optional. An integer, from 1 to 5 inclusive, representing the threshold for dangerous content,
#'    with a higher value representing a lower probability of being blocked.
#'
#'    \item \code{harm.category.harassment}
#'
#'    Optional. An integer, from 1 to 5 inclusive, representing the threshold for harasment content,
#'    with a higher value representing a lower probability of being blocked.
#'
#'    \item \code{harm.category.hate.speech}
#'
#'    Optional. An integer, from 1 to 5 inclusive, representing the threshold for hate speech and
#'    content, with a higher value representing a lower probability of being blocked.
#'
#'    \item \code{harm.category.sexually.explicit}
#'
#'    Optional. An integer, from 1 to 5 inclusive, representing the threshold for sexually explicit
#'    content, with a higher value representing a lower probability of being blocked.
#'
#'    \item \code{stop.sequences}
#'
#'    Optional. A list of character sequences (up to 5) that will stop output generation. If specified,
#'    the API will stop at the first appearance of a stop sequence. The stop sequence will not be
#'    included as part of the response.
#'
#'    \item \code{max.output.tokens}
#'
#'    Optional. An integer, value varies by model, representing maximum number of tokens to include
#'    in a candidate.
#'
#'    \item \code{temperature}
#'
#'    Optional. A number, from 0.0 to 1.0 inclusive, controlling the randomness of the output.
#'
#'    \item \code{top.p}
#'
#'    Optional. A number, value varies by model, representing maximum cumulative probability of tokens
#'    to consider when sampling.
#'
#'    \item \code{top.k}
#'
#'    Optional. A number, value varies by model, representing maximum number of tokens to consider when sampling.
#' }
#'
#' For \strong{Moonshot AI} models, available configurations are as follows. For more detail, please refer to
#' \code{https://platform.moonshot.cn/api.html#chat-completion}.
#'
#' \itemize{
#'    \item \code{max.tokens}
#'
#'    Optional. An integer. The maximum number of tokens that will be generated when the chat completes.
#'    If the chat is not finished by the maximum number of tokens generated, the finish reason will be
#'    "length", otherwise it will be "stop".
#'
#'    \item \code{temperature}
#'
#'    Optional. A number. What sampling temperature to use, between 0 and 1. Higher values (e.g. 0.7) will
#'    make the output more random, while lower values (e.g. 0.2) will make it more focused and deterministic.
#'
#'    \item \code{top.p}
#'
#'    Optional. A number. Another sampling temperature.
#' }
#'
#' For \strong{OpenAI} models, available configurations are as follows. For more detail, please refer to
#' \code{https://platform.openai.com/docs/api-reference/chat/create}.
#'
#' \itemize{
#'    \item \code{frequency.penalty}
#'
#'    Optional. A number from -2.0 to 2.0 inclusive. Positive values penalize new tokens based on their
#'    existing frequency in the text so far, decreasing the model's likelihood to repeat the same line verbatim.
#'
#'    \item \code{logit.bias}
#'
#'    Optional. A map. Modify the likelihood of specified tokens appearing in the completion. Accepts a JSON object
#'    that maps tokens (specified by their token ID in the tokenizer) to an associated bias value from -100 to
#'    100. Mathematically, the bias is added to the logits generated by the model prior to sampling. The exact
#'    effect will vary per model, but values between -1 and 1 should decrease or increase likelihood of selection;
#'    values like -100 or 100 should result in a ban or exclusive selection of the relevant token.
#'
#'    \item \code{logprobs}
#'
#'    Optional. A boolean value. Whether to return log probabilities of the output tokens or not. If true, returns the log
#'    probabilities of each output token returned in the content of message
#'
#'    \item \code{top.logprobs}
#'
#'    Optional. An integer between 0 and 5 specifying the number of most likely tokens to return at each token
#'    position, each with an associated log probability. \code{logprobs} must be set to \code{TRUE} if this
#'    parameter is used.
#'
#'    \item \code{max.tokens}
#'
#'    Optional. An integer. The maximum number of tokens that can be generated in the chat completion. The total length of
#'    input tokens and generated tokens is limited by the model's context length.
#'
#'    \item \code{presence.penalty}
#'
#'    Optional. A Number between -2.0 and 2.0. Positive values penalize new tokens based on whether they appear
#'    in the text so far, increasing the model's likelihood to talk about new topics.
#'
#'    \item \code{response.format}
#'
#'    Optional. An object specifying the format that the model must output. Compatible with GPT-4 Turbo and
#'    all GPT-3.5 Turbo models newer than \code{gpt-3.5-turbo-1106}.
#'
#'    \item \code{seed}
#'
#'    Optional. An integer. If specified, our system will make a best effort to sample deterministically, such that repeated
#'    requests with the same seed and parameters should return the same result.
#'
#'    \item \code{stop}
#'
#'    Optional. A character string or list contains up to 4 sequences where the API will stop generating further tokens.
#'
#'    \item \code{temperature}
#'
#'    Optional. A number. What sampling temperature to use, between 0 and 2. Higher values like 0.8 will make the output
#'    more random, while lower values like 0.2 will make it more focused and deterministic.
#'
#'    \item \code{top.p}
#'
#'    Optional. A number. An alternative to sampling with temperature, called nucleus sampling, where the model considers
#'    the results of the tokens with \code{top.p} probability mass. So 0.1 means only the tokens comprising the top
#'    10% probability mass are considered.
#'
#'    \item \code{tools}
#'
#'    Optional. A list of tools the model may call. Currently, only functions are supported as a tool. Use this
#'    to provide a list of functions the model may generate JSON inputs for.
#'
#'    \item \code{tool.choice}
#'
#'    Optional. A character string or object. Controls which (if any) function is called by the model. \code{none} means
#'    the model will not call a function and instead generates a message. \code{auto} means the model can pick
#'    between generating a message or calling a function.
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
#' \href{https://colab.research.google.com/github/GitData-GA/GenAI/blob/gh-pages/r/example/chat.ipynb}{Live Demo in Colab}
#'
#' @examples
#' \dontrun{
#' # Assuming there is a GenAI object named 'genai.model' supporting this
#' # function, please refer to the "Live Demo in Colab" above for real
#' # examples. The following examples are just some basic guidelines.
#'
#' # Method 1 (recommended): use the pipe operator "%>%"
#' genai.model %>%
#'   chat(prompt = "Write a story about Mars in 50 words.") %>%
#'   cat()
#'
#' # Method 2: use the reference operator "$"
#' cat(genai.model$chat(prompt = "Write a story about Jupiter in 50 words."))
#'
#' # Method 3: use the function chat() directly
#' cat(chat(genai.object = genai.model,
#'          prompt = "Summarize the chat."))
#' }
#'
#' @export
chat = function(genai.object,
                prompt,
                verbose = FALSE,
                config = list()) {
  genai.object$chat(prompt,
                    verbose,
                    config)
}
