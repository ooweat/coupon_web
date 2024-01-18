package kr.co.ooweat.model;

import lombok.Data;

@Data
public class MemberGroupVO {
	long seq;
	long groupSeq;
	String groupName;
	String adminId;
	String regDate;
	String modDate;

	String businessNo;
	long companySeq;
	String companyName;
	String businessName;
	String etc1;
	String etc2;
	String etc3;
}
