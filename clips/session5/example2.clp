(deffunction classify-score (?mark)
   "Returns a performance category based on mark"
   (if (>= ?mark 25)
      then (return "Excellent")
      else (if (>= ?mark 15)   then (return "Pass") else (return "Fail"))))


(deffunction classify-score-implicit (?mark)
   (if (>= ?mark 25)
      then "Excellent"
      else (if (>= ?mark 15)
               then "Pass"
               else "Fail")))

;; =============================================================================
;; FACT BINDING EXAMPLE: DESCRIPTIVE vs DIRECT
;; =============================================================================

(deftemplate product
   (slot id (type INTEGER))
   (slot name (type STRING))
   (slot price (type FLOAT))
   (slot stock (type INTEGER)))

(deffacts inventory
   (product (id 101) (name "Laptop")    (price 999.99) (stock 15))
   (product (id 102) (name "Mouse")     (price  25.50) (stock  3))
   (product (id 103) (name "Monitor")   (price 300.00) (stock  0)))

;---
(deftemplate student
   (slot id (type INTEGER))
   (slot name (type STRING))
   (slot mark (type NUMBER)))

(deffacts class
   (student (id 1) (name "Alice")   (mark 25))
   (student (id 2) (name "Bob")     (mark 18))
   (student (id 3) (name "Charlie") (mark 22)))

(defrule show-top-students
   =>
   (printout t "--- Students with mark >= 20 ---" crlf)
   (do-for-all-facts ((?s student))
      (if (>= ?s:mark 20) ; Inside the loop, you access slots using ?s:slotname (e.g., ?s:mark, ?s:name)
         then
         (printout t ?s:name " (ID: " ?s:id ") scored " ?s:mark crlf))))


(deffunction countdown (?start)
   (printout t "Countdown from " ?start ":" crlf)
   (bind ?counter ?start)
   (while (> ?counter 0) do
      (printout t ?counter "... " crlf)
      (bind ?counter (- ?counter 1)))
   (printout t "Blastoff!" crlf))