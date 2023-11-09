!classDefinition: #CartTest category: 'TusLibros'!
TestCase subclass: #CartTest
	instanceVariableNames: 'testObjectsFactory'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:10'!
test01NewCartsAreCreatedEmpty

	self assert: testObjectsFactory createCart isEmpty! !

!CartTest methodsFor: 'tests' stamp: 'BR 11/8/2023 14:16:05'!
test02CanNotAddItemsThatDoNotBelongToStore

	| cart |
	
	cart := testObjectsFactory createCart.
	
	self 
		should: [ cart add: testObjectsFactory itemNotSoldByTheStore ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = Cart invalidItemErrorMessage.
			self assert: cart isEmpty ]! !

!CartTest methodsFor: 'tests' stamp: 'BR 11/8/2023 14:16:34'!
test03AfterAddingAnItemTheCartIsNotEmptyAnymore

	| cart |
	
	cart := testObjectsFactory createCart.
	
	cart add: testObjectsFactory itemSoldByTheStore.
	self deny: cart isEmpty ! !

!CartTest methodsFor: 'tests' stamp: 'BR 11/8/2023 14:16:34'!
test04CanNotAddNonPositiveNumberOfItems

	| cart |
	
	cart := testObjectsFactory createCart.
	
	self 
		should: [cart add: 0 of: testObjectsFactory itemSoldByTheStore ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = cart invalidQuantityErrorMessage.
			self assert: cart isEmpty ]! !

!CartTest methodsFor: 'tests' stamp: 'BR 11/8/2023 14:16:05'!
test05CanNotAddMoreThanOneItemNotSellByTheStore

	| cart |
	
	cart := testObjectsFactory createCart.
	
	self 
		should: [cart add: 2 of: testObjectsFactory itemNotSoldByTheStore  ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = Cart invalidItemErrorMessage.
			self assert: cart isEmpty ]! !

!CartTest methodsFor: 'tests' stamp: 'BR 11/8/2023 14:16:34'!
test06CartRemembersAddedItems

	| cart |
	
	cart := testObjectsFactory createCart.
	
	cart add: testObjectsFactory itemSoldByTheStore.
	self assert: (cart includes: testObjectsFactory itemSoldByTheStore)! !

!CartTest methodsFor: 'tests' stamp: 'BR 11/8/2023 14:16:34'!
test07CartDoesNotHoldNotAddedItems

	| cart |
	
	cart := testObjectsFactory createCart.
	
	self deny: (cart includes: testObjectsFactory itemSoldByTheStore)! !

!CartTest methodsFor: 'tests' stamp: 'BR 11/8/2023 14:16:34'!
test08CartRemembersTheNumberOfAddedItems

	| cart |
	
	cart := testObjectsFactory createCart.
	
	cart add: 2 of: testObjectsFactory itemSoldByTheStore.
	self assert: (cart occurrencesOf: testObjectsFactory itemSoldByTheStore) = 2! !


!CartTest methodsFor: 'setup' stamp: 'HernanWilkinson 6/17/2013 18:09'!
setUp 

	testObjectsFactory := StoreTestObjectsFactory new.! !


!classDefinition: #CashierTest category: 'TusLibros'!
TestCase subclass: #CashierTest
	instanceVariableNames: 'testObjectsFactory debitBehavior'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CashierTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:50'!
test01CanNotCheckoutAnEmptyCart

	| salesBook |
	
	salesBook := OrderedCollection new.
	self 
		should: [ Cashier 
			toCheckout: testObjectsFactory createCart 
			charging: testObjectsFactory notExpiredCreditCard 
			throught: self
			on: testObjectsFactory today
			registeringOn:  salesBook ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = Cashier cartCanNotBeEmptyErrorMessage.
			self assert: salesBook isEmpty ]! !

