;===============================================================
; Session 8 - Uncertainty / Certainty Factor (CF) Example
;---------------------------------------------------------------
; Initial evidence (fact, CF):
;   A with CF 0.4 "Based on the evidence we currently have, we are 40% certain that fact A is true."
;   B with CF 0.6 "Based on the evidence we currently have, we are 60% certain that fact B is true."
;   D with CF 0.8 "Based on the evidence we currently have, we are 80% certain that fact D is true."
;   F with CF -0.3 "Based on the evidence we currently have, we are 30% certain that fact F is false."
;
; Rules:
;   r1: A & B => C with rule CF 0.5 "If both A and B are true, we have 50% confidence that C is true."
;   r2: D => C with rule CF 0.4  "If D is true, we have 40% confidence that C is true."
;   r3: F => C with rule CF 0.3  "If F is true, we have 30% confidence that C is true."
;    (Note: F has initial CF -0.3, meaning it is currently believed false,
;
; This file also demonstrates combining multiple CF values for C.
;===============================================================

(deffacts myfacts
	(A 0.4)
	(B 0.6)
	(D 0.8)
	(F -0.3))

; r1: A & B => C, CF = min(CF(A), CF(B)) * 0.5
(defrule r1
	(and (A ?cf1) (B ?cf2))
	=>
	(bind ?cf (min ?cf1 ?cf2))
	(assert (C (* ?cf 0.5))))

; r2: D => C, CF = CF(D) * 0.4
(defrule r2
	(D ?cf)
	=>
	(assert (C (* ?cf 0.4))))

; r3: F => C, CF = CF(F) * 0.3
(defrule r3
	(F ?cf)
	=>
	(assert (C (* ?cf 0.3))))

; Combine two certainty factors using standard CF formulas:
; 1) both positive: cf = cf1 + cf2 - (cf1 * cf2) : cf1 + cf2 * (1-cf1) 
; 2) both negative: cf = cf1 + cf2 + (cf1 * cf2) : cf1 + cf2 * (1+cf1)
; 3) opposite signs:
;      cf = (cf1 + cf2) / (1 - min(|cf1|, |cf2|))
(deffunction combine-cf (?cf1 ?cf2)
	(bind ?cf 0.0)
	(if (and (> ?cf1 0.0) (> ?cf2 0.0)) then
		(bind ?cf (- (+ ?cf1 ?cf2) (* ?cf1 ?cf2)))
	 else
		(if (and (< ?cf1 0.0) (< ?cf2 0.0)) then
			(bind ?cf (+ (+ ?cf1 ?cf2) (* ?cf1 ?cf2)))
		 else
			(bind ?cf
						(/ (+ ?cf1 ?cf2)
							 (- 1.0 (min (abs ?cf1) (abs ?cf2)))))))
	(return ?cf))

; r4: repeatedly combine multiple C facts into one consolidated C fact.
; fact-index ordering prevents symmetric re-matching of the same pair.
(defrule r4
	?f1 <- (C ?cf1)
	?f2 <- (C ?cf2)
	(test (< (fact-index ?f1) (fact-index ?f2)))
	=>
	(retract ?f1)
	(retract ?f2)
	(assert (C (combine-cf ?cf1 ?cf2))))

