(deftemplate person
(slot name (type STRING))
(slot height (type NUMBER)))

(deffacts people 
(person (name "Roger") (height 185))
(person (name "Rafa") (height 187))
(person (name "Novak") (height 186))
(person (name "Richard") (height 167))
)

#We want to know the people who are taller than 170, but there are people equal or taller than them (not the tallest but taller than 170)

