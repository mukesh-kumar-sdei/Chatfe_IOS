
import Foundation

struct GetMovieModel : Codable {
	let status : String?
	let code : Int?
	let data : GetMovieData?
    let message : String?

	enum CodingKeys: String, CodingKey {

		case status = "status"
		case code = "code"
		case data = "data"
        case message = "message"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		status = try values.decodeIfPresent(String.self, forKey: .status)
		code = try values.decodeIfPresent(Int.self, forKey: .code)
		data = try values.decodeIfPresent(GetMovieData.self, forKey: .data)
        message = try values.decodeIfPresent(String.self, forKey: .message)
	}

}



struct GetMovieData : Codable {
    let search : [SearchGetMovieData]?
    let totalResults : String?
    let response : String?

    enum CodingKeys: String, CodingKey {

        case search = "Search"
        case totalResults = "totalResults"
        case response = "Response"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        search = try values.decodeIfPresent([SearchGetMovieData].self, forKey: .search)
        totalResults = try values.decodeIfPresent(String.self, forKey: .totalResults)
        response = try values.decodeIfPresent(String.self, forKey: .response)
    }

}



struct SearchGetMovieData : Codable {
    let title : String?
    let year : String?
    let imdbID : String?
    let type : String?
    let poster : String?

    enum CodingKeys: String, CodingKey {

        case title = "Title"
        case year = "Year"
        case imdbID = "imdbID"
        case type = "Type"
        case poster = "Poster"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        year = try values.decodeIfPresent(String.self, forKey: .year)
        imdbID = try values.decodeIfPresent(String.self, forKey: .imdbID)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        poster = try values.decodeIfPresent(String.self, forKey: .poster)
    }

}
