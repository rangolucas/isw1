!classDefinition: #CartTest category: 'TusLibros'!
TestCase subclass: #CartTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 17:08'!
test01NewCartsAreCreatedEmpty

	self assert: self createCart isEmpty! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 17:45'!
test02CanNotAddItemsThatDoNotBelongToStore

	| cart |
	
	cart := self createCart.
	
	self 
		should: [ cart add: self itemNotSellByTheStore ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = cart invalidItemErrorMessage.
			self assert: cart isEmpty ]! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 17:43'!
test03AfterAddingAnItemTheCartIsNotEmptyAnymore

	| cart |
	
	cart := self createCart.
	
	cart add: self itemSellByTheStore.
	self deny: cart isEmpty ! !

!CartTest methodsFor: 'tests' stamp: 'HAW 11/2/2023 17:12:35'!
test04CanNotAddNonPositiveNumberOfItems

	| cart |
	
	cart := self createCart.
	
	self 
		should: [cart add: self itemSellByTheStore withOcurrences: 0  ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = cart invalidQuantityErrorMessage.
			self assert: cart isEmpty ]! !

!CartTest methodsFor: 'tests' stamp: 'HAW 11/2/2023 17:12:46'!
test05CanNotAddMoreThanOneItemNotSellByTheStore

	| cart |
	
	cart := self createCart.
	
	self 
		should: [cart add:  self itemNotSellByTheStore withOcurrences: 2  ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = cart invalidItemErrorMessage.
			self assert: cart isEmpty ]! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 17:43'!
test06CartRemembersAddedItems

	| cart |
	
	cart := self createCart.
	
	cart add: self itemSellByTheStore.
	self assert: (cart includes: self itemSellByTheStore)! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 17:43'!
test07CartDoesNotHoldNotAddedItems

	| cart |
	
	cart := self createCart.
	
	self deny: (cart includes: self itemSellByTheStore)! !

!CartTest methodsFor: 'tests' stamp: 'HAW 11/2/2023 17:12:59'!
test08CartRemembersTheNumberOfAddedItems

	| cart |
	
	cart := self createCart.
	
	cart add: self itemSellByTheStore withOcurrences: 2.
	self assert: (cart occurrencesOf: self itemSellByTheStore) = 2! !


!CartTest methodsFor: 'support' stamp: 'HernanWilkinson 6/17/2013 17:48'!
createCart
	
	^Cart acceptingItemsOf: self defaultCatalog! !

!CartTest methodsFor: 'support' stamp: 'LR 11/2/2023 21:28:25'!
defaultCatalog
	
	^ Dictionary with: self itemSellByTheStore -> 10! !

!CartTest methodsFor: 'support' stamp: 'HernanWilkinson 6/17/2013 17:44'!
itemNotSellByTheStore
	
	^'invalidBook'! !

!CartTest methodsFor: 'support' stamp: 'HernanWilkinson 6/17/2013 17:43'!
itemSellByTheStore
	
	^ 'validBook'! !


!classDefinition: #CashierTest category: 'TusLibros'!
TestCase subclass: #CashierTest
	instanceVariableNames: 'emptyCatalog'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CashierTest methodsFor: 'as yet unclassified' stamp: 'LR 11/2/2023 19:04:30'!
setUp
	emptyCatalog := Dictionary new.! !

!CashierTest methodsFor: 'as yet unclassified' stamp: 'LR 11/2/2023 21:53:36'!
test01CannotCheckoutEmptyCart
	| cashier emptyCart |
	emptyCart := Cart acceptingItemsOf: Dictionary new.
	cashier := Cashier initializeFor: emptyCart.
	self
		should: [ 
			cashier checkout
		]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :error |
			self assert: error messageText equals: cashier cannotCheckoutEmptyCartErrorDescription.
			self assert: cashier chargedSoFar equals: 0 * dollar
		]! !

