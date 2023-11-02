!classDefinition: #CartTest category: 'Mis Libros - Solucion'!
TestCase subclass: #CartTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Mis Libros - Solucion'!

!CartTest methodsFor: 'as yet unclassified' stamp: 'BR 10/30/2023 17:26:51'!
assertCart: aCart includes: item
	
	self assert: (aCart books includes: item).! !

!CartTest methodsFor: 'as yet unclassified' stamp: 'BR 10/30/2023 19:00:11'!
testCartCannotAddInvalidBooks
	|cart |
	
	cart := Cart createWithCatalog: (Set with: #book).
	
	self 
		should: [cart add: #invalidbook numberOfCopies: 1] 
		raise: Error withExceptionDo: 
			[:anError | 
				self assert: anError messageText equals: cart invalidItemErrorDescription. 
				self assert: cart isEmpty]  
	
! !

!CartTest methodsFor: 'as yet unclassified' stamp: 'BR 10/30/2023 18:57:59'!
testCartWithItemsContainsEveryItem
	|cart |
	
	cart := Cart createWithCatalog: (Bag with: #book1).
	cart add: #book1 numberOfCopies: 2.
	
	self assert: cart books equals: (Bag with: #book1 with: #book1).! !

!CartTest methodsFor: 'as yet unclassified' stamp: 'BR 10/30/2023 19:00:54'!
testCartWithItemsIsNotEmpty
	|cart |
	
	cart := Cart createWithCatalog: (Bag with: #book).
	cart add: #book numberOfCopies: 1.
	
	self deny: (cart isEmpty).! !

!CartTest methodsFor: 'as yet unclassified' stamp: 'BR 10/30/2023 19:03:50'!
testEmptyBookCollectionCannotBeAddedToCart
	|cart|
	
	cart := Cart createWithCatalog: (Bag with: #book).
	
	self 
		should: [cart add: #book numberOfCopies: 0] 
		raise: Error withExceptionDo: 
			[:anError | 
				self assert: anError messageText equals: cart numberOfBooksToAddMustBePositive. 
				self assert: cart isEmpty]  ! !

!CartTest methodsFor: 'as yet unclassified' stamp: 'BR 10/30/2023 18:34:15'!
testNewlyCreatedCartIsEmpty
	|cart|
	
	cart := Cart createWithCatalog: (Bag with: #book).
	
	self assert: cart isEmpty.! !


!classDefinition: #Cart category: 'Mis Libros - Solucion'!
Object subclass: #Cart
	instanceVariableNames: 'books catalog'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Mis Libros - Solucion'!

!Cart methodsFor: 'evaluating' stamp: 'BR 10/30/2023 18:30:19'!
initializeWithCatalog: aCatalog
	catalog := aCatalog.! !

!Cart methodsFor: 'evaluating' stamp: 'BR 10/30/2023 17:56:49'!
invalidItemErrorDescription
	^'Invalid items cannot be added'! !

!Cart methodsFor: 'evaluating' stamp: 'BR 10/30/2023 17:55:31'!
isEmpty
	^books isEmpty.! !

!Cart methodsFor: 'evaluating' stamp: 'BR 10/30/2023 19:02:50'!
numberOfBooksToAddMustBePositive
	^'Number of books to add to cart must be positive'! !


!Cart methodsFor: 'updating' stamp: 'BR 10/30/2023 19:02:50'!
add: aBook numberOfCopies: anAmount
	(catalog includes: aBook) ifFalse: [^self error: self invalidItemErrorDescription.].
	(anAmount = 0) ifTrue: [^self error: self numberOfBooksToAddMustBePositive ].
	books add: aBook withOccurrences: anAmount.! !

!Cart methodsFor: 'updating' stamp: 'BR 10/30/2023 17:15:26'!
books
	^books.! !

!Cart methodsFor: 'updating' stamp: 'BR 10/30/2023 18:29:10'!
initialize
	books := Bag new.
	! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cart class' category: 'Mis Libros - Solucion'!
Cart class
	instanceVariableNames: ''!

!Cart class methodsFor: 'as yet unclassified' stamp: 'BR 10/30/2023 18:29:42'!
createWithCatalog: aCatalog
	^self new initializeWithCatalog: aCatalog .! !


!classDefinition: #MisLibros category: 'Mis Libros - Solucion'!
Object subclass: #MisLibros
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Mis Libros - Solucion'!
