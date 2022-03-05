"
I am an abstract base class for different styles of opening/saving.

Don't use me directly -- instead use one of my children.

## Examples

see class-side

## Website

https://github.com/peteruhnak/file-dialog
"
Class {
	#name : #FDFileReferenceDialog,
	#superclass : #ComposablePresenter,
	#instVars : [
		'bookmarksList',
		'createFolderButton',
		'filesList',
		'currentDirectory',
		'cancelButton',
		'confirmButton',
		'onConfirmBlock',
		'showHiddenFiles',
		'filter',
		'filtersDropList',
		'fileFilters',
		'currentFolderLabel',
		'lastSelectedFile'
	],
	#classVars : [
		'CustomBookmarks'
	],
	#category : #FileDialog
}

{ #category : #adding }
FDFileReferenceDialog class >> addBookmark: aFolder [
	self customBookmarks detect: [ :each | each location = aFolder ] ifFound: [ ^ self ].
	self customBookmarks
		add: (FDBookmark name: aFolder basename location: aFolder icon: (self iconNamed: #open))
]

{ #category : #icons }
FDFileReferenceDialog class >> allIcons [
	<script: 'self allIcons inspect'>
	^ (Pragma
		allNamed: 'icons'
		from: self class
		to: FDFileReferenceDialog class)
		flatCollect:
			[ :pragma | pragma methodClass instanceSide perform: pragma methodSelector ]
]

{ #category : #icons }
FDFileReferenceDialog class >> basicIcons [
"	<icons>
	^ {#zip -> ''}"
]

{ #category : #adding }
FDFileReferenceDialog class >> convertBookmarks: aDictionary [
	"convert bookmarks from old OrderedDictionary of location->#(name icon) to FDBookmark instances"

	^ aDictionary associations asOrderedCollection
		collect: [ :pair | FDBookmark name: pair value first location: pair key icon: pair value second ]
]

{ #category : #adding }
FDFileReferenceDialog class >> customBookmarks [
	CustomBookmarks isDictionary
		ifTrue: [ CustomBookmarks := self convertBookmarks: CustomBookmarks ].
	^ CustomBookmarks ifNil: [ CustomBookmarks := OrderedCollection new ]
]

{ #category : #adding }
FDFileReferenceDialog class >> customBookmarks: aCollection [
	self assert: [ aCollection isKindOf: OrderedCollection ].
	self assert: [ aCollection allSatisfy: [ :each | each isKindOf: FDBookmark ] ].
	CustomBookmarks := aCollection
]

{ #category : #specs }
FDFileReferenceDialog class >> dialogButtonsLayout: aRow [
	^ OSPlatform current isWindows
		ifTrue: [ aRow
						add: #confirmButton width: 60;
						add: #cancelButton width: 60 ]
		ifFalse: [ aRow
						add: #cancelButton width: 60;
						add: #confirmButton width: 60 ]
]

{ #category : #example }
FDFileReferenceDialog class >> example [
	^ FDOpenFileDialog new
		whenSelected: [ :file | file inspect ];
		extensionFilters:
			{'All Images' -> #(jpg png gif svg).
			'All Files' -> #()};
		defaultFolder: FileLocator imageDirectory asFileReference;
		defaultName: 'hello.png';
		open
]

{ #category : #example }
FDFileReferenceDialog class >> exampleModal [
	"modal returns the selected value"

	(FDOpenDirectoryDialog new
		defaultFolder: FileLocator imageDirectory asFileReference;
		openModal) inspect
]

{ #category : #'filtering - convenience' }
FDFileReferenceDialog class >> filterAllFiles [
	^ {'All Files' -> #()}
]

{ #category : #'filtering - convenience' }
FDFileReferenceDialog class >> filterAllImages [
	^ {'All Images' -> #(jpg png gif svg)}
]

{ #category : #example }
FDFileReferenceDialog class >> forImages [
	^ self new
		extensionFilters:
			{'All Images' -> #(jpg png gif svg).
			'All Files' -> #()}
]

{ #category : #icons }
FDFileReferenceDialog class >> imageIcons [
	<icons>
	^ {(#png -> (self iconNamed: #komitter)).
		(#jpg -> (self iconNamed: #komitter)).
		(#gif -> (self iconNamed: #komitter)).
		(#svg -> (self iconNamed: #komitter))}
]

{ #category : #adding }
FDFileReferenceDialog class >> removeBookmark: aFolder [
	self customBookmarks removeAllSuchThat: [ :each | each location = aFolder ]
]

{ #category : #icons }
FDFileReferenceDialog class >> textIcons [
	<icons>
	^ {(#st -> (self iconNamed: #smallLeftFlush)).
		(#txt -> (self iconNamed: #smallLeftFlush))}
]

{ #category : #bookmarks }
FDFileReferenceDialog >> addBookmark: aFolder [
	self class addBookmark: aFolder.
	self refreshBookmarks
]

{ #category : #bookmarks }
FDFileReferenceDialog >> bookmarks [
	^ self defaultBookmarks , self customBookmarks
]

{ #category : #'accessing - spec fields' }
FDFileReferenceDialog >> bookmarksList [
	^ bookmarksList
]

{ #category : #'accessing - spec fields' }
FDFileReferenceDialog >> cancelButton [
	^ cancelButton
]

{ #category : #utility }
FDFileReferenceDialog >> canonicalize: aFileReference [
	^ (aFileReference respondsTo: #canonicalize)
		ifTrue: [ ">= P7" aFileReference canonicalize ]
		ifFalse: [ "<= P6" aFileReference pathString asFileReference ]
]

{ #category : #actions }
FDFileReferenceDialog >> confirm [
	self selectedEntry
		ifNotNil: [ :entry | 
			onConfirmBlock value: entry.
			self delete ]
]

{ #category : #'accessing - spec fields' }
FDFileReferenceDialog >> confirmButton [
	^ confirmButton
]

{ #category : #actions }
FDFileReferenceDialog >> createDirectory [
	^ self createDirectory: 'new-folder'
]

{ #category : #actions }
FDFileReferenceDialog >> createDirectory: initialName [
	| name path |
	name := (UIManager default
		request: 'Folder name'
		initialAnswer: initialName
		title: 'Create New Folder') ifNil: [ ^ self ].
	path := currentDirectory / name.
	path exists
		ifFalse: [ (currentDirectory / name) ensureCreateDirectory.
			self openFolder: currentDirectory.
			^ self ].
	path isDirectory
		ifTrue: [ UIManager default alert: 'A folder with that name already exists.' ].
	path isFile
		ifTrue: [ UIManager default alert: 'A file with that name already exists.' ].
	self createDirectory: name
]

{ #category : #'accessing - spec fields' }
FDFileReferenceDialog >> createFolderButton [
	^ createFolderButton
]

{ #category : #accessing }
FDFileReferenceDialog >> currentDirectory [
	^ currentDirectory ifNil: [ currentDirectory := self defaultFolder ]
]

{ #category : #accessing }
FDFileReferenceDialog >> currentFiles [
	^ ((self isRootDirectory: currentDirectory)
		ifTrue: [ {} ]
		ifFalse: [ {self currentDirectory / '..'} ]) , self currentDirectory children
]

{ #category : #'accessing - spec fields' }
FDFileReferenceDialog >> currentFolderLabel [
	^ currentFolderLabel
]

{ #category : #utility }
FDFileReferenceDialog >> currentFolderTitleFor: aString [
	| e optimal max leftBarWidth |
	e := self window ifNil: [ self initialExtent ] ifNotNil: [ self window window extent ].
	leftBarWidth := 200.
	optimal := (LabelMorph contents: aString) optimalExtent x.
	max := e x - leftBarWidth.
	optimal < max
		ifTrue: [ ^ aString , self delimiter ].
	^ '... ' , (aString last: (aString size * (max / optimal)) rounded) , self delimiter
]

{ #category : #bookmarks }
FDFileReferenceDialog >> customBookmarks [
	^ self class customBookmarks
]

{ #category : #bookmarks }
FDFileReferenceDialog >> defaultBookmarks [
	| presets |
	presets := OrderedCollection new.
	presets add: FDBookmark image.
	presets add: FDBookmark home.
	OSPlatform current isUnix
		ifTrue: [ presets add: FDBookmark root.
			presets add: FDBookmark tmp ].
	OSPlatform current isWindows
		ifTrue: [ presets addAll: FDBookmark windowsDrives ].
	^ presets
]

{ #category : #accessing }
FDFileReferenceDialog >> defaultFolder [
	^ FileLocator imageDirectory asFileReference
]

{ #category : #public }
FDFileReferenceDialog >> defaultFolder: aPath [
	(aPath isNotNil and: [ aPath asFileReference exists ])
		ifTrue: [ self openFolder: aPath asFileReference ]
		ifFalse: [ self openFolder: self defaultFolder ]
]

{ #category : #accessing }
FDFileReferenceDialog >> delimiter [
	^ FileSystem disk delimiter asString
]

{ #category : #public }
FDFileReferenceDialog >> extensionFilters: anArray [
	self
		fileFilters:
			(anArray
				collect: [ :each | 
					| exts |
					exts := each value collect: [ :ext | '*.' , ext ].
					(each key
						, (each value ifEmpty: [ '' ] ifNotEmpty: [ ' (' , (exts joinUsing: ', ') , ')' ]))
						-> exts ])
]

{ #category : #accessing }
FDFileReferenceDialog >> fileFilters [
	^ fileFilters ifNil: [ fileFilters := self class filterAllFiles ]
]

{ #category : #public }
FDFileReferenceDialog >> fileFilters: anArray [
	anArray ifEmpty: [ ^ self ].
	anArray anyOne isString
		ifTrue: [ fileFilters := {(anArray joinUsing: ', ') -> anArray} ]
		ifFalse: [ fileFilters := anArray ].
	filtersDropList items: fileFilters
]

{ #category : #accessing }
FDFileReferenceDialog >> filesFilteringBlock [
	^ [ :entries | 
	| e |
	e := entries.
	showHiddenFiles
		ifFalse: [ e := filter noHiddenFiles: entries ].
	filtersDropList selectedItem value
		ifNotEmpty: [ :patterns | e := filter files: e matching: patterns ].
	e ]
]

{ #category : #'accessing - spec fields' }
FDFileReferenceDialog >> filesList [
	^ filesList
]

{ #category : #public }
FDFileReferenceDialog >> filteredExtensions: anArray [
	self deprecated: 'Use extensionFilters: instead'.
	self extensionFilters: anArray
]

{ #category : #'accessing - spec fields' }
FDFileReferenceDialog >> filtersDropList [
	^ filtersDropList
]

{ #category : #accessing }
FDFileReferenceDialog >> iconFor: anEntry [
	| icons ext |
	icons := self icons.
	anEntry isDirectory
		ifTrue: [ ^ self iconNamed: #open ].
	ext := anEntry extension.
	^ self class allIcons asDictionary
		at: ext
		ifPresent: [ :icon | icon ]
		ifAbsent: [ self iconNamed: #page ]
]

{ #category : #accessing }
FDFileReferenceDialog >> icons [
	^ Smalltalk ui icons
]

{ #category : #api }
FDFileReferenceDialog >> initialExtent [
	^ 550 @ 550
]

{ #category : #api }
FDFileReferenceDialog >> initialTitle [
	^ self subclassResponsibility
]

{ #category : #initialization }
FDFileReferenceDialog >> initialize [
	showHiddenFiles := false.
	lastSelectedFile := FDFileSelectionRecord none.
	onConfirmBlock := [ :selection |  ].
	filter := FDFileFilter new.
	super initialize.
	self defaultFolder: self defaultFolder
]

{ #category : #initialization }
FDFileReferenceDialog >> initializeBookmarksList [
	| nonRemovableBookmarks |
	nonRemovableBookmarks := self defaultBookmarks.
	bookmarksList items: self bookmarks.
	bookmarksList autoDeselect: false.
	bookmarksList displayBlock: [ :each | each name ].
	bookmarksList icons: [ :each | each icon ].
	self selectBookmarkFor: self currentDirectory.
	bookmarksList
		whenSelectedItemChanged: [ :bookmark | bookmark ifNotNil: [ self openFolder: bookmark location ] ].
	bookmarksList
		menu: [ :aMenu :shifterd | 
			bookmarksList selectedItem
				ifNotNil: [ :bookmark | 
					(nonRemovableBookmarks includes: bookmark)
						ifFalse: [ aMenu
								add: 'Remove bookmark'
								target: self
								selector: #removeBookmark:
								argument: bookmark ].
					aMenu ] ]
]

{ #category : #initialization }
FDFileReferenceDialog >> initializeDragAndDrop [
	filesList dragEnabled: true.
	bookmarksList
		dropEnabled: true;
		wantDropBlock: [ :item :event :source | 
			item isTransferable
				and: [ item source = filesList
						and: [ item passenger first originalObject isDirectory
								and: [ (item passenger first originalObject basename = '..') not ] ] ] ];
		acceptDropBlock: [ :transfer :event :source :receiver | self addBookmark: transfer passenger first originalObject ]
]

{ #category : #initialization }
FDFileReferenceDialog >> initializeFilesList [

	filesList
		items: self currentFiles;
		autoDeselect: true;
		displayBlock: [ :entry | entry basename ];
		icons: [ :entry | self iconFor: entry ];
		filteringBlock: self filesFilteringBlock;
		sortingBlock: [ :a :b | 
			(a isDirectory & b isDirectory not or: [ 
					 a isDirectory & b isDirectory
					 & (a basename asLowercase < b basename asLowercase) ]) or: [ 
					a isFile & b isFile
					& (a basename asLowercase < b basename asLowercase) ] ].
	filesList whenSelectedItemChanged: [ :entry | 
		entry
			ifNotNil: [ 
				Transcript crShow: 'initializeFilesList: selected'.
				entry isDirectory
					ifTrue: [ self openFolder: entry ]
					ifFalse: [ self selectFile: entry ] ]
			ifNil: [ 
				Transcript crShow: 'initializeFilesList: unselected'.
				self unselected ] ].
	filesList menu: [ :aMenu :shifterd | 
		aMenu
			add: 'Create directory' target: self selector: #createDirectory;
			add: 'Toggle hidden files'
			target: self
			selector: #toggleHiddenFiles;
			yourself ]
]

{ #category : #initialization }
FDFileReferenceDialog >> initializeFiltersDropList [
	filtersDropList
		items: self fileFilters;
		displayBlock: [ :item | item key ];
		whenSelectedItemChanged: [ :item | filesList refreshListItems ];
		setSelectedIndex: 1
]

{ #category : #initialization }
FDFileReferenceDialog >> initializePresenter [
	self initializeBookmarksList.
	self initializeFilesList.
	self initializeFiltersDropList.
	self initializeDragAndDrop.
	cancelButton action: [ self delete ].
	confirmButton action: [ self confirm ]
]

{ #category : #initialization }
FDFileReferenceDialog >> initializeWidgets [
	bookmarksList := self instantiate: IconListModel.
	(currentFolderLabel := self newLabel)
		color: Smalltalk ui theme textColor.
	filesList := self instantiate: IconListModel.
	createFolderButton := self newButton.
	(cancelButton := self newButton) label: 'Cancel'.
	(confirmButton := self newButton)
		label: 'Confirm';
		disable.
	filtersDropList := self newDropList.
	self title: self initialTitle.
	self focusOrder
		add: filtersDropList;
		add: cancelButton;
		add: confirmButton
]

{ #category : #accessing }
FDFileReferenceDialog >> isRootDirectory: aDirectory [
	^ aDirectory isRoot or: [ OSPlatform current isWindows and: [ aDirectory parent isRoot ] ]
]

{ #category : #'instance creation' }
FDFileReferenceDialog >> open [
	^ self openWithSpec
]

{ #category : #actions }
FDFileReferenceDialog >> openFolder: aFolder [
	currentDirectory := self canonicalize: aFolder.
	currentFolderLabel
		label: (self currentFolderTitleFor: currentDirectory pathString);
		help: currentDirectory pathString , self delimiter.
	filesList items: self currentFiles.
	filesList resetSelection.
	self selectBookmarkFor: currentDirectory
]

{ #category : #'instance creation' }
FDFileReferenceDialog >> openModal [
	| result |
	self whenSelected: [ :file | result := file ].
	self openWithSpec modalRelativeTo: self currentWorld.
	^ result
]

{ #category : #bookmarks }
FDFileReferenceDialog >> refreshBookmarks [
	bookmarksList items: self bookmarks
]

{ #category : #bookmarks }
FDFileReferenceDialog >> removeBookmark: aBookmark [
	self class removeBookmark: aBookmark location.
	self refreshBookmarks
]

{ #category : #utility }
FDFileReferenceDialog >> selectBookmarkFor: aDirectory [
	"bookmarksList' ListModel uses identity based comparison, so I need to select index instead"
	
	"is there withIndexDetect: ?"
	bookmarksList setSelectedIndex: ((self bookmarks collect: #location) indexOf: aDirectory)
]

{ #category : #actions }
FDFileReferenceDialog >> selectFile: aFile [

	filesList selectedItem = aFile ifFalse: [ 
		Transcript crShow: 'selectFile: different file'.
		filesList setSelectedIndex: (filesList listItems indexOf: aFile) ].
	(lastSelectedFile
		 hasBeen: aFile
		 directlyUnselectedInLast: 600 milliseconds) ifTrue: [ 
		Transcript crShow: 'selectFile: confirming'.
		self confirm ].
	Transcript crShow: 'selectFile: marking file as selected'.
	lastSelectedFile := FDFileSelectionRecord ofFile: aFile
]

{ #category : #accessing }
FDFileReferenceDialog >> selectedEntry [
	^ self subclassResponsibility
]

{ #category : #actions }
FDFileReferenceDialog >> toggleHiddenFiles [
	showHiddenFiles := showHiddenFiles not.
	filesList items: self currentFiles
]

{ #category : #actions }
FDFileReferenceDialog >> unselected [

	(lastSelectedFile hasBeenDirectlySelectedInLast: 600 milliSeconds) 
		ifFalse: [ 
			Transcript crShow: 'unselected: was not directly selected'.
			lastSelectedFile unselected.
			^ self ].
	Transcript crShow: 'unselected: was directly selected'.
	filesList setSelectedItem: lastSelectedFile file.
	self confirm
]

{ #category : #public }
FDFileReferenceDialog >> whenSelected: aOneArgBlock [
	onConfirmBlock := aOneArgBlock
]
