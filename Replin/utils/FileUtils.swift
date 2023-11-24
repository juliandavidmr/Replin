//
//  FileUtils.swift
//  Replin
//
//  Created by Julian on 23/11/23.
//

import Foundation

class FileUtils {
    static func getTextContent(fileURL: URL) -> String {
        // Obtén la URL del archivo
        var content = ""

        do {
            // Lee el contenido del archivo
            content = try String(contentsOf: fileURL, encoding: .utf8)
            // print("Contenido del archivo:\n\(content)")
        } catch {
            // Maneja cualquier error que pueda ocurrir al leer el archivo
            print("Error al leer el archivo:\n\(error)")
        }
        
        return content
    }
    
    static func parseJSON(_ json: Any, into result: inout [String: String]) {
        guard let json = json as? [String: Any] else {
            return
        }
        
        for (key, value) in json {
            if let value = value as? String {
                result[key] = value
            } else if let value = value as? [String: Any] {
                parseJSON(value, into: &result)
            }
        }
    }
    
    static func extractJSONKeysAndValues(_ text: String) -> [KeyValueItem] {
        var items = [KeyValueItem]()
        let pattern = #"\"?(.*?)\"?\s*:\s*(.*?)(,|"|$)"#
        
        let regex = try! NSRegularExpression(pattern: pattern)
        let matches = regex.matches(in: text, range: NSRange(text.startIndex..., in: text))
        
        for match in matches {
            let key = (text as NSString).substring(with: match.range(at: 1))
            let value = (text as NSString).substring(with: match.range(at: 2))
            // print("\(key): \(value)")
            
            items.append(KeyValueItem(key: key, value: value))
        }
        
        return items
    }

}
