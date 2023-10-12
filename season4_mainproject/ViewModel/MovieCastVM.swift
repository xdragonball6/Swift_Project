//
//  MovieCastVM.swift
//  season4_mainproject
//
//  Created by 박지환 on 2023/09/26.
//

import Foundation
protocol MovieCastProtocol{
    func itemDownloaded(item: [MovieCastModel])
}

class MovieCastQueryModel{
    var delegate: MovieCastProtocol!
    func fetchDataFromAPI(seq: Int) {
        let PORT = Bundle.main.object(forInfoDictionaryKey: "PORT") as? String ?? ""
        let HOST = Bundle.main.object(forInfoDictionaryKey: "HOST") as? String ?? ""
        // API 엔드포인트 URL
        let apiUrl = "\(HOST):\(PORT)/movie/cast/\(seq)"
        var locations: [MovieCastModel] = []
        // task 변수를 클로저 외부에서 선언
        let task = URLSession.shared.dataTask(with: URL(string: apiUrl)!) { (data, response, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            // 응답 데이터가 있는지 확인
            guard let data = data else {
                print("No data received.")
                return
            }
            
            do {
                // JSON 디코딩
                let decoder = JSONDecoder()
                let movieData = try decoder.decode(MovieCastData.self, from: data)
                // 필요한 작업을 수행하세요
                for movie in movieData.result {
                    let query = MovieCastModel(id: movie.id, imgpath: movie.imgpath, name: movie.name, role: movie.role)
                    locations.append(query)
                }
            } catch {
                print("JSON decoding error: \(error.localizedDescription)")
            }
            DispatchQueue.main.async {
                self.delegate.itemDownloaded(item: locations)
            }
        }
        // task 시작
        task.resume()
    }
}

