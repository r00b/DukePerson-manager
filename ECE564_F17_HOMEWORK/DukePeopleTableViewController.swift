//
//  DukePeopleTableViewController.swift
//  ECE564_F17_HOMEWORK
//
//  Created by Robert Steilberg on 9/19/17.
//  Copyright © 2017 ece564. All rights reserved.
//

import UIKit
import os.log

class DukePeopleTableViewController: UITableViewController {
    
    // MARK: Properties
    
    var dukePersons = [[DukePerson]]()
    
    var sections: [String] = ["Students", "Teaching Assistants", "Professor"]
    
    let overwriteData = false
    
    // MARK: UI Outlets
    
    @IBOutlet weak var DukePeopleTableView: UITableView!
    
    
    // MARK: ViewController functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use the edit button item provided by the table view controller for deleting entries
        navigationItem.leftBarButtonItem = editButtonItem
        
        // Load any saved DukePersons, otherwise load sample data.
        if overwriteData {
            dukePersons = sampleDukePersons()
        } else {
            if let savedDukePersons = loadDukePersons(), let savedSections = loadSections() {
                dukePersons = savedDukePersons
                sections = savedSections
            } else {
                dukePersons = sampleDukePersons()
            }
        }
        createTeamSections()
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
        if let profilePicture = dukePerson.getProfilePicture() {
            cell.profilePicture.image = profilePicture
        }
        cell.nameLabel.text = dukePerson.getFullName()
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
            
            if dukePersons[indexPath.section].isEmpty && indexPath.section > 2 {
                dukePersons.remove(at: indexPath.section)
                sections.remove(at: indexPath.section)
            }
            
