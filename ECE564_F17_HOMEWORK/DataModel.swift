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

class Person: NSObject {
    var firstName = "First"
    var lastName = "Last"
    var whereFrom = "Anywhere"  // this is just a free String - can be city, state, both, etc.
    var gender : Gender = .Male
}

protocol BlueDevil {
    var hobbies : [String] { get }
    var role : DukeRole { get }
}

class DukePerson: Person, BlueDevil, NSCoding {
    
    init(firstName: String, lastName: String, gender: String, whereFrom: String, school: String, role: String) {
        super.init()
        self.firstName = firstName
        self.lastName = lastName
        self.setGender(gender: gender)
        self.whereFrom = whereFrom
        self.school = school
        self.setRole(role: role)
    }
    
    
    // MARK: properties

    var profilePicture: UIImage?
    
    var role: DukeRole = .Student
    
    var team: String = ""
    
    var school: String = ""
    
    var degree: Degree = .NA
    
    var gpa: Double?
    
    var employer: String = ""
    
    var yearsExperience: Int?
    
    var languages = [String]()
    
    var hobbies = [String]()
    
    var animationController: UIViewController?
    
    override var description: String {
        return "\(self.firstName) \(self.lastName) is a \(self.gender) from \(self.whereFrom) and is a \(self.role). \(getTeamDescription()) \(getSchoolDescription()) \(getDegreeDescription()) \(getWorkExperienceDescription()) \(getLanguagesDescription()) \(getHobbiesDescription())"
    }
    
    // MARK: public functions
    
    func addLanguage(language: String) {
        if (self.languages.count < 3 && language != "") {
            self.languages.append(language)
        } else {
//            os_log("Cannot add more than 3 languages", log: OSLog.default, type: .debug)
        }
    }
    