!CashierTest methodsFor: 'tests' stamp: 'BR 11/8/2023 14:16:54'!
test02CalculatedTotalIsCorrect

	| cart cashier |
	
	cart := testObjectsFactory createCart.
	cart add: 2 of: testObjectsFactory itemSoldByTheStore.
	
	cashier :=  Cashier
		toCheckout: cart 
		charging: testObjectsFactory notExpiredCreditCard 
		throught: self
		on: testObjectsFactory today 
		registeringOn: OrderedCollection new.
		
	self assert: cashier checkOut = (testObjectsFactory itemSoldByTheStorePrice * 2)! !

!CashierTest methodsFor: 'tests' stamp: 'BR 11/8/2023 14:16:34'!
test03CanNotCheckoutWithAnExpiredCreditCart

	| cart salesBook |

	cart := testObjectsFactory createCart.
	cart add: testObjectsFactory itemSoldByTheStore.
	salesBook := OrderedCollection new.
	
	self
		should: [ Cashier 
				toCheckout: cart 
				charging: testObjectsFactory expiredCreditCard 
				throught: self
				on: testObjectsFactory today
				registeringOn: salesBook ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError | 
			self assert: anError messageText = Cashier canNotChargeAnExpiredCreditCardErrorMessage.
			self assert: salesBook isEmpty ]! !

!CashierTest methodsFor: 'tests' stamp: 'BR 11/8/2023 14:16:34'!
test04CheckoutRegistersASale

	| cart cashier salesBook total |

	cart := testObjectsFactory createCart.
	cart add: testObjectsFactory itemSoldByTheStore.
	salesBook := OrderedCollection new.
 
	cashier:= Cashier 
		toCheckout: cart 
		charging: testObjectsFactory notExpiredCreditCard
		throught: self
		on: testObjectsFactory today
		registeringOn: salesBook.
		
	total := cashier checkOut.
					
	self assert: salesBook size = 1.
	self assert: salesBook first total = total.! !

!CashierTest methodsFor: 'tests' stamp: 'BR 11/8/2023 14:16:34'!
test05CashierChargesCreditCardUsingMerchantProcessor

	| cart cashier salesBook total creditCard debitedAmout debitedCreditCard  |

	cart := testObjectsFactory createCart.
	cart add: testObjectsFactory itemSoldByTheStore.
	creditCard := testObjectsFactory notExpiredCreditCard.
	salesBook := OrderedCollection new.
 
	cashier:= Cashier 
		toCheckout: cart 
		charging: creditCard
		throught: self
		on: testObjectsFactory today
		registeringOn: salesBook.
		
	debitBehavior := [ :anAmount :aCreditCard | 
		debitedAmout := anAmount.
		debitedCreditCard := aCreditCard ].
	total := cashier checkOut.
					
	self assert: debitedCreditCard = creditCard.
	self assert: debitedAmout = total.! !

!CashierTest methodsFor: 'tests' stamp: 'BR 11/8/2023 14:16:34'!
test06CashierDoesNotSaleWhenTheCreditCardHasNoCredit

	| cart cashier salesBook creditCard |

	cart := testObjectsFactory createCart.
	cart add: testObjectsFactory itemSoldByTheStore.
	creditCard := testObjectsFactory notExpiredCreditCard.
	salesBook := OrderedCollection new.
 	debitBehavior := [ :anAmount :aCreditCard | self error: Cashier creditCardHasNoCreditErrorMessage].
	
	cashier:= Cashier 
		toCheckout: cart 
		charging: creditCard
		throught: self
		on: testObjectsFactory today
		registeringOn: salesBook.
		
	self 
		should: [cashier checkOut ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = Cashier creditCardHasNoCreditErrorMessage.
			self assert: salesBook isEmpty ]! !


!CashierTest methodsFor: 'setup' stamp: 'HernanWilkinson 6/17/2013 19:03'!
setUp 

	testObjectsFactory := StoreTestObjectsFactory new.
	debitBehavior := [ :anAmount :aCreditCard | ]! !


!CashierTest methodsFor: 'merchant processor protocol' stamp: 'HernanWilkinson 6/17/2013 19:02'!
debit: anAmount from: aCreditCard 

	^debitBehavior value: anAmount value: aCreditCard ! !


