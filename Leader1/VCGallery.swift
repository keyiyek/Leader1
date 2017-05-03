//
//  VCGallery.swift
//  Leader1
//
//  Created by hrs on 16/03/2017.
//  Copyright © 2017 Slothlair. All rights reserved.
//

import UIKit
import Foundation

class VCGallery: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var lbHexCode: UILabel!
    @IBOutlet weak var lbMilestone: UILabel!
    @IBOutlet weak var lbType: UILabel!
    @IBOutlet weak var lbConfiguration: UILabel!
    
    @IBOutlet weak var imvHexImage: UIImageView!
    
    public var hexList: [String] = []
    private var currentHexIndex: Int = 0
    private var siblingCode: String = ""
    var backgroundsList: [String] = []
    
    @IBOutlet weak var tbvBackgrounds: UITableView!
    
    let cellIdentifier: String = "Common Cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        DisplayHex()

                
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // DataSource Protocol
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let number = backgroundsList.count
        return number
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let normalCell = tbvBackgrounds.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let item = backgroundsList[indexPath.row]
            
        normalCell.textLabel?.text = item
        
        
        return normalCell
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
    
    @IBAction func GoToPrevious(_ sender: Any) {
        if currentHexIndex > 0 {
            currentHexIndex = currentHexIndex - 1
        }
        else {
            currentHexIndex = (hexList.endIndex - 1)
        }
        DisplayHex()
        
    }
    
    @IBAction func GoToNext(_ sender: Any) {
        if currentHexIndex < hexList.endIndex - 1 {
            currentHexIndex = currentHexIndex + 1
        }
        else {
            currentHexIndex = 0
        }
        DisplayHex()
    }
    
    @IBAction func GotoSibling(_ sender: Any) {
        currentHexIndex = hexList.index(of: siblingCode)!
        DisplayHex()
    }
    
    private func DisplayHex() {
        let querier: SQLizer = SQLizer()
    
        
        let displayedHex: Hexagon = querier.getCompleteHex(code: hexList[currentHexIndex])
        lbHexCode.text = displayedHex.HexCode
        lbMilestone.text = String(displayedHex.HexMilestone)
        lbType.text = displayedHex.HexTerrain
        lbConfiguration.text = "\(displayedHex.HexConfiguration[0]) : \(displayedHex.HexConfiguration[1])"
        
        siblingCode = displayedHex.HexSiblingCode
        
        imvHexImage.image = UIImage(named: hexList[currentHexIndex])
        
        backgroundsList = displayedHex.HexBackgrounds

        
        tbvBackgrounds.reloadData()
        
    }
    
    
    
    private func DisplayHexImage(image: String) {
        imvHexImage.image = UIImage(named: image, in: Bundle(identifier: "SmallPics"), compatibleWith: nil)

    }
    
    
}

