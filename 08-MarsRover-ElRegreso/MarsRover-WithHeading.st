!classDefinition: #MarsRoverLoggerTest category: 'MarsRover-WithHeading'!
TestCase subclass: #MarsRoverLoggerTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverLoggerTest methodsFor: 'as yet unclassified' stamp: 'BR 10/28/2023 20:41:49'!
east

	^ MarsRoverHeadingEast ! !

!MarsRoverLoggerTest methodsFor: 'as yet unclassified' stamp: 'BR 10/28/2023 20:42:03'!
north

	^ MarsRoverHeadingNorth! !

!MarsRoverLoggerTest methodsFor: 'as yet unclassified' stamp: 'BR 10/28/2023 20:42:12'!
south
	^ MarsRoverHeadingSouth! !

!MarsRoverLoggerTest methodsFor: 'as yet unclassified' stamp: 'BR 10/29/2023 23:56:53'!
test01HasEmptyLogWhenNoSubscribers
	|marsRover positions headings|
	
	positions := OrderedCollection new.
	headings := OrderedCollection new.
	
	marsRover := MarsRover at: 0@0 heading: self north.
	marsRover process: 'frblb'.
	
	marsRover subscribeToPosition: positions.
	marsRover subscribeToHeadings: headings.
	
	self assert: (positions isEmpty).
	self assert: (headings isEmpty).! !

!MarsRoverLoggerTest methodsFor: 'as yet unclassified' stamp: 'BR 10/30/2023 00:15:53'!
test02MarsroverCorrectlyNotifiesPositionAndHeadingChanges
	|marsRover positions headings|
	
	positions := OrderedCollection new.
	headings := OrderedCollection new.
	
	marsRover := MarsRover at: 0@0 heading: self north.

	marsRover subscribeToPosition: [:pos | positions add: pos].
	marsRover subscribeToHeadings: [:heading | headings add: heading].
	
	marsRover process: 'fr'.
	
	self assert: positions equals: (OrderedCollection with: 0@1).
	self assert: (headings first isHeading: self east)! !

!MarsRoverLoggerTest methodsFor: 'as yet unclassified' stamp: 'BR 10/30/2023 01:01:26'!
test03MarsroverCorrectlyNotifiesPositionAndHeadingToWindow
	|marsRover window|
	
	window := Window with: '' with: ''.
	
	marsRover := MarsRover at: 0@0 heading: self north.
	
	marsRover subscribeToPosition: [:pos | window modifyFirstValue: pos].
	marsRover process: 'frf'.
	marsRover subscribeToHeadings: [:heading | window modifySecondValue: heading].
	
	self assert: window firstValue equals: 1@1.
	self assert: window secondValue equals: ''.! !

!MarsRoverLoggerTest methodsFor: 'as yet unclassified' stamp: 'BR 10/30/2023 01:00:49'!
test04FollowsDirectionChangeCorrectly
	|marsRover window|
	
	window := Window with: '' with: ''.
	
	marsRover := MarsRover at: 0@0 heading: self north.
	
	marsRover subscribeToPosition: [:pos | window modifyFirstValue: pos].
	marsRover subscribeToHeadings: [:heading | window modifySecondValue: heading].
	marsRover process: 'frf'.
	
	
	self assert: window firstValue equals: 1@1.
	self assert: (window secondValue isHeading: self east).! !

!MarsRoverLoggerTest methodsFor: 'as yet unclassified' stamp: 'BR 10/28/2023 20:41:55'!
west

	^ MarsRoverHeadingWest ! !


!classDefinition: #MarsRoverTest category: 'MarsRover-WithHeading'!
TestCase subclass: #MarsRoverTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:21:23'!
test01DoesNotMoveWhenNoCommand

	self 
		assertIsAt: 1@2 
		heading: self north 
		afterProcessing: '' 
		whenStartingAt: 1@2 
		heading: self north 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:28:12'!
test02IsAtFailsForDifferentPosition

	| marsRover |
	
	marsRover := MarsRover at: 1@1 heading: self north . 
	
	self deny: (marsRover isAt: 1@2 heading: self north)! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:28:31'!
