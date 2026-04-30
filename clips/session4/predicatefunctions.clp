(deftemplate sensor
 (slot id)
 (slot value))

(deffacts initial-sensors
 (sensor (id 1) (value 95))
 (sensor (id 2) (value 105))
 (sensor (id 3) (value 90)))

(defrule high-temp-alert
   (sensor (id ?id) (value ?v &:(> ?v 100)))
   =>
   (printout t "ALERT: Sensor " ?id " exceeds 100°C" crlf))


(deftemplate person
 (slot name)
 (slot age))

(deffacts initial-people
 (person (name "Alice") (age 30))
 (person (name "Bob") (age 17))
 (person (name "Charlie") (age 70)))

(defrule valid-age-range
   (person (name ?n) (age ?a &:(>= ?a 18) &:(<= ?a 65)))
   =>
   (printout t "Person " ?n " is within the valid age range." crlf))