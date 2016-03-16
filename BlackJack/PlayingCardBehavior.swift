//
//  PlayingCardBehavior.swift
//  BlackJack
//
//  Created by Trevor Welch on 3/16/16.
//  Copyright © 2016 Trevor Welch. All rights reserved.
//

import UIKit

class PlayingCardBehavior: UIDynamicBehavior {
   
    //-------------------- 1. Set up physics system ------------------------------------
    
    override init(){
        super.init()
        addChildBehavior(colider)
        addChildBehavior(bounce)
        addChildBehavior(gravity)
    }
    
    lazy var colider: UICollisionBehavior = {
        let a = UICollisionBehavior()
        a.translatesReferenceBoundsIntoBoundary = true
        return a
    }()
    
    lazy var bounce: UIDynamicItemBehavior = {
        let b = UIDynamicItemBehavior()
        b.allowsRotation = false
        b.elasticity = 0.5
        return b;
    }()
    
    var gravity = UIGravityBehavior()
    
    //-------------------2. Add physics system to UIView--------------------------------
    func addPhysics(view :PlayingCardView){
        dynamicAnimator?.referenceView?.addSubview(view)
        gravity.addItem(view)
        colider.addItem(view)
        bounce.addItem(view)
        
    }
    
    func removePhysics(view: PlayingCardView){
        gravity.removeItem(view)
        colider.removeItem(view)
        bounce.removeItem(view)
        view.removeFromSuperview()
    }
    
    //--------------------3. See the view controller ------------------------------------
}


//1, set up the physics system
//2, add the physics system to the UIViews that are using it.
//3 run in the view controller