!classDefinition: #MineFieldTest category: 'ISW1-2023-2C-2doParcial'!
TestCase subclass: #MineFieldTest
	instanceVariableNames: 'randomResults'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ISW1-2023-2C-2doParcial'!

!MineFieldTest methodsFor: 'as yet unclassified' stamp: 'BR 11/30/2023 20:11:59'!
getNext
	^randomResults next.! !

!MineFieldTest methodsFor: 'as yet unclassified' stamp: 'BR 11/30/2023 20:11:42'!
randomResults: aCollectionOfResults

	randomResults := ReadStream on: aCollectionOfResults 
	! !

!MineFieldTest methodsFor: 'as yet unclassified' stamp: 'BR 11/30/2023 20:32:27'!
test01PlayerCannotStartOutsideOfFirstRow
	
	
	self 
		should: [MineField playerWithLives: 1 startingOn: 1@2 fieldExtension: 2@2 withTunnels: (Dictionary new) withMines: (Dictionary new) withArmours: (Dictionary new) withRandomValues: self.]
		raise: Error
		withMessageText: MineField invalidStartingPositionErrorMessage.
	! !

!MineFieldTest methodsFor: 'as yet unclassified' stamp: 'BR 11/30/2023 20:32:22'!
test02PlayerCannotStartOnOccupiedPositionByAMine
	
	
	self 
		should: [MineField playerWithLives: 1 startingOn: 1@1 fieldExtension: 2@2 withTunnels: (Dictionary new) withMines: (Dictionary with: 1@1->LowPowerMine new) withArmours: (Dictionary new) withRandomValues: self.]
		raise: Error
		withMessageText: MineField invalidStartingPositionErrorMessage.
	! !

!MineFieldTest methodsFor: 'as yet unclassified' stamp: 'BR 11/30/2023 20:32:17'!
test03PlayerCannotStartOnOccupiedPositionByAnArmour
	
	
	self 
		should: [MineField playerWithLives: 1 startingOn: 1@1 fieldExtension: 2@2 withTunnels: {} withMines: (Dictionary new) withArmours: (Dictionary with: 1@1->WeakArmour new) withRandomValues: self.]
		raise: Error
		withMessageText: MineField invalidStartingPositionErrorMessage.
	! !

!MineFieldTest methodsFor: 'as yet unclassified' stamp: 'BR 11/30/2023 20:32:12'!
test04PlayerCannotStartOnOccupiedPositionByATunnel
	|tunnel|
	
	tunnel := Tunnel from: 1@1 to: 2@2.
	
	self 
		should: [MineField playerWithLives: 1 startingOn: 1@1 fieldExtension: 2@2 withTunnels: {tunnel} withMines: (Dictionary new) withArmours: (Dictionary new) withRandomValues: self.]
		raise: Error
		withMessageText: MineField invalidStartingPositionErrorMessage.
	! !

!MineFieldTest methodsFor: 'as yet unclassified' stamp: 'BR 11/30/2023 20:32:08'!
test05PlayerCannotStartWithNumberOfLivesLessThanOrEqualToZero
	
	self 
		should: [MineField playerWithLives: 0 startingOn: 1@1 fieldExtension: 2@2 withTunnels: (Dictionary new) withMines: (Dictionary new) withArmours: (Dictionary new) withRandomValues: self.]
		raise: Error
		withMessageText: MineField invalidNumberOfStaringLivesErrorMessage .
	! !

!MineFieldTest methodsFor: 'as yet unclassified' stamp: 'BR 11/30/2023 20:32:02'!
test06PlayerLosesOneLifeWhenReachingALowPowerMine
	|minefield|
	
	minefield := MineField playerWithLives: 2 startingOn: 1@1 fieldExtension: 2@2 withTunnels: {} withMines: (Dictionary with: 1@2->(LowPowerMine new)) withArmours: (Dictionary new) withRandomValues: self.
	
	minefield playerMovesTo: 1@2.
	
	self assert: (minefield playerHasRemainingLives: 1).
	self deny: (minefield containsMine: 1@2).
	! !

