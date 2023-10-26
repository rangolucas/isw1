!classDefinition: #ExtensiveReportTest category: 'Portfolio-Solucion'!
TestCase subclass: #ExtensiveReportTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!ExtensiveReportTest methodsFor: 'nil' stamp: 'LR 10/26/2023 00:05:03'!
test01EmptyReport
	| report |
	report := (Portfolio named: 'mi portfolio') extensiveReport.
	self assert: report equals: 'mi portfolio\n\tBalance = 0'
	! !


!classDefinition: #PortfolioTest category: 'Portfolio-Solucion'!
TestCase subclass: #PortfolioTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:16:26'!
test01BalanceOfPortfolioWithoutAccountsIsZero

	self assert: 0 equals: Portfolio new balance! !

!PortfolioTest methodsFor: 'tests' stamp: 'NR 5/27/2021 17:36:04'!
test02BalanceOfPortfolioWithAccountsIsSumOfAccountsBalance

	| account portfolio |
	
	account := ReceptiveAccount new.
	Deposit register: 100 on: account.
	portfolio := Portfolio with: account.
	
	self assert: account balance equals: portfolio balance! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:23:25'!
test03BalanceOfPortfolioIsCalculatedRecursivelyOnPortfolios

	| simplePortfolioAccount simplePortfolio composedPortfolioAccount composedPortofolio |
	
	simplePortfolioAccount := ReceptiveAccount new.
	Deposit register: 100 on: simplePortfolioAccount.
	simplePortfolio := Portfolio with: simplePortfolioAccount.
	
	composedPortfolioAccount := ReceptiveAccount new.
	Withdraw register: 50 on: composedPortfolioAccount.
	composedPortofolio := Portfolio with: simplePortfolio with: composedPortfolioAccount.
	
	self assert: (composedPortfolioAccount balance + simplePortfolio balance) equals: composedPortofolio balance! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:43:15'!
test04PortfolioWithoutAccountsHasNoRegisteredTransaction

	self deny: (Portfolio new hasRegistered: (Deposit for: 100))! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:43:11'!
test05PortfolioHasRegisteredItsAccountsTransactions

	| account portfolio deposit |
	
	account := ReceptiveAccount new.
	deposit := Deposit register: 100 on: account.
	portfolio := Portfolio with: account.
	
	self assert: (portfolio hasRegistered: deposit)! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:58:06'!
test06PortfolioLooksForRegisteredTransactionsRecursively

	| simplePortfolioAccount simplePortfolio composedPortfolioAccount composedPortfolio composedPortfolioAccountWithdraw simplePortfolioAccountDeposit |
	
	simplePortfolioAccount := ReceptiveAccount new.
	simplePortfolioAccountDeposit := Deposit register: 100 on: simplePortfolioAccount.
	simplePortfolio := Portfolio with: simplePortfolioAccount.
	
	composedPortfolioAccount := ReceptiveAccount new.
	composedPortfolioAccountWithdraw := Withdraw register: 50 on: composedPortfolioAccount.
	composedPortfolio := Portfolio with: simplePortfolio with: composedPortfolioAccount.
	
	self assert: (composedPortfolio hasRegistered: simplePortfolioAccountDeposit).
	self assert: (composedPortfolio hasRegistered: composedPortfolioAccountWithdraw)! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:58:10'!
test07PortfolioHasNoTransactionWhenHasNoAccounts

	self assert: Portfolio new transactions isEmpty! !

!PortfolioTest methodsFor: 'tests' stamp: 'NR 6/22/2020 07:31:19'!
test08PortfolioTransactionsIncludesAllItsAccountsTransactions

	| account portfolio accountDeposit anotherAccount portfolioTransactions anotherAccountWithdraw |
	
	account := ReceptiveAccount new.
	accountDeposit := Deposit register: 100 on: account.
	anotherAccount := ReceptiveAccount new.
	anotherAccountWithdraw := Withdraw register: 100 on: account.
	portfolio := Portfolio with: account.
	
	portfolioTransactions := portfolio transactions.
	
	self assert: 2 equals: portfolioTransactions size.
	self assert: (portfolioTransactions includes: accountDeposit).
	self assert: (portfolioTransactions includes: anotherAccountWithdraw)! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:58:20'!
test09PortfolioTransactionsAreCalculatedRecursively

	| simplePortfolioAccount simplePortfolio composedPortfolioAccount composedPortfolio composedPortfolioAccountWithdraw simplePortfolioAccountDeposit composedPortfolioTransactions |
	
	simplePortfolioAccount := ReceptiveAccount new.
	simplePortfolioAccountDeposit := Deposit register: 100 on: simplePortfolioAccount.
	simplePortfolio := Portfolio with: simplePortfolioAccount.
	
	composedPortfolioAccount := ReceptiveAccount new.
	composedPortfolioAccountWithdraw := Withdraw register: 50 on: composedPortfolioAccount.
	composedPortfolio := Portfolio with: simplePortfolio with: composedPortfolioAccount.
	
	composedPortfolioTransactions := composedPortfolio transactions.
	self assert: 2 equals: composedPortfolioTransactions size.
	self assert: (composedPortfolioTransactions includes: simplePortfolioAccountDeposit).
	self assert: (composedPortfolioTransactions includes: composedPortfolioAccountWithdraw)! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:58:24'!
