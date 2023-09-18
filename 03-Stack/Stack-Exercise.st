!classDefinition: #OOStackTest category: 'Stack-Exercise'!
TestCase subclass: #OOStackTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!OOStackTest methodsFor: 'test' stamp: 'HernanWilkinson 5/7/2012 11:30'!
test01StackShouldBeEmptyWhenCreated

	| stack |
	
	stack := OOStack new.
	
	self assert: stack isEmpty! !

!OOStackTest methodsFor: 'test' stamp: 'NR 5/13/2020 13:29:55'!
test02PushAddElementsToTheStack

	| stack |
	
	stack := OOStack new.
	stack push: 'something'.
	
	self deny: stack isEmpty! !

!OOStackTest methodsFor: 'test' stamp: 'NR 5/13/2020 13:30:01'!
test03PopRemovesElementsFromTheStack

	| stack |
	
	stack := OOStack new.
	stack push: 'something'.
	stack pop.
	
	self assert: stack isEmpty! !

!OOStackTest methodsFor: 'test' stamp: 'LR 9/14/2023 21:13:18'!
test04PopReturnsLastPushedObject

	| stack pushedObject |
	
	stack := OOStack new.
	pushedObject := 'something'.
	stack push: pushedObject.
	
	self assert: stack pop = pushedObject.! !

!OOStackTest methodsFor: 'test' stamp: 'NR 9/16/2021 17:40:17'!
test05StackBehavesLIFO

	| stack firstPushedObject secondPushedObject |
	
	stack := OOStack new.
	firstPushedObject := 'firstSomething'.
	secondPushedObject := 'secondSomething'.
	
	stack push: firstPushedObject.
	stack push: secondPushedObject.
	
	self assert: stack pop = secondPushedObject.
	self assert: stack pop = firstPushedObject.
	self assert: stack isEmpty 
	! !

!OOStackTest methodsFor: 'test' stamp: 'NR 5/13/2020 13:30:20'!
test06TopReturnsLastPushedObject

	| stack pushedObject |
	
	stack := OOStack new.
	pushedObject := 'something'.
	
	stack push: pushedObject.
	
	self assert: stack top = pushedObject.
	! !

!OOStackTest methodsFor: 'test' stamp: 'NR 5/13/2020 13:30:24'!
test07TopDoesNotRemoveObjectFromStack

	| stack pushedObject |
	
	stack := OOStack new.
	pushedObject := 'something'.
	
	stack push: pushedObject.
	
	self assert: stack size = 1.
	stack top.
	self assert: stack size = 1.
	! !

!OOStackTest methodsFor: 'test' stamp: 'HAW 4/14/2017 22:48:26'!
test08CanNotPopWhenThereAreNoObjectsInTheStack

	| stack  |
	
	stack := OOStack new.
	self
		should: [ stack pop ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: anError messageText = OOStack stackEmptyErrorDescription ]
		
! !

!OOStackTest methodsFor: 'test' stamp: 'NR 5/13/2020 13:30:31'!
test09CanNotPopWhenThereAreNoObjectsInTheStackAndTheStackHadObjects

	| stack  |
	
	stack := OOStack new.
	stack push: 'something'.
	stack pop.
	
	self
		should: [ stack pop ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: anError messageText = OOStack stackEmptyErrorDescription ]
		
! !

!OOStackTest methodsFor: 'test' stamp: 'HAW 4/14/2017 22:48:44'!
test10CanNotTopWhenThereAreNoObjectsInTheStack

	| stack  |
	
	stack := OOStack new.
	self
		should: [ stack top ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: anError messageText = OOStack stackEmptyErrorDescription ]
		
! !


!classDefinition: #SentenceFinderByPrefixTest category: 'Stack-Exercise'!
TestCase subclass: #SentenceFinderByPrefixTest
	instanceVariableNames: 'sentenceFinder'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!SentenceFinderByPrefixTest methodsFor: 'test' stamp: 'LR 9/18/2023 10:21:40'!
testCannotUseInvalidPrefixes
	| aStack |
	aStack := OOStack new.
	self
		should: [ sentenceFinder findByPrefix: '' in: aStack ]
		raise: Error
		withExceptionDo: [:error | 
			error messageText = (SentenceFinderByPrefix invalidPrefixErrorDescription)
		]! !

