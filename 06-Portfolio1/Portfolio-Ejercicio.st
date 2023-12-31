!classDefinition: #PortfolioTest category: 'Portfolio-Ejercicio'!
TestCase subclass: #PortfolioTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!PortfolioTest methodsFor: 'as yet unclassified' stamp: 'LR 10/9/2023 21:27:49'!
test01EmptyPortfolioHasZeroBalance
	|portfolio|
	
	portfolio := Portfolio new.
	
	self assert: portfolio balance equals: 0.
	! !

!PortfolioTest methodsFor: 'as yet unclassified' stamp: 'BR 10/19/2023 00:09:08'!
test02BalanceOfPortfolioWithChildAccounts
	|portfolio anAccount anotherAccount|
	
	anAccount := ReceptiveAccount new.
	portfolio := PortfolioTest createPortfolioWithReceptiveAccount: anAccount.
	anotherAccount := ReceptiveAccount new.
	portfolio registerReceptiveAccount: anotherAccount.
	
	Deposit register: 100 on: anAccount.
	Deposit register: 50 on: anotherAccount.
	
	self assert: portfolio balance equals: 150.
	! !

!PortfolioTest methodsFor: 'as yet unclassified' stamp: 'BR 10/19/2023 00:12:28'!
test03BalanceOfPortfolioWithChildPortfolio
	|portfolio childAccount childPortfolio grandchildAccount|
	
	childAccount := ReceptiveAccount new.
	portfolio := PortfolioTest createPortfolioWithReceptiveAccount: childAccount.
	grandchildAccount := ReceptiveAccount new.
	childPortfolio := PortfolioTest createPortfolioWithReceptiveAccount: grandchildAccount.
	
	Deposit register: 100 on: childAccount.
	Deposit register: 50 on: grandchildAccount.
	
	portfolio registerPortfolio: childPortfolio. 
	self assert: portfolio balance equals: 150.
	! !

!PortfolioTest methodsFor: 'as yet unclassified' stamp: 'BR 10/19/2023 01:10:40'!
test04CannotAddSameFinancialEntityTwice
	|portfolio childReceptiveAccount|
	
	childReceptiveAccount := ReceptiveAccount new.
	portfolio := PortfolioTest createPortfolioWithReceptiveAccount: childReceptiveAccount.
	
	
	self should: [portfolio register: childReceptiveAccount] raise: Error withExceptionDo: [:error | 
			error messageText = (Portfolio portfolioCannotHaveRepeatedFinancialEntitiesErrorDescription).]! !

!PortfolioTest methodsFor: 'as yet unclassified' stamp: 'BR 10/19/2023 01:12:00'!
test05CannotAddPortfolioToItself
	|portfolio|
	
	portfolio := Portfolio new.

	self should: [portfolio register: portfolio.] raise: Error withExceptionDo: [:error | error messageText = (Portfolio portfolioHierarchyCannotContainCycles).]
	
	! !

!PortfolioTest methodsFor: 'as yet unclassified' stamp: 'BR 10/19/2023 01:12:13'!
test06CannotAddFatherToPortfolio
	|portfolio childPortfolio|
	
	portfolio := Portfolio new.
	childPortfolio := Portfolio new.
	portfolio registerPortfolio: childPortfolio.
	
	self should: [childPortfolio registerPortfolio: portfolio.] raise: Error withExceptionDo: [:error | error messageText = (Portfolio portfolioHierarchyCannotContainCycles).]
	
	! !

!PortfolioTest methodsFor: 'as yet unclassified' stamp: 'BR 10/19/2023 02:34:10'!
test07CannotAddGrandchildToPortfolio
	|portfolio childPortfolio grandchildPortfolio|
	
	portfolio := Portfolio new.
	childPortfolio := Portfolio new.
	grandchildPortfolio := Portfolio new.
	
	portfolio registerPortfolio: childPortfolio.
	childPortfolio registerPortfolio: grandchildPortfolio.
	
	self should: [grandchildPortfolio registerPortfolio: portfolio] raise: Error withExceptionDo: [:error | error messageText = (Portfolio portfolioHierarchyCannotContainCycles).]
	
	! !