!MineFieldTest methodsFor: 'as yet unclassified' stamp: 'BR 11/30/2023 20:36:41'!
test07PlayerLosesTwoLivesWhenReachingAHighPowerMine
	|minefield|
	
	self randomResults: #(1 1).
	minefield := MineField playerWithLives: 2 startingOn: 1@1 fieldExtension: 2@2 withTunnels: {} withMines: (Dictionary with: 1@2->(HighPowerMine new)) withArmours: (Dictionary new) withRandomValues: self.
	
	minefield playerMovesTo: 1@2.
	
	self assert: (minefield playerHasRemainingLives: 0).
	self deny: (minefield containsMine: 1@2).
	! !

!MineFieldTest methodsFor: 'as yet unclassified' stamp: 'BR 11/30/2023 20:31:52'!
test08PlayerIsProtectedFromLowPowerMinesIfArmoured
	|minefield mine weakArmour|
	
	mine := LowPowerMine new.
	weakArmour := WeakArmour new.
	minefield := MineField playerWithLives: 2 startingOn: 1@1 fieldExtension: 3@3 withTunnels: {} withMines: (Dictionary with: 1@3->mine) withArmours: (Dictionary with: 1@2->weakArmour) withRandomValues: self.
	
	minefield playerMovesTo: 1@2.
	minefield playerMovesTo: 1@3.
	
	self assert: (minefield playerHasRemainingLives: 2).
	self deny: (minefield containsMine: 1@3).
	self assert: (minefield playerIsUnarmoured).
	self deny: (minefield containsArmour: 1@2).
	! !

!MineFieldTest methodsFor: 'as yet unclassified' stamp: 'BR 11/30/2023 20:36:30'!
test09PlayerCannotMoveOutsideField
	|minefield mine weakArmour|
	
	mine := LowPowerMine new.
	weakArmour := WeakArmour new.
	self randomResults: #(1 1).
	minefield := MineField playerWithLives: 2 startingOn: 1@1 fieldExtension: 3@3 withTunnels: {} withMines: (Dictionary new) withArmours: (Dictionary new) withRandomValues: self.
	
	minefield playerMovesTo: 0@1.
	
	self assert: (minefield playerIsInPosition: 1@1).

	! !

!MineFieldTest methodsFor: 'as yet unclassified' stamp: 'BR 11/30/2023 20:41:12'!
test10PlayerIsProtectedFromHighPowerMinesIfArmoured
	|minefield mine weakArmour|
	
	mine := HighPowerMine new.
	weakArmour := WeakArmour new.
	
	self randomResults: #(1 1).
	minefield := MineField playerWithLives: 2 startingOn: 1@1 fieldExtension: 3@3 withTunnels: {} withMines: (Dictionary with: 1@3->mine) withArmours: (Dictionary with: 1@2->weakArmour) withRandomValues: self.
	
	minefield playerMovesTo: 1@2.
	minefield playerMovesTo: 1@3.
	
	self assert: (minefield playerHasRemainingLives: 2).
	self deny: (minefield containsMine: 1@3).
	self assert: (minefield playerIsUnarmoured).
	self deny: (minefield containsArmour: 1@2).
	self assert: (minefield playerIsInPosition: 1@3).
	! !

!MineFieldTest methodsFor: 'as yet unclassified' stamp: 'BR 11/30/2023 20:43:26'!
test11PlayerIsProtectedFromHighPowerMinesIfArmouredButFlies
	|minefield mine weakArmour|
	
	mine := HighPowerMine new.
	weakArmour := WeakArmour new.
	
	self randomResults: #(-2 -2).
	minefield := MineField playerWithLives: 2 startingOn: 1@1 fieldExtension: 4@4 withTunnels: {} withMines: (Dictionary with: 2@3->mine) withArmours: (Dictionary with: 1@2->weakArmour) withRandomValues: self.
	
	minefield playerMovesTo: 1@2.
	minefield playerMovesTo: 1@3.
	minefield playerMovesTo: 2@3.
	
	self assert: (minefield playerHasRemainingLives: 2).
	self deny: (minefield containsMine: 1@3).
	self assert: (minefield playerIsUnarmoured).
	self deny: (minefield containsArmour: 1@2).
	self assert: (minefield playerIsInPosition: 1@2).
	! !

