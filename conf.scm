(define flite-voice "rms")
(define flite (sprintf "flite -t \"~A\" -voice ~A" "~A" flite-voice))

(define espeak "espeak \"~A\"")

(define festival "festival \"~A\"")

(define selected-command espeak)

