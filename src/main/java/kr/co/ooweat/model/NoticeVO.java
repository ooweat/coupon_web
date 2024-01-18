package kr.co.ooweat.model;

import lombok.Data;

@Data
public class NoticeVO {
	long noticeSeq;
	long groupSeq;
	String groupName;
	String noticeType;
	String noticeTitle;
	String noticeContent;
	String regDate;
	String expiryDate;
	String useYN;
}
