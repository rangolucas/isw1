!classDefinition: #I category: 'Naturales'!
DenotativeObject subclass: #I
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Naturales'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'I class' category: 'Naturales'!
I class
	instanceVariableNames: 'next'!

!I class methodsFor: 'as yet unclassified' stamp: 'LR 9/3/2023 20:41:30'!
* aNaturalNumber
	^aNaturalNumber! !

!I class methodsFor: 'as yet unclassified' stamp: 'LR 9/3/2023 20:39:34'!
+ aNaturalNumber
	^aNaturalNumber next! !

!I class methodsFor: 'as yet unclassified' stamp: 'LR 9/3/2023 20:40:21'!
- aNaturalNumber
	self error: self descripcionDeErrorDeNumerosNegativosNoSoportados.! !

!I class methodsFor: 'as yet unclassified' stamp: 'LR 9/3/2023 23:40:11'!
/ aNaturalNumber
	| difference |
	difference := [(self + I - aNaturalNumber).] 
		on: Error 
		do: [self error: self descripcionDeErrorDeNoSePuedeDividirPorUnNumeroMayor].
	^[(difference - I) / aNaturalNumber + I] on: Error do: [^I]! !

!I class methodsFor: 'as yet unclassified' stamp: 'LR 9/3/2023 23:09:26'!
descripcionDeErrorDeDividirAlUno
	^'Error al intentar dividir al uno'.! !

!I class methodsFor: 'as yet unclassified' stamp: 'LR 9/3/2023 23:40:49'!
descripcionDeErrorDeNoSePuedeDividirPorUnNumeroMayor
	^'No se puede dividir por un numero mayor'! !

!I class methodsFor: 'as yet unclassified' stamp: 'LR 9/3/2023 20:41:07'!
descripcionDeErrorDeNumerosNegativosNoSoportados
	^'Numeros negativos no soportados'.! !

!I class methodsFor: 'as yet unclassified' stamp: 'LR 9/3/2023 20:34:09'!
next
	^II! !

!I class methodsFor: 'as yet unclassified' stamp: 'LR 9/3/2023 20:36:33'!
noTengoPrevio
	^'El I no tiene previo'! !

!I class methodsFor: 'as yet unclassified' stamp: 'LR 9/3/2023 20:35:22'!
previous
	self error: self noTengoPrevio.! !

!I class methodsFor: 'as yet unclassified' stamp: 'LR 9/3/2023 21:22:50'!
subtractFrom: aNaturalNumber
	^aNaturalNumber previous! !


!I class methodsFor: '--** private fileout/in **--' stamp: 'LR 9/3/2023 23:41:43'!
initializeCollaboratorsFromFile
	"Auto generated method for loading purposes - Do not modify it"

	next := nil.! !


!classDefinition: #II category: 'Naturales'!
DenotativeObject subclass: #II
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Naturales'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'II class' category: 'Naturales'!
II class
	instanceVariableNames: 'next previous'!

!II class methodsFor: 'as yet unclassified' stamp: 'LR 9/3/2023 21:06:38'!
* aNaturalNumber
	^aNaturalNumber + (self previous * aNaturalNumber)! !

!II class methodsFor: 'as yet unclassified' stamp: 'LR 9/3/2023 21:10:54'!
+ aNaturalNumber
	^self previous + aNaturalNumber next.! !

!II class methodsFor: 'as yet unclassified' stamp: 'LR 9/3/2023 21:22:02'!
- aNaturalNumber
	^aNaturalNumber subtractFrom: self! !

!II class methodsFor: 'as yet unclassified' stamp: 'LR 9/3/2023 23:35:34'!
/ aNaturalNumber
	| difference |
	difference := [(self + I - aNaturalNumber).] 
		on: Error 
		do: [self error: self descripcionDeErrorDeNoSePuedeDividirPorUnNumeroMayor].
	^[(difference - I) / aNaturalNumber + I] on: Error do: [^I]! !

!II class methodsFor: 'as yet unclassified' stamp: 'LR 9/3/2023 23:35:25'!
descripcionDeErrorDeNoSePuedeDividirPorUnNumeroMayor
	^'No se puede dividir por un numero mayor'! !

!II class methodsFor: 'as yet unclassified' stamp: 'LR 9/3/2023 21:12:25'!
next
	next ifNil: [
		next := II createChildNamed: self name,'I'.
		next previous: self.
		].
	^next.! !

!II class methodsFor: 'as yet unclassified' stamp: 'LR 9/3/2023 21:08:41'!
previous
	^previous! !

!II class methodsFor: 'as yet unclassified' stamp: 'LR 9/3/2023 21:10:15'!
previous: aNaturalNumber
	previous:=aNaturalNumber.! !

!II class methodsFor: 'as yet unclassified' stamp: 'LR 9/3/2023 21:22:29'!
subtractFrom: aNaturalNumber
	^aNaturalNumber previous - self previous.! !


!II class methodsFor: '--** private fileout/in **--' stamp: 'LR 9/3/2023 23:41:43'!
initializeCollaboratorsFromFile
	"Auto generated method for loading purposes - Do not modify it"

	next := III.
	previous := I.! !


!classDefinition: #III category: 'Naturales'!
II subclass: #III
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Naturales'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'III class' category: 'Naturales'!
III class
	instanceVariableNames: ''!

!III class methodsFor: '--** private fileout/in **--' stamp: 'LR 9/3/2023 23:41:43'!
initializeCollaboratorsFromFile
	"Auto generated method for loading purposes - Do not modify it"

	next := IIII.
	previous := II.! !


!classDefinition: #IIII category: 'Naturales'!
II subclass: #IIII
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Naturales'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'IIII class' category: 'Naturales'!
IIII class
	instanceVariableNames: ''!

!IIII class methodsFor: '--** private fileout/in **--' stamp: 'LR 9/3/2023 23:41:43'!
initializeCollaboratorsFromFile
	"Auto generated method for loading purposes - Do not modify it"

	next := IIIII.
	previous := III.! !


!classDefinition: #IIIII category: 'Naturales'!
II subclass: #IIIII
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Naturales'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'IIIII class' category: 'Naturales'!
IIIII class
	instanceVariableNames: ''!

!IIIII class methodsFor: '--** private fileout/in **--' stamp: 'LR 9/3/2023 23:41:43'!
initializeCollaboratorsFromFile
	"Auto generated method for loading purposes - Do not modify it"

	next := nil.
	previous := IIII.! !

I initializeAfterFileIn!
II initializeAfterFileIn!
III initializeAfterFileIn!
IIII initializeAfterFileIn!
IIIII initializeAfterFileIn!