!classDefinition: #TusLibrosTest category: 'TusLibros'!
TestCase subclass: #TusLibrosTest
	instanceVariableNames: 'testObjectsFactory credentialValidatorBehavior idGenerator tusLibros'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!TusLibrosTest methodsFor: 'as yet unclassified' stamp: 'LR 11/6/2023 23:29:27'!
invalidateClientId: invalidClientId andPassword: invalidPassword
	^[:aClientId :aPassword | (invalidClientId = aClientId and: [invalidPassword = aPassword]) not.]! !

!TusLibrosTest methodsFor: 'as yet unclassified' stamp: 'BR 11/6/2023 21:28:43'!
isValidClient: aClientId withPassword: aPassword 
	^credentialValidatorBehavior value: aClientId value: aPassword.
	! !

!TusLibrosTest methodsFor: 'as yet unclassified' stamp: 'LR 11/7/2023 00:54:45'!
setUp 

	testObjectsFactory := StoreTestObjectsFactory new.
	credentialValidatorBehavior := [ :aClientId :aPassword | true ].
	idGenerator := IdGenerator new.
	tusLibros := TusLibros createAcceptingCatalog: testObjectsFactory defaultCatalog withCredentialValidator: self withIdGenerator: idGenerator! !

!TusLibrosTest methodsFor: 'as yet unclassified' stamp: 'BR 11/8/2023 14:16:34'!
test02ValidUserCanCreateManyCarts
	| clientId password cartId1 cartId2 item |
	
	clientId := '1'.
	password := '1234'.
	cartId1 := tusLibros createNewCartByClient: clientId usingPassword: password.
	cartId2 := tusLibros createNewCartByClient: clientId usingPassword: password.
	item := testObjectsFactory itemSoldByTheStore.
	
	tusLibros addToCart: cartId1 bookIsbn: item withQuantity: 1.
	self assert: (tusLibros listCart: cartId2) isEmpty.
	self assert: (tusLibros listCart: cartId1) equals: (Dictionary with: (item -> 1)).
	self assert: idGenerator generatedIds equals: (OrderedCollection with: cartId1 with: cartId2)! !

!TusLibrosTest methodsFor: 'as yet unclassified' stamp: 'LR 11/6/2023 23:35:52'!
test03InvalidUserCannotCreateCart
	| invalidClientId invalidClientPassword |
	
	invalidClientId := '2'.
	invalidClientPassword := '1234'.
	credentialValidatorBehavior := self invalidateClientId: invalidClientId andPassword: invalidClientPassword.
	
	self
		should: [
			tusLibros createNewCartByClient: invalidClientId usingPassword: invalidClientPassword.
		]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [:error | 
			self assert: error messageText equals: TusLibros invalidClientCredentialsErrorMessage.
			self assert: idGenerator generatedIds isEmpty
		].
	! !

!TusLibrosTest methodsFor: 'as yet unclassified' stamp: 'BR 11/8/2023 14:16:34'!
test04CanAddToCart
	| cartId book |
	book := testObjectsFactory itemSoldByTheStore.
	cartId := tusLibros createNewCartByClient: '1' usingPassword: '123'.
	
	tusLibros addToCart: cartId bookIsbn: book withQuantity: 1.
	
	self assert: (tusLibros listCart: cartId) equals: (Dictionary with: book -> 1)! !

!TusLibrosTest methodsFor: 'as yet unclassified' stamp: 'BR 11/8/2023 14:16:34'!
test05CannotAddToCartItemNotInCatalog
	| cartId |
	
	cartId := tusLibros createNewCartByClient: '1' usingPassword: '123'.
	tusLibros addToCart: cartId bookIsbn: testObjectsFactory itemSoldByTheStore withQuantity: 1.
	
	self
		should: [
			tusLibros addToCart: cartId bookIsbn: testObjectsFactory itemNotSoldByTheStore withQuantity: 1.
		]
		raise: Error
		withExceptionDo: [ :error |
			self assert: error messageText equals: Cart invalidItemErrorMessage.
			self assert: (tusLibros listCart: cartId) equals: (Dictionary with: testObjectsFactory itemSoldByTheStore -> 1)
		]! !

