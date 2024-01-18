package kr.co.ooweat.model;

import lombok.Data;

@Data
public class CouponVO {
	long balSeq;
	int groupSeq;
	int userSeq;
	String groupName;
	String couponNo;
	String terminalId;
	String couponType;
	int couponAmt;
	int couponReAmt;
	String couponStat;
	int discntInfo;
	String expireDay;
	String revMobile;
	int sendCnt;
	String regDate;
	String regTime;
	String modDate;

	String userId;
	String couponBin;
	String couponCount;
	String couponConfCount;
	String merchantName;		//이용가능한 가맹점
	
	int page;
}
