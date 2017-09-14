//
//  DataModel.swift
//  ECE564_F17_HOMEWORK
//
//  Created by Ric Telford on 7/16/17.
//  Copyright © 2017 ece564. All rights reserved.
//

import UIKit

enum Gender: String {
    case Male = "Male"
    case Female = "Female"
}

enum DukeRole : String {
    case Student = "Student"
    case Professor = "Professor"
    case TA = "Teaching Assistant"
    
    var description: String {
        return self.rawValue
    }
}

enum Degree : String {
    case MS = "MS"
    case BS = "BS"
    case MENG = "MENG"
    case Phd = "Ph.D"
    case NA = "N/A"
    case Other = "Other"
}

class Person {
    var firstName = "First"
    var lastName = "Last"
    var whereFrom = "Anywhere"  // this is just a free String - can be city, state, both, etc.
    var gender : Gender = .Male
}

protocol BlueDevil {
    var hobbies : [String] { get }
    var role : DukeRole { get }
}

class DukePersonAttribute {
    
    var label: String?
    
    var placeholder: String?
    
    var labelView = UILabel()
    
    var fieldView = UITextField()
    
    init(label: String, placeholder: String, textFieldDelegate: UITextFieldDelegate) {
        self.label = label
        self.placeholder = placeholder
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            return false
        }
        
        self.labelView.text = self.label
        self.labelView.translatesAutoresizingMaskIntoConstraints = false
        
        self.fieldView.delegate = textFieldDelegate
        self.fieldView.placeholder = self.placeholder
        self.fieldView.font = UIFont.systemFont(ofSize: 14)
        self.fieldView.borderStyle = UITextBorderStyle.roundedRect
        self.fieldView.layer.cornerRadius = 3.0
        self.fieldView.layer.borderColor = UIColor( red: 118/255, green: 162/255, blue:246/255, alpha: 2.0 ).cgColor
        self.fieldView.layer.borderWidth = 1
        self.fieldView.autocorrectionType = UITextAutocorrectionType.no
        if self.label == "GPA:" {
            self.fieldView.keyboardType = UIKeyboardType.decimalPad
        } else {
            self.fieldView.keyboardType = UIKeyboardType.default
        }
        self.fieldView.returnKeyType = UIReturnKeyType.done
        self.fieldView.clearButtonMode = UITextFieldViewMode.whileEditing
        self.fieldView.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        self.fieldView.translatesAutoresizingMaskIntoConstraints = false
    }
}

class DukePerson: Person, BlueDevil, CustomStringConvertible {
    
    func setFirstName(firstName: String) {
        self.firstName = firstName
    }
    
    func getFirstName() -> String {
        return self.firstName
    }
    
    func setLastName(lastName: String) {
        self.lastName = lastName
    }
    
    func getLastName() -> String {
        return self.lastName
    }
    
    func setWhereFrom(whereFrom: String) {
        self.whereFrom = whereFrom
    }
    
    func setGender(gender: Gender) {
        self.gender = gender
    }
    
    var role: DukeRole = .Student
    
    func setRole(role: DukeRole) {
        self.role = role
    }
    
    var school: String = ""
    
    func setSchool(school: String) {
        self.school = school
    }
    
    var degree: Degree = .NA
    
    func setDegree(degree: Degree) {
        self.degree = degree
    }
    
    func getDegree() -> Degree {
        return self.degree
    }
    
    var gpa: Double = -1.0
    
    func setGPA(gpa: Double) {
        self.gpa = gpa
    }
    
    func getGPA() -> Double {
        return self.gpa
    }
    
    func getSchoolDegree() -> String {
        if gpa != -1.0 {
            return "\(self.firstName) graduated with a \(self.degree) from \(self.school) and a GPA of \(self.gpa). "
        } else {
            return "\(self.firstName) graduated with a \(self.degree) from \(self.school)."
        }
    }
    
    func englishizeArray(array: [String]) -> String {
        var result: String = ""
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
        var newLanguages: [String] = languages
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
        let languageList: String = englishizeArray(array: Array(self.languages))
        if (languageList != "") {
            return "\(self.firstName) is proficient in" + languageList
        } else {
            return ""
        }
    }
    
    func removeLanguage(languages: String) {
        self.languages = Set(self.languages.filter() { $0 != languages })
    }
    
    var hobbies = [String]() // cannot be a Set because would violate protocol
    
    func addHobby(hobby: String) {
        self.hobbies.append(hobby)
    }
    
    func addHobbies(hobbies: [String]) {
        var newHobbies: [String] = hobbies
        while !newHobbies.isEmpty {
            if (self.hobbies.count < 3) {
                self.hobbies.append(newHobbies[0])
            } else {
                print("You cannot add more than 3 hobbies. Remove a language using removeLanguage().")
            }
            newHobbies.remove(at: 0)
        }
    }
    
    func getHobbies() -> String {
        let hobbyList: String = englishizeArray(array: self.hobbies)
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
    
    func getDescription() -> String {
        return self.description
    }
}
