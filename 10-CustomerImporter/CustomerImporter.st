!classDefinition: #PersistentSet category: 'CustomerImporter'!
Set subclass: #PersistentSet
	instanceVariableNames: 'session'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!PersistentSet methodsFor: 'initialization' stamp: 'HAW 11/14/2023 08:25:31'!
initializeOn: aSession from: aNonPersistentSet

	session := aSession.
	self addAll: aNonPersistentSet ! !


!PersistentSet methodsFor: 'adding' stamp: 'HAW 11/14/2023 08:23:40'!
add: newObject

	super add: newObject.
	session persist: newObject.
	
	^newObject! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'PersistentSet class' category: 'CustomerImporter'!
PersistentSet class
	instanceVariableNames: ''!

!PersistentSet class methodsFor: 'instance creation' stamp: 'HAW 11/14/2023 08:24:32'!
on: aSession

	^self on: aSession from: #()! !

!PersistentSet class methodsFor: 'instance creation' stamp: 'HAW 11/14/2023 08:25:00'!
on: aSession from: aNonPersistentSet

	^self new initializeOn: aSession from: aNonPersistentSet
! !


!classDefinition: #ImportTest category: 'CustomerImporter'!
TestCase subclass: #ImportTest
	instanceVariableNames: 'session customerSystem'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!ImportTest methodsFor: 'tests' stamp: 'BR 11/16/2023 20:09:23'!
test01ImportCorrectDataFromCsv

	CustomerImporter valueFrom: self validImportData into: session..

	self assertImportedRightNumberOfCustomers.
	self assertPepeSanchezWasImportedCorrecty.
	self assertJuanPerezWasImportedCorrectly ! !

!ImportTest methodsFor: 'tests' stamp: 'BR 11/20/2023 15:22:37'!
test02CannotImportCustomerRegisterWithMoreOrLessThan5Fields
	
	self should:[
			CustomerImporter valueFrom: (ReadStream on: 'C,Pepe,Sanchez,D,22333444,x') into: session..
		] 
	raise: Error - MessageNotUnderstood
	withExceptionDo: [:error |
						self assert: error messageText = CustomerImporter invalidNumberOfFieldsErrorDescription.
						self assert: (session selectAllOfType: Customer) isEmpty
					].

	self should:[
			CustomerImporter valueFrom: (ReadStream on: 'C,Pepe,Sanchez,D') into: session..
		] 
	raise: Error - MessageNotUnderstood
	withExceptionDo: [:error |
						self assert: error messageText = CustomerImporter invalidNumberOfFieldsErrorDescription.
						self assert: (session selectAllOfType: Customer) isEmpty
					].! !