!MineFieldTest methodsFor: 'as yet unclassified' stamp: 'BR 11/30/2023 21:04:36'!
test11PlayerIsProtectedFromLowPowerMinesTwoTimes
	|minefield |
	
	
	self randomResults: #(-2 -2).
	minefield := MineField playerWithLives: 2 startingOn: 1@1 fieldExtension: 4@4 withTunnels: {} withMines: (Dictionary with: 2@3->(LowPowerMine new) with: 1@3->(LowPowerMine new)) withArmours: (Dictionary with: 1@2->(StrongArmour new)) withRandomValues: self.
	
	minefield playerMovesTo: 1@2.
	minefield playerMovesTo: 1@3.
	minefield playerMovesTo: 2@3.
	
	self assert: (minefield playerHasRemainingLives: 2).
	self deny: (minefield containsMine: 1@3).
	self assert: (minefield playerIsUnarmoured).
	self deny: (minefield containsArmour: 1@2).
	self deny: (minefield containsArmour: 1@3).
	self assert: (minefield playerIsInPosition: 2@3).
	! !

!MineFieldTest methodsFor: 'as yet unclassified' stamp: 'BR 11/30/2023 20:55:13'!
test12PlayerCannotMoveMoreThanOneStepAtATime
	|minefield |
	
	minefield := MineField playerWithLives: 2 startingOn: 1@1 fieldExtension: 4@4 withTunnels: {} withMines: (Dictionary new) withArmours: (Dictionary new) withRandomValues: self.
	
	self
		should: [minefield playerMovesTo: 1@3]
		raise: Error
		withMessageText: minefield class cannotMoveMoreThanOneStepAtATimeErrorMessage.
	
	
	! !

!MineFieldTest methodsFor: 'as yet unclassified' stamp: 'BR 11/30/2023 21:04:44'!
test13PlayerIsProtectedFromLowPowerMinesTwoTimes
	|minefield |
	
	
	self randomResults: #(-2 -2).
	minefield := MineField playerWithLives: 2 startingOn: 1@1 fieldExtension: 4@4 withTunnels: {} withMines: (Dictionary with: 2@3->(LowPowerMine new) with: 1@3->(LowPowerMine new)) withArmours: (Dictionary with: 1@2->(StrongArmour new)) withRandomValues: self.
	
	minefield playerMovesTo: 1@2.
	minefield playerMovesTo: 1@3.
	minefield playerMovesTo: 2@3.
	
	self assert: (minefield playerHasRemainingLives: 2).
	self deny: (minefield containsMine: 1@3).
	self assert: (minefield playerIsUnarmoured).
	self deny: (minefield containsArmour: 1@2).
	self deny: (minefield containsArmour: 1@3).
	self assert: (minefield playerIsInPosition: 2@3).
	! !

!MineFieldTest methodsFor: 'as yet unclassified' stamp: 'BR 11/30/2023 21:07:02'!
test14PlayerOnlyKeepsLatestCollectedArmour
	|minefield |
	
	
	self randomResults: #(-2 -2).
	minefield := MineField playerWithLives: 2 startingOn: 1@1 fieldExtension: 4@4 withTunnels: {} withMines: (Dictionary new) withArmours: (Dictionary with: 1@2->(StrongArmour new) with: 1@3->(WeakArmour new)) withRandomValues: self.
	
	minefield playerMovesTo: 1@2.
	minefield playerMovesTo: 1@3.
	
	self assert: (minefield playerHasRemainingLives: 2).
	self deny: (minefield containsArmour: 1@2).
	self deny: (minefield containsArmour: 1@3).
	self assert: (minefield playerHasWeakArmour).
	! !

!MineFieldTest methodsFor: 'as yet unclassified' stamp: 'BR 11/30/2023 21:09:34'!
test15PlayerMovesThroughTunnels
	|minefield tunnel|
	
	
	self randomResults: #(-2 -2).
	tunnel := Tunnel from: 2@2 to: 3@3.
	minefield := MineField playerWithLives: 2 startingOn: 1@1 fieldExtension: 4@4 withTunnels: {tunnel} withMines: (Dictionary new) withArmours: (Dictionary new) withRandomValues: self.
	
	minefield playerMovesTo: 1@2.
	minefield playerMovesTo: 2@2.
	
	self assert: (minefield playerIsInPosition: 3@3).

	! !

