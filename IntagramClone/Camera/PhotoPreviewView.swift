//
//  PhotoPreviewView.swift
//  IntagramClone
//
//  Created by Egehan Karaköse on 19.03.2021.
//

import UIKit
import Photos


class PhotoPreviewView : UIView {
    
    
    let saveButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "Fotograf_Kaydet").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    
    let cancelButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "Fotograf_Iptal").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    let photoPreview : UIImageView = {
        
        let image = UIImageView()
        return image
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
       
        addSubview(photoPreview)
        addSubview(cancelButton)
        addSubview(saveButton)
       
        setButtons()
        
    }
    
    
    fileprivate func setButtons(){
        
        photoPreview.anchor(top: topAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
        
        cancelButton.anchor(top: topAnchor, bottom: nil, leading: leadingAnchor, trailing: nil, paddingTop: 25, paddingBottom: 0, paddingLeft: 25, paddingRight: 0, width: 0, height: 0)
        
        
        saveButton.anchor(top: nil, bottom: bottomAnchor, leading: leadingAnchor, trailing: nil, paddingTop: 0, paddingBottom: -25, paddingLeft: 25, paddingRight: 0, width: 0, height: 0)
        
        
    }
    
    
    @objc fileprivate func saveButtonPressed(){
        guard let imageToSave = photoPreview.image else {return}
        
        let library = PHPhotoLibrary.shared()
        
        library.performChanges {
            PHAssetChangeRequest.creationRequestForAsset(from: imageToSave)
        } completionHandler: { (result, error) in
            if let error = error {
                print("Failed to save photo \(error.localizedDescription)")
            }
            print("Photo saved successfully.")
            
            DispatchQueue.main.async {
                let savedLabel = UILabel()
                savedLabel.text = "Photo Saved"
                savedLabel.font = UIFont.boldSystemFont(ofSize: 18)
                savedLabel.textColor = .white
                savedLabel.numberOfLines = 0
                savedLabel.backgroundColor = UIColor(white: 0, alpha: 0.3)
                savedLabel.frame = CGRect(x: 0, y: 0, width: 200, height: 120)
                savedLabel.textAlignment = .center
                savedLabel.center = self.center
                self.addSubview(savedLabel)
                
                savedLabel.layer.transform = CATransform3DMakeScale(0, 0, 0)
                UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut) {
                    savedLabel.layer.transform = CATransform3DMakeScale(1, 1, 1)
                } completion: { (success) in
                    // Animation Finished
                    UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut) {
                        savedLabel.layer.transform = CATransform3DMakeScale(0.01, 0.01, 0.01)
                    } completion: { (_) in
                        savedLabel.removeFromSuperview()
                    }

                }

            }
            
           
        }

        
    }
    
    @objc fileprivate func cancelButtonPressed(){
        
        self.removeFromSuperview()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
