#' @title Convert matrices
#' @description Performs inter-conversions between various formats of
#' position-specific scoring matrices (PSSM). The program also performs a
#' statistical analysis of the original matrix to provide different
#' position-specific scores (weight, frequencies, information contents),
#' general statistics (E-value, total information content), and synthetic
#' descriptions (consensus).
#' @author José Alquicira Hernández
#' @param matrix Matrix (or assembly or features) you want to convert.
#' @param from Input matrix format. Supported: alignace, assembly, cb, clustal,
#' consensus, feature, gibbs, infogibbs, meme, motifsampler, tab, transfac.
#' @param to Output matrix format. Supported: consensus, patser, tab, transfac.
#' @param return Result type (matrix content). Supported: consensus, counts,
#' frequencies, info, information, logo, margins, parameters, profile, sites,
#' wdistrib, weights.
#' @param background.format Format for the background model (prior) files.
#' Supported: oligo-analysis, MotifSampler, meme, dyads.
#' @param background.pseudo Pseudo frequency for the background models. Value
#' must be a real between 0 and 1 (default: 0.01).
#' @param sort
#' \itemize{
#' \item desc
#' \item asc
#' \item alpha}
#' Sort matrices according to the specified attribute (sort_key). The sorting
#' can be done on numerical values, either in descending (desc) or ascending
#' (asc) order. It can also be done in alphabetical order (alpha).
#' The key must be one of the numeric parameters of the matrices (e.g.
#' information.content, E-value, ...).
#' This option is convenient, for example, to sort matrices from MotifSampler
#' according to their information content:
#' sort desc MS.ic.
#' @param top Maximal number of matrices to return. Some of the input formats
#' can contain several matrices in a single file (e.g. consensus, meme,
#' MotifSampler). By default, all the matrices are parsed and exported. The
#' option `top` allows to restrict the number of matrices to be exported.
#' @param pseudo pseudo-weight used for the calculation of the weight matrix
#' (default: 1).
#' @param equi.pseudo If value is 1, the pseudo-weight is distributed in an
#' equiprobable way between residues. By default, the pseudo-weight is
#' distributed proportionally to residue priors.
#' @param base Base for the logarithms used in the scores involving a
#' log-likelihood (weight and information content). Default: exp(1) (natural
#' logarithms). A common alternative to natural logarithms is to use logarithms
#' in base 2, in which case the information content is computed in bits.
#' @param decimals Number of decimals to print for real matrices (frequencies,
#' weights, information) or to compute score distributions. Warning: for the
#' computation of score distributions, the computing time increases
#' exponentially with the number of decimals. We recommend to restrict the
#' precision to 2 decimals for the weight, this is generally more than
#' sufficient.
#' @param perm Number of permuted matrices to return. Matrix columns are
#' permuted so that the total information content remains identical to the
#' original matrix. Note that the output format for permuted matrix is tab.
#' @param max.profile Maximal width of the profile histogram (units = number of
#' characters).
#' @param rc Convert the matrix to its reverse complement if `TRUE`.
#' @return a string with results retrieved from RSAT
#' @examples
#'
#' ## Define the matrix
#' m <-
#'     '; MET4 matrix, from Gonze et al. (2005). Bioinformatics 21, 3490-500.
#' A |   7   9   0   0  16   0   1   0   0  11   6   9   6   1   8
#' C |   5   1   4  16   0  15   0   0   0   3   5   5   0   2   0
#' G |   4   4   1   0   0   0  15   0  16   0   3   0   0   2   0
#' T |   0   2  11   0   0   1   0  16   0   2   2   2  10  11   8
#' //
#' ; MET31 matrix, from Gonze et al. (2005). Bioinformatics 21, 3490-500.
#' A |   3   6   9   6  14  18  16  18   2   0   0   0   1   3   8
#' C |   8   3   3   2   3   0   1   0  13   2   0   1   0   3   6
#' G |   4   3   4   8   0   0   1   0   2   0  17   1  17  11   1
#' T |   3   6   2   2   1   0   0   0   1  16   1  16   0   1   3
#' //
#' ; PHO4 matrix, from Gonze et al. (2005). Bioinformatics 21, 3490-500.
#' A |   0   4   4   1   1  21   0   0   0   0   2   2   6   1   7
#' C |   2   7  12   6  20   0  20   0   1   0   5   5   8   4   6
#' G |   5   1   2  11   0   0   0  21   0  15   8   7   2  11   2
#' T |  14   9   3   3   0   0   1   0  20   6   6   7   5   5   6
#' '
#'
#' ## Convert the matrix
#' res <- convert_matrix(matrix = m, from = "tab", to = "consensus")
#' cat(res)
#'
#' @export

convert_matrix <- function(matrix,
    from = NULL,
    to = NULL,
    background.format = NULL,
    background.pseudo = NULL,
    return = NULL,
    sort = NULL,
    top = NULL,
    pseudo = NULL,
    equi.pseudo = NULL,
    base = NULL,
    decimals = NULL,
    perm = NULL,
    max.profile = NULL,
    rc = FALSE) {
    !missing(matrix) || stop('Matrix is missing')
    ! missing(from) ||
        stop('"from" parameter is missing. Indicate an input format')
    ! missing(to) ||
        stop('"to" parameter is missing. Indicate an output format')

    if (rc) {
        rc <- 1
    } else{
        rc <- NULL
    }


    parameters <- list(
        matrix = matrix,
        background_format = background.format,
        background_pseudo = background.pseudo,
        from = from,
        to = to,
        return = return,
        sort = sort,
        top = top,
        pseudo = pseudo,
        equi_pseudo = equi.pseudo,
        base = base,
        decimals = decimals,
        perm = perm,
        max_profile = max.profile,
        rc = rc
    )

    res <- RSAT(method = "convert_matrix",
        parameters = parameters)
    return(res)
}
