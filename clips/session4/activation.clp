(deftemplate my_template
   (slot slot1)
   (slot slot2))

(deffacts my_facts
    (my_template (slot1 value1) (slot2 value2))
    (my_template (slot1 value3) (slot2 value4))
    (my_template (slot1 value5) (slot2 value6))
    )

(defrule my_rule
    (my_template (slot1 ?s1) (slot2 ?s2))
    => (printout t "Rule fired with slot1: " ?s1 " and slot2: " ?s2 crlf))