test03IsAtFailsForDifferentHeading

	| marsRover |
	
	marsRover := MarsRover at: 1@1 heading: self north . 
	
	self deny: (marsRover isAt: 1@1 heading: self south)! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:30:17'!
test04IncrementsYAfterMovingForwardWhenHeadingNorth

	self 
		assertIsAt: 1@3 
		heading: self north 
		afterProcessing: 'f' 
		whenStartingAt: 1@2 
		heading: self north 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:30:11'!
test06DecrementsYAfterMovingBackwardsWhenHeadingNorth

	self 
		assertIsAt: 1@1 
		heading: self north 
		afterProcessing: 'b' 
		whenStartingAt: 1@2 
		heading: self north 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:29:59'!
test07PointToEashAfterRotatingRightWhenHeadingNorth

	self 
		assertIsAt: 1@2 
		heading: self east 
		afterProcessing: 'r' 
		whenStartingAt: 1@2 
		heading: self north 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:29:51'!
test08PointsToWestAfterRotatingLeftWhenPointingNorth

	self 
		assertIsAt: 1@2 
		heading: self west 
		afterProcessing: 'l' 
		whenStartingAt: 1@2 
		heading: self north 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'BR 10/29/2023 22:58:41'!
test09DoesNotProcessInvalidCommand

	| marsRover |
	
	marsRover := MarsRover at: 1@2 heading: self north.
	
	self 
		should: [ marsRover process: 'x' ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: anError messageText equals: marsRover invalidCommandErrorDescription.
			self assert: (marsRover isAt: 1@2 heading: self north) ]! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:29:39'!
test10CanProcessMoreThanOneCommand

	self 
		assertIsAt: 1@4 
		heading: self north 
		afterProcessing: 'ff' 
		whenStartingAt: 1@2 
		heading: self north 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:29:31'!
test11IncrementsXAfterMovingForwareWhenHeadingEast

	self 
		assertIsAt: 2@2 
		heading: self east 
		afterProcessing: 'f' 
		whenStartingAt: 1@2 
		heading: self east 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:29:19'!
test12DecrementsXAfterMovingBackwardWhenHeadingEast

	self 
		assertIsAt: 0@2 
		heading: self east 
		afterProcessing: 'b' 
		whenStartingAt: 1@2 
		heading: self east 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:29:14'!
test13PointsToSouthAfterRotatingRightWhenHeadingEast

		self 
		assertIsAt: 1@2 
		heading: self south 
		afterProcessing: 'r' 
		whenStartingAt: 1@2 
		heading: self east 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:29:05'!
test14PointsToNorthAfterRotatingLeftWhenPointingEast

		self 
		assertIsAt: 1@2 
		heading: self north 
		afterProcessing: 'l' 
		whenStartingAt: 1@2 
		heading: self east 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:29:00'!
test15ForwardBackwardsAndRotateRightWorkAsExpectedWhenPointingSouth

	self 
		assertIsAt: 1@1 
		heading: self west 
		afterProcessing: 'ffblrr' 
		whenStartingAt: 1@2 
		heading: self south 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:28:52'!
test16ForwardBackwardsAndRotateRightWorkAsExpectedWhenPointingWest

	self 
		assertIsAt: 0@2 
		heading: self north 
		afterProcessing: 'ffblrr' 
		whenStartingAt: 1@2 
		heading: self west 
! !


!MarsRoverTest methodsFor: 'headings' stamp: 'HAW 10/7/2021 20:09:31'!
east

	^ MarsRoverHeadingEast ! !

!MarsRoverTest methodsFor: 'headings' stamp: 'HAW 10/7/2021 20:09:38'!
north

	^ MarsRoverHeadingNorth ! !

!MarsRoverTest methodsFor: 'headings' stamp: 'HAW 10/7/2021 20:09:45'!
south

	^ MarsRoverHeadingSouth ! !

!MarsRoverTest methodsFor: 'headings' stamp: 'HAW 10/7/2021 20:09:54'!
west

	^ MarsRoverHeadingWest ! !