!MineFieldTest methodsFor: 'as yet unclassified' stamp: 'BR 11/30/2023 21:25:36'!
test16PlayerCannotFlyOutsideField
	|minefield |
	
	self randomResults: #(3 3).
	minefield := MineField playerWithLives: 2 startingOn: 1@1 fieldExtension: 4@4 withTunnels: {} withMines: (Dictionary with: 2@3->(HighPowerMine new)) withArmours: (Dictionary new) withRandomValues: self.
	
	minefield playerMovesTo: 1@2.
	minefield playerMovesTo: 1@3.
	minefield playerMovesTo: 2@3.
	
	self assert: (minefield playerHasRemainingLives: 0).
	self deny: (minefield containsMine: 2@3).
	self assert: (minefield playerIsUnarmoured).
	self assert: (minefield playerIsInPosition: 2@3).
	self assert: (minefield playerIsDead).
	! !

!MineFieldTest methodsFor: 'as yet unclassified' stamp: 'BR 11/30/2023 21:47:41'!
test17PlayerWinsCorrectly
	|minefield |
	
	self randomResults: #(3 3).
	minefield := MineField playerWithLives: 2 startingOn: 1@1 fieldExtension: 3@3 withTunnels: {} withMines: (Dictionary new) withArmours: (Dictionary new) withRandomValues: self.
	
	minefield playerMovesTo: 1@2.
	minefield playerMovesTo: 1@3.
	
	self assert: (minefield playerHasRemainingLives: 2).
	self assert: (minefield playerWonTheGame ).
	! !

!MineFieldTest methodsFor: 'as yet unclassified' stamp: 'BR 11/30/2023 21:47:49'!
test18PlayerCannotKeepPlayingIfGameIsOver
	|minefield |
	
	self randomResults: #(3 3).
	minefield := MineField playerWithLives: 2 startingOn: 1@1 fieldExtension: 3@3 withTunnels: {} withMines: (Dictionary new) withArmours: (Dictionary new) withRandomValues: self.
	
	minefield playerMovesTo: 1@2.
	minefield playerMovesTo: 1@3.
	
	self 
		should: [minefield playerMovesTo: 2@3]
		raise: Error
		withMessageText: minefield cannotKeepPlayingIfGameIsOverErrorMessage.
	! !

!MineFieldTest methodsFor: 'as yet unclassified' stamp: 'BR 11/30/2023 21:49:40'!
test19PlayerCannotKeepPlayingIfTheyAreDead
	|minefield |
	
	self randomResults: #(3 3).
	minefield := MineField playerWithLives: 2 startingOn: 1@1 fieldExtension: 3@3 withTunnels: {} withMines: (Dictionary with: 1@2->(HighPowerMine new)) withArmours: (Dictionary new) withRandomValues: self.
	
	minefield playerMovesTo: 1@2.
	
	self 
		should: [minefield playerMovesTo: 1@3]
		raise: Error
		withMessageText: minefield cannotKeepPlayingIfGameIsOverErrorMessage.
	! !


!classDefinition: #ArmourType category: 'ISW1-2023-2C-2doParcial'!
Object subclass: #ArmourType
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ISW1-2023-2C-2doParcial'!

!ArmourType methodsFor: 'as yet unclassified' stamp: 'BR 11/30/2023 19:36:10'!
explodeHighPowerMineIn: aMineField

	self subclassResponsibility! !

!ArmourType methodsFor: 'as yet unclassified' stamp: 'BR 11/30/2023 19:36:17'!
explodeLowPowerMineIn: aMineField

	self subclassResponsibility! !


!classDefinition: #StrongArmour category: 'ISW1-2023-2C-2doParcial'!
ArmourType subclass: #StrongArmour
	instanceVariableNames: 'usagesLeft'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ISW1-2023-2C-2doParcial'!

!StrongArmour methodsFor: 'as yet unclassified' stamp: 'BR 11/30/2023 19:36:10'!
explodeHighPowerMineIn: aMineField! !

!StrongArmour methodsFor: 'as yet unclassified' stamp: 'BR 11/30/2023 20:45:54'!
explodeHighPowerMineIn: aMineField withDelta: aDelta

	aMineField affectLifeBy: 0 andPositionBy: 0@0.
	aMineField removeArmour.! !

!StrongArmour methodsFor: 'as yet unclassified' stamp: 'BR 11/30/2023 20:49:27'!
explodeLowPowerMineIn: aMineField

	aMineField affectLifeBy: 0 andPositionBy: 0@0.
	usagesLeft := usagesLeft - 1.
	(usagesLeft = 0) ifTrue: [aMineField removeArmour].! !

