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
	instanceVariableNames: 'emptyCatalog creditCard merchantProcessor'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!


!CashierTest methodsFor: 'as yet unclassified' stamp: 'BR 11/6/2023 00:23:15'!
setUp
	emptyCatalog := Dictionary new.
	creditCard := CreditCard createWithId: '1234567890123456'  expirationMonthOfYear: (GregorianMonthOfYear year: 2023 monthNumber: 11) ownedBy: 'Ricardo Fort'.
	merchantProcessor := MerchantProcessorMock createWith: (OrderedCollection with: creditCard).
	! !

!CashierTest methodsFor: 'as yet unclassified' stamp: 'BR 11/6/2023 00:04:45'!
test01CannotCheckoutEmptyCart
	| cashier emptyCart |
	emptyCart := Cart acceptingItemsOf: Dictionary new.
	cashier := Cashier initializeFor: emptyCart withCard: creditCard andMerchantProcessor: MerchantProcessorMock new.
	self
		should: [ 
			cashier checkout
		]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :error |
			self assert: error messageText equals: cashier cannotCheckoutEmptyCartErrorDescription.
			self assert: cashier chargedAmount equals: 0 * dollar
		]! !

!CashierTest methodsFor: 'as yet unclassified' stamp: 'BR 11/6/2023 00:11:16'!
test02CanCheckoutCartWithOneBook
	| cashier cartToCheckout catalog |
	catalog := Dictionary with: (#SherlockHolmes->(50 * dollar)).
	cartToCheckout := Cart acceptingItemsOf: catalog.
	cartToCheckout add: #SherlockHolmes withOcurrences: 1.
	cashier := Cashier initializeFor: cartToCheckout withCard: creditCard andMerchantProcessor: merchantProcessor.
	
	cashier checkout.
	
	self assert: cashier chargedAmount equals: 50 * dollar ! !

!CashierTest methodsFor: 'as yet unclassified' stamp: 'BR 11/6/2023 00:55:23'!
test03CanCheckoutCartWithManyBooks
	| cashier cartToCheckout catalog |
	catalog := Dictionary with: #SherlockHolmes->(50 * dollar) with: #MobyDick->(30 * dollar).
	cartToCheckout := Cart acceptingItemsOf: catalog.
	cartToCheckout add: #SherlockHolmes withOcurrences: 2.
	cartToCheckout add: #MobyDick withOcurrences: 1.
	cashier := Cashier initializeFor: cartToCheckout withCard: creditCard andMerchantProcessor: merchantProcessor.
	
	cashier checkout.
	
	self assert: cashier chargedAmount equals: 130 * dollar ! !

!CashierTest methodsFor: 'as yet unclassified' stamp: 'BR 11/6/2023 00:11:41'!
test04CartIsEmptyAfterCheckout
	| cashier cartToCheckout catalog |
	catalog := Dictionary with: #SherlockHolmes->(50 * dollar) with: #MobyDick->(30 * dollar).
	cartToCheckout := Cart acceptingItemsOf: catalog.
	cartToCheckout add: #SherlockHolmes withOcurrences: 2.
	cartToCheckout add: #MobyDick withOcurrences: 1.
	cashier := Cashier initializeFor: cartToCheckout withCard: creditCard andMerchantProcessor: merchantProcessor.
	
	cashier checkout.
	
	self assert: cartToCheckout isEmpty.! !

!CashierTest methodsFor: 'as yet unclassified' stamp: 'BR 11/6/2023 01:35:27'!
test05CannotCheckoutWhenMerchantProcessorRejects
	| cashier cartToCheckout catalog failingMerchantProcessor|
	catalog := Dictionary with: #SherlockHolmes->(50 * dollar).
	cartToCheckout := Cart acceptingItemsOf: catalog.
	cartToCheckout add: #SherlockHolmes withOcurrences: 1.
	failingMerchantProcessor := MerchantProcessorMock new.
	failingMerchantProcessor failWithAllCards.
	cashier := Cashier initializeFor: cartToCheckout withCard: creditCard andMerchantProcessor: failingMerchantProcessor.
	
	self
		should: [
			cashier checkout.
		]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :error |
			self assert: error messageText equals: failingMerchantProcessor checkoutCouldNotBeProcessedErrorDescription.
			self assert: cashier chargedAmount equals: 0 * dollar
		]	
	! !

