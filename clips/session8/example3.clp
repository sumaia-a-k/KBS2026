;===============================================================
; Session 8 - Conflict Resolution Strategy Example
;---------------------------------------------------------------
; Goal:
;   Show the difference between the CLIPS strategies:
;     - simplicity
;     - complexity
;
; Idea:
;   Both rules below have the same salience and both are activated
;   after (reset). The only important difference is rule specificity:
;
;   simple-rule  -> less specific LHS
;   complex-rule -> more specific LHS
;
; In CLIPS:
;   - simplicity: activations with LOWER specificity are preferred.
;   - complexity: activations with HIGHER specificity are preferred.
;
; So the firing order changes:
;   1) With (set-strategy simplicity)
;      simple-rule fires before complex-rule
;
;   2) With (set-strategy complexity)
;      complex-rule fires before simple-rule
;
;===============================================================

(deffacts initial-facts
	(a)
	(b))

; This rule is less specific because its LHS has fewer conditions.
(defrule simple-rule
	(a)
	=>
	(printout t "simple-rule fired" crlf))

; This rule is more specific because it requires both (a) and (b).
(defrule complex-rule
	(a)
	(b)
	=>
	(printout t "complex-rule fired" crlf))
