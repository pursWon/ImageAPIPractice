import UIKit
import Alamofire

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var dataList: [Contents] = []
    
    let url: String = "https://dapi.kakao.com/v2/search/image"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAlamofire(url: url)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func getAlamofire(url: String) {
        let headers: HTTPHeaders = [
            "Authorization" : "KakaoAK d8b066a3dbb0e888b857f37b667d96d2"
        ]
        
        let parameters: [String : Any] = [
            "query" : "쿨루셉스키"
        ]
        
        AF.request(url, method: .get, parameters: parameters, headers: headers).responseDecodable(of: Image.self) { response in
            debugPrint(response.value)
            
            if let data = response.value {
                self.dataList = data.documents
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell" , for: indexPath) as? MyCell else { return UITableViewCell() }
        
        if let imageURL = URL(string: dataList[indexPath.row].image_url),
            let imageData = try? Data(contentsOf: imageURL) {
            cell.myImageView.image = UIImage(data: imageData)
        }
        
        return cell
    }
}

class MyCell: UITableViewCell {
    @IBOutlet weak var myImageView: UIImageView!
}