!PortfolioTest methodsFor: 'as yet unclassified' stamp: 'BR 10/19/2023 01:42:27'!
test08CannotAddFatherToAnotherFather
	|parentPortfolio childPortfolio portfolio|
	
	parentPortfolio := Portfolio new.
	childPortfolio := Portfolio new.
	portfolio := Portfolio new.
	
	portfolio registerPortfolio: childPortfolio.
	parentPortfolio registerPortfolio: childPortfolio.
	
	self should: [parentPortfolio registerPortfolio: portfolio] raise: Error withExceptionDo: [:error | error messageText = (Portfolio portfolioHierarchyCannotContainCycles).]
	
	! !

!PortfolioTest methodsFor: 'as yet unclassified' stamp: 'BR 10/19/2023 02:27:18'!
test09CannotAddAnotherFatherToFatherOfAccount
	|parentPortfolio childPortfolio childAccount|
	
	parentPortfolio := Portfolio new.
	childPortfolio := Portfolio new.
	childAccount := ReceptiveAccount new.
	
	parentPortfolio registerPortfolio: childPortfolio.
	parentPortfolio registerReceptiveAccount: childAccount.
	
	self should: [childPortfolio registerReceptiveAccount: childAccount] raise: Error withExceptionDo: [:error | error messageText = (Portfolio portfolioHierarchyCannotContainCycles).]
	
	! !

!PortfolioTest methodsFor: 'as yet unclassified' stamp: 'LR 10/19/2023 03:18:31'!
test10CannotAddPortfolioWhoseGrandparentIsMyParent
	|portfolio grandchildPortfolio parentPortfolio grandparentPortfolio|
	
	grandparentPortfolio := Portfolio new.
	grandchildPortfolio := Portfolio new.
	parentPortfolio := Portfolio new.
	portfolio := Portfolio new.
	
	grandparentPortfolio registerPortfolio: parentPortfolio.
	parentPortfolio registerPortfolio: grandchildPortfolio.
	grandparentPortfolio registerPortfolio: portfolio.
	
	self should: [portfolio registerPortfolio: grandchildPortfolio] raise: Error withExceptionDo: [:error | error messageText = (Portfolio portfolioHierarchyCannotContainCycles).]
	
	! !

!PortfolioTest methodsFor: 'as yet unclassified' stamp: 'BR 10/19/2023 11:37:49'!
test11TransactionsOfPortfolioReturnsTransactionsOfAccounts
	|portfolio anAccount anotherAccount aDeposit anotherDeposit|
	
	anAccount := ReceptiveAccount new.
	portfolio := PortfolioTest createPortfolioWithReceptiveAccount: anAccount.
	anotherAccount := ReceptiveAccount new.
	portfolio registerReceptiveAccount: anotherAccount.
	
	aDeposit := Deposit for: 100.
	anotherDeposit := Deposit for: 50.
	
	anAccount register: aDeposit.
	anotherAccount register: anotherDeposit.
	
	self assert: (portfolio transactions) equals: (OrderedCollection with: aDeposit with: anotherDeposit).
	! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'PortfolioTest class' category: 'Portfolio-Ejercicio'!
PortfolioTest class
	instanceVariableNames: ''!

!PortfolioTest class methodsFor: 'as yet unclassified' stamp: 'BR 10/17/2023 21:15:59'!
createPortfolioWithFinancialEntity: aFinancialEntity
	|aPortfolio|
	
	aPortfolio := Portfolio new.
	
	aPortfolio register: aFinancialEntity.
	
	^aPortfolio.! !

!PortfolioTest class methodsFor: 'as yet unclassified' stamp: 'BR 10/19/2023 00:08:47'!
createPortfolioWithReceptiveAccount: aReceptiveAccount
	|aPortfolio|
	
	aPortfolio := Portfolio new.
	
	aPortfolio registerReceptiveAccount: aReceptiveAccount.
	
	^aPortfolio.! !


