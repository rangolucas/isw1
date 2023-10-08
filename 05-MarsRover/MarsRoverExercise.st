!classDefinition: #TestMarsRover category: 'MarsRoverExercise'!
TestCase subclass: #TestMarsRover
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRoverExercise'!

!TestMarsRover methodsFor: 'as yet unclassified' stamp: 'BR 10/8/2023 00:47:41'!
test01MarsRoverProcessEmptyCommand
	|marsRover|
	
	marsRover := MarsRover deployAt: 0@0 facing: #North.
	marsRover processCommand: ''.
	
	self assert: (marsRover isAt: 0@0 facing: #North).! !

!TestMarsRover methodsFor: 'as yet unclassified' stamp: 'BR 10/5/2023 21:42:05'!
test02MarsRoverProcessEmptyCommand
	|marsRover|
	
	marsRover := MarsRover deployAt: 0@0 facing: #North.
	marsRover processCommand: 'f'.
	
	self assert: (marsRover isAt: 0@1 facing: #North).! !

!TestMarsRover methodsFor: 'as yet unclassified' stamp: 'BR 10/5/2023 21:46:39'!
test03MarsRoverProcessEmptyCommand
	|marsRover|
	
	marsRover := MarsRover deployAt: 0@0 facing: #North.
	marsRover processCommand: 'b'.
	
	self assert: (marsRover isAt: 0@-1 facing: #North).! !

!TestMarsRover methodsFor: 'as yet unclassified' stamp: 'BR 10/8/2023 00:50:08'!
test04MarsRoverProcessEmptyCommand
	|marsRover|
	
	marsRover := MarsRover deployAt: 0@0 facing: #North.
	marsRover processCommand: 'l'.
	
	self assert: (marsRover isAt: 0@0 facing: #West).! !

!TestMarsRover methodsFor: 'as yet unclassified' stamp: 'BR 10/8/2023 00:52:06'!
test05MarsRoverProcessEmptyCommand
	|marsRover|
	
	marsRover := MarsRover deployAt: 0@0 facing: #West.
	marsRover processCommand: 'l'.
	
	self assert: (marsRover isAt: 0@0 facing: #South).! !

!TestMarsRover methodsFor: 'as yet unclassified' stamp: 'BR 10/8/2023 01:00:16'!
test06MarsRoverProcessErroneousCommand
	|marsRover|
	
	marsRover := MarsRover deployAt: 0@0 facing: #North.
	marsRover processCommand: 'x'.
	
	self assert: (marsRover isAt: 0@0 facing: #North).! !


!classDefinition: #CommandBase category: 'MarsRoverExercise'!
Object subclass: #CommandBase
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRoverExercise'!

!CommandBase methodsFor: 'as yet unclassified' stamp: 'BR 10/8/2023 01:57:29'!
isSentTo: aMarsRover

	self subclassResponsibility! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CommandBase class' category: 'MarsRoverExercise'!
CommandBase class
	instanceVariableNames: ''!

!CommandBase class methodsFor: 'as yet unclassified' stamp: 'BR 10/8/2023 02:12:19'!
commandParse: aCommandCharacter
	(aCommandCharacter = 'f') ifTrue: [^CommandForward new.].
	(aCommandCharacter = 'b') ifTrue: [^CommandBackward new.].
	(aCommandCharacter = 'l') ifTrue: [^CommandLeft new.].
	(aCommandCharacter = 'r') ifTrue: [^CommandRight new.].
	^CommandNotRecognized new.! !


!classDefinition: #CommandBackward category: 'MarsRoverExercise'!
CommandBase subclass: #CommandBackward
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRoverExercise'!

!CommandBackward methodsFor: 'as yet unclassified' stamp: 'BR 10/8/2023 01:57:48'!
isSentTo: aMarsRover
	
	aMarsRover moveBackwards.! !


!classDefinition: #CommandForward category: 'MarsRoverExercise'!
CommandBase subclass: #CommandForward
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRoverExercise'!

!CommandForward methodsFor: 'as yet unclassified' stamp: 'BR 10/8/2023 01:58:05'!
isSentTo: aMarsRover
	
	aMarsRover moveForwards.! !


!classDefinition: #CommandLeft category: 'MarsRoverExercise'!
CommandBase subclass: #CommandLeft
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRoverExercise'!

!CommandLeft methodsFor: 'as yet unclassified' stamp: 'BR 10/8/2023 01:58:33'!
isSentTo: aMarsRover
	
	aMarsRover rotateLeft.! !


!classDefinition: #CommandNotRecognized category: 'MarsRoverExercise'!
CommandBase subclass: #CommandNotRecognized
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRoverExercise'!

!CommandNotRecognized methodsFor: 'as yet unclassified' stamp: 'BR 10/8/2023 02:11:53'!
isSentTo: aMarsRover
	^self.! !


!classDefinition: #CommandRight category: 'MarsRoverExercise'!
CommandBase subclass: #CommandRight
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRoverExercise'!

!CommandRight methodsFor: 'as yet unclassified' stamp: 'BR 10/8/2023 01:58:53'!
isSentTo: aMarsRover
	
	aMarsRover rotateRight.! !


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


!MarsRover methodsFor: 'processing' stamp: 'BR 10/8/2023 02:07:51'!
processCommand: aCommand
	
	(CommandBase commandParse: aCommand) isSentTo: self.
	! !


!MarsRover methodsFor: 'movement' stamp: 'BR 10/8/2023 02:15:33'!
moveBackwards
	position := position + (0@-1).! !

!MarsRover methodsFor: 'movement' stamp: 'BR 10/8/2023 02:14:44'!
moveForwards
	position := position + (0@1).! !

!MarsRover methodsFor: 'movement' stamp: 'BR 10/8/2023 02:17:49'!
rotateLeft
	(facing = #North) ifTrue: [facing := #West.].
	(facing = #West) ifTrue: [facing := #South.].! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MarsRover class' category: 'MarsRoverExercise'!
MarsRover class
	instanceVariableNames: ''!

!MarsRover class methodsFor: 'as yet unclassified' stamp: 'BR 10/5/2023 21:33:19'!
deployAt: aPoint facing: aCardinalPoint
	^MarsRover new with: aPoint facing: aCardinalPoint.! !
