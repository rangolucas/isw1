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
test06MarsRoverProcessErroneousCommand
	|marsRover|
	
	marsRover := MarsRover deployAt: 0@0 facing: north.
	marsRover processCommand: 'x'.
	
	self assert: (marsRover isAt: 0@0 facing: north).! !

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

!TestMarsRover methodsFor: 'as yet unclassified' stamp: 'BR 10/9/2023 01:03:46'!
test12MarsRoverProcessManyValidCommands
	|marsRover|
	
	marsRover := MarsRover deployAt: 0@0 facing: north.
	marsRover processStringOfCommands: 'rbl'.
	
	self assert: (marsRover isAt: -1@0 facing: north).! !

!TestMarsRover methodsFor: 'as yet unclassified' stamp: 'BR 10/9/2023 01:03:46'!
test13MarsRoverProcessManyValidCommands
	|marsRover|
	
	marsRover := MarsRover deployAt: 0@0 facing: north.
	marsRover processStringOfCommands: 'rblbrrff'.
	
	self assert: (marsRover isAt: -1@-3 facing: south).! !

!TestMarsRover methodsFor: 'as yet unclassified' stamp: 'BR 10/9/2023 01:03:46'!
test14MarsRoverProcessManyValidCommandsWithAnInvalidOne
	|marsRover|
	
	marsRover := MarsRover deployAt: 0@0 facing: north.
	marsRover processStringOfCommands: 'rblbxrrff'.
	
	self assert: (marsRover isAt: -1@-1 facing: north).! !


!classDefinition: #MarsRover category: 'MarsRoverExercise'!
Object subclass: #MarsRover
	instanceVariableNames: 'position facing'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRoverExercise'!

!MarsRover methodsFor: 'as yet unclassified' stamp: 'BR 10/9/2023 01:01:00'!
isAt: aPoint facing: aCardinalPoint
	^(position = aPoint) and: (facing = aCardinalPoint).! !

!MarsRover methodsFor: 'as yet unclassified' stamp: 'BR 10/9/2023 01:02:29'!
with: aPoint facing: aCardinalPoint
	position := aPoint.
	facing := aCardinalPoint.! !


!MarsRover methodsFor: 'processing' stamp: 'BR 10/9/2023 01:02:07'!
processCommand: aCommand
	
	(MarsRoverCommand commandParse: aCommand) isSentTo: self.
	! !

!MarsRover methodsFor: 'processing' stamp: 'BR 10/9/2023 01:25:18'!
processStringOfCommands: aStringOfCommands
	|index|
	
	index := 1.
	
	[#('f' 'b' 'l' 'r') includes: ((aStringOfCommands at: index) asString)] whileTrue:[
							self processCommand: ((aStringOfCommands at: index) asString).
							index := index + 1.
							].
	! !


!MarsRover methodsFor: 'movement' stamp: 'BR 10/9/2023 01:01:14'!
moveBackwards
	^facing movesMarsRoverBackwards: self.! !

!MarsRover methodsFor: 'movement' stamp: 'BR 10/9/2023 01:01:28'!
moveForwards
	^facing movesMarsRoverForwards: self.! !

!MarsRover methodsFor: 'movement' stamp: 'BR 10/9/2023 01:01:32'!
movesBackwardsWhileFacingEast
	position := position + (-1@0).! !

!MarsRover methodsFor: 'movement' stamp: 'BR 10/9/2023 01:01:36'!
movesBackwardsWhileFacingNorth
	position := position + (0@-1).! !

!MarsRover methodsFor: 'movement' stamp: 'BR 10/9/2023 01:01:39'!
movesBackwardsWhileFacingSouth
	position := position + (0@1).! !

!MarsRover methodsFor: 'movement' stamp: 'BR 10/9/2023 01:01:43'!
movesBackwardsWhileFacingWest
	position := position + (1@0).! !

!MarsRover methodsFor: 'movement' stamp: 'BR 10/9/2023 01:01:48'!
movesForwardsWhileFacingEast
	position := position + (1@0).! !

!MarsRover methodsFor: 'movement' stamp: 'BR 10/9/2023 01:01:51'!
movesForwardsWhileFacingNorth
	position := position + (0@1).! !

!MarsRover methodsFor: 'movement' stamp: 'BR 10/9/2023 01:01:55'!
movesForwardsWhileFacingSouth
	position := position + (0@-1).! !

!MarsRover methodsFor: 'movement' stamp: 'BR 10/9/2023 01:01:58'!
movesForwardsWhileFacingWest
	position := position + (-1@0).! !

!MarsRover methodsFor: 'movement' stamp: 'BR 10/9/2023 01:02:21'!
rotateLeft
	facing := facing rotateLeft! !

!MarsRover methodsFor: 'movement' stamp: 'BR 10/9/2023 01:02:24'!
rotateRight
	facing := facing rotateRight! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MarsRover class' category: 'MarsRoverExercise'!
MarsRover class
	instanceVariableNames: ''!

!MarsRover class methodsFor: 'as yet unclassified' stamp: 'BR 10/9/2023 01:03:46'!
deployAt: aPoint facing: aCardinalPoint
	^MarsRover new with: aPoint facing: aCardinalPoint.! !


!classDefinition: #MarsRoverCommand category: 'MarsRoverExercise'!
Object subclass: #MarsRoverCommand
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRoverExercise'!

