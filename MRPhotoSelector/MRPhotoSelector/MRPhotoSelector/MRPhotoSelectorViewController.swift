//
//  MRPhotoSelectorViewController.swift
//  MRPhotoSelectorDemo
//
//  Created by 乐浩 on 16/5/31.
//  Copyright © 2016年 乐浩. All rights reserved.
//

import UIKit

let MRPhotoSelectorCellReuseIdentifier = "MRPhotoSelectorCellReuseIdentifier"

class MRPhotoSelectorViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI() {
        
        //1.添加子控件
        view.addSubview(collectionView)
        
        //2.布局子控件
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        var cons = [NSLayoutConstraint]()
        cons += NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[collectionView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["collectionView": collectionView])
        
        cons += NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[collectionView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["collectionView": collectionView])
        view.addConstraints(cons)
    }
    
    //MARK: - 懒加载
    private lazy var collectionView: UICollectionView = {
        let clv = UICollectionView(frame: CGRectZero, collectionViewLayout: MRPhotoSelectorViewLayout())
        
        //注册一个cell
        clv.registerClass(MRPhotoSelectorCell.self, forCellWithReuseIdentifier: MRPhotoSelectorCellReuseIdentifier)
        
        clv.backgroundColor = UIColor.lightGrayColor()
        
        //设置数据源
        clv.dataSource = self
        
        return clv
    }()
    
    private lazy var pictures = [UIImage]()
}

//MARK: - UICollectionViewDataSource
extension MRPhotoSelectorViewController: UICollectionViewDataSource, MRPhotoSelectorCellDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures.count + 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(MRPhotoSelectorCellReuseIdentifier, forIndexPath: indexPath) as! MRPhotoSelectorCell
        
        cell.backgroundColor = UIColor.whiteColor()
        
        cell.PhotoSelectorDelegate = self
        
        cell.image = (pictures.count == indexPath.item) ? nil : pictures[indexPath.item]
        
        print("pictures.count---- \(pictures.count)")
        print("indexPath.item---- \(indexPath.item)")
        
        return cell
    }
    
    //MARK: - MRPhotoSelectorCellDelegate
    func photoSelectorCellDidAddPhoto(cell: MRPhotoSelectorCell) {

        //1.判断是否能打开照片库
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary){
            print("I MISS MR ---- 不能打开相册")
            return
        }
        
        //2.创建图片选择器
        let vc = UIImagePickerController()
        vc.delegate = self

        presentViewController(vc, animated: true, completion: nil)
        
    }
    
    //MARK: - UINavigationControllerDelegate, UIImagePickerControllerDelegate
    
    /**
     选中图片之后调用该方法
     
     - parameter picker:      触发事件的控制器
     - parameter image:       当前选中的图片
     - parameter editingInfo: 编辑之后的图片
     */
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {

        print("I MISS MR ---- \(image)")
        
        //根据分类的方法(指定宽度，根据宽高比压缩图片)
        let newImage = image.imageWithScale(300)
        
        //1.将选中的图片添加到pictures这个数组中
        pictures.append(newImage)
        
        //2.刷新表格
        collectionView.reloadData()
        
        //这里实现了pickerController的代理方法，所以要我们自己关闭图片选择器
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: - MRPhotoSelectorCellDelegate
    func photoSelectorCellDidRemovePhoto(cell: MRPhotoSelectorCell) {
        
        //1.从数组中移除 “当前点击” 的图片
        let indexPath = collectionView.indexPathForCell(cell)
        pictures.removeAtIndex(indexPath!.item)
        
        //2.刷新表格
        collectionView.reloadData()
        
    }
}

@objc
protocol MRPhotoSelectorCellDelegate: NSObjectProtocol {
    
    optional func photoSelectorCellDidAddPhoto(cell: MRPhotoSelectorCell)
    optional func photoSelectorCellDidRemovePhoto(cell: MRPhotoSelectorCell)
}

class MRPhotoSelectorCell: UICollectionViewCell {
    
    weak var PhotoSelectorDelegate: MRPhotoSelectorCellDelegate?
    
    var image: UIImage?{
        didSet{
            if image != nil {
                removeButton.hidden = false
                addButton.setBackgroundImage(image!, forState: UIControlState.Normal)
                addButton.userInteractionEnabled = false
            }else {
                removeButton.hidden = true
                addButton.userInteractionEnabled = true
                addButton.setBackgroundImage(UIImage(named: "compose_pic_add"), forState: UIControlState.Normal)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    private func setupUI() {
        
        //1.添加子控件
        contentView.addSubview(addButton)
        contentView.addSubview(removeButton)
        
        //2.布局子控件
        addButton.translatesAutoresizingMaskIntoConstraints = false
        removeButton.translatesAutoresizingMaskIntoConstraints = false
        
        var cons = [NSLayoutConstraint]()
        cons += NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[addButton]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["addButton": addButton])
        cons += NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[addButton]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["addButton": addButton])
        
        cons += NSLayoutConstraint.constraintsWithVisualFormat("H:[removeButton]-2-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["removeButton": removeButton])
        cons += NSLayoutConstraint.constraintsWithVisualFormat("V:|-2-[removeButton]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["removeButton": removeButton])
        
        
        contentView.addConstraints(cons)
    }
    
    //MARK: - 懒加载
    private lazy var addButton: UIButton = {
        let btn = UIButton()
        btn.contentMode = UIViewContentMode.ScaleAspectFill
        btn.setBackgroundImage(UIImage(named: "compose_pic_add"), forState: UIControlState.Normal)
        btn.addTarget(self, action: #selector(MRPhotoSelectorCell.addBtnClick), forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()
    
    private lazy var removeButton: UIButton = {
        let btn = UIButton()
        btn.hidden = true
        btn.setBackgroundImage(UIImage(named: "compose_photo_close"), forState: UIControlState.Normal)
        btn.addTarget(self, action: #selector(MRPhotoSelectorCell.removeBtnClick), forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()
    
    func addBtnClick(){
        
        print("I MISS MR ---- ADD")
        //调用代理
        PhotoSelectorDelegate?.photoSelectorCellDidAddPhoto!(self)
    }
    
    func removeBtnClick() {
        
        print("I MISS MR ---- REMOVE")
        //调用代理
        PhotoSelectorDelegate?.photoSelectorCellDidRemovePhoto!(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MRPhotoSelectorViewLayout: UICollectionViewFlowLayout {
    
    override func prepareLayout() {
        
        let width = (UIScreen.mainScreen().bounds.width - 40) / 3
        itemSize = CGSize(width: width, height: width)
        minimumLineSpacing = 10
        minimumInteritemSpacing = 10
        sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}