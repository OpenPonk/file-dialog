Class {
	#name : #FDBookmarksTest,
	#superclass : #FDTest,
	#instVars : [
		'existingBookmarks'
	],
	#category : #'FileDialog-Tests'
}

{ #category : #tests }
FDBookmarksTest >> setUp [
	super setUp.
	existingBookmarks := FDFileReferenceDialog customBookmarks copy.
	FDFileReferenceDialog customBookmarks: OrderedCollection new
]

{ #category : #tests }
FDBookmarksTest >> tearDown [
	super tearDown.
	FDFileReferenceDialog customBookmarks: existingBookmarks
]

{ #category : #tests }
FDBookmarksTest >> testAdd [
	self assert: FDFileReferenceDialog customBookmarks isEmpty.
	FDFileReferenceDialog addBookmark: FileLocator D asFileReference / 'prog'.
	self assert: FDFileReferenceDialog customBookmarks size equals: 1
]

{ #category : #tests }
FDBookmarksTest >> testAddTwiceSame [
	self assert: FDFileReferenceDialog customBookmarks isEmpty.
	FDFileReferenceDialog addBookmark: FileLocator D asFileReference / 'prog'.
	FDFileReferenceDialog addBookmark: FileLocator D asFileReference / 'prog'.
	self assert: FDFileReferenceDialog customBookmarks size equals: 1
]
