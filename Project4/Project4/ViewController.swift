//
//  ViewController.swift
//  Project4
//
//  Created by Mehmet Subaşı on 22.06.2022.
//

import UIKit
import WebKit


class ViewController: UIViewController, WKNavigationDelegate {
    
    var webView : WKWebView!
    var progressView : UIProgressView!  //Progress of loading...
    var webSites = [ "apple.com", "hackingwithswift.com"]
    
    
    //MARK: - WebKit için bu fonksiyon viewDidLoad'dan önce çağırılır.
    override func loadView() {
        super.loadView()
    
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
       
        
        //MARK: - Toolbar Buttons / Items
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        let forward = UIBarButtonItem(title: "Forward", style: .plain, target: webView, action: #selector(webView.goForward))
        let backward = UIBarButtonItem(title: "Backward", style: .plain, target: webView, action: #selector(webView.goBack))
        // Target is declared and any other thing is not done for refresh button.
        
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        
        //MARK: Thanks to spacer button, refresh button is placed on the right
        toolbarItems = [progressButton, spacer, backward, forward, refresh]
        navigationController?.isToolbarHidden = false
        
        //MARK: KeyValue Observer for WKWebView.estimatedProgress
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        
        
        //MARK: - Loading URL
        let url = URL(string: "https://" + webSites[0])!  //Force unwrap is best practice here.
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true  //Backward and forward specialization is added to page by sliding right and left.
        

    }

    
    // MARK: - Action Sheet ve Adding Actions
    @objc func openTapped(){
        let actionSheet = UIAlertController(title: "Open Page", message: nil, preferredStyle: .actionSheet)
        
        for webSite in webSites {
            actionSheet.addAction(UIAlertAction(title: webSite, style: .default, handler: openPage))
        }
        actionSheet.addAction(UIAlertAction(title: "github.com", style: .default, handler: openPage))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        actionSheet.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem  // For iPads
        present(actionSheet, animated: true)
    }
    
    func openPage(action: UIAlertAction){
        guard let actionTitle = action.title else {return}
        if let url = URL(string: "https://" + actionTitle) {
            webView.load(URLRequest(url: url))
        }
        
    }
    
    // MARK: Adding webpage title to navigation bar after webpage is loaded.
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
    //MARK: Change the loading progress regard of observer
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    // MARK: - Decision policy for websites
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        let url = navigationAction.request.url
            if url!.absoluteString.range(of: "about:blank") != nil {
                decisionHandler(.cancel)
                return
            }
        
        
        //let url = navigationAction.request.url
        if let host = url?.host{
            for webSite in webSites {
                if host.contains(webSite){
                    decisionHandler(.allow)
                    return
                }
            }
        }
        
        giveAlert(title: "Blocked Website Trial", message: "This website has been blocked!")
        decisionHandler(.cancel)
        
        
    }
    
    func giveAlert (title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.destructive)
        alert.addAction(okButton)
        present(alert, animated: true)
        
    }

}

