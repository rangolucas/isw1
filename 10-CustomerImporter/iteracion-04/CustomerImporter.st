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


!PersistentSet methodsFor: 'adding' stamp: 'LR 11/23/2023 18:39:12'!
addCustomer: newObject

	super addCustomer: newObject.
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
	instanceVariableNames: 'system'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!ImportTest methodsFor: 'tests - customer' stamp: 'LR 11/24/2023 15:00:42'!
test01ValidDataIsImportedCorrectly

	CustomerImporter valueFrom: self validImportData into: system.

	self assertImportedRightNumberOfCustomers.
	self assertPepeSanchezWasImportedCorrecty.
	self assertJuanPerezWasImportedCorrectly ! !

!ImportTest methodsFor: 'tests - customer' stamp: 'LR 11/24/2023 12:59:26'!
test02CanNotImportAddressWithoutCustomer

	self
		should: [ CustomerImporter valueFrom: self addressWithoutCustomerData into: system . ]
		raise: Error - MessageNotUnderstood
		withMessageText: CustomerImporter canNotImportAddressWithoutCustomerErrorDescription

	! !

!ImportTest methodsFor: 'tests - customer' stamp: 'HAW 5/22/2022 19:56:58'!
test03DoesNotImportRecordsStartingWithCButMoreCharacters

	self
		shouldFailImporting: self invalidCustomerRecordStartData
		messageText: CustomerImporter invalidRecordTypeErrorDescription
		asserting: [ self assertNoCustomerWasImported ]

	! !

!ImportTest methodsFor: 'tests - customer' stamp: 'HAW 5/22/2022 19:49:03'!
test04DoesNotImportRecordsStartingWithAButMoreCharacters

	self
		shouldFailImporting: self invalidAddressRecordStartData
		messageText: CustomerImporter invalidRecordTypeErrorDescription
		asserting: [ self assertImportedOneCustomerWithoutAddress ]

	! !

!ImportTest methodsFor: 'tests - customer' stamp: 'LR 11/24/2023 13:09:58'!
test05CanNotImportAddressRecordWithLessThanSixFields

	self
		shouldFailImporting: self addressRecordWithLessThanSixFields
		messageText: AddressRecordParser invalidAddressRecordErrorDescription
		asserting: [ self assertImportedOneCustomerWithoutAddress ]

	! !

!ImportTest methodsFor: 'tests - customer' stamp: 'LR 11/24/2023 13:09:58'!
test06CanNotImportAddressRecordWithMoreThanSixFields

	self
		shouldFailImporting: self addressRecordWithMoreThanSixFields
		messageText: AddressRecordParser invalidAddressRecordErrorDescription
		asserting: [ self assertImportedOneCustomerWithoutAddress ]

	! !

!ImportTest methodsFor: 'tests - customer' stamp: 'LR 11/24/2023 13:10:06'!
test07CanNotImportCustomerRecordWithLessThanFiveFields

	self
		shouldFailImporting: self customerRecordWithLessThanFiveFields
		messageText: CustomerRecordParser invalidCustomerRecordErrorDescription
		asserting: [ self assertNoCustomerWasImported ]

	! !

!ImportTest methodsFor: 'tests - customer' stamp: 'LR 11/24/2023 13:10:06'!
test08CanNotImportCustomerRecordWithMoreThanFiveFields

	self
		shouldFailImporting: self customerRecordWithMoreThanFiveFields
		messageText: CustomerRecordParser invalidCustomerRecordErrorDescription
		asserting: [ self assertNoCustomerWasImported ]

	! !

!ImportTest methodsFor: 'tests - customer' stamp: 'HAW 5/22/2022 20:01:43'!
test09CannotImportEmptyLine

	self
		shouldFailImporting: self emptyLine
		messageText: CustomerImporter invalidRecordTypeErrorDescription
		asserting: [ self assertNoCustomerWasImported ]

	! !


!ImportTest methodsFor: 'assertions' stamp: 'LR 11/24/2023 15:45:08'!
assert: importedSupplier hasCustomerWithName: customerName lastName: customerLastName andId: customerId

	| associatedCustomer |
	associatedCustomer := importedSupplier findCustomerWithId: customerId ifNone: [
		self failWith: 'Associated customer not found'
	].
	self assert: (associatedCustomer hasFirstName: customerName hasLastName: customerLastName hasIdentification: customerId ).
	^associatedCustomer

	! !

!ImportTest methodsFor: 'assertions' stamp: 'LR 11/24/2023 16:24:04'!
assertAddressOf: importedCustomer at: aStreetName hasNumber: aNumber town: aTown zipCode: aZipCode province: aProvince

	| importedAddress |

	importedAddress := importedCustomer addressAt: aStreetName ifNone: [ self failWith: 'Address not found' ].
	self assert: (importedAddress hasStreetName: aStreetName streetNumber: aNumber town: aTown zipCode: aZipCode province: aProvince).

	! !

!ImportTest methodsFor: 'assertions' stamp: 'LR 11/24/2023 15:50:57'!
assertCorrectlyImportedCustomerOf: supplier withId: customerId name: customerName lastName: customerLastName   

	self assertCustomerWithIdentification: customerId hasFirstName: customerName lastName: customerLastName.
	self assert: supplier hasCustomerWithName: customerName lastName: customerLastName andId: customerId! !

!ImportTest methodsFor: 'assertions' stamp: 'LR 11/24/2023 11:25:02'!
assertCustomerWithIdentification: anId hasFirstName: aFirstName lastName: aLastName

	| importedCustomer |

	importedCustomer := system customerWithIdentification: anId.

	self assert: (importedCustomer hasFirstName: aFirstName hasLastName: aLastName hasIdentification: anId). 

	^importedCustomer

	! !

!ImportTest methodsFor: 'assertions' stamp: 'LR 11/24/2023 16:23:32'!
assertImportedOneCustomerWithoutAddress

	| importedCustomer |

	self assert: system numberOfCustomers equals: 1.
	importedCustomer := system customerWithIdentification: self pepeSanchezId.
	self assert: importedCustomer isAddressesEmpty
	! !

!ImportTest methodsFor: 'assertions' stamp: 'LR 11/24/2023 16:23:24'!
assertImportedRightNumberOfCustomers

	^ self assert: system numberOfCustomers equals: 2! !

