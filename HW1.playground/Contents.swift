import UIKit

/*:
 ### ECE 564 HW1 assignment
 In this first assignment, you are going to create a base data model for storing information about the students, TAs and professors in ECE 564. You need to populate your data model with at least 3 records, but can add more.  You will also provide a search function ("whoIs") to search an array of those objects by first name and last name.
 I suggest you create a new class called `DukePerson` and have it subclass `Person`.  You also need to abide by 2 protocols:
 1. BlueDevil
 2. CustomStringConvertible
 
 I also suggest you try to follow good OO practices by containing any properties and methods that deal with `DukePerson` within the class definition.
 */
/*:
 In addition to the properties required by `Person`, `CustomStringConvertible` and `BlueDevil`, you need to include the following information about each person:
 * Their degree, if applicable
 * Up to 3 of their best programming languages as an array of `String`s (like `hobbies` that is in `BlueDevil`)
 */
/*:
 I suggest you create an array of `DukePerson` objects, and you **must** have at least 3 entries in your array for me to test:
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
 Base grade is a 45 but more points can be earned by adding additional functions besides whoIs (like additional search), extensive error checking, concise code, excellent OO practices, and/or excellent, unique algorithms
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
//: Put your code here:


class DukePerson: Person, BlueDevil, CustomStringConvertible {
    
    var role: DukeRole = .Student
    
    var school: String = ""
    
    var degree: String = ""
    
    var gpa: Double = -1.0
    
    func getSchoolDegree() -> String {
        var res: String = ""
        if (self.school != "") {
            res += "\(self.firstName) graduated from \(self.school). "
        }
        if (self.degree != "") {
            res += "\(self.firstName)'s degree is in \(self.degree). "
        }
        if (self.gpa != -1.0) {
            res += "\(self.firstName) had a GPA of \(self.gpa). "
        }
        return res
    }
    
    func englishizeArray(array: [String]) -> String {
        var result = ""
        switch array.count {
        case 0:
            return ""
        case 1:
            return result + " \(array[0])."
        default:
            for element in array.dropLast() {
                result += " \(element),"
            }
            result += " and \(array[array.endIndex - 1])."
            return result
        }
    }
    
    var languages = Set<String>() // set so that no duplicate languages
    
    func addLanguage(language: String) {
        if (self.languages.count < 3) {
            self.languages.insert(language)
        } else {
            print("You cannot add more than 3 languages. Remove a language using removeLanguage().")
        }
    }
    
    func addLanguages(languages: [String]) {
        var newLanguages = languages
        while !newLanguages.isEmpty {
            if (self.languages.count < 3) {
                self.languages.insert(newLanguages[0])
            } else {
                print("You cannot add more than 3 languages. Remove a language using removeLanguage().")
            }
            newLanguages.remove(at: 0)
        }
    }
    
    func getLanguages() -> String {
        let languageList = englishizeArray(array: Array(self.languages))
        if (languageList != "") {
            return "\(self.firstName) is proficient in " + languageList
        } else {
            return ""
        }
    }
    
    func removeLanguage(languages: String) {
        self.languages = Set(self.languages.filter() { $0 != languages })
    }
    
    var hobbies = [String]() // cannot be set because would violate protocol
    
    func addHobby(hobby: String) {
        self.hobbies.append(hobby)
    }
    
    func addHobbies(hobbies: [String]) {
        var newHobbies = hobbies
        for num in 0...newHobbies.count - 1 {
            self.hobbies.append(newHobbies[num])
        }
    }
    
    func getHobbies() -> String {
        let hobbyList = englishizeArray(array: self.hobbies)
        if (englishizeArray(array: self.hobbies) != "") {
            return "When not in class, \(self.firstName) enjoys" + hobbyList
        } else {
            return ""
        }
    }
    
    func removeHobby(hobby: String) {
        self.hobbies = self.hobbies.filter() { $0 != hobby }
    }
    
    var description: String {
        return "\(self.firstName) \(self.lastName) is from \(self.whereFrom) and is a \(self.role). \(getSchoolDegree()) \(getLanguages()) \(getHobbies())"
    }
}



var dukePeople = [DukePerson]()

let robert = DukePerson()
robert.firstName = "Robert"
robert.lastName = "Steilberg"
robert.whereFrom = "Richmond, VA"
robert.gender = .Male
robert.role = .Student
robert.school = "Duke University"
robert.degree = "Computer Science"
robert.gpa = 3.8
robert.addLanguage(language: "Python")
robert.addLanguage(language: "JavaScript")
robert.addLanguage(language: "Ruby")
robert.addHobby(hobby: "Super Smash Bros.")
robert.addHobby(hobby: "skiing")
robert.addHobby(hobby: "SCUBA diving")

dukePeople.append(robert)

let ric = DukePerson()
ric.firstName = "Ric"
ric.lastName = "Telford"
ric.whereFrom = "Morrisville, NC"
ric.gender = .Male
ric.role = .Professor
ric.school = "Trinity University"
ric.degree = "Computer Science"
ric.gpa = 3.9 // for testing find highest GPA
ric.addLanguages(languages: ["Swift", "C", "C++"])
ric.addHobbies(hobbies: ["golf", "swimming", "biking"])

dukePeople.append(ric)

let gilbert = DukePerson()
gilbert.firstName = "Gilbert"
gilbert.lastName = "Brooks"
gilbert.whereFrom = "Shelby, NC"
gilbert.gender = .Male
gilbert.role = .TA
gilbert.school = "Duke University"
gilbert.degree = "Computer Science and African-American Studies"
gilbert.addLanguages(languages: ["Swift", "Java"])

dukePeople.append(gilbert)

let niral = DukePerson()
niral.firstName = "Niral"
niral.lastName = "Shah"
niral.whereFrom = "central New Jersey"
niral.gender = .Male
niral.role = .TA
niral.school = "Rutgers University"
niral.degree = "ECE and Computer Science"
niral.addLanguages(languages: ["Swift", "Python", "Java"])
//niral.addLanguage(language: "C")  // uncomment to see error checking for >3 languages
niral.addHobbies(hobbies: ["computer vision", "tennis", "travelling"])

dukePeople.append(niral)

func whoIs(_ name: String) -> String {
    let nameArr = name.characters.split{$0 == " "}.map(String.init)
    var res : String = ""
    var found: Bool = false
    for person in dukePeople {
        if (person.firstName == nameArr[0] && person.lastName == nameArr[1]) {
            found = true
            res += person.description + "\n"
        }
    }
    if found {
        return res
    } else {
        return "No DukePerson named \(name) was found!"
    }
}

func findByDegree(_ degree: String) -> String {
    var res: String = ""
    var found: Bool = false;
    for person in dukePeople {
        if (person.degree == degree) {
            found = true
            res += person.description + "\n"
        }
    }
    if found {
        return res
    } else {
        return "No DukePerson with a \(degree) degree was found!"
    }
}

func findHighestGPA() -> String {
    var res: String = ""
    var highestGPA: Double = 0.0
    for person in dukePeople {
        if (person.gpa > highestGPA) {
            highestGPA = person.gpa
            res = person.description
        }
    }
    return res
}

print("========================== whoIs test ==========================")

print(whoIs("Robert Steilberg"))
print(whoIs("Ric Telford"))
print(whoIs("Donald Trump"))

print("================================================================")

print("====================== findByDegree test =======================")

print(findByDegree("Computer Science"))
print(findByDegree("Underwater Basketweaving"))

print("================================================================")

print("===================== findHighestGPA test ======================")

print(findHighestGPA())

print("================================================================")

//: ### END OF HOMEWORK
//: Uncomment the line below to test your homework.
//: The "whoIs" function should be defined as `func whoIs(_ name: String) -> String {   }`

// print(whoIs("Ric Telford"))


