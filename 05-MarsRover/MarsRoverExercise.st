!classDefinition: #TestMarsRover category: 'MarsRoverExercise'!
TestCase subclass: #TestMarsRover
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRoverExercise'!

!TestMarsRover methodsFor: 'as yet unclassified' stamp: 'BR 10/5/2023 21:41:26'!
test01MarsRoverProcessEmptyCommand
	|marsRover aPoint aCardinalPoint|
	
	aPoint := 0@0.
	aCardinalPoint:= #North.
	marsRover := MarsRover deployAt: aPoint facing: aCardinalPoint.
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

!TestMarsRover methodsFor: 'as yet unclassified' stamp: 'BR 10/5/2023 21:47:30'!
test04MarsRoverProcessEmptyCommand
	|marsRover|
	
	marsRover := MarsRover deployAt: 0@0 facing: #North.
	marsRover processCommand: 'l'.
	
	self assert: (marsRover isAt: 0@-1 facing: #North).! !


!classDefinition: #MarsRover category: 'MarsRoverExercise'!
Object subclass: #MarsRover
	instanceVariableNames: 'position facing'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRoverExercise'!

!MarsRover methodsFor: 'as yet unclassified' stamp: 'BR 10/5/2023 20:40:46'!
currentPosition
	^0@0.! !

!MarsRover methodsFor: 'as yet unclassified' stamp: 'BR 10/5/2023 21:15:04'!
isAt: aPoint facing: aCardinalPoint
	^(position = aPoint) and: (facing = aCardinalPoint).! !

!MarsRover methodsFor: 'as yet unclassified' stamp: 'BR 10/5/2023 21:08:31'!
with: aPoint facing: aCardinalPoint
	position := aPoint.
	facing := aCardinalPoint.! !


!MarsRover methodsFor: 'processing' stamp: 'BR 10/5/2023 21:50:20'!
processCommand: aCommand
	
	(aCommand = 'f') ifTrue: [position := (position x + 0)@(position y + 1).].
	(aCommand = 'b') ifTrue: [position := (position x + 0)@(position y - 1).].	
	! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MarsRover class' category: 'MarsRoverExercise'!
MarsRover class
	instanceVariableNames: ''!

!MarsRover class methodsFor: 'as yet unclassified' stamp: 'BR 10/5/2023 21:33:19'!
deployAt: aPoint facing: aCardinalPoint
	^MarsRover new with: aPoint facing: aCardinalPoint.! !
