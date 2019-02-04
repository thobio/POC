//
//  EditViewController.swift
//  POC 4
//
//  Created by Thobio on 25/01/19.
//  Copyright © 2019 Zerone Consulting. All rights reserved.
//

import UIKit
import Neon
import Async


class EditViewController: UIViewController,AcuantMobileSDKControllerCapturingDelegate,AcuantMobileSDKControllerProcessingDelegate,AcuantFacialCaptureDelegate {
    
    @IBOutlet var imageDisplay: UIImageView!
    @IBOutlet var selfieImage: UIImageView!
    
    var connect_instance = AcuantMobileSDKController()
    var wasValidateds = Bool()
    let licenseKey = "DC8F38993D87"
    var selfieTaken : Bool = false
    let queue = DispatchQueue(label: "com.zeroneconsulting.POC-4-First")
    var acuantDriversLicense:AcuantDriversLicenseCard?
    var acuantPassaport:AcuantPassaportCard?
    
    let labels:UILabel = {
        var vw = UILabel()
        vw.textAlignment = .center
        return vw
    }()
    
    let labelsMatched:UILabel = {
        var vw = UILabel()
        vw.textAlignment = .center
        return vw
    }()
    
    let btn:UIButton = {
        var bn = UIButton()
        bn.setImage(UIImage(named: "navigation-back"), for: [])
         bn.backgroundColor = UIColor.lightGray
        bn.tintColor = UIColor.black
        bn.layer.cornerRadius = bn.layer.frame.width/2
        return bn
    }()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageDisplay.imageViewRoundView()
        selfieImage.imageViewRoundView()
        connect_instance = AcuantMobileSDKController.initAcuantMobileSDK(withLicenseKey: licenseKey, andDelegate: self)
        view.addSubview(labels)
        view.addSubview(labelsMatched)
        view.addSubview(btn)
        btn.layer.cornerRadius = 30
        btn.alpha = 0.0
        labels.anchorInCorner(.topLeft, xPad: 20, yPad: 150, width: (view.frame.width - 40), height: 40)
        labelsMatched.anchorInCorner(.bottomLeft, xPad: 20, yPad: 100, width: (view.frame.width - 40), height: 40)
        btn.anchorToEdge(.bottom, padding: 30, width: 60, height: 60)
        btn.addTarget(self, action: #selector(backButtonAcyion), for: .touchUpInside)
    }
    
    @objc func backButtonAcyion(){
        cardRegion = AcuantCardRegionAustralia
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if (selfieTaken == false) {
            DispatchQueue.main.async {
                self.imageViewGet()
            }
        }
        
    }
    
    func imageViewGet() {
        
        guard imageDisplay.image != nil else{
            return
        }
        selfieTaken = true
        let screenRect: CGRect = UIScreen.main.bounds
        let screenWidth: CGFloat = screenRect.size.width
        let messageFrame = CGRect(x: 0, y: 50, width: screenWidth, height: 20)
        
        let message = NSMutableAttributedString(string: "Get closer until Red Rectangle appears and Blink")
        message.addAttribute(.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: message.length))
        let range: NSRange = (message.string as NSString).range(of: "Red Rectangle")
        var font = UIFont.systemFont(ofSize: 13)
        var boldFont = UIFont.boldSystemFont(ofSize: 14)
        
        if UIScreen.main.nativeBounds.height == 1136 {
            font = UIFont.systemFont(ofSize: 11)
            boldFont = UIFont.boldSystemFont(ofSize: 12)
        }
        
