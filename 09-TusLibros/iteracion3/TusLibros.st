!classDefinition: #CartTest category: 'TusLibros'!
TestCase subclass: #CartTest
	instanceVariableNames: 'testObjectsFactory'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:10'!
test01NewCartsAreCreatedEmpty

	self assert: testObjectsFactory createCart isEmpty! !

!CartTest methodsFor: 'tests' stamp: 'LR 11/9/2023 00:17:07'!
test02CanNotAddItemsThatDoNotBelongToStore

	| cart |
	
	cart := testObjectsFactory createCart.
	
	self 
		should: [ cart add: testObjectsFactory itemNotSoldByTheStore ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = Cart invalidItemErrorMessage.
			self assert: cart isEmpty ]! !

!CartTest methodsFor: 'tests' stamp: 'LR 11/9/2023 00:16:49'!
test03AfterAddingAnItemTheCartIsNotEmptyAnymore

	| cart |
	
	cart := testObjectsFactory createCart.
	
	cart add: testObjectsFactory itemSoldByTheStore.
	self deny: cart isEmpty ! !

!CartTest methodsFor: 'tests' stamp: 'LR 11/9/2023 00:16:49'!
test04CanNotAddNonPositiveNumberOfItems

	| cart |
	
	cart := testObjectsFactory createCart.
	
	self 
		should: [cart add: 0 of: testObjectsFactory itemSoldByTheStore ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = cart invalidQuantityErrorMessage.
			self assert: cart isEmpty ]! !

!CartTest methodsFor: 'tests' stamp: 'LR 11/9/2023 00:17:07'!
test05CanNotAddMoreThanOneItemNotSellByTheStore

	| cart |
	
	cart := testObjectsFactory createCart.
	
	self 
		should: [cart add: 2 of: testObjectsFactory itemNotSoldByTheStore  ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = Cart invalidItemErrorMessage.
			self assert: cart isEmpty ]! !

!CartTest methodsFor: 'tests' stamp: 'LR 11/9/2023 00:16:49'!
test06CartRemembersAddedItems

	| cart |
	
	cart := testObjectsFactory createCart.
	
	cart add: testObjectsFactory itemSoldByTheStore.
	self assert: (cart includes: testObjectsFactory itemSoldByTheStore)! !

!CartTest methodsFor: 'tests' stamp: 'LR 11/9/2023 00:16:49'!
test07CartDoesNotHoldNotAddedItems

	| cart |
	
	cart := testObjectsFactory createCart.
	
	self deny: (cart includes: testObjectsFactory itemSoldByTheStore)! !

!CartTest methodsFor: 'tests' stamp: 'LR 11/9/2023 00:16:49'!
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

!CashierTest methodsFor: 'tests' stamp: 'LR 11/9/2023 00:17:00'!
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

!CashierTest methodsFor: 'tests' stamp: 'LR 11/9/2023 00:16:49'!
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

!CashierTest methodsFor: 'tests' stamp: 'LR 11/9/2023 00:16:49'!
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

!CashierTest methodsFor: 'tests' stamp: 'LR 11/9/2023 00:16:49'!
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

!CashierTest methodsFor: 'tests' stamp: 'LR 11/9/2023 00:16:49'!
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
	instanceVariableNames: 'testObjectsFactory credentialValidatorBehavior idGenerator tusLibros debitBehavior todayMonthOfYear currentTime'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!TusLibrosTest methodsFor: 'as yet unclassified' stamp: 'LR 11/9/2023 04:09:04'!
createCartWithValidCredentials
	^tusLibros createNewCartByClient: testObjectsFactory userId usingPassword: testObjectsFactory validPassword ! !

!TusLibrosTest methodsFor: 'as yet unclassified' stamp: 'LR 11/9/2023 03:47:38'!
dateTime
	^currentTime. ! !

!TusLibrosTest methodsFor: 'as yet unclassified' stamp: 'LR 11/8/2023 23:29:03'!
debit: debitAmount from: creditCard
	^debitBehavior value: creditCard value: debitAmount.! !

