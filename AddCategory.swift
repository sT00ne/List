//
//  AddCategory.swift
//  List
//
//  Created by sT00nne on 2/2/15.
//  Copyright (c) 2015 冬. All rights reserved.
//

import UIKit
import SQLite
class AddCategory: UIViewController, UINavigationBarDelegate {
    
    var listName = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        var nav = UINavigationBar(frame: CGRectMake(0, 0, self.view.bounds.size.width, 65))
        //nav.barTintColor = UIColor(red: 0.16, green: 0.47, blue: 0.87, alpha: 1)
        nav.backgroundColor =  UIColor(red: 0.16, green: 0.47, blue: 0.87, alpha: 1)
        nav.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        nav.shadowImage = UIImage()
        nav.delegate = self
        //nav添加左右item
        self.navigationItem.title =  "新清单"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "添加", style: UIBarButtonItemStyle.Bordered, target: self, action: "add:")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.Bordered, target: self, action: "cancel:")
        
        //清单名称填写
        listName = UITextField(frame: CGRectMake(self.view.bounds.size.width * 0.2, 100, self.view.bounds.size.width * 0.7, 50))
        listName.placeholder = "清单名称"
        listName.borderStyle = UITextBorderStyle.RoundedRect
        var listNameImg = UIImage(named: "addCategoryName.png")
        var listNameImgView = UIImageView(image: listNameImg)
        listNameImgView.frame = CGRect(x: listName.bounds.origin.x + 15, y: 100, width: 50, height: 50)
        //view添加
        self.view.addSubview(nav)
        self.view.addSubview(listNameImgView)
        self.view.addSubview(listName)
        self.view.backgroundColor = UIColor.whiteColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func cancel(sender: AnyObject) {
        //按取消返回
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    func add(sender: AnyObject) {
        
        //text为空时，不能添加
        //
        
        //添加数据
        let CategoryName = Expression<String>("CategoryName")
        let Category = database["DB_Category"]
        Category.insert(CategoryName <- "\(listName.text)").ID
        
        for row in database.prepare("SELECT CategoryID, CategoryName FROM DB_Category") {
            println("id: \(row[0]), CategoryName: \(row[1])")
        }
        
        println("add")
        self.navigationController!.popViewControllerAnimated(true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
