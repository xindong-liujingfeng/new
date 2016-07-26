//
//  ViewController.swift
//  IMONEY
//
//  Copyright © 2016年 L_J_F. All rights reserved.
//

import UIKit
import CoreData
class ViewController: UIViewController,UIScrollViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,NSURLSessionDataDelegate {
    var button:UIButton?
    var scrollView : UIScrollView?
    var keyArray : NSMutableArray?
    var valueArray : NSMutableArray?
    var pickView: UIPickerView?
    var leftTableVeiw : UITableView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.keyArray = NSMutableArray()
        self.valueArray = NSMutableArray()
        
        
        requestUrl("http://app-cdn.2q10.com/api/v2/currency?ver=iphone")
        
        creatScrollView()
//        自定义view创建
        creatSelfView()
        
        leftTableView()
        
        creatPickView()
        
        creatButton()
        
        
        
        
    }
   
    func creatButton() -> Void {
        self.button = UIButton(type: UIButtonType.System)
        self.button!.frame = CGRectMake(10 + (self.leftTableVeiw?.frame.size.width)!, (self.scrollView?.frame.size.height)! / 2 - 40 , 40, 80)
        self.button!.backgroundColor = UIColor.whiteColor()
        self.button!.setTitle("添加", forState: UIControlState.Normal)
        self.button!.setTitleColor(UIColor.blackColor(),forState: .Normal)
        self.button!.addTarget(self, action: #selector(ViewController.buttonDid), forControlEvents: UIControlEvents.TouchUpInside)
        self.scrollView?.addSubview(self.button!)
    }
    //    MARK:button点击事件
    
    func buttonDid() -> Void {
        //alertViewController创建
        let alert:UIAlertController = UIAlertController(title: "添加", message: "添加新货币", preferredStyle: UIAlertControllerStyle.Alert)
        let aleartAction =  UIAlertAction(title: "确定", style: UIAlertActionStyle.Default) { (action:UIAlertAction) in
            let textField1 = alert.textFields?.first
            let textField2 = alert.textFields?.last
            self.keyArray?.insertObject((textField1?.text)!, atIndex: 0)
            let string = (textField2?.text)! as NSString
            let float = string.floatValue
            let number = NSNumber(float: float)
            
            self.valueArray?.insertObject(number, atIndex: 0)
            
            self.pickView?.reloadAllComponents()
            
            for i:Int in 0...3{
                self.pickView?.selectRow(0, inComponent: i, animated: true)
                let textField = self.scrollView?.viewWithTag(200 + i) as! UITextField
                textField.text = nil
                textField.placeholder = "0.00"
            }
            
            for i:Int in 0...3 {
                self.pickerView(self.pickView!, didSelectRow: 0, inComponent: i)
            }
            
            self.leftTableVeiw?.reloadData()
            
        }
        
        let alearAction1 = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
        
        alert.addTextFieldWithConfigurationHandler { (textfield:UITextField) in
            textfield.placeholder = "输入三字码"
        }
        alert.addTextFieldWithConfigurationHandler { (textfield:UITextField) in
            textfield.placeholder = "输入对美元的汇率值"
        }
        alert.addAction(alearAction1)
        alert.addAction(aleartAction)
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    func creatSelfView() -> Void {
        for i:Int in 0...3{
            let newview = newView()
            newview.frame = CGRectMake(10 + view.frame.size.width, CGFloat(70 * i + 30) , view.frame.size.width - 20 , 60)
            newview.tag = 100 + i
            newview.textField?.delegate = self
            newview.textField?.tag = 200 + i
            scrollView!.addSubview(newview)
            
        }
    }
    
    
    func creatScrollView(){
        
        if scrollView == nil{
            let width:CGFloat = self.view.frame.size.width * 2
            let height:CGFloat = self.view.frame.size.height
            //        scrollview的属性设置
            scrollView = UIScrollView()
            scrollView?.frame = CGRectMake(0, 20, width / 2, height + 20)
            scrollView?.contentSize = CGSizeMake(width, height)
            scrollView?.bounces = false
            scrollView?.contentOffset = CGPointMake(self.view.frame.size.width, 0)
            scrollView?.showsHorizontalScrollIndicator = false
            scrollView?.pagingEnabled = true
            scrollView?.delegate = self
            
            
            let imageView = UIImageView(image: UIImage(named: "back.jpg"))
            
            imageView.frame = CGRectMake(0, 0, width, height)
            //        scrollview添加到视图上
            self.view.addSubview(scrollView!)
            scrollView!.addSubview(imageView)
            
        }
    }
    //    MARK:取消键盘的第一响应（失去焦点)
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.view.endEditing(true)
        
    }
    
    
    //    MARK:自定义view
    class newView:UIView,UITextFieldDelegate {
        var imageView:UIImageView?
        var label:UILabel?
        var textField:UITextField?
        //        MARK:重写初始化方法并初始化自定义view内部控件
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.backgroundColor = UIColor.grayColor()
            self.alpha = 0.8
            
            imageView = UIImageView(frame: CGRectZero)
            imageView?.backgroundColor = UIColor.yellowColor()
            self.addSubview(imageView!)
            
            label = UILabel(frame: CGRectZero )
            label?.text = "HRK"
            label?.textColor = UIColor.whiteColor()
            //            label?.backgroundColor = UIColor.orangeColor()
            self.addSubview(label!)
            
            textField = UITextField(frame: CGRectZero )
            textField?.textColor = UIColor.whiteColor()
            textField?.placeholder = "0.00"
            textField?.textAlignment = NSTextAlignment.Left
            
            
            self.addSubview(textField!)
            
        }
        
        
        //       在layoutsubviews设置自定义控件的frame
        override func layoutSubviews() {
            super.layoutSubviews()
            imageView?.frame = CGRectMake(0, 0, self.frame.size.width / 4,self.frame.size.height)
            
            let imageW:CGFloat = (imageView?.frame.size.width)!
            
            label?.frame = CGRectMake(imageW, 0, self.frame.size.width - imageW,self.frame.size.height/2)
            
            textField?.frame = CGRectMake(imageW, self.frame.size.height / 2, self.frame.size.width - imageW,self.frame.size.height / 2)
            
            textField?.keyboardType = UIKeyboardType.NumbersAndPunctuation
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    //    MARK:pickview
    func creatPickView(){
        
        pickView = UIPickerView()
        let h:CGFloat = self.view.frame.size.height
        let w:CGFloat = self.view.frame.size.width
        pickView?.backgroundColor = UIColor.grayColor()
        pickView?.alpha = 0.8
        pickView?.frame = CGRectMake(10 + self.view.frame.size.width, h * 0.6, w - 20, h / 3)
        pickView?.delegate = self
        pickView?.dataSource = self
        scrollView!.addSubview(pickView!)
        
    }
    
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 4
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return (self.keyArray?.count)!
    }
    
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return self.keyArray![row] as? String
    }
    
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 45
    }
    
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let view:newView?
        view = newView()
        
        switch component {
        case 0:
            (scrollView?.viewWithTag(100) as! newView).label?.text =  self.keyArray![row] as? String
            self.textFieldDidEndEditing(self.scrollView?.viewWithTag(200) as! UITextField)
            
        case 1:
            (scrollView?.viewWithTag(101) as! newView).label?.text =  self.keyArray![row] as? String
            self.textFieldDidEndEditing(self.scrollView?.viewWithTag(201) as! UITextField)
            
        case 2:
            (scrollView?.viewWithTag(102) as! newView).label?.text =  self.keyArray![row] as? String
            self.textFieldDidEndEditing(self.scrollView?.viewWithTag(202) as! UITextField)
            
        case 3:
            (scrollView?.viewWithTag(103) as! newView).label?.text =  self.keyArray![row] as? String
            self.textFieldDidEndEditing(self.scrollView?.viewWithTag(203) as! UITextField)
            
        default: break
            
        }
        
    }
    
    
    //    MARK:textField的代理方法
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        textField.placeholder = "按此输入金额"
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    //           MARK:计算用户输入的倍数并且刷新所有textfield的数据
    func textFieldDidEndEditing(textField: UITextField) {
        
        if textField.text ==  "" || textField.text == "0.00" {
            
            textField.placeholder = "0.00"
        }
        else{
            //            用户输入数字转换为浮点型显示
            let value =  (textField.text! as NSString ).floatValue
            textField.text = String(format: "%.2f", value)
            //            计算选中的textfield与其本身汇率的倍数
            let multiple = self.editMultiple(textField)
            //            找出非被选中textfield的存在值，并且乘以对应倍数，刷新其对应倍率的数据
            self.editUnSelected(textField , multiple:multiple )
        }
        
    }
    
    func editMultiple(textField:UITextField) -> Float {
        //选中的textField所在的自定义view，获取其对比美金的汇率
        let view:newView = self.scrollView?.viewWithTag(textField.tag - 100) as! newView
        var index: Int = 0
        //取出label.text对应的汇率
        for string in self.keyArray! {
            if string.isEqualToString((view.label?.text)!) {
                break
            }
            index += 1
        }
        //    获得选中textfield的汇率值（兑美元）
        let number:NSNumber = self.valueArray![index] as! NSNumber
        let valueString:String = textField.text!
        let newString = NSString(string: valueString).floatValue
        let multiple:Float = newString  / number.floatValue
        
        return multiple
    }
    
    func editUnSelected(textField:UITextField,multiple:Float) -> Void {
        for i:Int in 0...3{
            if i != textField.tag - 200  {
                let myView:newView = self.scrollView?.viewWithTag(100 + i) as! newView
                var newIndex: Int = 0
                
                //取出label.text对应的汇率
                for string in self.keyArray! {
                    if string.isEqualToString((myView.label?.text)!) {
                        break
                    }
                    newIndex += 1
                }
                let newNumber:NSNumber = self.valueArray![newIndex] as! NSNumber
                let answer:Float = newNumber.floatValue * multiple
                myView.textField?.text = String(format: "%.2f", answer)
                
            }
            
        }
        
    }
    
    
    //   MARK:lefttableview
    func leftTableView(){
        
        let rect:CGRect = CGRectMake(10, 20, self.view.frame.size.width - 50, self.view.frame.size.height - 60)
        
        self.leftTableVeiw = UITableView(frame:rect, style: UITableViewStyle.Grouped)
        self.leftTableVeiw!.backgroundColor = UIColor.grayColor()
        self.leftTableVeiw!.dataSource = self
        self.leftTableVeiw!.delegate = self
        
        scrollView?.addSubview(self.leftTableVeiw!)
        
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (self.keyArray?.count)!
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //        直接取tableview得cell判断没有再去创建
        var  cell = tableView.dequeueReusableCellWithIdentifier("tableView")
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "tableView")
        }
        
        if self.keyArray!.count > indexPath.row {
            cell?.textLabel?.text = self.keyArray![indexPath.row] as? String
        }
        
        cell?.backgroundColor = UIColor.grayColor()
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.min
    }
    //    MARK:tableview的编辑模式
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        self.keyArray?.removeObjectAtIndex(indexPath.row)
        
        self.valueArray?.removeObjectAtIndex(indexPath.row)
        
        self.leftTableVeiw?.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.tableView(self.leftTableVeiw!, commitEditingStyle: UITableViewCellEditingStyle.Delete, forRowAtIndexPath: indexPath)
        
        self.pickView?.reloadAllComponents()
        
        for i:Int in 0...3 {
            let text:UITextField = self.scrollView?.viewWithTag(200 + i) as! UITextField
            text.text = nil
            text.placeholder = "0.00"
    
        
        }
        
        for i:Int in 0...3{
            self.pickView?.selectRow(0, inComponent: i, animated: true)
        }
        
        for i:Int in 0...3 {
            self.pickerView(self.pickView!, didSelectRow: 0, inComponent: i)
        }
        
        
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    
    //    MARK:网络请求
    func requestUrl(urlString: String){
        
        let url:NSURL = NSURL(string: urlString)!
        // 转换为requset
        let requets:NSURLRequest = NSURLRequest(URL: url)
        //NSURLSession 对象都由一个 NSURLSessionConfiguration 对象来进行初始化，后者指定了刚才提到的那些策略以及一些用来增强移动设备上性能的新选项
        let configuration:NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session:NSURLSession = NSURLSession(configuration: configuration)
        
        let task:NSURLSessionDataTask = session.dataTaskWithRequest(requets, completionHandler: {
            (data:NSData?,response:NSURLResponse?,error:NSError?)->Void in
            if error == nil{
                do{
                    let responseData:NSDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
                    let newDic = responseData.valueForKey("rates")
                    
                    let array :NSArray = (newDic?.allKeys)!
                    self.keyArray = NSMutableArray(array: array)
                    let array1 :NSArray = (newDic?.allValues)!
                    self.valueArray = NSMutableArray(array:array1)
                }
                catch{
                    
                }
            }
            //        在主线程刷新ui
            dispatch_async(dispatch_get_main_queue()){
                self.leftTableVeiw?.reloadData()
                self.pickView?.reloadAllComponents()
            }
            
        })
        // 启动任务
        task.resume()
    }
}

