#' @noRd
genai.google.check = function(api, model, version, proxy) {
  json.data = jsonlite::fromJSON("https://genai.gd.edu.kg/model.json")
  if (is.na(match(model, json.data$google$model))) {
    stop(
      "Invalid value for model. Refer to 'available.models()' to view the supported models."
    )
  }
  if (is.na(match(version, json.data$google$version))) {
    stop(
      "Invalid value for version. Refer to 'available.models()' to view the supported versions."
    )
  }
  if (!proxy %in% c(TRUE, FALSE)) {
    stop("Invalid value for proxy. It must be either TRUE or FALSE.")
  }

  # Check connection
  api.url = paste0(
    "https://generativelanguage.googleapis.com/",
    version,
    "/models/",
    model,
    "?key=",
    api
  )
  if (proxy) {
    api.url = paste0("https://api.genai.gd.edu.kg/google/",
                     version,
                     "/models/",
                     model,
                     "?key=",
                     api)
  }
  response = httr::GET(url = api.url,
                       httr::add_headers("Content-Type" = "application/json"))
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
genai.google.config.check = function(config) {
  if (!is.list(config)) {
    stop("Invalid configuration. It must be a list.")
  }
  config.names = c(
    "harm.category.dangerous.content",
    "harm.category.harassment",
    "harm.category.hate.speech",
    "harm.category.sexually.explicit",
    "stop.sequences",
    "max.output.tokens",
    "temperature",
    "top.p",
    "top.k"
  )
  wrong.config = setdiff(names(config), config.names)
  if (length(wrong.config) > 0) {
    stop("Invalid configuration(s) detected: ",
         paste0(wrong.config, collapse = ", "))
  }
  if (length(unique(names(config))) != length(names(config))) {
    stop("Invalid configurations. Duplicate parameters detected.")
  }

  # Check harm categories
  invalid.harm = lapply(config.names[1:4], function(harm) {
    if (!is.null(config[[harm]]) &&
        is.na(match(config[[harm]], c(1, 2, 3, 4, 5)))) {
      return(paste0("Invalid value for ", harm, ". It must be 1, 2, 3, 4, or 5.\n"))
    }
  })
  invalid.harm = Filter(Negate(is.null), invalid.harm)
  if (length(invalid.harm) > 0) {
    stop(invalid.harm)
  }

  # Check stop sequence
  if (!is.null(config[["stop.sequences"]]) &&
      !is.list(config[["stop.sequences"]])) {
    stop("Invalid stop.sequences. It must be a list.")
  }
  if (length(config[["stop.sequences"]]) > 5) {
    stop("Invalid value for stop.sequences. It can only have at most 5 strings.")
  }
}

#' @noRd
genai.google.formated.confguration = function(request.body, prompt) {
  if (!is.null(request.body$safetySettings)) {
    cat("=============================================================================\n")
    cat("   Safety Settings\n")
    cat("-----------------------------------------------------------------------------\n")
    for (i in 1:length(request.body$safetySettings)) {
      cat(
        paste0(request.body$safetySettings[[i]]$category, ":"),
        request.body$safetySettings[[i]]$threshold,
        "\n"
      )
    }
    cat("=============================================================================\n\n\n\n")
  }
  if (!is.null(request.body$generationConfig)) {
    cat("=============================================================================\n")
    cat("   Generation Configuration\n")
    cat("-----------------------------------------------------------------------------\n")
    has.stop.sequences = FALSE
    if (!is.null(request.body$generationConfig$stopSequences)) {
      has.stop.sequences = TRUE
      cat(
        "stopSequences:",
        paste0(
          request.body$generationConfig$stopSequences,
          collapse = ", "
        ),
        "\n"
      )
    }
    config.length = length(request.body$generationConfig)
    config.names = names(request.body$generationConfig)
    if (has.stop.sequences) {
      if (config.length > 1) {
        for (i in 2:config.length) {
          cat(paste0(config.names[i], ":"),
              request.body$generationConfig[[config.names[i]]],
              "\n")
        }
      }
    }
    else {
      for (i in 1:config.length) {
        cat(paste0(config.names[i], ":"),
            request.body$generationConfig[[config.names[i]]],
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

#' @noRd
genai.google.generation.config = function(config) {
  configuration = list()
  if (!is.null(config[["stop.sequences"]])) {
    configuration$stopSequences = config[["stop.sequences"]]
  }
  if (!is.null(config[["max.output.tokens"]])) {
    configuration$maxOutputTokens = config[["max.output.tokens"]]
  }
  if (!is.null(config[["temperature"]])) {
    configuration$temperature = config[["temperature"]]
  }
  if (!is.null(config[["top.p"]])) {
    configuration$topP = config[["top.p"]]
  }
  if (!is.null(config[["top.k"]])) {
    configuration$topK = config[["top.k"]]
  }
  return(configuration)
}

#' @noRd
genai.google.safety.setting = function(config) {
  raw.harm.category = c(
    harm.category.dangerous.content = "HARM_CATEGORY_DANGEROUS_CONTENT",
    harm.category.harassment = "HARM_CATEGORY_HARASSMENT",
    harm.category.hate.speech = "HARM_CATEGORY_HATE_SPEECH",
    harm.category.sexually.explicit = "HARM_CATEGORY_SEXUALLY_EXPLICIT"
  )
  raw.harm.block.threshold = c(
    "HARM_BLOCK_THRESHOLD_UNSPECIFIED",
    "BLOCK_LOW_AND_ABOVE",
    "BLOCK_MEDIUM_AND_ABOVE",
    "BLOCK_ONLY_HIGH",
    "BLOCK_NONE"
  )
  filled.harm =
    lapply(names(raw.harm.category), function(harm) {
      if (!is.null(config[[harm]])) {
        safety.setting.object = list("category" = raw.harm.category[harm],
                                     "threshold" = raw.harm.block.threshold[config[[harm]]])
        return(safety.setting.object)
      } else {
        return(NULL)
      }
    })
  filled.harm = Filter(Negate(is.null), filled.harm)
  return(filled.harm)
}