    func addLanguages(languages: [String]) {
        var newLanguages: [String] = languages
        while !newLanguages.isEmpty {
            if (self.languages.count < 3 && newLanguages[0] != "") {
                self.languages.append(newLanguages[0])
            } else {
//                os_log("Cannot add more than 3 languages", log: OSLog.default, type: .debug)
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
//            os_log("Cannot add more than 3 hobbies", log: OSLog.default, type: .debug)
        }
    }
    
    func addHobbies(hobbies: [String]) {
        var newHobbies: [String] = hobbies
        while !newHobbies.isEmpty {
            if (self.hobbies.count < 3 && newHobbies[0] != "") {
                self.hobbies.append(newHobbies[0])
            } else {
//                os_log("Cannot add more than 3 hobbies", log: OSLog.default, type: .debug)
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
            return "."
        }
    }
    
    private func getWorkExperienceDescription() -> String {
        guard let years = self.yearsExperience else {
            if self.employer != "" {
                return "\(self.firstName) currently works at \(self.employer)."
            } else {
                return ""
            }
        }
        if self.employer != "" {
            return "\(self.firstName) currently works at \(self.employer) and has \(years) years of work experience."
        } else {
            return "\(self.firstName) has \(years) years of work experience."
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
    
    func getProfilePicture() -> UIImage? {
        return self.profilePicture
    }
    
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
    
    func getGPA() -> Double? {
        return self.gpa
    }
    
    func getEmployer() -> String {
        return self.employer
    }
    
    func getYearsExperience() -> Int? {
        return self.yearsExperience
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
    
    func getAnimationController() -> UIViewController? {
//        guard let animationController = self.animationController else {
//            return nil
//        }
        return animationController
    }
    
    
    // MARK: setters
    
    func setProfilePicture(picture: UIImage?) {
        self.profilePicture = picture
    }
    
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
    
    func setGPA(gpa: Double?) {
        self.gpa = gpa
    }
    
    func setEmployer(employer: String) {
        self.employer = employer
    }
    
    func setYearsExperience(years: Int?) {
        self.yearsExperience = years
    }
    
    func setAnimationController(controller: UIViewController?) {
        self.animationController = controller
    }
    
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let DukePersonArchiveURL = DocumentsDirectory.appendingPathComponent("DukePersons")
    static let SectionsArchiveURL = DocumentsDirectory.appendingPathComponent("Sections")

    //MARK: Types
    
    struct PropertyKey {
        static let profilePicture = "profilePicture"
        static let firstName = "firstName"
        static let lastName = "lastName"
        static let gender = "gender"
        static let whereFrom = "whereFrom"
        static let school = "school"
        static let degree = "degree"
        static let gpa = "gpa"
        static let role = "role"
        static let team = "team"
        static let employer = "employer"
        static let yearsExperience = "yearsExperience"
        static let languages = "languages"
        static let hobbies = "hobbies"
        static let animation = "animation"
    }
    
    // MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.profilePicture, forKey: PropertyKey.profilePicture)
        aCoder.encode(self.firstName, forKey: PropertyKey.firstName)
        aCoder.encode(self.lastName, forKey: PropertyKey.lastName)
        aCoder.encode(self.getGender(), forKey: PropertyKey.gender)
        aCoder.encode(self.whereFrom, forKey: PropertyKey.whereFrom)
        aCoder.encode(self.school, forKey: PropertyKey.school)
        aCoder.encode(self.getDegree(), forKey: PropertyKey.degree)
        aCoder.encode(self.getGPA(), forKey: PropertyKey.gpa)
        aCoder.encode(self.getRole(), forKey: PropertyKey.role)
        aCoder.encode(self.team, forKey: PropertyKey.team)
        aCoder.encode(self.employer, forKey: PropertyKey.employer)
        aCoder.encode(self.yearsExperience, forKey: PropertyKey.yearsExperience)
        aCoder.encode(self.languages, forKey: PropertyKey.languages)
        aCoder.encode(self.hobbies, forKey: PropertyKey.hobbies)
        aCoder.encode(self.animationController, forKey: PropertyKey.animation)

    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let profilePicture = aDecoder.decodeObject(forKey: PropertyKey.profilePicture) as? UIImage
        guard let firstName = aDecoder.decodeObject(forKey: PropertyKey.firstName) as? String else {
            os_log("Unable to decode firstName", log: OSLog.default, type: .debug)
            return nil
        }
        guard let lastName = aDecoder.decodeObject(forKey: PropertyKey.lastName) as? String else {
            os_log("Unable to decode lastName", log: OSLog.default, type: .debug)
            return nil
        }
        guard let gender = aDecoder.decodeObject(forKey: PropertyKey.gender) as? String else {
            os_log("Unable to decode gender", log: OSLog.default, type: .debug)
            return nil
        }
        guard let whereFrom = aDecoder.decodeObject(forKey: PropertyKey.whereFrom) as? String else {
            os_log("Unable to decode whereFrom", log: OSLog.default, type: .debug)
            return nil
        }
        guard let school = aDecoder.decodeObject(forKey: PropertyKey.school) as? String else {
            os_log("Unable to decode school", log: OSLog.default, type: .debug)
            return nil
        }
        guard let degree = aDecoder.decodeObject(forKey: PropertyKey.degree) as? String else {
            os_log("Unable to decode degree", log: OSLog.default, type: .debug)
            return nil
        }
        guard let gpa = aDecoder.decodeObject(forKey: PropertyKey.gpa) as? Double? else {
            os_log("Unable to decode GPA", log: OSLog.default, type: .debug)
            return nil
        }
        guard let role = aDecoder.decodeObject(forKey: PropertyKey.role) as? String else {
            os_log("Unable to decode role", log: OSLog.default, type: .debug)
            return nil
        }
        guard let team = aDecoder.decodeObject(forKey: PropertyKey.team) as? String else {
            os_log("Unable to decode team", log: OSLog.default, type: .debug)
            return nil
        }
        guard let employer = aDecoder.decodeObject(forKey: PropertyKey.employer) as? String else {
            os_log("Unable to decode employer", log: OSLog.default, type: .debug)
            return nil
        }
        guard let yearsExperience = aDecoder.decodeObject(forKey: PropertyKey.yearsExperience) as? Int? else {
            os_log("Unable to decode yearsExperience", log: OSLog.default, type: .debug)
            return nil
        }
        guard let languages = aDecoder.decodeObject(forKey: PropertyKey.languages) as? [String] else {
            os_log("Unable to decode languages", log: OSLog.default, type: .debug)
            return nil
        }
        guard let hobbies = aDecoder.decodeObject(forKey: PropertyKey.hobbies) as? [String] else {
            os_log("Unable to decode hobbies", log: OSLog.default, type: .debug)
            return nil
        }
        guard let animationController = aDecoder.decodeObject(forKey: PropertyKey.animation) as? UIViewController? else {
            os_log("Unable to decode animation controller", log: OSLog.default, type: .debug)
            return nil
        }
        if animationController != nil {
            animationController!.viewDidLoad()
        }
        
        self.init(firstName: firstName, lastName: lastName, gender: gender, whereFrom: whereFrom, school: school, role: role)
        self.setProfilePicture(picture: profilePicture)
        self.setDegree(degree: degree)
        self.setGPA(gpa: gpa)
        self.setTeam(team: team)
        self.setEmployer(employer: employer)
        self.setYearsExperience(years: yearsExperience)
        self.languages = languages
        self.hobbies = hobbies
        self.setAnimationController(controller: animationController)
        // Because photo is an optional property of Meal, just use conditional cast.
        
        
    }
    
}