!TusLibrosTest methodsFor: 'as yet unclassified' stamp: 'BR 11/8/2023 14:16:34'!
test06CannotAddToNonExistingCart
	
	self
		should: [
			tusLibros addToCart: '1' bookIsbn: testObjectsFactory itemSoldByTheStore withQuantity: 1.
		]
		raise: Error
		withExceptionDo: [ :error |
			self assert: error messageText equals: tusLibros invalidCartErrorMessage.
		]! !

!TusLibrosTest methodsFor: 'as yet unclassified' stamp: 'LR 11/7/2023 01:30:35'!
test07ListExistingEmptyCart
	| cartId |
	cartId := tusLibros createNewCartByClient: '1' usingPassword: '123'.
	
	self assert: (tusLibros listCart: cartId) equals: Dictionary new.! !

!TusLibrosTest methodsFor: 'as yet unclassified' stamp: 'BR 11/8/2023 14:16:34'!
test08ListExistingNonEmptyCart
	| cartId itemInCart |
	cartId := tusLibros createNewCartByClient: '1' usingPassword: '123'.
	itemInCart := testObjectsFactory itemSoldByTheStore.
	tusLibros addToCart: cartId bookIsbn: itemInCart withQuantity: 1.
	
	self assert: (tusLibros listCart: cartId) equals: (Dictionary with: itemInCart -> 1).! !

!TusLibrosTest methodsFor: 'as yet unclassified' stamp: 'LR 11/7/2023 01:35:01'!
test09CannotListNonExistingCart
	
	self
		should: [
			tusLibros listCart: '1'.
		]
		raise: Error
		withExceptionDo: [ :error |
			self assert: error messageText equals: tusLibros invalidCartErrorMessage.
		]! !

!TusLibrosTest methodsFor: 'as yet unclassified' stamp: 'BR 11/8/2023 21:24:49'!
test10CanCheckOutCart
	| cartId itemBought clientId|
	itemBought := testObjectsFactory itemSoldByTheStore.
	cartId := tusLibros createNewCartByClient: '1' usingPassword: '123'.
	tusLibros addToCart: cartId bookIsbn: itemBought withQuantity: 1.
	clientId := '1'.
	
	tusLibros checkOut: cartId.
	
	self assert: (tusLibros listPurchasesForUser: '1' withPassword: '123') equals: (OrderedCollection with: (Sale of: itemBought doneBy: clientId)). ! !


!classDefinition: #Cart category: 'TusLibros'!
Object subclass: #Cart
	instanceVariableNames: 'catalog items'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Cart methodsFor: 'error messages' stamp: 'LR 11/7/2023 01:01:46'!
invalidQuantityErrorMessage
	
	^'Invalid number of items'! !


!Cart methodsFor: 'assertions' stamp: 'LR 11/7/2023 00:38:53'!
assertIsValidItem: anItem

	(catalog includesKey: anItem) ifFalse: [ self error: self class invalidItemErrorMessage ]! !

!Cart methodsFor: 'assertions' stamp: 'HernanWilkinson 6/17/2013 17:51'!
assertIsValidQuantity: aQuantity

	aQuantity strictlyPositive ifFalse: [ self error: self invalidQuantityErrorMessage ]! !


!Cart methodsFor: 'initialization' stamp: 'HernanWilkinson 6/17/2013 17:48'!
initializeAcceptingItemsOf: aCatalog

	catalog := aCatalog.
	items := OrderedCollection new.! !


!Cart methodsFor: 'queries' stamp: 'HernanWilkinson 6/17/2013 17:45'!
occurrencesOf: anItem

	^items occurrencesOf: anItem  ! !


!Cart methodsFor: 'testing' stamp: 'HernanWilkinson 6/17/2013 17:44'!
includes: anItem

	^items includes: anItem ! !

