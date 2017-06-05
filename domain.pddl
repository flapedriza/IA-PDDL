(define (domain MENU)
	(:requirements :strips :typing :adl :equality)

	(:types plato dia tipo - object)
	(:predicates

		(primero ?p - plato) 				;; ?p es un primero
		(es_tipo ?p - plato ?t - tipo) 		;; ?p es de tipo ?t
		(incomp ?p1 - plato ?p2 - plato) 	;; ?p1 (primero) es incompatible con ?p2
		(plato_usado ?p - plato) 			;; ?p plato usado
		(after ?d1 - dia ?d2 - dia) 		;; ?d2 va despues de ?d1 (after d1 comes d2, d1 - d2)
		(before ?d2 - dia ?d1 - dia) 		;; ?d1 va antes de d2 (before d2 is d1, // potser treure //)
		;; // inmutables //

		(primero_asignado ?d - dia)   ;; ?d tiene asignado un primero
		(segundo_asignado ?d - dia)   ;; ?d tiene asignado un segundo
		(primero_asignado_en ?p - plato ?d - dia) 	;; ?p es primero del ?d
		(segundo_asignado_en ?p - plato ?d - dia) 	;; ?p es segundo del ?d

	)


	;; asigna primer plato a un dia
	(:action asignar_primero
		:parameters (?p - plato ?d - dia)
		:precondition
		(and
			(primero ?p) 	;; ?p debe ser un primero

      ;;(not (plato_usado ?p))  ;; ?p no debe haber sido ya usado esa semana

			(not (primero_asignado ?d))

			(not
        (exists (?p2 - plato)
  				(and
  					(segundo_asignado_en ?p2 ?d)
  					(incomp ?p ?p2)
  				)
			  )
      )

			(not
        (exists (?d2 - dia)
  				(and
  					(or (after ?d ?d2) (before ?d2 ?d))
  					(exists (?p2 - plato)
  						(and
  							(primero_asignado_en ?p2 ?d2)

  							(exists (?t - tipo)
  								(and
  									(es_tipo ?p ?t)
  									(es_tipo ?p2 ?t)
  								)
  							)

  						)
  					)
  				)
			  )
      )
		)
		:effect
		(and
			(primero_asignado ?d)
			(primero_asignado_en ?p ?d)
			(plato_usado ?p)
		)
	)

	;; asigna segundo plato a un dia
	(:action asignar_segundo
		:parameters (?p - plato ?d - dia)
		:precondition
		(and
			(not (primero ?p)) 	;; ?p NO debe ser un primero (sino segundo)
      ;;(not (plato_usado ?p))  ;; ?p no debe haber sido ya usado esa semana
			(not (segundo_asignado ?d))
			(not (exists (?p2 - plato)
				(and
					(primero_asignado_en ?p2 ?d)
					(incomp ?p2 ?p)
				)
			))
			(not (exists
				(?d2 - dia)
				(and
					(or (after ?d ?d2) (before ?d2 ?d))
					(exists
						(?p2 - plato)
						(and
							(segundo_asignado_en ?p2 ?d2)
							(exists
								(?t - tipo)
								(and
									(es_tipo ?p ?t)
									(es_tipo ?p2 ?t)
								)
							)
						)
					)
				)
			))
		)
		:effect
		(and
			(segundo_asignado ?d)
			(segundo_asignado_en ?p ?d)
			(plato_usado ?p)
		)
	)
)