!ImportTest methodsFor: 'assertions' stamp: 'LR 11/24/2023 15:36:01'!
assertJuanPerezWasImportedCorrectly

	| importedCustomer |
	importedCustomer := self assertCustomerWithIdentification: self juanPerezId hasFirstName: 'Juan' lastName: 'Perez'.
	self assertAddressOf: importedCustomer at: 'Alem' hasNumber: 1122 town: 'CABA' zipCode: 1001 province: 'CABA'
	! !

!ImportTest methodsFor: 'assertions' stamp: 'LR 11/24/2023 16:22:56'!
assertNoCustomerWasImported

	^ self assert: system numberOfCustomers equals: 0! !

!ImportTest methodsFor: 'assertions' stamp: 'LR 11/24/2023 16:23:09'!
assertNoSupplierWasImported

	^ self assert: system numberOfSuppliers equals: 0! !

!ImportTest methodsFor: 'assertions' stamp: 'LR 11/24/2023 15:01:11'!
assertPepeSanchezWasImportedCorrecty

	| importedCustomer |

	importedCustomer := self assertCustomerWithIdentification: self pepeSanchezId hasFirstName: 'Pepe' lastName: 'Sanchez'.
	self assertAddressOf: importedCustomer at: 'San Martin' hasNumber: 3322 town: 'Olivos' zipCode: 1636 province: 'BsAs'.
	self assertAddressOf: importedCustomer at: 'Maipu' hasNumber: 888 town: 'Florida' zipCode: 1122 province: 'Buenos Aires'.


	! !

!ImportTest methodsFor: 'assertions' stamp: 'LR 11/24/2023 15:15:52'!
assertSupplierWithIdentification: anId hasFirstName: aFirstName

	| importedSupplier |

	importedSupplier := system supplierWithIdentification: anId.

	self assert: (importedSupplier isIdentifiedWith: anId withName: aFirstName). 

	^importedSupplier

	! !

!ImportTest methodsFor: 'assertions' stamp: 'LR 11/24/2023 12:59:26'!
shouldFailImporting: aReadStream messageText: anErrorMessageText asserting: anAssertionBlock

	self
		should: [ CustomerImporter valueFrom: aReadStream into: system . ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anErrorMessageText equals: anError messageText.
			anAssertionBlock value ]

	! !


!ImportTest methodsFor: 'setUp/tearDown' stamp: 'LR 11/24/2023 14:59:33'!
setUp

	system := Environment current createErpSystem.
	system start.
	system beginTransaction.
! !

!ImportTest methodsFor: 'setUp/tearDown' stamp: 'HAW 5/22/2022 20:12:16'!
tearDown

	system commit.
	system stop
	! !


!ImportTest methodsFor: 'test data' stamp: 'HAW 5/22/2022 19:41:20'!
addressRecordWithLessThanSixFields

	^ReadStream on: 'C,Pepe,Sanchez,D,22333444
A,San Martin,3322,Olivos,1636'! !

!ImportTest methodsFor: 'test data' stamp: 'HAW 5/22/2022 19:51:35'!
addressRecordWithMoreThanSixFields

	^ReadStream on: 'C,Pepe,Sanchez,D,22333444
A,San Martin,3322,Olivos,1636,BsAs,x'! !

!ImportTest methodsFor: 'test data' stamp: 'HAW 5/22/2022 19:14:13'!
addressWithoutCustomerData

	^ReadStream on: 'A,San Martin,3322,Olivos,1636,BsAs'! !

!ImportTest methodsFor: 'test data' stamp: 'HAW 5/22/2022 19:53:41'!
customerRecordWithLessThanFiveFields

	^ReadStream on: 'C,Pepe,Sanchez,D'! !

!ImportTest methodsFor: 'test data' stamp: 'HAW 5/22/2022 19:55:59'!
customerRecordWithMoreThanFiveFields

	^ReadStream on: 'C,Pepe,Sanchez,D,22333444,x'! !

!ImportTest methodsFor: 'test data' stamp: 'HAW 5/22/2022 20:02:57'!
emptyLine

	^ReadStream on: '
'! !

!ImportTest methodsFor: 'test data' stamp: 'HAW 5/22/2022 19:34:25'!
invalidAddressRecordStartData

	^ReadStream on: 'C,Pepe,Sanchez,D,22333444
AA,San Martin,3322,Olivos,1636,BsAs'! !

!ImportTest methodsFor: 'test data' stamp: 'HAW 5/22/2022 19:22:55'!
invalidCustomerRecordStartData

	^ReadStream on: 'CC,Pepe,Sanchez,D,22333444'! !

!ImportTest methodsFor: 'test data' stamp: 'LR 11/24/2023 16:16:24'!
juanPerez
	^Customer withFirstName: 'Juan' lastName: 'Perez' identification: self juanPerezId ! !

!ImportTest methodsFor: 'test data' stamp: 'LR 11/24/2023 15:34:40'!
juanPerezId
	^PartyId ofType: 'C' numbered: '23-25666777-9'! !

!ImportTest methodsFor: 'test data' stamp: 'LR 11/24/2023 16:04:24'!
pepeSanchez
	^Customer withFirstName: 'Pepe' lastName: 'Sanchez' identification: self pepeSanchezId ! !

!ImportTest methodsFor: 'test data' stamp: 'LR 11/24/2023 14:59:29'!
pepeSanchezId

	^ PartyId ofType: 'D' numbered: '22333444'! !

!ImportTest methodsFor: 'test data' stamp: 'LR 11/24/2023 15:34:11'!
validImportData

	^ ReadStream on:
'C,Pepe,Sanchez,D,22333444
A,San Martin,3322,Olivos,1636,BsAs
A,Maipu,888,Florida,1122,Buenos Aires
C,Juan,Perez,C,23-25666777-9
A,Alem,1122,CABA,1001,CABA'! !


!ImportTest methodsFor: 'tests - supplier' stamp: 'LR 11/24/2023 15:53:45'!
test01SingleSupplierIsImportedCorrectlyWithOneNewCustomer

	| stream importedSupplier supplierId |
	
	stream := ReadStream on: 'S,Supplier1,D,123
A,San Martin,3322,Olivos,1636,BsAs
NC,Pepe,Sanchez,D,22333444'.
	supplierId := PartyId ofType: 'D' numbered: '123'.
	SupplierImporter valueFrom: stream into: system .
	
	self assert: system numberOfSuppliers equals: 1.
	self assert: system numberOfCustomers equals: 1.
	importedSupplier := self assertSupplierWithIdentification: supplierId hasFirstName: 'Supplier1'.
	self assert: importedSupplier numberOfCustomers equals: 1.
	self assertCorrectlyImportedCustomerOf: importedSupplier withId: self pepeSanchezId name: 'Pepe' lastName: 'Sanchez' .
	self assertAddressOf: importedSupplier at: 'San Martin' hasNumber: 3322 town: 'Olivos' zipCode: 1636 province: 'BsAs'
	
	
	! !

