# README: Robert Steilberg (rhs16)

## HW 1

In addition to the project requirements, I also added the following improvements:

* added a function for bulk-adding languages
* added a function for removing a language
* added a function for bulk-adding hobbies
* added a function for removing a hobby
* added a new search query, findByDegree(), for finding a DukePerson according to their degree
* added a new search query, findHighestGPA(), for finding the DukePerson with the highest GPA out of an array of DukePersons
* added getters and setters for accessing class fields outside of the class
* error checking for not finding a DukePerson
* handles finding multiple DukePersons

## HW 2

In addition to the project requirements, I also added the following improvements:

* enhanced error checking (wrong enums entered, empty text fields, record collisions, existence of records when updating/deleting, etc.)
* constraints, rather than using magic values to place UI elements
* elegant layout and intuitive UI with color
* update button for updating existing records
* delete button for deleting existing records
* get by degree button for finding all records that share a particular degree type
* get highest GPA button for finding the record with the highest GPA
* elimination of reused and verbose code

## HW 3

I used the following videos/tutorials to help me understand how the storyboard, segues, custom TableView cells, and TableView sections work:

* https://apoorv.blog/uitableview-multiple-sections-ios-swift/
* https://developer.apple.com/library/content/referencelibrary/GettingStarted/DevelopiOSAppsSwift/BuildABasicUI.html#//apple_ref/doc/uid/TP40015214-CH5-SW1
* https://developer.apple.com/library/content/referencelibrary/GettingStarted/DevelopiOSAppsSwift/CreateATableView.html#//apple_ref/doc/uid/TP40015214-CH8-SW1
* https://apoorv.blog/pickerview-as-input-textfield-swift/

IMPORTANT NOTES:

* The project should be graded using a physical mobile device. Using a laptop keyboard to input into fields can bypass several UI elements that prevent incorrect input (i.e. only being able to use a UIPickerView to pick Gender). Running the application on the laptop and using the laptop's keyboard can cause unintended side effects.

* I made the DukePerson description a scrollable TextView. You can scroll on the description in the TableView to see the entire description. Tap elsewhere (on the profile image or the name label) to see details for each DukePerson.

* Towards the end of the project, my computer automatically updated to Xcode 9 overnight without my telling it to do so. I prevented it from converting my project to Swift 4 and making other updates, but if you have an issue compiling for whatever reason, it may be because of this upgrade. Please email me at rhs16@duke.edu if necessary.

In addition to the project requirements, I also added the following improvements:

* added a field for adding Team
* UIPickerViews for configuring properties that are enums (i.e. gender, role)
* Separate text boxes for languages and hobbies to prevent user error when adding languages or hobbies
* ability to delete DukePerson entries via the TableView

Known bugs:

* When trying to edit a TextField near the bottom of the screen, the keyboard will cover it. I tried to fix this but it caused more harm than good.


## HW 4

I resolved the issue with the keyboard covering the text fields in this HW.

To see an animation, go to "Robert Steilberg" from the TableView. Notice that one of his hobbies is SCUBA diving. Swipe right to see that animation. Swipe left to get back to the detail page. Notice that no other DukePersons have an aniation view.

In addition to the project requirements, I also added the following improvements:

* detail and animation views are handled via a PageController
* animations and drawings are createive (in my opinion) and a bit complex

## HW 5

To set a DukePerson's image, simply navigate to that DukePerson's detail page, and then tap their profile picture. You will be prompted to take an image and that image will be saved to memory. When creating a new DukePerson, tap on the profile picture to take and choose an image.

I used the following source to get data persistance and image support working:

* https://developer.apple.com/library/content/referencelibrary/GettingStarted/DevelopiOSAppsSwift/PersistData.html#//apple_ref/doc/uid/TP40015214-CH14-SW1
* https://newfivefour.com/swift-ios-choose-an-image-UIImagePickerController.html
* https://developer.apple.com/library/content/samplecode/PhotoPicker/Introduction/Intro.html

In addition to the project requirements, I also added the following improvements:

* images persist with other data
* additional information about DukePersons can be stored (GPA, job experience, years of experience)
