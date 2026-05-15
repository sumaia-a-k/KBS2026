
;In Knowledge base system subject the mark is:
;- 30 for the practical exam 
;- 70 for the final exam (theoretical exam )
;
;the student cannot apply for the final exam if:
;- they didn't achieve at least 12 out of 30 in the practical exam 
;- they didn't attended at least 6 out of 11 practical sessions 
;
;1- Define a templated for the student contains:
;- student name (String)
;- student id (integer > 0)
;- student mark (number between 0 and 30)
;- student attendance (integer between 0 and 11)
;
;2- add student facts
; 
;3-we will define a system which shows some options
;- option one: when we enter number 1,it will shows all students with (allowed or not allowed)
;- option two: when we enter number 2, it will ask us to enter the student id and then it will show us the state of this student
;- option three: when we enter number 3, it will ask us to enter the student id and then it will modify the student's mark to be 12  
;- option four: when we enter number 4, it will exit the system
;
;in this program , first thing the user will have all options displayed and the user can select which option they want to do 
;


; -----------------------------------------------------------------------------
; TEMPLATE: student
; PURPOSE:
;   Represents one student record in the knowledge base.
; SLOTS:
;   - name   : Student full name as a STRING.
;   - mark   : Practical exam mark in range [0..30].
;   - attend : Number of attended practical sessions in range [0..11].
;   - id     : Unique positive student identifier.
; BUSINESS RULE REFERENCE:
;   A student is allowed to apply for the final exam only if:
;   mark >= 12 AND attend >= 6.
; EXAMPLE FACT:
;   (student (id 2123) (name "Ali mohamad") (mark 25) (attend 11))
; -----------------------------------------------------------------------------
(deftemplate student
   (slot name (type STRING))
   (slot mark (type NUMBER) (range 0 30))
   (slot attend (type INTEGER) (range 0 11))
   (slot id (type INTEGER) (range 0 ?VARIABLE))) ; ?VARIABLE: The maximum value is positive infinity (+∞positive infinity+∞), meaning there is no upper bound on the integer value


; -----------------------------------------------------------------------------
; FACTS: students
; -----------------------------------------------------------------------------
(deffacts students
  (student (id 2123) (name "Ali mohamad") (mark 25) (attend 11))
  (student (id 2121) (name "Samer Ali") (mark 22) (attend 10))
  (student (id 2129) (name "Rana Yacoub") (mark 29) (attend 11))
  (student (id 2103) (name "Leen Abed") (mark 21) (attend 9))
  (student (id 2111) (name "Nancy Awad") (mark 21) (attend 8))
  (student (id 2178) (name "Amena Razk") (mark 17) (attend 4))
  (student (id 2153) (name "Fedaa Saood") (mark 10) (attend 11))
  (student (id 2198) (name "Khaled zaher") (mark 10) (attend 4)))


; -----------------------------------------------------------------------------
; TEMPLATE: question
; PURPOSE:
;   Defines question metadata used by the interactive menu engine.
; SLOTS:
;   - id            : Question key (q1, q2, q3).
;   - question-text : Prompt shown to the user.
;   - question-type : Validation type expected for the answer.
; -----------------------------------------------------------------------------
(deftemplate question
   (slot id (allowed-values q1 q2 q3))
   (slot question-text (type STRING))
   (slot question-type (allowed-values multi-choices uni-id)))


; -----------------------------------------------------------------------------
; TEMPLATE: answer
; PURPOSE:
;   Stores user responses as facts so rules can match them declaratively.
; SLOTS:
;   - id   : Question key that this answer belongs to.
;   - text : The actual user input value.
; -----------------------------------------------------------------------------
(deftemplate answer
   (slot id (allowed-values q1 q2 q3))
   (slot text))


; -----------------------------------------------------------------------------
; FACTS: questions
; PURPOSE:
;   Predefined interactive prompts used by ask-question-by-id.
; FLOW:
;   q1 -> main menu choice
;   q2 -> student id for single-student display
;   q3 -> student id for mark correction
; -----------------------------------------------------------------------------
(deffacts questions
   (question (id q1) (question-text "Choose 1 to display all students, 2 for one student, 3 to modify a student's degree, and 4 to exit") (question-type multi-choices))
   (question (id q2) (question-text "enter the student id that you want to display") (question-type uni-id))
   (question (id q3) (question-text "enter the student id that you want to modify") (question-type uni-id)))

