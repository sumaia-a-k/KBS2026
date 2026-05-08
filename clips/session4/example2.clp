(deftemplate employee
   (slot id)
   (slot name)
   (slot dept)
   (slot role)
   (slot skill))


(deffacts employees
   (employee (id "E1") (name "Alice") (dept "IT") (role "developer") (skill 8))
   (employee (id "E2") (name "Bob")   (dept "IT") (role "manager")   (skill 7))
   (employee (id "E3") (name "Carol") (dept "HR") (role "recruiter") (skill 6))
   (employee (id "E4") (name "Dave")  (dept "IT") (role "analyst")   (skill 3))
   (employee (id "E5") (name "Eve")   (dept "HR") (role "manager")   (skill 9))
   (employee (id "E6") (name "Frank") (dept "IT") (role "developer") (skill 2))
   (employee (id "E7") (name "Grace") (dept "IT") (role "manager")   (skill 3))
   (employee (id "E8") (name "Heidi") (dept "IT") (role "analyst")   (skill 4))
   (employee (id "E9") (name "Ivan")  (dept "HR") (role "recruiter") (skill 2))
   (employee (id "E10") (name "Judy") (dept "HR") (role "manager")   (skill 4))
   (employee (id "E11") (name "Ken")  (dept "IT") (role "developer") (skill 3))
   (employee (id "E12") (name "Lia")  (dept "IT") (role "manager")   (skill 2))
   (employee (id "E13") (name "Mia")  (dept "IT") (role "analyst")   (skill 7))
   (employee (id "E14") (name "Noah") (dept "HR") (role "recruiter") (skill 3))
   (employee (id "E15") (name "Omar") (dept "HR") (role "manager")   (skill 8))
   (employee (id "E16") (name "Pia")  (dept "IT") (role "developer") (skill 4))
   (employee (id "E17") (name "Quin") (dept "IT") (role "manager")   (skill 9))
   (employee (id "E18") (name "Ria")  (dept "IT") (role "analyst")   (skill 3))
   (employee (id "E19") (name "Sam")  (dept "HR") (role "recruiter") (skill 7))
   (employee (id "E20") (name "Tia")  (dept "HR") (role "manager")   (skill 2)))


(defrule find-team-alpha
   (employee (id ?id1) (name ?name1) (dept ?dept) (role ?role1) (skill ?skill1 &:(>= ?skill1 5)))
   (employee (id ?id2&~?id1) (name ?name2) (dept ?dept) (role ?role2&~?role1) (skill ?skill2 &:(>= ?skill2 5)))
   =>
   (printout t "Team1: " ?name1 " + " ?name2 
             " (Dept: " ?dept ")" crlf))

(defrule find-team-test
   (employee (id ?id1) (name ?name1) (dept ?dept) (role ?role1) (skill ?skill1))
   (employee (id ?id2) (name ?name2) (dept ?dept) (role ?role2) (skill ?skill2))
   (test (>= ?skill1 5))
   (test (>= ?skill2 5))
   (test (neq ?id1 ?id2))
   (test (neq ?role1 ?role2))
   =>
   (printout t "Team2: " ?name1 " + " ?name2 
             " (Dept: " ?dept ")" crlf))

;(id ?id2&~?id1), (dept ?dept), and (role ?role2&~?role1)  are evaluated during the Beta join phase, 