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

!PortfolioTest methodsFor: 'as yet unclassified' stamp: 'BR 10/17/2023 21:22:43'!
test02BalanceOfPortfolioWithChildAccounts
	|portfolio anAccount anotherAccount|
	
	anAccount := ReceptiveAccount new.
	portfolio := PortfolioTest createPortfolioWithFinancialEntity: anAccount.
	anotherAccount := ReceptiveAccount new.
	portfolio register: anotherAccount.
	
	Deposit register: 100 on: anAccount.
	Deposit register: 50 on: anotherAccount.
	
	self assert: portfolio balance equals: 150.
	! !

!PortfolioTest methodsFor: 'as yet unclassified' stamp: 'BR 10/17/2023 21:21:58'!
test03BalanceOfPortfolioWithChildPortfolio
	|portfolio childAccount childPortfolio grandchildAccount|
	
	childAccount := ReceptiveAccount new.
	portfolio := PortfolioTest createPortfolioWithFinancialEntity: childAccount.
	grandchildAccount := ReceptiveAccount new.
	childPortfolio := PortfolioTest createPortfolioWithFinancialEntity: grandchildAccount.
	
	Deposit register: 100 on: childAccount.
	Deposit register: 50 on: grandchildAccount.
	
	portfolio register: childPortfolio. 
	self assert: portfolio balance equals: 150.
	! !

!PortfolioTest methodsFor: 'as yet unclassified' stamp: 'BR 10/17/2023 21:49:54'!
test04CannotAddSameFinancialEntityTwice
	|portfolio childFinancialEntity|
	
	childFinancialEntity := ReceptiveAccount new.
	portfolio := PortfolioTest createPortfolioWithFinancialEntity: childFinancialEntity.
	
	
	self should: [portfolio register: childFinancialEntity] raise: Error description: Portfolio portfolioCannotHaveRepeatedFinancialEntitiesErrorDescription. 
	
	! !

!PortfolioTest methodsFor: 'as yet unclassified' stamp: 'BR 10/17/2023 22:41:29'!
test05CannotAddPortfolioToItself
	|portfolio|
	
	portfolio := Portfolio new.

	self should: [portfolio register: portfolio.] raise: Error description: Portfolio portfolioHierarchyCannotContainCycles . 
	
	! !

!PortfolioTest methodsFor: 'as yet unclassified' stamp: 'BR 10/17/2023 23:02:34'!
test06CannotAddFatherToPortfolio
	|portfolio childPortfolio|
	
	portfolio := Portfolio new.
	childPortfolio := Portfolio new.
	portfolio register: childPortfolio.
	
	self should: [childPortfolio register: portfolio.] raise: Error description: Portfolio portfolioCannotHaveRepeatedFinancialEntitiesErrorDescription. 
	
	! !

!PortfolioTest methodsFor: 'as yet unclassified' stamp: 'BR 10/17/2023 22:58:17'!
test07CannotAddSameFinancialEntityTwice
	|portfolio childPortfolio grandchildPortfolio|
	
	portfolio := Portfolio new.
	childPortfolio := Portfolio new.
	grandchildPortfolio := Portfolio new.
	
	portfolio register: childPortfolio.
	childPortfolio register: grandchildPortfolio.
	
	self should: [grandchildPortfolio register: portfolio.] raise: Error description: Portfolio portfolioCannotHaveRepeatedFinancialEntitiesErrorDescription. 
	
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
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!FinancialEntity methodsFor: 'as yet unclassified' stamp: 'BR 10/17/2023 21:06:41'!
balance
	self subclassResponsibility ! !


!classDefinition: #Portfolio category: 'Portfolio-Ejercicio'!
FinancialEntity subclass: #Portfolio
	instanceVariableNames: 'financialEntities'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!Portfolio methodsFor: 'evaluating' stamp: 'BR 10/17/2023 21:13:38'!
balance
	^financialEntities sum: [:financialEntity | financialEntity balance] ifEmpty: [0].
	! !


!Portfolio methodsFor: 'updating' stamp: 'BR 10/17/2023 22:54:14'!
register: aFinancialEntity 
	(financialEntities includes: aFinancialEntity) ifTrue: [^self error: self class portfolioCannotHaveRepeatedFinancialEntitiesErrorDescription ].
	(self = aFinancialEntity) ifTrue: [^self error: self class portfolioHierarchyCannotContainCycles].
	(aFinancialEntity hasRegisteredEntity: self) ifTrue: [^self error: self class portfolioHierarchyCannotContainCycles].
	financialEntities add: aFinancialEntity.! !


!Portfolio methodsFor: 'initialization' stamp: 'BR 10/17/2023 22:55:01'!
hasRegisteredEntity: aFinancialEntity
	^financialEntities includes: aFinancialEntity.! !

!Portfolio methodsFor: 'initialization' stamp: 'BR 10/17/2023 21:15:01'!
initialize
	financialEntities := OrderedCollection new.! !

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

!ReceptiveAccount methodsFor: 'initialization' stamp: 'NR 10/17/2019 15:06:56'!
initialize

	transactions := OrderedCollection new.! !


!ReceptiveAccount methodsFor: 'transactions' stamp: 'HernanWilkinson 7/13/2011 18:37'!
register: aTransaction

	transactions add: aTransaction 
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
