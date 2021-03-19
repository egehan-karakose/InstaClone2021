//
//  PresentAnimation.swift
//  IntagramClone
//
//  Created by Egehan Karaköse on 19.03.2021.
//

import UIKit


class PresentAnimation : NSObject , UIViewControllerAnimatedTransitioning {
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
//        Real Animation Method
        let containerView = transitionContext.containerView
        
        guard let toView = transitionContext.view(forKey: .to) else { return }
        guard let fromView = transitionContext.view(forKey: .from) else { return }
        
        containerView.addSubview(toView)
        
        
        let startFrame = CGRect(x: -toView.frame.width, y: 0, width: toView.frame.width, height: toView.frame.height)
        toView.frame = startFrame
        
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut) {
            toView.frame = CGRect(x: 0, y: 0, width: toView.frame.width, height: toView.frame.height)
            
            fromView.frame = CGRect(x: fromView.frame.width, y:0 , width: fromView.frame.width, height: fromView.frame.height )
            
        } completion: { (_) in
            // complete animation and ready to take action from user
            transitionContext.completeTransition(true)
        }
        
        
        
        

        
        
    }
    
    
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    
    
    
}