test10PortfolioCanNotIncludeTheSameAccountMoreThanOnce

	| account portfolio |
	
	account := ReceptiveAccount new.
	portfolio := Portfolio with: account.
	
	self 
		should: [ portfolio add: account ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: Portfolio canNotAddAccountErrorMessage equals: anError messageText.
			self assert: 1 equals: portfolio accountsSize.
			self assert: (portfolio accountsIncludes: account) ]! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:58:28'!
test11PortfolioCanNotIncludeAccountOfItsPortfolios

	| account simplePortfolio composedPortfolio |
	
	account := ReceptiveAccount new.
	simplePortfolio := Portfolio with: account.
	composedPortfolio := Portfolio with: simplePortfolio.
	
	self 
		should: [ composedPortfolio add: account ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: Portfolio canNotAddAccountErrorMessage equals: anError messageText.
			self assert: 1 equals: composedPortfolio accountsSize.
			self assert: (composedPortfolio accountsIncludes: simplePortfolio) ]! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:58:32'!
test12PortfolioCanNotIncludeItself

	| account simplePortfolio |
	
	account := ReceptiveAccount new.
	simplePortfolio := Portfolio with: account.
	
	self 
		should: [ simplePortfolio add: simplePortfolio ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: Portfolio canNotAddAccountErrorMessage equals: anError messageText.
			self assert: 1 equals: simplePortfolio accountsSize.
			self assert: (simplePortfolio accountsIncludes: account) ]! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 12:01:51'!
test13ComposedPortfolioCanNotHaveParentPortfolioAccount

	| account simplePortfolio composedPortfolio |
	
	account := ReceptiveAccount new.
	simplePortfolio := Portfolio new.
	composedPortfolio := Portfolio with: simplePortfolio.
	composedPortfolio add: account.
	
	self 
		should: [ simplePortfolio add: account ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: Portfolio canNotAddAccountErrorMessage equals: anError messageText.
			self assert: simplePortfolio accountsIsEmpty ]! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 12:12:16'!
test14ComposedPortfolioCanNotHaveAccountOfAnyRootParentRecursively

	| account leftParentPortfolio leftRootParentPortfolio portfolio rightParentPortfolio rightRootParentPortfolio |
	
	account := ReceptiveAccount new.
	portfolio := Portfolio new.
	leftParentPortfolio := Portfolio with: portfolio .
	leftRootParentPortfolio := Portfolio with: leftParentPortfolio.
	leftRootParentPortfolio add: account.
	
	rightParentPortfolio := Portfolio with: portfolio .
	rightRootParentPortfolio := Portfolio with: rightParentPortfolio.
	rightRootParentPortfolio add: account.

	self 
		should: [ portfolio add: account ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: Portfolio canNotAddAccountErrorMessage equals: anError messageText.
			self assert: portfolio accountsIsEmpty ]! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/29/2019 16:31:18'!
test15PortfolioCanNotIncludeAnyOfTheComposedAccountOfPortfolioToAdd

	| portfolioToAdd portfolioToModify rootPortfolio sharedAccount |
	
	sharedAccount := ReceptiveAccount new.
	portfolioToModify := Portfolio new.
	rootPortfolio := Portfolio with: sharedAccount with: portfolioToModify.
	portfolioToAdd := Portfolio with: sharedAccount.
	
	self 
		should: [ portfolioToModify add: portfolioToAdd ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError | 
			self assert: Portfolio canNotAddAccountErrorMessage equals: anError messageText.
			self assert: portfolioToModify accountsIsEmpty ]! !


!classDefinition: #ReceptiveAccountTest category: 'Portfolio-Solucion'!
TestCase subclass: #ReceptiveAccountTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'HAW 5/23/2019 15:19:48'!
test01ReceptiveAccountHaveZeroAsBalanceWhenCreated 

	| account |
	
	account := ReceptiveAccount new.

	self assert: 0 equals: account balance .
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'HAW 5/23/2019 15:19:54'!
test02DepositIncreasesBalanceOnTransactionValue 

	| account |
	
	account := ReceptiveAccount  new.
	Deposit register: 100 on: account.
		
	self assert: 100 equals: account balance .
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'HAW 5/23/2019 15:20:02'!
test03WithdrawDecreasesBalanceOnTransactionValue 

	| account |
	
	account := ReceptiveAccount new.
	Deposit register: 100 on: account.
	Withdraw register: 50 on: account.
		
	self assert: 50 equals: account balance .
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

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'HAW 5/23/2019 15:20:54'!
test06ReceptiveAccountDoNotKnowNotRegisteredTransactions

	| account deposit withdraw |
	
	account := ReceptiveAccount new.
	deposit :=  Deposit for: 100.
	withdraw := Withdraw for: 50.
		
	self deny: (account hasRegistered: deposit).
	self deny: (account hasRegistered:withdraw).
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'HAW 5/23/2019 15:21:24'!
test07AccountKnowsItsTransactions 

	| account1 deposit1 |
	
	account1 := ReceptiveAccount new.
	
	deposit1 := Deposit register: 100 on: account1.
		
	self assert: 1 equals: account1 transactions size .
	self assert: (account1 transactions includes: deposit1).
! !


!classDefinition: #TransferTest category: 'Portfolio-Solucion'!
TestCase subclass: #TransferTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!


!TransferTest methodsFor: 'as yet unclassified' stamp: 'BR 10/19/2023 21:43:11'!
assertAccount: anAccount hasBalance: potentialBalance
	self assert: anAccount balance equals: potentialBalance ! !