        message.addAttribute(.foregroundColor, value: UIColor.red, range: range)
        message.addAttribute(.font, value: font, range: NSRange(location: 0, length: message.length))
        message.addAttribute(.font, value: boldFont, range: range)
        DispatchQueue.main.async {
            AcuantFacialRecognitionViewController.presentFacialCaptureInterface(with: self, withSDK: self.connect_instance, in: self, withCancelButton: true, withCancelButtonRect: CGRect(x: 0, y: 0, width: 0, height: 0), withWaterMark:  "Powered by MCS", withBlinkMessage: message, in: messageFrame)
        }
    }
    
    func mobileSDKWasValidated(_ wasValidated: Bool) {
        wasValidateds  = wasValidated
    }
    
    func didFinishFacialRecognition(_ image: UIImage!) {
        
        self.selfieImage.image = image
        
        DispatchQueue.main.async {
            let option = AcuantCardProcessRequestOptions.defaultRequestOptions(for: AcuantCardTypeFacial)
            self.connect_instance.validatePhotoOne(image, withImage: self.imageDisplay.image?.pngData(), with: self, with: option)
        }
        
    }
    
    func didTimeoutFacialRecognition(_ lastImage: UIImage!) {
        self.didFinishFacialRecognition(lastImage)
    }
    
    func imageForFacialBackButton() -> UIImage! {
        return UIImage(named: "back")
    }
    
    func facialRecognitionTimeout() -> Int32 {
        return 20;
    }
    
    func shouldShowFacialTimeoutAlert() -> Bool {
        return true
    }
    
    func didFinishProcessingCard(with result: AcuantCardResult!) {
        
    }
    
    func messageToBeShownAfterFaceRectangleAppears() -> NSAttributedString! {
        return NSAttributedString(string: "Analyzing..", attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.white
            ])
    }
    
    func frameWhereMessageToBeShownAfterFaceRectangleAppears() -> CGRect {
        return CGRect(x: 0, y: 0, width: 0, height: 0)
    }
    
    func didFinishValidatingImage(with result: AcuantCardResult!) {
       
            let data:AcuantFacialData = result as! AcuantFacialData
            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {

                    self.selfieImage.center = CGPoint(x: (self.view.center.x -  ((self.selfieImage.frame.width/2) + 20)), y: (self.view.center.y +  ((self.selfieImage.frame.width/2) - (self.selfieImage.frame.width/2))))
                    self.imageDisplay.center = CGPoint(x: (self.view.center.x -  ((self.imageDisplay.frame.width/2) + 20)), y: (self.view.center.y +  ((self.imageDisplay.frame.width/2) - (self.imageDisplay.frame.width/2))))
                self.loadViewIfNeeded()
            }) { (bool) in
                UIView.animate(withDuration: 1.0, delay: 1.0, options: .curveLinear, animations: {
                    if(self.acuantPassaport != nil){
                        let name:String = (self.acuantPassaport?.nameFirst)!+" "+(self.acuantPassaport?.nameMiddle)!
                        let last:String = (self.acuantPassaport?.nameLast)!
                        DispatchQueue.main.async {
                            self.labels.text = name+" "+last
                        }
                    }else{
                        if(self.acuantDriversLicense != nil){
                            let name:String = (self.acuantDriversLicense?.nameFirst)!+" "+(self.acuantDriversLicense?.nameMiddle)!
                            let last:String = (self.acuantDriversLicense?.nameLast)!
                            DispatchQueue.main.async {
                                self.labels.text = name+" "+last
                            }
                        }
                    }
                }, completion: nil)
                UIView.animate(withDuration: 0.5, animations: {

                    if data.facialMatchConfidenceRating > 80 {

                        DispatchQueue.main.async {
                            self.selfieImage.image = UIImage(named: "Done")
                            self.labelsMatched.text = "Matched"
                            self.btn.alpha = 1.0

                        }
                    }else{

                        DispatchQueue.main.async {
                            self.selfieImage.image = UIImage(named: "Close")
                            self.labelsMatched.text = "Not Matched"
                            self.btn.alpha = 1.0

                        }
                    }
                    self.loadViewIfNeeded()
                })
            }
    
    }
    
    func didCaptureCropImage(_ cardImage: UIImage!, scanBackSide: Bool, andCardType cardType: AcuantCardType, withImageMetrics imageMetrics: [AnyHashable : Any]!) {}
    
    func didFailWithError(_ error: AcuantError!) {
        let alertController = UIAlertController.init(title: "MyTech Facial Recognition POC", message: error.errorMessage, preferredStyle: .alert)
        let cancelButton = UIAlertAction.init(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(cancelButton)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func didCaptureData(_ data: String!) {}

    func didCancelFacialRecognition() {}
}
