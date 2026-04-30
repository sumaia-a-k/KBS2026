(deffacts people
  (person "Mark")
  (person "Jamilia")
  (person "Haru")
  (person "Noah")
  (married "Noah" "Haru")
)

;Define the rule “single” which determine unmarried people 
(defrule single
  (person ?p) ;  if you put a variable inside a not before it has been given a value, CLIPS won't know what to look for.
  (not (married ?p ?))
  (not (married ? ?p))
  =>
  (assert (single ?p))
)