!TransferTest methodsFor: 'as yet unclassified' stamp: 'BR 10/21/2023 16:18:30'!
test01TransferTenDollars
	|senderAccount receiverAccount|
	
	senderAccount := ReceptiveAccount new.
	receiverAccount := ReceptiveAccount new.
	
	AccountTransfer from: senderAccount to: receiverAccount amount: 10.
	
	self assertAccount: senderAccount hasBalance: -10.
	self assertAccount: receiverAccount hasBalance: 10.! !

!TransferTest methodsFor: 'as yet unclassified' stamp: 'BR 10/21/2023 18:09:56'!
test03CanRecoverTransferValueFromDepositAndWithdraw
	|senderAccount receiverAccount aTransfer aDepositByTransfer aWithdrawByTransfer|
	
	senderAccount := ReceptiveAccount new.
	receiverAccount := ReceptiveAccount new.
	
	aTransfer := AccountTransfer from: senderAccount to: receiverAccount amount: 10.
	aDepositByTransfer := DepositTransfer by: aTransfer.
	aWithdrawByTransfer := WithdrawTransfer by: aTransfer.
	
	self assert: ((aDepositByTransfer transfer) = aTransfer).
	self assert: ((aWithdrawByTransfer transfer) = aTransfer).! !

!TransferTest methodsFor: 'as yet unclassified' stamp: 'BR 10/26/2023 02:01:14'!
test04TransferNetReportReturnsCorrectValue
	|anAccount anotherAccount|
	
	anAccount := ReceptiveAccount new.
	anotherAccount := ReceptiveAccount new.
	
	AccountTransfer from: anAccount to: anotherAccount amount: 10.
	AccountTransfer from: anAccount to: anotherAccount amount: 20.
	
	self assert: (TransferNet runOn: anAccount) equals: -30.! !

!TransferTest methodsFor: 'as yet unclassified' stamp: 'BR 10/26/2023 03:24:27'!
test05AccountSummaryReportReturnsCorrectValue
	|anAccount anotherAccount|
	
	anAccount := ReceptiveAccount new.
	anotherAccount := ReceptiveAccount new.
	
	AccountTransfer from: anAccount to: anotherAccount amount: 10.
	AccountTransfer from: anAccount to: anotherAccount amount: 20.
	
	self assert: (AccountSummary runOn: anAccount) = 'Salida por transferencia de 10. \nSalida por transferencia de 20. \nBalance = -30'.! !

!TransferTest methodsFor: 'as yet unclassified' stamp: 'BR 10/26/2023 03:24:04'!
test06AccountSummaryReportReturnsCorrectValue
	|anAccount anotherAccount|
	
	anAccount := ReceptiveAccount new.
	anotherAccount := ReceptiveAccount new.
	
	AccountTransfer from: anAccount to: anotherAccount amount: 10.
	AccountTransfer from: anAccount to: anotherAccount amount: 20.
	anAccount register: (Deposit for: 50).
	
	self assert: (AccountSummary runOn: anAccount) equals: 'Salida por transferencia de 10. \nSalida por transferencia de 20. \nDepósito por 50.\nBalance = 20'.! !

!TransferTest methodsFor: 'as yet unclassified' stamp: 'BR 10/26/2023 03:23:39'!
test07PortfolioSummaryReportReturnsCorrectValue

	| account portfolio deposit |
	
	account := ReceptiveAccount new.
	deposit := Deposit register: 100 on: account.
	portfolio := Portfolio with: account.
	
	self assert: (AccountSummary runOn: portfolio) equals: 'Depósito por 100.\nBalance = 100'! !

!TransferTest methodsFor: 'as yet unclassified' stamp: 'BR 10/26/2023 02:08:00'!
test08PortfolioTransferNetReportReturnsCorrectValue

	| account portfolio anotherAccount|
	
	account := ReceptiveAccount new.
	Deposit register: 100 on: account.
	portfolio := Portfolio with: account.
	
	anotherAccount := ReceptiveAccount new.
	AccountTransfer from: account to: anotherAccount amount: 10.
	
	self assert: (TransferNet runOn: portfolio) equals: -10! !

!TransferTest methodsFor: 'as yet unclassified' stamp: 'BR 10/26/2023 03:12:40'!
test09DepthTwoPortfolioTreeStructureReportReturnsCorrectValue

	| account portfolio anotherPortfolio|
	
	account := ReceptiveAccount named: 'unacuenta'.

	anotherPortfolio := Portfolio named: 'hijoportafolio' with: account.
	portfolio := Portfolio named: 'unportafolio' with: anotherPortfolio.
	
	
	self assert: (TreeStructureReport runOn: portfolio) equals: 'unportafolio\n\thijoportafolio\n\t\tunacuenta\n'! !

!TransferTest methodsFor: 'as yet unclassified' stamp: 'BR 10/26/2023 03:12:40'!
test10DepthThreePortfolioTreeStructureReportReturnsCorrectValue

	| account portfolio anotherPortfolio grandchildPortfolio|
	
	account := ReceptiveAccount named: 'unacuenta'.
	grandchildPortfolio := Portfolio named: 'nietoportfolio' with: account.
	anotherPortfolio := Portfolio named: 'hijoportafolio' with: grandchildPortfolio .
	portfolio := Portfolio named: 'unportafolio' with: anotherPortfolio.
	
	
	self assert: (TreeStructureReport runOn: portfolio) equals: 'unportafolio\n\thijoportafolio\n\t\tnietoportfolio\n\t\t\tunacuenta\n'! !


!classDefinition: #Account category: 'Portfolio-Solucion'!
Object subclass: #Account
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!Account methodsFor: 'testing' stamp: 'HAW 5/25/2019 12:23:47'!
hasRegistered: aTransaction

	self subclassResponsibility ! !

