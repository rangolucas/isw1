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

!TestMarsRover methodsFor: 'as yet unclassified' stamp: 'LR 10/8/2023 19:57:04'!
test01MarsRoverProcessEmptyCommand
	|marsRover|
	
	marsRover := MarsRover deployAt: 0@0 facing: north.
	marsRover processCommand: ''.
	
	self assert: (marsRover isAt: 0@0 facing: north).! !

!TestMarsRover methodsFor: 'as yet unclassified' stamp: 'LR 10/8/2023 20:07:59'!
test02MarsRoverProcessMoveForwardsCommand
	|marsRover|
	
	marsRover := MarsRover deployAt: 0@0 facing: north.
	marsRover processCommand: 'f'.
	
	self assert: (marsRover isAt: 0@1 facing: north).! !

!TestMarsRover methodsFor: 'as yet unclassified' stamp: 'LR 10/8/2023 20:08:06'!
test03MarsRoverProcessMoveBackwardsCommand
	|marsRover|
	
	marsRover := MarsRover deployAt: 0@0 facing: north.
	marsRover processCommand: 'b'.
	
	self assert: (marsRover isAt: 0@-1 facing: north).! !

!TestMarsRover methodsFor: 'as yet unclassified' stamp: 'LR 10/8/2023 20:08:37'!
test04MarsRoverProcessRotateLeftCommandWhenFacingNorth
	|marsRover|
	
	marsRover := MarsRover deployAt: 0@0 facing: north.
	marsRover processCommand: 'l'.
	
	self assert: (marsRover isAt: 0@0 facing: west).! !

!TestMarsRover methodsFor: 'as yet unclassified' stamp: 'LR 10/8/2023 20:08:31'!
test05MarsRoverProcessRotateLeftCommandWhenFacingWest
	|marsRover|
	
	marsRover := MarsRover deployAt: 0@0 facing: west.
	marsRover processCommand: 'l'.
	
	self assert: (marsRover isAt: 0@0 facing: south).! !

!TestMarsRover methodsFor: 'as yet unclassified' stamp: 'LR 10/8/2023 19:57:53'!
test06MarsRoverProcessErroneousCommand
	|marsRover|
	
	marsRover := MarsRover deployAt: 0@0 facing: north.
	marsRover processCommand: 'x'.
	
	self assert: (marsRover isAt: 0@0 facing: north).! !

!TestMarsRover methodsFor: 'as yet unclassified' stamp: 'LR 10/8/2023 20:10:43'!
test06MarsRoverProcessRotateLeftCommandWhenFacingSouth
	|marsRover|
	
	marsRover := MarsRover deployAt: 0@0 facing: south.
	marsRover processCommand: 'l'.
	
	self assert: (marsRover isAt: 0@0 facing: east).! !

!TestMarsRover methodsFor: 'as yet unclassified' stamp: 'LR 10/8/2023 20:25:57'!
test07MarsRoverProcessRotateLeftCommandWhenFacingEast
	|marsRover|
	
	marsRover := MarsRover deployAt: 0@0 facing: east.
	marsRover processCommand: 'l'.
	
	self assert: (marsRover isAt: 0@0 facing: north).! !


!classDefinition: #MarsRover category: 'MarsRoverExercise'!
Object subclass: #MarsRover
	instanceVariableNames: 'position facing'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRoverExercise'!

!MarsRover methodsFor: 'as yet unclassified' stamp: 'BR 10/8/2023 00:46:48'!
currentPosition
	^position.! !

!MarsRover methodsFor: 'as yet unclassified' stamp: 'BR 10/5/2023 21:15:04'!
isAt: aPoint facing: aCardinalPoint
	^(position = aPoint) and: (facing = aCardinalPoint).! !

!MarsRover methodsFor: 'as yet unclassified' stamp: 'BR 10/5/2023 21:08:31'!
with: aPoint facing: aCardinalPoint
	position := aPoint.
	facing := aCardinalPoint.! !


!MarsRover methodsFor: 'processing' stamp: 'LR 10/8/2023 20:06:29'!
processCommand: aCommand
	
	(MarsRoverCommand commandParse: aCommand) isSentTo: self.
	! !


!MarsRover methodsFor: 'movement' stamp: 'BR 10/8/2023 02:15:33'!
moveBackwards
	position := position + (0@-1).! !

!MarsRover methodsFor: 'movement' stamp: 'BR 10/8/2023 02:14:44'!
moveForwards
	position := position + (0@1).! !

!MarsRover methodsFor: 'movement' stamp: 'LR 10/8/2023 20:14:10'!
rotateLeft
	facing := facing rotateLeft! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MarsRover class' category: 'MarsRoverExercise'!
MarsRover class
	instanceVariableNames: ''!

!MarsRover class methodsFor: 'as yet unclassified' stamp: 'BR 10/5/2023 21:33:19'!
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

!CommandNotRecognized methodsFor: 'as yet unclassified' stamp: 'BR 10/8/2023 02:11:53'!
isSentTo: aMarsRover
	^self.! !


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

!East methodsFor: 'as yet unclassified' stamp: 'LR 10/8/2023 20:16:18'!
rotateLeft
	^Orientation north! !


!classDefinition: #North category: 'MarsRoverExercise'!
Orientation subclass: #North
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRoverExercise'!

!North methodsFor: 'as yet unclassified' stamp: 'LR 10/8/2023 19:47:44'!
rotateLeft
	^Orientation west! !


!classDefinition: #South category: 'MarsRoverExercise'!
Orientation subclass: #South
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRoverExercise'!

!South methodsFor: 'as yet unclassified' stamp: 'LR 10/8/2023 20:15:31'!
rotateLeft
	^Orientation east! !

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

!West methodsFor: 'as yet unclassified' stamp: 'LR 10/8/2023 19:55:39'!
rotateLeft
	^Orientation south! !

Orientation initialize!