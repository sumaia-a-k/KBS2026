(defmodule MAIN (export ?ALL))

(deftemplate node
(slot depth(type INTEGER))
(slot fox-position (allowed-values Right Left))
(slot sheep-position (allowed-values Right Left))
(slot grass-position (allowed-values Right Left))
(slot farmer-position (allowed-values Right Left))
(slot parent (default nil))
(multislot action (default nil)))

(deffacts initial-facts
(node
(depth 0)
(fox-position Left)
(grass-position Left)
(farmer-position Left)
(sheep-position Left))
(op Right Left)
(op Left Right))

; Print path from root node to the current node using parent links.
; Notes about this function:
; 1) ?node is a fact-address (passed from goal-reached as ?state).
; 2) fact-slot-value is a CLIPS built-in function that reads one slot from
;    a fact-address: (fact-slot-value <fact-address> <slot-name>).
; 3) bind assigns the returned value to a local variable.
; 4) This is different from "?f <- (node ...)" which is rule-pattern syntax
;    on the LHS of defrule. Here we are inside deffunction, so we read slots
;    through functions, not pattern matching.
(deffunction print-solution (?node)
	; Read the parent slot from the current node. The value is either nil
	; (for the root node) or a fact-address pointing to the previous node.
	(bind ?parent (fact-slot-value ?node parent))
	(if (neq ?parent nil) then
		(print-solution ?parent))

	(bind ?depth (fact-slot-value ?node depth))
	(bind ?action (fact-slot-value ?node action))
	(if (> ?depth 0) then
		(bind ?pf (fact-slot-value ?parent farmer-position))
		(bind ?ps (fact-slot-value ?parent sheep-position))
		(bind ?px (fact-slot-value ?parent fox-position))
		(bind ?pg (fact-slot-value ?parent grass-position))

		(bind ?cf (fact-slot-value ?node farmer-position))
		(bind ?cs (fact-slot-value ?node sheep-position))
		(bind ?cx (fact-slot-value ?node fox-position))
		(bind ?cg (fact-slot-value ?node grass-position))

		(printout t "Step " ?depth ": " ?action crlf)
		(printout t "  Farmer: " ?pf " -> " ?cf
				 " | Sheep: " ?ps " -> " ?cs
				 " | Fox: " ?px " -> " ?cx
				 " | Grass: " ?pg " -> " ?cg crlf)))

(defmodule MOVEMENTS (import MAIN ?ALL))

(defrule MOVEMENTS::fox-move
?parent<-(node
(farmer-position ?fp)
(fox-position ?fp)
(depth ?depth))
(op ?fp ?op-side)
(test (neq ?fp ?op-side))
=>
(duplicate ?parent(farmer-position ?op-side)
(fox-position ?op-side)
(depth (+ ?depth 1))
(parent ?parent)
(action move fox))
)

(defrule MOVEMENTS::sheep-move
?parent<-(node
(farmer-position ?fp)
(sheep-position ?fp)
(depth ?depth))
(op ?fp ?op-side)
(test (neq ?fp ?op-side))
=>
(duplicate ?parent(farmer-position ?op-side)
(sheep-position ?op-side)
(depth (+ ?depth 1))
(parent ?parent)
(action move sheep)))

(defrule MOVEMENTS::grass-move
?parent<-
(node (farmer-position ?fp)
(grass-position ?fp)
(depth ?depth))
(op ?fp ?op-side)
(test (neq ?fp ?op-side))
=>
(duplicate ?parent(farmer-position ?op-side)
(grass-position ?op-side)
(depth (+ ?depth 1))
(parent ?parent)
(action move grass))
)

(defrule MOVEMENTS::farmer-move
?parent<-(node
(farmer-position ?fp)
(depth ?depth))
(op ?fp ?op-side)
(test (neq ?fp ?op-side))
=>
(duplicate ?parent(farmer-position ?op-side)
(parent ?parent)
(depth (+ ?depth 1))
(action move farmer)))

(defmodule CONSTRAINTS (import MAIN ?ALL))

(defrule CONSTRAINTS::fox-eat-sheep
(declare (auto-focus TRUE))
?r<-(node
(fox-position ?fp)
(sheep-position ?fp)
(farmer-position ~?fp))
=>
(retract ?r))

(defrule CONSTRAINTS::sheep-eat-grass
(declare (auto-focus TRUE))
?r<-(node (sheep-position ?fp)
(grass-position ?fp)
(farmer-position ~?fp))
=>
(retract ?r))

(defrule CONSTRAINTS::remove-duplicated-nodes
(declare (auto-focus TRUE))
(node (farmer-position ?fp)
(fox-position ?fop)
(sheep-position ?sp)
(grass-position ?gp)
(depth ?depth1))
?r<-(node (farmer-position ?fp)
(fox-position ?fop)
(sheep-position ?sp)
(grass-position ?gp)
(depth ?depth2))
(test (> ?depth2 ?depth1))
=>
(retract ?r))

(defrule CONSTRAINTS::goal-reached
(declare (auto-focus TRUE) (salience 1))
?state<-(node(farmer-position Right)
(sheep-position Right)
(fox-position Right)
(grass-position Right))
=>
(printout t crlf "Solution found:" crlf)
(print-solution ?state)
(halt))