; -----------------------------------------------------------------------------
; FUNCTION: validate-answer
; PURPOSE:
;   Validates user input according to a question type.
; PARAMETERS:
;   ?answer : User-entered value.
;   ?type   : Expected answer type (multi-choices or uni-id).
; RETURNS:
;   TRUE if valid, FALSE otherwise.
; VALIDATION LOGIC:
;   - multi-choices: accepts only 1, 2, 3, 4.
;   - uni-id       : accepts positive integers only.
; EXAMPLES:
;   (validate-answer 1 multi-choices)  => TRUE
;   (validate-answer 9 multi-choices)  => FALSE
;   (validate-answer 2123 uni-id)      => TRUE
;   (validate-answer "abc" uni-id)     => FALSE
; -----------------------------------------------------------------------------
(deffunction validate-answer
   (?answer ?type)
   "Check if the answer matches on of the question's valid answers"
   (if (eq ?type multi-choices)
      then
      (return (or (eq ?answer 1) (eq ?answer 2) (eq ?answer 3) (eq ?answer 4)))
      else
      (if (eq ?type uni-id)
         then
         (return (and (integerp ?answer) (> ?answer 0))))))

; -----------------------------------------------------------------------------
; FUNCTION: ask-user
; PURPOSE:
;   Displays a question, reads input, and keeps asking until the answer is valid.
; PARAMETERS:
;   ?question : Prompt text to display.
;   ?type     : Validation mode passed to validate-answer.
; WHAT (read) DOES:
;   `read` is a CLIPS built-in input function that waits for user input from
;   the console and returns the entered token/value.
;   - If user enters a number like 2, `read` returns a numeric value.
;   - If user enters text/symbol, it returns that token form.
; WHY IT IS USED HERE:
;   The loop captures each user attempt, then validate-answer checks whether
;   this input matches the expected question type.
; RETURNS:
;   The first valid answer entered by the user.
; EXAMPLE:
;   (ask-user "Choose option" multi-choices)
;   If user enters 7 then 2, the function returns 2.
; -----------------------------------------------------------------------------
(deffunction ask-user
   (?question ?type)
   "Ask a question, and check the answer if correct return it, if not re-ask the question"
   (bind ?answer "")
   (while (not (validate-answer ?answer ?type)) do
      (printout t ?question ":" crlf)
      ; read waits for the user's keyboard input and returns the typed value.
      (bind ?answer (read)))
   (return ?answer))


; -----------------------------------------------------------------------------
; FUNCTION: retract-answer
; PURPOSE:
;   Clears all existing answer facts from working memory.
; WHY IT MATTERS:
;   Prevents stale inputs from blocking or duplicating future interactions.
;   This enables re-triggering the same question-driven rules multiple times.
; in other words:
; Since we are going to ask more than one  for the same information (for example 
; asking for all students many times, and  because of the second fact we mentioned in 
; the first slide , we need to retract answers and then add them later to re-activate the rules
; EXAMPLE EFFECT:
;   Before: (answer (id q1) (text 1)), (answer (id q2) (text 2123))
;   After : no answer facts remain.
; -----------------------------------------------------------------------------
(deffunction retract-answer
   ()
   (do-for-all-facts ((?fact answer)); Loop through all facts of type 'answer'
      TRUE ; Apply to every matching fact (no condition filtering)
      (retract ?fact)))

; define the rule that will fire the question	  
; -----------------------------------------------------------------------------
; RULE: ask-question-by-id
; PURPOSE:
;   Generic rule that asks a question when an (ask <question-id>) fact appears.
; TRIGGERS WHEN:
;   - A question definition exists for ?id.
;   - An (ask ?id) control fact is asserted.
; ACTIONS:
;   1) Calls ask-user to collect validated input.
;   2) Asserts (answer (id ?id) (text <value>)).
;   3) Retracts the triggering ask fact.
; EXAMPLE:
;   If (ask q1) exists, user is shown menu prompt and answer q1 is asserted.
; -----------------------------------------------------------------------------
(defrule ask-question-by-id "Ask question and assert the answer"
   ; both lines are conditions, and they also perform binding:
   (question (id ?id) (question-text ?text) (question-type ?type))
   ?ask <- (ask ?id)
   =>
   (bind ?answer (ask-user ?text ?type))
   (assert (answer (id ?id) (text ?answer)))
   (retract ?ask))

; The rule to end the execution 
; -----------------------------------------------------------------------------
; RULE: exit-rule
; PURPOSE:
;   Stops the program when the user chooses option 4 in the main menu.
; TRIGGERS WHEN:
;   (answer (id q1) (text 4)) is present.
; ACTIONS:
;   Prints exit message and terminates CLIPS execution.
; -----------------------------------------------------------------------------
(defrule exit-rule
   (answer (id q1) (text 4))
   =>
   (printout t "exit ..")
   (exit))