!ImportTest methodsFor: 'tests - supplier' stamp: 'LR 11/24/2023 12:59:26'!
test02FailsWithEmptyLine

	| stream |
	stream := ReadStream on: '
	'.
	self should: [
		SupplierImporter valueFrom: stream into: system .
		]
		 raise: Error - MessageNotUnderstood
		 withExceptionDo: [:error | 
			self assert: error messageText equals: SupplierImporter invalidRecordTypeErrorDescription.
			self assertNoSupplierWasImported.
		]! !

!ImportTest methodsFor: 'tests - supplier' stamp: 'LR 11/24/2023 16:13:15'!
test03SingleSupplierIsImportedCorrectlyWithManyNewCustomers

	| stream importedSupplier supplierId |
	
	stream := ReadStream on: 'S,Supplier1,D,123
NC,Pepe,Sanchez,D,22333444
NC,Juan,Perez,C,23-25666777-9'.
	supplierId := PartyId ofType: 'D' numbered: '123'.
	SupplierImporter valueFrom: stream into: system .
	
	importedSupplier := system supplierWithIdentification: supplierId.
	self assert: importedSupplier numberOfCustomers equals: 2.
	self assert: system numberOfCustomers equals: 2.
	self assertCorrectlyImportedCustomerOf: importedSupplier withId: self pepeSanchezId name: 'Pepe' lastName: 'Sanchez'.
	self assertCorrectlyImportedCustomerOf: importedSupplier withId: self juanPerezId name: 'Juan' lastName: 'Perez'.
	
	
	! !

!ImportTest methodsFor: 'tests - supplier' stamp: 'LR 11/24/2023 16:13:25'!
test04SingleSupplierIsImportedCorrectlyWithOneExistingCustomer

	| stream importedSupplier supplierId |
	
	system addCustomer: self pepeSanchez.
	stream := ReadStream on: 'S,Supplier1,D,123
EC,D,22333444'.
	supplierId := PartyId ofType: 'D' numbered: '123'.
	SupplierImporter valueFrom: stream into: system .
	
	importedSupplier := system supplierWithIdentification: supplierId.
	self assert: importedSupplier numberOfCustomers equals: 1.
	self assert: system numberOfCustomers equals: 1.
	self assertCorrectlyImportedCustomerOf: importedSupplier withId: self pepeSanchezId name: 'Pepe' lastName: 'Sanchez'.
	
	
	! !

!ImportTest methodsFor: 'tests - supplier' stamp: 'LR 11/24/2023 16:16:00'!
test05SingleSupplierIsImportedCorrectlyWithManyExistingCustomers

	| stream importedSupplier supplierId |
	
	system addCustomer: self pepeSanchez.
	system addCustomer: self juanPerez.
	stream := ReadStream on: 'S,Supplier1,D,123
EC,D,22333444
EC,C,23-25666777-9'.
	supplierId := PartyId ofType: 'D' numbered: '123'.
	SupplierImporter valueFrom: stream into: system .
	
	importedSupplier := system supplierWithIdentification: supplierId.
	self assert: importedSupplier numberOfCustomers equals: 2.
	self assert: system numberOfCustomers equals: 2.
	self assertCorrectlyImportedCustomerOf: importedSupplier withId: self pepeSanchezId name: 'Pepe' lastName: 'Sanchez'.
	self assertCorrectlyImportedCustomerOf: importedSupplier withId: self juanPerezId name: 'Juan' lastName: 'Perez'.
	! !

!ImportTest methodsFor: 'tests - supplier' stamp: 'BR 11/26/2023 18:34:51'!
test06SingleSupplierIsImportedCorrectlyWithManyAddresses

	| stream importedSupplier supplierId |
	
	stream := ReadStream on: 'S,Supplier1,D,123
A,San Martin,3322,Olivos,1636,BsAs
A,Maipu,888,Florida,1122,Buenos Aires'.
	supplierId := PartyId ofType: 'D' numbered: '123'.
	SupplierImporter valueFrom: stream into: system .
	
	importedSupplier := system supplierWithIdentification: supplierId.
	self assert: importedSupplier numberOfCustomers equals: 0.
	self assert: system numberOfCustomers equals: 0.
	self assertAddressOf: importedSupplier at: 'San Martin' hasNumber: 3322 town: 'Olivos' zipCode: 1636 province: 'BsAs'.
	self assertAddressOf: importedSupplier at: 'Maipu' hasNumber: 888 town: 'Florida' zipCode: 1122 province: 'Buenos Aires'
	! !

!ImportTest methodsFor: 'tests - supplier' stamp: 'BR 11/26/2023 18:39:29'!
test07SingleSupplierDoesNotReimportAlreadyExistingCustomer

	| stream importedSupplier supplierId |
	
	stream := ReadStream on: 'S,Supplier1,D,123
NC,Pepe,Sanchez,D,22333444
EC,D,22333444'.
	supplierId := PartyId ofType: 'D' numbered: '123'.
	SupplierImporter valueFrom: stream into: system .
	
	importedSupplier := system supplierWithIdentification: supplierId.
	self assert: importedSupplier numberOfCustomers equals: 1.
	self assert: system numberOfCustomers equals: 1.
	self assertCorrectlyImportedCustomerOf: importedSupplier withId: self pepeSanchezId name: 'Pepe' lastName: 'Sanchez'.

	! !

!ImportTest methodsFor: 'tests - supplier' stamp: 'BR 11/26/2023 18:47:01'!
test08SingleSupplierIsImportedCorrectlyWithExistingAndNewCustomers

	| stream importedSupplier supplierId |
	
	system addCustomer: self juanPerez.
	stream := ReadStream on: 'S,Supplier1,D,123
NC,Pepe,Sanchez,D,22333444
EC,C,23-25666777-9'.
	supplierId := PartyId ofType: 'D' numbered: '123'.
	SupplierImporter valueFrom: stream into: system .
	
	importedSupplier := system supplierWithIdentification: supplierId.
	self assert: importedSupplier numberOfCustomers equals: 2.
	self assert: system numberOfCustomers equals: 2.
	self assertCorrectlyImportedCustomerOf: importedSupplier withId: self pepeSanchezId name: 'Pepe' lastName: 'Sanchez'.

	! !