!SentenceFinderByPrefixTest methodsFor: 'test' stamp: 'LR 9/16/2023 12:01:35'!
testEmptyResultInStackWithOneSentence
	| aStackWithOneSentence sentence foundSentences |
	sentence := 'Winter is here'.
	aStackWithOneSentence := self stackWithSentence: sentence.
	
	foundSentences := sentenceFinder findByPrefix: 'here' in: aStackWithOneSentence.
	
	self assert: foundSentences isEmpty! !

!SentenceFinderByPrefixTest methodsFor: 'test' stamp: 'LR 9/15/2023 20:23:58'!
testEmptyResultWhenStackHasNoSentences
	| anEmptyStack foundSentences |
	anEmptyStack := OOStack new.
	
	foundSentences := sentenceFinder findByPrefix: 'some prefix' in: anEmptyStack.
	
	self assert: foundSentences isEmpty
	! !

!SentenceFinderByPrefixTest methodsFor: 'test' stamp: 'LR 9/18/2023 10:24:11'!
testLookingForPrefixesDoesntModifyTheStack
	| aStackWithTwoSentences firstSentence secondSentence |
	firstSentence := 'Winter is here'.
	secondSentence := 'winter is here'.
	aStackWithTwoSentences := self stackWithSentence: firstSentence.
	aStackWithTwoSentences push: secondSentence.	
	
	sentenceFinder findByPrefix: 'Win' in: aStackWithTwoSentences.
	
	self assert: aStackWithTwoSentences pop equals: secondSentence.
	self assert: aStackWithTwoSentences pop equals: firstSentence.! !

!SentenceFinderByPrefixTest methodsFor: 'test' stamp: 'LR 9/18/2023 10:12:53'!
testSingleResultInStackWithOneSentence
	| aStackWithOneSentence sentence foundSentences |
	sentence := 'Winter is here'.
	aStackWithOneSentence := self stackWithSentence: sentence.
	
	foundSentences := sentenceFinder findByPrefix: 'Win' in: aStackWithOneSentence.
	
	self assert: foundSentences size equals: 1.
	self assert: foundSentences last equals: sentence! !

!SentenceFinderByPrefixTest methodsFor: 'test' stamp: 'LR 9/16/2023 12:01:52'!
testTwoResultsInStackWithThreeSentences
	| aStackWithThreeSentences foundSentences |
	aStackWithThreeSentences := self stackWithSentence: 'Winter is here'.
	aStackWithThreeSentences push: 'here is Winter'.
	aStackWithThreeSentences push: 'Winter here is'.
	
	foundSentences := sentenceFinder findByPrefix: 'Win' in: aStackWithThreeSentences.
	
	self assert: foundSentences size equals: 2.
	self assert: foundSentences includes: 'Winter is here'.
	self assert: foundSentences includes: 'Winter here is'.! !


!SentenceFinderByPrefixTest methodsFor: 'setup' stamp: 'LR 9/15/2023 19:53:48'!
setUp
	sentenceFinder := SentenceFinderByPrefix new! !


!SentenceFinderByPrefixTest methodsFor: 'stackInitialization' stamp: 'LR 9/15/2023 20:17:44'!
stackWithSentence: aSentence
	| aStack |
	aStack := OOStack new.
	aStack push: aSentence.
	^aStack! !


!classDefinition: #OOStack category: 'Stack-Exercise'!
Object subclass: #OOStack
	instanceVariableNames: 'items'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!OOStack methodsFor: 'observation' stamp: 'LR 9/15/2023 13:09:33'!
isEmpty
	^items size = 1! !

!OOStack methodsFor: 'observation' stamp: 'LR 9/15/2023 14:45:03'!
size
	^items size - 1! !

!OOStack methodsFor: 'observation' stamp: 'LR 9/15/2023 14:45:21'!
top
	^items last top! !


!OOStack methodsFor: 'manipulation' stamp: 'LR 9/15/2023 13:10:45'!
pop
	^items last popFrom: self! !

!OOStack methodsFor: 'manipulation' stamp: 'LR 9/15/2023 14:58:25'!
popNonEmpty
	| lastItem |
	lastItem := items last.
	items removeLast.
	^lastItem value! !

!OOStack methodsFor: 'manipulation' stamp: 'LR 9/15/2023 13:12:13'!
push: anItem
	items add: (OOStackItem of: anItem)! !


!OOStack methodsFor: 'initialization' stamp: 'LR 9/15/2023 19:21:03'!
initialize
	items := OrderedCollection new.
	items add: OOStackBase new.
	^self! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'OOStack class' category: 'Stack-Exercise'!
OOStack class
	instanceVariableNames: ''!

