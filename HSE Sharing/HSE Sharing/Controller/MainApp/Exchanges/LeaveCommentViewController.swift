//
//  LeaveCommentViewController.swift
//  HSE Sharing
//
//  Created by Екатерина on 09.04.2022.
//

import Foundation
import UIKit

class LeaveCommentViewController: UIViewController {
    @IBOutlet weak var SaveButton: UIButton!
    
    @IBOutlet weak var commentSpace: UITextView!
    
    override func viewDidLayoutSubviews() {
        SaveButton.makeButtonOval()
        commentSpace.layer.cornerRadius = 10
    }
}