!Account methodsFor: 'testing' stamp: 'HAW 5/25/2019 12:24:25'!
isComposedBy: anAccount

	self subclassResponsibility ! !


!Account methodsFor: 'balance' stamp: 'HAW 5/25/2019 12:23:40'!
balance

	self subclassResponsibility ! !


!Account methodsFor: 'transactions' stamp: 'BR 10/22/2023 21:23:04'!
accountSummaryReport
	self subclassResponsibility ! !

!Account methodsFor: 'transactions' stamp: 'HAW 5/25/2019 12:23:27'!
addTransactionsTo: aCollectionOfTransactions

	self subclassResponsibility ! !

!Account methodsFor: 'transactions' stamp: 'HAW 5/25/2019 12:23:15'!
transactions

	self subclassResponsibility ! !

!Account methodsFor: 'transactions' stamp: 'BR 10/21/2023 18:24:10'!
transferNetReport
	self subclassResponsibility ! !


!Account methodsFor: 'composition' stamp: 'HAW 5/25/2019 12:24:04'!
addedTo: aPortfolio

	self subclassResponsibility ! !


!Account methodsFor: 'reports' stamp: 'BR 10/26/2023 03:12:07'!
doReport: aReport

	self subclassResponsibility! !

!Account methodsFor: 'reports' stamp: 'BR 10/26/2023 02:39:20'!
doTreeStructureReport: aReport

	self subclassResponsibility! !


!classDefinition: #Portfolio category: 'Portfolio-Solucion'!
Account subclass: #Portfolio
	instanceVariableNames: 'accounts parents name'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!Portfolio methodsFor: 'accounts management' stamp: 'HAW 5/25/2019 11:49:20'!
accountsIncludes: anAccount

	^accounts includes: anAccount ! !

!Portfolio methodsFor: 'accounts management' stamp: 'HAW 5/25/2019 12:05:04'!
accountsIsEmpty
	
	^accounts isEmpty ! !

!Portfolio methodsFor: 'accounts management' stamp: 'HAW 5/25/2019 11:49:06'!
accountsSize
	
	^accounts size! !

!Portfolio methodsFor: 'accounts management' stamp: 'HAW 5/25/2019 12:19:20'!
add: accountToAdd

	self assertCanAdd: accountToAdd.
		
	accounts add: accountToAdd.
	accountToAdd addedTo: self 
	! !

!Portfolio methodsFor: 'accounts management' stamp: 'BR 10/25/2023 14:09:06'!
name
	^name
	! !

!Portfolio methodsFor: 'accounts management' stamp: 'HAW 5/25/2019 12:17:31'!
rootParents
	
	| rootParents |
	
	rootParents := Set new.
	self addRootParentsTo: rootParents.
	
	^ rootParents! !


!Portfolio methodsFor: 'initialization' stamp: 'BR 10/25/2023 13:50:29'!
initialize

	accounts := OrderedCollection new.
	parents := OrderedCollection new.
	name := ''.! !

!Portfolio methodsFor: 'initialization' stamp: 'BR 10/25/2023 13:50:22'!
initializeWithName: aName

	accounts := OrderedCollection new.
	parents := OrderedCollection new.
	name := aName.! !


!Portfolio methodsFor: 'balance' stamp: 'HAW 5/25/2019 11:19:36'!
balance
	
	^accounts sum: [ :anAccount | anAccount balance ] ifEmpty: [ 0 ]! !


!Portfolio methodsFor: 'transactions' stamp: 'HAW 5/25/2019 11:42:55'!
addTransactionsTo: aCollectionOfTransactions

	accounts do: [ :anAccount | anAccount addTransactionsTo: aCollectionOfTransactions ]! !

!Portfolio methodsFor: 'transactions' stamp: 'HAW 5/25/2019 11:38:32'!
transactions
	
	| transactions |
	
	transactions := OrderedCollection new.
	accounts do: [ :anAccount | anAccount addTransactionsTo: transactions ].
	
	^transactions ! !


!Portfolio methodsFor: 'composition' stamp: 'HAW 5/25/2019 12:02:59'!
addedTo: aPortfolio 
	
	parents add: aPortfolio ! !


!Portfolio methodsFor: 'testing' stamp: 'HAW 5/25/2019 12:20:56'!
anyRootParentIsComposedBy: accountToAdd

	^self rootParents anySatisfy: [ :aParent | aParent isComposedBy: accountToAdd]! !

!Portfolio methodsFor: 'testing' stamp: 'HAW 5/25/2019 11:28:29'!
hasRegistered: aTransaction

	^accounts anySatisfy: [ :anAccount | anAccount hasRegistered: aTransaction ]! !

!Portfolio methodsFor: 'testing' stamp: 'HAW 5/29/2019 16:24:54'!
isComposedBy: anAccount

	^ self = anAccount or: [ accounts anySatisfy: [ :composedAccount | (composedAccount isComposedBy: anAccount) or: [ anAccount isComposedBy: composedAccount ]]]! !


!Portfolio methodsFor: 'account management - private' stamp: 'HAW 5/25/2019 12:17:31'!
addRootParentsTo: rootParents

	parents 
		ifEmpty: [ rootParents add: self ] 
		ifNotEmpty: [ parents do: [ :aParent | aParent addRootParentsTo: rootParents ]]! !

!Portfolio methodsFor: 'account management - private' stamp: 'HAW 5/25/2019 12:20:36'!
assertCanAdd: accountToAdd

	(self anyRootParentIsComposedBy: accountToAdd) ifTrue: [ self signalCanNotAddAccount ].
