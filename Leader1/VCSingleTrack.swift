//
//  VCSingleTrack.swift
//  Leader1
//
//  Created by hrs on 19/03/2017.
//  Copyright © 2017 Slothlair. All rights reserved.
//

import Foundation
import UIKit

class VCSingleTrack: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var lbTrackLength: UILabel!
    @IBOutlet weak var lbTilesCount: UILabel!
    @IBOutlet weak var lbNumberOfBoxes: UILabel!
    @IBOutlet weak var lbNumberOfTracks: UILabel!
    @IBOutlet weak var lbTracksVariance: UILabel!
  
    @IBOutlet weak var tbvTerrainsTypes: UITableView!
    @IBOutlet weak var tbvBackgroundTypes: UITableView!
    
    
    var listHexTypes: [String] = []
    var listBackgrounds: [String] = []
    
    let cellIdentifier = "Common Cell"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let querier: SQLizer = SQLizer()
        
        listHexTypes = querier.GetTerrainsList()
        listBackgrounds = querier.GetBackgroundsList()
    }
    
    // DataSource Protocol
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var number: Int = 0
        if tableView == tbvTerrainsTypes {
            number = listHexTypes.count
        }
        if tableView == tbvBackgroundTypes {
            number = listBackgrounds.count
        }
        return number
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        if tableView == tbvTerrainsTypes {
        
            let normalCell = tbvTerrainsTypes.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            
            let item = listHexTypes[indexPath.row]
        
            normalCell.textLabel?.text = item
            
            return normalCell
        }
        if tableView == tbvBackgroundTypes {
            let normalCell = tbvBackgroundTypes.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            
            let item = listBackgrounds[indexPath.row]
            
            normalCell.textLabel?.text = item
            return normalCell
        }
        
        
        return tbvTerrainsTypes.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .none
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func updateTilesCount() {
        
    }
    
    @IBAction func StepTrackLength(_ sender: UIStepper) {
        lbTrackLength.text = String(Int(sender.value))
    }
    
    @IBAction func StepNumberOfBoxes(_ sender: UIStepper) {
        lbNumberOfBoxes.text = String(Int(sender.value))
    }
    
    @IBAction func StepNumberOfTracks(_ sender: UIStepper) {
        lbNumberOfTracks.text = String(Int(sender.value))
    }
    
    @IBAction func StepTracksVariance(_ sender: UIStepper) {
        lbTracksVariance.text = String(Int(sender.value))
    }
    
    
}
