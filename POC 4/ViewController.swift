//
//  ViewController.swift
//  POC 4
//
//  Created by Thobio on 23/01/19.
//  Copyright © 2019 Zerone Consulting. All rights reserved.
//

import UIKit
import Neon
import Async
import IHProgressHUD

class ViewController: UIViewController,AcuantMobileSDKControllerCapturingDelegate,AcuantMobileSDKControllerProcessingDelegate {
    
    var acuantMobileSDKController = AcuantMobileSDKController()

    var wasValidated:Bool!
    var images = UIImage()
    @IBOutlet var viewCenter: UIView!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        viewCenter.createViewBackground()
        IHProgressHUD.set(borderColor: UIColor.lightGray)
        IHProgressHUD.set(borderWidth: 0.5)
        acuantSDKCamera()
    }
    
    func acuantSDKCamera () {
        acuantMobileSDKController = AcuantMobileSDKController.initAcuantMobileSDK(withLicenseKey: licenseKey, andDelegate: self)
        cardTypes = AcuantCardTypeAuto
        cardRegion = AcuantCardRegionAustralia
        self.view.isUserInteractionEnabled = true
        acuantMobileSDKController.setInitialMessage("Tap screen to capture", frame: CGRect(x: 0, y: 0, width: 0, height: 0), backgroundColor: UIColor.clear, duration: Int32(10.0), orientation: AcuantHUDLandscape)
        
        acuantMobileSDKController.setCapturingMessage("Hold Steady", frame: CGRect(x: 0, y: 0, width: 0, height: 0), backgroundColor: UIColor.clear, duration: Int32(10.0), orientation: AcuantHUDLandscape)
        let singleTap = UITapGestureRecognizer.init(target: self, action: #selector(self.callingCameraView(sender:)))
        let singleTaps = UITapGestureRecognizer.init(target: self, action: #selector(self.callingCameraView(sender:)))
        view.addGestureRecognizer(singleTap)
        viewCenter.addGestureRecognizer(singleTaps)
        
    }
    
    @objc func callingCameraView(sender:UITapGestureRecognizer? = nil){
        acuantMobileSDKController.setWidth(1478)
        acuantMobileSDKController.showManualCameraInterface(in: self, delegate: self, cardType: cardTypes!, region: cardRegion!, andBackSide: false)
    }
    
    func processCard(cardsTypes: AcuantCardType) {
        
        let frontSideImage = self.images
        var backSideImage = UIImage()
        if (Int(cardTypes!.rawValue) == 2) {
            backSideImage = frontSideImage
        }
        let options = AcuantCardProcessRequestOptions.defaultRequestOptions(for: cardsTypes)
        
       // print(self.cardType?.rawValue as Any)
        
        options?.autoDetectState = true
        options?.stateID = -1
        options?.reformatImage = true
        options?.reformatImageColor = 0
        options?.dpi = Int32(150.0)
        options?.cropImage = false
        options?.faceDetection = true
        options?.signatureDetection = true
        options?.region = cardRegion!
        
        self.acuantMobileSDKController.processFrontCardImage(frontSideImage, backCardImage: backSideImage, andStringData: nil, with: self, with: options)
        
    }
    
    func mobileSDKWasValidated(_ wasValidated: Bool) {
        self.wasValidated = wasValidated
    }

    func didFinishValidatingImage(with result: AcuantCardResult!) {

    }
    
    func didFinishProcessingCard(with result: AcuantCardResult!) {
        switch Int(cardTypes!.rawValue) {
        case 1:

            let data:AcuantMedicalInsuranceCard = result as! AcuantMedicalInsuranceCard
            print(data.dateOfBirth)
            
            break
        case 2:
            

                let data:AcuantDriversLicenseCard = result as! AcuantDriversLicenseCard
                let images = UIImage(data: data.faceImage)
                DispatchQueue.main.async {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "edit") as! EditViewController
                    DispatchQueue.global(qos: .default).async(execute: {
                        IHProgressHUD.dismiss()
                    })
                    self.present(vc, animated: true, completion: nil)
                    vc.imageDisplay.image = images
                    vc.acuantDriversLicense = data
                }


            break
        case 3:
            
                let data:AcuantPassaportCard = result as! AcuantPassaportCard
                let images = UIImage(data: data.faceImage)
                DispatchQueue.main.async {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "edit") as! EditViewController
                    DispatchQueue.global(qos: .default).async(execute: {
                        IHProgressHUD.dismiss()
                    })
                    self.present(vc, animated: true, completion: nil)
                    vc.imageDisplay.image = images
                    vc.acuantPassaport = data
                }

            break
        default:
            print("default \(Int(cardTypes!.rawValue))")
            break
        }
    }
    
    func didFailWithError(_ error: AcuantError!) {
        var errorMessage:String?
        
        switch (error.errorType) {
            case AcuantErrorTimedOut:
                errorMessage = error.errorMessage
                break
            case AcuantErrorUnknown:
                errorMessage = error.errorMessage
                break
            case AcuantErrorUnableToProcess:
                errorMessage = error.errorMessage
                break
            case AcuantErrorInternalServerError:
                errorMessage = error.errorMessage
                break
            case AcuantErrorCouldNotReachServer:
                errorMessage = error.errorMessage
                break
            case AcuantErrorUnableToAuthenticate:
                errorMessage = error.errorMessage
                break
            case AcuantErrorAutoDetectState:
                errorMessage = error.errorMessage
                break
            case AcuantErrorWebResponse:
                errorMessage = error.errorMessage
                break
            case AcuantErrorUnableToCrop:
                errorMessage = error.errorMessage
                break
            case AcuantErrorInvalidLicenseKey:
                errorMessage = error.errorMessage
                break
            case AcuantErrorInactiveLicenseKey:
                errorMessage = error.errorMessage
                break
            case AcuantErrorAccountDisabled:
                errorMessage = error.errorMessage
                break
            case AcuantErrorOnActiveLicenseKey:
                errorMessage = error.errorMessage
                break
            case AcuantErrorValidatingLicensekey:
                errorMessage = error.errorMessage
                break
            case AcuantErrorCameraUnauthorized:
                errorMessage = error.errorMessage
                break
            default:
                errorMessage = "Error try again"
                break
        }
        
        
        if(errorMessage == "State not Recognized"){
            IHProgressHUD.dismiss()
            let alertController = UIAlertController.init(title: "MyTech Facial Recognition POC", message: errorMessage, preferredStyle: .alert)
            let cancelButton = UIAlertAction.init(title: "OK", style: .default) { (actions) in
                 self.performSegue(withIdentifier: "state", sender: self)
            }
            alertController.addAction(cancelButton)
            self.present(alertController, animated: true, completion: nil)
        }else{
            DispatchQueue.global(qos: .default).async(execute: {
                IHProgressHUD.showError(withStatus: errorMessage)
            })
        }
      
    }
    
    func didCaptureCropImage(_ cardImage: UIImage!, scanBackSide: Bool, andCardType cardType: AcuantCardType, withImageMetrics imageMetrics: [AnyHashable : Any]!) {
        
        DispatchQueue.main.async {
            IHProgressHUD.show()
            self.images = cardImage
            cardTypes = cardType
            self.processCard(cardsTypes: cardTypes!)
        }
        
    }
    
    func didCaptureData(_ data: String!) {
        print("didTakeCardPhoto")
    }
    
    func imageForBackButton() -> UIImage! {
        return UIImage(named: "back")
    }
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "state"
        {
            if segue.destination is RegionViewController {
        
            }
        }
    }

}

