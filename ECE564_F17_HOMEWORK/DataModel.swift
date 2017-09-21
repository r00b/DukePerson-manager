//
//  DataModel.swift
//  ECE564_F17_HOMEWORK
//
//  Created by Ric Telford on 7/16/17.
//  Copyright © 2017 ece564. All rights reserved.
//

import UIKit
import os.log

enum Gender: String {
    case Male = "Male"
    case Female = "Female"
}

enum DukeRole : String {
    case Student = "Student"
    case Professor = "Professor"
    case TA = "Teaching Assistant"
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

class DukePerson: Person, BlueDevil, CustomStringConvertible {
    
    
    // MARK: instance variables
    
    var role: DukeRole = .Student
    
    var team: String = "N/A"
    
    var school: String = ""
    
    var degree: Degree = .NA
    
    var gpa: Double = -1.0
    
    var languages = [String]()
    
    var hobbies = [String]()
    
    var description: String {
        return "\(self.firstName) \(self.lastName) is a \(self.gender) from \(self.whereFrom) and is a \(self.role). \(getTeamDescription()) \(getSchoolDescription()) \(getDegreeDescription()) \(getLanguagesDescription()) \(getHobbiesDescription())"
    }
    
    // MARK: public functions
    
    func addLanguage(language: String) {
        if (self.languages.count < 3 && language != "") {
            self.languages.append(language)
        } else {
            os_log("Cannot add more than 3 languages", log: OSLog.default, type: .debug)
        }
    }
    
    func addLanguages(languages: [String]) {
        var newLanguages: [String] = languages
        while !newLanguages.isEmpty {
            if (self.languages.count < 3 && newLanguages[0] != "") {
                self.languages.append(newLanguages[0])
            } else {
                os_log("Cannot add more than 3 languages", log: OSLog.default, type: .debug)
            }
            newLanguages.remove(at: 0)
        }
    }
    
    func removeLanguage(languages: String) {
        self.languages = self.languages.filter() { $0 != languages }
    }
    
    func addHobby(hobby: String) {
        if (self.hobbies.count < 3 && hobby != "") {
            self.hobbies.append(hobby)
        } else {
            os_log("Cannot add more than 3 hobbies", log: OSLog.default, type: .debug)
        }
    }
    
    func addHobbies(hobbies: [String]) {
        var newHobbies: [String] = hobbies
        while !newHobbies.isEmpty {
            if (self.hobbies.count < 3 && newHobbies[0] != "") {
                self.hobbies.append(newHobbies[0])
            } else {
                os_log("Cannot add more than 3 hobbies", log: OSLog.default, type: .debug)
            }
            newHobbies.remove(at: 0)
        }
    }
    
    func removeHobby(hobby: String) {
        self.hobbies = self.hobbies.filter() { $0 != hobby }
    }
    
    
    // MARK: private functions
    
    private func getTeamDescription() -> String {
        if team != "" {
            return "\(self.firstName) is on the \(self.team) team."
        } else {
            return ""
        }
    }
    
    private func getSchoolDescription() -> String {
        if school != "" {
            return "\(self.firstName) graduated from \(self.school)"
        } else {
            return ""
        }
    }
    
    private func getDegreeDescription() -> String {
        if degree != .NA {
            return "with a \(self.degree)."
        } else {
            return ". "
        }
    }
    
    private func englishizeArray(array: [String]) -> String {
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
    
    private func getLanguagesDescription() -> String {
        let languageList: String = englishizeArray(array: Array(self.languages))
        if (languageList != "") {
            return "\(self.firstName) is proficient in" + languageList
        } else {
            return ""
        }
    }
    
    private func getHobbiesDescription() -> String {
        let hobbyList: String = englishizeArray(array: self.hobbies)
        if (englishizeArray(array: self.hobbies) != "") {
            return "When not in class, \(self.firstName) enjoys" + hobbyList
        } else {
            return ""
        }
    }
    
    
    // MARK: getters
    
    func getFirstName() -> String {
        return self.firstName
    }
    
    func getLastName() -> String {
        return self.lastName
    }
    
    func getFullName() -> String {
        return "\(self.firstName) \(self.lastName)"
    }
    
    func getWhereFrom() -> String {
        return self.whereFrom
    }
    
    func getGender() -> String {
        return self.gender.rawValue
    }
    
    func getRole() -> String {
        return self.role.rawValue
    }
    
    func getTeam() -> String {
        return self.team
    }
    
    func getSchool() -> String {
        return self.school
    }
    
    func getDegree() -> String {
        return self.degree.rawValue
    }
    
    func getGPA() -> Double {
        return self.gpa
    }
    
    func getDescription() -> String {
        return self.description
    }
    
    func getLanguage(index: Int) -> String {
        if languages.count >= index + 1 {
            return languages[index]
        } else {
            return ""
        }
    }
    
    func getHobby(index: Int) -> String {
        if hobbies.count >= index + 1 {
            return hobbies[index]
        } else {
            return ""
        }
    }
    
    
    // MARK: setters
    
    func setFirstName(firstName: String) {
        self.firstName = firstName
    }
    
    func setLastName(lastName: String) {
        self.lastName = lastName
    }
    
    func setWhereFrom(whereFrom: String) {
        self.whereFrom = whereFrom
    }
    
    func setGender(gender: String) {
        switch gender {
        case "Male":
            self.gender = .Male
        case "Female":
            self.gender = .Female
        default:
            fatalError("Unexpected gender: \(gender)")
        }
    }
    
    func setRole(role: String) {
        switch role {
        case "Student":
            self.role = .Student
        case "Teaching Assistant":
            self.role = .TA
        case "TA":
            self.role = .TA
        case "Professor":
            self.role = .Professor
        default:
            fatalError("Unexpected role: \(role)")
        }
    }
    
    func setTeam(team: String) {
        self.team = team
    }
    
    func setSchool(school: String) {
        self.school = school
    }
    
    func setDegree(degree: String) {
        switch degree {
        case "MS":
            self.degree = .MS
        case "BS":
            self.degree = .BS
        case "MENG":
            self.degree = .MENG
        case "Ph.D":
            self.degree = .Phd
        case "NA":
            self.degree = .NA
        case "Other":
            self.degree = .Other
        default:
            self.degree = .NA
        }
    }
    
    func setGPA(gpa: Double) {
        self.gpa = gpa
    }
}
