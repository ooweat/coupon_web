package kr.co.ooweat.model;

import lombok.Data;

import java.util.HashMap;
import java.util.List;

@Data
public class AlertModel {
	String receiver;		//연락처
	String templateType;		//템플릿 타입
	String service;		//서비스
	String title;		//타이틀
	String content;		//내용
	String snedDate;		//날짜
	HashMap<String, String> paramMap;	//Map 형식의 파라미터
	List<HashMap<String, String>> paramListMap;	//List<Map> 형식의 파라미터
}
