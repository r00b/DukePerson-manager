import UIKit

/*:
 ### ECE 564 HW1 assignment
 In this first assignment, you are going to create a base data model for the Students, TAs and Professors in this class, and then be able to search an array of those objects by writing a `whoIs` function.
 I suggest you create a new class called `DukePerson` and have it subclass `Person`.  You also need to abide by 2 protocols:
 1. BlueDevil
 2. CustomStringConvertible
 
 I also suggest you try to follow good OO practices by containing any properties and methods that deal with `DukePerson` within the class definition.
 */
/*:
 In addition to the properties required by `Person`, `CustomStringConvertible` and `BlueDevil`, you need to have include the following information about each person:
 * Their degree, if applicable
 * Up to 3 of their best programming languages as an array of `String` (like `hobbies` that is in the protocol)
 */
/*:
 I suggest you create an array of `DukePerson` objects, and you must have at least 3 entries in your array for me to test:
 1. Yourself
 2. Me (my info is in the slide deck)
 3. One of the TAs (also in slide deck)
 */
/*:
 Your program must contain the following:
 - You must include 4 of the following - array, dictionary, set, class, function, closure expression, enum, struct
 - You must include 4 different types, such as string, character, int, double, bool, float
 - You must include 4 different control flows, such as for/in, while, repeat/while, if/else, switch/case
 - You must include 4 different operators from any of the various categories of assignment, arithmatic, comparison, nil coalescing, range, logical
 */
/*:
 Below is an example of what the string output from `whoIs' should look like:
 
 Ric Telford is from Morrisville, NC and is a Professor. He is proficient in Swift, C and C++. When not in class, Ric enjoys Biking, Hiking and Golf.
 */

enum Gender {
    case Male
    case Female
}

class Person {
    var firstName = "First"
    var lastName = "Last"
    var whereFrom = "Anywhere"  // this is just a free String - can be city, state, both, etc.
    var gender : Gender = .Male
}

enum DukeRole : String {
    case Student = "Student"
    case Professor = "Professor"
    case TA = "Teaching Assistant"
}

protocol BlueDevil {
    var hobbies : [String] { get }
    var role : DukeRole { get }
}
//: ### START OF HOMEWORK 
//: Do not change anything above.
//: Put your code here


//: ### END OF HOMEWORK
//: Uncomment the line below to test your homework.
//: The "whoIs" function should be defined as `func whoIs(_ name: String) -> String {   }`

// print(whoIs("Ric Telford"))