!TusLibrosTest methodsFor: 'as yet unclassified' stamp: 'LR 11/6/2023 23:29:27'!
invalidateClientId: invalidClientId andPassword: invalidPassword
	^[:aClientId :aPassword | (invalidClientId = aClientId and: [invalidPassword = aPassword]) not.]! !

!TusLibrosTest methodsFor: 'as yet unclassified' stamp: 'BR 11/6/2023 21:28:43'!
isValidClient: aClientId withPassword: aPassword 
	^credentialValidatorBehavior value: aClientId value: aPassword.
	! !

!TusLibrosTest methodsFor: 'as yet unclassified' stamp: 'LR 11/9/2023 02:32:37'!
listPurchasesForUser: userId andPassword: password hasSales: sales andTotal: itemPrice 
	self assert: (tusLibros listPurchasesForUser: userId usingPassword: password) sales equals: sales.
	self assert: (tusLibros listPurchasesForUser: userId usingPassword: password) total equals: itemPrice.! !

!TusLibrosTest methodsFor: 'as yet unclassified' stamp: 'LR 11/9/2023 04:13:29'!
setUp 

	testObjectsFactory := StoreTestObjectsFactory new.
	credentialValidatorBehavior := [ :aClientId :aPassword |
		 aClientId = (testObjectsFactory userId) and: [aPassword = testObjectsFactory validPassword ]
	].
	idGenerator := IdGenerator new.
	tusLibros := TusLibros createAcceptingCatalog: testObjectsFactory defaultCatalog withCredentialValidator: self withIdGenerator: idGenerator withMerchantProcessor: self withClock: self.
	debitBehavior := [:card :price].
	currentTime := testObjectsFactory today! !

!TusLibrosTest methodsFor: 'as yet unclassified' stamp: 'LR 11/9/2023 04:27:10'!
shouldNotBeAbleToDoWithExpiredCart: anActionWithCartId

	| expiredCartId |
	
	expiredCartId := self createCartWithValidCredentials.
	
	currentTime := testObjectsFactory today + (Duration minutes: 40).
	
	self
		should: [anActionWithCartId value: expiredCartId]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :error |
			self assert: error messageText equals: TimedCart cannotOperateWithExpiredCartErrorDescription.
			self 
				listPurchasesForUser: testObjectsFactory userId 
				andPassword: testObjectsFactory validPassword 
				hasSales: OrderedCollection new 
				andTotal: 0.
		]! !

!TusLibrosTest methodsFor: 'as yet unclassified' stamp: 'LR 11/9/2023 04:09:36'!
test02ValidUserCanCreateManyCarts
	| cartId1 cartId2 item |
	
	cartId1 := self createCartWithValidCredentials.
	cartId2 := self createCartWithValidCredentials .
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

!TusLibrosTest methodsFor: 'as yet unclassified' stamp: 'LR 11/9/2023 04:13:56'!
test04CanAddToCart
	| cartId book |
	book := testObjectsFactory itemSoldByTheStore.
	cartId := self createCartWithValidCredentials.
	
	tusLibros addToCart: cartId bookIsbn: book withQuantity: 1.
	
	self assert: (tusLibros listCart: cartId) equals: (Dictionary with: book -> 1)! !

!TusLibrosTest methodsFor: 'as yet unclassified' stamp: 'LR 11/9/2023 04:14:06'!
test05CannotAddToCartItemNotInCatalog
	| cartId |
	
	cartId := self createCartWithValidCredentials.
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

!TusLibrosTest methodsFor: 'as yet unclassified' stamp: 'LR 11/9/2023 00:16:49'!
test06CannotAddToNonExistingCart
	
	self
		should: [
			tusLibros addToCart: '1' bookIsbn: testObjectsFactory itemSoldByTheStore withQuantity: 1.
		]
		raise: Error
		withExceptionDo: [ :error |
			self assert: error messageText equals: tusLibros invalidCartIdErrorMessage.
		]! !

