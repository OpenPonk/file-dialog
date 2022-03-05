"
I am an abstract class providing dialog for selecting files, but not directories
"
Class {
	#name : #FDFileDialog,
	#superclass : #FDFileReferenceDialog,
	#instVars : [
		'nameText',
		'nameLabel'
	],
	#category : #FileDialog
}

{ #category : #specs }
FDFileDialog class >> defaultSpec [
	^ SpecColumnLayout composed
		newRow: [ :r | 
			r
				newColumn: [ :c | c add: #bookmarksList ] width: 150;
				newColumn: [ :c | 
					c add: #currentFolderLabel height: self toolbarHeight.
					c add: #filesList ] ];
		newRow: [ :r | 
			r
				add: #nameLabel width: 50;
				add: #nameText;
				add: #filtersDropList width: 200 ]
			height: self toolbarHeight;
		newRow: [ :r | 
			r newColumn: [ :c |  ].
			self dialogButtonsLayout: r ]
			height: self toolbarHeight;
		yourself
]

{ #category : #public }
FDFileDialog >> defaultName: aString [
	nameText text: aString
]

{ #category : #initialization }
FDFileDialog >> initializeWidgets [
	super initializeWidgets.
	(nameLabel := self newLabel) label: 'Name:'.
	(nameText := self newTextInput) autoAccept: true.
	self focusOrder addFirst: nameText
]

{ #category : #'accessing - spec fields' }
FDFileDialog >> nameLabel [
	^ nameLabel
]

{ #category : #'accessing - spec fields' }
FDFileDialog >> nameText [
	^ nameText
]

{ #category : #actions }
FDFileDialog >> selectFile: aFile [
	nameText text: aFile basename.
	super selectFile: aFile
]

{ #category : #actions }
FDFileDialog >> unselected [

	| originalLastSelectedFile |
	(lastSelectedFile hasBeenDirectlySelectedInLast: 600 milliSeconds) 
		ifTrue: [ 
			filesList setSelectedItem: lastSelectedFile file.
			nameText text: lastSelectedFile file basename.
			^ self confirm ].
	originalLastSelectedFile := lastSelectedFile.
	nameText text: ''.
	Transcript crShow:
		'unselected: was not recently selected, unselecting'.
	lastSelectedFile := originalLastSelectedFile unselected
]
