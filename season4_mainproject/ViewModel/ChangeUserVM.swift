//
//  ChangeNickVM.swift
//  season4_mainproject
//
//  Created by TJ on 2023/09/27.
//

import Foundation

protocol PasswordProtocol {
    func getPwResult(code: Int)
}

class ChangeUserVM{
    var delegate: PasswordProtocol!
    func updateNickModel(nickname: String) -> Int {
        
        var codeValue = 0
        
        let access_token : String = UserDefaults.standard.string(forKey: "access_token")!
        let baseUrl = HOST + ":" + PORT + "/user/nickname/" + nickname
        
        let url: URL = URL(string: baseUrl)!
        var request = URLRequest(url: url)
        
        print("urlPath: \(baseUrl)")
        
        // post방식 설정
        request.httpMethod = "PUT"
        request.setValue("Bearer \(access_token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // URLSession 객체를 통해 전송, 응답값 처리
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let httpResponse = response as? HTTPURLResponse {
                codeValue = httpResponse.statusCode
                print("닉변 응답코드 : \(codeValue)")
                return
            }
            // 서버가 응답이 없거나 통신이 실패
            if let e = error {
                NSLog("An error has occured: \(e.localizedDescription)")
                return
            }
            // 응답 처리 로직
            print("comment post success")
        }
        // POST 전송
        task.resume()

        return codeValue
    }
    func updatePasswordModel(currentPW: String, newPW: String) {
        
        
        
        var codeValue = 0
        
        let access_token : String = UserDefaults.standard.string(forKey: "access_token")!
        let baseUrl = HOST + ":" + PORT + "/user/password"
        
        let url: URL = URL(string: baseUrl)!
        var request = URLRequest(url: url)
        
        print("urlPath: \(baseUrl)")
        
        // post방식 설정
        request.httpMethod = "PUT"
        request.setValue("Bearer \(access_token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters = PasswordJSON(current: currentPW, new: newPW)
        guard let uploadData = try? JSONEncoder().encode(parameters)
            else { return }
        
        // URLSession 객체를 통해 전송, 응답값 처리
        let task = URLSession.shared.uploadTask(with: request, from: uploadData) { (data, response, error) in
            if let httpResponse = response as? HTTPURLResponse {
                codeValue = httpResponse.statusCode
                print("닉변 응답코드 : \(codeValue)")
                return
            }
            // 서버가 응답이 없거나 통신이 실패
            if let e = error {
                NSLog("An error has occured: \(e.localizedDescription)")
                return
            }
            // 응답 처리 로직
            print("comment post success")
        }
        // POST 전송
        task.resume()
        DispatchQueue.main.async {
            self.delegate.getPwResult(code: codeValue)
        }
        
    }
}
