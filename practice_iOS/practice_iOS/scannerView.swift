//
//  scannerView.swift
//  practice_iOS
//
//  Created by Eswar Gadey on 27/11/22.
//

import UIKit
import AVFoundation

class scannerView: UIView, AVCaptureMetadataOutputObjectsDelegate {
    var ratio:CGFloat = 0.208
    var ratioHeight:CGFloat!
    let session = AVCaptureSession()
    var previewLayer : AVCaptureVideoPreviewLayer?

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
        self.layer.addSublayer(previewLayer!)
    }
    open func setScanView() {
        ratioHeight = self.frame.height * ratio
        
        let inputDevice:AVCaptureDeviceInput!
        do {
            if let captureDevice = AVCaptureDevice.default(for: AVMediaType(rawValue: convertFromAVMediaType(AVMediaType.video))) {
                inputDevice =  try AVCaptureDeviceInput(device: captureDevice)  //AVCaptureDeviceInput(device: captureDevice, error: &error)
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
    }
}
