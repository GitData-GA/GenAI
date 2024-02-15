#' @noRd
image.to.data.uri = function(image.path) {
  image.data = ""
  if (grepl("^https?://", tolower(image.path))) {
    response = httr::GET(image.path)
    image.data = base64enc::base64encode(httr::content(response, type = "raw"))
  } else {
    image.data = base64enc::base64encode(readBin(image.path, "raw", file.info(image.path)$size))
  }
  return(c(tools::file_ext(image.path), image.data))
}