!CashierTest methodsFor: 'as yet unclassified' stamp: 'BR 11/6/2023 01:28:05'!
test06CannotCheckoutCashierWithExpiredCC
	| cashier cartToCheckout catalog today|
	catalog := Dictionary with: #SherlockHolmes->(50 * dollar).
	cartToCheckout := Cart acceptingItemsOf: catalog.
	cartToCheckout add: #SherlockHolmes withOcurrences: 1.
	today := Date newDay: 12 month: #July year: 2025.
	cashier := Cashier initializeFor: cartToCheckout withCard: creditCard andMerchantProcessor: merchantProcessor.
	
	self
		should: [
			cashier checkoutOnDate: today.
		]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :error |
			self assert: error messageText equals: cashier expiredCreditCardErrorDescription .
			self assert: cashier chargedAmount equals: 0 * dollar
		]	
	! !

!CashierTest methodsFor: 'as yet unclassified' stamp: 'BR 11/6/2023 01:37:00'!
test07CanDebitAfterSuccessfulCheckout
	| cashier cartToCheckout catalog today|
	catalog := Dictionary with: #SherlockHolmes->(50 * dollar).
	cartToCheckout := Cart acceptingItemsOf: catalog.
	cartToCheckout add: #SherlockHolmes withOcurrences: 1.
	today := Date newDay: 12 month: #July year: 1999.
	cashier := Cashier initializeFor: cartToCheckout withCard: creditCard andMerchantProcessor: merchantProcessor.
	cashier checkoutOnDate: today.
	
	self assert: cashier chargedAmount equals: 50 * dollar.
	! !


!classDefinition: #CreditCardTest category: 'TusLibros'!
TestCase subclass: #CreditCardTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CreditCardTest methodsFor: 'as yet unclassified' stamp: 'BR 11/6/2023 01:49:47'!
test01CannotInitializeCardWithEmptyId

	
	self should: [
		CreditCard createWithId: ''  expirationMonthOfYear: (GregorianMonthOfYear year: 2023 monthNumber: 11) ownedBy: 'Ricardo Fort'.
		]
	raise:
		Error - MessageNotUnderstood 
	withExceptionDo:
		[:error | self assert: error messageText equals: (CreditCard invalidIdErrorMessage).]! !

!CreditCardTest methodsFor: 'as yet unclassified' stamp: 'BR 11/6/2023 01:50:46'!
test02CannotInitializeCardWithIdOfLengthDifferentThan16

	
	self should: [
		CreditCard createWithId: '5739'  expirationMonthOfYear: (GregorianMonthOfYear year: 2023 monthNumber: 11) ownedBy: 'Ricardo Fort'.
		]
	raise:
		Error - MessageNotUnderstood 
	withExceptionDo:
		[:error | self assert: error messageText equals: (CreditCard invalidIdErrorMessage).]! !

!CreditCardTest methodsFor: 'as yet unclassified' stamp: 'BR 11/6/2023 01:51:23'!
test03CannotInitializeCardWithIdOfNotIntegerChars

	
	self should: [
		CreditCard createWithId: '5739aast'  expirationMonthOfYear: (GregorianMonthOfYear year: 2023 monthNumber: 11) ownedBy: 'Ricardo Fort'.
		]
	raise:
		Error - MessageNotUnderstood 
	withExceptionDo:
		[:error | self assert: error messageText equals: (CreditCard invalidIdErrorMessage).]! !

!CreditCardTest methodsFor: 'as yet unclassified' stamp: 'BR 11/6/2023 01:53:07'!
test04CanCreateCardWithValidId
	
	CreditCard createWithId: '1234567890123456'  expirationMonthOfYear: (GregorianMonthOfYear year: 2023 monthNumber: 11) ownedBy: 'Ricardo Fort'.
		
	! !

!CreditCardTest methodsFor: 'as yet unclassified' stamp: 'BR 11/6/2023 01:59:35'!
test05CannotCreateCardWithInvalidOwnerName
	
	self should: [
		CreditCard createWithId: '1234567890123456'  expirationMonthOfYear: (GregorianMonthOfYear year: 2023 monthNumber: 11) ownedBy: 'Ricardo Fort El Matador Killer Max 2023'.
		]
	raise:
		Error - MessageNotUnderstood 
	withExceptionDo:
		[:error | self assert: error messageText equals: (CreditCard invalidOwnerNameErrorMessage ).]! !


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

