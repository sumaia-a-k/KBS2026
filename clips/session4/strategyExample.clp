(deffacts my_facts
(B)
(C))

(defrule r1
(B)(D)(E)=> (assert (F))(printout t "R1 is fired" crlf))

(defrule r2
(C)(D) => (assert (A))(printout t "R2 is fired" crlf))

(defrule r3
(C)(F)=>(assert (A))(printout t "R3 is fired" crlf))

(defrule r4
(B) => (assert (X))(printout t "R4 is fired" crlf))

(defrule r5
(D) => (assert (E))(printout t "R5 is fired" crlf))

(defrule r6
(X)(A) => (assert(H))
(printout t "H is reached" crlf)
(halt))

(defrule r7
(C)
=> (assert (D))(printout t "R7 is fired" crlf))

(defrule r8
(X)
(C)
=> (assert (A))(printout t "R8 is fired" crlf))

(defrule r9
(X)
(B)
=> (assert (D))(printout t "R9 is fired" crlf))