!ImportTest methodsFor: 'tests' stamp: 'BR 11/20/2023 15:24:02'!
test03CannotImportAddressWithMoreOrLessThan6Fields

	self should:[
			CustomerImporter valueFrom: (ReadStream on: 'C,Pepe,Sanchez,D,22333444
A,San Martin,3322,Olivos,1636,BsAs,Tigre') into: session..
		] 
	raise: Error - MessageNotUnderstood
	withExceptionDo: [:error |
						self assert: error messageText = CustomerImporter invalidNumberOfFieldsErrorDescription.
						self assert: (session selectAllOfType: Customer) size = 1 .
						self assert: (session selectAllOfType: Customer) anyOne addresses isEmpty
					].
				
	self should:[
			CustomerImporter valueFrom: (ReadStream on: 'A,San Martin,3322,Olivos,1636') into: session..
		] 
	raise: Error - MessageNotUnderstood
	withExceptionDo: [:error |
						self assert: error messageText = CustomerImporter invalidNumberOfFieldsErrorDescription.
						self assert: (session selectAllOfType: Customer) size = 1 .
						self assert: (session selectAllOfType: Customer) anyOne addresses isEmpty
					].! !

!ImportTest methodsFor: 'tests' stamp: 'BR 11/20/2023 15:18:26'!
test06DoesNotImportRecordsThatStartWithAAndSomethingElse

	self should: [
		CustomerImporter valueFrom: (ReadStream on: 'CQ,Pepe,Sanchez,D,22333444') into: session.]
		raise: Error
		withExceptionDo: [
			:anError | self assert: anError messageText equals: (CustomerImporter invalidIdErrorDescription).
					self assert: (session selectAllOfType: Customer) isEmpty
					] 
		! !

!ImportTest methodsFor: 'tests' stamp: 'BR 11/20/2023 15:18:35'!
test07DoesNotImportRecordsThatStartWithCAndSomethingElse

	self should: [
		CustomerImporter valueFrom: (ReadStream on: 'CQ,Pepe,Sanchez,D,22333444') into: session.]
		raise: Error
		withExceptionDo: [
			:anError | self assert: anError messageText equals: (CustomerImporter invalidIdErrorDescription).
					self assert: (session selectAllOfType: Customer) isEmpty
					] 
		! !

!ImportTest methodsFor: 'tests' stamp: 'BR 11/20/2023 15:18:49'!
test08CannotImportEmptyLine

	self should: [
		CustomerImporter valueFrom: (ReadStream on: '
		') into: session..
	]
	raise: Error - MessageNotUnderstood
	withExceptionDo: [:error |
						self assert: error messageText = CustomerImporter emptyLineErrorDescription.
						self assert: (session selectAllOfType: Customer) isEmpty
					].! !

!ImportTest methodsFor: 'tests' stamp: 'BR 11/19/2023 15:47:55'!
test09CannotImportAddressWithoutCustomer

	self should:[
			CustomerImporter valueFrom: (ReadStream on: 'A,San Martin,3322,Olivos,1636,BsAs') into: session..
		] 
	raise: Error - MessageNotUnderstood
	withExceptionDo: [:error |
						self assert: error messageText = CustomerImporter missingCustomerForAddressErrorDescription
					].! !


!ImportTest methodsFor: 'assertions' stamp: 'HAW 5/22/2022 18:22:05'!
assertAddressOf: importedCustomer at: aStreetName hasNumber: aNumber town: aTown zipCode: aZipCode province: aProvince

	| importedAddress |

	importedAddress := importedCustomer addressAt: aStreetName ifNone: [ self fail ].
	self assert: aStreetName equals: importedAddress streetName.
	self assert: aNumber equals: importedAddress streetNumber.
	self assert: aTown equals: importedAddress town.
	self assert: aZipCode equals: importedAddress zipCode.
	self assert: aProvince equals: importedAddress province.

	! !

!ImportTest methodsFor: 'assertions' stamp: 'HAW 5/22/2022 18:27:57'!
assertCustomerWithIdentificationType: anIdType number: anIdNumber hasFirstName: aFirstName lastName: aLastName

	| importedCustomer |

	importedCustomer := self customerWithIdentificationType: anIdType number: anIdNumber.

	self assert: aFirstName equals: importedCustomer firstName.
	self assert: aLastName equals: importedCustomer lastName.
	self assert: anIdType equals: importedCustomer identificationType.
	self assert: anIdNumber equals: importedCustomer identificationNumber.

	^importedCustomer

	! !

!ImportTest methodsFor: 'assertions' stamp: 'HAW 5/22/2022 18:12:18'!
assertImportedRightNumberOfCustomers

	^ self assert: 2 equals: (session selectAllOfType: Customer) size! !

!ImportTest methodsFor: 'assertions' stamp: 'HAW 5/22/2022 18:28:45'!
assertJuanPerezWasImportedCorrectly

	| importedCustomer |

	importedCustomer := self assertCustomerWithIdentificationType: 'C' number: '23-25666777-9' hasFirstName: 'Juan' lastName: 'Perez'.
	self assertAddressOf: importedCustomer at: 'Alem' hasNumber: 1122 town: 'CABA' zipCode: 1001 province: 'CABA'
	! !

!ImportTest methodsFor: 'assertions' stamp: 'HAW 5/22/2022 18:28:05'!
assertPepeSanchezWasImportedCorrecty

	| importedCustomer |

	importedCustomer := self assertCustomerWithIdentificationType: 'D' number: '22333444' hasFirstName: 'Pepe' lastName: 'Sanchez'.
	self assertAddressOf: importedCustomer at: 'San Martin' hasNumber: 3322 town: 'Olivos' zipCode: 1636 province: 'BsAs'.
	self assertAddressOf: importedCustomer at: 'Maipu' hasNumber: 888 town: 'Florida' zipCode: 1122 province: 'Buenos Aires'.


	! !


!ImportTest methodsFor: 'setUp/tearDown' stamp: 'BR 11/19/2023 13:31:14'!
setUp

	session := DataBaseSession for: (Array with: Address with: Customer).
	session beginTransaction.
! !

!ImportTest methodsFor: 'setUp/tearDown' stamp: 'BR 11/16/2023 20:56:13'!
start

	^ session := DataBaseSession for: (Array with: Address with: Customer)! !

!ImportTest methodsFor: 'setUp/tearDown' stamp: 'HAW 5/22/2022 00:28:23'!
tearDown

	session commit.
	session close.
	! !


!ImportTest methodsFor: 'customer' stamp: 'HAW 5/22/2022 18:14:22'!
customerWithIdentificationType: anIdType number: anIdNumber

	^ (session
		select: [ :aCustomer | aCustomer identificationType = anIdType and: [ aCustomer identificationNumber = anIdNumber ]]
		ofType: Customer) anyOne! !


!ImportTest methodsFor: 'test data' stamp: 'HAW 5/22/2022 18:08:08'!
validImportData

	^ ReadStream on:
'C,Pepe,Sanchez,D,22333444
A,San Martin,3322,Olivos,1636,BsAs
A,Maipu,888,Florida,1122,Buenos Aires
C,Juan,Perez,C,23-25666777-9
A,Alem,1122,CABA,1001,CABA'! !


!classDefinition: #Address category: 'CustomerImporter'!
Object subclass: #Address
	instanceVariableNames: 'id streetName streetNumber town zipCode province'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!Address methodsFor: 'province' stamp: 'HAW 5/22/2022 00:19:29'!
province

	^province! !

!Address methodsFor: 'province' stamp: 'HAW 5/22/2022 00:19:29'!
province: aProvince

	province := aProvince
	! !


!Address methodsFor: 'street' stamp: 'HAW 5/22/2022 17:55:46'!
isAt: aStreetName

	^streetName = aStreetName ! !

!Address methodsFor: 'street' stamp: 'HAW 5/22/2022 00:19:29'!
streetName

	^streetName ! !

!Address methodsFor: 'street' stamp: 'HAW 5/22/2022 00:19:29'!
streetName: aStreetName

	streetName := aStreetName ! !

!Address methodsFor: 'street' stamp: 'HAW 5/22/2022 00:19:29'!
streetNumber

	^streetNumber ! !

!Address methodsFor: 'street' stamp: 'HAW 5/22/2022 00:19:29'!
streetNumber: aStreetNumber

	streetNumber := aStreetNumber ! !


!Address methodsFor: 'twon' stamp: 'HAW 5/22/2022 00:19:29'!
town

	^town! !

!Address methodsFor: 'twon' stamp: 'HAW 5/22/2022 00:19:29'!
town: aTown

	town := aTown! !


!Address methodsFor: 'zip code' stamp: 'HAW 5/22/2022 00:19:29'!
zipCode

	^zipCode! !

!Address methodsFor: 'zip code' stamp: 'HAW 5/22/2022 00:19:29'!
zipCode: aZipCode

	zipCode := aZipCode! !


!classDefinition: #Customer category: 'CustomerImporter'!
Object subclass: #Customer
	instanceVariableNames: 'id firstName lastName identificationType identificationNumber addresses'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!Customer methodsFor: 'addresses' stamp: 'HAW 5/22/2022 00:19:29'!
addAddress: anAddress

	addresses add: anAddress ! !

!Customer methodsFor: 'addresses' stamp: 'HAW 5/22/2022 17:55:17'!
addressAt: aStreetName ifNone: aNoneBlock

	^addresses detect: [ :address | address isAt: aStreetName ] ifNone: aNoneBlock ! !

!Customer methodsFor: 'addresses' stamp: 'HAW 5/22/2022 00:19:29'!
addresses

	^ addresses! !


!Customer methodsFor: 'name' stamp: 'HAW 5/22/2022 00:19:29'!
firstName

	^firstName ! !

!Customer methodsFor: 'name' stamp: 'HAW 5/22/2022 00:19:29'!
firstName: aName

	firstName := aName! !

!Customer methodsFor: 'name' stamp: 'HAW 5/22/2022 00:19:29'!
lastName

	^lastName ! !

!Customer methodsFor: 'name' stamp: 'HAW 5/22/2022 00:19:29'!
lastName: aLastName

	lastName := aLastName
! !


!Customer methodsFor: 'identification' stamp: 'HAW 5/22/2022 00:19:29'!
identificationNumber

	^identificationNumber ! !

!Customer methodsFor: 'identification' stamp: 'HAW 5/22/2022 00:19:29'!
identificationNumber: anIdentificationNumber

	identificationNumber := anIdentificationNumber! !

!Customer methodsFor: 'identification' stamp: 'HAW 5/22/2022 00:19:29'!
identificationType

	^identificationType ! !

!Customer methodsFor: 'identification' stamp: 'HAW 5/22/2022 00:19:29'!
identificationType: anIdentificationType

	identificationType := anIdentificationType! !


!Customer methodsFor: 'initialization' stamp: 'HAW 5/22/2022 00:19:29'!
initialize

	super initialize.
	addresses := OrderedCollection new.! !


!classDefinition: #CustomerImporter category: 'CustomerImporter'!
Object subclass: #CustomerImporter
	instanceVariableNames: 'session readStream newCustomer line register'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!CustomerImporter methodsFor: 'initialization' stamp: 'BR 11/19/2023 15:44:51'!
initializeFrom: aReadStream into: aSession

	session := aSession.
	readStream := aReadStream.! !


!CustomerImporter methodsFor: 'evaluating' stamp: 'BR 11/20/2023 15:09:21'!
assertAddressRegisterHas6Fields: anAddressRegister

	^ (anAddressRegister size = 6) ifFalse: [self error: self class invalidNumberOfFieldsErrorDescription]! !

!CustomerImporter methodsFor: 'evaluating' stamp: 'BR 11/20/2023 15:09:52'!
assertCustomerRegisterHas5Fields: aCustomerRegister

	^ (aCustomerRegister size = 5) ifFalse: [self error: self class invalidNumberOfFieldsErrorDescription]! !

!CustomerImporter methodsFor: 'evaluating' stamp: 'BR 11/20/2023 15:10:29'!
assertCustomerRegisterIsNotMissing

	^ newCustomer isNil ifTrue: [self error: self class missingCustomerForAddressErrorDescription ]! !

!CustomerImporter methodsFor: 'evaluating' stamp: 'BR 11/19/2023 15:46:35'!
createRegister

	register := line findTokens: $,.
	(register isEmpty) ifTrue: [self error: self class emptyLineErrorDescription.]! !

!CustomerImporter methodsFor: 'evaluating' stamp: 'BR 11/20/2023 15:11:35'!
importAddressRegister: anAddressRegister

	| newAddress |
	
	self assertAddressRegisterHas6Fields: anAddressRegister.
	self assertCustomerRegisterIsNotMissing.
	
	newAddress := Address new.
	newAddress streetName: anAddressRegister second.
	newAddress streetNumber: anAddressRegister third asNumber .
	newAddress town: anAddressRegister fourth.
	newAddress zipCode: anAddressRegister fifth asNumber .
	newAddress province: anAddressRegister sixth.
	newCustomer addAddress: newAddress.! !

!CustomerImporter methodsFor: 'evaluating' stamp: 'BR 11/20/2023 15:09:52'!
importCustomerRegister: aCustomerRegister

 	self assertCustomerRegisterHas5Fields: aCustomerRegister.
	newCustomer := Customer new.
	newCustomer firstName: aCustomerRegister second.
	newCustomer lastName: aCustomerRegister third.
	newCustomer identificationType: aCustomerRegister fourth.
	newCustomer identificationNumber: aCustomerRegister fifth.
	session persist: newCustomer! !

!CustomerImporter methodsFor: 'evaluating' stamp: 'BR 11/19/2023 13:39:35'!
readLine

	line := readStream nextLine. 
	^line notNil! !

!CustomerImporter methodsFor: 'evaluating' stamp: 'BR 11/16/2023 20:08:42'!
value

	"
	self importCustomers
	"
	
	[ self readLine. ] 
		whileTrue: [
				self createRegister.
				self importRegister.
			].

	! !


!CustomerImporter methodsFor: 'as yet unclassified' stamp: 'BR 11/19/2023 15:46:54'!
importRegister
	
	(self isCustomer) ifTrue: [ ^self importCustomerRegister: register ].
	(self isAddress) ifTrue: [ ^self importAddressRegister: register ].
	^self error: self class invalidIdErrorDescription.! !

!CustomerImporter methodsFor: 'as yet unclassified' stamp: 'BR 11/19/2023 15:39:33'!
isAddress

	^ register first = 'A'! !

!CustomerImporter methodsFor: 'as yet unclassified' stamp: 'BR 11/19/2023 15:39:16'!
isCustomer

	^ register first = 'C'! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CustomerImporter class' category: 'CustomerImporter'!
CustomerImporter class
	instanceVariableNames: ''!

!CustomerImporter class methodsFor: 'instance creation' stamp: 'HAW 5/22/2022 18:06:47'!
from: aReadStream into: aSession
	^self new initializeFrom: aReadStream into: aSession! !


!CustomerImporter class methodsFor: 'importing' stamp: 'BR 11/19/2023 15:46:35'!
emptyLineErrorDescription
	^'Empty line cannot be imported'.! !

!CustomerImporter class methodsFor: 'importing' stamp: 'BR 11/19/2023 15:46:54'!
invalidIdErrorDescription
	^'Unrecognized record type id'.! !

!CustomerImporter class methodsFor: 'importing' stamp: 'BR 11/19/2023 15:47:13'!
invalidNumberOfFieldsErrorDescription
	^'Invalid number of fields on register'.! !

!CustomerImporter class methodsFor: 'importing' stamp: 'BR 11/19/2023 15:47:40'!
missingCustomerForAddressErrorDescription
	^'Missing customer to add address to'.! !

!CustomerImporter class methodsFor: 'importing' stamp: 'HAW 5/22/2022 18:11:27'!
valueFrom: aReadStream into: aSession

	^(self from: aReadStream into: aSession) value! !


!classDefinition: #DataBaseSession category: 'CustomerImporter'!
Object subclass: #DataBaseSession
	instanceVariableNames: 'configuration tables id inTransaction closed'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!DataBaseSession methodsFor: 'transaction management' stamp: 'HAW 11/14/2023 08:52:25'!
beginTransaction

	inTransaction := true.! !

!DataBaseSession methodsFor: 'transaction management' stamp: 'HAW 11/14/2023 08:52:18'!
commit

	inTransaction := false.! !


!DataBaseSession methodsFor: 'closing' stamp: 'HAW 11/14/2023 08:52:30'!
close

	closed := true.! !


!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 11/14/2023 08:49:30'!
assertCanUseDatabase

	self assertIsOpen.
	self assertInTransaction ! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 11/14/2023 08:48:43'!
assertInTransaction

	inTransaction ifFalse: [ self error: 'Not in transaction' ].! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 11/14/2023 08:48:16'!
assertIsOpen

	closed ifTrue: [ self error: 'Connection with database closed' ].! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 11/14/2023 09:09:07'!
assertTypeIsPersisted: aType

	(configuration includes: aType) ifFalse: [ self error: 'Object of type ', aType name, ' are not configured to be persisted' ].! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 5/22/2022 00:19:29'!
defineIdOf: anObject

	anObject instVarNamed: 'id' put: (self newIdFor: anObject).! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 5/22/2022 00:19:29'!
delay

	(Delay forMilliseconds: 100) wait! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 11/14/2023 08:58:59'!
isRelationToPersist: possibleRelation

	^ possibleRelation class = Set! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 11/14/2023 08:58:59'!
persistPossibleRelationOf: anObject at: anInstVarOffset

	| possibleRelation |
		
	possibleRelation := anObject instVarAt: anInstVarOffset.
	(self isRelationToPersist: possibleRelation) ifTrue: [ self persistRelationOf: anObject at: anInstVarOffset with: possibleRelation ]! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 11/14/2023 08:58:03'!
persistRelationOf: anObject at: anInstVarOffset with: aRelation

	| persistentRelation |
	
	persistentRelation := PersistentSet on: self from: aRelation.
	anObject instVarAt: anInstVarOffset put: persistentRelation! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 11/14/2023 08:58:34'!
persistRelationsOf: anObject

	anObject class instVarNamesAndOffsetsDo: [ :anInstVarName :anInstVarOffset | self persistPossibleRelationOf: anObject at: anInstVarOffset]! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 11/14/2023 09:06:24'!
tableOfType: aType

	^ tables at: aType ifAbsentPut: [ Set new ]! !


!DataBaseSession methodsFor: 'initialization' stamp: 'HAW 11/14/2023 08:44:19'!
initializeFor: aConfiguration

	configuration := aConfiguration.
	tables := Dictionary new.
	id := 0.
	inTransaction := false.
	closed := false.! !


!DataBaseSession methodsFor: 'id' stamp: 'HAW 5/22/2022 00:19:29'!
newIdFor: anObject

	id := id + 1.
	^id! !


!DataBaseSession methodsFor: 'persistance' stamp: 'HAW 11/14/2023 09:06:24'!
persist: anObject

	| table |

	self assertCanUseDatabase.
	self assertTypeIsPersisted: anObject class.
	self delay.
	
	table := self tableOfType: anObject class.
	self defineIdOf: anObject.
	table add: anObject.
	self persistRelationsOf: anObject.
! !


!DataBaseSession methodsFor: 'selecting' stamp: 'HAW 11/14/2023 09:06:56'!
select: aCondition ofType: aType

	self assertCanUseDatabase.
	self assertTypeIsPersisted: aType.
	self delay.
	
	^(self tableOfType: aType) select: aCondition ! !

!DataBaseSession methodsFor: 'selecting' stamp: 'HAW 11/14/2023 09:07:12'!
selectAllOfType: aType

	self assertCanUseDatabase.
	self assertTypeIsPersisted: aType.
	self delay.
	
	^(self tableOfType: aType) copy ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'DataBaseSession class' category: 'CustomerImporter'!
DataBaseSession class
	instanceVariableNames: ''!

!DataBaseSession class methodsFor: 'instance creation' stamp: 'HAW 5/22/2022 00:19:29'!
for: aConfiguration

	^self new initializeFor: aConfiguration! !


!classDefinition: #PersistentCustomerSystem category: 'CustomerImporter'!
Object subclass: #PersistentCustomerSystem
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!
