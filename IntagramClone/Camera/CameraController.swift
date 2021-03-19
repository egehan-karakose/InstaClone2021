//
//  CameraController.swift
//  IntagramClone
//
//  Created by Egehan Karaköse on 18.03.2021.
//

import AVFoundation
import UIKit
import JGProgressHUD


class CameraController : UIViewController, UIViewControllerTransitioningDelegate {
    
    
    
    let output = AVCapturePhotoOutput()
    
    
    let backButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "Ok_Sag").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        return button
    }()
    
 
    
    
    
    let takePhotoButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "Fotograf_Cek").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(takePhotoPressed), for: .touchUpInside)
        return button
    }()
    
    
    
//    Hide status bar
    override var prefersStatusBarHidden: Bool {
        
        return true
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        getPhotoPreview()
        
        view.addSubview(takePhotoButton)
        view.addSubview(backButton)
        setView()
        
        transitioningDelegate = self
       
    }
    fileprivate func setView(){
        takePhotoButton.anchor(top: nil, bottom: view.bottomAnchor, leading: nil, trailing: nil, paddingTop: 0, paddingBottom: -25, paddingLeft: 0, paddingRight: 0, width: 90, height: 90)
        
        takePhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        
        backButton.anchor(top: view.topAnchor, bottom: nil, leading: nil, trailing: view.trailingAnchor, paddingTop: 25, paddingBottom: 0, paddingLeft: 0, paddingRight: -15, width: 50, height: 50)
    }
    
    
    
    @objc fileprivate func takePhotoPressed(){
        
        let settings = AVCapturePhotoSettings()
        
        
        output.capturePhoto(with: settings, delegate: self)
    }
    
    @objc fileprivate func backButtonPressed(){
        dismiss(animated: true, completion: nil)
    }
    
    
    fileprivate func getPhotoPreview(){
        let captureSession = AVCaptureSession()
        
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        do{
            let input = try AVCaptureDeviceInput(device: device)
            if captureSession.canAddInput(input){
                captureSession.addInput(input)
            }
            
            
        }catch let error{
            print("Can't access camera", error.localizedDescription)
        }
        
        
        
        if captureSession.canAddOutput(output){
            captureSession.addOutput(output)
        }
        
        
        let preview = AVCaptureVideoPreviewLayer(session: captureSession)
        preview.frame = view.frame
        view.layer.addSublayer(preview)
        captureSession.startRunning()
        
    }
    
    let presentAnimation = PresentAnimation()
    let dismissAnimation = DismissAnimation()
    
    
//    Triggered when start animation
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return presentAnimation
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return dismissAnimation
    }
    
    
}

extension CameraController : AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        
        guard let imageData = photo.fileDataRepresentation() else {return}
        
        let preview = UIImage(data: imageData)
        
        let photoPreviewView =  PhotoPreviewView()
        
        photoPreviewView.photoPreview.image = preview
        
        view.addSubview(photoPreviewView)
        photoPreviewView.anchor(top: view.topAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
        
       
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Photo Capturing..."
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 1)
        
    }
}