; Display the name of students that are allowed to apply for the final exam
; -----------------------------------------------------------------------------
; RULE: allowed
; PURPOSE:
;   Lists students who satisfy final-exam eligibility constraints.
; TRIGGERS WHEN:
;   User chooses option 1 (display all statuses).
; CONDITIONS:
;   - mark >= 12
;   - attend >= 6
; OUTPUT:
;   Prints that the student can apply for the final exam.
; EXAMPLE:
;   (mark 25, attend 11) => allowed
; -----------------------------------------------------------------------------
 (defrule allowed
   (answer (id q1) (text 1))
   (student (id ?id) (name ?n) (mark ?m&:(>= ?m 12)) (attend ?a&:(>= ?a 6)))
   =>
   (printout t  ?id " - " ?n " is allowed to apply for the final exam " crlf))
 
 ; not allowed students to apply for the final exam
 ; -----------------------------------------------------------------------------
 ; RULE: not-allowed
 ; PURPOSE:
 ;   Lists students who fail at least one eligibility condition.
 ; TRIGGERS WHEN:
 ;   User chooses option 1 (display all statuses).
 ; CONDITIONS:
 ;   Student mark < 12 OR attendance < 6.
 ; OUTPUT:
 ;   Prints that the student is not allowed to apply.
 ; EXAMPLES:
 ;   (mark 10, attend 11) => not allowed (insufficient mark)
 ;   (mark 17, attend 4)  => not allowed (insufficient attendance)
 ; -----------------------------------------------------------------------------
 (defrule not-allowed
   (answer (id q1) (text 1))  ; Condition 1: There must be an answer with id q1 and text 1
   (student (id ?id) (name ?n) (mark ?m) (attend ?a)) ; Condition 2: Matches any student fact
   (test (or (< ?m 12)  ; Condition 3: Either mark is less than 12
             (< ?a 6))); OR attendance is less than 6
   =>
   (printout t ?id " - " ?n  " is NOT allowed to apply for the final exam " crlf))

; -----------------------------------------------------------------------------
; RULE: ask-for-one
; PURPOSE:
;   Routes menu option 2 to the follow-up question that asks for a student id.
; TRIGGERS WHEN:
;   (answer (id q1) (text 2)) is asserted.
; ACTION:
;   Asserts (ask q2), which activates ask-question-by-id for q2.
; -----------------------------------------------------------------------------
(defrule ask-for-one-student-info
   (answer (id q1) (text 2))
   =>
   (assert (ask q2)))


; -----------------------------------------------------------------------------
; RULE: one-student-info
; PURPOSE:
;   Displays complete information for one student selected by id.
; TRIGGERS WHEN:
;   An answer for q2 is available and a matching student exists.
; OUTPUT:
;   Prints id, name, mark, and attendance.
; EXAMPLE:
;   If q2 = 2123 and student exists, prints the student's details.
; -----------------------------------------------------------------------------
(defrule one-student-info
   (answer (id q2) (text ?number))
   (student (id ?number) (name ?n) (mark ?m) (attend ?a))
   =>
  (printout t ?number " - " ?n " mark is " ?m " attendance is " ?a  crlf))
  
  
; -----------------------------------------------------------------------------
; RULE: ask-for-modify
; PURPOSE:
;   Routes menu option 3 to the follow-up question that asks for student id.
; TRIGGERS WHEN:
;   (answer (id q1) (text 3)) is asserted.
; ACTION:
;   Asserts (ask q3), which activates ask-question-by-id for q3.
; -----------------------------------------------------------------------------
  (defrule ask-for-modify-student-mark
   (answer (id q1) (text 3))
   =>
   (assert (ask q3)))

; -----------------------------------------------------------------------------
; RULE: modify-student-info
; PURPOSE:
;   Corrects the practical mark to 12 for a selected student when mark is below 12.
; TRIGGERS WHEN:
;   - User provided id in q3.
;   - Matching student fact exists.
;   - Current mark is less than 12.
; ACTION:
;   Modifies student fact by setting (mark 12).
; EXAMPLE:
;   (student (id 2153) (mark 10) ...) becomes (mark 12).
; -----------------------------------------------------------------------------
(defrule modify-student-info
   (answer (id q3) (text ?number))
   ?f <- (student (id ?number) (name ?n) (mark ?m) (attend ?a))
   (test (< ?m 12))
   =>
   (modify ?f (mark 12)))


; -----------------------------------------------------------------------------
; RULE: student-not-found
; PURPOSE:
;   Handles invalid q2 id values when no matching student exists.
; TRIGGERS WHEN:
;   q2 is answered with ?number AND there is no student with that id.
; OUTPUT:
;   Prints a clear "student was not found" message.
; -----------------------------------------------------------------------------
(defrule student-not-found
   (answer (id q2 ) (text ?number))
   (not (student (id ?number)))
   =>
   (printout t "student was not found" crlf))

; student task : for modify if the number if not found we need to print student was not found