!MarsRoverTest methodsFor: 'assertions' stamp: 'HAW 10/7/2021 20:20:47'!
assertIsAt: newPosition heading: newHeadingType afterProcessing: commands whenStartingAt: startPosition heading: startHeadingType

	| marsRover |
	
	marsRover := MarsRover at: startPosition heading: startHeadingType. 
	
	marsRover process: commands.
	
	self assert: (marsRover isAt: newPosition heading: newHeadingType)! !


!classDefinition: #MarsRover category: 'MarsRover-WithHeading'!
Object subclass: #MarsRover
	instanceVariableNames: 'position head'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRover methodsFor: 'exceptions' stamp: 'HAW 6/30/2018 19:48:45'!
invalidCommandErrorDescription
	
	^'Invalid command'! !

!MarsRover methodsFor: 'exceptions' stamp: 'HAW 6/30/2018 19:50:26'!
signalInvalidCommand
	
	self error: self invalidCommandErrorDescription ! !


!MarsRover methodsFor: 'initialization' stamp: 'BR 10/29/2023 23:28:10'!
initializeAt: aPosition heading: aHeadingType

	position := Proxy with: aPosition.
	head := Proxy with: (aHeadingType for: self). ! !


!MarsRover methodsFor: 'heading' stamp: 'BR 10/29/2023 23:28:44'!
headEast
	
	head modifyValue: (MarsRoverHeadingEast for: self).
	! !

!MarsRover methodsFor: 'heading' stamp: 'BR 10/29/2023 23:28:55'!
headNorth
	
	head modifyValue: (MarsRoverHeadingNorth for: self).
	! !

!MarsRover methodsFor: 'heading' stamp: 'BR 10/29/2023 23:29:04'!
headSouth
	
	head modifyValue: (MarsRoverHeadingSouth for: self).
	! !

!MarsRover methodsFor: 'heading' stamp: 'BR 10/29/2023 23:29:16'!
headWest
	
	head modifyValue: (MarsRoverHeadingWest for: self).
	! !

!MarsRover methodsFor: 'heading' stamp: 'BR 10/29/2023 23:34:42'!
heading
	^head value! !

!MarsRover methodsFor: 'heading' stamp: 'BR 10/29/2023 23:34:52'!
position
	^position value! !

!MarsRover methodsFor: 'heading' stamp: 'BR 10/29/2023 23:39:44'!
rotateLeft
	
	self heading rotateLeft! !

!MarsRover methodsFor: 'heading' stamp: 'BR 10/29/2023 23:39:51'!
rotateRight
	
	self heading rotateRight! !


!MarsRover methodsFor: 'testing' stamp: 'BR 10/29/2023 23:35:23'!
isAt: aPosition heading: aHeadingType

	^(self position = aPosition) and: [ self heading isHeading: aHeadingType ]! !

!MarsRover methodsFor: 'testing' stamp: 'HAW 7/6/2018 18:16:51'!
isBackwardCommand: aCommand

	^aCommand = $b! !

!MarsRover methodsFor: 'testing' stamp: 'HAW 7/6/2018 18:16:19'!
isForwardCommand: aCommand

	^aCommand = $f ! !

!MarsRover methodsFor: 'testing' stamp: 'HAW 7/6/2018 18:17:51'!
isRotateLeftCommand: aCommand

	^aCommand = $l! !

!MarsRover methodsFor: 'testing' stamp: 'HAW 7/6/2018 18:17:21'!
isRotateRightCommand: aCommand

	^aCommand = $r! !

!MarsRover methodsFor: 'testing' stamp: 'BR 10/29/2023 23:43:24'!
subscribeToHeadings: actionToPerformOnSubs
	head addSubscriber: actionToPerformOnSubs .! !

!MarsRover methodsFor: 'testing' stamp: 'BR 10/29/2023 23:42:49'!
subscribeToPosition: actionToPerformOnSubs
	position addSubscriber: actionToPerformOnSubs .! !


!MarsRover methodsFor: 'moving' stamp: 'BR 10/29/2023 23:36:24'!
moveBackward
	
	self heading moveBackward! !