! !

!Portfolio methodsFor: 'account management - private' stamp: 'HAW 5/25/2019 11:48:34'!
signalCanNotAddAccount
	
	self error: self class canNotAddAccountErrorMessage! !


!Portfolio methodsFor: 'reports' stamp: 'BR 10/26/2023 02:05:40'!
doReport: aReport

	accounts do: [
			:account| 
				account doReport: aReport
			].
! !

!Portfolio methodsFor: 'reports' stamp: 'BR 10/26/2023 02:45:56'!
doTreeStructureReport: aReport 
	aReport processPortfolio: name withAccounts: accounts.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Portfolio class' category: 'Portfolio-Solucion'!
Portfolio class
	instanceVariableNames: ''!

!Portfolio class methodsFor: 'as yet unclassified' stamp: 'HAW 5/25/2019 11:48:55'!
canNotAddAccountErrorMessage
	
	^'Can not add repeated account to a portfolio'! !

!Portfolio class methodsFor: 'as yet unclassified' stamp: 'BR 10/25/2023 13:53:11'!
named: aName with: anAccount

	^(self new initializeWithName: aName) 
		add: anAccount;
		yourself! !

!Portfolio class methodsFor: 'as yet unclassified' stamp: 'BR 10/25/2023 13:52:56'!
named: aName with: anAccount with: anotherAccount

	^(self new initializeWithName: aName)
		add: anAccount;
		add: anotherAccount;
		yourself! !

!Portfolio class methodsFor: 'as yet unclassified' stamp: 'HAW 5/25/2019 11:18:21'!
with: anAccount

	^self new 
		add: anAccount;
		yourself! !

!Portfolio class methodsFor: 'as yet unclassified' stamp: 'HAW 5/25/2019 11:23:59'!
with: anAccount with: anotherAccount

	^self new 
		add: anAccount;
		add: anotherAccount;
		yourself! !


!classDefinition: #ReceptiveAccount category: 'Portfolio-Solucion'!
Account subclass: #ReceptiveAccount
	instanceVariableNames: 'transactions name'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!ReceptiveAccount methodsFor: 'initialization' stamp: 'BR 10/25/2023 13:49:50'!
initialize

	super initialize.
	transactions := OrderedCollection new.
	name := ''.
	! !

!ReceptiveAccount methodsFor: 'initialization' stamp: 'BR 10/25/2023 13:49:25'!
initializeWithName: aName

	super initialize.
	transactions := OrderedCollection new.
	name := aName.
	! !


!ReceptiveAccount methodsFor: 'transactions' stamp: 'HAW 5/25/2019 11:38:52'!
addTransactionsTo: aCollectionOfTransactions

	aCollectionOfTransactions addAll: transactions ! !

!ReceptiveAccount methodsFor: 'transactions' stamp: 'BR 10/23/2023 20:21:02'!
register: aTransaction

	transactions add: aTransaction.! !

!ReceptiveAccount methodsFor: 'transactions' stamp: 'HernanWilkinson 7/13/2011 18:37'!
transactions 

	^ transactions copy! !


!ReceptiveAccount methodsFor: 'balance' stamp: 'HAW 5/25/2019 11:24:46'!
balance

	^transactions 
		inject: 0
		into: [ :currentBalance :transaction | transaction affectBalance: currentBalance ]! !


!ReceptiveAccount methodsFor: 'testing' stamp: 'NR 10/21/2019 18:55:56'!
hasRegistered: aTransaction

	^ transactions includes: aTransaction 
! !

!ReceptiveAccount methodsFor: 'testing' stamp: 'HAW 5/25/2019 11:54:51'!
isComposedBy: anAccount

	^self = anAccount ! !

!ReceptiveAccount methodsFor: 'testing' stamp: 'BR 10/25/2023 14:09:20'!
name
	^name! !


!ReceptiveAccount methodsFor: 'composition' stamp: 'HAW 5/25/2019 12:03:32'!
addedTo: aPortfolio 
	
	! !


!ReceptiveAccount methodsFor: 'reports' stamp: 'BR 10/26/2023 01:38:02'!
doReport: aReport
	
	transactions do: [
			:transaction| 
				transaction acceptReport: aReport
			].
		
	
		
	
	
	
	! !

!ReceptiveAccount methodsFor: 'reports' stamp: 'BR 10/26/2023 02:43:09'!
doTreeStructureReport: aReport 
	aReport processReceptiveAccount: name! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ReceptiveAccount class' category: 'Portfolio-Solucion'!
ReceptiveAccount class
	instanceVariableNames: ''!

!ReceptiveAccount class methodsFor: 'as yet unclassified' stamp: 'BR 10/25/2023 14:13:33'!
named: aName
	^self new initializeWithName: aName.! !


!classDefinition: #AccountTransaction category: 'Portfolio-Solucion'!
Object subclass: #AccountTransaction
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!AccountTransaction methodsFor: 'value' stamp: 'LR 10/26/2023 00:43:35'!
acceptReport: report

	self subclassResponsibility! !

!AccountTransaction methodsFor: 'value' stamp: 'LR 10/26/2023 00:29:36'!
doAccountSummaryAppliedTo: accum

	self subclassResponsibility! !

!AccountTransaction methodsFor: 'value' stamp: 'LR 10/26/2023 00:29:42'!
doTransferNetAppliedTo: accum

	self subclassResponsibility! !

