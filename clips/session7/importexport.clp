; Session 7 - Import/Export example with first template in M1,
; and both templates in M2 and M3.


(defmodule MAIN
	(export deftemplate mainFact)
	(export deftemplate statusFact)
    )

(deftemplate MAIN::mainFact
	(slot goal))


(deftemplate MAIN::statusFact
	(slot goal)
	(slot state))

(deffacts MAIN::info
	(mainFact (goal A))
	(mainFact (goal B))
	(mainFact (goal C))
	(mainFact (goal E))
	(mainFact (goal F))
	(statusFact (goal C) (state ready))
	(statusFact (goal D) (state blocked))
	(statusFact (goal E) (state ready))
	(statusFact (goal F) (state ready)))

(defrule MAIN::r1
    (mainFact (goal A))
    =>
    (printout t "MAIN::r1 (mainFact)" crlf)
    )

(defmodule M1
	(import MAIN deftemplate mainFact))

(defmodule M2
	(import MAIN deftemplate mainFact)
	(import MAIN deftemplate statusFact))

(defmodule M3
	(import MAIN deftemplate mainFact)
	(import MAIN deftemplate statusFact))

(defrule M1::r1
	(mainFact (goal A))
	=>
	(printout t "M1::r1 (mainFact)" crlf)
    ; (return)
    )

(defrule M1::r2
	(mainFact (goal B))
	=>
	(printout t "M1::r2 (mainFact)" crlf)
    )

(defrule M2::r1
	(mainFact (goal C))
	(statusFact (goal C) (state ready))
	=>
	(printout t "M2::r1 (mainFact + statusFact)" crlf))

(defrule M2::r2
	(mainFact (goal D))
	(statusFact (goal D) (state blocked))
	=>
	(printout t "M2::r2 (mainFact + statusFact)" crlf))

(defrule M3::r1
	(mainFact (goal E))
	(statusFact (goal E) (state ready))
	=>
	(printout t "M3::r1 (mainFact + statusFact)" crlf))

(defrule M3::r2
	(mainFact (goal F))
	(statusFact (goal F) (state ready))
	=>
	(printout t "M3::r2 (mainFact + statusFact)" crlf))
