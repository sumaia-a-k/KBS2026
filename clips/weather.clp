;; Initial facts
(deffacts initial-facts
  (moisture wet)
  (clouds dark))

;; Rule 1: If moisture is wet, then ground is wet
(defrule ground-wet
  (moisture wet)
  =>
  (assert (ground wet))
  (printout t "Rule ground-wet fired: asserted (ground wet)" crlf))

;; Rule 2: If clouds are dark and ground is wet, then it will rain
(defrule will-rain
  (clouds dark)
  (ground wet)
  =>
  (assert (rain predicted))
  (printout t "Rule will-rain fired: asserted (rain predicted)" crlf))