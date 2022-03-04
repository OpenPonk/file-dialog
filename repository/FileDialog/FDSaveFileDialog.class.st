"
My responsibility is to provide dialog for SAVING files.
"
Class {
	#name : #FDSaveFileDialog,
	#superclass : #FDFileDialog,
	#category : #FileDialog
}

{ #category : #api }
FDSaveFileDialog >> initialTitle [
	^ 'Save As'
]

{ #category : #initialization }
FDSaveFileDialog >> initializePresenter [
	| ec |
	super initializePresenter.
	(ec := EntryCompletion new)
		dataSourceBlock: [ :text | currentDirectory children collect: #basename ];
		filterBlock: [ :opt :text | opt beginsWith: text ].
	nameText entryCompletion: ec.
	nameText whenTextChanged: [ self nameChanged ]
]

{ #category : #initialization }
FDSaveFileDialog >> initializeWidgets [
	super initializeWidgets.
	confirmButton label: 'Save'
]

{ #category : #testing }
FDSaveFileDialog >> isFileValid [
	^ nameText text isNotEmpty
]

{ #category : #actions }
FDSaveFileDialog >> nameChanged [
	| file |
	confirmButton enabled: self isFileValid.
	filesList selectedItem
		ifNotNil: [ :selectedItem | 
			selectedItem basename = nameText text
				| (selectedItem basenameWithoutExtension = nameText text)
				ifTrue: [ ^ self ] ].
	file := filesList listItems
		detect: [ :any | any basename = nameText text ]
		ifNone: [ filesList listItems
				detect: [ :any | any basenameWithoutExtension = nameText text ]
				ifNone: [ lastSelectedFile := FDFileSelectionRecord none.
					^ filesList setSelectedIndex: 0 ] ].
	file isFile
		ifFalse: [ ^ self ].
	lastSelectedFile := FDFileSelectionRecord byNameOfFile: file.
	filesList setSelectedItem: file
]

{ #category : #actions }
FDSaveFileDialog >> selectFile: aFile [
	lastSelectedFile isFileSelectedBasedOnName
		ifTrue: [ lastSelectedFile := FDFileSelectionRecord ofFile: aFile.
			^ self ].
	super selectFile: aFile
]

{ #category : #accessing }
FDSaveFileDialog >> selectedEntry [
	| entry proceed |
	entry := self currentDirectory / nameText text.
	filtersDropList selectedItem value
		ifNotEmpty: [ :extensions | 
			(nameText text includes: $.)
				ifFalse: [ entry := entry
						, ((extensions first copyReplaceAll: '*' with: '') withoutPrefix: '.') ] ].
	proceed := entry exists not.
	entry exists
		ifTrue: [ proceed := UIManager default
				proceed:
					('File named "{1}" already exists. Do you want to overwrite it?'
						format: {entry printString}) ].
	^ proceed
		ifTrue: [ entry ]
		ifFalse: [ nil ]
]