!CashierTest methodsFor: 'as yet unclassified' stamp: 'LR 11/2/2023 21:53:36'!
test02CanCheckoutCartWithOneBook
	| cashier cartToCheckout catalog |
	catalog := Dictionary with: (#SherlockHolmes->(50 * dollar)).
	cartToCheckout := Cart acceptingItemsOf: catalog.
	cartToCheckout add: #SherlockHolmes withOcurrences: 1.
	cashier := Cashier initializeFor: cartToCheckout.
	
	cashier checkout.
	
	self assert: cashier chargedSoFar equals: 50 * dollar ! !

!CashierTest methodsFor: 'as yet unclassified' stamp: 'LR 11/2/2023 21:53:36'!
test03CanCheckoutCartWithTwoBooks
	| cashier cartToCheckout catalog |
	catalog := Dictionary with: #SherlockHolmes->(50 * dollar) with: #MobyDick->(30 * dollar).
	cartToCheckout := Cart acceptingItemsOf: catalog.
	cartToCheckout add: #SherlockHolmes withOcurrences: 2.
	cartToCheckout add: #MobyDick withOcurrences: 1.
	cashier := Cashier initializeFor: cartToCheckout.
	
	cashier checkout.
	
	self assert: cashier chargedSoFar equals: 130 * dollar ! !


!classDefinition: #Cart category: 'TusLibros'!
Object subclass: #Cart
	instanceVariableNames: 'catalog items mmmm'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Cart methodsFor: 'error messages' stamp: 'HernanWilkinson 6/17/2013 17:45'!
invalidItemErrorMessage
	
	^'Item is not in catalog'! !

!Cart methodsFor: 'error messages' stamp: 'HernanWilkinson 6/17/2013 17:45'!
invalidQuantityErrorMessage
	
	^'Invalid number of items'! !


!Cart methodsFor: 'assertions' stamp: 'LR 11/2/2023 21:27:36'!
assertIsValidItem: anItem

	(catalog includesKey: anItem) ifFalse: [ self error: self invalidItemErrorMessage ]! !

!Cart methodsFor: 'assertions' stamp: 'HernanWilkinson 6/17/2013 17:51'!
assertIsValidQuantity: aQuantity

	aQuantity strictlyPositive ifFalse: [ self error: self invalidQuantityErrorMessage ]! !


!Cart methodsFor: 'initialization' stamp: 'LR 11/2/2023 19:40:30'!
initializeAcceptingItemsOf: aCatalog

	catalog := aCatalog.
	items := OrderedCollection new.! !


!Cart methodsFor: 'queries' stamp: 'LR 11/2/2023 21:37:17'!
itemsValue
	^items sum: [ :item | catalog at: item ] ifEmpty: 0! !

!Cart methodsFor: 'queries' stamp: 'LR 11/2/2023 19:40:30'!
occurrencesOf: anItem

	^items occurrencesOf: anItem  ! !


!Cart methodsFor: 'testing' stamp: 'LR 11/2/2023 19:40:30'!
includes: anItem

	^items includes: anItem ! !

!Cart methodsFor: 'testing' stamp: 'LR 11/2/2023 19:40:30'!
isEmpty
	
	^items isEmpty ! !


!Cart methodsFor: 'adding' stamp: 'HAW 11/2/2023 17:13:30'!
add: anItem

	^ self add: anItem withOcurrences: 1 ! !

!Cart methodsFor: 'adding' stamp: 'LR 11/2/2023 19:41:02'!
add: anItem withOcurrences: aQuantity

	self assertIsValidQuantity: aQuantity.
	self assertIsValidItem: anItem.

	items add: anItem withOccurrences: aQuantity .
	! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cart class' category: 'TusLibros'!
Cart class
	instanceVariableNames: ''!

!Cart class methodsFor: 'instance creation' stamp: 'HernanWilkinson 6/17/2013 17:48'!
acceptingItemsOf: aCatalog

	^self new initializeAcceptingItemsOf: aCatalog ! !


!classDefinition: #Cashier category: 'TusLibros'!
Object subclass: #Cashier
	instanceVariableNames: 'catalog cart chargedSoFar'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Cashier methodsFor: 'evaluating' stamp: 'LR 11/2/2023 21:53:36'!
chargedSoFar
	^0 * dollar! !

!Cashier methodsFor: 'evaluating' stamp: 'LR 11/2/2023 21:54:40'!
checkout
	| cartValue |
	cart isEmpty ifTrue: [
		self error: self cannotCheckoutEmptyCartErrorDescription 
	].
	cartValue := cart itemsValue.
	chargedSoFar := chargedSoFar + cartValue.
	^cartValue! !


!Cashier methodsFor: 'error messages' stamp: 'LR 11/2/2023 18:41:26'!
cannotCheckoutEmptyCartErrorDescription
	^'Cannot checkout empty cart'.! !


!Cashier methodsFor: 'initialization' stamp: 'LR 11/2/2023 21:53:27'!
withCart: aCart
	cart := aCart.
	chargedSoFar := 0 * dollar! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cashier class' category: 'TusLibros'!
Cashier class
	instanceVariableNames: ''!

!Cashier class methodsFor: 'instance creation' stamp: 'LR 11/2/2023 21:50:57'!
initializeFor: cartToInitializeWith
	^self new withCart: cartToInitializeWith ! !
