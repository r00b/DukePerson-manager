//
//  DukePersonTableViewController.swift
//  ECE564_F17_HOMEWORK
//
//  Created by Robert Steilberg on 9/25/17.
//  Copyright © 2017 ece564. All rights reserved.
//

import UIKit
import os.log

class DukePersonTableViewController: UITableViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
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
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(DukePersonTableViewController.hideKeyboard))
        tapGesture.cancelsTouchesInView = true
        tableView.addGestureRecognizer(tapGesture)
        
        genderPickerView.delegate = self
        degreePickerView.delegate = self
        rolePickerView.delegate = self
        
        for textField in textFields {
            textField.delegate = self
        }
        
        textFields[2].inputView = genderPickerView
        textFields[5].inputView = degreePickerView
        textFields[6].inputView = rolePickerView
        
        textFields[0].text = dukePerson?.getFirstName()
        textFields[1].text = dukePerson?.getLastName()
        textFields[2].text = dukePerson?.getGender()
        textFields[3].text = dukePerson?.whereFrom
        
        textFields[4].text = dukePerson?.getSchool()
        textFields[5].text = dukePerson?.getDegree()
        textFields[6].text = dukePerson?.getRole()
        textFields[7].text = dukePerson?.getTeam()

        textFields[8].text = dukePerson?.getLanguage(index: 0)
        textFields[9].text = dukePerson?.getLanguage(index: 1)
        textFields[10].text = dukePerson?.getLanguage(index: 2)
        
        textFields[11].text = dukePerson?.getHobby(index: 0)
        textFields[12].text = dukePerson?.getHobby(index: 1)
        textFields[13].text = dukePerson?.getHobby(index: 2)

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   
    // MARK: - Navigation

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
        dukePerson?.setFirstName(firstName: textFields[0].text ?? "")
        dukePerson?.setLastName(lastName: textFields[1].text ?? "")
        dukePerson?.setGender(gender: textFields[2].text ?? "")
        dukePerson?.setWhereFrom(whereFrom: textFields[3].text ?? "")

        dukePerson?.setSchool(school: textFields[4].text ?? "")
        dukePerson?.setDegree(degree: textFields[5].text ?? "")
        dukePerson?.setRole(role: textFields[6].text ?? "")
        dukePerson?.setTeam(team: textFields[7].text ?? "")
        
        dukePerson?.addLanguages(languages: [textFields[8].text ?? "", textFields[9].text ?? "", textFields[10].text ?? ""])
        dukePerson?.addHobbies(hobbies: [textFields[11].text ?? "", textFields[12].text ?? "", textFields[13].text ?? ""])
        
    }
    
    // MARK: Actions
    
    @IBAction func leftBarButton(_ sender: Any) {
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
            textFields[2].text = genders[row]
        case degreePickerView:
            textFields[5].text = degrees[row]
        case rolePickerView:
            textFields[6].text = roles[row]
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
        rightBarButton.isEnabled = !firstName.isEmpty && !lastName.isEmpty && !gender.isEmpty && !from.isEmpty && !school.isEmpty && !role.isEmpty
    }

}
