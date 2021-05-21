//
//  ViewController.swift
//  stockquotes
//
//  Created by Ariel Sehr on 4/1/21.
//

import UIKit

class ViewController: UIViewController {
    
    var stkPrice : Double = 0 // for all controllers
    var stkRes : String = "" // hold current stock price

    @IBOutlet weak var lblProgress: UILabel!
    
    @IBOutlet weak var lblPrice: UILabel!
    
    @IBOutlet weak var lblStkPurchTot: UILabel!
    
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var button: UIButton!
    
    @IBOutlet weak var stepper: UIStepper!
    
    //set counter
    var counter:Int = 0 {
        didSet {
            let fractionalProgress = Float(counter) / 100
            let animated = counter != 0
            
            progressView.setProgress(fractionalProgress, animated: animated)
            //set progress label
            lblProgress.text = ("\(counter/2)%")
        }
    }
    
    @IBAction func segmentControl(_ sender: UISegmentedControl) {
    //start progress bar activity
    self.counter = 0
    for _ in 0..<100 {
        DispatchQueue.global(qos: .background).async { sleep(1)
            DispatchQueue.main.async {
            self.counter += 1
            return
        }
      }
    }
    // reset stepper value and total purchase price
    stepper.value = 0
    lblStkPurchTot.text = "Total purchase amount: $0"
        
    //clear stock result variable for each new outcome
        stkRes = ""
        //intialize array to aprse url data
        var splitUrl : [String] = [""]
        //get segment control choice from user
        let val = sender.selectedSegmentIndex
        let stkName = sender.titleForSegment(at: val)
        
        //grab needed stock data
        if let url = NSURL(string: "https://www.bloomberg.com/quote/\(stkName!):US"),
           let html = try? String(contentsOf: url as URL, encoding:String.Encoding.utf8) {
            let strSplit : String = html
            
        //create a character set of delimiters
            let seperators = CharacterSet(charactersIn:"<span class=\"[^\"]+>([^<]+)")
            //parse string
            splitUrl = strSplit.components(separatedBy: seperators)
        }
        for f in splitUrl {
            if (f.contains("ue%22%3A")) {
                var ct = 1;
                let aCt = f.count
                if (f.contains("%7D%5D%2C%22vo")) {
                    for v in f {
                        if(ct>8 && ct <= aCt - 14) {
                         stkRes += String(v)
                         }
                        ct = ct + 1
                    }
                }
            } // end outer if
        } // end loop
    
        //display stock price
        lblPrice.text! = "$" + stkRes;
        print("Stock symbol: " + stkName! + " Stock Price: $" + stkRes);
        
        //store current stock data into global vars
        stkPrice = (stkRes as NSString).doubleValue
        
        //start progress bar activity
        self.counter = 0
        for _ in 0..<100 {
            DispatchQueue.global(qos: .background).async {
             sleep(1)
            DispatchQueue.main.async {
             self.counter += 1
             return
        }
            }
    }
}
    @IBAction func stepperControl(_ sender: UIStepper) {
        //local variables
        let stepVal = Double(sender.value)
        let stkPurchTot = stepVal * stkPrice
        
        //display stock puchase total
        lblStkPurchTot.text = "Total purchase amount: $" + String(format:"%.2f", stkPurchTot)
    }
    
    @IBAction func button(_ sender: UIButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        lblPrice.text = ""
        lblProgress.text = "0%" //initialize progress bar label value
        progressView.setProgress(0, animated: true)
    }


}

