
import Foundation

struct EditRoomModel : Codable {
	let status : String?
	let data : EditRoomData?
	let code : Int?

	enum CodingKeys: String, CodingKey {

		case status = "status"
		case data = "data"
		case code = "code"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		status = try values.decodeIfPresent(String.self, forKey: .status)
		data = try values.decodeIfPresent(EditRoomData.self, forKey: .data)
		code = try values.decodeIfPresent(Int.self, forKey: .code)
	}

}


struct EditRoomData : Codable {
    let createdAt : String?
    let updatedAt : String?
    let roomType : String?
    let __v : Int?
    let roomClass : String?
    let about : String?
    let _id : String?
    let endDate : String?
    let roomName : String?
//    let date : String?
    let createdBy : String?
//    let endTime : String?
    let image : String?
    let startDate : String?
    let duration : Double?
//    let startTime : String?
    let status : String?
    let categoryId : String?

    enum CodingKeys: String, CodingKey {

        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
        case roomType = "roomType"
        case __v = "__v"
        case roomClass = "roomClass"
        case about = "about"
        case _id = "_id"
        case endDate = "endDate"
        case roomName = "roomName"
//        case date = "date"
        case createdBy = "createdBy"
//        case endTime = "endTime"
        case image = "image"
        case startDate = "startDate"
        case duration = "duration"
//        case startTime = "startTime"
        case status = "status"
        case categoryId = "categoryId"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        roomType = try values.decodeIfPresent(String.self, forKey: .roomType)
        __v = try values.decodeIfPresent(Int.self, forKey: .__v)
        roomClass = try values.decodeIfPresent(String.self, forKey: .roomClass)
        about = try values.decodeIfPresent(String.self, forKey: .about)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        endDate = try values.decodeIfPresent(String.self, forKey: .endDate)
        roomName = try values.decodeIfPresent(String.self, forKey: .roomName)
//        date = try values.decodeIfPresent(String.self, forKey: .date)
        createdBy = try values.decodeIfPresent(String.self, forKey: .createdBy)
//        endTime = try values.decodeIfPresent(String.self, forKey: .endTime)
        image = try values.decodeIfPresent(String.self, forKey: .image)
        startDate = try values.decodeIfPresent(String.self, forKey: .startDate)
        duration = try values.decodeIfPresent(Double.self, forKey: .duration)
//        startTime = try values.decodeIfPresent(String.self, forKey: .startTime)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        categoryId = try values.decodeIfPresent(String.self, forKey: .categoryId)
    }

}
