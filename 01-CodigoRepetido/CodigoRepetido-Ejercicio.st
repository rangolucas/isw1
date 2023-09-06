!classDefinition: #CantSuspend category: 'CodigoRepetido-Ejercicio'!
Error subclass: #CantSuspend
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CodigoRepetido-Ejercicio'!


!classDefinition: #NotFound category: 'CodigoRepetido-Ejercicio'!
Error subclass: #NotFound
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CodigoRepetido-Ejercicio'!


!classDefinition: #CustomerBookTest category: 'CodigoRepetido-Ejercicio'!
TestCase subclass: #CustomerBookTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CodigoRepetido-Ejercicio'!

!CustomerBookTest methodsFor: 'testing' stamp: 'LR 9/5/2023 20:23:54'!
assertThat: aForbiddenAction failsWith: anError andThen: postCondition
	
	[ aForbiddenAction value.
	self fail ]
		on: anError 
		do: postCondition
! !

!CustomerBookTest methodsFor: 'testing' stamp: 'LR 9/5/2023 20:49:52'!
assertThat: aCustomerBook 
hasTotalCustomers: totalCount 
ofWhichActive: activeCount
andSuspended: suspendedCount

	self assert: activeCount equals: aCustomerBook numberOfActiveCustomers.
	self assert: suspendedCount equals: aCustomerBook numberOfSuspendedCustomers.
	self assert: totalCount equals: aCustomerBook numberOfCustomers.


	
! !

!CustomerBookTest methodsFor: 'testing' stamp: 'LR 9/5/2023 21:03:02'!
assertThat: aCustomerBook onlyContainsACustomerNamed: aCustomerName
	self assert: aCustomerBook numberOfCustomers = 1.
	self assert: (aCustomerBook includesCustomerNamed: aCustomerName).
! !

!CustomerBookTest methodsFor: 'testing' stamp: 'LR 9/4/2023 18:53:44'!
assertThat: actionToMeasure takesLessThan: maximumDuration

	| millisecondsBeforeRunning millisecondsAfterRunning |
	
	millisecondsBeforeRunning := Time millisecondClockValue * millisecond.
	actionToMeasure value.
	millisecondsAfterRunning := Time millisecondClockValue * millisecond.
	
	self assert: (millisecondsAfterRunning-millisecondsBeforeRunning) < (maximumDuration)
	
! !

!CustomerBookTest methodsFor: 'testing' stamp: 'LR 9/4/2023 18:50:34'!
test01AddingCustomerShouldNotTakeMoreThan50Milliseconds

	| customerBook |
	
	customerBook := CustomerBook new.
	
	self assertThat: [customerBook addCustomerNamed: 'John Lennon'.] takesLessThan: 50 * millisecond
	
! !

!CustomerBookTest methodsFor: 'testing' stamp: 'LR 9/5/2023 20:56:46'!
test02RemovingCustomerShouldNotTakeMoreThan100Milliseconds

	| customerBook paulMcCartney |
	paulMcCartney := 'Paul McCartney'.
	customerBook := self createCustomerBookWithCustomerNamed: paulMcCartney.
	  
	self assertThat: [customerBook removeCustomerNamed: paulMcCartney] takesLessThan: 100 * millisecond
! !

!CustomerBookTest methodsFor: 'testing' stamp: 'LR 9/5/2023 20:26:06'!
test03CanNotAddACustomerWithEmptyName 

	| customerBook |
			
	customerBook := CustomerBook new.

	self
		assertThat: [ customerBook addCustomerNamed: '' ]
		failsWith: Error
		andThen: [ :anError | 
			self assert: anError messageText = CustomerBook customerCanNotBeEmptyErrorMessage.
			self assert: customerBook isEmpty 
		]! !

!CustomerBookTest methodsFor: 'testing' stamp: 'LR 9/5/2023 21:04:18'!
test04CanNotRemoveAnInvalidCustomer
	
	| customerBook johnLennon |
	johnLennon := 'John Lennon'.
	customerBook :=  self createCustomerBookWithCustomerNamed: johnLennon.
	
	self
		assertThat: [ customerBook removeCustomerNamed: 'Paul McCartney' ]
		failsWith: NotFound 
		andThen: [ self assertThat: customerBook onlyContainsACustomerNamed: johnLennon ]
! !

!CustomerBookTest methodsFor: 'testing' stamp: 'LR 9/5/2023 20:50:51'!
test05SuspendingACustomerShouldNotRemoveItFromCustomerBook

	| customerBook paulMcCartney|
	
	paulMcCartney := 'Paul McCartney'.
	customerBook := self createCustomerBookWithSuspendedCustomerNamed: paulMcCartney.
	
	self assertThat: customerBook hasTotalCustomers: 1 ofWhichActive: 0 andSuspended: 1.
	self assert: (customerBook includesCustomerNamed: paulMcCartney).
	

	
! !

!CustomerBookTest methodsFor: 'testing' stamp: 'LR 9/5/2023 20:51:10'!
test06RemovingASuspendedCustomerShouldRemoveItFromCustomerBook

	| customerBook paulMcCartney|
	
	paulMcCartney := 'Paul McCartney'.
	customerBook := self createCustomerBookWithSuspendedCustomerNamed: paulMcCartney.
	customerBook removeCustomerNamed: paulMcCartney.
	
	self assertThat: customerBook hasTotalCustomers: 0 ofWhichActive: 0 andSuspended: 0.
	self deny: (customerBook includesCustomerNamed: paulMcCartney).


	
