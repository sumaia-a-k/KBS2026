(deffacts community
  (person "frieren")
  (person "fern")
  (person "stark")
  (person "heiter") 
  (person "aura")
  (age "frieren" 1000)
  (age "fern" 17)
  (age "stark" 18)
  (age "heiter" 35)  
  (age "aura" 3)    
  (school "fern")
  (school "stark") 
)

; (defrule goodCommunity
;   (forall (person ?x) (age ?x ?a&:(and (>= ?a 6) (<= ?a 32)))
;           (school ?x)) => (printout t "good community" crlf))

(defrule goodCommunity
  (forall (age ?x ?a&:(and (>= ?a 6) (<= ?a 32))) (person ?x) 
          (school ?x)) => (printout t "good community" crlf))