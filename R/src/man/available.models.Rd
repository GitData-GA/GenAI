% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/available.models.R
\name{available.models}
\alias{available.models}
\title{Get Supported Generative AI Models}
\usage{
available.models()
}
\value{
If successful, the function returns a list containing generative AI
service providers and their corresponding models. If the function encounters an error,
it will halt execution and provide an error message.
}
\description{
This function sends a request to GenAI database API to retrieve information
about available generative AI models.
}
\details{
The function utilizes the GenAI database API to fetch the latest information about
available Generative AI models. The retrieved data includes details about different models
offered by various service providers.
}
\examples{
\dontrun{
# Assuming there is a GenAI object named 'genai.model' supporting this
# function, please refer to the "Live Demo in Colab" above for real
# examples. The following examples are just some basic guidelines.

all.models = available.models() \%>\% print()
}

}
\seealso{
\href{https://genai.gd.edu.kg/r/documentation/}{GenAI - R Package "GenAI" Documentation}

\href{https://colab.research.google.com/github/GitData-GA/GenAI/blob/gh-pages/r/example/available_models.ipynb}{Live Demo in Colab}
}