            saveDukePersons()
            saveSections()
            DukePeopleTableView.reloadData()
            //            tableView.deleteRows(at: [indexPath], with: .fade)
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
            guard let dukePersonViewController = segue.destination as? DukePersonPageViewController else {
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
        if let sourceViewController = sender.source as? DukePersonTableViewController, let dukePerson = sourceViewController.dukePerson {
            
            if var selectedIndexPath = tableView.indexPathForSelectedRow {
                
                // we are updating an existing DukePerson
                var newSection = getSectionFromRole(dukePerson: dukePerson, role: dukePerson.getRole())
                
                if (newSection != selectedIndexPath.section) {
                    
                    // we are changing roles
                    dukePersons[selectedIndexPath.section].remove(at: selectedIndexPath.row)
                    
                    
                    if dukePersons[selectedIndexPath.section].isEmpty && selectedIndexPath.section > 2 {
                        dukePersons.remove(at: selectedIndexPath.section)
                        sections.remove(at: selectedIndexPath.section)
                    }
                    if newSection >= sections.count {
                        newSection -= 1
                    }
                    DukePeopleTableView.reloadData()
                    
                    //                    tableView.deleteRows(at: [selectedIndexPath], with: .fade)
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
                let section = getSectionFromRole(dukePerson: dukePerson, role: dukePerson.getRole())
                DukePeopleTableView.reloadData()
                let newIndexPath = IndexPath(row: dukePersons[section].count, section: section)
                dukePersons[section].append(dukePerson)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            saveDukePersons()
            saveSections()
        }
    }
    
    
    //MARK: Private Methods
    
    private func sampleDukePersons() -> [[DukePerson]] {
        var result = [[DukePerson](), [DukePerson](), [DukePerson]()]
        
        let robert = DukePerson(firstName: "Robert", lastName: "Steilberg", gender: "Male", whereFrom: "Richmond, VA", school: "Duke University", role: "Student")
        robert.setProfilePicture(picture: UIImage(named: "rob.jpg"))
        robert.setTeam(team: "The Gargs")
        robert.setDegree(degree: "BS")
        robert.setGPA(gpa: 3.8)
        robert.setEmployer(employer: "Esri")
        robert.setYearsExperience(years: 0)
        robert.addLanguage(language: "Python")
        robert.addLanguage(language: "JavaScript")
        robert.addLanguage(language: "Ruby")
        robert.addHobby(hobby: "Super Smash Bros.")
        robert.addHobby(hobby: "skiing")
        robert.addHobby(hobby: "SCUBA diving")
        robert.setAnimationController(controller: HobbySCUBAViewController())
        
        result[0].append(robert)
        
        let teddy = DukePerson(firstName: "Teddy", lastName: "Franceschi", gender: "Male", whereFrom: "Los Angeles, CA", school: "Duke University", role: "Student")
        teddy.setTeam(team: "The Gargs")
        teddy.setDegree(degree: "BS")
        teddy.addLanguage(language: "MATLAB")
        teddy.addLanguage(language: "Java")
        teddy.addLanguage(language: "Swift")
        teddy.addHobby(hobby: "Super Smash Bros.")
        teddy.addHobby(hobby: "hiking")
        teddy.addHobby(hobby: "lifting")
        
        result[0].append(teddy)
        
        let jack = DukePerson(firstName: "Jack", lastName: "Steilberg", gender: "Male", whereFrom: "Richmond, VA", school: "Northeastern University", role: "Student")
        jack.setDegree(degree: "BS")
        jack.setEmployer(employer: "Lincoln Labs")
        jack.setYearsExperience(years: 0)
        jack.addLanguage(language: "C++")
        jack.addLanguage(language: "Java")
        jack.addLanguage(language: "C")
        jack.addHobby(hobby: "Super Smash Bros.")
        jack.addHobby(hobby: "gaming")
        
        result[0].append(jack)
        
        let ric = DukePerson(firstName: "Ric", lastName: "Telford", gender: "Male", whereFrom: "Morrisville, NC", school: "Trinity University", role: "Professor")
        ric.setDegree(degree: "MENG")
        ric.setGPA(gpa: 3.9) // for testing findHighestGPA() in HW 1 & 2
        ric.addLanguages(languages: ["Swift", "C", "C++"])
        ric.addHobbies(hobbies: ["golf", "swimming", "biking"])
        
        result[2].append(ric)
        
        let gilbert = DukePerson(firstName: "Gilbert", lastName: "Brooks", gender: "Male", whereFrom: "Shelby, NC", school: "Duke University", role: "Teaching Assistant")
        gilbert.setDegree(degree: "BS")
        gilbert.addLanguages(languages: ["Swift", "Java"])
        gilbert.addHobbies(hobbies: ["user experience", "product development"])
        
        result[1].append(gilbert)
        
        let niral = DukePerson(firstName: "Niral", lastName: "Shah", gender: "Male", whereFrom: "central New Jersey", school: "Rutgers University", role: "Teaching Assistant")
        niral.setDegree(degree: "BS")
        niral.addLanguages(languages: ["Swift", "Python", "Java"])
        niral.addHobbies(hobbies: ["computer vision", "tennis", "travelling"])
        
        result[1].append(niral)
        
        return result
    }
    
    // map each role to a section index
    private func getSectionFromRole(dukePerson: DukePerson, role: String) -> Int {
        switch role {
        case "Student":
            let team = dukePerson.getTeam()
            if team != "" {
                if sections.contains(team) {
                    return sections.index(of: team)!
                } else {
                    sections.append(team)
                    dukePersons.append([DukePerson]())
                    return sections.count - 1
                }
            } else {
                return 0
            }
        case "Teaching Assistant":
            return 1
        case "Professor":
            return 2
        default:
            fatalError("DukePerson of invalid role created")
        }
    }
    
    private func saveDukePersons() {
        let path = DukePerson.DukePersonArchiveURL.path
        
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(dukePersons, toFile: path)
        if isSuccessfulSave {
            os_log("DukePersons successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save DukePersons...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadDukePersons() -> [[DukePerson]]? {
        let res = NSKeyedUnarchiver.unarchiveObject(withFile: DukePerson.DukePersonArchiveURL.path) as? [[DukePerson]]
        return res
    }
    
    private func saveSections() {
        let path = DukePerson.SectionsArchiveURL.path
        
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(sections, toFile: path)
        if isSuccessfulSave {
            os_log("Sections successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save Sections...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadSections() -> [String]? {
        let res = NSKeyedUnarchiver.unarchiveObject(withFile: DukePerson.SectionsArchiveURL.path) as? [String]
        return res
    }
    
    private func createTeamSections() {
        for dukeStudent in dukePersons[0] {
            let team = dukeStudent.getTeam()
            if team != "" {
                if sections.contains(team) {
                    let idx = sections.index(of: team)!
                    dukePersons[idx].append(dukeStudent)
                } else {
                    sections.append(team)
                    dukePersons.append([dukeStudent])
                }
                dukePersons[0].remove(at: dukePersons[0].index(of: dukeStudent)!)
            }
        }
    }
    
}
