import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var dataList: [Contents] = []
    
    let url: String = "https://dapi.kakao.com/v2/search/image?query=%EC%BF%A8%EB%A3%A8%EC%85%89%EC%8A%A4%ED%82%A4"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getImage()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func getImage() {
        guard let url = URL(string: url) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("KakaoAK d8b066a3dbb0e888b857f37b667d96d2", forHTTPHeaderField: "Authorization")
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            guard let response = response as? HTTPURLResponse else { return }
            guard error == nil else { return  }
            
            switch response.statusCode {
            case 200:
                guard let data = try? JSONDecoder().decode(Image.self, from: data) else { return }
                self.dataList = data.documents
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            default:
                print("데이터 연결 실패")
            }
        }
        dataTask.resume()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell" , for: indexPath) as? MyCell else { return UITableViewCell() }
        
        if let imageURL = URL(string: dataList[indexPath.row].image_url), let imageData = try? Data(contentsOf: imageURL) {
            cell.myImageView.image = UIImage(data: imageData)
        }
        
        return cell
    }
}

class MyCell: UITableViewCell {
    @IBOutlet weak var myImageView: UIImageView!
}
