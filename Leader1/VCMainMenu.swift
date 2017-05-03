//
//  ViewController.swift
//  Leader1
//
//  Created by hrs on 16/03/2017.
//  Copyright © 2017 Slothlair. All rights reserved.
//

import UIKit
import Foundation

class VCMainMenu: UIViewController {

    let genSetting = UserDefaults.standard
    
    @IBOutlet weak var lbTest: UILabel!
    @IBOutlet weak var txfTest: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GalleryFromMain" {
            let querier = SQLizer()
            let controller = segue.destination as! VCGallery
            controller.hexList = querier.GetHexList()
        }
    }
    
    
    @IBAction func TestButton(_ sender: UIButton) {
        lbTest.text = String(genSetting.dictionaryRepresentation().count)
        txfTest.text = ""
        for strIndex in genSetting.dictionaryRepresentation() {
            txfTest.text = txfTest.text + " - " + String(strIndex.key)
        }
        
    }
    
}

