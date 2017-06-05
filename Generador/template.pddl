(define (problem Menu)
    (:domain MENU)
	(:objects
		dilluns dimarts dimecres dijous divendres - dia
		{0} - tipo
		{1} - plato
	)

    (:init
        (adj dilluns dimarts)
        (adj dimarts dimecres)
        (adj dimecres dijous)
        (adj dijous divendres)

		(= (calorias_dia dilluns) 0)
		(= (calorias_dia dimarts) 0)
		(= (calorias_dia dimecres) 0)
		(= (calorias_dia dijous) 0)
		(= (calorias_dia divendres) 0)

{2}

		(= (precio_total) 0)

{3}

{4}

{5}

{6}

{7}
    )

    (:goal
		(forall (?d - dia)
			(and
				(primero_asignado ?d)
				(segundo_asignado ?d)
				(<= (calorias_dia ?d) 1500)
				(>= (calorias_dia ?d) 1000)
				(forall (?p - plato)
					(or
						(and
							(obligacion ?p ?d)
							(or
								(primero_asignado_en ?p ?d)
								(segundo_asignado_en ?p ?d)
							)
						)
						(not (obligacion ?p ?d))
					)
				)
			)
		)
    )

	(:metric minimize (precio_total))
)
