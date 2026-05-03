(deffacts family
(husband "sam" "Jamilia")
(husband "Mark" "Petre"))

(defrule wife 
(logical (husband ?h ?w))
=>
(assert (wife ?w ?h)))
