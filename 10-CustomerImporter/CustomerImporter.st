!classDefinition: #ImportTest category: 'CustomerImporter'!
TestCase subclass: #ImportTest
	instanceVariableNames: 'session'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!ImportTest methodsFor: 'as yet unclassified' stamp: 'BR 11/14/2023 19:37:53'!
importCustomers

	^self importCustomersFrom: (UniFileStream new open: 'input.txt' forWrite: false).
	! !

!ImportTest methodsFor: 'as yet unclassified' stamp: 'BR 11/14/2023 20:09:33'!
importCustomersFrom: inputStream

	"
	self importCustomers
	"
	Importer new importFrom: inputStream persistInto: session.
	! !


!ImportTest methodsFor: 'assertions' stamp: 'BR 11/14/2023 19:26:50'!
assertAddress: anAddress hasStreetName: aStreetName andStreetNumber: aStreetNmb andTown: aTown andZipCode: aZipCode andProvince: aProvince
	self assert: anAddress streetName equals: aStreetName.
	self assert: anAddress streetNumber equals: aStreetNmb.
	self assert: anAddress town equals: aTown.
	self assert: anAddress zipCode equals: aZipCode.
	self assert: anAddress province equals: aProvince.! !

!ImportTest methodsFor: 'assertions' stamp: 'LR 11/13/2023 21:46:38'!
assertCustomer: customer hasName: aName withLastName: aLastName withIdNmb: anIdNmb withIdType: anIdType 
	self assert: customer firstName equals: aName.
	self assert: customer lastName equals: aLastName.
	self assert: customer identificationNumber equals: anIdNmb.
	self assert: customer identificationType equals: anIdType.! !

!ImportTest methodsFor: 'assertions' stamp: 'BR 11/14/2023 20:26:14'!
assertFirstCustomerWasImportedSucessfully
	
	|filteredList customer |

	filteredList := session select: [ :aCustomer | aCustomer identificationType = 'D' and: [ aCustomer identificationNumber = '22333444' ]] ofType: Customer.
	customer := filteredList anyOne.
	
	self assert: filteredList size equals: 1.
	self assertCustomer: customer hasName: 'Pepe' withLastName: 'Sanchez' withIdNmb: '22333444' withIdType: 'D'.
! !

!ImportTest methodsFor: 'assertions' stamp: 'BR 11/14/2023 20:26:23'!
assertSecondCustomerWasImportedSucessfully
	
	|filteredList customer |

	filteredList := session select: [ :aCustomer | aCustomer identificationType = 'C' and: [ aCustomer identificationNumber = '23-25666777-9' ]] ofType: Customer.
	customer := filteredList anyOne.
	
	self assert: filteredList size equals: 1.
	self assertCustomer: customer hasName: 'Juan' withLastName: 'Perez' withIdNmb: '23-25666777-9' withIdType: 'C'.
! !

!ImportTest methodsFor: 'assertions' stamp: 'BR 11/14/2023 20:22:16'!
asssertAddressesCorrectlyLoadedForFirstCustomer

	| filteredList customer|

	filteredList := session select: [ :aCustomer | aCustomer identificationType = 'D' and: [ aCustomer identificationNumber = '22333444' ]] ofType: Customer.
	
	self assert: (filteredList size) equals:1.
	self assert: (filteredList anyOne) addresses size equals: 2.
	
	customer := filteredList anyOne.
	
	self assertAddress: (customer addresses first) hasStreetName: 'San Martin' andStreetNumber: 3322 andTown: 'Olivos' andZipCode: 1636 andProvince: 'BsAs'.
	self assertAddress: (customer addresses second) hasStreetName: 'Maipu' andStreetNumber: 888 andTown: 'Florida' andZipCode: 1122 andProvince: 'Buenos Aires'.! !

!ImportTest methodsFor: 'assertions' stamp: 'BR 11/14/2023 20:23:18'!
asssertAddressesCorrectlyLoadedForSecondCustomer

	| filteredList customer |

	filteredList := session select: [ :aCustomer | aCustomer identificationType = 'C' and: [ aCustomer identificationNumber = '23-25666777-9' ]] ofType: Customer.
	
	self assert: (filteredList size) equals:1.
	self assert: (filteredList anyOne) addresses size equals: 1.
	
	customer := filteredList anyOne.
	
	self assertAddress: (customer addresses first) hasStreetName: 'Alem' andStreetNumber: 1122 andTown: 'CABA' andZipCode: 1001 andProvince: 'CABA'.! !


!ImportTest methodsFor: 'testing' stamp: 'BR 11/14/2023 20:25:13'!
test01CanImportCustomerSuccessfullyToDatabase

	|filteredList |
		
	self importCustomers. 
	
	self assertFirstCustomerWasImportedSucessfully.
	self assertSecondCustomerWasImportedSucessfully.
	

! !

!ImportTest methodsFor: 'testing' stamp: 'BR 11/14/2023 20:25:32'!
test02CanImportAddressSuccessfullyToCustomers

	|filteredList customer |
		
	self importCustomers. 
	
	self asssertAddressesCorrectlyLoadedForFirstCustomer.
	self asssertAddressesCorrectlyLoadedForSecondCustomer.
