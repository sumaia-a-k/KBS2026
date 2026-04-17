(deftemplate employee
    (slot name )
    (slot manager)
)

(deffacts employees
    (employee (name Alice) (manager nil))
    (employee (name Bob) (manager Alice))
    (employee (name Carol) (manager Alice))
    (employee (name David) (manager Bob))
    (employee (name Emma) (manager Bob))
    (employee (name Frank) (manager Carol))
    (employee (name Grace) (manager David))
)