!MarsRover methodsFor: 'moving' stamp: 'BR 10/29/2023 23:45:42'!
moveEast
	
	position modifyValue: (self position + (1@0)).
	! !

!MarsRover methodsFor: 'moving' stamp: 'BR 10/29/2023 23:38:43'!
moveForward
	
	self heading moveForward! !

!MarsRover methodsFor: 'moving' stamp: 'BR 10/29/2023 23:45:48'!
moveNorth
	
	position modifyValue: (self position + (0@1)).
	
	! !

!MarsRover methodsFor: 'moving' stamp: 'BR 10/29/2023 23:45:52'!
moveSouth
	
	position modifyValue: (self position + (0@-1)).
	! !

!MarsRover methodsFor: 'moving' stamp: 'BR 10/29/2023 23:45:56'!
moveWest
	
	position modifyValue: (self position + (-1@0)).
	! !


!MarsRover methodsFor: 'command processing' stamp: 'HAW 6/30/2018 19:48:26'!
process: aSequenceOfCommands

	aSequenceOfCommands do: [:aCommand | self processCommand: aCommand ]
! !

!MarsRover methodsFor: 'command processing' stamp: 'HAW 8/22/2019 12:08:50'!
processCommand: aCommand

	(self isForwardCommand: aCommand) ifTrue: [ ^ self moveForward ].
	(self isBackwardCommand: aCommand) ifTrue: [ ^ self moveBackward ].
	(self isRotateRightCommand: aCommand) ifTrue: [ ^ self rotateRight ].
	(self isRotateLeftCommand: aCommand) ifTrue: [ ^ self rotateLeft ].

	self signalInvalidCommand.! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MarsRover class' category: 'MarsRover-WithHeading'!
MarsRover class
	instanceVariableNames: 'headings'!

!MarsRover class methodsFor: 'instance creation' stamp: 'HAW 10/7/2021 20:10:30'!
at: aPosition heading: aHeadingType
	
	^self new initializeAt: aPosition heading: aHeadingType! !


!classDefinition: #MarsRoverHeading category: 'MarsRover-WithHeading'!
Object subclass: #MarsRoverHeading
	instanceVariableNames: 'marsRover'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverHeading methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:20'!
rotateLeft

	self subclassResponsibility ! !

!MarsRoverHeading methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:44'!
rotateRight

	self subclassResponsibility ! !


!MarsRoverHeading methodsFor: 'testing' stamp: 'HAW 10/7/2021 20:15:38'!
isHeading: aHeadingType

	^self isKindOf: aHeadingType ! !


!MarsRoverHeading methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:24'!
moveBackward

	self subclassResponsibility ! !

!MarsRoverHeading methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:53'!
moveForward

	self subclassResponsibility ! !


!MarsRoverHeading methodsFor: 'initialization' stamp: 'HAW 10/7/2021 20:11:59'!
initializeFor: aMarsRover 
	
	marsRover := aMarsRover.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MarsRoverHeading class' category: 'MarsRover-WithHeading'!
MarsRoverHeading class
	instanceVariableNames: ''!

!MarsRoverHeading class methodsFor: 'instance creation' stamp: 'HAW 10/7/2021 20:11:35'!
for: aMarsRover 
	
	^self new initializeFor: aMarsRover ! !


!classDefinition: #MarsRoverHeadingEast category: 'MarsRover-WithHeading'!
MarsRoverHeading subclass: #MarsRoverHeadingEast
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverHeadingEast methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:24'!
moveBackward
	
	^marsRover moveWest! !

!MarsRoverHeadingEast methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:53'!
moveForward
	
	^marsRover moveEast! !


!MarsRoverHeadingEast methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:20'!
rotateLeft
	
	^marsRover headNorth! !

!MarsRoverHeadingEast methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:44'!
rotateRight
	
	^marsRover headSouth! !


!classDefinition: #MarsRoverHeadingNorth category: 'MarsRover-WithHeading'!
MarsRoverHeading subclass: #MarsRoverHeadingNorth
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverHeadingNorth methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:24'!
moveBackward
	
	^marsRover moveSouth! !

