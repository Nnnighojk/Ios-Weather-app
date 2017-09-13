//
//  WeatherViewController.swift
//  Finalweather
//
//  Created by Nivedita Nighojkar on 6/28/17.
//  Copyright © 2017 Nivedita Nighojkar. All rights reserved.
//

import UIKit

protocol DataSentDelegate {
    func userDidEnterData(obj: Weather)
    
}

class WeatherViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var cityLbl: UILabel!
    
    var degree: Int!
    var condition: String!
    var imgURL: String!
    var city: String!
    var delegate1: DataSentDelegate? = nil
    
    
    var exists: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        self.cityLbl.isHidden = true

        // Do any additional setup after loading the view.
    }

    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let urlRequest = URLRequest(url: URL(string: "http://api.apixu.com/v1/current.json?key=23c50a7b2a7a435789843131171606&q=\(searchBar.text!.replacingOccurrences(of: " ", with: "%20"))")!)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            
            if error == nil {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String : AnyObject]
                    
                    if let current = json["current"] as? [String : AnyObject] {
                        
                        if let temp = current["temp_c"] as? Int {
                            self.degree = temp
                        }
                        if let condition = current["condition"] as? [String : AnyObject] {
                            self.condition = condition["text"] as! String
                            let icon = condition["icon"] as! String
                            self.imgURL = "http:\(icon)"
                        }
                    }
                    if let location = json["location"] as? [String : AnyObject] {
                        self.city = location["name"] as! String
                    }
                    
                    if let _ = json["error"] {
                        self.exists = false
                    }
                    
                    DispatchQueue.main.async {
                        if self.exists
                        {
                            //self.cityLbl.isHidden = false
                           // self.degreeLbl.isHidden = false
                           // self.conditionLbl.isHidden = false
                           // self.imgView.isHidden = false
                           // self.degreeLbl.text = "\(self.degree.description)°"
                           self.cityLbl.text = self.city
                           // self.conditionLbl.text = self.condition
                           // self.imgView.downloadImage(from: self.imgURL!)
                            let city_data = self.city
                            let degree_data = self.degree
                            
                            let obj :Weather = Weather()
                            
                            obj.city = city_data!;
                            obj.degree = degree_data!
                            //print(obj.city)
                            //print(obj.degree)

                            self.navigationController?.popViewController(animated: true)
                            
                            self.delegate1?.userDidEnterData(obj: obj)
                            //print (self.delegate1)
                            
                            //self.dismiss(animated: true, completion: nil)
                        }
                        else
                        {
                            self.cityLbl.isHidden = false
                           // self.degreeLbl.isHidden = true
                           // self.conditionLbl.isHidden = true
                           // self.imgView.isHidden = true
                            self.cityLbl.text = "No matching city found"
                            self.exists = true
                        }
                    }
                    
                    
                } catch let jsonError {
                    print(jsonError.localizedDescription)
                }
            }
        }
        
        task.resume()
    }
    

        
}

   