!Cart methodsFor: 'testing' stamp: 'HernanWilkinson 6/17/2013 17:44'!
isEmpty
	
	^items isEmpty ! !


!Cart methodsFor: 'total' stamp: 'BR 11/6/2023 20:41:59'!
items
	^items! !

!Cart methodsFor: 'total' stamp: 'HernanWilkinson 6/17/2013 19:09'!
total

	^ items sum: [ :anItem | catalog at: anItem ]! !


!Cart methodsFor: 'adding' stamp: 'HernanWilkinson 6/17/2013 17:44'!
add: anItem

	^ self add: 1 of: anItem ! !

!Cart methodsFor: 'adding' stamp: 'HernanWilkinson 6/17/2013 17:51'!
add: aQuantity of: anItem

	self assertIsValidQuantity: aQuantity.
	self assertIsValidItem: anItem.

	1 to: aQuantity do: [ :aNumber | items add: anItem ]! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cart class' category: 'TusLibros'!
Cart class
	instanceVariableNames: ''!

!Cart class methodsFor: 'instance creation' stamp: 'HernanWilkinson 6/17/2013 17:48'!
acceptingItemsOf: aCatalog

	^self new initializeAcceptingItemsOf: aCatalog ! !


!Cart class methodsFor: 'error messages' stamp: 'LR 11/7/2023 00:31:55'!
invalidItemErrorMessage
	
	^'Item is not in catalog'! !


!classDefinition: #CartStateInTime category: 'TusLibros'!
Object subclass: #CartStateInTime
	instanceVariableNames: 'cart interface lastUpdate'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CartStateInTime methodsFor: 'as yet unclassified' stamp: 'BR 11/8/2023 21:35:45'!
initializeWith: aCart using: anInterface
	cart := aCart.
	interface := anInterface.
	lastUpdate := 0 * minute.! !

!CartStateInTime methodsFor: 'as yet unclassified' stamp: 'BR 11/8/2023 21:32:24'!
isExpiredRelativeTo: timePassed
	^(lastUpdate + timePassed) > 30 * minute.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CartStateInTime class' category: 'TusLibros'!
CartStateInTime class
	instanceVariableNames: ''!

!CartStateInTime class methodsFor: 'as yet unclassified' stamp: 'BR 11/8/2023 21:35:07'!
createWith: aCart using: anInterface 
	^self new initializeWith: aCart using: anInterface! !


!classDefinition: #Cashier category: 'TusLibros'!
Object subclass: #Cashier
	instanceVariableNames: 'cart salesBook merchantProcessor creditCard total'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Cashier methodsFor: 'checkout - private' stamp: 'HernanWilkinson 6/17/2013 19:08'!
calculateTotal

	total := cart total.
	! !

!Cashier methodsFor: 'checkout - private' stamp: 'HernanWilkinson 6/17/2013 19:07'!
createSale

	^ Sale of: total
! !

!Cashier methodsFor: 'checkout - private' stamp: 'HernanWilkinson 6/17/2013 19:06'!
debitTotal

	merchantProcessor debit: total from: creditCard.
	! !

!Cashier methodsFor: 'checkout - private' stamp: 'HernanWilkinson 6/17/2013 19:06'!
registerSale

	salesBook add: self createSale! !


!Cashier methodsFor: 'checkout' stamp: 'HernanWilkinson 6/17/2013 19:06'!
checkOut

	self calculateTotal.
	self debitTotal.
	self registerSale.

	^ total! !


!Cashier methodsFor: 'initialization' stamp: 'HernanWilkinson 6/17/2013 18:53'!
initializeToCheckout: aCart charging: aCreditCard throught: aMerchantProcessor registeringOn: aSalesBook
	
	cart := aCart.
	creditCard := aCreditCard.
	merchantProcessor := aMerchantProcessor.
	salesBook := aSalesBook! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cashier class' category: 'TusLibros'!
Cashier class
	instanceVariableNames: ''!