!TusLibrosTest methodsFor: 'as yet unclassified' stamp: 'LR 11/9/2023 04:14:20'!
test07ListExistingEmptyCart
	| cartId |
	cartId := self createCartWithValidCredentials.
	
	self assert: (tusLibros listCart: cartId) equals: Dictionary new.! !

!TusLibrosTest methodsFor: 'as yet unclassified' stamp: 'LR 11/9/2023 04:14:31'!
test08ListExistingNonEmptyCart
	| cartId itemInCart |
	cartId := self createCartWithValidCredentials.
	itemInCart := testObjectsFactory itemSoldByTheStore.
	tusLibros addToCart: cartId bookIsbn: itemInCart withQuantity: 1.
	
	self assert: (tusLibros listCart: cartId) equals: (Dictionary with: itemInCart -> 1).! !

!TusLibrosTest methodsFor: 'as yet unclassified' stamp: 'LR 11/9/2023 04:14:45'!
test09CannotListNonExistingCart
	
	self
		should: [ tusLibros listCart: '1' ]
		raise: Error
		withExceptionDo: [ :error |
			self assert: error messageText equals: tusLibros invalidCartIdErrorMessage.
		]! !

!TusLibrosTest methodsFor: 'as yet unclassified' stamp: 'LR 11/9/2023 04:14:53'!
test10CartCheckoutUsesMerchantProcessor
	| cartId itemBought creditCardUsed chargedPrice userCreditCard |
	userCreditCard := testObjectsFactory notExpiredCreditCard .
	itemBought := testObjectsFactory itemSoldByTheStore.
	cartId := self createCartWithValidCredentials.
	tusLibros addToCart: cartId bookIsbn: itemBought withQuantity: 1.
	debitBehavior := [:creditCard :price |
		creditCardUsed := creditCard.
		chargedPrice := price
	].
	
	tusLibros checkOut: cartId withCreditCard: userCreditCard todayIs: testObjectsFactory today.
	
	self assert: chargedPrice equals: testObjectsFactory itemSoldByTheStorePrice.
	self assert: creditCardUsed equals: userCreditCard ! !

!TusLibrosTest methodsFor: 'as yet unclassified' stamp: 'LR 11/9/2023 00:30:02'!
test11CannotCheckOutNonExistingCart
	| merchantProcessorWasUsed |
	
	merchantProcessorWasUsed := false.
	debitBehavior := [ :card :price | merchantProcessorWasUsed := true ].
	
	self
		should: [
			tusLibros checkOut: '1' withCreditCard: testObjectsFactory notExpiredCreditCard todayIs: testObjectsFactory today.
		]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [:error |
			self assert: error messageText equals: tusLibros invalidCartIdErrorMessage.
			self deny: merchantProcessorWasUsed.
		]! !

!TusLibrosTest methodsFor: 'as yet unclassified' stamp: 'LR 11/9/2023 04:16:51'!
test12CartCheckoutRegistersPurchase
	| cartId itemBought creditCard userId password |
	creditCard := testObjectsFactory notExpiredCreditCard.
	userId := testObjectsFactory userId.
	password := testObjectsFactory validPassword.
	itemBought := testObjectsFactory itemSoldByTheStore.
	cartId := self createCartWithValidCredentials.
	tusLibros addToCart: cartId bookIsbn: itemBought withQuantity: 1.
	
	tusLibros checkOut: cartId withCreditCard: creditCard todayIs: testObjectsFactory today.
	
	self assert: (tusLibros listPurchasesForUser: userId usingPassword: password) total equals: testObjectsFactory itemSoldByTheStorePrice .! !

