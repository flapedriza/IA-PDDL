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

{2}

{3}

{4}
    )

    (:goal
		(forall (?d - dia)
		(and
			(primero_asignado ?d)
			(segundo_asignado ?d)
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
                        ))
		))
    )
)
