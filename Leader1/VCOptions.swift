//
//  VCOptions.swift
//  Leader1
//
//  Created by hrs on 16/03/2017.
//  Copyright © 2017 Slothlair. All rights reserved.
//

import UIKit
import Foundation

class VCOptions: UIViewController {
    
    let generalSettings = UserDefaults.standard
    
    @IBOutlet weak var sgTrackUnits: UISegmentedControl!
    
    @IBOutlet weak var lbEnergyVariance: UILabel!
    @IBOutlet weak var lbTilesVariance: UILabel!
    @IBOutlet weak var lbEnergyRefreshes: UILabel!
    @IBOutlet weak var lbTilesRefreshes: UILabel!
    @IBOutlet weak var lbEnergySprint: UILabel!
    @IBOutlet weak var lbTilesSprint: UILabel!
    
    @IBOutlet weak var stEnergyVariance: UIStepper!
    @IBOutlet weak var stTilesVariance: UIStepper!
    @IBOutlet weak var stEnergyRefreshes: UIStepper!
    @IBOutlet weak var stTilesRefreshes: UIStepper!
    @IBOutlet weak var stEnergySprint: UIStepper!
    @IBOutlet weak var stTilesSprint: UIStepper!
    
    @IBOutlet weak var swBoxHN: UISwitch!
    @IBOutlet weak var swBoxGI: UISwitch!
    
    let genSettings = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func SetTrackUnits(_ sender: UISegmentedControl) {
        genSettings.set(sender.selectedSegmentIndex, forKey: "Track Unit")
    }
    
    
    @IBAction func StepEnergyVariance(_ sender: UIStepper) {
        lbEnergyVariance.text = String(Int(stEnergyVariance.value))
        genSettings.set(stEnergyVariance.value, forKey: "Energy Variance")
    }
    
    @IBAction func StepTilesVariance(_ sender: UIStepper) {
        lbTilesVariance.text = String(Int(stTilesVariance.value))
        genSettings.set(stTilesVariance.value, forKey: "Tiles Variance")
    }
    
    @IBAction func StepEnergyRefreshes(_ sender: UIStepper) {
        lbEnergyRefreshes.text = String(Int(stEnergyRefreshes.value))
        genSettings.set(stEnergyRefreshes.value, forKey: "Energy Refreshes")
    }
    
    @IBAction func StepTilesRefreshes(_ sender: UIStepper) {
        lbTilesRefreshes.text = String(Int(stTilesRefreshes.value))
        genSettings.set(stTilesRefreshes.value, forKey: "Tiles Refreshes")
    }
    
    @IBAction func StepEnergySprint(_ sender: UIStepper) {
        lbEnergySprint.text = String(Int(stEnergySprint.value))
        genSettings.set(stEnergySprint.value, forKey: "Energy Sprint")
    }
    
    @IBAction func StepTilesSprint(_ sender: UIStepper) {
        lbTilesSprint.text = String(Int(stTilesSprint.value))
        genSettings.set(stTilesSprint.value, forKey: "Tiles Sprint")
    }
    
    @IBAction func SetBoxHN(_ sender: UISwitch) {
        genSettings.set(swBoxHN.isOn, forKey: "Box HN")
    }
    
    @IBAction func SetBoxGI(_ sender: UISwitch) {
        genSettings.set(swBoxGI.isOn, forKey: "Box GI")
    }
    
    @IBAction func ResetSettingsToDefaults(_ sender: UIButton) {
        
        var format = PropertyListSerialization.PropertyListFormat.xml //format of the property list
        var plistData:[String:AnyObject] = [:]  //our data
        let plistPath:String? = Bundle.main.path(forResource: "DefaultSettings", ofType: "plist")! //the path of the data
        let plistXML = FileManager.default.contents(atPath: plistPath!)! //the data in XML format
        do{ //convert the data to a dictionary and handle errors.
            plistData = try PropertyListSerialization.propertyList(from: plistXML,options: .mutableContainersAndLeaves,format: &format)as! [String:AnyObject]
            
            //assign the values in the dictionary to the properties
            sgTrackUnits.selectedSegmentIndex = plistData["Track Unit"] as! Int
            SetTrackUnits(sgTrackUnits)
            
            stEnergyVariance.value = Double(plistData["Energy Variance"] as! Int)
            StepEnergyVariance(stEnergyVariance)
            
            stTilesVariance.value = Double(plistData["Tiles Variance"] as! Int)
            StepTilesVariance(stTilesVariance)
            
            stEnergyRefreshes.value = Double(plistData["Energy Refreshes"] as! Int)
            StepEnergyRefreshes(stEnergyRefreshes)
            
            stTilesRefreshes.value = Double(plistData["Tiles Refreshes"] as! Int)
            StepTilesRefreshes(stTilesRefreshes)
            
            stEnergySprint.value = Double(plistData["Energy Sprint"] as! Int)
            StepEnergySprint(stEnergySprint)
            
            stTilesSprint.value = Double(plistData["Tiles Sprint"] as! Int)
            StepTilesSprint(stTilesSprint)
            
            swBoxHN.setOn((plistData["Box HN"] as! Bool), animated: false)
            SetBoxHN(swBoxHN)
            
            swBoxGI.setOn((plistData["Box GI"] as! Bool), animated: false)
            SetBoxGI(swBoxGI)
            
            genSettings.synchronize()
            
            }
        catch{ // error condition
            print("Error reading plist: \(error), format: \(format)")
        }
    }
}