!Cart methodsFor: 'adding' stamp: 'BR 11/5/2023 23:26:00'!
checkoutWith: aCashier
	| cartValue |
	  
	items isEmpty ifTrue: [
		self error: aCashier cannotCheckoutEmptyCartErrorDescription 
	].

	cartValue := items sum: [:item | catalog at: item] ifEmpty: 0.
	aCashier doOrderProcessingFor: cartValue.
	items := OrderedCollection new.

	^cartValue! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cart class' category: 'TusLibros'!
Cart class
	instanceVariableNames: ''!

!Cart class methodsFor: 'instance creation' stamp: 'HernanWilkinson 6/17/2013 17:48'!
acceptingItemsOf: aCatalog

	^self new initializeAcceptingItemsOf: aCatalog ! !


!classDefinition: #Cashier category: 'TusLibros'!
Object subclass: #Cashier
	instanceVariableNames: 'catalog cart chargedAmount creditCard merchantProcessor'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Cashier methodsFor: 'evaluating' stamp: 'BR 11/6/2023 01:10:33'!
assertCardIsNotExpiredAsOf: today
	(self cardIsNotExpiredAsOf: today) ifFalse: [^self error: self expiredCreditCardErrorDescription].
	
! !

!Cashier methodsFor: 'evaluating' stamp: 'BR 11/6/2023 01:07:37'!
cardIsNotExpiredAsOf: today
	^creditCard isValidAsOf: today.
! !

!Cashier methodsFor: 'evaluating' stamp: 'BR 11/5/2023 22:57:39'!
chargedAmount
	^chargedAmount! !

!Cashier methodsFor: 'evaluating' stamp: 'BR 11/5/2023 22:57:27'!
checkout
	|checkoutTotalValue|
	
	checkoutTotalValue := cart checkoutWith: self.	
	chargedAmount := chargedAmount + checkoutTotalValue.
! !

!Cashier methodsFor: 'evaluating' stamp: 'BR 11/6/2023 01:10:52'!
checkoutOnDate: today
	|checkoutTotalValue|
	self assertCardIsNotExpiredAsOf: today.
	
	checkoutTotalValue := cart checkoutWith: self.
	chargedAmount := chargedAmount + checkoutTotalValue.
! !

!Cashier methodsFor: 'evaluating' stamp: 'BR 11/5/2023 23:26:52'!
doOrderProcessingFor: anAmount
	merchantProcessor debit: anAmount from: creditCard .! !

!Cashier methodsFor: 'evaluating' stamp: 'BR 11/6/2023 01:08:36'!
expiredCreditCardErrorDescription
	^'Credit card is expired.'
! !


!Cashier methodsFor: 'error messages' stamp: 'BR 11/5/2023 23:20:35'!
cannotCheckoutCashierWithUnregisteredCreditCardErrorDescription
	^'Cannot checkout due to unregistered credit card'.! !

!Cashier methodsFor: 'error messages' stamp: 'LR 11/2/2023 18:41:26'!
cannotCheckoutEmptyCartErrorDescription
	^'Cannot checkout empty cart'.! !


!Cashier methodsFor: 'initialization' stamp: 'BR 11/5/2023 22:58:07'!
withCart: aCart
	cart := aCart.
	chargedAmount := 0 * dollar! !

!Cashier methodsFor: 'initialization' stamp: 'BR 11/5/2023 22:58:13'!
withCart: aCart withCard: aCreditCard andMerchantProcessor: aMerchantProcessor
	cart := aCart.
	creditCard := aCreditCard.
	merchantProcessor := aMerchantProcessor.
	chargedAmount := 0 * dollar! !



"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cashier class' category: 'TusLibros'!
Cashier class
	instanceVariableNames: ''!

!Cashier class methodsFor: 'instance creation' stamp: 'LR 11/2/2023 21:50:57'!
initializeFor: cartToInitializeWith
	^self new withCart: cartToInitializeWith ! !

!Cashier class methodsFor: 'instance creation' stamp: 'BR 11/5/2023 22:50:01'!
initializeFor: cartToCheckout withCard: creditCard andMerchantProcessor: merchantProcessor
	^self new withCart: cartToCheckout withCard: creditCard andMerchantProcessor: merchantProcessor.! !


