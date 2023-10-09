!classDefinition: #TestMarsRover category: 'MarsRoverExercise'!
TestCase subclass: #TestMarsRover
	instanceVariableNames: 'north south west east'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRoverExercise'!

!TestMarsRover methodsFor: 'as yet unclassified' stamp: 'LR 10/8/2023 20:24:46'!
initialize
	north := Orientation north.
	south := Orientation south.
	west := Orientation west.
	east := Orientation east.! !

!TestMarsRover methodsFor: 'as yet unclassified' stamp: 'BR 10/9/2023 01:03:46'!
test01MarsRoverProcessEmptyCommand
	|marsRover|
	
	marsRover := MarsRover deployAt: 0@0 facing: north.
	marsRover processCommand: ''.
	
	self assert: (marsRover isAt: 0@0 facing: north).! !

!TestMarsRover methodsFor: 'as yet unclassified' stamp: 'BR 10/9/2023 01:03:46'!
test02MarsRoverProcessMoveForwardsCommand
	|marsRover|
	
	marsRover := MarsRover deployAt: 0@0 facing: north.
	marsRover processCommand: 'f'.
	
	self assert: (marsRover isAt: 0@1 facing: north).! !

!TestMarsRover methodsFor: 'as yet unclassified' stamp: 'BR 10/9/2023 01:03:46'!
test03MarsRoverProcessMoveBackwardsCommand
	|marsRover|
	
	marsRover := MarsRover deployAt: 0@0 facing: north.
	marsRover processCommand: 'b'.
	
	self assert: (marsRover isAt: 0@-1 facing: north).! !

!TestMarsRover methodsFor: 'as yet unclassified' stamp: 'BR 10/9/2023 01:03:46'!
test04MarsRoverProcessRotateLeftCommandWhenFacingNorth
	|marsRover|
	
	marsRover := MarsRover deployAt: 0@0 facing: north.
	marsRover processCommand: 'l'.
	
	self assert: (marsRover isAt: 0@0 facing: west).! !

!TestMarsRover methodsFor: 'as yet unclassified' stamp: 'BR 10/9/2023 01:03:46'!
test05MarsRoverProcessRotateLeftCommandWhenFacingWest
	|marsRover|
	
	marsRover := MarsRover deployAt: 0@0 facing: west.
	marsRover processCommand: 'l'.
	
	self assert: (marsRover isAt: 0@0 facing: south).! !

!TestMarsRover methodsFor: 'as yet unclassified' stamp: 'BR 10/9/2023 01:03:46'!
test06MarsRoverProcessRotateLeftCommandWhenFacingSouth
	|marsRover|
	
	marsRover := MarsRover deployAt: 0@0 facing: south.
	marsRover processCommand: 'l'.
	
	self assert: (marsRover isAt: 0@0 facing: east).! !

!TestMarsRover methodsFor: 'as yet unclassified' stamp: 'BR 10/9/2023 01:03:46'!
test07MarsRoverProcessRotateLeftCommandWhenFacingEast
	|marsRover|
	
	marsRover := MarsRover deployAt: 0@0 facing: east.
	marsRover processCommand: 'l'.
	
	self assert: (marsRover isAt: 0@0 facing: north).! !

!TestMarsRover methodsFor: 'as yet unclassified' stamp: 'BR 10/9/2023 01:03:46'!
test08MarsRoverProcessRotateRightCommandWhenFacingNorth
	|marsRover|
	
	marsRover := MarsRover deployAt: 0@0 facing: north.
	marsRover processCommand: 'r'.
	
	self assert: (marsRover isAt: 0@0 facing: east).! !

!TestMarsRover methodsFor: 'as yet unclassified' stamp: 'BR 10/9/2023 01:03:46'!
test09MarsRoverProcessRotateRightCommandWhenFacingEast
	|marsRover|
	
	marsRover := MarsRover deployAt: 0@0 facing: east.
	marsRover processCommand: 'r'.
	
	self assert: (marsRover isAt: 0@0 facing: south).! !

!TestMarsRover methodsFor: 'as yet unclassified' stamp: 'BR 10/9/2023 01:03:46'!
test10MarsRoverProcessRotateRightCommandWhenFacingSouth
	|marsRover|
	
	marsRover := MarsRover deployAt: 0@0 facing: south.
	marsRover processCommand: 'r'.
	
	self assert: (marsRover isAt: 0@0 facing: west).! !

!TestMarsRover methodsFor: 'as yet unclassified' stamp: 'BR 10/9/2023 01:03:46'!
test11MarsRoverProcessRotateRightCommandWhenFacingWest
	|marsRover|
	
	marsRover := MarsRover deployAt: 0@0 facing: west.
	marsRover processCommand: 'r'.
	
	self assert: (marsRover isAt: 0@0 facing: north).! !

!TestMarsRover methodsFor: 'as yet unclassified' stamp: 'LR 10/9/2023 08:52:31'!
test12MarsRoverProcessManyValidCommands
	|marsRover|
	
	marsRover := MarsRover deployAt: 0@0 facing: north.
	marsRover processCommand: 'rb'.
	
	self assert: (marsRover isAt: -1@0 facing: east).! !