!TusLibrosTest methodsFor: 'as yet unclassified' stamp: 'LR 11/9/2023 04:18:02'!
test13CannotCheckOutWithExpiredCreditCard
	| cartId itemBought merchantProcessorWasUsed |
	merchantProcessorWasUsed := false.
	debitBehavior := [ :card :price | merchantProcessorWasUsed := true ].
	itemBought := testObjectsFactory itemSoldByTheStore.
	cartId := self createCartWithValidCredentials.
	tusLibros addToCart: cartId bookIsbn: itemBought withQuantity: 1.
	
	self
		should: [ tusLibros checkOut: cartId withCreditCard: testObjectsFactory expiredCreditCard todayIs: testObjectsFactory today]
		raise: Error
		withExceptionDo: [:error |
			self assert: error messageText equals: Cashier canNotChargeAnExpiredCreditCardErrorMessage.
			self deny: merchantProcessorWasUsed.
			self assert: (tusLibros listPurchasesForUser: testObjectsFactory userId usingPassword: testObjectsFactory validPassword) isEmpty.
		]! !

!TusLibrosTest methodsFor: 'as yet unclassified' stamp: 'LR 11/9/2023 04:19:14'!
test14KeepHistoryOfMultiplePurchases
	| olderCartId newerCartId itemBought itemPrice sale |
	itemBought := testObjectsFactory itemSoldByTheStore.
	itemPrice := testObjectsFactory itemSoldByTheStorePrice .
	sale := (Sale of: itemPrice to: '1' items: (OrderedCollection with: itemBought) ).
	olderCartId := self createCartWithValidCredentials.
	tusLibros addToCart: olderCartId bookIsbn: itemBought withQuantity: 1.
	newerCartId := self createCartWithValidCredentials.
	tusLibros addToCart: newerCartId bookIsbn: itemBought withQuantity: 1.
	tusLibros checkOut: olderCartId withCreditCard: testObjectsFactory notExpiredCreditCard todayIs: testObjectsFactory today.
	tusLibros checkOut: newerCartId withCreditCard: testObjectsFactory notExpiredCreditCard todayIs: testObjectsFactory today.
	
	self 
		listPurchasesForUser: testObjectsFactory userId
		andPassword: testObjectsFactory validPassword
		hasSales: (OrderedCollection with: sale with: sale) 
		andTotal: itemPrice * 2! !

!TusLibrosTest methodsFor: 'as yet unclassified' stamp: 'LR 11/9/2023 04:24:41'!
test15FilterPurchasesOfGivenUser
	| olderCartId newerCartId itemBought itemPrice sale |
	itemBought := testObjectsFactory itemSoldByTheStore.
	itemPrice := testObjectsFactory itemSoldByTheStorePrice .
	sale := (Sale of: itemPrice to: '1' items: (OrderedCollection with: itemBought) ).
	olderCartId := self createCartWithValidCredentials.
	tusLibros addToCart: olderCartId bookIsbn: itemBought withQuantity: 1.
	newerCartId := self createCartWithValidCredentials.
	tusLibros addToCart: newerCartId bookIsbn: itemBought withQuantity: 1.
	tusLibros checkOut: olderCartId withCreditCard: testObjectsFactory notExpiredCreditCard todayIs: testObjectsFactory today.
	tusLibros checkOut: newerCartId withCreditCard: testObjectsFactory notExpiredCreditCard todayIs: testObjectsFactory today.
	
	self 
		listPurchasesForUser: testObjectsFactory userId
		andPassword: testObjectsFactory validPassword 
		hasSales: (OrderedCollection with: sale with: sale)
		andTotal: itemPrice * 2! !

!TusLibrosTest methodsFor: 'as yet unclassified' stamp: 'LR 11/9/2023 04:25:46'!
test16CannotCheckoutExpiredCart
	| creditCard today |
	creditCard := testObjectsFactory notExpiredCreditCard.
	today := testObjectsFactory today.
	self shouldNotBeAbleToDoWithExpiredCart: [ :expiredCartId |
		tusLibros checkOut: expiredCartId withCreditCard: creditCard todayIs: today
	 ]! !

!TusLibrosTest methodsFor: 'as yet unclassified' stamp: 'LR 11/9/2023 03:53:02'!
test17CannotListExpiredCart
	self shouldNotBeAbleToDoWithExpiredCart: [ :expiredCartId | tusLibros listCart: expiredCartId ]! !

