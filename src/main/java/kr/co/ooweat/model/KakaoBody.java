package kr.co.ooweat.model;

import lombok.Data;

@Data
public class KakaoBody {

	public String type;			// 메세지 타입

	public String msg;			// 메세지

	public String phone;		// 전화번호

	public String button;		// 버튼 URL

}