!AccountTransaction methodsFor: 'value' stamp: 'HernanWilkinson 9/12/2011 12:25'!
value 

	self subclassResponsibility ! !


!AccountTransaction methodsFor: 'balance' stamp: 'HAW 5/25/2019 11:25:39'!
affectBalance: aBalance

	self subclassResponsibility ! !

!AccountTransaction methodsFor: 'balance' stamp: 'LR 10/26/2023 00:29:51'!
parseReport: aReport appliedTo: accum

	self subclassResponsibility! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'AccountTransaction class' category: 'Portfolio-Solucion'!
AccountTransaction class
	instanceVariableNames: ''!

!AccountTransaction class methodsFor: 'instance creation' stamp: 'NR 10/21/2019 18:54:27'!
register: aValue on: account

	| transaction |
	
	transaction := self for: aValue.
	account register: transaction.
		
	^ transaction! !


!classDefinition: #Deposit category: 'Portfolio-Solucion'!
AccountTransaction subclass: #Deposit
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!Deposit methodsFor: 'initialization' stamp: 'HernanWilkinson 7/13/2011 18:45'!
initializeFor: aValue

	value := aValue ! !


!Deposit methodsFor: 'value' stamp: 'BR 10/25/2023 01:13:39'!
doAccountSummaryAppliedTo: accum
	^accum, 'Depósito por ', (value) asString, '. '! !

!Deposit methodsFor: 'value' stamp: 'BR 10/25/2023 01:13:06'!
doTransferNetAppliedTo: accum
	^accum! !

!Deposit methodsFor: 'value' stamp: 'HernanWilkinson 7/13/2011 18:38'!
value

	^ value! !


!Deposit methodsFor: 'balance' stamp: 'HAW 5/25/2019 11:25:02'!
affectBalance: aBalance

	^aBalance + value ! !

!Deposit methodsFor: 'balance' stamp: 'BR 10/25/2023 01:06:32'!
parseReport: aReport appliedTo: accum
	^aReport useAsInput: self appliedTo: accum.! !


!Deposit methodsFor: 'nil' stamp: 'BR 10/26/2023 01:47:41'!
acceptReport: report
	report processDeposit: (self value)! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Deposit class' category: 'Portfolio-Solucion'!
Deposit class
	instanceVariableNames: ''!

!Deposit class methodsFor: 'instance creation' stamp: 'HernanWilkinson 7/13/2011 18:38'!
for: aValue

	^ self new initializeFor: aValue ! !


!classDefinition: #DepositTransfer category: 'Portfolio-Solucion'!
AccountTransaction subclass: #DepositTransfer
	instanceVariableNames: 'transfer'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!DepositTransfer methodsFor: 'as yet unclassified' stamp: 'LR 10/26/2023 00:27:34'!
affectBalance: aBalance
	^aBalance + (self value)! !

!DepositTransfer methodsFor: 'as yet unclassified' stamp: 'LR 10/26/2023 00:27:23'!
doAccountSummaryAppliedTo: accum
	^accum, 'Entrada por transferencia de ', (self value) asString, '. '! !

!DepositTransfer methodsFor: 'as yet unclassified' stamp: 'LR 10/26/2023 00:27:29'!
doTransferNetAppliedTo: accum
	^accum + self value! !

!DepositTransfer methodsFor: 'as yet unclassified' stamp: 'BR 10/21/2023 17:31:39'!
initializeBy: aTransfer
	transfer := aTransfer.! !

!DepositTransfer methodsFor: 'as yet unclassified' stamp: 'BR 10/21/2023 17:57:36'!
transfer
	^transfer! !


!DepositTransfer methodsFor: 'balance' stamp: 'BR 10/25/2023 01:06:47'!
parseReport: aReport appliedTo: accum
	^aReport useAsInput: self appliedTo: accum.! !


!DepositTransfer methodsFor: 'nil' stamp: 'BR 10/26/2023 01:47:53'!
acceptReport: report
	report processDepositTransfer: self value! !

!DepositTransfer methodsFor: 'nil' stamp: 'LR 10/26/2023 00:29:05'!
value
	^transfer value! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'DepositTransfer class' category: 'Portfolio-Solucion'!
DepositTransfer class
	instanceVariableNames: ''!

!DepositTransfer class methodsFor: 'as yet unclassified' stamp: 'BR 10/22/2023 23:33:31'!
by: aTransfer
	^self new initializeBy: aTransfer.! !


!classDefinition: #Withdraw category: 'Portfolio-Solucion'!
AccountTransaction subclass: #Withdraw
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!Withdraw methodsFor: 'initialization' stamp: 'HernanWilkinson 7/13/2011 18:46'!
initializeFor: aValue

	value := aValue ! !


!Withdraw methodsFor: 'value' stamp: 'BR 10/25/2023 01:14:44'!
doAccountSummaryAppliedTo: accum
	^accum, 'Extracción por ', (value) asString, '. '! !

!Withdraw methodsFor: 'value' stamp: 'BR 10/25/2023 01:14:57'!
doTransferNetAppliedTo: accum
	^accum! !

!Withdraw methodsFor: 'value' stamp: 'HernanWilkinson 7/13/2011 18:33'!
value

	^ value! !


!Withdraw methodsFor: 'balance' stamp: 'HAW 5/25/2019 11:25:15'!
affectBalance: aBalance

	^aBalance - value! !

!Withdraw methodsFor: 'balance' stamp: 'BR 10/25/2023 01:06:56'!
parseReport: aReport appliedTo: accum
	^aReport useAsInput: self appliedTo: accum.! !


