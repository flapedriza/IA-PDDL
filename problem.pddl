(define (problem MENU)
	(:domain MENU)
	(:objects
		dilluns dimarts dimecres dijous divendres - dia
		carn peix pasta amanida sopa verdura - tipo
		peix1 pasta1 peix2 carn1 amanida1 carn2 verdura1 sopa1 pasta2 peix3 - plato
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

			(primero peix1)
			(primero pasta1)
			(primero peix2)
			(primero carn1)
			(primero amanida1)

			(incomp carn1 carn2)
			(incomp peix2 carn2)
			(incomp peix1 carn2)
			(incomp peix1 verdura1)
			(incomp pasta1 carn2)
			(incomp pasta1 verdura1)
			(incomp peix2 sopa1)
			(incomp carn1 pasta2)
			(incomp peix2 verdura1)

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