!TusLibrosTest methodsFor: 'as yet unclassified' stamp: 'LR 11/9/2023 03:55:12'!
test18CannotAddToExpiredCart
	self shouldNotBeAbleToDoWithExpiredCart: [ :expiredCartId | 
		tusLibros addToCart: expiredCartId bookIsbn: testObjectsFactory itemSoldByTheStore withQuantity: 1
	]! !

!TusLibrosTest methodsFor: 'as yet unclassified' stamp: 'LR 11/9/2023 04:22:24'!
test19ResetExpirationTimeAfterInteractionWithCart
	| cartId |
	cartId := self createCartWithValidCredentials.
	
	currentTime := currentTime + (Duration minutes: 20).
	tusLibros listCart: cartId.
	currentTime := currentTime + (Duration minutes: 20).
	
	self shouldntFail: [tusLibros listCart: cartId]! !

!TusLibrosTest methodsFor: 'as yet unclassified' stamp: 'LR 11/9/2023 04:05:43'!
test20CannotListPurchasesWithInvalidCredentials
	| invalidClientId invalidClientPassword |
	
	invalidClientId := '2'.
	invalidClientPassword := '1234'.
	credentialValidatorBehavior := self invalidateClientId: invalidClientId andPassword: invalidClientPassword.
	
	self 
		should: [ tusLibros listPurchasesForUser: invalidClientId usingPassword: invalidClientPassword ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :error |
			TusLibros invalidClientCredentialsErrorMessage.
		]! !


!classDefinition: #Cart category: 'TusLibros'!
Object subclass: #Cart
	instanceVariableNames: 'catalog items owner'
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


!Cart methodsFor: 'initialization' stamp: 'LR 11/9/2023 01:25:26'!
initializeAcceptingItemsOf: aCatalog ownedBy: userId

	catalog := aCatalog.
	items := OrderedCollection new.
	owner := userId.! !


!Cart methodsFor: 'queries' stamp: 'HernanWilkinson 6/17/2013 17:45'!
occurrencesOf: anItem

	^items occurrencesOf: anItem  ! !

!Cart methodsFor: 'queries' stamp: 'LR 11/9/2023 01:46:48'!
owner
	^owner! !


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

!Cart class methodsFor: 'instance creation' stamp: 'LR 11/9/2023 01:26:32'!
acceptingItemsOf: aCatalog ownedBy: userId

	^self new initializeAcceptingItemsOf: aCatalog ownedBy: userId! !


!Cart class methodsFor: 'error messages' stamp: 'LR 11/7/2023 00:31:55'!
invalidItemErrorMessage
	
	^'Item is not in catalog'! !


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

!Cashier methodsFor: 'checkout - private' stamp: 'LR 11/9/2023 01:47:09'!
createSale

	^ Sale of: total to: cart owner items: cart items
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
	instanceVariableNames: 'total clientId items'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Sale methodsFor: 'total' stamp: 'HernanWilkinson 6/17/2013 18:48'!
total
	
	^ total! !


!Sale methodsFor: 'initialization' stamp: 'LR 11/9/2023 01:52:18'!
initializeWithTotal: aTotal to: aClientId items: aCollectionOfItems 
	total := aTotal.
	clientId := aClientId.
	items := aCollectionOfItems.! !


!Sale methodsFor: 'nil' stamp: 'LR 11/9/2023 02:03:52'!
= otherObject

(otherObject isKindOf: self class) ifTrue: [
	^(otherObject clientId = clientId) and: [ otherObject total = total and: [ otherObject items = items ] ]
] ifFalse: [
	^false
]! !

!Sale methodsFor: 'nil' stamp: 'LR 11/9/2023 02:04:12'!
items
	^items! !


!Sale methodsFor: 'as yet unclassified' stamp: 'LR 11/9/2023 02:04:23'!
clientId
	^clientId! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Sale class' category: 'TusLibros'!
Sale class
	instanceVariableNames: ''!

