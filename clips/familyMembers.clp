; Family Facts and Rules for Testing CLIPS
(deffacts family 
(father Tom Nicholas) 
(father Tom Brad) 
(mother Clair Nicholas) 
(wife Leen Nicholas) 
(father Nicholas Roger)) 

; define rules
(defrule parent 
(or (father ?x ?y)(mother ?x ?y))
=>
(assert (parent ?x ?y))
)

(defrule grandparent
(and (parent ?x ?y) (parent ?y ?z))
=>
(assert (grandparent ?x ?z))
)

(defrule husband
(wife ?x ?y)=>
(assert (husband ?y ?x))
)

(defrule sibling
(and (parent ?p ?x) (parent ?p ?y) (test (neq ?x ?y)))
=>
(assert (sibling ?x ?y)))