!OOStack class methodsFor: 'error descriptions' stamp: 'NR 9/14/2023 08:12:21'!
stackEmptyErrorDescription
	
	^ 'stack is empty!!!!!!'! !


!classDefinition: #OOStackBase category: 'Stack-Exercise'!
Object subclass: #OOStackBase
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!OOStackBase methodsFor: 'observation' stamp: 'LR 9/15/2023 14:45:59'!
top
	self error: OOStack stackEmptyErrorDescription ! !


!OOStackBase methodsFor: 'stackManipulation' stamp: 'LR 9/15/2023 13:08:55'!
popFrom: aStack
	self error: OOStack stackEmptyErrorDescription ! !


!classDefinition: #OOStackItem category: 'Stack-Exercise'!
Object subclass: #OOStackItem
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!OOStackItem methodsFor: 'initialization' stamp: 'LR 9/15/2023 14:50:03'!
initializeWith: aValue
	value := aValue.
	^self! !


!OOStackItem methodsFor: 'stackManipulation' stamp: 'LR 9/15/2023 14:43:49'!
popFrom: aStack
	^aStack popNonEmpty! !


!OOStackItem methodsFor: 'observation' stamp: 'LR 9/15/2023 14:46:13'!
top
	^value! !

!OOStackItem methodsFor: 'observation' stamp: 'LR 9/15/2023 19:18:47'!
value
	^value! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'OOStackItem class' category: 'Stack-Exercise'!
OOStackItem class
	instanceVariableNames: ''!

!OOStackItem class methodsFor: 'as yet unclassified' stamp: 'LR 9/15/2023 13:12:57'!
of: anItem
	^self new initializeWith: anItem! !


!classDefinition: #SentenceFinderByPrefix category: 'Stack-Exercise'!
Object subclass: #SentenceFinderByPrefix
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!SentenceFinderByPrefix methodsFor: 'main' stamp: 'LR 9/18/2023 09:49:02'!
findByPrefix: aPrefix in: aStack
	| complyingSentences auxiliaryStack |
	self validatePrefix: aPrefix.
	complyingSentences := OrderedCollection new.
	auxiliaryStack := OOStack new.
	self popAllFrom: aStack into: auxiliaryStack andForEach: [ :poppedSentence | 
		self addSentence: poppedSentence to: complyingSentences ifItBeginsWith: aPrefix
	].
	self popAllFrom: auxiliaryStack into: aStack.
	^complyingSentences! !


!SentenceFinderByPrefix methodsFor: 'auxiliary' stamp: 'LR 9/16/2023 12:39:48'!
addSentence: aSentence to: aCollection ifItBeginsWith: aPrefix
	(aSentence beginsWith: aPrefix) ifTrue: [ aCollection add: aSentence ]! !

!SentenceFinderByPrefix methodsFor: 'auxiliary' stamp: 'LR 9/18/2023 10:07:21'!
popAllFrom: stackToPopFrom into: stackToPushTo
	self popAllFrom: stackToPopFrom into: stackToPushTo andForEach: [:x | ]! !

!SentenceFinderByPrefix methodsFor: 'auxiliary' stamp: 'LR 9/16/2023 12:26:51'!
popAllFrom: aStackToPopFrom into: aStackToPushTo andForEach: aClosureForASentence
	| poppedSentence |
	[ aStackToPopFrom isEmpty ] whileFalse: [
		poppedSentence := self popFrom: aStackToPopFrom into: aStackToPushTo.
		aClosureForASentence value: poppedSentence
	]! !

!SentenceFinderByPrefix methodsFor: 'auxiliary' stamp: 'LR 9/16/2023 12:16:44'!
popFrom: stackToPopFrom into: stackToPushTo

	| poppedSentence |
	poppedSentence := stackToPopFrom pop.
	stackToPushTo push: poppedSentence.
	^poppedSentence! !

!SentenceFinderByPrefix methodsFor: 'auxiliary' stamp: 'LR 9/18/2023 09:54:17'!
validatePrefix: aPrefix
	((aPrefix = '') or: (aPrefix includesSubString: '')) ifTrue: [
		self error: self class invalidPrefixErrorDescription
	]! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SentenceFinderByPrefix class' category: 'Stack-Exercise'!
SentenceFinderByPrefix class
	instanceVariableNames: ''!

!SentenceFinderByPrefix class methodsFor: 'as yet unclassified' stamp: 'LR 9/18/2023 10:00:35'!
invalidPrefixErrorDescription
	^'A prefix cannot be blank or contain spaces'! !