!ImportTest methodsFor: 'tests - supplier' stamp: 'BR 11/26/2023 19:25:17'!
test09ImportingFailsWhenAttemptingToImportNonExistentCustomer

	| stream supplierId importedSupplier|
	
	stream := ReadStream on: 'S,Supplier1,D,123
EC,C,23-25666777-9'.
	supplierId := PartyId ofType: 'D' numbered: '123'.

	self should: [
		SupplierImporter valueFrom: stream into: system .
		]
	 raise: Error - MessageNotUnderstood
	 withExceptionDo: [:error | 
		self assert: error messageText equals: ErpSystem nonExistentCustomerId.
		self assert: system numberOfSuppliers equals: 1.
		importedSupplier := self assertSupplierWithIdentification: supplierId hasFirstName: 'Supplier1'.
		self assert: importedSupplier numberOfCustomers equals: 0.
		self assert: system numberOfCustomers equals: 0.
	]

	
	
	
	
	

	! !

!ImportTest methodsFor: 'tests - supplier' stamp: 'BR 11/26/2023 19:25:10'!
test10ImportingFailsWhenAttemptingToImportWithEmptySupplier

	| stream |
	
	stream := ReadStream on: 'NC,Pepe,Sanchez,D,22333444'.

	self should: [
		SupplierImporter valueFrom: stream into: system .
		]
	 raise: Error - MessageNotUnderstood
	 withExceptionDo: [:error | 
		self assert: error messageText equals: SupplierImporter canNotImportCustomerWithoutSupplierErrorDescription.
		self assert: system numberOfSuppliers equals: 0.
		self assert: system numberOfCustomers equals: 0.
	]

	
	
	
	
	

	! !

!ImportTest methodsFor: 'tests - supplier' stamp: 'BR 11/26/2023 19:23:41'!
test11ImportingFailsWhenAttemptingToImportAddressWithEmptySupplier

	| stream |
	
	stream := ReadStream on: 'A,San Martin,3322,Olivos,1636,BsAs'.

	self should: [
		SupplierImporter valueFrom: stream into: system .
		]
	 raise: Error - MessageNotUnderstood
	 withExceptionDo: [:error | 
		self assert: error messageText equals: SupplierImporter canNotImportAddressWithoutSupplierErrorDescription.
		self assert: system numberOfSuppliers equals: 0.
		self assert: system numberOfCustomers equals: 0.
	]

	
	
	
	
	

	! !

!ImportTest methodsFor: 'tests - supplier' stamp: 'BR 11/26/2023 19:33:53'!
test12ManySuppliersAreImportedCorrectly

	| stream importedSupplier1 importedSupplier2 supplierId1 supplierId2 |
	
	system addCustomer: self juanPerez.
	stream := ReadStream on: 'S,Supplier1,D,123
NC,Pepe,Sanchez,D,22333444
S,Supplier2,E,1234
EC,C,23-25666777-9'.
	supplierId1 := PartyId ofType: 'D' numbered: '123'.
	supplierId2 := PartyId ofType: 'E' numbered: '1234'.
	SupplierImporter valueFrom: stream into: system .
	
	importedSupplier1 := system supplierWithIdentification: supplierId1.
	importedSupplier2 := system supplierWithIdentification: supplierId2.
	
	self assert: importedSupplier1 numberOfCustomers equals: 1.
	self assert: importedSupplier2 numberOfCustomers equals: 1.
	self assert: system numberOfCustomers equals: 2.
	self assert: system numberOfSuppliers equals: 2.
	self assertCorrectlyImportedCustomerOf: importedSupplier1 withId: self pepeSanchezId name: 'Pepe' lastName: 'Sanchez'.
	self assertCorrectlyImportedCustomerOf: importedSupplier2 withId: self juanPerezId name: 'Juan' lastName: 'Perez'.

	! !


!classDefinition: #Address category: 'CustomerImporter'!
Object subclass: #Address
	instanceVariableNames: 'id streetName streetNumber town zipCode province'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!Address methodsFor: 'initialization' stamp: 'LR 11/24/2023 12:46:30'!
initializeWithStreetName: aStreetName streetNumber: aStreetNumber town: aTown zipCode: aZipCode province: aProvince
	streetName := aStreetName.
	streetNumber := aStreetNumber.
	town := aTown.
	zipCode := aZipCode.
	province := aProvince.! !


!Address methodsFor: 'testing' stamp: 'LR 11/24/2023 12:42:12'!
hasStreetName: aStreetName streetNumber: aStreetNumber town: aTown zipCode: aZipCode province: aProvince
	^(self isAt: aStreetName) and: [
		streetNumber = aStreetNumber and: [
			town = aTown and: [
				zipCode = aZipCode and: [
					province = aProvince
				]
			]
		]
	]! !

!Address methodsFor: 'testing' stamp: 'LR 11/24/2023 12:42:00'!
isAt: aStreetName 
	^streetName = aStreetName! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Address class' category: 'CustomerImporter'!
Address class
	instanceVariableNames: ''!

!Address class methodsFor: 'instance creation' stamp: 'LR 11/24/2023 12:36:57'!
withStreetName: streetName streetNumber: streetNumber town: town zipCode: zipCode province: province 
	^self new initializeWithStreetName: streetName streetNumber: streetNumber town: town zipCode: zipCode province: province ! !


!classDefinition: #CSVImporter category: 'CustomerImporter'!
Object subclass: #CSVImporter
	instanceVariableNames: 'readStream line record system'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!CSVImporter methodsFor: 'initialization' stamp: 'LR 11/24/2023 13:01:55'!
initializeFrom: aReadStream into: aCustomerSystem 

	readStream := aReadStream.
	system := aCustomerSystem! !


!CSVImporter methodsFor: 'evaluating' stamp: 'LR 11/23/2023 18:54:34'!
value

	[ self hasLineToImport ] whileTrue: [
		self createRecord.
		self importRecord ].

	! !


!CSVImporter methodsFor: 'evaluating - private' stamp: 'LR 11/23/2023 18:54:47'!
assertRecordNotEmpty

	record isEmpty ifTrue: [ self error: self class invalidRecordTypeErrorDescription ]! !

