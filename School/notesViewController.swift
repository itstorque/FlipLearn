//
//  notesViewController.swift
//  School
//
//  Created by Tareq El Dandachi on 5/11/17.
//  Copyright © 2017 Tareq El Dandachi. All rights reserved.
//

import UIKit

class notesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UITextViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var notes : [String] = []
    
    var importNotes = [""]//UserDefaults.standard.array(forKey: "notes")
    
    var subjects = UserDefaults.standard.dictionary(forKey: "notesDictionary")
    
    var Titles : [String] = []
    
    var noteData : [String] = []
    
    var oppositeTextColor = UIColor.black
    
    @IBOutlet weak var NewButton: UIButton!
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var subjectView: UITableView!
    
    @IBOutlet var titleLabel: UITextField!
    
    @IBOutlet var noteView: UITextView!
    
    @IBOutlet var subjectCollectionView: UICollectionView!
    
    @IBOutlet weak var addSubject: UIButton!
    
    var isNewNote : Bool = false
    
    var isTitleActive : Bool = false
    
    let deleteAlertController = UIAlertController(title: "Delete Note", message: "Are you sure you want to delete this note", preferredStyle: .alert)
    
    let tagAlertController = UIAlertController(title: "Pick a tag color", message: "",preferredStyle: .alert)
    
    let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel)
    
    var deleteAction = UIAlertAction(title: "Delete", style: .destructive)
    
    var tagAction1 = UIAlertAction(title: "Tag", style: .default)
    
    var tagAction2 = UIAlertAction(title: "Tag", style: .default)
    
    var tagAction3 = UIAlertAction(title: "Tag", style: .default)
    
    var tagAction4 = UIAlertAction(title: "Tag", style: .default)
    
    var tagAction5 = UIAlertAction(title: "Tag", style: .default)
    
    var tagAction6 = UIAlertAction(title: "Tag", style: .default)
    
    var indexSavedLast = -1
    
    var array : [String] = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        selectedSubject = 0
        
        titleLabel.text = "Title"
        
        titleLabel.returnKeyType = .done
        
        titleLabel.delegate = self
        
        noteView.font = UIFont.systemFont(ofSize: 20, weight:  UIFont.Weight.semibold)
        
        //print("\n\nON")
        
        // Do any additional setup after loading the view, typically from a nib.
        
        UserDefaults.standard.set(false, forKey: "aCellIsSwiping")
        
        subjects = UserDefaults.standard.dictionary(forKey: "notesDictionary")
        
        print(subjects as Any)
        
        if subjects == nil {
            
            UserDefaults.standard.set(["Help":["Title: Taking notes down🗅Note: Select the subject you want from the side bar, if it doesnt exist press the button found under the subjects column and create a new subject.\n\nAfter this by pressing the write button in the top right corner, you create a new note!\nGive it the lesson title name and you are done!𛲁tag: NX"]], forKey: "notesDictionary")
            
            subjects = UserDefaults.standard.dictionary(forKey: "notesDictionary")
            
        }
        
        if UserDefaults.standard.bool(forKey: "LoadedNotesBefore") == false {
            
            UserDefaults.standard.set(["Help":["Title: Taking notes down🗅Note: Select the subject you want from the side bar, if it doesnt exist press the button found under the subjects column and create a new subject.\n\nAfter this by pressing the write button in the top right corner, you create a new note!\nGive it the lesson title name and you are done!𛲁tag: NX"]], forKey: "notesDictionary")
            
            tableView.isHidden = true
            
            UserDefaults.standard.set(true, forKey: "LoadedNotesBefore")
            
        }
        
        array = Array(subjects!.keys)
        
        let keysToRemove = Array(subjects!.keys).filter { subjects?[$0]! == nil }
        
        for key in keysToRemove {
            
            subjects?.removeValue(forKey: key)//.removeValueForKey(key)
            
        }
        
        array = Array(subjects!.keys)
        
        /*print(array)
        
        print("^^^")
        
        print(subjects)*/
        
        importNotes = subjects![String(array[selectedSubject])] as! [String]//UserDefaults.standard.array(forKey: "notes")
        
        //Changed This
        
        notes = importNotes
        
        if notes.count > 0 {
         
            indexSavedLast = 0
            
            loadData(indexValue: indexSavedLast)
            
        }
        
        notes = ["Title: New Note🗅Note: 𛲁tag: NX"]
        
        tableView.register(NoteCell.self, forCellReuseIdentifier: "cell")
        
        breakArray()
        
        NewButton.addTarget(self, action:#selector(self.addClicked), for: .touchUpInside)
        
        Refresh()
        
        self.tableView.reloadData()
        
        tableView.separatorStyle = .none
        
        deleteAction = UIAlertAction(title: "Delete", style: .destructive) {
            
            UIAlertAction in
            
            self.confirmDelete()
            
        }
        
        let indexOfNote = indexSavedLast
        
        //titleLabel.text = Titles[indexOfNote]
        
        //noteView.text = noteData[indexOfNote]
        
        print("Selected Subject:", selectedSubject)
        
        //print(notes)
        
        //print(indexOfNote)
        
        var noteTag = notes[indexOfNote] as String
        
        let indexOfTag = noteTag.index(of: "𛲁")
        
        noteTag = notes[indexOfNote].substring(from: indexOfTag!)
        
        noteTag = String(noteTag.dropFirst(6))
        
        if isNewNote {
            
            if titleLabel.text == "" {
                
                titleLabel.text = "New Note"
                
            }
            
        } else {
            
            if titleLabel.text == "" {
                
                titleLabel.text = "No Title"
                
            }
            
        }
        
        //tagTitle()
        
        subjects = UserDefaults.standard.dictionary(forKey: "notesDictionary")
        
        array = Array(subjects!.keys)
        
        importNotes = subjects![String(array[selectedSubject])] as! [String]//UserDefaults.standard.array(forKey: "notes")
        
        //Changed This
        
        notes = importNotes
        
        Titles[indexOfNote] = titleLabel.text!.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        
        noteData[indexOfNote] = noteView.text.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        
        tagAction1 = UIAlertAction(title: "Blue", style: .default) {
            
            UIAlertAction in
            
            let z = UserDefaults.standard.integer(forKey: "indexToTag")
            
            self.notes[z] = "Title: " + self.Titles[z] + "🗅Note: " + self.noteData[z] + "𛲁tag: NX"
            
            self.subjects?[String(self.array[self.selectedSubject])] = self.notes
            
            UserDefaults.standard.set(self.subjects, forKey: "notesDictionary")
            
            self.Refresh()

            
        }
        
        tagAction2 = UIAlertAction(title: "Pink", style: .default) {
            
            UIAlertAction in
            
            self.notes[indexOfNote] = "Title: " + self.Titles[indexOfNote] + "🗅Note: " + self.noteData[indexOfNote] + "𛲁tag: BX"
            
            print("notes[indexOfNote] = ", self.notes[indexOfNote])
            
            self.subjects?[String(self.array[self.selectedSubject])] = self.notes
            
            UserDefaults.standard.set(self.subjects, forKey: "notesDictionary")
            
            self.Refresh()
            
        }
        
        tagAction3 = UIAlertAction(title: "Green", style: .default) {
            
            UIAlertAction in
            
            self.notes[indexOfNote] = "Title: " + self.Titles[indexOfNote] + "🗅Note: " + self.noteData[indexOfNote] + "𛲁tag: GX"
            
            print("notes[indexOfNote] = ", self.notes[indexOfNote])
            
            self.subjects?[String(self.array[self.selectedSubject])] = self.notes
            
            UserDefaults.standard.set(self.subjects, forKey: "notesDictionary")
            
            self.Refresh()
            
        }
        
        tagAction4 = UIAlertAction(title: "Red", style: .default) {
            
            UIAlertAction in
            
            self.notes[indexOfNote] = "Title: " + self.Titles[indexOfNote] + "🗅Note: " + self.noteData[indexOfNote] + "𛲁tag: RX"
            
            print("notes[indexOfNote] = ", self.notes[indexOfNote])
            
            self.subjects?[String(self.array[self.selectedSubject])] = self.notes
            
            UserDefaults.standard.set(self.subjects, forKey: "notesDictionary")
            
            self.Refresh()
            
        }
        
        tagAction5 = UIAlertAction(title: "Purple", style: .default) {
            
            UIAlertAction in
            
            self.notes[indexOfNote] = "Title: " + self.Titles[indexOfNote] + "🗅Note: " + self.noteData[indexOfNote] + "𛲁tag: PX"
            
            print("notes[indexOfNote] = ", self.notes[indexOfNote])
            
            self.subjects?[String(self.array[self.selectedSubject])] = self.notes
            
            UserDefaults.standard.set(self.subjects, forKey: "notesDictionary")
            
            self.Refresh()
            
        }
        
        tagAction6 = UIAlertAction(title: "Orange", style: .default) {
            
            UIAlertAction in
            
            self.notes[indexOfNote] = "Title: " + self.Titles[indexOfNote] + "🗅Note: " + self.noteData[indexOfNote] + "𛲁tag: OX"
            
            print("notes[indexOfNote] = ", self.notes[indexOfNote])
            
            self.subjects?[String(self.array[self.selectedSubject])] = self.notes
            
            UserDefaults.standard.set(self.subjects, forKey: "notesDictionary")
            
            self.Refresh()
            
        }
        
        deleteAlertController.addAction(cancelAction)
        
        deleteAlertController.addAction(deleteAction)
        
        tagAlertController.addAction(tagAction1)
        tagAlertController.addAction(tagAction2)
        tagAlertController.addAction(tagAction3)
        tagAlertController.addAction(tagAction4)
        tagAlertController.addAction(tagAction5)
        tagAlertController.addAction(tagAction6)
        
        tagAlertController.addAction(cancelAction)
        
        let nightModeOn = UserDefaults.standard.bool(forKey: "nightModeOn")
        
        if nightModeOn {
            
            view.backgroundColor = #colorLiteral(red: 0.1568627451, green: 0.1568627451, blue: 0.1568627451, alpha: 1)
            tableView.backgroundColor = #colorLiteral(red: 0.1568627451, green: 0.1568627451, blue: 0.1568627451, alpha: 1)
            //topMarginLabel.backgroundColor = #colorLiteral(red: 0.1568627451, green: 0.1568627451, blue: 0.1568627451, alpha: 1)
            oppositeTextColor = UIColor.white
            UIApplication.shared.statusBarStyle = .lightContent
            
        } else {
            
            view.backgroundColor = UIColor.white
            tableView.backgroundColor = UIColor.white
            //topMarginLabel.backgroundColor = UIColor.white
            oppositeTextColor = UIColor.black
            UIApplication.shared.statusBarStyle = .default
            
        }
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.startEditing))
        noteView.addGestureRecognizer(recognizer)
        
        let hashRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.addHash))
        hashRecognizer.numberOfTapsRequired = 2
        hashRecognizer.numberOfTouchesRequired = 2
        view.addGestureRecognizer(hashRecognizer)
        noteView.addGestureRecognizer(hashRecognizer)
        
        let hideKeyboardrecognizer = UITapGestureRecognizer(target: self, action: #selector(self.doneAll))
        hideKeyboardrecognizer.numberOfTapsRequired = 3
        view.addGestureRecognizer(hideKeyboardrecognizer)
        noteView.addGestureRecognizer(hideKeyboardrecognizer)
        
        let lpgr : UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress))
        lpgr.minimumPressDuration = 0.75
        lpgr.delaysTouchesBegan = true
        self.subjectCollectionView?.addGestureRecognizer(lpgr)
        
        addSubject.addTarget(self, action: #selector(self.addNewSubject), for: .touchUpInside)

        
        //noNotesBottomLabel.textColor = oppositeTextColor
        
    }
    
    @objc func handleLongPress(gestureRecognizer : UILongPressGestureRecognizer){
        
        if gestureRecognizer.state == UIGestureRecognizerState.began {
            
            return
            
        }
        
        if gestureRecognizer.state == UIGestureRecognizerState.ended {
            
            //HERE
            
            return
            
        }
        
        let p = gestureRecognizer.location(in: self.subjectCollectionView)
        
        if let indexPath : NSIndexPath = (self.subjectCollectionView?.indexPathForItem(at: p))! as NSIndexPath?{
            //do whatever you need to do
            
            //print(indexPath)/////
            
            let deleteSubjectAlertController = UIAlertController(title: "Delete Subject", message: "All the notes taken in this subject will get deleted! To confirm deletion enter the the first 5 letters of the alphabet", preferredStyle: .alert)
            
            deleteSubjectAlertController.addTextField { (textField) in
                
                textField.text = ""
                
                textField.clearButtonMode = .always
                
                textField.autocapitalizationType = .none
                
            }
            
            deleteSubjectAlertController.addAction(UIAlertAction(title: "Confirm", style: .destructive, handler: {
                
                (_) in
                
                let textField = deleteSubjectAlertController.textFields![0]
                
                if textField.text == "abcde" {
                    
                    //subjects?[String(array[indexPath.item])!]! = nil
                    
                    let x = String(self.array[indexPath.item])
                    
                    self.subjects?.removeValue(forKey: x)
                    
                    UserDefaults.standard.set(self.subjects, forKey: "notesDictionary")
                    
                    self.Refresh()
                    
                    self.tableView.reloadData()
                    
                    self.subjectCollectionView.reloadData()
                    
                } else {
                    
                    let v = UIAlertController(title: "Cancelled Deletion", message: "You entered the string incorrectly", preferredStyle: .alert)
                    
                    v.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(_) in}))
                    
                    self.present(v, animated: true, completion: nil)
                    
                }
                
            }))
            
            self.present(deleteSubjectAlertController, animated: true, completion: nil)
            
        }
        
        subjectCollectionView.reloadData()
        
    }
    
    @objc func addNewSubject() {
        
        let alert = UIAlertController(title: "Write the name of the Subject", message: "This will house all your notes", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            
            textField.text = "Subject Name"
            
            textField.clearButtonMode = .always
            
            textField.autocapitalizationType = .words
            
        }
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak alert] (_) in
            
            let textField = alert?.textFields![0]
            
            let keyExists = self.subjects?[(textField?.text)!] != nil
            
            if keyExists {
                
                let v = UIAlertController(title: "Oops", message: "You already have a subject called " + String(describing: textField?.text), preferredStyle: .alert)
                
                v.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(_) in}))
                
                self.present(v, animated: true, completion: nil)
                
            } else {
                
                self.subjects?[(textField?.text)!] = ["Title: New Note🗅Note: 𛲁tag: NX"]
                
                UserDefaults.standard.set(self.subjects, forKey: "notesDictionary")
                
                self.Refresh()
                
                self.subjectCollectionView.reloadData()
                
                self.tableView.reloadData()
                
            }
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @objc func startEditing() {
        
        isNewNote = UserDefaults.standard.bool(forKey: "isNewNote")
        
        if /*noteActionsView.isHidden*/true == true {
            
            if noteView.text == "(Empty Note)" {
                
                noteView.text = ""
                
            }
            
            if titleLabel.text == "" {
                
                if isNewNote {
                    
                    titleLabel.text = "New Note"
                    
                } else {
                    
                    titleLabel.text = "No Title"
                    
                }
                
            }
            
            noteView.isEditable = true
            noteView.becomeFirstResponder()
            hashPaste()
            Refresh()
            
            noteView.textColor = UIColor.black
            
        }/* else {
            
            noteActionsView.isHidden = true
            
        }*/
        
    }
    
    func hashPaste() {
        
        if !(titleLabel.text == nil) {
            
            let pasteboardString : String? = UIPasteboard.general.string
            
            if !(pasteboardString == nil) {
                
                titleLabel.text = titleLabel!.text?.replacingOccurrences(of: "#Paste", with: pasteboardString!)
                
                noteView.text = noteView.text.replacingOccurrences(of: "#Paste", with: pasteboardString!)
                
            } else {
                
                titleLabel.text = titleLabel!.text?.replacingOccurrences(of: "#Paste", with: "")
                
                noteView.text = noteView.text.replacingOccurrences(of: "#Paste", with: "")
                
            }
            
        }
        
    }

    
    override func viewWillAppear(_ animated: Bool) {
        
        self.tableView.reloadData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        _ = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.CheckForDelete), userInfo: nil, repeats: true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func breakArray() {
        
        array = Array(subjects!.keys)
        
        subjects = UserDefaults.standard.dictionary(forKey: "notesDictionary")
        
        importNotes = subjects![String(array[selectedSubject])] as! [String]//UserDefaults.standard.array(forKey: "notes")
        
        //Changed This
        
        if !((importNotes.count) > 0) {
            
            importNotes = []
            
            tableView.isHidden = true
            
        }
        
        notes = importNotes
        
        for i in 0 ..< notes.count {
            
            var iTitle : String = notes[i]
            
            var iNote : String = notes[i]
            
            let iToDel = iTitle.index(of: "🗅")
            
            iTitle = iTitle.substring(to: iToDel!)
            
            iTitle = String(iTitle.dropFirst(7))
            
            if iTitle == "" {
                
                iTitle = "No Title"
                
            }
            
            Titles.append(iTitle)
            
            iNote = iNote.substring(from: iToDel!)
            
            iNote = String(iNote.dropFirst(7))
            
            iNote = String(iNote.dropLast(8))
            
            if iNote == "" {
                
                iNote = "(Empty Note)"
                
            }
            
            noteData.append(iNote)
            
        }
        
    }
    
    func Refresh() {
        
        subjects = UserDefaults.standard.dictionary(forKey: "notesDictionary")
        
        array = Array(subjects!.keys)
        
        importNotes = subjects![String(array[selectedSubject])] as! [String]//UserDefaults.standard.array(forKey: "notes")
        
        //Changed This
        
        if !((importNotes.count) > 0) {
            
            importNotes = []
            
            tableView.isHidden = true
            
        }
        
        notes = importNotes
        
        breakArray()
        
        if !(notes.count > 0) {
            
            tableView.isHidden = true
            
        } else {
            
            tableView.isHidden = false
            
        }
        
        ///UserDefaults.standard.set(notes, forKey: "notes")
        
        subjects?[String(array[selectedSubject])] = notes
        
        UserDefaults.standard.set(self.subjects, forKey: "notesDictionary")
        
        self.tableView.reloadData()
        
    }
    
    func refreshNote() {
        
        titleLabel.resignFirstResponder()
        
        if !(indexSavedLast == -1) {
            
            //print("LOADING")
            
            let indexOfNote = indexSavedLast
            
            //titleLabel.text = Titles[indexOfNote]
            
            //noteView.text = noteData[indexOfNote]
            
            print("Selected Subject:", selectedSubject)
            
            //print(notes)
            
            //print(indexOfNote)
            
            var noteTag = notes[indexOfNote] as String
            
            let indexOfTag = noteTag.index(of: "𛲁")
            
            noteTag = notes[indexOfNote].substring(from: indexOfTag!)
            
            noteTag = String(noteTag.dropFirst(6))
            
            if isNewNote {
                
                if titleLabel.text == "" {
                    
                    titleLabel.text = "New Note"
                    
                }
                
            } else {
                
                if titleLabel.text == "" {
                    
                    titleLabel.text = "No Title"
                    
                }
                
            }
            
            //tagTitle()
            
            subjects = UserDefaults.standard.dictionary(forKey: "notesDictionary")
            
            array = Array(subjects!.keys)
            
            importNotes = subjects![String(array[selectedSubject])] as! [String]//UserDefaults.standard.array(forKey: "notes")
            
            //Changed This
            
            notes = importNotes
            
            Titles[indexOfNote] = titleLabel.text!.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
            
            noteData[indexOfNote] = noteView.text.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
            
            notes[indexOfNote] = "Title: " + Titles[indexOfNote] + "🗅Note: " + noteData[indexOfNote] + "𛲁tag: " + noteTag
            
            print("notes[indexOfNote] = ", notes[indexOfNote])
            
            //Title: The Note Title🗅Note: Just some text in here𛲁tag: GX
            
            ///UserDefaults.standard.set(notes, forKey: "notes")
            
            subjects?[String(array[selectedSubject])] = notes
            
            UserDefaults.standard.set(self.subjects, forKey: "notesDictionary")
            
            tableView.reloadData()
            
            Refresh()
            
            //textColorManager()

            
        } else {
            
            
            
        }
        
        
    }

    
    //tableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.notes.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //print("RUN")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NoteCell
        
        cell.label.text = String(self.notes[(indexPath as NSIndexPath).row]).components(separatedBy: "🗅")[0].components(separatedBy: "Title: ")[1]
        
        cell.label.font = UIFont(name: ".SFFont", size: 20)
        
        var noteTag = notes[(indexPath as NSIndexPath).row] as String
        
        let indexOfTag = noteTag.index(of: "𛲁")
        
        noteTag = notes[(indexPath as NSIndexPath).row].substring(from: indexOfTag!)
        
        noteTag = String(noteTag.dropFirst(6))
        
        let bgColorView = UIView()
        
        if noteTag == "NX" {
            
            cell.label.textColor = #colorLiteral(red: 0.3529411765, green: 0.7843137255, blue: 0.9803921569, alpha: 1)
            cell.tagCircleLayer.backgroundColor = #colorLiteral(red: 0.3529411765, green: 0.7843137255, blue: 0.9803921569, alpha: 1).cgColor
            cell.tagCircleLayer.borderColor = UIColor.clear.cgColor
            cell.tagCircleLayer.borderWidth = 0
            cell.discIndicator.image = #imageLiteral(resourceName: "Disclosure Indicator")
            bgColorView.backgroundColor = #colorLiteral(red: 0.3529411765, green: 0.7843137255, blue: 0.9803921569, alpha: 1)
            
        } else if noteTag == "BX" {
            
            cell.label.textColor = #colorLiteral(red: 1, green: 0, blue: 0.501960814, alpha: 1)
            cell.tagCircleLayer.backgroundColor = #colorLiteral(red: 1, green: 0, blue: 0.501960814, alpha: 1).cgColor
            cell.tagCircleLayer.borderColor = UIColor.clear.cgColor
            cell.tagCircleLayer.borderWidth = 0
            cell.discIndicator.image = #imageLiteral(resourceName: "Disclosure Indicator Pink.png")
            bgColorView.backgroundColor = #colorLiteral(red: 1, green: 0, blue: 0.501960814, alpha: 1)
            
        } else if noteTag == "RX" {
            
            cell.label.textColor = #colorLiteral(red: 0.8941176471, green: 0.1450980392, blue: 0.0862745098, alpha: 1)
            cell.tagCircleLayer.backgroundColor = #colorLiteral(red: 0.8941176471, green: 0.1450980392, blue: 0.0862745098, alpha: 1).cgColor
            cell.tagCircleLayer.borderColor = UIColor.clear.cgColor
            cell.tagCircleLayer.borderWidth = 0
            cell.discIndicator.image = #imageLiteral(resourceName: "Disclosure Indicator Red.png")
            bgColorView.backgroundColor = #colorLiteral(red: 0.8941176471, green: 0.1450980392, blue: 0.0862745098, alpha: 1)
            
        } else if noteTag == "GX" {
            
            cell.label.textColor = #colorLiteral(red: 0, green: 0.8196078431, blue: 0.08235294118, alpha: 1)
            cell.tagCircleLayer.backgroundColor = #colorLiteral(red: 0, green: 0.8196078431, blue: 0.08235294118, alpha: 1).cgColor
            cell.tagCircleLayer.borderColor = UIColor.clear.cgColor
            cell.tagCircleLayer.borderWidth = 0
            cell.discIndicator.image = #imageLiteral(resourceName: "Disclosure Indicator Green.png")
            bgColorView.backgroundColor = #colorLiteral(red: 0, green: 0.8196078431, blue: 0.08235294118, alpha: 1)
            
        } else if noteTag == "PX" {
            
            cell.label.textColor = #colorLiteral(red: 0.3294117647, green: 0, blue: 0.9215686275, alpha: 1)
            cell.tagCircleLayer.backgroundColor = #colorLiteral(red: 0.3294117647, green: 0, blue: 0.9215686275, alpha: 1).cgColor
            cell.tagCircleLayer.borderColor = UIColor.clear.cgColor
            cell.tagCircleLayer.borderWidth = 0
            cell.discIndicator.image = #imageLiteral(resourceName: "Disclosure Indicator Purple.png")
            bgColorView.backgroundColor = #colorLiteral(red: 0.3294117647, green: 0, blue: 0.9215686275, alpha: 1)
            
        } else if noteTag == "OX" {
            
            cell.label.textColor = #colorLiteral(red: 0.9333333333, green: 0.6274509804, blue: 0.1058823529, alpha: 1)
            cell.tagCircleLayer.backgroundColor = #colorLiteral(red: 0.9346159697, green: 0.6284804344, blue: 0.1077284366, alpha: 1).cgColor
            cell.tagCircleLayer.borderColor = UIColor.clear.cgColor
            cell.tagCircleLayer.borderWidth = 0
            cell.discIndicator.image = #imageLiteral(resourceName: "Disclosure Indicator Orange.png")
            bgColorView.backgroundColor = #colorLiteral(red: 0.9346159697, green: 0.6284804344, blue: 0.1077284366, alpha: 1)
            
        }
        
        cell.selectedBackgroundView = bgColorView
        
        cell.backgroundColor = view.backgroundColor
        
        var indexString : String = String(describing: indexPath)
        
        indexString = String(indexString.dropLast())
        
        indexString = String(indexString.dropFirst(4))
        
        cell.indexOfCell = Int(indexString)!
        
        cell.descLabel.text = String(self.notes[(indexPath as NSIndexPath).row]).components(separatedBy: "𛲁tag:")[0].components(separatedBy: "🗅Note: ")[1].replacingOccurrences(of: "\n", with: "; ")
        
        cell.descLabel.textColor = oppositeTextColor
        
        tableView.rowHeight = 75
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        doneAll() 
        
        Refresh()
        
        //print("DID SELECT")
        
        var indexString : String = String(describing: indexPath)
        
        indexString = String(indexString.dropLast())
        
        indexString = String(indexString.dropFirst(4))
        
        UserDefaults.standard.set(Int(indexString), forKey: "indexInt")
        
        indexSavedLast = Int(indexString)!
        
        loadData(indexValue: indexSavedLast)
        
    }
    
    @objc func addClicked() {
        
        refreshNote()
        
        Refresh()
        
        //let nTemp = String(array[selectedSubject])//HERE
        
        notes.insert("Title: New Note🗅Note: 𛲁tag: NX", at: 0)
        
        indexSavedLast = 0
        
        titleLabel.text = "New Note"
        
        noteView.text = ""
        
        UserDefaults.standard.set(true, forKey: "isNewNote")
        
        ///UserDefaults.standard.set(notes, forKey: "notes")
        
        subjects?[String(array[selectedSubject])] = notes
        
        UserDefaults.standard.set(self.subjects, forKey: "notesDictionary")
        
        UserDefaults.standard.set(Int(0), forKey: "indexInt")
        
        Refresh()
        
    }
    
    @objc func CheckForDelete() {
        
        let DeleteAnything = UserDefaults.standard.bool(forKey: "Delete?")
        
        if DeleteAnything {
            
            self.present(deleteAlertController, animated: true, completion: {
                
                UserDefaults.standard.set(false, forKey: "Delete?")
                
            })
            
        }
        
        let TagAnything = UserDefaults.standard.bool(forKey: "Tag?")
        
        if TagAnything {
            
            self.present(tagAlertController, animated: true, completion: {
                
                UserDefaults.standard.set(false, forKey: "Tag?")
                
            })
            
        }
        
    }
    
    func confirmDelete() {
        
        refreshNote()
        
        let indexDelete = UserDefaults.standard.integer(forKey: "indexToDelete")
        
        notes.remove(at: indexDelete)
        
        if notes.count == 0 {
            
            let x = String(self.array[indexSavedLast])
            
            self.subjects?.removeValue(forKey: x)
            
        } else {
            
            subjects?[String(array[selectedSubject])] = notes
            
            selectedSubject = 0
            
        }
        
        ///UserDefaults.standard.set(notes, forKey: "notes")
        
        UserDefaults.standard.set(self.subjects, forKey: "notesDictionary")
        
        if indexSavedLast == indexDelete {
            
            indexSavedLast = -1
            
        }
        
        Refresh()
        
        tableView.reloadData()
        
    }
    
    func loadData(indexValue: Int) {
        
        let note = notes[indexValue]
        
        var iTitle : String = note
            
        var iNote : String = note
            
        let iToDel = iTitle.index(of: "🗅")
            
        iTitle = iTitle.substring(to: iToDel!)
            
        iTitle = String(iTitle.dropFirst(7))
            
        if iTitle == "" {
                
            iTitle = "No Title"
                
        }
            
        Titles.append(iTitle)
            
        iNote = iNote.substring(from: iToDel!)
            
        iNote = String(iNote.dropFirst(7))
        
        iNote = String(iNote.dropLast(8))
        
        if iNote == "" {
            
            iNote = "(Empty Note)"
            
        }
        
        noteData.append(iNote)

        titleLabel.text = iTitle
        
        noteView.text = iNote
        
        indexSavedLast = indexValue
        
        var noteTag = notes[indexValue] as String
        
        let indexOfTag = noteTag.index(of: "𛲁")
        
        noteTag = notes[indexValue].substring(from: indexOfTag!)
        
        noteTag = String(noteTag.dropFirst(6))
        
        if noteTag == "NX" {
            
            titleLabel.textColor = #colorLiteral(red: 0.3529411765, green: 0.7843137255, blue: 0.9803921569, alpha: 1)
            
        } else if noteTag == "BX" {
            
            titleLabel.textColor = #colorLiteral(red: 1, green: 0, blue: 0.501960814, alpha: 1)
            
        } else if noteTag == "RX" {
            
            titleLabel.textColor = #colorLiteral(red: 0.8941176471, green: 0.1450980392, blue: 0.0862745098, alpha: 1)
            
        } else if noteTag == "GX" {
            
            titleLabel.textColor = #colorLiteral(red: 0, green: 0.8196078431, blue: 0.08235294118, alpha: 1)
            
        } else if noteTag == "PX" {
            
            titleLabel.textColor = #colorLiteral(red: 0.3294117647, green: 0, blue: 0.9215686275, alpha: 1)
            
        } else if noteTag == "OX" {
            
            titleLabel.textColor = #colorLiteral(red: 0.9346159697, green: 0.6284804344, blue: 0.1077284366, alpha: 1)
            
        }
        
        refreshNote()
        
    }
    
    @objc func addHash() {
        
        if isTitleActive == true {
            
            titleLabel.text = titleLabel.text! + "#"
            
        } else {
            
            noteView.isEditable = true
            noteView.becomeFirstResponder()
            noteView.text = noteView.text + "#"
            
        }
        
    }
    
    @objc func doneAll() {
        
        noteView.resignFirstResponder()
        
        titleLabel.resignFirstResponder()
        
        noteView.isEditable = false
        
        if isNewNote {
            
            if titleLabel.text == "" {
                
                titleLabel.text = "New Note"
                
            }
            
        } else {
            
            if titleLabel.text == "" {
                
                titleLabel.text = "No Title"
                
            }
            
        }
        
        if noteView.text == "" {
            
            noteView.text = "(Empty Note)"
            
        }
        
        Refresh()
        
        refreshNote()
        
        Refresh()
        
    }
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.subjects!.count
        
    }
    
    func randColor(index: Int) -> UIColor {
        
        var x = index //arc4random_uniform(5)
        
        while x > 5 {
            
            x = x - 5
            
        }
        
        if x == 0 {
            
            return #colorLiteral(red: 0.3529411765, green: 0.7843137255, blue: 0.9803921569, alpha: 1)
            
        } else if x == 1{
            
            return #colorLiteral(red: 0, green: 0.8196078431, blue: 0.08235294118, alpha: 1)
            
        } else if x == 2{
            
            return #colorLiteral(red: 1, green: 0, blue: 0.501960814, alpha: 1)
            
        } else if x == 3{
            
            return #colorLiteral(red: 0.9333333333, green: 0.6274509804, blue: 0.1058823529, alpha: 1)
            
        } else if x == 4{
            
            return #colorLiteral(red: 0.3294117647, green: 0, blue: 0.9215686275, alpha: 1)
            
        } else {
            
            return #colorLiteral(red: 0.8941176471, green: 0.1450980392, blue: 0.0862745098, alpha: 1)
            
        }
        
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reuseCollectionViewCell", for: indexPath as IndexPath) as! subjectCollectionViewCell
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        
        array = Array(subjects!.keys)
        
        cell.myLabel.text = array[indexPath.item]
        
        cell.layer.borderWidth = 2
        
        cell.layer.cornerRadius = 5
        
        if indexPath.item == selectedSubject {
            
            cell.myLabel.font = UIFont.boldSystemFont(ofSize: 17)
            
            cell.backgroundColor = randColor(index: indexPath.item)
            
            cell.layer.borderWidth = 0
            
            cell.myLabel.textColor = UIColor.white
            
        } else {
            
            cell.myLabel.font = UIFont.systemFont(ofSize: 17)
            
            cell.backgroundColor = UIColor.white
            
            let x = randColor(index: indexPath.item)
            
            cell.myLabel.textColor = x
            
            cell.layer.borderColor = x.cgColor
            
        }
        
        return cell
    
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
        
    }
    
    var selectedSubject = 0
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        selectedSubject = indexPath.item
        
        //print(subjects?[String(array[indexPath.item])!]!)
        
        subjectCollectionView.reloadData()
        
        importNotes = subjects![String(array[selectedSubject])] as! [String]
        
        //CHANGED THIS
        
        //importNotes = subjects![String(array[selectedSubject])!]! as! [String]//UserDefaults.standard.array(forKey: "notes")
        
        notes = importNotes
        
        loadData(indexValue: 0)
        
        self.tableView.reloadData()
        
        refreshNote()
        
        print("HERE:", subjects as Any)
        
    }

}