!Withdraw methodsFor: 'nil' stamp: 'BR 10/26/2023 01:47:57'!
acceptReport: report
	report processWithdraw: self value! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Withdraw class' category: 'Portfolio-Solucion'!
Withdraw class
	instanceVariableNames: ''!

!Withdraw class methodsFor: 'instance creation' stamp: 'HernanWilkinson 7/13/2011 18:33'!
for: aValue

	^ self new initializeFor: aValue ! !


!classDefinition: #WithdrawTransfer category: 'Portfolio-Solucion'!
AccountTransaction subclass: #WithdrawTransfer
	instanceVariableNames: 'transfer'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!WithdrawTransfer methodsFor: 'as yet unclassified' stamp: 'LR 10/26/2023 00:28:24'!
affectBalance: aBalance
	^aBalance - (self value)! !

!WithdrawTransfer methodsFor: 'as yet unclassified' stamp: 'LR 10/26/2023 00:27:13'!
doAccountSummaryAppliedTo: accum
	^accum, 'Salida por transferencia de ', (self value) asString, '. '! !

!WithdrawTransfer methodsFor: 'as yet unclassified' stamp: 'LR 10/26/2023 00:28:38'!
doTransferNetAppliedTo: accum
	^accum - (self value)! !

!WithdrawTransfer methodsFor: 'as yet unclassified' stamp: 'BR 10/21/2023 17:31:00'!
initializeBy: aTransfer
	transfer := aTransfer.! !

!WithdrawTransfer methodsFor: 'as yet unclassified' stamp: 'BR 10/21/2023 17:57:26'!
transfer
	^transfer! !

!WithdrawTransfer methodsFor: 'as yet unclassified' stamp: 'LR 10/26/2023 00:28:56'!
value
	^transfer value! !


!WithdrawTransfer methodsFor: 'balance' stamp: 'BR 10/25/2023 01:07:05'!
parseReport: aReport appliedTo: accum
	^aReport useAsInput: self appliedTo: accum.! !


!WithdrawTransfer methodsFor: 'nil' stamp: 'BR 10/26/2023 01:48:02'!
acceptReport: report
	report processWithdrawTransfer: self value! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'WithdrawTransfer class' category: 'Portfolio-Solucion'!
WithdrawTransfer class
	instanceVariableNames: ''!

!WithdrawTransfer class methodsFor: 'as yet unclassified' stamp: 'BR 10/22/2023 23:33:24'!
by: aTransfer
	^self new initializeBy: aTransfer.! !


!classDefinition: #AccountTransfer category: 'Portfolio-Solucion'!
Object subclass: #AccountTransfer
	instanceVariableNames: 'deposit withdraw value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!AccountTransfer methodsFor: 'nil' stamp: 'BR 10/21/2023 18:03:52'!
depositLeg
	^deposit! !

!AccountTransfer methodsFor: 'nil' stamp: 'BR 10/21/2023 18:03:09'!
extractFrom: senderAccount sendTo: receiverAccount amount: transferredAmount
	withdraw := WithdrawTransfer by: self.
	deposit := DepositTransfer by: self.
	value := transferredAmount.
	
	senderAccount register: withdraw.
	receiverAccount register: deposit.
	! !

!AccountTransfer methodsFor: 'nil' stamp: 'BR 10/21/2023 17:38:04'!
value
	^value.
	! !

!AccountTransfer methodsFor: 'nil' stamp: 'BR 10/21/2023 18:03:38'!
withdrawLeg
	^withdraw! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'AccountTransfer class' category: 'Portfolio-Solucion'!
AccountTransfer class
	instanceVariableNames: ''!

!AccountTransfer class methodsFor: 'nil' stamp: 'BR 10/22/2023 23:32:30'!
from: senderAccount to: receiverAccount amount: transferredAmount
	^self new extractFrom: senderAccount sendTo: receiverAccount amount: transferredAmount! !


!classDefinition: #Report category: 'Portfolio-Solucion'!
Object subclass: #Report
	instanceVariableNames: 'account lines'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!Report methodsFor: 'as yet unclassified' stamp: 'BR 10/26/2023 01:54:23'!
processDeposit: depositValue

	self subclassResponsibility! !

!Report methodsFor: 'as yet unclassified' stamp: 'BR 10/26/2023 01:56:43'!
processDepositTransfer: depositTransferValue

	self subclassResponsibility! !

!Report methodsFor: 'as yet unclassified' stamp: 'BR 10/26/2023 01:54:40'!
processWithdraw: withdrawValue

	self subclassResponsibility! !

!Report methodsFor: 'as yet unclassified' stamp: 'BR 10/26/2023 01:54:45'!
processWithdrawTransfer: withdrawTransferValue

	self subclassResponsibility! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Report class' category: 'Portfolio-Solucion'!
Report class
	instanceVariableNames: ''!

!Report class methodsFor: 'as yet unclassified' stamp: 'BR 10/26/2023 01:35:59'!
constructOn: anAccount

	self subclassResponsibility! !


!classDefinition: #AccountSummary category: 'Portfolio-Solucion'!
Report subclass: #AccountSummary
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!AccountSummary methodsFor: 'as yet unclassified' stamp: 'BR 10/26/2023 01:43:02'!
initialize
	lines := ''! !

!AccountSummary methodsFor: 'as yet unclassified' stamp: 'BR 10/26/2023 01:54:23'!
processDeposit: depositValue
	lines := lines, 'Depósito por ', (depositValue asString), '.','\n'! !

