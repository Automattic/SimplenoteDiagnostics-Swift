import Foundation
import Cocoa
import Alamofire

class ViewController: NSViewController {

    @IBOutlet var authenticationResponseTextView: NSTextView!
    @IBOutlet var progressIndicator: NSProgressIndicator!


    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear() {
        super.viewWillAppear()
        ensureWindowsIsVisible()
        performAuth()
    }

    func ensureWindowsIsVisible() {
        view.window?.makeKeyAndOrderFront(self)
    }


    @IBAction
    func retryAuth(sender: Any) {
        authenticationResponseTextView.string = ""
        performAuth()
    }

    func performAuth() {
        let url = "https://auth.simperium.com/1/" + SPCredentials.simperiumAppID + "/authorize/"
        let login = Login(username: "test1234@test1234.test", password: "test1234")

        let headers: HTTPHeaders = [
            "X-Simperium-API-Key": SPCredentials.simperiumApiKey,
            "Content-Type": "application/json"
        ]

        progressIndicator.startAnimation(self)
        progressIndicator.isHidden = false

        AF.request(url,
                   method: .post,
                   parameters: login,
                   encoder: JSONParameterEncoder.default,
                   headers: headers).response { response in

            self.display(response: response.debugDescription)
            self.progressIndicator.stopAnimation(self)
            self.progressIndicator.isHidden = true
        }
    }

    func display(response: String) {
        authenticationResponseTextView.string = response
    }
}



struct Login: Encodable {
    let username: String
    let password: String
}
