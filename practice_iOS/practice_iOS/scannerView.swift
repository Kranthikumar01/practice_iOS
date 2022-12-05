//
//  scannerView.swift
//  practice_iOS
//
//  Created by Eswar Gadey on 27/11/22.
//

import UIKit
import AVFoundation

protocol scanViewDelegate {
    func dismissView()
    func decodedOutput(_ outValue: String)
}

class scannerView: UIView, AVCaptureMetadataOutputObjectsDelegate {
    
    var delegate: scanViewDelegate!
    var ratio:CGFloat = 0.208
    var ratioHeight:CGFloat!
    let session = AVCaptureSession()
    var previewLayer : AVCaptureVideoPreviewLayer?
    var scanningLine = UIView()

    @IBOutlet weak var scanArea: UIView!
    
    override func awakeFromNib() {
        self.backgroundColor = .red
    }
    func setupView() {
        self.backgroundColor = .gray
        self.layer.cornerRadius = 14
        self.layer.shadowOffset = CGSize(width: 4, height: 8)
        self.layer.shadowColor = CGColor.init(red: 99, green: 78, blue: 43, alpha: 0.4)
    }
    func addPreviewLayer() {
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer?.videoGravity = AVLayerVideoGravity(rawValue: convertFromAVLayerVideoGravity(AVLayerVideoGravity.resizeAspectFill))
        previewLayer?.bounds = self.bounds
        previewLayer?.position = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        AVCaptureVideoPreviewLayer().cornerRadius = 14
        self.layer.addSublayer(previewLayer!)
    }
    open func setScanView() {
        ratioHeight = self.frame.height * ratio
        
        let inputDevice:AVCaptureDeviceInput!
        do {
            if let captureDevice = AVCaptureDevice.default(for: AVMediaType(rawValue: convertFromAVMediaType(AVMediaType.video))) {
                inputDevice =  try AVCaptureDeviceInput(device: captureDevice)
                if let inp = inputDevice {
                    session.addInput(inp)
                }
            }
        } catch {
            print("error")
        }
        
        addPreviewLayer()
        
        /* Check for metadata */
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        output.metadataObjectTypes = output.availableMetadataObjectTypes
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        session.startRunning()
        
        
        let dismissButton = UIButton()
        dismissButton.frame = CGRect(x: 20, y: 30, width: 50, height: 50)
        dismissButton.setImage(UIImage(named: "close"), for: UIControl.State())
        dismissButton.addTarget(self, action: #selector(scannerView.dismissScanView), for: UIControl.Event.touchUpInside)
        self.addSubview(dismissButton)
        
        let scannerLayer = UIImageView(frame: self.frame)
        scannerLayer.image = UIImage(named: "scanner")
        self.addSubview(scannerLayer)
        
        self.scanningLine.frame = CGRect(x: 0, y: 0, width: self.frame.width - 70, height: 2)
        self.scanningLine.center = CGPoint(x: self.center.x-10, y: self.center.y - 160)
        self.scanningLine.backgroundColor = .white//UIImage(named: "scanner_line")
        self.addSubview(self.scanningLine)
        
        UIView.animate(withDuration: 1.3, delay:0, options: [.repeat, .autoreverse], animations: {
            self.scanningLine.frame = CGRect(x: self.scanningLine.frame.origin.x, y: self.scanningLine.frame.origin.y + 180, width: self.scanningLine.frame.width, height: self.scanningLine.frame.height)
            }, completion: nil)
    }
    
    @objc func dismissScanView() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        session.stopRunning()
        self.removeFromSuperview()
        delegate.dismissView()
    }
    
    open func metadataOutput(_ captureOutput: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        self.endEditing(true)
        for data in metadataObjects {
            let metaData = data
            let transformed = previewLayer?.transformedMetadataObject(for: metaData) as? AVMetadataMachineReadableCodeObject
            if let unwraped = transformed {
                if let decodeValue = unwraped.stringValue {
                    print("======>>>   ",decodeValue)
                    delegate.decodedOutput(decodeValue)
                    self.scanningLine.layer.removeAllAnimations()
                    self.session.stopRunning()
                    let systemSoundID: SystemSoundID = 1114
                    AudioServicesPlaySystemSound (systemSoundID)
                    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
                    Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(scannerView.dismissScanView), userInfo: nil, repeats: false)
                    return
                }
            }
        }
    }

}
