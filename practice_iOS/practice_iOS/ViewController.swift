//
//  ViewController.swift
//  practice_iOS
//
//  Created by Kranthi Kumar on 27/11/22.
//

import UIKit

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
        self.scanView = scannerView(frame: CGRect(x: self.view.frame.width/9, y: self.view.frame.height/8, width: self.view.frame.width*0.78, height: self.view.frame.height*0.8))
        self.view.addSubview(scanView)
        self.scanView.setupView()
        print("scanner")
        
    }
    
    @IBAction func bioMetricBtn(_ sender: Any) {
        print("there is something")
        scanView.alpha = 0
        self.scanView.removeFromSuperview()
    }
    
}