!CSVImporter methodsFor: 'evaluating - private' stamp: 'LR 11/23/2023 18:54:50'!
createRecord

	^ record := line findTokens: $,! !

!CSVImporter methodsFor: 'evaluating - private' stamp: 'LR 11/23/2023 18:54:53'!
hasLineToImport

	line := readStream nextLine.
	^line notNil! !

!CSVImporter methodsFor: 'evaluating - private' stamp: 'LR 11/23/2023 18:54:59'!
importRecord

	self subclassResponsibility! !


!CSVImporter methodsFor: 'parsing' stamp: 'LR 11/24/2023 13:38:22'!
parseRecordWith: csvRecordParser
	^csvRecordParser parse: record.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CSVImporter class' category: 'CustomerImporter'!
CSVImporter class
	instanceVariableNames: ''!

!CSVImporter class methodsFor: 'instance creation' stamp: 'LR 11/24/2023 13:02:21'!
from: aReadStream into: aCustomerSystem   

	^self new initializeFrom: aReadStream into: aCustomerSystem ! !


!CSVImporter class methodsFor: 'error messages' stamp: 'LR 11/23/2023 18:55:44'!
invalidRecordTypeErrorDescription

	^'Invalid record type'! !


!CSVImporter class methodsFor: 'importing' stamp: 'LR 11/24/2023 13:02:26'!
valueFrom: aReadStream into: aCustomerSystem  

	^(self from: aReadStream into: aCustomerSystem ) value! !


!classDefinition: #CustomerImporter category: 'CustomerImporter'!
CSVImporter subclass: #CustomerImporter
	instanceVariableNames: 'newCustomer'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!CustomerImporter methodsFor: 'customer' stamp: 'HAW 5/22/2022 19:59:39'!
assertValidCustomerRecord

	^ record size ~= 5 ifTrue: [ self error: self class invalidCustomerRecordErrorDescription ]! !

!CustomerImporter methodsFor: 'customer' stamp: 'LR 11/24/2023 13:39:22'!
importCustomer

	newCustomer := self parseRecordWith: CustomerRecordParser.
	system addCustomer: newCustomer! !

!CustomerImporter methodsFor: 'customer' stamp: 'HAW 5/22/2022 19:23:55'!
isCustomerRecord

	^ record first = 'C'! !


!CustomerImporter methodsFor: 'address' stamp: 'HAW 5/22/2022 19:58:41'!
assertCustomerWasImported

	^ newCustomer ifNil: [ self error: self class canNotImportAddressWithoutCustomerErrorDescription ]! !

!CustomerImporter methodsFor: 'address' stamp: 'LR 11/24/2023 13:38:45'!
importAddress
	
	| parsedAddress |
	self assertCustomerWasImported.
	parsedAddress := self parseRecordWith: AddressRecordParser.
	newCustomer addAddress: parsedAddress.! !

!CustomerImporter methodsFor: 'address' stamp: 'HAW 5/22/2022 19:37:45'!
isAddressRecord

	^ record first = 'A'! !


!CustomerImporter methodsFor: 'evaluating - private' stamp: 'LR 11/23/2023 18:31:57'!
importRecord

	self assertRecordNotEmpty.

	self isCustomerRecord ifTrue: [ ^self importCustomer ].
	self isAddressRecord ifTrue: [ ^self importAddress ].

	self error: self class invalidRecordTypeErrorDescription! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CustomerImporter class' category: 'CustomerImporter'!
CustomerImporter class
	instanceVariableNames: ''!

!CustomerImporter class methodsFor: 'error messages' stamp: 'HAW 5/22/2022 19:13:48'!
canNotImportAddressWithoutCustomerErrorDescription

	^'Cannot import address without customer'! !


!classDefinition: #SupplierImporter category: 'CustomerImporter'!
CSVImporter subclass: #SupplierImporter
	instanceVariableNames: 'newSupplier'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!SupplierImporter methodsFor: 'customer' stamp: 'BR 11/26/2023 19:16:59'!
importCustomer
	
	| parsedCustomer |
	self assertSupplierWasImportedWhenImportingCustomer.
	parsedCustomer := self parseRecordWith: CustomerRecordParser.
	system addCustomer: parsedCustomer.
	newSupplier addCustomer: parsedCustomer.! !

!SupplierImporter methodsFor: 'customer' stamp: 'BR 11/26/2023 19:20:23'!
importExistingCustomer
	
	| parsedId existingCustomer |
	self assertSupplierWasImportedWhenImportingCustomer.
	parsedId := self parseRecordWith: PartyIdRecordParser.
	existingCustomer := system customerWithIdentification: parsedId.
	newSupplier addCustomer: existingCustomer.! !

!SupplierImporter methodsFor: 'customer' stamp: 'LR 11/24/2023 16:06:44'!
isExistingCustomerRecord

	^ record first = 'EC'! !

!SupplierImporter methodsFor: 'customer' stamp: 'LR 11/24/2023 12:52:32'!
isNewCustomerRecord

	^ record first = 'NC'! !


!SupplierImporter methodsFor: 'address' stamp: 'BR 11/26/2023 19:17:47'!
importAddress

	| parsedAddress |
	self assertSupplierWasImportedWhenAddingAddress.
	parsedAddress := self parseRecordWith: AddressRecordParser.
	newSupplier addAddress: parsedAddress.! !

!SupplierImporter methodsFor: 'address' stamp: 'LR 11/23/2023 20:51:05'!
isAddressRecord

	^ record first = 'A'! !


!SupplierImporter methodsFor: 'evaluating - private' stamp: 'LR 11/24/2023 16:06:14'!
importRecord

	self assertRecordNotEmpty.
	
	self isSupplierRecord ifTrue: [^self importSupplier].
	self isAddressRecord ifTrue: [^self importAddress.].
	self isNewCustomerRecord ifTrue: [^self importCustomer].
	self isExistingCustomerRecord ifTrue: [^self importExistingCustomer].	! !


!SupplierImporter methodsFor: 'supplier' stamp: 'BR 11/26/2023 19:16:46'!
assertSupplierWasImportedWhenAddingAddress

	^ newSupplier ifNil: [ self error: self class canNotImportAddressWithoutSupplierErrorDescription ]! !

!SupplierImporter methodsFor: 'supplier' stamp: 'BR 11/26/2023 19:17:23'!
assertSupplierWasImportedWhenImportingCustomer

	^ newSupplier ifNil: [ self error: self class canNotImportCustomerWithoutSupplierErrorDescription ]! !

