(deftemplate employee
   (slot id (type INTEGER))
   (slot name (type STRING))
   (slot dept (type STRING))
   (slot salary (type FLOAT)))

(deffacts staff
   (employee (id 1) (name "Alice")   (dept "IT")    (salary 60000.0))
   (employee (id 2) (name "Bob")     (dept "HR")    (salary 45000.0))
   (employee (id 3) (name "Charlie") (dept "IT")    (salary 70000.0))
   (employee (id 4) (name "Diana")   (dept "Sales") (salary 40000.0))
   (employee (id 5) (name "Eve")     (dept "IT")    (salary 48000.0))) ; IT, but under 50k

(defrule show-it-high-earners
   =>
   (printout t "--- IT Employees with Salary > 50000 ---" crlf)
   (do-for-all-facts ((?e employee))
      (and (eq ?e:dept "IT") (> ?e:salary 50000.0)) ; FILTER CONDITION
      (printout t "ID: " ?e:id " | Name: " ?e:name " | Salary: $" ?e:salary crlf))
   (printout t "--- End of List ---" crlf))


;-------------------------example with no template---------------------------------
(deffacts values
   (value 10)
   (value 11))

; This will iterate over both ordered facts
(defrule show-values
   =>
   (printout t "--- Values in the system ---" crlf)
   (do-for-all-facts ((?v value))
      (printout t "Found value: " ?v crlf)))