(deftemplate person "person info template "
  (slot height (type NUMBER) (range 0 300))
  (slot name (type STRING))
  (slot gender (allowed-values M F f m) (default M))
)

(deffacts people
  (person (name "Mark") (height 179))
  (person (name "Rebecca")(height 160)(gender F))
  (person (name "Tai")(height 182))
  (person (name "Roger")(height 185)(gender m))
  (person (name "Maria")(height 175)(gender f))
)

; define the following rule 
; females with height over 170 are considered to be tall
(defrule tall-female
  (person (name ?n)(height ?h)(gender f | F))(test (> ?h 170))
  =>
  (assert (tall ?n))
)
; men with their height is over 180 are considered to be tall
(defrule tall-male
  (person (name ?n)(height ?h)(gender m | M))(test (> ?h 180))
  =>
  (assert (tall ?n))
)
