(define (problem MENU)
	(:domain MENU)
	(:objects
		dilluns dimarts dimecres dijous divendres - dia
		carn peix pasta amanida sopa verdura - tipo
		peix1 pasta1 peix2 carn1 amanida1 carn2 verdura1 sopa1 pasta2 peix3 - plato
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

			(= (precio_total) 0)

			(primero peix1)
			(primero pasta1)
			(primero peix2)
			(primero carn1)
			(primero amanida1)

			(incomp carn1 carn2)
			(incomp carn1 pasta2)
			(incomp peix1 carn2)
			(incomp peix1 verdura1)
			(incomp peix2 carn2)
			(incomp peix2 sopa1)
			(incomp peix2 verdura1)
			(incomp pasta1 carn2)
			(incomp pasta1 verdura1)
			
			(es_tipo peix1 peix)
			(es_tipo pasta1 pasta)
			(es_tipo peix2 peix)
			(es_tipo carn1 carn)
			(es_tipo amanida1 amanida)
			(es_tipo carn2 carn)
			(es_tipo verdura1 verdura)
			(es_tipo sopa1 sopa)
			(es_tipo pasta2 pasta)
			(es_tipo peix3 peix)
			
			(obligacion peix1 dilluns)
			(obligacion pasta2 dimecres)
			(obligacion sopa1 dilluns)
			(obligacion carn2 dijous)
			(obligacion carn1 divendres)
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
                        ))
		))
	)

	(:metric minimize (precio_total))
)