!SupplierImporter methodsFor: 'supplier' stamp: 'LR 11/24/2023 13:40:02'!
importSupplier

	newSupplier := self parseRecordWith: SupplierRecordParser.
	system addSupplier: newSupplier! !

!SupplierImporter methodsFor: 'supplier' stamp: 'LR 11/23/2023 20:50:37'!
isSupplierRecord

	^ record first = 'S'! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SupplierImporter class' category: 'CustomerImporter'!
SupplierImporter class
	instanceVariableNames: ''!

!SupplierImporter class methodsFor: 'as yet unclassified' stamp: 'BR 11/26/2023 19:18:44'!
canNotImportAddressWithoutSupplierErrorDescription

	^'Cannot import Address without Supplier'! !

!SupplierImporter class methodsFor: 'as yet unclassified' stamp: 'BR 11/26/2023 19:18:18'!
canNotImportCustomerWithoutSupplierErrorDescription

	^'Cannot import customer without Supplier'! !


!classDefinition: #CSVRecordParser category: 'CustomerImporter'!
Object subclass: #CSVRecordParser
	instanceVariableNames: 'record'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!CSVRecordParser methodsFor: 'parse' stamp: 'LR 11/24/2023 16:08:11'!
parse

	self subclassResponsibility! !


!CSVRecordParser methodsFor: 'initialization' stamp: 'LR 11/24/2023 12:31:56'!
initializeWith: aRecord 
	record := aRecord.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CSVRecordParser class' category: 'CustomerImporter'!
CSVRecordParser class
	instanceVariableNames: ''!

!CSVRecordParser class methodsFor: 'instance creation - private' stamp: 'LR 11/24/2023 12:26:26'!
of: record
	^self new initializeWith: record! !


!CSVRecordParser class methodsFor: 'parse' stamp: 'LR 11/24/2023 13:07:07'!
parse: record
	^(self of: record) parse! !


!classDefinition: #AddressRecordParser category: 'CustomerImporter'!
CSVRecordParser subclass: #AddressRecordParser
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!AddressRecordParser methodsFor: 'parse' stamp: 'LR 11/24/2023 12:36:13'!
parse
	
	self assertValidAddressRecord.
	^Address 
		withStreetName: record second
		streetNumber: record third asNumber
		town: record fourth
		zipCode: record fifth asNumber
		province: record sixth.! !


!AddressRecordParser methodsFor: 'assertions' stamp: 'LR 11/24/2023 12:28:48'!
assertValidAddressRecord

	^ record size ~= 6 ifTrue: [ self error: self class invalidAddressRecordErrorDescription ]! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'AddressRecordParser class' category: 'CustomerImporter'!
AddressRecordParser class
	instanceVariableNames: ''!

!AddressRecordParser class methodsFor: 'error messages' stamp: 'LR 11/23/2023 20:48:16'!
invalidAddressRecordErrorDescription

	^'Address record has to have six fields'! !


!classDefinition: #CustomerRecordParser category: 'CustomerImporter'!
CSVRecordParser subclass: #CustomerRecordParser
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!CustomerRecordParser methodsFor: 'parse' stamp: 'LR 11/24/2023 12:27:58'!
parse

	|id|
	
	self assertValidCustomerRecord.

	id := PartyId ofType: record fourth numbered: record fifth.
	^Customer
		withFirstName: record second
		lastName: record third
		identification: id.! !


!CustomerRecordParser methodsFor: 'assertions' stamp: 'LR 11/24/2023 12:08:15'!
assertValidCustomerRecord

	^ record size ~= 5 ifTrue: [ self error: self class invalidCustomerRecordErrorDescription ]! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CustomerRecordParser class' category: 'CustomerImporter'!
CustomerRecordParser class
	instanceVariableNames: ''!

!CustomerRecordParser class methodsFor: 'error messages' stamp: 'LR 11/24/2023 12:20:55'!
invalidCustomerRecordErrorDescription

	^'Invalid Customer record'! !


!classDefinition: #PartyIdRecordParser category: 'CustomerImporter'!
CSVRecordParser subclass: #PartyIdRecordParser
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!PartyIdRecordParser methodsFor: 'parse' stamp: 'LR 11/24/2023 16:18:24'!
parse

	^PartyId ofType: record second numbered: record third! !


!classDefinition: #SupplierRecordParser category: 'CustomerImporter'!
CSVRecordParser subclass: #SupplierRecordParser
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!SupplierRecordParser methodsFor: 'parse' stamp: 'LR 11/24/2023 12:50:52'!
parse

	| id |
	id := PartyId ofType: record third numbered: record fourth.
	^Supplier withName: record second identification: id! !


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


!DataBaseSession methodsFor: 'persistance' stamp: 'LR 11/24/2023 11:53:19'!
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


!classDefinition: #Environment category: 'CustomerImporter'!
Object subclass: #Environment
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!Environment methodsFor: 'customer system' stamp: 'LR 11/24/2023 13:28:23'!
createErpSystem

	self subclassResponsibility ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Environment class' category: 'CustomerImporter'!
Environment class
	instanceVariableNames: ''!

!Environment class methodsFor: 'current' stamp: 'HAW 5/22/2022 21:37:10'!
current

	^(self subclasses detect: [ :anEnvironmentClass | anEnvironmentClass isCurrent ]) new! !

!Environment class methodsFor: 'current' stamp: 'HAW 11/23/2023 16:44:46'!
environmentKey

	^ #ENV! !

!Environment class methodsFor: 'current' stamp: 'HAW 11/23/2023 16:44:46'!
environmentVariable

	^ Smalltalk at: self environmentKey! !

!Environment class methodsFor: 'current' stamp: 'HAW 11/23/2023 16:44:09'!
identifier

	self subclassResponsibility! !

!Environment class methodsFor: 'current' stamp: 'HAW 5/22/2022 21:41:36'!
isCurrent

	self subclassResponsibility ! !

!Environment class methodsFor: 'current' stamp: 'HAW 11/23/2023 16:46:01'!
makeCurrent

	"
	Tener en cuenta que en Smalltalk se podría poner directamente la clase de environment,
	esto es DevelopmentEnvironment o IntegrationEnvironmet o hasta una instancia de ellas,
	pero se está simulando el hecho de que esto esté definido por fuera del sistema, como una
	variable del sistema operativo - Hernan"
	
	Smalltalk at: self environmentKey put: self identifier! !


