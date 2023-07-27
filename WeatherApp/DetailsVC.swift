//
//  DetailsVC.swift
//  WeatherApp
//
//  Created by İbrahim AY on 17.07.2023.
//

import UIKit
import CoreData

class DetailsVC: UIViewController {
    
    @IBOutlet weak var sehirLabel: UILabel!
    @IBOutlet weak var dereceLabel: UILabel!
    @IBOutlet weak var ruzgarLabel: UILabel!
    @IBOutlet weak var saveBtn: UIButton!
    
    var ruzgar = ""
    var sehir = ""
    var chosenCity = ""
    var chosenCityID = UUID()
    
    var gelenisim : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !chosenCity.isEmpty {
            
            saveBtn.isHidden = true
            saveBtn.isEnabled = false
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Sehirler")
            let idString = chosenCityID.uuidString
            fetchRequest.predicate = NSPredicate(format: "id = %@", idString)
            fetchRequest.returnsObjectsAsFaults = false
            
            do {
                let results = try context.fetch(fetchRequest)
                if results.count > 0 {
                    for result in results as! [NSManagedObject] {
                        if let city = result.value(forKey: "sehir") as? String {
                            sehirLabel.text = city
                            sehir = city
                        }
                    }
                }
            } catch {
                print("Error")
            }
            
        }
        
        navigationController?.navigationBar.tintColor = UIColor.white

        sehirLabel.text = sehir
        jsonOperation(sehir: sehir)
        weeklyJsonOperation()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func jsonOperation (sehir : String) {
        
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(sehir)&appid=81553a114bc16e43e474d44f39fe09b3") else { return }
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            } else {
                
                if let newData = data {
                    
                    do {
                        let jsonResponse = try JSONSerialization.jsonObject(with: newData, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                        if let main = jsonResponse["main"] as? NSDictionary {
                            if let temp = main["temp"] as? Double {
                                let state = temp - 273.15
                                let derece = Int(state)
                                DispatchQueue.main.async {
                                    self.dereceLabel.text = String(derece)
                                }
                            }
                        }
                        
                        if let wind = jsonResponse["wind"] as? NSDictionary {
                            if let speed = wind["speed"] as? Double {
                                DispatchQueue.main.async {
                                    self.ruzgarLabel.text = "\(String(speed)) km/sa"
                                }
                            }
                        }
                        
                    } catch {
                        print("Error")
                    }
                    
                }
                
            }
            
            
        }
        task.resume()
    }
    
    func weeklyJsonOperation() {
        
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/forecast?lat=36.8979091&lon=30.6357048&appid=81553a114bc16e43e474d44f39fe09b3") else { return }
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if error != nil {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            } else {
                guard let newData = data else { return }
                DispatchQueue.main.async {
                    let decoder = JSONDecoder()
                    do {
                        let model = try decoder.decode(List.self, from: newData)
                        let mainClass = model.main
                        let temps = mainClass.temp
                        print(temps)
                    } catch {
                        print("Error")
                    }
                }
            }
            
        }
        task.resume()
    }

    @IBAction func saveButton(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newCity = NSEntityDescription.insertNewObject(forEntityName: "Sehirler", into: context)
        newCity.setValue(sehir, forKey: "sehir")
        newCity.setValue(UUID(), forKey: "id")
        
        do {
            try context.save()
        } catch {
            print("Error")
        }
        
        NotificationCenter.default.post(name: NSNotification.Name("newData"), object: nil)
        
        let tableViewVC = storyboard?.instantiateViewController(withIdentifier: "toTableViewVC") as! TableViewVC
        tableViewVC.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButton))
        self.navigationController?.pushViewController(tableViewVC, animated: true)
        
    }
    
    @objc func addButton () {
        performSegue(withIdentifier: "toViewController", sender: nil)
    }
    
}
