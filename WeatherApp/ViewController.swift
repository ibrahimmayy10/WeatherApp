//
//  ViewController.swift
//  WeatherApp
//
//  Created by İbrahim AY on 17.07.2023.
//

import UIKit

class ViewController: UIViewController {
    
    var sehir = ""
    
    @IBOutlet weak var sehirTextField: UITextField!
    
    var isim = "İbrahim"
        
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.tintColor = .systemBlue
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer)

    }
    
    @objc func hideKeyboard () {
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        sehirTextField.text = ""
    }

    @IBAction func showButton(_ sender: Any) {
//        let detailsVC = DetailsVC()
//        detailsVC.gelenisim = isim
//        present(detailsVC, animated: true, completion: nil)
        performSegue(withIdentifier: "toDetailsVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        sehir = sehirTextField.text!
        if !sehir.isEmpty {
            if segue.identifier == "toDetailsVC" {
                let destinationVC = segue.destination as! DetailsVC
                destinationVC.sehir = sehir
            }
        } else {
            print("boş")
        }
    }
    
}

