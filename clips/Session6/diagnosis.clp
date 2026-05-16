

(deftemplate patient
(slot number (type INTEGER))
(slot full-name (type STRING))
(multislot signs (type STRING)))

(deftemplate disease
(slot name(type STRING))
(multislot symptoms(type STRING)))

(deftemplate diagnosis
(slot number (type INTEGER))
(slot full-name (type STRING)) ; usually we should not add redundant info here we can get the name from the number
(slot disease (type STRING)))

(deffacts patients
(patient (number 1)(full-name "Ahmad Khan")(signs "a" "b" "c" "d"))
(patient (number 2)(full-name "John Snow")(signs "c" "d" "e" "f" "g"))
(patient (number 3)(full-name "Tareq Khan")(signs "b" "d" "e" "f" "g" "j"))
(patient (number 4)(full-name "Ehab black")(signs "a" "b" "c" "h" "i" "g"))
(patient (number 5)(full-name "Itadori Yuji")(signs "d" "e" "f" "g"))
(patient (number 6)(full-name "Rob Stark")(signs "h" "i" "g"))
(patient (number 7)(full-name "Dexter Morgan")(signs "h" "i" "g" "j" "f" "b"))
(patient (number 8)(full-name "Debra Morgan")(signs "d" "e" "f" "g")))

(deffacts diseases 
(disease (name "tumor")(symptoms "a" "b" "c"))
(disease (name "inflammation")(symptoms "d" "e" "f" "g"))
(disease (name "gallbladder")(symptoms "h" "i" "g"))
(disease (name "atrophic gastritis")(symptoms "b" "f" "j")))

; write function for contain 
; (deffunction contains (?list1 ?list2)
; )


;-------------------------
;---- Questions rules ----
;-------------------------

(deftemplate question
   (slot id (allowed-values q1 q2 q3))
   (slot question-text (type STRING))
   (slot question-type (allowed-values multi-choices patient-id)))
;----------------   
(deffacts questions
  (question (id q1)(question-text "choose 1 to view all patients
   2-to view information for specific patient
   3- to delete specific patient
   4-to exit")(question-type multi-choices))
  (question (id q2)(question-text "What is the patient id ?")(question-type patient-id))
  (question (id q3)(question-text "What is the patient id ?")(question-type patient-id))     
    )
;-----------------
(deftemplate answer
   (slot id (allowed-values q1 q2 q3))
   (slot text))

;--------

(deffunction validate-answer (?answer ?type)
"Check that the answer has the right form"
(if (eq ?type multi-choices) then
(return (or (eq ?answer 1) (eq ?answer 2)(eq ?answer 3)(eq ?answer 4)))
else (if (eq ?type patient-id) then
(return (and (integerp ?answer)(> ?answer 0))))
        )
  )
  
;----------------------------
(deffunction ask-user (?question ?type)
"Ask a question, and return the answer"
(bind ?answer "")
(while (not (validate-answer ?answer ?type)) do
(printout t ?question ":" crlf)
(bind ?answer (read)))
(return ?answer))

;-----------
; we need to retract ( and later add) the facts that lead to the same rule to be triggered
; since this is a system where you can ask the same question (you might need the same sanswe) many times	
(deffunction retract-answer
   ()
   (do-for-all-facts ((?fact answer))
      TRUE
      (retract ?fact)))
;---------------	  
(deffunction run-system
   ()
   (assert (ask q1))
   (run)
   (retract-answer))
;-----------------
(defrule ask-question-by-id  "Ask question and assert the answer"
   ; is there a question with id ?id ?
   (question (id ?id) (question-text ?text) (question-type ?type))
   ;and the trigger fact for this question exists
   ?ask <- (ask ?id)
   =>
   (bind ?answer (ask-user ?text ?type))
   (assert (answer (id ?id) (text ?answer)))
   (retract ?ask))
;------------------ rules for answers 
(defrule diagnosis-tumor
(declare (salience 5))
(logical(patient (number ?num) (full-name ?f) (signs $?signs)))
(disease (name ?n &:(eq ?n "tumor")) (symptoms $?symptoms &:(contains ?signs ?symptoms)))
=>
(assert(diagnosis (number ?num)(disease ?n) (full-name ?f))))
;--------------------
(defrule diagnosis-rule
(declare (salience 4))
(logical(patient (number ?num) (full-name ?f) (signs $?signs)))
(disease (name ?n &:(neq ?n "tumor")) (symptoms $?symptoms &:(contains ?signs ?symptoms)))
=>
(assert(diagnosis (number ?num)(disease ?n)(full-name ?f))))
;---------------------
;------------------
(defrule disease-patient
(answer (id q1)(text 1))
(diagnosis(number ?num)(disease ?name)(full-name ?f))
=>
(printout t "the patient " ?f " with id: " ?num " has the desiease: " ?name  crlf))
;------------------
;;question 2
(defrule ask-q2
 (answer (id q1)(text 2))
  =>
    (assert (ask q2))       
    )
;-----------------
;-------------------
(defrule one-patient-info
 (answer(id q2)(text ?id))
 (diagnosis(number ?id)(disease ?name) (full-name ?f))         
  =>
  (printout t "patient " ?f   "number is " ?id "disease is  "  ?name crlf)    
  )
;--------------------
;;question 3
(defrule ask-q3
 (answer (id q1)(text 3))
  =>
    (assert (ask q3))       
    )
;-------------------
(defrule delete-one-patient
 (answer(id q3)(text ?id)) 
 ?r1<-(patient(number ?id))        
  =>
  (retract ?r1)
  )
  
;-----

(defrule exit-rule
   (answer (id q1) (text 4))
   =>
   (printout t "exit ..")
   (exit))