!Cashier class methodsFor: 'assertions' stamp: 'HernanWilkinson 6/17/2013 18:22'!
assertIsNotEmpty: aCart 
	
	aCart isEmpty ifTrue: [self error: self cartCanNotBeEmptyErrorMessage ]! !

!Cashier class methodsFor: 'assertions' stamp: 'HernanWilkinson 6/17/2013 18:23'!
assertIsNotExpired: aCreditCard on: aDate
	
	(aCreditCard isExpiredOn: aDate) ifTrue: [ self error: self canNotChargeAnExpiredCreditCardErrorMessage ]! !


!Cashier class methodsFor: 'instance creation' stamp: 'HernanWilkinson 6/17/2013 18:51'!
toCheckout: aCart charging: aCreditCard throught: aMerchantProcessor on: aDate registeringOn: aSalesBook
	
	self assertIsNotEmpty: aCart.
	self assertIsNotExpired: aCreditCard on: aDate.
	
	^self new initializeToCheckout: aCart charging: aCreditCard throught: aMerchantProcessor registeringOn: aSalesBook! !


!Cashier class methodsFor: 'error messages' stamp: 'HernanWilkinson 6/17/2013 18:21'!
canNotChargeAnExpiredCreditCardErrorMessage
	
	^'Can not charge an expired credit card'! !

!Cashier class methodsFor: 'error messages' stamp: 'HernanWilkinson 6/17/2013 17:56'!
cartCanNotBeEmptyErrorMessage
	
	^'Can not check out an empty cart'! !

!Cashier class methodsFor: 'error messages' stamp: 'HernanWilkinson 6/17/2013 19:02'!
creditCardHasNoCreditErrorMessage
	
	^'Credit card has no credit'! !


!classDefinition: #CreditCard category: 'TusLibros'!
Object subclass: #CreditCard
	instanceVariableNames: 'expiration'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CreditCard methodsFor: 'testing' stamp: 'HernanWilkinson 6/17/2013 18:39'!
isExpiredOn: aDate 
	
	^expiration start < (Month month: aDate monthIndex year: aDate yearNumber) start ! !


!CreditCard methodsFor: 'initialization' stamp: 'HernanWilkinson 6/17/2013 18:38'!
initializeExpiringOn: aMonth 
	
	expiration := aMonth ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CreditCard class' category: 'TusLibros'!
CreditCard class
	instanceVariableNames: ''!

!CreditCard class methodsFor: 'instance creation' stamp: 'HernanWilkinson 6/17/2013 18:38'!
expiringOn: aMonth 
	
	^self new initializeExpiringOn: aMonth! !


!classDefinition: #IdGenerator category: 'TusLibros'!
Object subclass: #IdGenerator
	instanceVariableNames: 'lastGeneratedId generatedIds'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!IdGenerator methodsFor: 'evaluating' stamp: 'LR 11/6/2023 23:10:15'!
generatedIds
	^generatedIds! !

!IdGenerator methodsFor: 'evaluating' stamp: 'LR 11/6/2023 23:20:26'!
nextId
	lastGeneratedId := lastGeneratedId + 1.
	generatedIds add: lastGeneratedId printString.
	^lastGeneratedId printString! !


!IdGenerator methodsFor: 'initialization' stamp: 'LR 11/6/2023 23:10:33'!
initialize
	lastGeneratedId := 0.
	generatedIds := OrderedCollection new! !


!classDefinition: #Sale category: 'TusLibros'!
Object subclass: #Sale
	instanceVariableNames: 'total purchaser'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!


!Sale methodsFor: 'initialization' stamp: 'BR 11/8/2023 21:14:06'!
initializeTotal: aTotal doneBy: aPurchaser

	total := aTotal.
	purchaser := aPurchaser.! !

!Sale methodsFor: 'initialization' stamp: 'BR 11/8/2023 21:12:55'!
purchaser
	^purchaser! !

!Sale methodsFor: 'initialization' stamp: 'BR 11/8/2023 21:14:19'!
total
	^total! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Sale class' category: 'TusLibros'!