!MarsRoverHeadingNorth methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:53'!
moveForward
	
	^marsRover moveNorth! !


!MarsRoverHeadingNorth methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:20'!
rotateLeft
	
	^marsRover headWest! !

!MarsRoverHeadingNorth methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:44'!
rotateRight
	
	^marsRover headEast! !


!classDefinition: #MarsRoverHeadingSouth category: 'MarsRover-WithHeading'!
MarsRoverHeading subclass: #MarsRoverHeadingSouth
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverHeadingSouth methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:24'!
moveBackward
	
	^marsRover moveNorth! !

!MarsRoverHeadingSouth methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:53'!
moveForward
	
	^marsRover moveSouth! !


!MarsRoverHeadingSouth methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:20'!
rotateLeft
	
	^marsRover headEast! !

!MarsRoverHeadingSouth methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:44'!
rotateRight
	
	^marsRover headWest! !


!classDefinition: #MarsRoverHeadingWest category: 'MarsRover-WithHeading'!
MarsRoverHeading subclass: #MarsRoverHeadingWest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverHeadingWest methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:24'!
moveBackward

	^marsRover moveEast! !

!MarsRoverHeadingWest methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:53'!
moveForward
	
	^marsRover moveWest! !


!MarsRoverHeadingWest methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:20'!
rotateLeft
	
	^marsRover headSouth! !

!MarsRoverHeadingWest methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:44'!
rotateRight
	
	^marsRover headNorth! !


!classDefinition: #Proxy category: 'MarsRover-WithHeading'!
Object subclass: #Proxy
	instanceVariableNames: 'value subscribers'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!Proxy methodsFor: 'as yet unclassified' stamp: 'BR 10/29/2023 23:41:21'!
addSubscriber: aSubscriber
	subscribers add: aSubscriber .! !

!Proxy methodsFor: 'as yet unclassified' stamp: 'BR 10/29/2023 23:41:36'!
initializeWith: initialValue
	value := initialValue.
	subscribers := OrderedCollection new.! !

!Proxy methodsFor: 'as yet unclassified' stamp: 'BR 10/29/2023 23:27:31'!
modifyValue: newValue

	value := newValue.
	subscribers do: [:subscriber | subscriber value: newValue].! !

!Proxy methodsFor: 'as yet unclassified' stamp: 'BR 10/29/2023 23:21:02'!
value
	^value! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Proxy class' category: 'MarsRover-WithHeading'!
Proxy class
	instanceVariableNames: ''!

!Proxy class methodsFor: 'as yet unclassified' stamp: 'BR 10/29/2023 23:21:34'!
with: value
	^self new initializeWith: value! !


!classDefinition: #Window category: 'MarsRover-WithHeading'!
Object subclass: #Window
	instanceVariableNames: 'value anothervalue'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!Window methodsFor: 'as yet unclassified' stamp: 'BR 10/30/2023 00:57:05'!
firstValue
	^value! !

!Window methodsFor: 'as yet unclassified' stamp: 'BR 10/30/2023 00:47:08'!
initializeWith: aValue with: anotherValue
	value := aValue.
	anothervalue := anotherValue.! !

!Window methodsFor: 'as yet unclassified' stamp: 'BR 10/30/2023 00:55:06'!
modifyFirstValue: newValue
	value := newValue! !

!Window methodsFor: 'as yet unclassified' stamp: 'BR 10/30/2023 00:55:19'!
modifySecondValue: newValue
	anothervalue := newValue! !

!Window methodsFor: 'as yet unclassified' stamp: 'BR 10/30/2023 00:57:13'!
secondValue
	^anothervalue! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Window class' category: 'MarsRover-WithHeading'!
Window class
	instanceVariableNames: ''!

!Window class methodsFor: 'as yet unclassified' stamp: 'BR 10/30/2023 00:44:48'!
with: aValue with: anotherValue
	^self new initializeWith: aValue with: anotherValue.! !
