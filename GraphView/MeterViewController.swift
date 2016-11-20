//
//  MeterViewController.swift
//  GraphView
//
//  Created by Mohamed Ayadi on 11/6/16.
//
//

import UIKit
import SFGaugeView


class MeterViewController: UIViewController {
    
    @IBOutlet weak var myNamberLabel: UILabel!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    var curentLevelOfWater = 0.0

    var SFGauge = SFGaugeView()
    @IBOutlet weak var meterView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
       self.meterConfig()
        //Getting the current usage from AWS
        self.getUserInfo()
        let helloWorldTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(MeterViewController.getUserInfo), userInfo: nil, repeats: true)

        

    }
    @IBAction func backButtonTapped(_ sender: AnyObject) {
        self.dismiss(animated: false) { 
            
        }
    }
 
    func getUserInfo() {
        let url = URL(string: "http://pubsub.pubnub.com/history/sub-c-b10662c0-aeb6-11e6-b0d5-0619f8945a4f/quake/0/1")
        
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            guard error == nil else {
                print(error)
                return
            }
            guard let data = data else {
                print("Data is empty")
                return
            }
            
            let json = try! JSONSerialization.jsonObject(with: data, options: [])
            
            let array = json
            
            let myArray = array as! NSArray
            
            let myNumber: NSDictionary = myArray[0] as! NSDictionary
            
            
            let myValue = myNumber.allValues
            
            let myFirstValue = myValue.first
            print(myFirstValue!)
           self.curentLevelOfWater = myFirstValue as! Double
        }
        
        task.resume()
        self.myNamberLabel.text = "\(curentLevelOfWater)"
        self.SFGauge.currentLevel = Int(curentLevelOfWater as! Double)

    }
    
    func meterConfig(){
        //Meter config
        
        //        Set up parameters
        //
        //        maxlevel = The maximum level of gauge control (unsigned int value)
        //        minlevel = The minimum level of gauge control (unsigned int value)
        //        needleColor = Color of needle
        //        bgColor = Background Color of gauge control
        //        hideLevel = If set to YES the current level is hidden
        //        minImage = An image for min level (see screenshot)
        //        maxImage = An image for max level (see screenshot)
        //        currentLevel = Sets the current Level
        //        autoAdjustImageColors = Overlays the images with needleColor (default: NO)
        //
        SFGauge.frame = self.meterView.frame
//        SFGauge = SFGaugeView(frame: self.meterView.frame)
        SFGauge.bgColor = UIColor.colorFromHex(hexString: "#add8e6")
        SFGauge.needleColor = UIColor.colorFromHex(hexString: "#000080")
        SFGauge.backgroundColor = UIColor.colorFromHex(hexString: "#464646")
        //SFGauge.maxImage = "unhappyWater"
        //SFGauge.minImage = "happyWater"
        SFGauge.maxlevel = 15
        SFGauge.minlevel = 0
        
        self.meterView.addSubview(SFGauge)
        
        //End of meter config
    }

}
