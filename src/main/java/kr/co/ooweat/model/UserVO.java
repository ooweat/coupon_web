package kr.co.ooweat.model;

import lombok.Data;

@Data
public class UserVO {
	long userSeq;
	long groupSeq;
	String groupName;
	String userId;
	String userPw;
	String userOriginPw;
	String userName;
	String role;
	String regDate;
	String modDate;
	String modAdminId;
	String useYN;
	long companySeq;
	String companyName;
	char useDashboard;
	char useCouponPublish;
	char useCouponConfig;
	char useCouponIssuanceHistory;
	char useCouponSalesHistory;
	
	char useGiftYn;
	char useRuseYn;
}
