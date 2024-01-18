package kr.co.ooweat.model;

import lombok.Data;

@Data
public class GroupVO {
	long groupSeq;
	String groupName;
	String adminId;
	String regDate;
	String modDate;
}
