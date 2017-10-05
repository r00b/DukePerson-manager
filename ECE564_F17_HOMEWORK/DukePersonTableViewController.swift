//
//  DukePersonTableViewController.swift
//  ECE564_F17_HOMEWORK
//
//  Created by Robert Steilberg on 9/25/17.
//  Copyright © 2017 ece564. All rights reserved.
//

import UIKit
import os.log

class DukePersonTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: Properties
    
    // either passed by `DukeTableViewController` in `prepare(for:sender:)` or constructed as part of adding a new DukePerson
    var dukePerson: DukePerson?
    
    // define enums, since we can't just create an array from an enum class
    let genders: [String] = ["Male", "Female"]
    let roles: [String] = ["Student", "Teaching Assistant", "Professor"]
    let degrees: [String] = ["MS", "BS", "MENG", "Ph.D", "N/A", "Other"]
    
    
    // MARK: Views
    
    @IBOutlet var labels: [UILabel]!
    
    @IBOutlet var textFields: [UITextField]!
    
    @IBOutlet weak var profilePicture: UIImageView!
    let profilePicturePicker = UIImagePickerController()
    
    let genderPickerView = UIPickerView()
    let rolePickerView = UIPickerView()
    let degreePickerView = UIPickerView()
    
    @IBOutlet weak var leftBarButton: UIBarButtonItem!
    @IBOutlet weak var rightBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateWidthsForLabels(labels: labels)
        
        updateRightBarButtonState()
        
        // dismiss keyboard when focus leaves text field
        let dismissKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(DukePersonTableViewController.hideKeyboard))
        dismissKeyboardGesture.cancelsTouchesInView = true
        tableView.addGestureRecognizer(dismissKeyboardGesture)
        
        let addImageGesture = UITapGestureRecognizer(target: self, action: #selector(DukePersonTableViewController.imageTapped))
        profilePicture.isUserInteractionEnabled = true
        profilePicture.addGestureRecognizer(addImageGesture)
        
        profilePicturePicker.delegate = self
        genderPickerView.delegate = self
        degreePickerView.delegate = self
        rolePickerView.delegate = self
        
        for textField in textFields {
            textField.delegate = self
        }
        
        textFields[2].inputView = genderPickerView
        textFields[5].inputView = degreePickerView
        textFields[6].inputView = rolePickerView
        
        if let dukePerson = dukePerson {
            
            self.navigationItem.leftBarButtonItem?.title = "Back"
            self.navigationItem.rightBarButtonItem?.title = "Edit"
            rightBarButton.isEnabled = true
            
            if let pic = dukePerson.getProfilePicture() {
                profilePicture.image = pic
            }
            
            textFields[0].text = dukePerson.getFirstName()
            textFields[1].text = dukePerson.getLastName()
            textFields[2].text = dukePerson.getGender()
            textFields[3].text = dukePerson.whereFrom
            
            textFields[4].text = dukePerson.getSchool()
            textFields[5].text = dukePerson.getDegree()
            textFields[6].text = dukePerson.getRole()
            textFields[7].text = dukePerson.getTeam()
            
            textFields[8].text = dukePerson.getLanguage(index: 0)
            textFields[9].text = dukePerson.getLanguage(index: 1)
            textFields[10].text = dukePerson.getLanguage(index: 2)
            
            textFields[11].text = dukePerson.getHobby(index: 0)
            textFields[12].text = dukePerson.getHobby(index: 1)
            textFields[13].text = dukePerson.getHobby(index: 2)
            
            textFields[14].text = dukePerson.getEmployer()
            
            if dukePerson.getYearsExperience() != nil {
                textFields[15].text = String(describing: dukePerson.getYearsExperience()!)
            }
            
            if dukePerson.getGPA() != nil {
                textFields[16].text = String(describing: dukePerson.getGPA()!)
            }
            
            setTextFieldsEditable(editable: false)
        }
    }
    
    // MARK: - Navigation
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        guard let button = sender as? UIBarButtonItem, button === rightBarButton else {
            // Edit button not pressed, execute the segue
            return true
        }
        if rightBarButton.title! == "Edit" {
            setTextFieldsEditable(editable: true)
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
        
        // creating a new DukePerson
        let newDukePerson = DukePerson(firstName: textFields[0].text!, lastName: textFields[1].text!, gender: textFields[2].text!, whereFrom: textFields[3].text!, school: textFields[4].text!, role: textFields[6].text!)
        newDukePerson.setProfilePicture(picture: profilePicture.image)
        newDukePerson.setDegree(degree: textFields[5].text ?? "")
        newDukePerson.setGPA(gpa: Double(textFields[16].text!))
        newDukePerson.setTeam(team: textFields[7].text ?? "")
        newDukePerson.setEmployer(employer: textFields[14].text ?? "")
        newDukePerson.setYearsExperience(years: Int(textFields[15].text!))
        
        newDukePerson.addLanguages(languages: [textFields[8].text ?? "", textFields[9].text ?? "", textFields[10].text ?? ""])
        newDukePerson.addHobbies(hobbies: [textFields[11].text ?? "", textFields[12].text ?? "", textFields[13].text ?? ""])
        if let animationController = dukePerson?.getAnimationController() {
            newDukePerson.setAnimationController(controller: animationController)
        }
        
        dukePerson = newDukePerson
    }
    
    
    // MARK: Actions
    
    @IBAction func leftBarButtonAction(_ sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways
        let isPresentingInAddDukePersonMode = presentingViewController is UINavigationController
        
        if isPresentingInAddDukePersonMode {
            // cancel adding new DukePerson
            dismiss(animated: true, completion: nil)
        } else if let owningNavigationController = navigationController {
            // go back to list of DukePersons
            owningNavigationController.popViewController(animated: true)
        } else {
            fatalError("The DukePersonTableViewController is not inside a navigation controller")
        }
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profilePicture.contentMode = .scaleAspectFit
            profilePicture.image = pickedImage
            dukePerson?.setProfilePicture(picture: pickedImage)
            if rightBarButton.title == "Edit" {
                performSegue(withIdentifier: "saveProfilePicture", sender: rightBarButton)
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
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
            fatalError("Invalid PickerView used in controller.")
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
            fatalError("Invalid PickerView used in controller.")
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case genderPickerView:
            textFields[2].text = genders[row]
        case degreePickerView:
            textFields[5].text = degrees[row]
        case rolePickerView:
            textFields[6].text = roles[row]
        default:
            fatalError("Invalid PickerView used in controller.")
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
        //        let isPresentingInDukePersonDetailMode = !(presentingViewController is UINavigationController)
        //        if (isPresentingInDukePersonDetailMode) {
        //            navigationItem.title = dukePerson?.getFullName()
        //        }
    }
    
    // Dismiss keyboard
    func hideKeyboard() {
        tableView.endEditing(true)
    }
    
    // Dismiss keyboard when "Done" is pressed
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        hideKeyboard()
        return true
    }
    
    
    // MARK: Private functions
    
    private func calculateLabelWidth(label: UILabel) -> CGFloat {
        let labelSize = label.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: label.frame.height))
        return labelSize.width
    }
    
    private func calculateMaxLabelWidth(labels: [UILabel]) -> CGFloat {
        return labels.map(calculateLabelWidth).reduce(0, max)
    }
    
    private func updateWidthsForLabels(labels: [UILabel]) {
        let maxLabelWidth = calculateMaxLabelWidth(labels: labels)
        for label in labels {
            let constraint = NSLayoutConstraint(item: label,
                                                attribute: .width,
                                                relatedBy: .equal,
                                                toItem: nil,
                                                attribute: .notAnAttribute,
                                                multiplier: 1,
                                                constant: maxLabelWidth)
            label.addConstraint(constraint)
        }
    }
    
    private func updateRightBarButtonState() {
        // Disable the Save button if any of the following TextFields are empty
        let firstName = textFields[0].text ?? ""
        let lastName = textFields[1].text ?? ""
        let gender = textFields[2].text ?? ""
        let from = textFields[3].text ?? ""
        let school = textFields[4].text ?? ""
        let role = textFields[6].text ?? ""
        let team = textFields[7].text ?? ""
        
        var teamValid = true
        if team != "" {
            teamValid = (role == "Student")
        }
        
        rightBarButton.isEnabled = !firstName.isEmpty && !lastName.isEmpty && !gender.isEmpty && !from.isEmpty && !school.isEmpty && !role.isEmpty && teamValid
    }
    
    private func setTextFieldsEditable(editable: Bool) {
        for textField in textFields {
            textField.isUserInteractionEnabled = editable
        }
    }
    
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        //        let tappedImage = tapGestureRecognizer.view as! UIImageView
        profilePicturePicker.allowsEditing = false
        profilePicturePicker.sourceType = .camera
        present(profilePicturePicker, animated: true, completion: nil)
    }
    
}
