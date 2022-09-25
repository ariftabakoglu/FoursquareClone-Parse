//
//  PlacesVC.swift
//  Pods
//
//  Created by Arif TABAKOĞLU on 23.09.2022.
//

import UIKit
import Parse

class PlacesVC: UIViewController{

    @IBOutlet weak var tableView: UITableView!
    
    var placeNameArray = [String]()
    var placeIdArray = [String]()
    
    var selectedPlaceId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonClicked))
        
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Log Out", style: UIBarButtonItem.Style.plain, target: self, action: #selector(logOutButtonClicked))
        
        navigationController?.navigationBar.tintColor = .white
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getDataFromParse()
    }
    
    func getDataFromParse(){
        
        let query = PFQuery(className: "Places")
        query.findObjectsInBackground { objects, error in
            
            if error != nil{
                
                self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                
            }else{
                
                if objects != nil{
                    
                    self.placeIdArray.removeAll(keepingCapacity: false)
                    self.placeNameArray.removeAll(keepingCapacity: false)
                    
                    for object in objects!{
                        if let placeId = object.objectId {
                            if let placeName = object.object(forKey: "name") as? String {
                                self.placeNameArray.append(placeName)
                                self.placeIdArray.append(placeId)
                            }
                        }
                    }
                        
                    self.tableView.reloadData()
                
                }
            }
        }
        
    }
    
    @objc func addButtonClicked(){
        
        self.performSegue(withIdentifier: "toAddPlacesVC", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsVC"{
            let destinationVC = segue.destination as! DetailsVC
            destinationVC.choosenPlaceId = selectedPlaceId
        }
    }

    
    @objc func logOutButtonClicked(){
        
        PFUser.logOutInBackground { error in
            if error != nil {
                
                self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error")
                
            }else{
                self.performSegue(withIdentifier: "toSignUpVC", sender: nil)
            }
        }
        
    }
    
    func makeAlert(titleInput:String, messageInput:String){
        
        let alertController = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel)
        alertController.addAction(okButton)
        self.present(alertController, animated: true)
    }

}


extension PlacesVC : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeNameArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        cell.textLabel?.text = placeNameArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedPlaceId = placeIdArray[indexPath.row]
        self.performSegue(withIdentifier: "toDetailsVC", sender: nil)
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAct = UIContextualAction(style: .destructive, title: "Delete") { contextualAction, view, boolValue in
            
                
            DispatchQueue.main.async {
                
                let query = PFQuery(className: "Places")
                query.whereKey("objectId", equalTo: self.placeIdArray[indexPath.row])
                query.findObjectsInBackground { objects, error in
                    
                    if error != nil {
                        
                        self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                        
                    }else{
                        
                        if objects != nil{
                            
                            if objects!.count > 0{
                                
                                self.placeNameArray.removeAll(keepingCapacity: false)
                                self.placeIdArray.removeAll(keepingCapacity: false)
                                
                                if let choosenPlaceObject = objects?[0]{
                                    
                                    choosenPlaceObject.deleteInBackground { result, error in
                                        
                                        if error != nil {
                                            
                                            self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                                            
                                        }
                                        
                                        self.tableView.reloadData()
                                        
                                        self.makeAlert(titleInput: "Success", messageInput: "The deletion was success.")
                                        print("result:\(result)")
                                        
                                    }
                                }
                            }
                        }
                        
                    }
                }
            }
                
            }
            
            
   
        return UISwipeActionsConfiguration(actions: [deleteAct])
        
    }
    
}