Sale class
	instanceVariableNames: ''!

!Sale class methodsFor: 'instance creation' stamp: 'BR 11/8/2023 21:13:37'!
of: aTotal doneBy: aPurchaser

	"should assert total is not negative or 0!!"
	^self new initializeTotal: aTotal doneBy: aPurchaser! !


!classDefinition: #Salesbook category: 'TusLibros'!
Object subclass: #Salesbook
	instanceVariableNames: 'sales'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Salesbook methodsFor: 'as yet unclassified' stamp: 'BR 11/8/2023 20:51:51'!
registerSale: aSale
	sales add: aSale.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Salesbook class' category: 'TusLibros'!
Salesbook class
	instanceVariableNames: ''!

!Salesbook class methodsFor: 'instance creation' stamp: 'BR 11/8/2023 20:51:13'!
with: aSale
	^self new initializeWith: aSale! !


!classDefinition: #StoreTestObjectsFactory category: 'TusLibros'!
Object subclass: #StoreTestObjectsFactory
	instanceVariableNames: 'today'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!StoreTestObjectsFactory methodsFor: 'items' stamp: 'BR 11/8/2023 14:16:05'!
itemNotSoldByTheStore
	
	^'invalidBook'! !

!StoreTestObjectsFactory methodsFor: 'items' stamp: 'BR 11/8/2023 14:16:34'!
itemSoldByTheStore
	
	^ 'validBook'! !

!StoreTestObjectsFactory methodsFor: 'items' stamp: 'BR 11/8/2023 14:16:54'!
itemSoldByTheStorePrice
	
	^10! !


!StoreTestObjectsFactory methodsFor: 'cart' stamp: 'HernanWilkinson 6/17/2013 18:08'!
createCart
	
	^Cart acceptingItemsOf: self defaultCatalog! !

!StoreTestObjectsFactory methodsFor: 'cart' stamp: 'BR 11/8/2023 14:16:54'!
defaultCatalog
	
	^ Dictionary new
		at: self itemSoldByTheStore put: self itemSoldByTheStorePrice;
		yourself ! !


!StoreTestObjectsFactory methodsFor: 'credit card' stamp: 'HernanWilkinson 6/17/2013 18:37'!
expiredCreditCard
	
	^CreditCard expiringOn: (Month month: today monthIndex year: today yearNumber - 1)! !

!StoreTestObjectsFactory methodsFor: 'credit card' stamp: 'HernanWilkinson 6/17/2013 18:36'!
notExpiredCreditCard
	
	^CreditCard expiringOn: (Month month: today monthIndex year: today yearNumber + 1)! !


!StoreTestObjectsFactory methodsFor: 'initialization' stamp: 'HernanWilkinson 6/17/2013 18:37'!
initialize

	today := DateAndTime now! !


!StoreTestObjectsFactory methodsFor: 'date' stamp: 'HernanWilkinson 6/17/2013 18:37'!
today
	
	^ today! !


!classDefinition: #TusLibros category: 'TusLibros'!
Object subclass: #TusLibros
	instanceVariableNames: 'total carts catalog credentialValidator idGenerator merchantProcessor booksByCart sales salesBook'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!TusLibros methodsFor: 'updating' stamp: 'LR 11/7/2023 01:36:41'!
addToCart: cartId bookIsbn: bookIsbn withQuantity: anAmount 
	| targetCart |
	
	targetCart := self findCart: cartId.
	targetCart add: anAmount of: bookIsbn! !

!TusLibros methodsFor: 'updating' stamp: 'BR 11/8/2023 19:52:39'!
createNewCartByClient: clientId usingPassword: clientPassword 
	| assignedId |
	self validateCredentialsWithId: clientId andPassword: clientPassword.
	 
	assignedId := idGenerator nextId.
	carts add: (assignedId -> (Cart acceptingItemsOf: catalog)). 
	sales add: (clientId -> (OrderedCollection new)).
	^assignedId! !

