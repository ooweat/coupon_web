package kr.co.ooweat.common;

import org.json.simple.JSONObject;

@SuppressWarnings("unchecked")
public class JsonCreate {

	private static JsonCreate instance = new JsonCreate();

	public static JsonCreate getInstance() {
		return instance;
	}


	// 공통 에러 메시지 Json 파싱 메소드
	public static JSONObject errorParsing(String type){
		JSONObject json = new JSONObject();
		json.put("code", ResponseCode.ILLEGAL_HEADER.getCode());
		json.put("message", ResponseCode.ILLEGAL_HEADER.getCode());
		json.put("description", ResponseCode.ILLEGAL_HEADER.getDescription());
		json.put("type", type);
		return json;
	}

	public static JSONObject errorParsing(String type,String msg){
		JSONObject json = new JSONObject();
		json.put("message", msg);
		json.put("type", type);
		return json;
	}

	public static JSONObject errorParsing(String type, String code, String description, String message){
		JSONObject json = new JSONObject();
		json.put("code", code);
		json.put("message", message);
		json.put("description", description);
		json.put("type", type);
		return json;
	}

	public static JSONObject successParsing(String type){
		JSONObject json = new JSONObject();
		json.put("message", "Data Insert Success!");
		json.put("type", type);
		return json;
	}

	public static JSONObject successParsing(String type, String code, String description){
		JSONObject json = new JSONObject();
		json.put("code", code);
		json.put("message", code);
		json.put("description", description);
		json.put("type", type);
		return json;
	}

	public static JSONObject successParsing(String type, String code, String description, String message){
		JSONObject json = new JSONObject();
		json.put("code", code);
		json.put("message", message);
		json.put("description", description);
		json.put("type", type);
		return json;
	}

	public static JSONObject dbInsertErrorParsing(String type){
		JSONObject json = new JSONObject();
		json.put("message", "Data Insert Error!");
		json.put("type", type);
		return json;
	}


}
