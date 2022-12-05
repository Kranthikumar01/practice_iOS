//
//  ViewController.swift
//  practice_iOS
//
//  Created by Kranthi Kumar on 27/11/22.
//

import UIKit
import AVFoundation
import LocalAuthentication

class ViewController: UIViewController {

    @IBOutlet weak var barCodeScanButton: UIButton!
    @IBOutlet weak var biometricButton: UIButton!
    var scanView: scannerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .cyan
        buttonSetUp()
        
    }
    func buttonSetUp() {
        let cornerRadius = barCodeScanButton.frame.height/4
        self.barCodeScanButton.layer.cornerRadius = cornerRadius
        self.biometricButton.layer.cornerRadius = cornerRadius
        UIView.animate(withDuration: 0.7, delay: 0.2,options: .curveEaseInOut) {
            self.barCodeScanButton.center.y += 200
            self.biometricButton.center.y -= 200
        }
    }
    

    @IBAction func barCodeBtn(_ sender: Any) {
        
        self.scannerAction()
        
    }
    func scannerAction() {
        self.view.endEditing(true)
        if AVCaptureDevice.authorizationStatus(for: AVMediaType(rawValue: convertFromAVMediaType(AVMediaType.video))) ==  AVAuthorizationStatus.authorized {
            self.startScanning()
        } else {
            AVCaptureDevice.requestAccess(for: AVMediaType(rawValue: convertFromAVMediaType(AVMediaType.video)), completionHandler: { (granted :Bool) -> Void in
                DispatchQueue.main.async {
                    if granted == true {
                        self.startScanning()
                    } else {
                        self.showAlert(message: "REJECTED_CAMERA_SUPPORT")
                    }
                }
            })
        }
    }
    func startScanning() {
        self.scanView = UINib(nibName: "scannerView", bundle: nil).instantiate(withOwner: self, options: nil)[0] as? scannerView
        self.scanView.frame = CGRect(x: 10, y: self.view.frame.height/8.5, width: self.view.frame.width-20, height: self.view.frame.height*0.75)
        self.view.addSubview(scanView)
        self.scanView.delegate = self
        self.scanView.setupView()
        self.scanView.setScanView()
    }
    
    @IBAction func bioMetricBtn(_ sender: Any) {
        let context = LAContext()
            var error: NSError?

            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "Identify yourself!"

                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                    [weak self] success, authenticationError in

                    DispatchQueue.main.async {
                        if success {
                            self?.showAlert(message: "unlocked")
                        } else {
                            // error
                        }
                    }
                }
            } else {
                // no biometry
            }
        
        
    }
    func showAlert(title:String = "Alert", message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension ViewController: scanViewDelegate {
    func decodedOutput(_ outValue: String) {
        self.showAlert(message: outValue)
    }
    
    func dismissView() {
        self.scanView.removeFromSuperview()
    }
    
    
}

func convertFromAVMediaType(_ input: AVMediaType) -> String {
    return input.rawValue
}
func convertFromAVLayerVideoGravity(_ input: AVLayerVideoGravity) -> String {
    return input.rawValue
}
