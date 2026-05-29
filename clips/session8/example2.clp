;===============================================================
; Session 8 - Concrete Certainty Factor Diagnosis Example
;---------------------------------------------------------------
; Evidence:
;   - Engine does not start, CF = 0.7
;   - Horn does not work, CF = 0.8
;
; Rules:
;   - If engine does not start -> battery is bad, rule CF = 0.7
;   - If horn does not work    -> battery is bad, rule CF = 0.6
;
; Final recommendation:
;   - Recommend changing battery only if CF(battery bad) > 0.7
;
; Expected numeric result:
;   from engine = 0.7 * 0.7 = 0.49
;   from horn   = 0.8 * 0.6 = 0.48
;   combined    = 0.49 + 0.48 - (0.49 * 0.48) = 0.7348
;   so recommendation should be produced.
;===============================================================

(deftemplate OAV
        (slot Object)
        (slot Attribute)
        (slot Value)
        (slot CF (type FLOAT)))

(deffacts initial-evidence
        (OAV (Object engine) (Attribute start) (Value no) (CF 0.7))
        (OAV (Object horn) (Attribute work) (Value no) (CF 0.8)))

; Rule 1: engine symptom contributes to battery-bad hypothesis.
(defrule infer-battery-from-engine
        (OAV (Object engine) (Attribute start) (Value no) (CF ?c))
        =>
        (assert (OAV (Object battery) (Attribute bad) (Value yes) (CF (* 0.7 ?c)))))

; Rule 2: horn symptom contributes to battery-bad hypothesis.
(defrule infer-battery-from-horn
        (OAV (Object horn) (Attribute work) (Value no) (CF ?c))
        =>
        (assert (OAV (Object battery) (Attribute bad) (Value yes) (CF (* 0.6 ?c)))))

; Standard certainty factor combination.
(deffunction combine-cf (?cf1 ?cf2)
        (bind ?cf 0.0)
        (if (and (> ?cf1 0.0) (> ?cf2 0.0)) then
                (bind ?cf (- (+ ?cf1 ?cf2) (* ?cf1 ?cf2)))
         else
                (if (and (< ?cf1 0.0) (< ?cf2 0.0)) then
                        (bind ?cf (+ (+ ?cf1 ?cf2) (* ?cf1 ?cf2)))
                 else
                        (bind ?cf (/ (+ ?cf1 ?cf2)
                                                                         (- 1.0 (min (abs ?cf1) (abs ?cf2)))))))
        (return ?cf))

; Combine multiple battery-bad facts into one consolidated CF.
(defrule combine-battery-cf
        ?f1 <- (OAV (Object battery) (Attribute bad) (Value yes) (CF ?cf1))
        ?f2 <- (OAV (Object battery) (Attribute bad) (Value yes) (CF ?cf2))
        (test (< (fact-index ?f1) (fact-index ?f2)))
        =>
        (retract ?f1)
        (retract ?f2)
        (assert (OAV (Object battery) (Attribute bad) (Value yes)
                                                         (CF (combine-cf ?cf1 ?cf2)))))

; Recommend only if expert certainty is strictly more than 70%.
(defrule recommend-change-battery
        (declare (salience -10))
        ?f <- (OAV (Object battery) (Attribute bad) (Value yes) (CF ?cf))
        (test (> ?cf 0.7))
        ; Guard against duplicate recommendation facts.
        (not (OAV (Object recommendation) (Attribute action) (Value change-battery) (CF ?)))
        =>
        (assert (OAV (Object recommendation) (Attribute action) (Value change-battery) (CF ?cf)))
        (printout t "Battery likely bad (CF=" ?cf "). Recommendation: change battery." crlf))