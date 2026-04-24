(deffunction triangle-area (?base ?height)
(if (and (numberp ?base) (numberp ?height) (> ?base 0) (> ?height 0)) then 
(bind ?area (* 0.5 ?base ?height))
(printout t "Area =" ?area crlf)
else    (printout t "Base and height must be positive numbers." crlf)
))