#' @title Matrix scan.
#' @description Scan sequences with one or several position-specific scoring
#' matrices (PSSM)
#' to identify instances of the corresponding motifs (putative sites).
#' This function supports a variety of background models (Bernoulli, Markov
#' chains of any order).
#' @author José Alquicira Hernández
#' @param sequence Sequence(s) to scan - all the formats supported in RSAT can
#' be used as input (default: `fasta`)
#' @param matrix Matrix/ces to scan with. The matrix format is specified with
#' the option `matrix.format` (see below) Default format: `tab`.
#' @param sequence.format Supported fields:
#' \itemize{
#' \item `fasta` (default)
#' \item `IG` (Intelligenetics)
#' \item `WC` (wconsensus)
#' \item `raw`
#' }
#' @param matrix.format Supported fields:
#' \itemize{
#' \item `tab` (default)
#' \item `cb`
#' \item `consensus`
#' \item `gibbs`
#' \item `meme`
#' \item `assembly`
#' }
#' @param quick Delegates scanning to the C program matrix-scan-quick
#' (developed by Matthieu Defrance). Evaluate if the quick mode is compatible
#' with the selected output parameters, otherwise, run in the slower mode.
#' Incompatible with - CRER scanning - window background model.
#' @param n.treatment Treatment of N characters. These characters are often
#' used in DNA sequences to represent undefined or masked nucleotides.
#' \itemize{
#' \item `skip`.  N-containing regions are skipped.
#' \item `score`. N-containing regions are scored. The probability of an N is 1
#' for both the background model and the matrix. The N residues will thus
#' contribute neither positively nor negatively to the weight score of the
#' N-containing fragment. This option can be useful to detect sites which are
#' at the border of N-containing regions, or in cases there are isolated N in
#' the sequences.
#' }
#' @param consensus.name Use the motif (degenerate) consensus as matrix name.
#' @param pseudo Pseudo-count for the matrix (default: 1). The pseudo-count
#' reflects the possibility that residues that were not (yet) observed in the
#' model might however be valid for future observations. The pseudo-count is
#' used to compute the corrected residue frequencies.
#' @param equi.pseudo If this option is called,  the pseudo-weight is
#' distributed in an equiprobable way between residues. By default, the
#' pseudo-weight is distributed proportionally to residue priors, except for
#' the -window option where equipseudo is default.
#' @param top.matrices Only scan with the top # matrices per matrix file. This
#' option is valid for some file formats containing multiple matrices where top
#' matrices are generally more informative.
#' @param background.model Background model is a tab-delimited specification of
#' oligonucleotide frequencies.
#' @param organism To use a precalculated background model from RSAT, choose
#' the organism corresponding to the background model. Works with background
#' and markov options.
#' @param background To use a precalculated background model from RSAT. Works
#' with organism and markov options. Type of sequences used as background model
#' for estimating expected oligonucleotide frequencies.
#' Supported:
#' \itemize{
#' \item `upstream`
#' \item `upstream-noorf`
#' \item `upstream-noorf-rm`
#' \item `intergenic`
#' }
#' @param background.input Calculate background model from the input sequence
#' set. This option requires to specify the order of the background model with
#' the option markov.
#' @param background.window Size of the sliding window for the background model
#' calculation. This option requires to specify the order of the background
#' model with the option markov (suitable for short order model only markov 0
#' or 1)
#' @param markov Order of the markov chain for the background model. This
#' option is incompatible with the option background.
#' @param background.pseudo Pseudo frequency for the background models. Value
#' must be a real between 0 and 1.
#' If this option is not specified,  the pseudo-frequency value depends on the
#' background calculation.
#' For `background.input` and `background_window`,  the pseudo frequency is
#' automatically calculated with the length (L) of the sequence following this
#' formula:
#' square-root of L divided by L+squareroot of L.
#' For `background.model`,  default value is 0.01.
#' If the training sequence length (L) is known,  the value can be set by
#' `background.pseudo` option to square-root of L divided by L+squareroot of L.
#' @param return.fields List of fields to return.
#' Supported fields:
#' \itemize{
#' \item `sites`
#' \item `rank`
#' \item `limits`
#' \item `normw`
#' \item `bg_model`
#' \item `matrix`
#' \item `freq_matrix`
#' \item `weight_matrix`
#' \item `distrib`
#' }
#' @param sort.distrib Sort score distribution by decreasing value of
#' significance, if value TRUE. By default, the score distributions are sorted
#' by score (weight).
#' @param lth Lower threshold on some parameter. Format=list of
#' 'parameter value'.
#' Supported fields:
#' \itemize{
#' \item `score`
#' \item `pval`
#' \item `eval`
#' \item `sig`
#' \item `normw`
#' \item `proba_M`
#' \item `proba_B`
#' \item `rank`
#' \item `crer_sites`
#' \item `crer_size`
#' \item `occ`
#' \item `occ_sum`
#' \item `inv_cum`
#' \item `exp_occ`
#' \item `occ_pval`
#' \item `occ_eval`
#' \item `occ_sig`
#' \item `occ_sig_rank`
#' }
#' @param uth Upper threshold on some parameter. Format=list of 'param value'.
#' Supported parameters: same as `lth`.
#' @param str Scan 1 or 2 strands for DNA sequences.
#' @param origin Define the origin for the calculation of positions.
#' `origin` -0 defines the end of each sequence as the origin.
#' The matching positions are then negative values, providing the distance
#' between the match and the end of the sequence.
#' @param decimals Number of decimals displayed for the weight score.
#' @param crer.ids Assign one separate feature ID per CRER. This option is
#' convenient to distinguish separate CRERs.
#' @return an R object with results retrieved from RSAT
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
#' ## This is incomplete:
# \dontrun{
#     matrix_scan(
#         sequence = "TCGCAATCTACTTACTATTGCTTACTATTGCTTACTATTGCGAGCGCAGA",
#         matrix = m,
#         n.treatment = 'score',
#         background.model = 'something???')
# }
#'
#' @export