!TestMarsRover methodsFor: 'as yet unclassified' stamp: 'LR 10/9/2023 09:39:17'!
test13MarsRoverProcessInvalidCommandInTheMiddle
	|marsRover|
	
	marsRover := MarsRover deployAt: 0@0 facing: north.
	
	self 
		should: [ marsRover processCommand: 'rxb' ]
		raise: Error
		description: MarsRover invalidCommandErrorDescription.
	self assert: (marsRover isAt: 0@0 facing: east).! !


!classDefinition: #MarsRover category: 'MarsRoverExercise'!
Object subclass: #MarsRover
	instanceVariableNames: 'position orientation'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRoverExercise'!

!MarsRover methodsFor: 'as yet unclassified' stamp: 'LR 10/9/2023 09:50:59'!
isAt: aPoint facing: aCardinalPoint
	^(position = aPoint) and: (orientation = aCardinalPoint).! !

!MarsRover methodsFor: 'as yet unclassified' stamp: 'LR 10/9/2023 09:50:59'!
with: aPoint facing: aCardinalPoint
	position := aPoint.
	orientation := aCardinalPoint.! !


!MarsRover methodsFor: 'processing' stamp: 'LR 10/9/2023 08:59:48'!
processCommand: commands
	commands do: [ :command |
		(MarsRoverCommand commandParse: command) sendTo: self
	]
	! !


!MarsRover methodsFor: 'movement' stamp: 'LR 10/9/2023 09:50:59'!
moveBackwards
	^position := orientation moveBackwards: position.! !

!MarsRover methodsFor: 'movement' stamp: 'LR 10/9/2023 09:51:14'!
moveForward
	^position := orientation moveForward: position.! !

!MarsRover methodsFor: 'movement' stamp: 'LR 10/9/2023 09:50:59'!
rotateLeft
	orientation := orientation rotateLeft! !

!MarsRover methodsFor: 'movement' stamp: 'LR 10/9/2023 09:50:59'!
rotateRight
	orientation := orientation rotateRight! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MarsRover class' category: 'MarsRoverExercise'!
MarsRover class
	instanceVariableNames: ''!

!MarsRover class methodsFor: 'as yet unclassified' stamp: 'BR 10/9/2023 01:03:46'!
deployAt: aPoint facing: aCardinalPoint
	^MarsRover new with: aPoint facing: aCardinalPoint.! !

!MarsRover class methodsFor: 'as yet unclassified' stamp: 'LR 10/9/2023 09:39:35'!
invalidCommandErrorDescription
	^'Invalid command'! !


!classDefinition: #MarsRoverCommand category: 'MarsRoverExercise'!
Object subclass: #MarsRoverCommand
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRoverExercise'!

!MarsRoverCommand methodsFor: 'as yet unclassified' stamp: 'LR 10/9/2023 09:00:04'!
sendTo: aMarsRover

	self subclassResponsibility! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MarsRoverCommand class' category: 'MarsRoverExercise'!
MarsRoverCommand class
	instanceVariableNames: ''!

!MarsRoverCommand class methodsFor: 'as yet unclassified' stamp: 'LR 10/9/2023 09:51:44'!
commandParse: aCommandCharacter
	(aCommandCharacter = $f) ifTrue: [^MoveForwardCommand new.].
	(aCommandCharacter = $b) ifTrue: [^MoveBackwardsCommand new.].
	(aCommandCharacter = $l) ifTrue: [^RotateLeftCommand new.].
	(aCommandCharacter = $r) ifTrue: [^RotateRightCommand new.].
	self error: 'Invalid command'! !


!classDefinition: #MoveBackwardsCommand category: 'MarsRoverExercise'!
MarsRoverCommand subclass: #MoveBackwardsCommand
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRoverExercise'!

!MoveBackwardsCommand methodsFor: 'as yet unclassified' stamp: 'LR 10/9/2023 09:00:04'!
sendTo: aMarsRover
	
	aMarsRover moveBackwards.! !


!classDefinition: #MoveForwardCommand category: 'MarsRoverExercise'!
MarsRoverCommand subclass: #MoveForwardCommand
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRoverExercise'!

!MoveForwardCommand methodsFor: 'as yet unclassified' stamp: 'LR 10/9/2023 09:51:38'!
sendTo: aMarsRover
	
	aMarsRover moveForward.! !


!classDefinition: #RotateLeftCommand category: 'MarsRoverExercise'!
MarsRoverCommand subclass: #RotateLeftCommand
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRoverExercise'!

!RotateLeftCommand methodsFor: 'as yet unclassified' stamp: 'LR 10/9/2023 09:00:04'!
sendTo: aMarsRover
	
	aMarsRover rotateLeft.! !


!classDefinition: #RotateRightCommand category: 'MarsRoverExercise'!
MarsRoverCommand subclass: #RotateRightCommand
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRoverExercise'!

!RotateRightCommand methodsFor: 'as yet unclassified' stamp: 'LR 10/9/2023 09:00:04'!
sendTo: aMarsRover
	
	aMarsRover rotateRight.! !


