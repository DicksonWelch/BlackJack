//
//  ViewController.swift
//  BlackJack
//
//  Created by Trevor Welch on 3/2/16.
//  Copyright © 2016 Trevor Welch. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var pcv: PlayingCardView!{
        didSet{
            let tap = UITapGestureRecognizer(target: pcv, action: "makeRandomCard")
            pcv.addGestureRecognizer(tap)
        }
    }
    
    @IBAction func longPress(sender: UILongPressGestureRecognizer) {
        pcv.faceUp = !pcv.faceUp
    }
}