!classDefinition: #DevelopmentEnvironment category: 'CustomerImporter'!
Environment subclass: #DevelopmentEnvironment
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!DevelopmentEnvironment methodsFor: 'erp system' stamp: 'LR 11/24/2023 13:28:23'!
createErpSystem

	^TransientErpSystem new! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'DevelopmentEnvironment class' category: 'CustomerImporter'!
DevelopmentEnvironment class
	instanceVariableNames: ''!

!DevelopmentEnvironment class methodsFor: 'current' stamp: 'HAW 11/23/2023 16:42:50'!
identifier

	^ #DEV! !

!DevelopmentEnvironment class methodsFor: 'current' stamp: 'LR 11/23/2023 18:19:36'!
isCurrent

	"
	self makeCurrent
	"
	^self environmentVariable = self identifier! !


!classDefinition: #IntegrationEnvironment category: 'CustomerImporter'!
Environment subclass: #IntegrationEnvironment
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!IntegrationEnvironment methodsFor: 'erp system' stamp: 'LR 11/24/2023 13:28:23'!
createErpSystem

	^PersistentErpSystem new! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'IntegrationEnvironment class' category: 'CustomerImporter'!
IntegrationEnvironment class
	instanceVariableNames: ''!

!IntegrationEnvironment class methodsFor: 'current' stamp: 'HAW 11/23/2023 16:43:07'!
identifier

	^ #INT! !

!IntegrationEnvironment class methodsFor: 'current' stamp: 'HAW 11/23/2023 16:44:04'!
isCurrent

	"
	self makeCurrent
	"
	^self environmentVariable = self identifier! !


!classDefinition: #ErpSystem category: 'CustomerImporter'!
Object subclass: #ErpSystem
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!ErpSystem methodsFor: 'customers' stamp: 'LR 11/23/2023 18:39:12'!
addCustomer: aCustomer

	self subclassResponsibility ! !

!ErpSystem methodsFor: 'customers' stamp: 'LR 11/24/2023 11:40:09'!
customerWithIdentification: anId

	self subclassResponsibility! !

!ErpSystem methodsFor: 'customers' stamp: 'HAW 5/22/2022 21:18:51'!
numberOfCustomers

	self subclassResponsibility ! !


!ErpSystem methodsFor: 'transactions' stamp: 'HAW 5/22/2022 21:18:04'!
beginTransaction

	self subclassResponsibility ! !

!ErpSystem methodsFor: 'transactions' stamp: 'HAW 5/22/2022 21:18:16'!
commit

	self subclassResponsibility ! !


!ErpSystem methodsFor: 'system lifecycle' stamp: 'HAW 5/22/2022 21:18:10'!
start

	self subclassResponsibility ! !

!ErpSystem methodsFor: 'system lifecycle' stamp: 'HAW 5/22/2022 21:18:13'!
stop

	self subclassResponsibility ! !


!ErpSystem methodsFor: 'evaluating' stamp: 'LR 11/23/2023 18:36:28'!
numberOfSuppliers
	self subclassResponsibility .! !

!ErpSystem methodsFor: 'evaluating' stamp: 'LR 11/24/2023 11:30:20'!
supplierWithIdentification: anId

	self subclassResponsibility! !


!ErpSystem methodsFor: 'updating' stamp: 'LR 11/24/2023 11:48:42'!
addSupplier: aSupplier

	self subclassResponsibility! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ErpSystem class' category: 'CustomerImporter'!
ErpSystem class
	instanceVariableNames: ''!

!ErpSystem class methodsFor: 'as yet unclassified' stamp: 'BR 11/26/2023 18:58:39'!
nonExistentCustomerId
	^'Customer id is not registered in the system'.! !


!classDefinition: #PersistentErpSystem category: 'CustomerImporter'!
ErpSystem subclass: #PersistentErpSystem
	instanceVariableNames: 'session'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!PersistentErpSystem methodsFor: 'customers' stamp: 'LR 11/23/2023 18:39:12'!
addCustomer: aCustomer

	^session persist: aCustomer ! !

!PersistentErpSystem methodsFor: 'customers' stamp: 'BR 11/26/2023 18:58:54'!
customerWithIdentification: anId
	|filtered|
	filtered := (session
		select: [ :aCustomer | aCustomer isIdentifiedWith: anId ]
		ofType: Customer
	).
	filtered isEmpty ifTrue: [^self error: self class nonExistentCustomerId]. 
	^filtered anyOne! !

!PersistentErpSystem methodsFor: 'customers' stamp: 'HAW 5/22/2022 21:08:47'!
numberOfCustomers

	^(session selectAllOfType: Customer) size! !


!PersistentErpSystem methodsFor: 'transactions' stamp: 'HAW 5/22/2022 20:12:39'!
beginTransaction

	session beginTransaction.
! !

!PersistentErpSystem methodsFor: 'transactions' stamp: 'HAW 5/22/2022 20:13:00'!
commit

	session commit ! !


!PersistentErpSystem methodsFor: 'system lifecycle' stamp: 'HAW 11/14/2023 09:21:54'!
start

	session := DataBaseSession for: (Array with: Address with: Customer).
	! !

!PersistentErpSystem methodsFor: 'system lifecycle' stamp: 'HAW 5/22/2022 20:13:10'!
stop

	session close! !


!PersistentErpSystem methodsFor: 'suppliers' stamp: 'LR 11/24/2023 11:49:09'!
addSupplier: aSupplier

	^session persist: aSupplier! !


!classDefinition: #TransientErpSystem category: 'CustomerImporter'!
ErpSystem subclass: #TransientErpSystem
	instanceVariableNames: 'customers suppliers'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!TransientErpSystem methodsFor: 'system lifecycle' stamp: 'LR 11/23/2023 18:37:33'!
start

	customers := OrderedCollection new.
	suppliers := OrderedCollection new.! !

!TransientErpSystem methodsFor: 'system lifecycle' stamp: 'HAW 5/22/2022 21:23:17'!
stop

	customers := nil! !


!TransientErpSystem methodsFor: 'transactions' stamp: 'HAW 5/22/2022 21:21:20'!
beginTransaction

	! !

!TransientErpSystem methodsFor: 'transactions' stamp: 'HAW 5/22/2022 21:23:01'!
commit

	! !


!TransientErpSystem methodsFor: 'customers' stamp: 'LR 11/23/2023 18:40:02'!
addCustomer: aCustomer

	customers add: aCustomer ! !

