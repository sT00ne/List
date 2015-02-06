//
//  ViewController.swift
//  List
//
//  Created by sT00nne on 2/1/15.
//  Copyright (c) 2015 冬. All rights reserved.
//
import UIKit
import SQLite

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //UINavigationControllerDelegate，
    var table = UITableView()
    var leftButton = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //nav
        var nav = UINavigationBar(frame: CGRectMake(0, 0, self.view.bounds.size.width, 65))
        nav.barTintColor = UIColor.lightGrayColor()        
        //table
        table = UITableView(frame: CGRectMake(0, 65, self.view.bounds.size.width, self.view.bounds.size.height - 105), style:UITableViewStyle.Plain)
        table.delegate = self
        table.registerClass(UITableViewCell.self, forCellReuseIdentifier: "CategoryCell")
        table.dataSource = self
        //button
        var addButton = UIButton(frame: CGRectMake(0, 65 + table.bounds.size.height, self.view.bounds.size.height, 40))
        addButton.backgroundColor = UIColor(red: 0.81, green: 0.81, blue: 0.81, alpha: 1)
        addButton.setTitleColor(UIColor(red: 0.16, green: 0.47, blue: 0.87, alpha: 1), forState: UIControlState.Normal)
        //addButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        //addButton.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        addButton.setTitle("添加", forState: UIControlState.Normal)
        addButton.addTarget(self, action: "add:", forControlEvents: .TouchUpInside)
        
        //nav添加左右item
        self.navigationItem.title =  "清单"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "setting.png"), style: UIBarButtonItemStyle.Bordered, target: self, action: "setting:")
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        self.navigationItem.leftBarButtonItem?.title = "编辑"
        //view添加
        self.view.addSubview(nav)
        self.view.addSubview(table)
        self.view.addSubview(addButton)
        view.backgroundColor = UIColor.yellowColor()
        
    }
    
  
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //按钮的跳转
    func add(sender: UIButton!) {
        //点击添加，跳转到添加页面。
        let nav = AddCategory()
        //若处于编辑操作，则完成编辑
        setEditing(false, animated: true)
        self.navigationController!.pushViewController(nav, animated: true)
    }

    func setting(sender: AnyObject!) {
        //跳转设置页面
        let set = Setting()
        setEditing(false, animated: true)
        self.navigationController!.pushViewController(set, animated: true)
    }
    
    //editbuttonitem 的 控制
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.navigationItem.setHidesBackButton(true, animated: true)
        if editing == true {
            self.navigationItem.leftBarButtonItem?.title = "完成"
            table.setEditing(true, animated: true)
        } else {
            self.navigationItem.leftBarButtonItem?.title = "编辑"
            table.setEditing(false, animated: true)
        }
    }
    
    //表的数据加载
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        var count = 0
        for row in database.prepare("SELECT CategoryID, CategoryName FROM DB_Category") {
            count++
        }
        return count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CategoryCell", forIndexPath: indexPath) as UITableViewCell
        
        // Configure the cell...
        //var name:[String!] = []
        var name = [String]()
        var id = [String]()
        for row in database.prepare("SELECT CategoryID, CategoryName FROM DB_Category") {
            id.append("\(row[0]!)")
            name.append("\(row[1]!)")
            //println("\(name)")
        }
        for var i:Int = 0; i <= indexPath.row; i++ {
            cell.textLabel!.text = name[i]
            cell.tag = "\(id[i])".toInt()!
            //println("\(cell.tag)")
        }
        return cell
    }
    
    //编辑删除操作
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        //获取当前cell
        let cell = table.cellForRowAtIndexPath(indexPath) as UITableViewCell!
        println("\(cell.tag)")
        var CategoryID = 0
        //查找到对应条目的数据库中的id
        for row in database.prepare("SELECT CategoryID, CategoryName FROM DB_Category WHERE CategoryID = ?", cell.tag) {
            CategoryID = "\(row[0]!)".toInt()!
            println("\(row[0]!)")
        }
        var id = Expression<Int>("CategoryID")
        var Catagory = database["DB_Category"]
        //删除数据库中数据
        Catagory.filter(id == CategoryID).delete().changes
        //cell的删除动画
        table.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
    }
}

