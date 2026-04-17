(deffacts company
  ; (manages manager employee)
  (manages Alice Bob)
  (manages Alice Carol)
  (manages Bob David)
  (manages Bob Emma)
  (manages Carol Frank)
  (manages David Grace)
  (manages Grace Emma)
)

; write clips rules for the following queries:
; Create a file called company_hierarchy_rules.clp and write the following rules in it:
; 1. Direct or indirect manager of an employee
; 2. Colleague: two employees who share the same manager
; 3. Top-level manager: a manager who does not have any manager above them