!TransientErpSystem methodsFor: 'customers' stamp: 'BR 11/26/2023 18:59:16'!
customerWithIdentification: anId 
	^customers detect: [:customer | customer isIdentifiedWith: anId] ifNone: [^self error: self class nonExistentCustomerId.].! !

!TransientErpSystem methodsFor: 'customers' stamp: 'HAW 5/22/2022 21:21:43'!
numberOfCustomers

	^customers size! !


!TransientErpSystem methodsFor: 'evaluating' stamp: 'LR 11/23/2023 18:36:56'!
numberOfSuppliers
	^suppliers size! !

!TransientErpSystem methodsFor: 'evaluating' stamp: 'LR 11/24/2023 11:30:08'!
supplierWithIdentification: anId
	^suppliers detect: [ :supplier | supplier isIdentifiedWith: anId ]! !


!TransientErpSystem methodsFor: 'updating' stamp: 'LR 11/23/2023 18:41:41'!
addSupplier: aSupplier
	suppliers add: aSupplier! !


!classDefinition: #Party category: 'CustomerImporter'!
Object subclass: #Party
	instanceVariableNames: 'identification addresses firstName'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!Party methodsFor: 'addresses' stamp: 'LR 11/23/2023 18:59:23'!
isAddressesEmpty

	^addresses isEmpty ! !


!Party methodsFor: 'initialization' stamp: 'LR 11/23/2023 19:00:32'!
initialize

	super initialize.
	addresses := OrderedCollection new.! !


!Party methodsFor: 'evaluating' stamp: 'LR 11/23/2023 19:58:46'!
addressAt: aStreetName ifNone: aNoneBlock

	^addresses detect: [ :address | address isAt: aStreetName ] ifNone: aNoneBlock ! !


!Party methodsFor: 'testing' stamp: 'LR 11/24/2023 11:27:07'!
isIdentifiedWith: anId
	^identification equals: anId! !


!Party methodsFor: 'private' stamp: 'LR 11/24/2023 11:35:58'!
hasFirstName: name

	^ firstName = name! !


!classDefinition: #Customer category: 'CustomerImporter'!
Party subclass: #Customer
	instanceVariableNames: 'id lastName'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!Customer methodsFor: 'addresses' stamp: 'LR 11/23/2023 18:40:23'!
addAddress: anAddress

	addresses add: anAddress ! !

!Customer methodsFor: 'addresses' stamp: 'HAW 5/22/2022 00:19:29'!
addresses

	^ addresses! !


!Customer methodsFor: 'identification' stamp: 'HAW 5/22/2022 00:19:29'!
identificationNumber

	^identificationNumber ! !

!Customer methodsFor: 'identification' stamp: 'HAW 5/22/2022 00:19:29'!
identificationType

	^identificationType ! !


!Customer methodsFor: 'initialization' stamp: 'LR 11/24/2023 11:12:05'!
initializeWithFirstName: aFirstName lastName: aLastName identification: aPartyId
	firstName := aFirstName.
	lastName := aLastName.
	identification := aPartyId.! !


!Customer methodsFor: 'testing' stamp: 'LR 11/24/2023 11:41:34'!
hasFirstName: aFirstName hasLastName: aLastName hasIdentification: anId 
	
	^(self hasFirstName: aFirstName) and: [
		lastName = aLastName and: [
			self isIdentifiedWith: anId
		]
	]! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Customer class' category: 'CustomerImporter'!
Customer class
	instanceVariableNames: ''!

!Customer class methodsFor: 'instance creation' stamp: 'LR 11/24/2023 11:11:39'!
withFirstName: firstName lastName: lastName identification: partyId
	^self new initializeWithFirstName: firstName lastName: lastName identification: partyId! !


!classDefinition: #Supplier category: 'CustomerImporter'!
Party subclass: #Supplier
	instanceVariableNames: 'customers'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!Supplier methodsFor: 'initialization' stamp: 'LR 11/24/2023 15:42:26'!
initializeWithName: aName identification: aPartyId
	firstName := aName.
	identification := aPartyId.
	customers := Set new.! !


!Supplier methodsFor: 'evaluating' stamp: 'LR 11/24/2023 15:41:56'!
findCustomerWithId: anId ifNone: aFallbackAction
	^customers detect: [ :customer |
		customer isIdentifiedWith: anId
	] ifNone: aFallbackAction! !

!Supplier methodsFor: 'evaluating' stamp: 'LR 11/24/2023 15:41:25'!
numberOfCustomers
	^customers size! !


!Supplier methodsFor: 'testing' stamp: 'LR 11/24/2023 11:35:53'!
isIdentifiedWith: supplierId withName: name 
	^(self isIdentifiedWith: supplierId) and: [ self hasFirstName: name ]! !



!Supplier methodsFor: 'updating' stamp: 'LR 11/23/2023 19:52:48'!
addAddress: anAddress

	addresses add: anAddress ! !

!Supplier methodsFor: 'updating' stamp: 'LR 11/24/2023 15:41:12'!
addCustomer: customer
	customers add: customer! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Supplier class' category: 'CustomerImporter'!
Supplier class
	instanceVariableNames: ''!

!Supplier class methodsFor: 'instance creation' stamp: 'LR 11/24/2023 11:13:14'!
withName: aName identification: aPartyId
	^self new initializeWithName: aName identification: aPartyId ! !


!classDefinition: #PartyId category: 'CustomerImporter'!
Object subclass: #PartyId
	instanceVariableNames: 'type number'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!PartyId methodsFor: 'initialization' stamp: 'LR 11/24/2023 11:17:19'!
initializeWithType: anIdType numbered: anIdNumber 
	type := anIdType.
	number := anIdNumber.! !


!PartyId methodsFor: 'testing' stamp: 'LR 11/24/2023 11:33:54'!
equals: anId 
	^number = anId number and: [ type = anId type ]! !


!PartyId methodsFor: 'accessing' stamp: 'LR 11/24/2023 11:33:12'!
number
	^number! !

!PartyId methodsFor: 'accessing' stamp: 'LR 11/24/2023 11:33:22'!
type
	^type! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'PartyId class' category: 'CustomerImporter'!
PartyId class
	instanceVariableNames: ''!

!PartyId class methodsFor: 'instance creation' stamp: 'LR 11/24/2023 11:16:36'!
ofType: idType numbered: idNumber 
	^self new initializeWithType: idType numbered: idNumber ! !