!classDefinition: #ReceptiveAccountTest category: 'Portfolio-Ejercicio'!
TestCase subclass: #ReceptiveAccountTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'NR 11/2/2020 17:13:44'!
test01ReceptiveAccountHaveZeroAsBalanceWhenCreated 

	| account |
	
	account := ReceptiveAccount new.

	self assert: 0 equals: account balance.
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'NR 11/2/2020 17:13:48'!
test02DepositIncreasesBalanceOnTransactionValue 

	| account |
	
	account := ReceptiveAccount  new.
	Deposit register: 100 on: account.
		
	self assert: 100 equals: account balance.
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'NR 11/2/2020 17:13:52'!
test03WithdrawDecreasesBalanceOnTransactionValue 

	| account |
	
	account := ReceptiveAccount new.
	Deposit register: 100 on: account.
	Withdraw register: 50 on: account.
		
	self assert: 50 equals: account balance.
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'HAW 5/23/2019 15:20:32'!
test04WithdrawValueMustBePositive 

	| account withdrawValue |
	
	account := ReceptiveAccount new.
	withdrawValue := 50.
	
	self assert: withdrawValue equals: (Withdraw register: withdrawValue on: account) value
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'HAW 5/23/2019 15:20:46'!
test05ReceptiveAccountKnowsRegisteredTransactions 

	| account deposit withdraw |
	
	account := ReceptiveAccount new.
	deposit := Deposit register: 100 on: account.
	withdraw := Withdraw register: 50 on: account.
		
	self assert: (account hasRegistered: deposit).
	self assert: (account hasRegistered: withdraw).
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'NR 5/17/2021 17:29:53'!
test06ReceptiveAccountDoNotKnowNotRegisteredTransactions

	| deposit withdraw account |
	
	account := ReceptiveAccount new.
	deposit :=  Deposit for: 200.
	withdraw := Withdraw for: 50.
		
	self deny: (account hasRegistered: deposit).
	self deny: (account hasRegistered:withdraw).
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'NR 11/2/2020 17:14:01'!
test07AccountKnowsItsTransactions 

	| account1 deposit1 |
	
	account1 := ReceptiveAccount new.
	
	deposit1 := Deposit register: 50 on: account1.
		
	self assert: 1 equals: account1 transactions size.
	self assert: (account1 transactions includes: deposit1).
! !


!classDefinition: #AccountTransaction category: 'Portfolio-Ejercicio'!
Object subclass: #AccountTransaction
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!AccountTransaction methodsFor: 'value' stamp: 'HernanWilkinson 9/12/2011 12:25'!
value 

	self subclassResponsibility ! !


!AccountTransaction methodsFor: 'as yet unclassified' stamp: 'LR 10/9/2023 20:57:54'!
applyToBalance: aBalance
	^self subclassResponsibility ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'AccountTransaction class' category: 'Portfolio-Ejercicio'!
AccountTransaction class
	instanceVariableNames: ''!

!AccountTransaction class methodsFor: 'instance creation' stamp: 'NR 10/17/2019 03:22:00'!
register: aValue on: account

	| transaction |
	
	transaction := self for: aValue.
	account register: transaction.
		
	^ transaction! !


!classDefinition: #Deposit category: 'Portfolio-Ejercicio'!
AccountTransaction subclass: #Deposit
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!Deposit methodsFor: 'initialization' stamp: 'HernanWilkinson 7/13/2011 18:45'!
initializeFor: aValue

	value := aValue ! !


!Deposit methodsFor: 'value' stamp: 'HernanWilkinson 7/13/2011 18:38'!
value

	^ value! !


!Deposit methodsFor: 'as yet unclassified' stamp: 'LR 10/9/2023 20:57:54'!
applyToBalance: aPreviousBalance
	^aPreviousBalance + value! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Deposit class' category: 'Portfolio-Ejercicio'!
Deposit class
	instanceVariableNames: ''!

!Deposit class methodsFor: 'instance creation' stamp: 'HernanWilkinson 7/13/2011 18:38'!
for: aValue

	^ self new initializeFor: aValue ! !


!classDefinition: #Withdraw category: 'Portfolio-Ejercicio'!
AccountTransaction subclass: #Withdraw
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!Withdraw methodsFor: 'initialization' stamp: 'HernanWilkinson 7/13/2011 18:46'!
initializeFor: aValue

	value := aValue ! !