!StrongArmour methodsFor: 'as yet unclassified' stamp: 'BR 11/30/2023 20:48:28'!
initialize
	usagesLeft := 2.! !


!classDefinition: #Unarmoured category: 'ISW1-2023-2C-2doParcial'!
ArmourType subclass: #Unarmoured
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ISW1-2023-2C-2doParcial'!

!Unarmoured methodsFor: 'as yet unclassified' stamp: 'BR 11/30/2023 20:21:27'!
explodeHighPowerMineIn: aMineField

	aMineField affectLifeBy: 2 andPositionBy: 0@0! !

!Unarmoured methodsFor: 'as yet unclassified' stamp: 'BR 11/30/2023 20:21:10'!
explodeHighPowerMineIn: aMineField withDelta: aDelta

	aMineField affectLifeBy: 2 andPositionBy: aDelta! !

!Unarmoured methodsFor: 'as yet unclassified' stamp: 'BR 11/30/2023 20:44:22'!
explodeLowPowerMineIn: aMineField
	aMineField affectLifeBy: 1 andPositionBy: 0@0! !


!classDefinition: #WeakArmour category: 'ISW1-2023-2C-2doParcial'!
ArmourType subclass: #WeakArmour
	instanceVariableNames: 'usagesLeft'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ISW1-2023-2C-2doParcial'!

!WeakArmour methodsFor: 'as yet unclassified' stamp: 'BR 11/30/2023 19:36:10'!
explodeHighPowerMineIn: aMineField! !