!classDefinition: #Orientation category: 'MarsRoverExercise'!
Object subclass: #Orientation
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRoverExercise'!

!Orientation methodsFor: 'as yet unclassified' stamp: 'LR 10/9/2023 09:44:20'!
moveBackwards: aPoint

	self subclassResponsibility! !

!Orientation methodsFor: 'as yet unclassified' stamp: 'LR 10/9/2023 09:44:14'!
moveForward: aPoint

	self subclassResponsibility! !

!Orientation methodsFor: 'as yet unclassified' stamp: 'LR 10/8/2023 19:46:56'!
rotateLeft
	^self subclassResponsibility ! !

!Orientation methodsFor: 'as yet unclassified' stamp: 'LR 10/8/2023 19:47:00'!
rotateRight
	^self subclassResponsibility ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Orientation class' category: 'MarsRoverExercise'!
Orientation class
	instanceVariableNames: 'south west north east'!

!Orientation class methodsFor: 'as yet unclassified' stamp: 'LR 10/8/2023 20:23:56'!
east
	^east! !

!Orientation class methodsFor: 'as yet unclassified' stamp: 'LR 10/8/2023 20:11:45'!
initialize
	north := North new.
	south := South new.
	west := West new.
	east := East new.
	! !

!Orientation class methodsFor: 'as yet unclassified' stamp: 'LR 10/8/2023 19:54:47'!
north
	^north! !

!Orientation class methodsFor: 'as yet unclassified' stamp: 'LR 10/8/2023 19:54:54'!
south
	^south! !

!Orientation class methodsFor: 'as yet unclassified' stamp: 'LR 10/8/2023 19:54:36'!
west
	^west! !


!classDefinition: #East category: 'MarsRoverExercise'!
Orientation subclass: #East
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRoverExercise'!

!East methodsFor: 'as yet unclassified' stamp: 'LR 10/9/2023 09:52:46'!
moveBackwards: aPosition
	^aPosition + (-1 @ 0).! !

!East methodsFor: 'as yet unclassified' stamp: 'LR 10/9/2023 09:52:51'!
moveForward: aPosition
	^aPosition + (1 @ 0)! !

!East methodsFor: 'as yet unclassified' stamp: 'LR 10/8/2023 20:16:18'!
rotateLeft
	^Orientation north! !

!East methodsFor: 'as yet unclassified' stamp: 'BR 10/8/2023 23:24:12'!
rotateRight
	^Orientation south! !


!classDefinition: #North category: 'MarsRoverExercise'!
Orientation subclass: #North
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRoverExercise'!

!North methodsFor: 'as yet unclassified' stamp: 'LR 10/9/2023 09:52:29'!
moveBackwards: aPosition
	^aPosition + (0 @ -1)! !

!North methodsFor: 'as yet unclassified' stamp: 'LR 10/9/2023 09:52:37'!
moveForward: aPosition
	^aPosition + (0 @ 1)! !

!North methodsFor: 'as yet unclassified' stamp: 'LR 10/8/2023 19:47:44'!
rotateLeft
	^Orientation west! !

!North methodsFor: 'as yet unclassified' stamp: 'BR 10/8/2023 23:22:40'!
rotateRight
	^Orientation east! !


!classDefinition: #South category: 'MarsRoverExercise'!
Orientation subclass: #South
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRoverExercise'!

!South methodsFor: 'as yet unclassified' stamp: 'LR 10/9/2023 09:53:08'!
moveBackwards: aPosition
	^aPosition + (0 @ 1)! !

!South methodsFor: 'as yet unclassified' stamp: 'LR 10/9/2023 09:53:14'!
moveForward: aPosition
	^aPosition + (0 @ 1)! !

!South methodsFor: 'as yet unclassified' stamp: 'LR 10/8/2023 20:15:31'!
rotateLeft
	^Orientation east! !

!South methodsFor: 'as yet unclassified' stamp: 'BR 10/8/2023 23:24:35'!
rotateRight
	^Orientation west! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'South class' category: 'MarsRoverExercise'!
South class
	instanceVariableNames: ''!

!South class methodsFor: 'as yet unclassified' stamp: 'LR 10/8/2023 20:12:13'!
rotateLeft
	^Orientation east! !


!classDefinition: #West category: 'MarsRoverExercise'!
Orientation subclass: #West
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRoverExercise'!

!West methodsFor: 'as yet unclassified' stamp: 'LR 10/9/2023 09:53:22'!
moveBackwards: aPosition
	^aPosition + (-1 @ 0)! !

!West methodsFor: 'as yet unclassified' stamp: 'LR 10/9/2023 09:53:27'!
moveForward: aPosition
	^aPosition + (0 @ 1)! !

!West methodsFor: 'as yet unclassified' stamp: 'LR 10/8/2023 19:55:39'!
rotateLeft
	^Orientation south! !

!West methodsFor: 'as yet unclassified' stamp: 'BR 10/8/2023 23:24:49'!
rotateRight
	^Orientation north! !

Orientation initialize!