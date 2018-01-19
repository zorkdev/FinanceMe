import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var balanceLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let configURL = Bundle.main.url(forResource: "config", withExtension: "json"),
            let configData = try? Data(contentsOf: configURL),
            let configJSON = try? JSONSerialization.jsonObject(with: configData, options: []),
            let configDict = configJSON as? [String: String],
            let token = configDict["token"] else { return }

        let urlString = "https://api.starlingbank.com/api/v1/accounts/balance"
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)

        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard error == nil,
                let data = data,
                let json = try? JSONSerialization.jsonObject(with: data, options: []),
                let dict = json as? [String: Any]  else { return }

            if let balance = dict["effectiveBalance"] as? Double {
                DispatchQueue.main.async {
                    self?.balanceLabel.text = String(format: "£%.2f", balance)
                }
            }
        }
        task.resume()
    }

}

