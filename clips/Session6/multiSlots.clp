(deftemplate  person
   (slot name)
   (multislot hobbies))

(deffacts  pepole
   (person (name "Tamer") (hobbies "reading" "playing tennis" "programming"))
   (person (name "Hisham") (hobbies "reading manga" "watching anime" "swimming"))
   (person (name "Hala") (hobbies "reading" "swimming" "dancing" "cooking")))

(defrule  count-hobbies
   (person (name ?n) (hobbies $?h))
   =>
   (printout t "count-hobbies rule fired for " ?n crlf)
   (printout t ?n " has " (length$ ?h) " hobbies." crlf)
   (printout t "------------------------------" crlf))

(defrule  get-first-hobby
   (person (name ?n) (hobbies $?h))
   =>
   (printout t "get-first-hobby rule fired for " ?n crlf)
   (printout t ?n "'s first hobby is " (nth$ 1 ?h) "." crlf)
   (printout t "------------------------------" crlf))

(defrule  check-programmer
   (person (name ?n) (hobbies $?h &:(member$ "programming" ?h)))
   =>
   (printout t "check-programmer rule fired for " ?n crlf)
   (printout t ?n " is a programmer!" crlf)
   (printout t "------------------------------" crlf))

(defrule  show-other-hobbies
   (person (name ?n) (hobbies $?h &:(> (length$ ?h) 1)))
   =>
   (printout t "show-other-hobbies rule fired for " ?n crlf)
   (printout t ?n "'s other hobbies: " (rest$ ?h) crlf)
   (printout t "------------------------------" crlf))

;; FUNCTION RETURNING A MULTIFIELD
(deffunction  build-summary-list (?name ?hobbies-mf)
   (return (create$ ?name (length$ ?hobbies-mf) "summary")))

;; first$ exists, but last$ DOES NOT. Use nth$ + length$ instead.
(defrule  first-and-last-hobby
   (person (name ?n) (hobbies $?h))
   =>
   (printout t "first-and-last-hobby rule fired for " ?n crlf)
   (printout t ?n "'s first hobby: " (first$ ?h) crlf)
   (printout t ?n "'s last hobby:  " (nth$ (length$ ?h) ?h) crlf crlf)
   (printout t "------------------------------" crlf))

(defrule  slice-hobbies
   (person (name ?n) (hobbies $?h))
   (test (>= (length$ ?h) 3))
   =>
   (printout t "slice-hobbies rule fired for " ?n crlf)
   (printout t ?n "'s hobbies 2-3: " (subseq$ ?h 2 3) crlf)
   (printout t "Original: " ?h crlf crlf)
   (printout t "------------------------------" crlf))

(defrule  change-hobbies-list
   (person (name "Tamer") (hobbies $?h))
   =>
   (printout t "change-hobbies-list rule fired for Tamer" crlf)
   (bind ?replaced (replace$ ?h 3 3 "coding"))
   (printout t "replace$ (third to be coding): " ?replaced crlf)

   (bind ?deleted (delete$ ?replaced 2 2))
   (printout t "delete$ (remove 2):   " ?deleted crlf)

   (bind ?inserted (insert$ ?deleted 2 "hiking"))
   (printout t "insert$ (add at 2):   " ?inserted crlf crlf)
   
   (printout t "Original hobbies: " ?h crlf crlf)
   (printout t "------------------------------" crlf))

;; Type predicates do NOT end with $
(defrule  validate-and-print-list
   (person (name ?n) (hobbies $?h))
   =>
   (printout t "validate-and-print-list rule fired for " ?n crlf)
   (bind ?result-list (build-summary-list ?n ?h))
   (printout t ?n " summary list: " ?result-list crlf)
   (printout t "Is it a multifield? " (multifieldp ?result-list) crlf crlf)
   (printout t "------------------------------" crlf))