//
//  DukePersonViewController.swift
//  ECE564_F17_HOMEWORK
//
//  Created by Robert Steilberg on 9/19/17.
//  Copyright © 2017 ece564. All rights reserved.
//

import UIKit
import os.log

class DukePersonViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    // MARK: Properties
    
    // either passed by `DukeTableViewController` in `prepare(for:sender:)` or constructed as part of adding a new DukePerson
    var dukePerson: DukePerson?
    
    // define enums, since we can't just create an array from an enum class
    let genders: [String] = ["Male", "Female"]
    let roles: [String] = ["Student", "Teaching Assistant", "Professor"]
    let degrees: [String] = ["MS", "BS", "MENG", "Ph.D", "N/A", "Other"]
    
    var textFields = [UITextField]()
    
    // MARK: View components
    
    @IBOutlet weak var leftBarButton: UIBarButtonItem!
    @IBOutlet weak var rightBarButton: UIBarButtonItem!
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var roleTextField: UITextField!
    @IBOutlet weak var teamTextField: UITextField!
    @IBOutlet weak var fromTextField: UITextField!
    @IBOutlet weak var schoolTextField: UITextField!
    @IBOutlet weak var degreeTextField: UITextField!
    @IBOutlet weak var language1TextField: UITextField!
    @IBOutlet weak var language2TextField: UITextField!
    @IBOutlet weak var language3TextField: UITextField!
    @IBOutlet weak var hobby1TextField: UITextField!
    @IBOutlet weak var hobby2TextField: UITextField!
    @IBOutlet weak var hobby3TextField: UITextField!
    
    var activeField: UITextField?

    @IBOutlet weak var profilePicImageView: UIImageView!
    
    let genderPickerView = UIPickerView()
    let rolePickerView = UIPickerView()
    let degreePickerView = UIPickerView()
    
    
    // MARK: ViewController functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // put TextFields in an array so we can loop to do batch-actions
        textFields.append(firstNameTextField)
        textFields.append(lastNameTextField)
        textFields.append(genderTextField)
        textFields.append(roleTextField)
        textFields.append(teamTextField)
        textFields.append(fromTextField)
        textFields.append(schoolTextField)
        textFields.append(degreeTextField)
        textFields.append(language1TextField)
        textFields.append(language2TextField)
        textFields.append(language3TextField)
        textFields.append(hobby1TextField)
        textFields.append(hobby2TextField)
        textFields.append(hobby3TextField)
        
        // set up delegates
        genderPickerView.delegate = self
        rolePickerView.delegate = self
        degreePickerView.delegate = self
        for textField in textFields {
            textField.delegate = self
        }
        genderTextField.inputView = genderPickerView
        roleTextField.inputView = rolePickerView
        degreeTextField.inputView = degreePickerView
     
        // see if we are being provided an existing DukePerson
        if let dukePerson = dukePerson {
            
            navigationItem.title = dukePerson.getFullName()
            leftBarButton.title = "Back"
            rightBarButton.title = "Edit"
            rightBarButton.isEnabled = true
            
            // getting properties of existing DukePerson
            firstNameTextField.text = dukePerson.getFirstName()
            lastNameTextField.text = dukePerson.getLastName()
            genderTextField.text = dukePerson.getGender()
            roleTextField.text = dukePerson.getRole()
            teamTextField.text = dukePerson.getTeam()
            fromTextField.text = dukePerson.whereFrom
            schoolTextField.text = dukePerson.getSchool()
            degreeTextField.text = dukePerson.getDegree()
            language1TextField.text = dukePerson.getLanguage(index: 0)
            language2TextField.text = dukePerson.getLanguage(index: 1)
            language3TextField.text = dukePerson.getLanguage(index: 2)
            hobby1TextField.text = dukePerson.getHobby(index: 0)
            hobby2TextField.text = dukePerson.getHobby(index: 1)
            hobby3TextField.text = dukePerson.getHobby(index: 2)
            
            for textField in textFields {
                textField.isUserInteractionEnabled = false
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: Navigation
    
    // Handle leftBarButton
    @IBAction func cancelAdd(_ sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways
        let isPresentingInAddDukePersonMode = presentingViewController is UINavigationController
        
        if isPresentingInAddDukePersonMode {
            // cancel adding new DukePerson
            dismiss(animated: true, completion: nil)
        } else if let owningNavigationController = navigationController {
            // go back to list of DukePersons
            owningNavigationController.popViewController(animated: true)
        } else {
            fatalError("The DukePersonViewController is not inside a navigation controller")
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        guard let button = sender as? UIBarButtonItem, button === rightBarButton else {
            // Edit button not pressed, execute the segue
            return true
        }
        if rightBarButton.title! == "Edit" {
            enableTextFieldEditing()
            rightBarButton.title = "Save"
            // cancel the segue
            return false
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        // configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === rightBarButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        //        let photo = profilePicImageView.image
        
        // creating a new DukePerson
        dukePerson = DukePerson()
        dukePerson?.setFirstName(firstName: firstNameTextField.text ?? "")
        dukePerson?.setLastName(lastName: lastNameTextField.text ?? "")
        dukePerson?.setGender(gender: genderTextField.text ?? "")
        dukePerson?.setRole(role: roleTextField.text ?? "")
        dukePerson?.setTeam(team: teamTextField.text ?? "")
        dukePerson?.setWhereFrom(whereFrom: fromTextField.text ?? "")
        dukePerson?.setSchool(school: schoolTextField.text ?? "")
        dukePerson?.setDegree(degree: degreeTextField.text ?? "")
        dukePerson?.addLanguages(languages: [language1TextField.text ?? "", language2TextField.text ?? "", language3TextField.text ?? ""])
        dukePerson?.addHobbies(hobbies: [hobby1TextField.text ?? "", hobby2TextField.text ?? "", hobby3TextField.text ?? ""])
    }
    
    
    // MARK: Actions
    
    @IBAction func rightBarButton(_ sender: UIBarButtonItem) {
        if sender.title == "Edit" {
            enableTextFieldEditing()
        }
    }
    
    
    // MARK: UIPickerViewDelegate / UIPickerViewDataSource functions
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case genderPickerView:
            return genders.count
        case rolePickerView:
            return roles.count
        case degreePickerView:
            return degrees.count
        default:
            fatalError("Invalid Picker View used in controller.")
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case genderPickerView:
            return genders[row]
        case rolePickerView:
            return roles[row]
        case degreePickerView:
            return degrees[row]
        default:
            fatalError("Invalid Picker View used in controller.")
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case genderPickerView:
            genderTextField.text = genders[row]
        case rolePickerView:
            roleTextField.text = roles[row]
        case degreePickerView:
            degreeTextField.text = degrees[row]
        default:
            fatalError("Invalid Picker View used in controller.")
        }
    }
    
    
    //MARK: UITextFieldDelegate functions
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        rightBarButton.isEnabled = false
    }
    
    // Check to see if all fields are valid, update modal title
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateRightBarButtonState()
        let isPresentingInDukePersonDetailMode = !(presentingViewController is UINavigationController)
        if (isPresentingInDukePersonDetailMode) {
            navigationItem.title = dukePerson?.getFullName()
        }
    }
    
    // Dismiss keyboard when focus leaves TextField
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // Dismiss keyboard when "Done" is pressed
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    
    // MARK: Private functions
    
    private func updateRightBarButtonState() {
        // Disable the Save button if any of the following TextFields are empty
        let firstName = firstNameTextField.text ?? ""
        let lastName = lastNameTextField.text ?? ""
        let gender = genderTextField.text ?? ""
        let role = roleTextField.text ?? ""
        let from = fromTextField.text ?? ""
        let school = schoolTextField.text ?? ""
        rightBarButton.isEnabled = !firstName.isEmpty && !lastName.isEmpty && !gender.isEmpty && !role.isEmpty && !from.isEmpty && !school.isEmpty
    }
    
    private func enableTextFieldEditing() {
        for textField in textFields {
            textField.isUserInteractionEnabled = true
        }
    }
}
