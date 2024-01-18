package kr.co.ooweat.model;

import lombok.Data;

@Data
public class MemberVO {
	long memberSeq;
	long groupSeq;
	String groupName;
	String memberId;
	String loginId;
	String loginPw;
	String memberName;
	String vm;
	String memo;
	String level;
	String useYN;
	String regDate;
	String modDate;
	String modAdminId;
	String etc1;
	String etc2;
	String etc3;
}
