#' @noRd
genai.moonshot.check = function(api, model, version, proxy) {
  json.data = jsonlite::fromJSON("https://genai.gd.edu.kg/model.json")
  if (is.na(match(model, json.data$moonshot$model))) {
    stop(
      "Invalid value for model. Refer to 'available.models()' to view the supported models."
    )
  }
  if (is.na(match(version, json.data$moonshot$version))) {
    stop(
      "Invalid value for version. Refer to 'available.models()' to view the supported versions."
    )
  }
  if (!proxy %in% c(TRUE, FALSE)) {
    stop("Invalid value for proxy. It must be either TRUE or FALSE.")
  }

  # Check connection
  api.url = paste0(
    "https://api.moonshot.cn/",
    version,
    "/models"
  )
  if (proxy) {
    api.url = paste0(
      "https://api.genai.gd.edu.kg/moonshot/",
      version,
      "/models")
  }
  response = httr::GET(url = api.url,
                       httr::add_headers(
                         "Content-Type" = "application/json",
                         "Authorization" = paste("Bearer", api)
                       )
  )
  responseJSON = httr::content(response, "parsed")
  if (!is.null(responseJSON$error)) {
    stop(responseJSON$error$message)
  }
  if (response$status_code != 200) {
    stop(
      "Invalid parameter(s) detected. Please check the values for api, model, version, and proxy."
    )
  }
}

#' @noRd
genai.moonshot.config.check = function(config) {
  if (!is.list(config)) {
    stop("Invalid configuration. It must be a list.")
  }
  config.names = c(
    "max.tokens",
    "temperature",
    "top.p"
  )
  wrong.config = setdiff(names(config), config.names)
  if (length(wrong.config) > 0) {
    stop("Invalid configuration(s) detected: ",
         paste0(wrong.config, collapse = ", "))
  }
  if (length(unique(names(config))) != length(names(config))) {
    stop("Invalid configurations. Duplicate parameters detected.")
  }
}

#' @noRd
genai.moonshot.generation.config = function(requestBody, config) {
  config.names = c(
    max.tokens = "max_tokens",
    temperature = "temperature",
    top.p = "top_p"
  )
  for (param_name in names(config)) {
    if (!is.null(config[[param_name]])) {
      requestBody[[config.names[param_name]]] = config[[param_name]]
    }
  }
  return(requestBody)
}

#' @noRd
genai.moonshot.formated.confguration = function(request.body, prompt) {
  config.names = c(
    max.tokens = "max_tokens",
    temperature = "temperature",
    top.p = "top_p"
  )
  intersect.param = intersect(names(request.body), config.names)
  if (length(intersect.param) > 0) {
    cat("=============================================================================\n")
    cat("   Generation Configuration\n")
    cat("-----------------------------------------------------------------------------\n")
    for (param in intersect.param) {
      if (is.list(request.body[[param]])) {
        cat("stop:",
            paste0(request.body[[param]],
                   collapse = ", "),
            "\n")
      }
      else {
        cat(paste0(param, ":"),
            request.body[[param]],
            "\n")
      }
    }
    cat("=============================================================================\n\n\n\n")
  }
  cat("=============================================================================\n")
  cat("   Prompt\n")
  cat("-----------------------------------------------------------------------------\n")
  cat(paste(strwrap(prompt, width = 76, exdent = 0), collapse = "\n"))
  cat("\n")
  cat("=============================================================================\n\n\n\n")
}
