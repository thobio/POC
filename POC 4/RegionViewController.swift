//
//  RegionViewController.swift
//  POC 4
//
//  Created by Thobio on 31/01/19.
//  Copyright © 2019 Zerone Consulting. All rights reserved.
//

import UIKit

class RegionViewController: UIViewController {
    
    @IBOutlet var usaButton: UIButton!
    @IBOutlet var canadaButton: UIButton!
    @IBOutlet var saButton: UIButton!
    @IBOutlet var europeButton: UIButton!
    @IBOutlet var asiaButton: UIButton!
    @IBOutlet var southAfricaButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func regionSelection(_ sender: UIButton) {
        
        switch sender {
            case usaButton:
                cardRegion = AcuantCardRegionUnitedStates
                break
            case canadaButton:
                cardRegion = AcuantCardRegionCanada
                break
            case saButton:
                cardRegion = AcuantCardRegionAmerica
                break
            case europeButton:
                cardRegion = AcuantCardRegionEurope
                break
            case asiaButton:
                cardRegion = AcuantCardRegionAsia
                break
            case southAfricaButton:
                cardRegion = AcuantCardRegionAfrica
                break
            default:
                cardRegion = AcuantCardRegionAustralia
                break
        }
        
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
