//
//  toDoViewController.swift
//  School
//
//  Created by Tareq El Dandachi on 5/13/17.
//  Copyright © 2017 Tareq El Dandachi. All rights reserved.
//

import UIKit

class toDoViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate  {

    var iArray = UserDefaults.standard.array(forKey: "toDos")
    
    var array = [""]
    
    var highlighted = -1
    
    @IBOutlet var toDoCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if iArray == nil {
            
            UserDefaults.standard.set([], forKey: "toDos")
            
            iArray = []
            
        }
        
        array = iArray as! [String]
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapOut))
        
        self.toDoCollectionView.backgroundView = UIView(frame:self.toDoCollectionView.bounds)
        self.toDoCollectionView.backgroundView!.addGestureRecognizer(tapGestureRecognizer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func tapOut() {
        
        print("TAP OUT")
        
        highlighted = -1
        
        toDoCollectionView.reloadData()
        
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
        return array.count + 1
    
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "toDoCollectionViewCell", for: indexPath as IndexPath) as! toDoCollectionViewCell
        
        //cell.imgView.contentMode = .center
        
        //cell.layer.borderColor = #colorLiteral(red: 0.3529411765, green: 0.7843137255, blue: 0.9803921569, alpha: 1).cgColor
        
        //cell.label.textColor = #colorLiteral(red: 0.3529411765, green: 0.7843137255, blue: 0.9803921569, alpha: 1)
        
        //cell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        //cell.imgView.isHidden = false
        
        if !(indexPath.item == array.count) {
            
            cell.layer.borderWidth = 0
            
            cell.label.text = String(describing: array[indexPath.item])
            
            if indexPath.item == highlighted {
                
                if cell.label.text?.characters.first == "✓" {
                    
                    cell.label.text! = "✖︎" + String(cell.label.text!.characters.dropFirst())
                    
                    cell.backgroundColor = #colorLiteral(red: 0.3529411765, green: 0.7843137255, blue: 0.9803921569, alpha: 1)
                    
                } else {
                    
                    cell.label.text! = "✓ " + cell.label.text!
                    
                    cell.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
                    
                }
                
                cell.label.textColor = UIColor.white
                
            } else {
                
                if cell.label.text?.characters.first == "✓" {
                    
                    cell.backgroundColor = #colorLiteral(red: 0, green: 0.8196078431, blue: 0.08235294118, alpha: 1)
                    
                } else {
                    
                    cell.label.text! = "∙ " + cell.label.text!
                    
                    cell.backgroundColor = #colorLiteral(red: 0.9764705882, green: 0.4117647059, blue: 0.05490196078, alpha: 1)//#colorLiteral(red: 0.8941176471, green: 0.1450980392, blue: 0.0862745098, alpha: 1)
                    
                }
                
                cell.label.textColor = UIColor.white
                
            }
            
        } else {
            
            cell.layer.borderWidth = 1
            
            cell.label.text = "+ Add"
            
            cell.backgroundColor = UIColor.white
            
            cell.layer.borderColor = #colorLiteral(red: 0, green: 0.8196078431, blue: 0.08235294118, alpha: 1).cgColor
            
            cell.label.textColor = #colorLiteral(red: 0, green: 0.8196078431, blue: 0.08235294118, alpha: 1)
            
            //cell.imgView.image = #imageLiteral(resourceName: "Plus")
            
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if !(indexPath.item == array.count) {
            
            if highlighted != -1 {
                
                if indexPath.item == highlighted {
                    
                    if array[indexPath.item].characters.first == "✓" {
                        
                        array.remove(at: indexPath.item)
                        
                        UserDefaults.standard.set(array, forKey: "toDos")
                        
                    } else {
                        
                        array[indexPath.item] = "✓ " + array[indexPath.item]
                        
                        UserDefaults.standard.set(array, forKey: "toDos")
                        
                    }
                    
                    highlighted = -1
                    
                } else {
                    
                    highlighted = indexPath.item
                    
                }
                
            } else {
                
                highlighted = indexPath.item
                
            }
            
        } else {
            
            let alertController = UIAlertController(title: "Create Reminder", message: "Enter the title of your assignment", preferredStyle: .alert)
            
            alertController.addTextField { (textField) in
                
                textField.text = ""
                
                textField.clearButtonMode = .always
                
                textField.autocapitalizationType = .none
                
            }
            
            alertController.addAction(UIAlertAction(title: "Confirm", style: .destructive, handler: {
                
                (_) in
                
                let textField = alertController.textFields![0]
                
                if textField.text?.replacingOccurrences(of: " ", with: "") != "" {
                    
                    self.array.insert(textField.text!, at: self.array.count)
                    
                    UserDefaults.standard.set(self.array, forKey: "toDos")
                    
                    collectionView.reloadData()
                    
                } else {
                    
                    let v = UIAlertController(title: "No Text", message: "You need to put a label for your diary item so you remember it!", preferredStyle: .alert)
                    
                    v.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(_) in}))
                    
                    self.present(v, animated: true, completion: nil)
                    
                }
                
            }))
            
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
            
        }
        
        toDoCollectionView.reloadData()
        
    }

}
