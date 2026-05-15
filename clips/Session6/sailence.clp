(deffacts letter
(A)
(B)
(C)
(D))

 (defrule AB
(A)(B)=>(assert (AB)))

(defrule AC
(A)(C)=>(assert (AC)))

(defrule CD
(C)(D)=>(assert (CD)))

(defrule BCD
(B)(CD)=>(assert (BCD)))


; (deffacts letter
; (A)
; (B)
; (C)
; (D))


; (defrule AB
; (declare (salience 3))
; (A)(B)=>(assert (AB)))


; (defrule AC
; (A)(C)=>(assert (AC)))

; (defrule CD
; (C)(D)=>(assert (CD)))

; (defrule BCD
; (B)(CD)=>(assert (BCD)))