!TusLibros methodsFor: 'updating' stamp: 'LR 11/7/2023 01:05:36'!
validateCredentialsWithId: id andPassword: password

	^ (credentialValidator isValidClient: id withPassword: password) ifFalse: [self error: self class invalidClientCredentialsErrorMessage.]! !


!TusLibros methodsFor: 'evaluating' stamp: 'LR 11/7/2023 01:36:24'!
listCart: cartId
	| occurrenciesByBook updatedOccurrencies targetCart |
	targetCart := self findCart: cartId.
	occurrenciesByBook := Dictionary new.
	targetCart items do: [ :item |
		updatedOccurrencies := occurrenciesByBook at: item ifPresent: [:occurrencies | occurrencies + 1] ifAbsent: [ 1 ].
		occurrenciesByBook at: item put: updatedOccurrencies
	].
	
	^occurrenciesByBook.! !

!TusLibros methodsFor: 'evaluating' stamp: 'BR 11/8/2023 21:17:52'!
listPurchasesForUser: userId withPassword: password 
	(userId = '1' and: [password = '123']) ifTrue: [
		^salesBook select: [:aSale | 		aSale purchaser = userId]].! !


!TusLibros methodsFor: 'error handling' stamp: 'LR 11/7/2023 00:57:39'!
invalidCartErrorMessage
	^'Error trying to operate with invalid cart'! !


!TusLibros methodsFor: 'private' stamp: 'LR 11/7/2023 01:36:24'!
findCart: cartId

	^ carts at: cartId ifAbsent: [ self error: self invalidCartErrorMessage ]! !


!TusLibros methodsFor: 'initialization' stamp: 'BR 11/8/2023 20:50:52'!
initializeAcceptingCatalog: aCatalog withCredentialValidator: aCredentialValidator withIdGenerator: anIdGenerator through: aMerchantProcessor
	catalog := aCatalog.
	carts := Dictionary new.
	credentialValidator := aCredentialValidator.
	idGenerator := anIdGenerator.
	merchantProcessor := aMerchantProcessor.
	salesBook := Salesbook new.
	booksByCart := Dictionary new.! !


!TusLibros methodsFor: 'events-triggering' stamp: 'LR 11/7/2023 01:52:17'!
checkOut: cartId 
	! !

!TusLibros methodsFor: 'events-triggering' stamp: 'BR 11/8/2023 21:22:13'!
checkOut: cartId usingCreditCardNumber: aCreditCard andOwner: ownerName 
	|cashier|
	
	cashier := Cashier 
		toCheckout: (carts at: cartId) 
		charging: aCreditCard
		throught: merchantProcessor
		on: StoreTestObjectsFactory new today
		registeringOn: salesBook.
		
	cashier checkout.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TusLibros class' category: 'TusLibros'!
TusLibros class
	instanceVariableNames: ''!

!TusLibros class methodsFor: 'as yet unclassified' stamp: 'LR 11/6/2023 23:15:55'!
createAcceptingCatalog: aCatalog withCredentialValidator: aCredentialValidator withIdGenerator: anIdGenerator
	^self new initializeAcceptingCatalog: aCatalog withCredentialValidator: aCredentialValidator withIdGenerator: anIdGenerator.! !

!TusLibros class methodsFor: 'as yet unclassified' stamp: 'BR 11/8/2023 15:57:58'!
createAcceptingCatalog: aCatalog withCredentialValidator: aCredentialValidator withIdGenerator: anIdGenerator through: aMerchantProcessor
	^self new initializeAcceptingCatalog: aCatalog withCredentialValidator: aCredentialValidator withIdGenerator: anIdGenerator through: aMerchantProcessor.! !

!TusLibros class methodsFor: 'as yet unclassified' stamp: 'BR 11/6/2023 21:42:34'!
invalidCartIdErrorMessage
	^'Invalid cart id'.! !

!TusLibros class methodsFor: 'as yet unclassified' stamp: 'BR 11/6/2023 21:13:40'!
invalidClientCredentialsErrorMessage
	^'Invalid client credentials'.! !