!classDefinition: #CreditCard category: 'TusLibros'!
Object subclass: #CreditCard
	instanceVariableNames: 'id owner expirationMonthOfYear'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!


!CreditCard methodsFor: 'as yet unclassified' stamp: 'BR 11/6/2023 01:49:40'!
assertIsValidId: anId.

	^((anId size = 16) and: [self idOnlyContainsNumbers: anId]) ifFalse: [^self error: self class invalidIdErrorMessage ].
! !

!CreditCard methodsFor: 'as yet unclassified' stamp: 'BR 11/6/2023 01:57:55'!
assertIsValidOwnerName: aName.

	^(aName size > 30) ifTrue: [^self error: self class invalidOwnerNameErrorMessage ].
! !

!CreditCard methodsFor: 'as yet unclassified' stamp: 'BR 11/6/2023 00:21:42'!
idOnlyContainsNumbers: anId

	^anId allSatisfy: [:elm | #($0 $1 $2 $3 $4 $5 $6 $7 $8 $9)  includes: elm].! !

!CreditCard methodsFor: 'as yet unclassified' stamp: 'BR 11/6/2023 01:59:12'!
initializeWith: anId expirationMonthOfYear: monthOfYear ownedBy: anOwner
	self assertIsValidId: anId.
	self assertIsValidOwnerName: anOwner.

	id := anId.
	expirationMonthOfYear := monthOfYear.
	owner := anOwner.! !

!CreditCard methodsFor: 'as yet unclassified' stamp: 'BR 11/6/2023 01:23:41'!
isValidAsOf: aDate
	^(GregorianMonthOfYear year: (aDate yearNumber) monthNumber: (aDate monthIndex)) < expirationMonthOfYear! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CreditCard class' category: 'TusLibros'!
CreditCard class
	instanceVariableNames: ''!

!CreditCard class methodsFor: 'as yet unclassified' stamp: 'BR 11/6/2023 00:17:17'!
createWithId: anId  expirationMonthOfYear: monthOfYear ownedBy: owner
	^self new initializeWith: anId expirationMonthOfYear: monthOfYear ownedBy: owner. ! !

!CreditCard class methodsFor: 'as yet unclassified' stamp: 'BR 11/6/2023 01:48:53'!
invalidIdErrorMessage
	
	^'Invalid id provided for credit card'! !

!CreditCard class methodsFor: 'as yet unclassified' stamp: 'BR 11/6/2023 01:58:47'!
invalidOwnerNameErrorMessage 
	^'Owner name must be of length at most 30'.
! !


!classDefinition: #MerchantProcessorMock category: 'TusLibros'!
Object subclass: #MerchantProcessorMock
	instanceVariableNames: 'acceptedCreditCards'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!


!MerchantProcessorMock methodsFor: 'as yet unclassified' stamp: 'BR 11/6/2023 00:57:09'!
checkoutCouldNotBeProcessedErrorDescription
	^'Cannot process checkout'.! !

!MerchantProcessorMock methodsFor: 'as yet unclassified' stamp: 'BR 11/6/2023 00:58:52'!
debit: anAmount from: aCreditCard
	(acceptedCreditCards includes: aCreditCard) ifFalse: 
		[
			^self error: self checkoutCouldNotBeProcessedErrorDescription.
		].
	
	! !

!MerchantProcessorMock methodsFor: 'as yet unclassified' stamp: 'BR 11/6/2023 00:45:31'!
failWithAllCards
	acceptedCreditCards := OrderedCollection new.! !

!MerchantProcessorMock methodsFor: 'as yet unclassified' stamp: 'BR 11/5/2023 23:41:08'!
initialize
	acceptedCreditCards := OrderedCollection new.! !

!MerchantProcessorMock methodsFor: 'as yet unclassified' stamp: 'BR 11/5/2023 23:40:47'!
initializeWith: creditCards
	acceptedCreditCards := creditCards.! !

!MerchantProcessorMock methodsFor: 'as yet unclassified' stamp: 'BR 11/6/2023 00:09:44'!
registerCreditCard: aCreditCard
	acceptedCreditCards add: aCreditCard.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MerchantProcessorMock class' category: 'TusLibros'!
MerchantProcessorMock class
	instanceVariableNames: ''!

!MerchantProcessorMock class methodsFor: 'nil' stamp: 'BR 11/5/2023 23:40:26'!
createWith: creditCards
	^self new initializeWith: creditCards.
	! !

