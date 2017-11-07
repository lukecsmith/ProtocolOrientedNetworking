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
            //url request is created by the Router enum
            var urlRequest = try Router.testCall.asURLRequest()
            
            //any JSON for eg that we might want to attach to the call is
            //created by the createTestHTTPBody function
            urlRequest.httpBody = self.createTestHTTPBody()
            
            //the call is done by calling fetch on the UserData model object, which is made
            //possible by conforming UserData to the Fetchable protocol (and Unboxable too)
            let _ = UserData.fetch(with: urlRequest, onSuccess: { result in
                //handle call success
                print("*** Succesfully fetched user data, \(result)")
            }, onError: { error in
                //handle call failure (call went - but server returned an error)
                print("Failed the test call, \(error.localizedDescription)")
            })
        } catch {
            //if our Router failed to create a url with the given params, we catch that here
            print("Unable to create url request")
        }
    }
    
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

