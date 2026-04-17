(deffacts gender
(male Tom)
(female Clair)
(female Miriam)
(female Leen)
(female Amira)
(male John)
(male Mark)
(female Luna)
(male Nichols))

(deffacts family
(parent Tom Nicholas)
(parent Clair Nicholas)
(parent Amira Miriam)
(parent Amira Leen)
(parent Mark Clair)
(parent Tom John)
(parent Nicholas Luna)
)

;define rule for father 
(defrule father
(and (parent ?x ?y) (male ?x))
=> (assert (father ?x ?y)))

;define rule for mother
(defrule mother
(and (parent ?x ?y)(female ?x))
=> (assert (mother ?x ?y)))

;define rule for grandparent
(defrule grandparent
(parent ?x ?y) (parent ?y ?z)
=> (assert (grandparent ?x ?z)))

;define rule for grandFather
(defrule grandFather
(grandparent ?x ?y)(male ?x)
=> (assert(grandfather ?x ?y)))
