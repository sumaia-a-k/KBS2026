(deftemplate person
(slot name (type STRING))
(slot height (type NUMBER)))

(deffacts people 
(person (name "Roger") (height 185))
(person (name "Rafa") (height 187))
(person (name "Novak") (height 186))
(person (name "Richard") (height 167))
)

;We want to know the people who are taller than 170, but there are people equal or taller than them (not the tallest but taller than 170)


(defrule taller-than-170-but-not-tallest
(person (name ?n) (height ?h &:(> ?h 170)))
(person (name ?n2 &:(neq ?n ?n2)) (height ?h2 & : (>= ?h2 ?h)))
=>
(printout t ?n " is taller than 170 but not the tallest." crlf)
)

; method 2 with no duplication of the same person in the rule
; (defrule taller-than-170-but-not-tallest-2
; (person (name ?n) (height ?h &:(> ?h 170)))
; (exists(person (name ~?n) (height ?h2 & : (>= ?h2 ?h))))
; =>
; (printout t ?n " is taller than 170 but not the tallest. from rule 2" crlf)
; )