//
//  scannerView.swift
//  practice_iOS
//
//  Created by Eswar Gadey on 27/11/22.
//

import UIKit

class scannerView: UIView {

    @IBOutlet weak var scanArea: UIView!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func awakeFromNib() {
        scanArea.backgroundColor = .clear
    }
    func setupView() {
        self.backgroundColor = .gray
        self.layer.cornerRadius = 14
        self.layer.shadowOffset = CGSize(width: 4, height: 8)
        self.layer.shadowColor = CGColor.init(red: 99, green: 78, blue: 43, alpha: 0.4)
        
        
    }

}
