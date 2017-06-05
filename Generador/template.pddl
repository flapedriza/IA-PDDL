(define (problem Menu)
    (:domain MENU)
	(:objects
		dilluns dimarts dimecres dijous divendres - dia
		{0} - tipo
		{1} - plato
	)

    (:init
        (after dilluns dimarts)
        (after dimarts dimecres)
        (after dimecres dijous)
        (after dijous divendres)
        (before divendres dijous)
        (before dijous dimecres)
        (before dimecres dimarts)
        (before dimarts dilluns)

{2}

{3}

{4}
    )

    (:goal
        (forall (?d - dia)
            (and
                (primero_asignado ?d)
                (segundo_asignado ?d)
            )
		)
    )
)