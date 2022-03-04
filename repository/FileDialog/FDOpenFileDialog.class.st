"
My responsibility is to provide dialog for selecting Files.


Example of modal use

[[[  
FDOpenFileDialog new openModal
]]]

Example of modal use

[[[ 
FDOpenFileDialog new
	whenSelected: [ :file | file inspect ];
	extensionFilters: {
		'All images' -> #(jpg png gif svg).
		'All files' -> #()
	};
	defaultFolder: FileLocator imageDirectory asFileReference;
	open
]]]
"
Class {
	#name : #FDOpenFileDialog,
	#superclass : #FDFileDialog,
	#category : #FileDialog
}

{ #category : #api }
FDOpenFileDialog >> initialTitle [
	^ 'Select File To Open'
]

{ #category : #initialization }
FDOpenFileDialog >> initializeWidgets [
	super initializeWidgets.
	nameText disable.
	confirmButton label: 'Open'
]

{ #category : #actions }
FDOpenFileDialog >> selectFile: aFile [
	super selectFile: aFile.
	confirmButton enable
]

{ #category : #accessing }
FDOpenFileDialog >> selectedEntry [
	^ filesList listItems
		detect: [ :any | any basename = nameText text ]
		ifNone: [ filesList listItems
				detect: [ :any | any basenameWithoutExtension = nameText text ]
				ifNone: [ nil ] ]
]

{ #category : #actions }
FDOpenFileDialog >> unselected [
	super unselected.
	filesList selectedItem ifNil: [ confirmButton disable ]
]