!Sale class methodsFor: 'instance creation' stamp: 'LR 11/9/2023 01:51:45'!
of: aTotal to: aClientId items: aCollectionOfItems 
	^self new initializeWithTotal: aTotal to: aClientId items: aCollectionOfItems ! !


!classDefinition: #Salesbook category: 'TusLibros'!
Object subclass: #Salesbook
	instanceVariableNames: 'sales'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!


!Salesbook methodsFor: 'as yet unclassified' stamp: 'LR 11/9/2023 00:12:05'!
isEmpty
	^true! !


!Salesbook methodsFor: 'updating' stamp: 'LR 11/9/2023 02:04:59'!
add: sale
	sales add: sale! !


!Salesbook methodsFor: 'evaluate' stamp: 'LR 11/9/2023 01:53:57'!
sales
	^sales! !

!Salesbook methodsFor: 'evaluate' stamp: 'LR 11/9/2023 02:05:38'!
total
	^sales sum: [ :sale | sale total ] ifEmpty: 0.! !


!Salesbook methodsFor: 'initialization' stamp: 'LR 11/9/2023 01:53:40'!
initialize
	sales := OrderedCollection new.! !

!Salesbook methodsFor: 'initialization' stamp: 'LR 11/9/2023 02:29:56'!
with: salesCollection
	sales := salesCollection! !


!Salesbook methodsFor: 'filter' stamp: 'LR 11/9/2023 02:24:12'!
filteredBy: clientId
	^Salesbook with: (sales select: [:sale | sale clientId = clientId ]) copy! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Salesbook class' category: 'TusLibros'!
Salesbook class
	instanceVariableNames: ''!

!Salesbook class methodsFor: 'instance creation' stamp: 'LR 11/9/2023 02:28:38'!
with: sales
	^self new with: sales! !


!classDefinition: #StoreTestObjectsFactory category: 'TusLibros'!
Object subclass: #StoreTestObjectsFactory
	instanceVariableNames: 'today'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!StoreTestObjectsFactory methodsFor: 'items' stamp: 'LR 11/9/2023 00:17:07'!
itemNotSoldByTheStore
	
	^'invalidBook'! !

!StoreTestObjectsFactory methodsFor: 'items' stamp: 'LR 11/9/2023 00:16:49'!
itemSoldByTheStore
	
	^ 'validBook'! !

!StoreTestObjectsFactory methodsFor: 'items' stamp: 'LR 11/9/2023 00:17:00'!
itemSoldByTheStorePrice
	
	^10! !


!StoreTestObjectsFactory methodsFor: 'cart' stamp: 'LR 11/9/2023 04:06:59'!
createCart
	
	^Cart acceptingItemsOf: self defaultCatalog ownedBy: self userId! !

!StoreTestObjectsFactory methodsFor: 'cart' stamp: 'LR 11/9/2023 00:17:00'!
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


!StoreTestObjectsFactory methodsFor: 'user' stamp: 'LR 11/9/2023 04:06:59'!
userId
	^'1'! !

!StoreTestObjectsFactory methodsFor: 'user' stamp: 'LR 11/9/2023 04:07:31'!
validPassword
	^'c451h4ck3r'! !


!classDefinition: #TimedCart category: 'TusLibros'!
Object subclass: #TimedCart
	instanceVariableNames: 'cart timer clock lastUpdate'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!TimedCart methodsFor: 'nil' stamp: 'LR 11/9/2023 03:45:26'!
cart
	| currentTime maxDuration |
	maxDuration := Duration minutes: 30.
	currentTime := clock dateTime.
	(currentTime > (lastUpdate + maxDuration)) ifTrue: [
		self error: self class cannotOperateWithExpiredCartErrorDescription 
	] ifFalse: [
		lastUpdate := currentTime.
		^cart
	]! !


!TimedCart methodsFor: 'initialization' stamp: 'LR 11/9/2023 03:28:02'!
initializeWith: aCart andClock: aClock
	clock := aClock.
	cart := aCart.
	lastUpdate := clock dateTime.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TimedCart class' category: 'TusLibros'!
TimedCart class
	instanceVariableNames: ''!