!MarsRoverCommand methodsFor: 'as yet unclassified' stamp: 'BR 10/8/2023 01:57:29'!
isSentTo: aMarsRover

	self subclassResponsibility! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MarsRoverCommand class' category: 'MarsRoverExercise'!
MarsRoverCommand class
	instanceVariableNames: ''!

!MarsRoverCommand class methodsFor: 'as yet unclassified' stamp: 'LR 10/8/2023 20:07:38'!
commandParse: aCommandCharacter
	(aCommandCharacter = 'f') ifTrue: [^MoveForwardsCommand new.].
	(aCommandCharacter = 'b') ifTrue: [^MoveBackwardsCommand new.].
	(aCommandCharacter = 'l') ifTrue: [^RotateLeftCommand new.].
	(aCommandCharacter = 'r') ifTrue: [^RotateRightCommand new.].
	^CommandNotRecognized new.! !


!classDefinition: #CommandNotRecognized category: 'MarsRoverExercise'!
MarsRoverCommand subclass: #CommandNotRecognized
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRoverExercise'!

!CommandNotRecognized methodsFor: 'as yet unclassified' stamp: 'BR 10/9/2023 01:14:49'!
isSentTo: aMarsRover
	
	self.! !


!classDefinition: #MoveBackwardsCommand category: 'MarsRoverExercise'!
MarsRoverCommand subclass: #MoveBackwardsCommand
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRoverExercise'!

!MoveBackwardsCommand methodsFor: 'as yet unclassified' stamp: 'BR 10/8/2023 01:57:48'!
isSentTo: aMarsRover
	
	aMarsRover moveBackwards.! !


!classDefinition: #MoveForwardsCommand category: 'MarsRoverExercise'!
MarsRoverCommand subclass: #MoveForwardsCommand
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRoverExercise'!

!MoveForwardsCommand methodsFor: 'as yet unclassified' stamp: 'BR 10/8/2023 01:58:05'!
isSentTo: aMarsRover
	
	aMarsRover moveForwards.! !


!classDefinition: #RotateLeftCommand category: 'MarsRoverExercise'!
MarsRoverCommand subclass: #RotateLeftCommand
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRoverExercise'!

!RotateLeftCommand methodsFor: 'as yet unclassified' stamp: 'BR 10/8/2023 01:58:33'!
isSentTo: aMarsRover
	
	aMarsRover rotateLeft.! !


!classDefinition: #RotateRightCommand category: 'MarsRoverExercise'!
MarsRoverCommand subclass: #RotateRightCommand
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRoverExercise'!

!RotateRightCommand methodsFor: 'as yet unclassified' stamp: 'BR 10/8/2023 01:58:53'!
isSentTo: aMarsRover
	
	aMarsRover rotateRight.! !


!classDefinition: #Orientation category: 'MarsRoverExercise'!
Object subclass: #Orientation
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRoverExercise'!

!Orientation methodsFor: 'as yet unclassified' stamp: 'BR 10/8/2023 23:56:29'!
movesMarsRoverBackwards: aMarsRover

	self subclassResponsibility! !

!Orientation methodsFor: 'as yet unclassified' stamp: 'BR 10/8/2023 23:56:37'!
movesMarsRoverForwards: aMarsRover

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

!East methodsFor: 'as yet unclassified' stamp: 'BR 10/8/2023 23:57:42'!
movesMarsRoverBackwards: aMarsRover
	^aMarsRover movesBackwardsWhileFacingEast.! !

!East methodsFor: 'as yet unclassified' stamp: 'BR 10/8/2023 23:57:59'!
movesMarsRoverForwards: aMarsRover
	^aMarsRover movesForwardsWhileFacingEast.! !

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

!North methodsFor: 'as yet unclassified' stamp: 'BR 10/8/2023 23:58:33'!
movesMarsRoverBackwards: aMarsRover
	^aMarsRover movesBackwardsWhileFacingNorth.! !

!North methodsFor: 'as yet unclassified' stamp: 'BR 10/8/2023 23:58:52'!
movesMarsRoverForwards: aMarsRover
	^aMarsRover movesForwardsWhileFacingNorth.! !

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

!South methodsFor: 'as yet unclassified' stamp: 'BR 10/8/2023 23:59:09'!
movesMarsRoverBackwards: aMarsRover
	^aMarsRover movesBackwardsWhileFacingSouth.! !

!South methodsFor: 'as yet unclassified' stamp: 'BR 10/8/2023 23:59:26'!
movesMarsRoverForwards: aMarsRover
	^aMarsRover movesForwardsWhileFacingSouth.! !

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

!West methodsFor: 'as yet unclassified' stamp: 'BR 10/9/2023 00:00:02'!
movesMarsRoverBackwards: aMarsRover
	^aMarsRover movesBackwardsWhileFacingWest.! !

!West methodsFor: 'as yet unclassified' stamp: 'BR 10/8/2023 23:59:44'!
movesMarsRoverForwards: aMarsRover
	^aMarsRover movesForwardsWhileFacingWest.! !

!West methodsFor: 'as yet unclassified' stamp: 'LR 10/8/2023 19:55:39'!
rotateLeft
	^Orientation south! !

!West methodsFor: 'as yet unclassified' stamp: 'BR 10/8/2023 23:24:49'!
rotateRight
	^Orientation north! !

Orientation initialize!