!AccountSummary methodsFor: 'as yet unclassified' stamp: 'BR 10/26/2023 01:46:09'!
processDepositTransfer: depositTransferValue
	lines := lines , 'Entrada por transferencia de ', (depositTransferValue asString), '. ','\n'.! !

!AccountSummary methodsFor: 'as yet unclassified' stamp: 'BR 10/26/2023 01:46:20'!
processWithdraw: withdrawValue
	lines := lines, 'Extracción por ', (withdrawValue asString), '. ', '\n'! !

!AccountSummary methodsFor: 'as yet unclassified' stamp: 'BR 10/26/2023 01:46:34'!
processWithdrawTransfer: withdrawTransferValue
	lines := lines, 'Salida por transferencia de ', (withdrawTransferValue asString), '. ', '\n'.! !

!AccountSummary methodsFor: 'as yet unclassified' stamp: 'BR 10/26/2023 03:21:29'!
runOn: anAccount
	
	anAccount doReport: self.
	^lines, 'Balance = ', (anAccount balance) asString.! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'AccountSummary class' category: 'Portfolio-Solucion'!
AccountSummary class
	instanceVariableNames: ''!

!AccountSummary class methodsFor: 'as yet unclassified' stamp: 'BR 10/26/2023 01:42:43'!
runOn: anAccount

	^(self new runOn: anAccount)! !


!classDefinition: #ExtensiveReport category: 'Portfolio-Solucion'!
Report subclass: #ExtensiveReport
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!ExtensiveReport methodsFor: 'as yet unclassified' stamp: 'BR 10/26/2023 01:36:32'!
initializeOn: anAccount
	account := anAccount.! !

!ExtensiveReport methodsFor: 'as yet unclassified' stamp: 'BR 10/26/2023 01:54:23'!
processDeposit: depositValue
	lines := lines, 'Depósito por ', (depositValue asString), '.','\n'! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ExtensiveReport class' category: 'Portfolio-Solucion'!
ExtensiveReport class
	instanceVariableNames: ''!

!ExtensiveReport class methodsFor: 'as yet unclassified' stamp: 'BR 10/26/2023 03:15:22'!
runOn: anAccount
	^self new initializeOn: anAccount.! !


!classDefinition: #TransferNet category: 'Portfolio-Solucion'!
Report subclass: #TransferNet
	instanceVariableNames: 'transferNetResult'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!TransferNet methodsFor: 'as yet unclassified' stamp: 'BR 10/26/2023 02:01:43'!
initialize
	transferNetResult := 0.! !

!TransferNet methodsFor: 'as yet unclassified' stamp: 'BR 10/26/2023 01:57:11'!
processDeposit: depositValue
! !

!TransferNet methodsFor: 'as yet unclassified' stamp: 'BR 10/26/2023 01:57:27'!
processDepositTransfer: depositTransferValue

	transferNetResult := transferNetResult + depositTransferValue ! !

!TransferNet methodsFor: 'as yet unclassified' stamp: 'BR 10/26/2023 01:58:08'!
processWithdraw: withdrawValue
! !

!TransferNet methodsFor: 'as yet unclassified' stamp: 'BR 10/26/2023 01:57:48'!
processWithdrawTransfer: withdrawTransferValue

	transferNetResult := transferNetResult - withdrawTransferValue ! !

!TransferNet methodsFor: 'as yet unclassified' stamp: 'BR 10/26/2023 01:59:02'!
runOn: anAccount
	
	anAccount doReport: self.
	^transferNetResult
	! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TransferNet class' category: 'Portfolio-Solucion'!
TransferNet class
	instanceVariableNames: ''!

!TransferNet class methodsFor: 'as yet unclassified' stamp: 'BR 10/26/2023 01:59:42'!
runOn: anAccount

	^(self new runOn: anAccount)! !


!classDefinition: #TreeStructureReport category: 'Portfolio-Solucion'!
Object subclass: #TreeStructureReport
	instanceVariableNames: 'indentedLines margin'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!TreeStructureReport methodsFor: 'as yet unclassified' stamp: 'BR 10/26/2023 02:30:11'!
initialize
	indentedLines := ''! !

!TreeStructureReport methodsFor: 'as yet unclassified' stamp: 'BR 10/26/2023 03:12:40'!
processPortfolio: aName withAccounts: accounts
	indentedLines := indentedLines, aName, '\n'.
	accounts do: [:account | indentedLines := indentedLines , (TreeStructureReport runOn: account withMargin: (margin, '\t'))] ! !

!TreeStructureReport methodsFor: 'as yet unclassified' stamp: 'BR 10/26/2023 02:46:51'!
processReceptiveAccount: aName
	indentedLines := indentedLines, aName, '\n'.! !

!TreeStructureReport methodsFor: 'as yet unclassified' stamp: 'BR 10/26/2023 03:01:07'!
runOn: aPortfolio withMargin: aString

	margin := aString.
	aPortfolio doTreeStructureReport: self.
	^margin, indentedLines! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TreeStructureReport class' category: 'Portfolio-Solucion'!
TreeStructureReport class
	instanceVariableNames: ''!

!TreeStructureReport class methodsFor: 'as yet unclassified' stamp: 'BR 10/26/2023 03:12:40'!
runOn: anAccount 
	^TreeStructureReport runOn: anAccount withMargin: ''.! !

!TreeStructureReport class methodsFor: 'as yet unclassified' stamp: 'BR 10/26/2023 03:03:14'!
runOn: anAccount withMargin: aString
	^self new runOn: anAccount withMargin: aString.! !
