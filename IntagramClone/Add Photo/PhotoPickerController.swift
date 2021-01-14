//
//  PhotoPickerController.swift
//  IntagramClone
//
//  Created by Egehan Karaköse on 11.01.2021.
//

import Foundation
import UIKit
import Photos



class PhotoPickerController : UICollectionViewController {
    
    
    var assets = [PHAsset]()
    var photos = [UIImage]()
    var choosenPhoto : UIImage?
    var header : ImagePickerHeader?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addButtons()
        
        collectionView.register(PhotoPickerCell.self, forCellWithReuseIdentifier: PhotoPickerCell.identifier)
        
        collectionView.register(ImagePickerHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ImagePickerHeader.identifier)
        
        getPhotos()
        
        
    }
    
    fileprivate func getPhotosOptions() -> PHFetchOptions{
        let fetchOptions = PHFetchOptions()
        fetchOptions.fetchLimit = 40
        
        let sortOption = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchOptions.sortDescriptors = [sortOption]
        
        return fetchOptions
    }
    
    
    fileprivate func getPhotos(){
        
        let photos = PHAsset.fetchAssets(with: .image, options: getPhotosOptions())
        
        DispatchQueue.global(qos: .background).async {
            
            photos.enumerateObjects { (asset, num, stopPoint) in
                // all info about photos in asset
                // index photo photo 0 to 9
                // address of stop index
                
                let imageManager = PHImageManager.default()
                let size = CGSize(width: 200, height: 200)
                let options = PHImageRequestOptions()
                options.isSynchronous = true
                
                imageManager.requestImage(for: asset, targetSize: size, contentMode: .aspectFit, options: options){ (image, imageInfo) in
                    if let photo = image {
                        self.assets.append(asset)
                        self.photos.append(photo)
                        if self.choosenPhoto == nil {
                            self.choosenPhoto = photo
                        }
                    }
                    
                    if num == photos.count - 1 {
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                        
                    }
                    
                }
            }
        }
        
        
  
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        choosenPhoto = photos[indexPath.row]
        collectionView.reloadData()
        
        let indexTop = IndexPath(item: 0, section: 0)
        collectionView.scrollToItem(at: indexTop, at: .bottom, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ImagePickerHeader.identifier, for: indexPath) as! ImagePickerHeader
        
        self.header = header
        header.photo.image = choosenPhoto
    
        if let choosenPhoto = choosenPhoto {
            if let index = self.photos.firstIndex(of: choosenPhoto){
                let choosenAsset = self.assets[index]
                
                let photoManager = PHImageManager.default()
                let size = CGSize(width: 600, height: 600)
                photoManager.requestImage(for: choosenAsset, targetSize: size, contentMode: .default, options: nil){ (photo, info) in
                    
                    header.photo.image = photo
                }
                
            }
        }
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let size = view.frame.width
        return CGSize(width: size, height: size)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoPickerCell.identifier, for: indexPath) as! PhotoPickerCell
        
        cell.photo.image = photos[indexPath.row]
        return cell
    }
    
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    fileprivate func addButtons(){
        navigationController?.navigationBar.tintColor = .label
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonPressed))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action:#selector(nextButtonPressed))
        
    }
    
    @objc func nextButtonPressed(){
        
        let vc = SharePhotoController()
        vc.choosenPhoto = header?.photo.image
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc func cancelButtonPressed(){
        dismiss(animated: true, completion: nil)
    }
}

extension UINavigationController {
    open override var childForStatusBarHidden: UIViewController? {
        return self.topViewController
    }
}


extension PhotoPickerController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (view.frame.width - 3) / 4
        return CGSize(width: size, height: size)
    }
}