! !


!ImportTest methodsFor: 'setUp/tearDown' stamp: 'LR 11/13/2023 20:52:58'!
setUp

	session := DataBaseSession for: (Array with: Address with: Customer).
	session beginTransaction! !

!ImportTest methodsFor: 'setUp/tearDown' stamp: 'LR 11/13/2023 20:55:48'!
tearDown

	session commit.
	session close.! !


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

!Customer methodsFor: 'initialization' stamp: 'LR 11/13/2023 21:20:55'!
initializeWithName: aFirstName lastName: aLastName identificationType: anIdType identificationNumber: anIdNmb.
	firstName := aFirstName.
	lastName := aLastName.
	identificationType := anIdType.
	identificationNumber := anIdNmb.
	
	! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Customer class' category: 'CustomerImporter'!
Customer class
	instanceVariableNames: ''!


!Customer class methodsFor: 'as yet unclassified' stamp: 'LR 11/13/2023 21:15:06'!
customerWithName: firstName lastName: lastName identificationType: idType identificationNumber: idNmb  
	^self new initializeWithName: firstName lastName: lastName identificationType: idType identificationNumber: idNmb.! !


!classDefinition: #DataBaseSession category: 'CustomerImporter'!
Object subclass: #DataBaseSession
	instanceVariableNames: 'configuration tables id'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!DataBaseSession methodsFor: 'transaction management' stamp: 'HAW 5/22/2022 00:19:29'!
beginTransaction

	! !

!DataBaseSession methodsFor: 'transaction management' stamp: 'HAW 5/22/2022 19:17:36'!
commit

	(tables at: Customer ifAbsent: [#()]) do: [ :aCustomer | self persistAddressesOf: aCustomer ]
	! !


!DataBaseSession methodsFor: 'closing' stamp: 'HAW 5/22/2022 00:19:29'!
close

	! !


!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 5/22/2022 00:19:29'!
defineIdOf: anObject

	anObject instVarNamed: 'id' put: (self newIdFor: anObject).! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 5/22/2022 00:19:29'!
delay

	(Delay forMilliseconds: 100) wait! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 5/22/2022 19:29:06'!
objectsOfType: aType

	^ tables at: aType ifAbsent: [ #() ]! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 5/22/2022 00:19:29'!
persistAddressesOf: anObjectWithAddresses

	anObjectWithAddresses addresses do: [ :anAddress | self persist: anAddress ]
	! !


!DataBaseSession methodsFor: 'initialization' stamp: 'HAW 5/22/2022 00:19:29'!
initializeFor: aConfiguration

	configuration := aConfiguration.
	tables := Dictionary new.
	id := 0.! !


!DataBaseSession methodsFor: 'id' stamp: 'HAW 5/22/2022 00:19:29'!
newIdFor: anObject

	id := id + 1.
	^id! !


!DataBaseSession methodsFor: 'persistance' stamp: 'HAW 5/22/2022 00:19:29'!
persist: anObject

	| table |

	self delay.
	table := tables at: anObject class ifAbsentPut: [ Set new ].

	self defineIdOf: anObject.
	table add: anObject.

	(anObject isKindOf: Customer) ifTrue: [ self persistAddressesOf: anObject ].! !


!DataBaseSession methodsFor: 'selecting' stamp: 'HAW 5/22/2022 19:29:06'!
select: aCondition ofType: aType

	self delay.
	^(self objectsOfType: aType) select: aCondition ! !

!DataBaseSession methodsFor: 'selecting' stamp: 'HAW 5/22/2022 19:29:06'!
selectAllOfType: aType

	self delay.
	^(self objectsOfType: aType) copy ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'DataBaseSession class' category: 'CustomerImporter'!
DataBaseSession class
	instanceVariableNames: ''!

!DataBaseSession class methodsFor: 'instance creation' stamp: 'HAW 5/22/2022 00:19:29'!
for: aConfiguration

	^self new initializeFor: aConfiguration! !


!classDefinition: #Importer category: 'CustomerImporter'!
Object subclass: #Importer
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!Importer methodsFor: 'as yet unclassified' stamp: 'BR 11/14/2023 20:06:57'!
importFrom: inputStream persistInto: dbSession
	
	
	"
	self importCustomers
	"
	|  newCustomer line |

	line := inputStream nextLine.
	[ line notNil ] whileTrue: [
		(line beginsWith: 'C') ifTrue: [ | customerData |
			customerData := line findTokens: $,.
			newCustomer := Customer new.
			newCustomer firstName: customerData second.
			newCustomer lastName: customerData third.
			newCustomer identificationType: customerData fourth.
			newCustomer identificationNumber: customerData fifth.
			dbSession persist: newCustomer ].

		(line beginsWith: 'A') ifTrue: [ | addressData newAddress |
			addressData := line findTokens: $,.
			newAddress := Address new.
			newCustomer addAddress: newAddress.
			newAddress streetName: addressData second.
			newAddress streetNumber: addressData third asNumber .
			newAddress town: addressData fourth.
			newAddress zipCode: addressData fifth asNumber .
			newAddress province: addressData sixth ].

		line := inputStream nextLine. ].

	inputStream close.! !
