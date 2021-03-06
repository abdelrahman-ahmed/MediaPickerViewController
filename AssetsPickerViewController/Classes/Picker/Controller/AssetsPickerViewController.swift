//
//  AssetsPickerViewController.swift
//  Pods
//
//  Created by DragonCherry on 5/17/17.
//
//

import UIKit
import TinyLog
import Photos

// MARK: - AssetsPickerViewControllerDelegate
@objc public protocol AssetsPickerViewControllerDelegate: class {
    @objc optional func assetsPickerDidCancel(controller: AssetsPickerViewController)
    @objc optional func assetsPickerCannotAccessPhotoLibrary(controller: AssetsPickerViewController)
    func assetsPicker(controller: AssetsPickerViewController, selected assets: [PHAsset])
    @objc optional func assetsPicker(controller: AssetsPickerViewController, shouldSelect asset: PHAsset, at indexPath: IndexPath) -> Bool
    @objc optional func assetsPicker(controller: AssetsPickerViewController, didSelect asset: PHAsset, at indexPath: IndexPath)
    @objc optional func assetsPicker(controller: AssetsPickerViewController, shouldDeselect asset: PHAsset, at indexPath: IndexPath) -> Bool
    @objc optional func assetsPicker(controller: AssetsPickerViewController, didDeselect asset: PHAsset, at indexPath: IndexPath)
    @objc optional func assetsPicker(controller: AssetsPickerViewController, didDismissByCancelling byCancel: Bool)
}

// MARK: - AssetsPickerViewController
open class AssetsPickerViewController: UINavigationController {
    
    @objc open weak var pickerDelegate: AssetsPickerViewControllerDelegate?
    open var selectedAssets: [PHAsset] {
        return photoViewController.selectedAssets
    }
    
    open var isShowLog: Bool = false
    private var pickerConfig: AssetsPickerConfig!
    
    open var photoViewController: AssetsPhotoViewController!
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupPhotoController(type: AssetsPhotoViewController.self)
        commonInit()
    }
    
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setupPhotoController(type: AssetsPhotoViewController.self)
        commonInit()
    }
    
    public init(pickerConfig: AssetsPickerConfig? = nil) {
        self.pickerConfig = pickerConfig
        super.init(nibName: nil, bundle: nil)
       setupPhotoController(type: AssetsPhotoViewController.self)
        commonInit()
    }
    
    public func setupPhotoController<T:AssetsPhotoViewController>(type:T.Type) {
        var config: AssetsPickerConfig!
        if let pickerConfig = self.pickerConfig {
            config = pickerConfig.prepare()
        } else {
            config = AssetsPickerConfig().prepare()
        }
        self.pickerConfig = config
        AssetsManager.shared.pickerConfig = config
        photoViewController =  T(pickerConfig: config)
    }
    
    public func commonInit() {
        TinyLog.isShowInfoLog = isShowLog
        TinyLog.isShowErrorLog = isShowLog
        AssetsManager.shared.registerObserver()
        viewControllers = [photoViewController]
    }
    
    deinit {
        AssetsManager.shared.clear()
        logd("Released \(type(of: self))")
    }
}
