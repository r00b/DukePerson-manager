//
//  DukePersonTableViewController.swift
//  ECE564_F17_HOMEWORK
//
//  Created by Robert Steilberg on 9/19/17.
//  Copyright © 2017 ece564. All rights reserved.
//

import UIKit
import os.log

class DukePersonTableViewController: UITableViewController {
    
    // MARK: Properties
    
    var dukePersons: [[DukePerson]] = [[DukePerson](), [DukePerson](), [DukePerson]()]
    
    var sections: [String] = ["Students", "Teaching Assistants", "Professor"]
    
    
    // MARK: ViewController functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSampleDukePersons()

        // Use the edit button item provided by the table view controller for deleting entries
        navigationItem.leftBarButtonItem = editButtonItem
            }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: TableView functions
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dukePersons[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // TableView cells are reused and should be dequeued using a cell identifier
        let cellIdentifier = "DukePersonTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? DukePersonTableViewCell else {
            fatalError("The dequeued cell is not an instance of DukePersonTableViewCell")
        }
        
        // fetch the appropriate DukePerson for the data source layout
        let dukePerson = dukePersons[indexPath.section][indexPath.row]
        
        // set text and description of each cell
        cell.nameLabel.text = dukePerson.getFirstName() + " " + dukePerson.getLastName()
        cell.descriptionTextView.text = dukePerson.getDescription()
        cell.clipsToBounds = true
        return cell
    }
    
    // allow editing of cells in the TableView
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // back-end support for editing cells in the TableView
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // delete the row from the data source
            dukePersons[indexPath.section].remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "") {
        case "AddDukePerson":
            os_log("adding a new DukePerson", log: OSLog.default, type: .debug)
        case "ShowDetail":
            guard let dukePersonViewController = segue.destination as? DukePersonViewController else {
                fatalError("unexpected destination: \(segue.destination)")
            }
            guard let selectedDukePersonCell = sender as? DukePersonTableViewCell else {
                fatalError("unexpected sender: \(String(describing: sender))")
            }
            guard let indexPath = tableView.indexPath(for: selectedDukePersonCell) else {
                fatalError("the selected cell is not being displayed by the table")
            }
            let selectedDukePerson = dukePersons[indexPath.section][indexPath.row]
            // set the DukePerson that the DukePersonViewController with initialize with
            dukePersonViewController.dukePerson = selectedDukePerson
        default:
            fatalError("unexpected Segue Identifier: \(String(describing: segue.identifier))")
        }
    }
    
    
    //MARK: Actions
    
    @IBAction func unwindToDukePersonList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? DukePersonViewController, let dukePerson = sourceViewController.dukePerson {
            
            if var selectedIndexPath = tableView.indexPathForSelectedRow {
                // we are updating an existing DukePerson
                let newSection = getSectionFromRole(role: dukePerson.getRole())
                if (newSection != selectedIndexPath.section) {
                    // we are changing roles
                    dukePersons[selectedIndexPath.section].remove(at: selectedIndexPath.row)
                    tableView.deleteRows(at: [selectedIndexPath], with: .fade)
//                    tableView.reloadRows(at: [selectedIndexPath], with: .none)

                    let newIndexPath = IndexPath(row: dukePersons[newSection].count, section: newSection)
                    dukePersons[newSection].append(dukePerson)
                    tableView.insertRows(at: [newIndexPath], with: .automatic)

                } else {
                    dukePersons[selectedIndexPath.section][selectedIndexPath.row] = dukePerson
                    tableView.reloadRows(at: [selectedIndexPath], with: .none)
                }
            } else {
                // we are adding a new DukePerson
                let section = getSectionFromRole(role: dukePerson.getRole())
                let newIndexPath = IndexPath(row: dukePersons[section].count, section: section)
                dukePersons[section].append(dukePerson)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        }
    }
    
    
    //MARK: Private Methods
    
    private func loadSampleDukePersons() {
        let robert = DukePerson()
        robert.setFirstName(firstName: "Robert")
        robert.setLastName(lastName: "Steilberg")
        robert.setWhereFrom(whereFrom: "Richmond, VA")
        robert.setGender(gender: "Male")
        robert.setRole(role: "Student")
        robert.setTeam(team: "FirePage")
        robert.setSchool(school: "Duke University")
        robert.setDegree(degree: "BS")
        robert.setGPA(gpa: 3.8)
        robert.addLanguage(language: "Python")
        robert.addLanguage(language: "JavaScript")
        robert.addLanguage(language: "Ruby")
        robert.addHobby(hobby: "Super Smash Bros.")
        robert.addHobby(hobby: "skiing")
        robert.addHobby(hobby: "SCUBA diving")
        
        self.dukePersons[0].append(robert)
        
        let teddy = DukePerson()
        teddy.setFirstName(firstName: "Teddy")
        teddy.setLastName(lastName: "Franceschi")
        teddy.setWhereFrom(whereFrom: "Los Angeles, CA")
        teddy.setGender(gender: "Male")
        teddy.setRole(role: "Student")
        teddy.setTeam(team: "FirePage")
        teddy.setSchool(school: "Duke University")
        teddy.setDegree(degree: "BS")
        teddy.addLanguage(language: "MATLAB")
        teddy.addLanguage(language: "Java")
        teddy.addLanguage(language: "Swift")
        teddy.addHobby(hobby: "Super Smash Bros.")
        teddy.addHobby(hobby: "hiking")
        teddy.addHobby(hobby: "lifting")
        
        self.dukePersons[0].append(teddy)
        
        let ric = DukePerson()
        ric.setFirstName(firstName: "Ric")
        ric.setLastName(lastName: "Telford")
        ric.setWhereFrom(whereFrom: "Morrisville, NC")
        ric.setGender(gender: "Male")
        ric.setRole(role: "Professor")
        ric.setSchool(school: "Trinity University")
        ric.setDegree(degree: "MENG")
        ric.setGPA(gpa: 3.9) // for testing findHighestGPA() in HW 1 & 2
        ric.addLanguages(languages: ["Swift", "C", "C++"])
        ric.addHobbies(hobbies: ["golf", "swimming", "biking"])
        
        self.dukePersons[2].append(ric)
        
        let gilbert = DukePerson()
        gilbert.setFirstName(firstName: "Gilbert")
        gilbert.setLastName(lastName: "Brooks")
        gilbert.setWhereFrom(whereFrom: "Shelby, NC")
        gilbert.setGender(gender: "Male")
        gilbert.setRole(role: "Teaching Assistant")
        gilbert.setSchool(school: "Duke University")
        gilbert.setDegree(degree: "BS")
        gilbert.addLanguages(languages: ["Swift", "Java"])
        gilbert.addHobbies(hobbies: ["user experience", "product development"])
        
        self.dukePersons[1].append(gilbert)
        
        let niral = DukePerson()
        niral.setFirstName(firstName: "Niral")
        niral.setLastName(lastName: "Shah")
        niral.setWhereFrom(whereFrom: "central New Jersey")
        niral.setGender(gender: "Male")
        niral.setRole(role: "Teaching Assistant")
        niral.setSchool(school: "Rutgers University")
        niral.setDegree(degree: "BS")
        niral.addLanguages(languages: ["Swift", "Python", "Java"])
        niral.addHobbies(hobbies: ["computer vision", "tennis", "travelling"])
        
        self.dukePersons[1].append(niral)
    }
    
    // map each role to a section index
    private func getSectionFromRole(role: String) -> Int {
        switch role {
        case "Student":
            return 0
        case "Teaching Assistant":
            return 1
        case "Professor":
            return 2
        default:
            fatalError("DukePerson of invalid role created")
        }
    }
}
