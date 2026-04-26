(deffunction triangle-area (?base ?height)
    (if (and (> ?base 0) (> ?height 0)) then
        (* 0.5 ?base ?height)
    else
        (printout t "Base and height must be positive numbers." crlf)
    )
)