!Withdraw methodsFor: 'value' stamp: 'HernanWilkinson 7/13/2011 18:33'!
value

	^ value! !


!Withdraw methodsFor: 'as yet unclassified' stamp: 'LR 10/9/2023 20:57:54'!
applyToBalance: aPreviousBalance
	^aPreviousBalance - value! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Withdraw class' category: 'Portfolio-Ejercicio'!
Withdraw class
	instanceVariableNames: ''!

!Withdraw class methodsFor: 'instance creation' stamp: 'HernanWilkinson 7/13/2011 18:33'!
for: aValue

	^ self new initializeFor: aValue ! !


!classDefinition: #FinancialEntity category: 'Portfolio-Ejercicio'!
Object subclass: #FinancialEntity
	instanceVariableNames: 'parents'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!FinancialEntity methodsFor: 'as yet unclassified' stamp: 'LR 10/19/2023 03:35:55'!
ancestors
	|ancestors|
	ancestors := OrderedCollection new.
	ancestors addAll: parents.
	parents do: [:parent | ancestors addAll: parent ancestors].
	^ancestors! !

!FinancialEntity methodsFor: 'as yet unclassified' stamp: 'BR 10/17/2023 21:06:41'!
balance
	self subclassResponsibility ! !

!FinancialEntity methodsFor: 'as yet unclassified' stamp: 'LR 10/19/2023 03:25:45'!
hasAnyAncestorOf: potentialAncestors
	^self ancestors anySatisfy: [:ancestor | potentialAncestors includes: ancestor ]! !

!FinancialEntity methodsFor: 'as yet unclassified' stamp: 'BR 10/19/2023 02:55:51'!
registerParent: aFinancialEntity
	parents add: aFinancialEntity.! !

!FinancialEntity methodsFor: 'as yet unclassified' stamp: 'LR 10/19/2023 03:21:28'!
sharesAncestorsWith: aPotentialSiblingEntity
	^aPotentialSiblingEntity hasAnyAncestorOf: self ancestors! !



!classDefinition: #Portfolio category: 'Portfolio-Ejercicio'!
FinancialEntity subclass: #Portfolio
	instanceVariableNames: 'portfolios receptiveAccounts'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!Portfolio methodsFor: 'evaluating' stamp: 'BR 10/18/2023 23:37:45'!
balance
	^(portfolios sum: [:portfolio | portfolio balance] ifEmpty: [0])+ (receptiveAccounts sum: [:receptiveAccount | receptiveAccount balance] ifEmpty: [0])
 	! !

!Portfolio methodsFor: 'evaluating' stamp: 'BR 10/19/2023 02:43:17'!
hierarchy
	|children|
	
	children := OrderedCollection new.
	
	children add: self.
	children addAll: portfolios.
	children addAll: receptiveAccounts.
	
	portfolios do: [:portfolio | children addAll: portfolio hierarchy].
	^children.
 	! !


!Portfolio methodsFor: 'updating' stamp: 'BR 10/19/2023 02:19:09'!
descendantsContainsAnyOf: aListOfFinancialEntities
	^aListOfFinancialEntities anySatisfy: [:financialEntity | self hasChild: financialEntity]! !

!Portfolio methodsFor: 'updating' stamp: 'BR 10/19/2023 01:17:26'!
hasChild: aFinancialEntity
	^(self hasRegisteredEntity: aFinancialEntity) or: [
		portfolios anySatisfy: [:portfolio | portfolio hasChild: aFinancialEntity].
	]! !

!Portfolio methodsFor: 'updating' stamp: 'BR 10/19/2023 02:56:15'!
registerPortfolio: aPortfolio 
	self validatePortfolioRegistration: aPortfolio.
	aPortfolio registerParent: self.
	portfolios add: aPortfolio.! !

!Portfolio methodsFor: 'updating' stamp: 'LR 10/19/2023 03:19:53'!
registerReceptiveAccount: aReceptiveAccount 
	(self sharesAncestorsWith: aReceptiveAccount) ifTrue: [^self error: self class portfolioCannotHaveRepeatedFinancialEntitiesErrorDescription].
	self validateReceptiveAccountRegistration: aReceptiveAccount.
	aReceptiveAccount registerParent: self.
	receptiveAccounts add: aReceptiveAccount.! !

