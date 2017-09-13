//
//  ViewController.swift
//  Finalweather
//
//  Created by Nivedita Nighojkar on 6/27/17.
//  Copyright © 2017 Nivedita Nighojkar. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource, DataSentDelegate  {

    @IBOutlet weak var locationbtn: UIButton!
    @IBOutlet weak var citybtn: UIButton!
    @IBOutlet weak var ctable: UITableView!
    
    let locationManager = CLLocationManager()
    var currentLocation : CLLocation!
    var degree: Int!
    var condition: String!
    var imgURL: String!
    var city: String!
    var imageArray = [] as NSMutableArray
    
    var exists: Bool = true
    
    struct cellData {
        let text1 : String!
        let text2 : Int!
       // let image : UIImage!
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        // gets rid of any additional rows
        self.ctable.tableFooterView=UIView()
        
        self.ctable.register(UINib(nibName: "WeatherCell", bundle: nil), forCellReuseIdentifier: "UICustomTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        
    }

    
    
   
    @IBAction func locationbtn(_ sender: Any) {
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // You can change the location accuracy here.
        locationManager.requestWhenInUseAuthorization()
        self.locationAuthStatus()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        
    }
    

    func locationAuthStatus()  {
        
        
        var ret:String=""
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            
            currentLocation = locationManager.location
            //print(currentLocation.coordinate.latitude)
            //print(currentLocation.coordinate.longitude)
            
        } else {
            locationManager.requestWhenInUseAuthorization()
            
        }
        
        let location = CLLocation(latitude: 18.5204  , longitude: 73.8567  )
        
        //changed!!!
        //print(location)
        
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            // print(location)
            
            if error != nil {
                print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
            }
            
            if (placemarks?.count)! > 0 {
                let pm = placemarks?[0]
                //print(pm?.locality ?? location) // this is the line for debugging
                
                ret = (pm?.locality ?? "Test")
        
                self.setLocationWeather(userLocation: ret)
                
                
            }
            else {
                print("Problem with the data received from geocoder")
            
                self.setLocationWeather(userLocation:"")
                
            }
        })
        
        
    }
    
    func setLocationWeather(userLocation:String)
    {
        
        let urlRequest = URLRequest(url: URL(string: "http://api.apixu.com/v1/current.json?key=23c50a7b2a7a435789843131171606&q=\(userLocation.replacingOccurrences(of: " ", with: "%20"))")!)
        
        let task = URLSession.shared.dataTask (with: urlRequest) { (data, response, error) in
            
        
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
                           // self.cityLbl.isHidden = false
                           // self.degreeLbl.isHidden = false
                           // self.conditionLbl.isHidden = false
                           // self.imgView.isHidden = false
                            //self.degreeLbl.text = "\(self.degree.description)°"
                            //self.cityLbl.text = self.city
                            //self.conditionLbl.text = self.condition
                            //self.imgView.downloadImage(from: self.imgURL!)
                            self.getTableView(city:self.city, degree: self.degree)
                        }
                }
                    
                    
                } catch let jsonError {
                    print(jsonError.localizedDescription)
                }
            }
        }
        
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return imageArray.count
        
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        //let cell = tableView.dequeueReusableCell(withIdentifier: "Reccept") as UITableViewCell!
      //  let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier:"Reccept") as UITableViewCell!
        //let cell = Bundle.main.loadNibNamed("WeatherCell", owner: self, options: nil)?.first as! WeatherCell
        
        let cell:WeatherCell = tableView.dequeueReusableCell(withIdentifier:"UICustomTableViewCell") as! WeatherCell!
        
        
        
        let weObj:Weather = imageArray.object(at: indexPath.row) as! Weather;
        
        cell.weImage?.image = UIImage(named: "sun.thumbnail.png");
        cell.city.text = weObj.city
        cell.degree.text = String(format:"%d",weObj.degree) as String
        return cell
        
        
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
   
        return 100
    }
    

    
    func getTableView (city:String, degree:Int) {
        
        let weObj:Weather = Weather()
        
        weObj.city = city
        weObj.degree = degree;
       // print (weObj.city)
       // print (weObj.degree)
        
        imageArray.add(weObj)
        
        ctable.reloadData()
        
        
        
    }

    
    @IBAction func citybtn(_ sender: Any) {
        var  storyboard:UIStoryboard

        storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc:WeatherViewController
        vc = storyboard.instantiateViewController(withIdentifier: "WeatherViewController") as! WeatherViewController
        vc.delegate1=self;
        
        
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func userDidEnterData(obj: Weather){
        
       // print(obj.city)
       // print(obj.degree)
        self.getTableView(city: obj.city, degree: obj.degree)
        
        
    }


}





