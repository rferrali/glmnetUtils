% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/makeModelComponents.r
\name{glmnet.model.matrix}
\alias{glmnet.model.frame}
\alias{glmnet.model.matrix}
\alias{glmnet.modelFrame}
\alias{glmnet.modelMatrix}
\title{Model matrix options for glmnet}
\description{
This page describes the options available for generating the model matrix.
}
\details{
There are two ways in which glmnetUtils can generate a model matrix out of a formula and data frame. The first is to use the standard R machinery comprising \code{\link{model.frame}} and \code{\link{model.matrix}}; and the second is to build the matrix one variable at a time. These options are discussed and contrasted below.
}
\section{Using \code{model.frame}}{

This is the simpler option, and the one that is most compatible with other R modelling functions. The \code{model.frame} function takes a formula and data frame and returns a \emph{model frame}: a data frame with special information attached that lets R make sense of the terms in the formula. For example, if a formula includes an interaction term, the model frame will specify which columns in the data relate to the interaction, and how they should be treated. Similarly, if the formula includes expressions like \code{exp(x)} or \code{I(x^2)} on the RHS, \code{model.frame} will evaluate these expressions and include them in the output.

The major disadvantage of using \code{model.frame} is that it generates a \code{\link{terms}} object, which encodes how variables and interactions are organised. One of the attributes of this object is a matrix with one row per variable, and one column per main effect and interaction. At minimum, this is (approximately) a \eqn{p \times p}{p x p} square matrix where \eqn{p} is the number of main effects in the model. For wide datasets with \eqn{p > 10000}, this matrix can approach or exceed a gigabyte in size. Even if there is enough memory to store such an object, generating the model matrix can take a significant amount of time.

Another issue with the standard R approach is the treatment of factors. Normally, \code{model.matrix} will turn an \eqn{N}-level factor into an indicator matrix with \eqn{N-1} columns, with one column being dropped. This is necessary for unregularised models as fit with \code{lm} and \code{glm}, since the full set of \eqn{N} columns is linearly dependent. With the usual \link[=contr.treatment]{treatment contrasts}, the interpretation is that the dropped column represents a baseline level, while the coefficients for the other columns represent the difference in the response relative to the baseline.

This may not be appropriate for a regularised model as fit with glmnet. The regularisation procedure shrinks the coefficients towards zero, which forces the estimated differences from the baseline to be smaller. But this only makes sense if the baseline level was chosen beforehand, or is otherwise meaningful as a default; otherwise it is effectively making the levels more similar to an arbitrarily chosen level.
}

\section{Manually building the model matrix}{

To deal with the problems above, glmnetUtils by default will avoid using \code{model.frame}, instead building up the model matrix term-by-term. This avoids the memory cost of creating a \code{terms} object, and can be noticeably faster than the standard approach. It will also include one column in the model matrix for \emph{all} levels in a factor; that is, no baseline level is assumed. In this situation, the coefficients represent differences from the overall mean response, and shrinking them to zero \emph{is} meaningful (usually).

The main downside of not using \code{model.frame} is that the formula can only be relatively simple. At the moment, only straightforward formulas like \code{y ~ x1 + x2 + ... + x_p} are handled by the code, where the x's are columns already present in the data. Interaction terms and computed expressions are not supported. Where possible, you should compute such expressions beforehand.
}

