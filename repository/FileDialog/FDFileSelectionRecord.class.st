Class {
	#name : #FDFileSelectionRecord,
	#superclass : #Object,
	#instVars : [
		'file',
		'timestamp',
		'basedOnName'
	],
	#category : #FileDialog
}

{ #category : #'instance creation' }
FDFileSelectionRecord class >> byNameOfFile: aFileReference [
	^ self new
		basedOnName;
		file: aFileReference;
		yourself
]

{ #category : #'instance creation' }
FDFileSelectionRecord class >> none [
	^ self ofFile: nil
]

{ #category : #'instance creation' }
FDFileSelectionRecord class >> ofFile: aFileReference [
	^ self new
		file: aFileReference;
		yourself
]

{ #category : #accessing }
FDFileSelectionRecord >> basedOnName [
	basedOnName := true
]

{ #category : #accessing }
FDFileSelectionRecord >> file [
	^ file
]

{ #category : #accessing }
FDFileSelectionRecord >> file: anObject [
	file := anObject.
	self timestamp: DateAndTime now
]

{ #category : #testing }
FDFileSelectionRecord >> hasBeenDirectlySelectedInLast: aDuration [
	^ basedOnName not
		and:
			[ file isNotNil and: [ DateAndTime now - self timestamp <= aDuration ] ]
]

{ #category : #initialization }
FDFileSelectionRecord >> initialize [
	super initialize.
	basedOnName := false
]

{ #category : #accessing }
FDFileSelectionRecord >> isFileSelectedBasedOnName [
	^ basedOnName
]

{ #category : #accessing }
FDFileSelectionRecord >> timestamp [
	^ timestamp
]

{ #category : #accessing }
FDFileSelectionRecord >> timestamp: anObject [
	timestamp := anObject
]