!WeakArmour methodsFor: 'as yet unclassified' stamp: 'BR 11/30/2023 20:38:21'!
explodeHighPowerMineIn: aMineField withDelta: aDelta
	aMineField affectLifeBy: 0 andPositionBy: ((aDelta x)//2)@((aDelta x)//2).
	aMineField removeArmour .! !

!WeakArmour methodsFor: 'as yet unclassified' stamp: 'BR 11/30/2023 20:30:38'!
explodeLowPowerMineIn: aMineField
	aMineField affectLifeBy: 0 andPositionBy: 0@0.
	aMineField removeArmour.! !

!WeakArmour methodsFor: 'as yet unclassified' stamp: 'BR 11/30/2023 20:48:18'!
initialize
	usagesLeft := 1.! !


!classDefinition: #Mine category: 'ISW1-2023-2C-2doParcial'!
Object subclass: #Mine
	instanceVariableNames: 'power position'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ISW1-2023-2C-2doParcial'!


!classDefinition: #HighPowerMine category: 'ISW1-2023-2C-2doParcial'!
Mine subclass: #HighPowerMine
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ISW1-2023-2C-2doParcial'!

!HighPowerMine methodsFor: 'as yet unclassified' stamp: 'BR 11/30/2023 18:50:57'!
explodeIn: aMineField
	aMineField explodeHighPowerMine.! !

!HighPowerMine methodsFor: 'as yet unclassified' stamp: 'BR 11/30/2023 20:26:55'!
explodeIn: aMineField withRandomValues: randomValues
	aMineField explodeHighPowerMineWithDelta: ((randomValues getNext)@(randomValues getNext)).! !


!classDefinition: #LowPowerMine category: 'ISW1-2023-2C-2doParcial'!
Mine subclass: #LowPowerMine
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ISW1-2023-2C-2doParcial'!

!LowPowerMine methodsFor: 'as yet unclassified' stamp: 'BR 11/30/2023 18:50:57'!
explodeIn: aMineField
	aMineField explodeLowPowerMine.! !

!LowPowerMine methodsFor: 'as yet unclassified' stamp: 'BR 11/30/2023 20:23:09'!
explodeIn: aMineField withRandomValues: randomValues
	aMineField explodeLowPowerMine.! !


!classDefinition: #MineField category: 'ISW1-2023-2C-2doParcial'!
Object subclass: #MineField
	instanceVariableNames: 'playerLivesLeft fieldExtension startingPos tunnels mines armours playerPos playerArmour randomValues isGameOver'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ISW1-2023-2C-2doParcial'!

!MineField methodsFor: 'as yet unclassified' stamp: 'BR 11/30/2023 21:29:05'!
affectLifeBy: aNumberOfLives andPositionBy: aPositionDelta
	self reduceLifeBy: aNumberOfLives .
	self moveOnlyIfPositionIsInRange: (playerPos + aPositionDelta).! !

!MineField methodsFor: 'as yet unclassified' stamp: 'BR 11/30/2023 21:35:10'!
assertGameIsNotOver 
	
	^isGameOver ! !

!MineField methodsFor: 'as yet unclassified' stamp: 'BR 11/30/2023 18:39:57'!
assertIfAMineExplodes: aPosition
	^mines anySatisfy: [:aMine | aMine isAt: aPosition].! !

!MineField methodsFor: 'as yet unclassified' stamp: 'BR 11/30/2023 21:00:03'!
assertNewPositionIsAtDistanceOne: aPosition
	
	^(((aPosition x) - (playerPos x)) abs  + ((aPosition y) - (playerPos y)) abs  ) <= 1.! !

!MineField methodsFor: 'as yet unclassified' stamp: 'BR 11/30/2023 21:32:15'!
cannotKeepPlayingIfGameIsOverErrorMessage
	^'Cannot keep playing if game is over'.! !

!MineField methodsFor: 'as yet unclassified' stamp: 'BR 11/30/2023 19:54:08'!
collectArmourIfPresent: aPosition
	(armours includesKey: aPosition) ifTrue: [
		playerArmour := (armours at: aPosition).
		armours removeKey: aPosition.
		].
! !

!MineField methodsFor: 'as yet unclassified' stamp: 'BR 11/30/2023 19:54:57'!
containsArmour: aPosition
	^armours includesKey: aPosition! !

!MineField methodsFor: 'as yet unclassified' stamp: 'BR 11/30/2023 19:29:00'!
containsMine: aPos
	^mines includesKey: aPos.! !

!MineField methodsFor: 'as yet unclassified' stamp: 'BR 11/30/2023 20:28:04'!
explodeHighPowerMine
	playerArmour explodeHighPowerMineIn: self withDelta: 0@0.
	! !

!MineField methodsFor: 'as yet unclassified' stamp: 'BR 11/30/2023 20:28:18'!
explodeHighPowerMineWithDelta: aDelta
	playerArmour explodeHighPowerMineIn: self withDelta: aDelta.
	! !

!MineField methodsFor: 'as yet unclassified' stamp: 'BR 11/30/2023 19:35:32'!
explodeLowPowerMine
	playerArmour explodeLowPowerMineIn: self.! !

!MineField methodsFor: 'as yet unclassified' stamp: 'BR 11/30/2023 20:24:30'!
explodeMineIfPresent: aPosition
	|mine|
	(mines includesKey: aPosition) ifTrue: [
		mine := mines at: aPosition.
		mine explodeIn: self withRandomValues: randomValues.
		mines removeKey: aPosition.
		].
	
	! !

!MineField methodsFor: 'as yet unclassified' stamp: 'BR 11/30/2023 20:16:34'!
initializePlayerWithLives: aNumberOfLives startingOn: aStartingPosition fieldExtension: aFieldExtension withTunnels: aCollectionOfTunnels withMines: aCollectionOfMines withArmours: aCollectionOfArmours

	^self initializePlayerWithLives: aNumberOfLives startingOn: aStartingPosition fieldExtension: aFieldExtension withTunnels: aCollectionOfTunnels withMines: aCollectionOfMines withArmours: aCollectionOfArmours withRandomValues: #().! !

!MineField methodsFor: 'as yet unclassified' stamp: 'BR 11/30/2023 21:28:21'!
initializePlayerWithLives: aNumberOfLives startingOn: aStartingPos fieldExtension: aFieldExtension withTunnels: aCollectionOfTunnels withMines: aCollectionOfMines withArmours: aCollectionOfArmours withRandomValues: aCollectionOfRandomValues

	playerLivesLeft := aNumberOfLives.
	fieldExtension := aFieldExtension.
	tunnels := aCollectionOfTunnels.
	mines := aCollectionOfMines.
	armours := aCollectionOfArmours.
	playerPos := aStartingPos .
	playerArmour := Unarmoured new.
	randomValues := aCollectionOfRandomValues.
	isGameOver := false.! !

!MineField methodsFor: 'as yet unclassified' stamp: 'BR 11/30/2023 21:40:00'!
moveOnlyIfPositionIsInRange: aPosition.
	
	^(aPosition between: 1@1 and: fieldExtension) ifTrue: [
		playerPos := aPosition.
		isGameOver := self playerWonTheGame 
		] .
! !

!MineField methodsFor: 'as yet unclassified' stamp: 'BR 11/30/2023 18:23:20'!
playerHasRemainingLives: aNumberOfLives
	^aNumberOfLives = playerLivesLeft .! !

!MineField methodsFor: 'as yet unclassified' stamp: 'BR 11/30/2023 21:07:36'!
playerHasWeakArmour
	^playerArmour isKindOf: WeakArmour.! !

!MineField methodsFor: 'as yet unclassified' stamp: 'BR 11/30/2023 21:28:36'!
playerIsDead
	^playerLivesLeft = 0.! !

!MineField methodsFor: 'as yet unclassified' stamp: 'BR 11/30/2023 19:58:08'!
playerIsInPosition: aPosition
	^playerPos = aPosition.! !

!MineField methodsFor: 'as yet unclassified' stamp: 'BR 11/30/2023 19:44:39'!
playerIsUnarmoured
	^playerArmour isKindOf: Unarmoured.! !

!MineField methodsFor: 'as yet unclassified' stamp: 'BR 11/30/2023 21:30:03'!
playerLosesLifeDueToMine 
	
	self reduceLifeBy: 1.! !

!MineField methodsFor: 'as yet unclassified' stamp: 'BR 11/30/2023 21:54:18'!
playerMovesTo: aPosition

	(self assertGameIsNotOver) ifTrue: [self error: self cannotKeepPlayingIfGameIsOverErrorMessage ].
	(self assertNewPositionIsAtDistanceOne: aPosition) ifFalse: [self error: self class cannotMoveMoreThanOneStepAtATimeErrorMessage .].
	self moveOnlyIfPositionIsInRange: aPosition.
	
	self explodeMineIfPresent: aPosition.
	self collectArmourIfPresent: aPosition.
	self takeTunnelIfPresent: aPosition.
! !

!MineField methodsFor: 'as yet unclassified' stamp: 'BR 11/30/2023 21:38:53'!
playerWonTheGame
	^(playerPos y= fieldExtension y).! !

!MineField methodsFor: 'as yet unclassified' stamp: 'BR 11/30/2023 21:53:26'!
reduceLifeBy: aNumberOfLives

	playerLivesLeft := playerLivesLeft - aNumberOfLives.
	(playerLivesLeft < 0) ifTrue: [isGameOver = true]! !

!MineField methodsFor: 'as yet unclassified' stamp: 'BR 11/30/2023 19:43:41'!
removeArmour
	playerArmour := Unarmoured new.
	! !

!MineField methodsFor: 'as yet unclassified' stamp: 'BR 11/30/2023 21:17:44'!
takeTunnelIfPresent: aPosition
	|tunnel|
	
	tunnel := tunnels detect: [:aTunnel | aTunnel isUnder: aPosition] ifNone: [^self].
	playerPos := tunnel returnOppositeEnd: aPosition.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MineField class' category: 'ISW1-2023-2C-2doParcial'!
MineField class
	instanceVariableNames: ''!

!MineField class methodsFor: 'as yet unclassified' stamp: 'BR 11/30/2023 18:07:42'!
assertPlayer: aStartingPos isNotSteppingOnATunnel: aCollectionOfTunnels.

	^(aCollectionOfTunnels anySatisfy: [:tunnel | tunnel isUnder: aStartingPos]) not. ! !

!MineField class methodsFor: 'as yet unclassified' stamp: 'BR 11/30/2023 18:14:42'!
assertPlayerHasValidStartingLives: aNumberOfLives
	^aNumberOfLives > 0.! !

!MineField class methodsFor: 'as yet unclassified' stamp: 'BR 11/30/2023 20:52:40'!
cannotMoveMoreThanOneStepAtATimeErrorMessage
	^'Cannot move more than one step at a time'! !

!MineField class methodsFor: 'as yet unclassified' stamp: 'BR 11/30/2023 18:14:11'!
invalidNumberOfStaringLivesErrorMessage

	^'Number of starting lives must be greater or equal than zero'.! !

!MineField class methodsFor: 'as yet unclassified' stamp: 'BR 11/30/2023 17:45:03'!
invalidStartingPositionErrorMessage
	^'Invalid starting position for player'! !

!MineField class methodsFor: 'as yet unclassified' stamp: 'BR 11/30/2023 17:47:34'!
isValidStartingPos: aStartingPos.

	^aStartingPos y = 1.! !

!MineField class methodsFor: 'as yet unclassified' stamp: 'BR 11/30/2023 19:26:31'!
isValidStartingPos: aStartingPos withRespectTo: aCollectionOfTunnels and: aCollectionOfMines and: aCollectionOfArmours
	
	^aStartingPos y = 1 and:[
			(aCollectionOfMines includesKey: aStartingPos) not and:[
				(aCollectionOfArmours includesKey: aStartingPos) not 
				]
		]! !

!MineField class methodsFor: 'as yet unclassified' stamp: 'BR 11/30/2023 21:42:29'!
playerWithLives: aNumberOfLives startingOn: aStartingPos fieldExtension: aFieldExtension withTunnels: aCollectionOfTunnels withMines: aCollectionOfMines withArmours: aCollectionOfArmours

	(self isValidStartingPos: aStartingPos withRespectTo: aCollectionOfTunnels and: aCollectionOfMines and: aCollectionOfArmours ) ifFalse: [^self error: self invalidStartingPositionErrorMessage ].
	
	(self assertPlayer: aStartingPos isNotSteppingOnATunnel: aCollectionOfTunnels) ifFalse: [^self error: self invalidStartingPositionErrorMessage ].
	
	(self assertAreDisjointTunnels: aCollectionOfTunnels and: aCollectionOfMines and: aCollectionOfArmours) ifFalse: [^self error: self invalidStartingSetupErrorMessage].
	
	(self assertPlayerHasValidStartingLives: aNumberOfLives) ifFalse: [^self error: self invalidNumberOfStaringLivesErrorMessage ].

	^self new initializePlayerWithLives: aNumberOfLives startingOn: aStartingPos fieldExtension: aFieldExtension withTunnels: aCollectionOfTunnels withMines: aCollectionOfMines withArmours: aCollectionOfArmours! !

!MineField class methodsFor: 'as yet unclassified' stamp: 'BR 11/30/2023 20:15:09'!
playerWithLives: aNumberOfLives startingOn: aStartingPos fieldExtension: aFieldExtension withTunnels: aCollectionOfTunnels withMines: aCollectionOfMines withArmours: aCollectionOfArmours withRandomValues: aCollectionOfRandomValues

	(self isValidStartingPos: aStartingPos withRespectTo: aCollectionOfTunnels and: aCollectionOfMines and: aCollectionOfArmours ) ifFalse: [^self error: self invalidStartingPositionErrorMessage ].
	(self assertPlayer: aStartingPos isNotSteppingOnATunnel: aCollectionOfTunnels) ifFalse: [^self error: self invalidStartingPositionErrorMessage ].
	(self assertPlayerHasValidStartingLives: aNumberOfLives) ifFalse: [^self error: self invalidNumberOfStaringLivesErrorMessage ].

	^self new initializePlayerWithLives: aNumberOfLives startingOn: aStartingPos fieldExtension: aFieldExtension withTunnels: aCollectionOfTunnels withMines: aCollectionOfMines withArmours: aCollectionOfArmours withRandomValues: aCollectionOfRandomValues.! !


!classDefinition: #Tunnel category: 'ISW1-2023-2C-2doParcial'!
Object subclass: #Tunnel
	instanceVariableNames: 'from to'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ISW1-2023-2C-2doParcial'!

!Tunnel methodsFor: 'as yet unclassified' stamp: 'BR 11/30/2023 18:02:25'!
initializeFrom: position1 to: position2

	from := position1.
	to := position2.! !

!Tunnel methodsFor: 'as yet unclassified' stamp: 'BR 11/30/2023 18:07:06'!
isUnder: aPos
	^aPos = from or: [aPos = to].! !

!Tunnel methodsFor: 'as yet unclassified' stamp: 'BR 11/30/2023 21:14:47'!
returnOppositeEnd: aPosition
	(aPosition = from) ifTrue: [^to].
	^from.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Tunnel class' category: 'ISW1-2023-2C-2doParcial'!
Tunnel class
	instanceVariableNames: ''!

!Tunnel class methodsFor: 'as yet unclassified' stamp: 'BR 11/30/2023 18:02:01'!
from: position1 to: position2
	^self new initializeFrom: position1 to: position2! !
