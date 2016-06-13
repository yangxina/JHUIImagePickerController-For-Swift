//
//  ViewController.swift
//  EaseImagePickerController
//
//  Created by jonhory on 16/6/12.
//
//

import UIKit

let SCREEN = UIScreen.mainScreen().bounds.size

class ViewController: UIViewController,JHImagePickerControllerDelegate {

    var imagePickerController:JHImagePickerController?
    
    var imageView:UIImageView! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        //初始化方法一
//        imagePickerController = JHImagePickerController()
        //初始化方法一的补充设置
        //设置是否缓存(默认为false)
//        imagePickerController?.isCaches = true
        //设置缓存id（当需要缓存时才设置）
//        imagePickerController?.identifier = "xx"
        
        //初始化方法二
        imagePickerController = JHImagePickerController(isCaches: true, identifier: "abc")
        //设置选择图片后回调的代理协议
        imagePickerController?.delegate = self
        
        imageView = UIImageView(frame: CGRectMake(10, 100, SCREEN.width - 20, SCREEN.height - 280))
        imageView.backgroundColor = UIColor.lightGrayColor()
        imageView.contentMode = .ScaleAspectFit
        self.view.addSubview(imageView)
        
        creatBtnWithTitle("选取图片", centerY: SCREEN.height - 50, action: #selector(selectImageClicked))
        
        creatBtnWithTitle("读取图片", centerY: SCREEN.height - 100, action: #selector(readImageClicked))
        
        creatBtnWithTitle("删除全部缓存", centerY: SCREEN.height - 150, action: #selector(deleteImageClicked))
        // Do any additional setup after loading the view, typically from a nib.
    }

    func creatBtnWithTitle(title:String,centerY y:CGFloat,action:Selector) {
        let button = UIButton(frame: CGRectMake(0,0,200,40))
        button.center = CGPointMake(SCREEN.width/2, y);
        button.backgroundColor = UIColor.orangeColor()
        button.addTarget(self, action: action, forControlEvents: .TouchUpInside)
        button.setTitle(title, forState: .Normal)
        self.view.addSubview(button)
    }
    
    //选取图片
    func selectImageClicked() {
        let alert = UIAlertController(title: "", message: "Choose the photo you like", preferredStyle: .Alert)
        let cameraAction = UIAlertAction(title: "From camera roll", style: .Default) { (action) in
            //图片来自相机闭包 注意使用[weak self] 防止强引用
            self.imagePickerController?.selectImageFromCameraSuccess({[weak self](imagePickerController) in
                    if let strongSelf = self {
                        strongSelf.presentViewController(imagePickerController, animated: true, completion: nil)
                    }
                }, Fail: {
                    //SVProgressHUD.showErrorWithStatus("无法获取相机权限")
            })
        }
        let photoAction = UIAlertAction(title: "Pictures", style: .Default) { (action) in
            //图片来自相册闭包 注意使用[weak self] 防止强引用
            self.imagePickerController?.selectImageFromAlbumSuccess({[weak self] (imagePickerController) in
                if let strongSelf = self {
                    strongSelf.presentViewController(imagePickerController, animated: true, completion: nil)
                }
                }, Fail: {
                    //SVProgressHUD.showErrorWithStatus("无法获取照片权限")
            })
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
        alert.addAction(cameraAction)
        alert.addAction(photoAction)
        alert.addAction(cancelAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    //根据identifier读取缓存图片
    func readImageClicked() {
        let image = self.imagePickerController?.readImageFromCaches("abc")
        if image?.accessibilityIdentifier != "jhSurprise.jpg" {
            imageView.image = image
        }else {
            print("读取缓存照片失败,请检查图片identifier是否存在")
            imageView.image = image
        }
    }
    
    func deleteImageClicked(){
        //删除指定identifier的缓存图片
//        self.imagePickerController?.removeCachesPictureForIdentifier("abc")
        //删除全部缓存图片
        if self.imagePickerController?.removeCachesPictures() == true {
            print("删除全部缓存图片成功")
        }
    }
    
    //MARK:JHImagePickerControllerDelegate
    //当设置了缓存，且输入缓存identifier时返回该方法
    func selectImageFinishedAndCaches(image: UIImage, cachesIdentifier: String, isCachesSuccess: Bool) {
        if isCachesSuccess == true {
            imageView.image = image
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //当未设置缓存或缓存identifier为空时返回该方法
    func selectImageFinished(image: UIImage) {
        imageView.image = image
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