!Portfolio methodsFor: 'updating' stamp: 'LR 10/19/2023 03:40:08'!
validatePortfolioRegistration: aPortfolio 
	(aPortfolio descendantsContainsAnyOf: self hierarchy) ifTrue: [^self error: self class portfolioHierarchyCannotContainCycles].
	(self sharesAncestorsWith: aPortfolio) ifTrue: [^self error: self class portfolioCannotHaveRepeatedFinancialEntitiesErrorDescription].! !

!Portfolio methodsFor: 'updating' stamp: 'BR 10/19/2023 03:03:03'!
validateReceptiveAccountRegistration: aReceptiveAccount 
	(self hasRegisteredEntity: aReceptiveAccount) ifTrue: [^self error: self class portfolioCannotHaveRepeatedFinancialEntitiesErrorDescription].
	(self hasChild: aReceptiveAccount) ifTrue: [^self error: self class portfolioHierarchyCannotContainCycles].
	
	! !


!Portfolio methodsFor: 'initialization' stamp: 'BR 10/19/2023 11:26:15'!
hasRegistered: aTransaction
	^(self transactions) includes: aTransaction.
	! !

!Portfolio methodsFor: 'initialization' stamp: 'BR 10/18/2023 23:42:03'!
hasRegisteredEntity: aFinancialEntity
	^(portfolios includes: aFinancialEntity) or: [receptiveAccounts includes: aFinancialEntity].! !

!Portfolio methodsFor: 'initialization' stamp: 'LR 10/19/2023 03:13:48'!
initialize
	portfolios := OrderedCollection new.
	receptiveAccounts := OrderedCollection new.
	parents := OrderedCollection new.! !

!Portfolio methodsFor: 'initialization' stamp: 'BR 10/19/2023 11:25:10'!
transactions
	|transactions|
	transactions := OrderedCollection new.
	receptiveAccounts do: [:account | transactions addAll: (account transactions)].
	^transactions! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Portfolio class' category: 'Portfolio-Ejercicio'!
Portfolio class
	instanceVariableNames: ''!

!Portfolio class methodsFor: 'as yet unclassified' stamp: 'BR 10/17/2023 21:49:37'!
portfolioCannotHaveRepeatedFinancialEntitiesErrorDescription
	^'Portfolio cannot have repeated financial entities'! !

!Portfolio class methodsFor: 'as yet unclassified' stamp: 'BR 10/17/2023 21:56:57'!
portfolioHierarchyCannotContainCycles
	^'Portfolio hierarchy cannot contain cycles'! !


!classDefinition: #ReceptiveAccount category: 'Portfolio-Ejercicio'!
FinancialEntity subclass: #ReceptiveAccount
	instanceVariableNames: 'transactions'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!ReceptiveAccount methodsFor: 'initialization' stamp: 'LR 10/19/2023 03:13:54'!
initialize

	transactions := OrderedCollection new.
	parents := OrderedCollection new.! !


!ReceptiveAccount methodsFor: 'transactions' stamp: 'HernanWilkinson 7/13/2011 18:37'!
register: aTransaction

	transactions add: aTransaction 
! !

!ReceptiveAccount methodsFor: 'transactions' stamp: 'BR 10/19/2023 11:20:46'!
registeredTransaction: aTransaction

	transactions includes: aTransaction 
! !

!ReceptiveAccount methodsFor: 'transactions' stamp: 'HernanWilkinson 7/13/2011 18:37'!
transactions 

	^ transactions copy! !


!ReceptiveAccount methodsFor: 'balance' stamp: 'LR 10/9/2023 20:58:02'!
balance

	^transactions inject: 0 into: [:partialBalance :nextTransaction | nextTransaction applyToBalance: partialBalance].! !


!ReceptiveAccount methodsFor: 'testing' stamp: 'NR 10/17/2019 03:28:43'!
hasRegistered: aTransaction

	^ transactions includes: aTransaction 
! !
