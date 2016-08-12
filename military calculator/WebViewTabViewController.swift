//
//  WebViewTabViewController.swift
//  military calculator
//
//  Created by ABC on 2016. 3. 30..
//  Copyright © 2016년 ABC. All rights reserved.
//

import UIKit

class WebViewTabViewController: UIViewController {
    
    
    @IBOutlet var webview: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let url = NSURL(string: "http://cafe.naver.com/komusincafe")
        let request = NSURLRequest(URL: url!)
        webview.loadRequest(request)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
