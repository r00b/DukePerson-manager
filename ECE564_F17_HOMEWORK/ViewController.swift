//
//  ViewController.swift
//  ECE564_F17_HOMEWORK
//
//  Created by Ric Telford on 7/16/17.
//  Copyright © 2017 ece564. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate{
    
    var attributes: [String:DukePersonAttribute] = [String:DukePersonAttribute]()
    
    let attributeOrder = ["firstName", "lastName", "gender", "role", "from", "school", "degree", "gpa", "languages", "hobbies"]
    
    var dukePeople: [DukePerson] = [DukePerson]()
    
    override func loadView() {
        self.view = UIView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addInitialData()
        
        self.attributes = [
            "firstName" : DukePersonAttribute(label: "First:",placeholder: "first name", textFieldDelegate: self),
            "lastName" : DukePersonAttribute(label: "Last:",placeholder: "last name", textFieldDelegate: self),
            "gender" : DukePersonAttribute(label: "Gender:",placeholder: "Male/Female", textFieldDelegate: self),
            "role" : DukePersonAttribute(label: "Role:",placeholder: "Student/TA/Professor", textFieldDelegate: self),
            "from" : DukePersonAttribute(label: "From:",placeholder: "city, state", textFieldDelegate: self),
            "school" : DukePersonAttribute(label: "School:",placeholder: "school name", textFieldDelegate: self),
            "degree" : DukePersonAttribute(label: "Degree:",placeholder: "MS/BS/MENG/PhD/NA/Other", textFieldDelegate: self),
            "gpa" : DukePersonAttribute(label: "GPA:",placeholder: "decimal", textFieldDelegate: self),
            "languages" : DukePersonAttribute(label: "Languages:",placeholder: "up to 3, comma delimited", textFieldDelegate: self),
            "hobbies" : DukePersonAttribute(label: "Hobbies:",placeholder: "up to 3, comma delimited", textFieldDelegate: self)]
        
        // close keyboard when tap out of text field
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        
        addLabels(initLabelView: addTitle())
        addFields()
        addButtons()
    }
    
    func addInitialData() {
        let robert = DukePerson()
        robert.setFirstName(firstName: "Robert")
        robert.setLastName(lastName: "Steilberg")
        robert.setWhereFrom(whereFrom: "Richmond, VA")
        robert.setGender(gender: .Male)
        robert.setRole(role: .Student)
        robert.setSchool(school: "Duke University")
        robert.setDegree(degree: .BS)
        robert.setGPA(gpa: 3.8)
        robert.addLanguage(language: "Python")
        robert.addLanguage(language: "JavaScript")
        robert.addLanguage(language: "Ruby")
        robert.addHobby(hobby: "Super Smash Bros.")
        robert.addHobby(hobby: "skiing")
        robert.addHobby(hobby: "SCUBA diving")
        
        self.dukePeople.append(robert)
        
        let ric = DukePerson()
        ric.setFirstName(firstName: "Ric")
        ric.setLastName(lastName: "Telford")
        ric.setWhereFrom(whereFrom: "Morrisville, NC")
        ric.setGender(gender: .Male)
        ric.setRole(role: .Professor)
        ric.setSchool(school: "Trinity University")
        ric.setDegree(degree: .MENG)
        ric.setGPA(gpa: 3.9) // for testing findHighestGPA()
        ric.addLanguages(languages: ["Swift", "C", "C++"])
        ric.addHobbies(hobbies: ["golf", "swimming", "biking"])
        
        self.dukePeople.append(ric)
        
        let gilbert = DukePerson()
        gilbert.setFirstName(firstName: "Gilbert")
        gilbert.setLastName(lastName: "Brooks")
        gilbert.setWhereFrom(whereFrom: "Shelby, NC")
        gilbert.setGender(gender: .Male)
        gilbert.setRole(role: .TA)
        gilbert.setSchool(school: "Duke University")
        gilbert.setDegree(degree: .BS)
        gilbert.addLanguages(languages: ["Swift", "Java"])
        gilbert.addHobbies(hobbies: ["user experience", "product development"])
        
        self.dukePeople.append(gilbert)
        
        let niral = DukePerson()
        niral.setFirstName(firstName: "Niral")
        niral.setLastName(lastName: "Shah")
        niral.setWhereFrom(whereFrom: "central New Jersey")
        niral.setGender(gender: .Male)
        niral.setRole(role: .TA)
        niral.setSchool(school: "Rutgers University")
        niral.setDegree(degree: .BS)
        niral.addLanguages(languages: ["Swift", "Python", "Java"])
        niral.addHobbies(hobbies: ["computer vision", "tennis", "travelling"])
        
        dukePeople.append(niral)
    }

    func addTitle() -> UILabel {
        let appTitle: UILabel = UILabel()
        self.view.addSubview(appTitle)
        appTitle.text = "DukePerson Record Keeper"
        appTitle.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraint(
            NSLayoutConstraint(item: appTitle,
                               attribute: .centerX,
                               relatedBy: .equal,
                               toItem: self.view,
                               attribute: .centerX,
                               multiplier: 1, constant: 0))
        self.view.addConstraint(
            NSLayoutConstraint(item: appTitle,
                               attribute: .centerY,
                               relatedBy: .equal,
                               toItem: self.view,
                               attribute: .top,
                               multiplier: 1, constant: 35))
        // return the label so that subsequent constraints can be created on it
        return appTitle
    }
    
    func addLabels(initLabelView: UILabel) {
        var prevLabelView: UILabel = initLabelView
        // create each label relative to the previous one
        for attribute in attributeOrder {
            let labelView = attributes[attribute]?.labelView
            self.view.addSubview(labelView!)
            self.view.addConstraint(
                NSLayoutConstraint(item: labelView!,
                                   attribute: .left,
                                   relatedBy: .equal,
                                   toItem: self.view,
                                   attribute: .left,
                                   multiplier: 1, constant: 10))
            self.view.addConstraint(
                NSLayoutConstraint(item: labelView!,
                                   attribute: .top,
                                   relatedBy: .equal,
                                   toItem: prevLabelView,
                                   attribute: .bottom,
                                   multiplier: 1, constant: 15))
            prevLabelView = labelView!
        }
    }
    
    func addFields() {
        // create each field relative to the previous one
        for attribute in attributeOrder {
            let fieldView = attributes[attribute]?.fieldView
            self.view.addSubview(fieldView!)
            self.view.addConstraint(
                NSLayoutConstraint(item: fieldView!,
                                   attribute: .left,
                                   relatedBy: .equal,
                                   toItem: self.view,
                                   attribute: .left,
                                   multiplier: 1, constant: 110))
            self.view.addConstraint(
                NSLayoutConstraint(item: fieldView!,
                                   attribute: .right,
                                   relatedBy: .equal,
                                   toItem: self.view,
                                   attribute: .right,
                                   multiplier: 1, constant: -10))
            self.view.addConstraint(
                NSLayoutConstraint(item: fieldView!,
                                   attribute: .centerY,
                                   relatedBy: .equal,
                                   toItem: attributes[attribute]?.labelView,
                                   attribute: .centerY,
                                   multiplier: 1, constant: 0))
        }
    }
    
    func addButtons() {
        let addButton: UIButton = UIButton()
        let getButton: UIButton = UIButton()
        addButtonRow(button1: addButton, button2: getButton, button1Title: "Add", button2Title: "Get", button1Selector: #selector(addDukePerson), button2Selector: #selector(getDukePerson), yRef: (attributes["hobbies"]?.labelView)!)
        
        let updateButton: UIButton = UIButton()
        let deleteButton: UIButton = UIButton()
        addButtonRow(button1: updateButton, button2: deleteButton, button1Title: "Update", button2Title: "Delete", button1Selector: #selector(updateDukePerson), button2Selector: #selector(deleteDukePerson), yRef: addButton)
        
        let degreeButton: UIButton = UIButton()
        let gpaButton: UIButton = UIButton()
        addButtonRow(button1: degreeButton, button2: gpaButton, button1Title: "Get by Degree", button2Title: "Highest GPA", button1Selector: #selector(getByDegree(sender:)), button2Selector: #selector(getHighestGPA), yRef: updateButton)
    }
    
    func addButtonRow(button1: UIButton, button2: UIButton, button1Title: String, button2Title: String, button1Selector: Selector, button2Selector: Selector, yRef: UIView) {
        
        button1.setTitle(button1Title, for: .normal)
        button1.backgroundColor = UIColor( red: 118/255, green: 162/255, blue:246/255, alpha: 2.0 )
        button1.layer.cornerRadius = 3
        button1.setTitleColor(UIColor.white, for: .normal)
        button1.addTarget(self, action: button1Selector, for: .touchUpInside)
        self.view.addSubview(button1)
        button1.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraint(
            NSLayoutConstraint(item: button1,
                               attribute: .left,
                               relatedBy: .equal,
                               toItem: self.view,
                               attribute: .left,
                               multiplier: 1, constant: 10))
        self.view.addConstraint(
            NSLayoutConstraint(item: button1,
                               attribute: .right,
                               relatedBy: .equal,
                               toItem: self.view,
                               attribute: .centerX,
                               multiplier: 1, constant: -10))
        self.view.addConstraint(
            NSLayoutConstraint(item: button1,
                               attribute: .top,
                               relatedBy: .equal,
                               toItem: yRef,
                               attribute: .top,
                               multiplier: 1, constant: 40))
        
        button2.setTitle(button2Title, for: .normal)
        button2.backgroundColor = UIColor( red: 118/255, green: 162/255, blue:246/255, alpha: 2.0 )
        button2.layer.cornerRadius = 3
        button2.setTitleColor(UIColor.white, for: .normal)
        button2.addTarget(self, action: button2Selector, for: .touchUpInside)
        self.view.addSubview(button2)
        button2.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraint(
            NSLayoutConstraint(item: button2,
                               attribute: .left,
                               relatedBy: .equal,
                               toItem: self.view,
                               attribute: .centerX,
                               multiplier: 1, constant: 10))
        self.view.addConstraint(
            NSLayoutConstraint(item: button2,
                               attribute: .right,
                               relatedBy: .equal,
                               toItem: self.view,
                               attribute: .right,
                               multiplier: 1, constant: -10))
        self.view.addConstraint(
            NSLayoutConstraint(item: button2,
                               attribute: .top,
                               relatedBy: .equal,
                               toItem: yRef,
                               attribute: .top,
                               multiplier: 1, constant: 40))
    }
    
    func addDukePerson(sender: UIButton!) {
        
        // validate text fields
        for attribute in attributes.values {
            let placeholder: String = attribute.fieldView.placeholder!
            if attribute.fieldView.text! == "" && placeholder != "MS/BS/MENG/PhD/NA/Other" && placeholder != "up to 3, comma delimited" && placeholder != "decimal" {
                handleEmptyField()
                return
            }
        }
        
        let newDukePerson: DukePerson = DukePerson()
        
        newDukePerson.setFirstName(firstName: attributes["firstName"]!.fieldView.text!)
        newDukePerson.setLastName(lastName: attributes["lastName"]!.fieldView.text!)
        
        if recordExists(first: newDukePerson.firstName, last: newDukePerson.lastName) {
            alertOkMessage(title: "Record Exists", message: "A record already exists for \(newDukePerson.getFirstName()) \(newDukePerson.getLastName()). You must update or delete the existing record.")
            return
        }
        
        newDukePerson.setWhereFrom(whereFrom: attributes["from"]!.fieldView.text!)
        let genderString: String = attributes["gender"]!.fieldView.text!
        switch (genderString.lowercased()) {
        case "male":
            newDukePerson.setGender(gender: .Male)
        case "female":
            newDukePerson.setGender(gender: .Female)
        default:
            handleIncorrectData(field: "Gender")
            return
        }
        
        let roleString: String = attributes["role"]!.fieldView.text!
        switch (roleString.lowercased()) {
        case "student":
            newDukePerson.setRole(role: .Student)
        case "ta":
            newDukePerson.setRole(role: .TA)
        case "professor":
            newDukePerson.setRole(role: .Professor)
        default:
            handleIncorrectData(field: "Role")
            return
        }
        
        newDukePerson.setSchool(school: attributes["school"]!.fieldView.text!)
        
        newDukePerson.setDegree(degree: getDegreeFromString(degreeString: attributes["degree"]!.fieldView.text!))
        
        let gpaString: String = attributes["gpa"]!.fieldView.text!
        if let gpa: Double = Double(gpaString) {
            newDukePerson.setGPA(gpa: gpa)
        }
        
        let languages: String = attributes["languages"]!.fieldView.text!
        var languagesArray: [String] = languages.characters.split{$0 == ","}.map(String.init)
        languagesArray = languagesArray.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        if (languagesArray.count > 3) {
            handleIncorrectData(field: "Languages")
            return
        }
        newDukePerson.addLanguages(languages: languagesArray)
        
        let hobbies: String = attributes["hobbies"]!.fieldView.text!
        var hobbiesArray: [String] = hobbies.characters.split{$0 == ","}.map(String.init)
        hobbiesArray = hobbiesArray.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        if (hobbiesArray.count > 3) {
            handleIncorrectData(field: "Hobbies")
            return
        }
        newDukePerson.addHobbies(hobbies: hobbiesArray)
        
        alertOkMessage(title: "Success", message: "The registry was updated with \(newDukePerson.getFirstName()) \(newDukePerson.getLastName()).")
        dukePeople.append(newDukePerson)
        clearTextFields()
    }
    
    func getDukePerson(sender: UIButton!) {
        
        let firstName: String = attributes["firstName"]!.fieldView.text!
        let lastName: String = attributes["lastName"]!.fieldView.text!
        
        if firstName == "" || lastName == "" {
            handleEmptyField()
        }
        
        var found: Bool = false
        for dukePerson in dukePeople {
            if dukePerson.getFirstName().lowercased() == firstName.lowercased() && dukePerson.getLastName().lowercased() == lastName.lowercased() {
                found = true
                alertOkMessage(title: "Result", message: dukePerson.getDescription())
            }
        }
        if !found {
            alertOkMessage(title: "No Records Found", message: "A record for \(firstName) \(lastName) was not found in the registry.")
        }
        clearTextFields()
    }
    
    func updateDukePerson(sender: UIButton!) {
        
        let firstName: String = attributes["firstName"]!.fieldView.text!
        let lastName: String = attributes["lastName"]!.fieldView.text!
        
        if firstName == "" || lastName == "" {
            handleEmptyField()
        } else {
            var newDukePeople: [DukePerson] = [DukePerson]()
            for dukePerson in dukePeople {
                if dukePerson.getFirstName() != firstName && dukePerson.getLastName() != lastName {
                    newDukePeople.append(dukePerson)
                }
            }
            if newDukePeople.count == dukePeople.count {
                alertOkMessage(title: "No Existing Record Found", message: "A record for \(firstName) \(lastName) was not found in the registry.")
            } else {
                dukePeople = newDukePeople
                addDukePerson(sender: sender)
            }
        }
    }
    
    func deleteDukePerson() {
        
        let firstName: String = attributes["firstName"]!.fieldView.text!
        let lastName: String = attributes["lastName"]!.fieldView.text!
        
        if firstName == "" || lastName == "" {
            handleEmptyField()
        } else {
            var newDukePeople: [DukePerson] = [DukePerson]()
            for dukePerson in dukePeople {
                if dukePerson.getFirstName() != firstName && dukePerson.getLastName() != lastName {
                    newDukePeople.append(dukePerson)
                }
            }
            if newDukePeople.count == dukePeople.count {
                alertOkMessage(title: "No Existing Record Found", message: "A record for \(firstName) \(lastName) was not found in the registry.")
            } else {
                dukePeople = newDukePeople
                alertOkMessage(title: "Success", message: "\(firstName) \(lastName) was removed from the registry.")
                clearTextFields()
            }
        }
    }
    
    func getByDegree(sender: UIButton!) {
        
        let degreeString: String = attributes["degree"]!.fieldView.text!
        let degree: Degree = getDegreeFromString(degreeString: degreeString)
        
        var found: Bool = false
        var res: String = ""
        for dukePerson in self.dukePeople {
            if dukePerson.getDegree() == degree {
                found = true
                res += dukePerson.getDescription() + "\n"
            }
        }
        if found {
            alertOkMessage(title: "Result", message: res)
        } else {
            alertOkMessage(title: "No Records Found", message: "No records with a \(degree) degree were found.")
        }
        clearTextFields()
    }
    
    func getHighestGPA(sender: UIButton!) {
        var res: DukePerson?
        var highestGPA: Double = 0.0
        for dukePerson in dukePeople {
            if (dukePerson.getGPA() > highestGPA) {
                highestGPA = dukePerson.getGPA()
                res = dukePerson
            }
        }
        alertOkMessage(title: "Result", message: res!.getDescription())
    }
    
    func recordExists(first: String, last: String) -> Bool {
        for dukePerson in dukePeople {
            if dukePerson.getFirstName().lowercased() == first.lowercased() && dukePerson.getLastName().lowercased() == last.lowercased() {
                return true
            }
        }
        return false
    }
    
    func clearTextFields() {
        for attribute in self.attributes {
            attribute.value.fieldView.text! = ""
        }
    }
    
    func getDegreeFromString(degreeString: String) -> Degree {
        switch (degreeString.lowercased()) {
        case "ms":
            return .MS
        case "bs":
            return .BS
        case "meng":
            return .MENG
        case "phd":
            return .Phd
        case "na":
            return .NA
        case "other":
            return .Other
        default:
            return .NA
        }
    }
    
    func handleEmptyField() {
        let alert = UIAlertController(title: "Empty Fields Detected", message: "Please ensure that the fields needed for this operation are not empty. Languages and Hobbies are optional for adding.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func handleIncorrectData(field: String) {
        let alert = UIAlertController(title: "Incorrect Data Detected", message: "Incorrect data was entered into the \(field) field.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func alertOkMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // dismiss keyboard on "Done" press
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