matrix_scan <-
    function(sequence,
        matrix,
        sequence.format = "fasta",
        matrix.format = "tab",
        quick = FALSE,
        n.treatment = NULL,
        concensus.name = NULL,
        pseudo = 1,
        equi.pseudo = FALSE,
        top.matrices = NULL,
        background.model = NULL,
        background = NULL,
        background.input = NULL,
        background.window = NULL,
        markov = NULL,
        background.pseudo = NULL,
        return.fields = NULL,
        sort.distrib = FALSE,
        lth = NULL,
        uth = NULL,
        str = NULL,
        origin = NULL,
        decimals = NULL,
        crer.ids = NULL,
        organism = NULL) {
        !missing(sequence) ||
            stop('"sequence" parameter is missing. Indicate an input format')
        ! missing(matrix) || stop('Matrix is missing')
        ! missing(n.treatment) ||
            stop('"n.treatment" parameter is missing. Must be "score" or "skip"')

        if (quick) {
            quick <- 1
        } else{
            quick <- NULL
        }
        if (equi.pseudo) {
            quick <- 1
        } else{
            equi.pseudo <- NULL
        }
        if (sort.distrib) {
            sort.distrib <- 1
        } else{
            sort.distrib <- NULL
        }


        ## Should 'organism' be used here?
        parameters <- list(
            sequence = sequence,
            matrix = matrix,
            sequence_format = sequence.format,
            matrix_format = matrix.format,
            quick = quick,
            n_treatment = n.treatment,
            concensus_name = concensus.name,
            pseudo = pseudo,
            equi_pseudo = equi.pseudo,
            top_matrices = top.matrices,
            background_model = background.model,
            background = background,
            background_input = background.input,
            background_window = background.window,
            markov = markov,
            background_pseudo = background.pseudo,
            return_fields = return.fields,
            sort_distrib = sort.distrib,
            lth = lth,
            uth = uth,
            str = str,
            origin = origin,
            decimals = decimals,
            crer_ids = crer.ids
        )

        res <- RSAT(method = "matrix_scan",
            parameters = parameters)
        return(res)
    }
