
; define the template of the student fact
(deftemplate student
    (slot name (type STRING))
    (slot degree (type INTEGER) (default 0))
    (slot status (allowed-values  M G)(default G)))
    
; define the facts of students' results 
(deffacts results
    (student (name "Ali") (degree 88) (status M))
    (student (name "Nagham") (degree 48) (status M))
    (student (name "Batoul") (degree 62))
    (student (name "Asaad")(degree 50))
)


; rule for master enrollment    
(defrule master-enrollment
(student (name ?n)(degree ?d)(status M))
(test (>= ?d 60))
=>
    (printout t ?n " is eligible for master enrollment." crlf))

; rule for passing the test
(defrule pass-test
(student (name ?n)(degree ?d))
(test (>= ?d 50  ))
=>
    (printout t ?n " has passed the test." crlf))

; rule for passing 48+2
(defrule pass-test-48
(student (name ?n)(degree ?d))
(test (>= ?d 48))
(test (< ?d 50))
=>
    (printout t ?n " has passed the 48+2 test." crlf))