! !

!CustomerBookTest methodsFor: 'testing' stamp: 'LR 9/5/2023 21:04:58'!
test07CanNotSuspendAnInvalidCustomer
	
	| customerBook johnLennon |
	johnLennon := 'John Lennon'.
	customerBook := self createCustomerBookWithCustomerNamed: johnLennon.
	
	self 
		assertThat: [ customerBook suspendCustomerNamed: 'George Harrison' ]
		failsWith: CantSuspend 
		andThen: [ self assertThat: customerBook onlyContainsACustomerNamed: johnLennon ]
! !

!CustomerBookTest methodsFor: 'testing' stamp: 'LR 9/5/2023 21:07:31'!
test08CanNotSuspendAnAlreadySuspendedCustomer
	
	| customerBook johnLennon |
	johnLennon := 'John Lennon'.
	customerBook := self createCustomerBookWithSuspendedCustomerNamed: johnLennon.
	
	self 
		assertThat: [ customerBook suspendCustomerNamed: johnLennon ]
		failsWith: CantSuspend 
		andThen: [ self assertThat: customerBook onlyContainsACustomerNamed: johnLennon ]
! !


!CustomerBookTest methodsFor: 'initialization' stamp: 'LR 9/5/2023 20:53:11'!
createCustomerBookWithCustomerNamed: aCustomerName

	| customerBook |
	
	customerBook := CustomerBook new.
	
	customerBook addCustomerNamed: aCustomerName.
	
	^customerBook


	
! !

!CustomerBookTest methodsFor: 'initialization' stamp: 'LR 9/5/2023 20:55:00'!
createCustomerBookWithSuspendedCustomerNamed: aCustomerName

	| customerBook |
	
	customerBook := self createCustomerBookWithCustomerNamed: aCustomerName.	
	customerBook suspendCustomerNamed: aCustomerName.
	^customerBook


	
! !


!classDefinition: #CustomerBook category: 'CodigoRepetido-Ejercicio'!
Object subclass: #CustomerBook
	instanceVariableNames: 'suspended active'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CodigoRepetido-Ejercicio'!

!CustomerBook methodsFor: 'testing' stamp: 'NR 4/3/2019 10:14:26'!
includesCustomerNamed: aName

	^(active includes: aName) or: [ suspended includes: aName ]! !

!CustomerBook methodsFor: 'testing' stamp: 'NR 4/3/2019 10:14:26'!
isEmpty
	
	^active isEmpty and: [ suspended isEmpty ]! !


!CustomerBook methodsFor: 'initialization' stamp: 'NR 9/17/2020 07:23:04'!
initialize

	active := OrderedCollection new.
	suspended:= OrderedCollection new.! !


!CustomerBook methodsFor: 'customer management' stamp: 'NR 4/3/2019 10:14:26'!
addCustomerNamed: aName

	aName isEmpty ifTrue: [ self signalCustomerNameCannotBeEmpty ].
	((active includes: aName) or: [suspended includes: aName]) ifTrue: [ self signalCustomerAlreadyExists ].
	
	active add: aName ! !

!CustomerBook methodsFor: 'customer management' stamp: 'NR 4/3/2019 10:14:26'!
numberOfActiveCustomers
	
	^active size! !

!CustomerBook methodsFor: 'customer management' stamp: 'NR 4/3/2019 10:14:26'!
numberOfCustomers
	
	^active size + suspended size! !

!CustomerBook methodsFor: 'customer management' stamp: 'NR 9/19/2018 17:36:09'!
numberOfSuspendedCustomers
	
	^suspended size! !

!CustomerBook methodsFor: 'customer management' stamp: 'NR 4/3/2019 10:14:26'!
removeCustomerNamed: aName 
 
	1 to: active size do: 
	[ :index |
		aName = (active at: index)
			ifTrue: [
				active removeAt: index.
				^ aName 
			] 
	].

	1 to: suspended size do: 	
	[ :index |
		aName = (suspended at: index)
			ifTrue: [
				suspended removeAt: index.
				^ aName 
			] 
	].
	
	^ NotFound signal.
! !

!CustomerBook methodsFor: 'customer management' stamp: 'HernanWilkinson 7/6/2011 17:52'!
signalCustomerAlreadyExists 

	self error: self class customerAlreadyExistsErrorMessage! !

!CustomerBook methodsFor: 'customer management' stamp: 'HernanWilkinson 7/6/2011 17:51'!
signalCustomerNameCannotBeEmpty 

	self error: self class customerCanNotBeEmptyErrorMessage ! !

!CustomerBook methodsFor: 'customer management' stamp: 'NR 4/3/2019 10:14:26'!
suspendCustomerNamed: aName 
	
	(active includes: aName) ifFalse: [^CantSuspend signal].
	
	active remove: aName.
	
	suspended add: aName
! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CustomerBook class' category: 'CodigoRepetido-Ejercicio'!
CustomerBook class
	instanceVariableNames: ''!

!CustomerBook class methodsFor: 'error messages' stamp: 'NR 9/4/2023 17:02:48'!
customerAlreadyExistsErrorMessage

	^'Customer already exists!!!!!!'! !

!CustomerBook class methodsFor: 'error messages' stamp: 'NR 9/4/2023 17:02:52'!
customerCanNotBeEmptyErrorMessage

	^'Customer name cannot be empty!!!!!!'! !
