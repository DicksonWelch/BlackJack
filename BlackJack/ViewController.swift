//
//  ViewController.swift
//  BlackJack
//
//  Created by Trevor Welch on 3/2/16.
//  Copyright © 2016 Trevor Welch. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
//    
//    lazy var animator: PlayingCardBehavior = {
//        return PlayingCardBehavior()
//    }()
  
    lazy var animator:UIDynamicAnimator = {
        return UIDynamicAnimator(referenceView: self.view)
    }()
    
    var physicsEngine = PlayingCardBehavior()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animator.addBehavior(physicsEngine)
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

