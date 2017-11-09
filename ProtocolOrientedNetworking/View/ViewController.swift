//
//  ViewController.swift
//  ProtocolOrientedNetworking
//
//  Created by Luke Smith on 07/11/2017.
//  Copyright © 2017 LukeSmith. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var address1Label: UILabel!
    @IBOutlet weak var address2Label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func testCallClicked(_ sender: Any) {
        self.testCall()
    }
    
    func testCall() {
        do {
            //url request is created by the Router enum (including the headers etc)
            var urlRequest = try Router.testCall.asURLRequest()
            
            //any JSON for eg that we might want to attach to the call is
            //created by the createTestHTTPBody function
            urlRequest.httpBody = self.createTestHTTPBody()
            
            //the call is done by calling fetch on the UserData model object, which is made
            //possible by conforming UserData to the Networkable protocol (and Unboxable too)
            UserData.call(with: urlRequest, onSuccess: { result in
                switch result {
                case .asSelf(let userData):
                    userData.printContents()
                case .asDictionary(let userDataDict):
                    print("Dictionary of UserData's : \(userDataDict)")
                case .asArray(let userDataArray):
                    print("Array of UserData's : \(userDataArray)")
                case .raw(let rawData):
                    print("Raw Data back : \(rawData)")
                }
            }, onError: { error in
                print("Failed the test call, \(error.localizedDescription)")
            })
        } catch {
            //if our Router failed to create a url with the given params, we catch that here
            print("Unable to create url request")
        }
    }
    
    //convert some JSON into data, to attach to the call
    func createTestHTTPBody() -> Data? {
        let bodyString1 = "testString1"
        let bodyString2 = "testString2"
        let bodyJSON = ["test_String1": bodyString1, "test_String2": bodyString2]
        do {
            let data = try JSONSerialization.data(withJSONObject: bodyJSON, options: .prettyPrinted)
            return data
        } catch {
            print("Unable to create login data")
            return nil
        }
    }
}