!TimedCart class methodsFor: 'instance creation' stamp: 'LR 11/9/2023 03:31:05'!
cannotOperateWithExpiredCartErrorDescription
	^'Cannot operate with invalid cart'! !

!TimedCart class methodsFor: 'instance creation' stamp: 'LR 11/9/2023 03:28:16'!
with: aCart andClock: aClock
	^self new initializeWith: aCart andClock: aClock! !


!classDefinition: #TusLibros category: 'TusLibros'!
Object subclass: #TusLibros
	instanceVariableNames: 'total carts catalog credentialValidator idGenerator merchantProcessor salesbook clock'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!TusLibros methodsFor: 'updating' stamp: 'LR 11/7/2023 01:36:41'!
addToCart: cartId bookIsbn: bookIsbn withQuantity: anAmount 
	| targetCart |
	
	targetCart := self findCart: cartId.
	targetCart add: anAmount of: bookIsbn! !

!TusLibros methodsFor: 'updating' stamp: 'LR 11/9/2023 03:28:35'!
createNewCartByClient: clientId usingPassword: clientPassword 
	| assignedId |
	self validateCredentialsWithId: clientId andPassword: clientPassword.
	 
	assignedId := idGenerator nextId.
	carts add: (assignedId -> (TimedCart with: (Cart acceptingItemsOf: catalog ownedBy: clientId) andClock: clock)). 
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

!TusLibros methodsFor: 'evaluating' stamp: 'LR 11/9/2023 04:06:10'!
listPurchasesForUser: userId usingPassword: password 
	self validateCredentialsWithId: userId andPassword: password.
	^salesbook filteredBy: userId! !


!TusLibros methodsFor: 'error handling' stamp: 'LR 11/8/2023 23:37:03'!
invalidCartIdErrorMessage
	^'Error trying to operate with invalid cart'! !


!TusLibros methodsFor: 'private' stamp: 'LR 11/9/2023 03:29:05'!
findCart: cartId

	^ (carts at: cartId ifAbsent: [ self error: self invalidCartIdErrorMessage ]) cart! !


!TusLibros methodsFor: 'initialization' stamp: 'LR 11/9/2023 03:22:54'!
initializeAcceptingCatalog: aCatalog withCredentialValidator: aCredentialValidator withIdGenerator: anIdGenerator withMerchantProcessor: aMerchantProcessor withClock: aClock
	catalog := aCatalog.
	carts := Dictionary new.
	credentialValidator := aCredentialValidator.
	idGenerator := anIdGenerator.
	merchantProcessor := aMerchantProcessor.
	salesbook := Salesbook new.
	clock := aClock.! !


!TusLibros methodsFor: 'events-triggering' stamp: 'LR 11/9/2023 01:39:29'!
checkOut: cartId withCreditCard: aCreditCard todayIs: aDate
	| cartToCheckOut cashier |
	
	cartToCheckOut := self findCart: cartId.
	cashier := Cashier 
		toCheckout: cartToCheckOut 
		charging: aCreditCard 
		throught: merchantProcessor 
		on: aDate 
		registeringOn: salesbook.
	^cashier checkOut.
	! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TusLibros class' category: 'TusLibros'!
TusLibros class
	instanceVariableNames: ''!

!TusLibros class methodsFor: 'as yet unclassified' stamp: 'LR 11/9/2023 03:22:25'!
createAcceptingCatalog: aCatalog withCredentialValidator: aCredentialValidator withIdGenerator: anIdGenerator withMerchantProcessor: aMerchantProcessor withClock: aClock
	^self new
		initializeAcceptingCatalog: aCatalog 
		withCredentialValidator: aCredentialValidator 
		withIdGenerator: anIdGenerator 
		withMerchantProcessor: aMerchantProcessor
		withClock: aClock! !

!TusLibros class methodsFor: 'as yet unclassified' stamp: 'BR 11/6/2023 21:13:40'!
invalidClientCredentialsErrorMessage
	^'Invalid client credentials'.! !


