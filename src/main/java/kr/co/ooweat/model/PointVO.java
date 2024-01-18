package kr.co.ooweat.model;

import lombok.Data;

//2021.11.30
@Data
public class PointVO {
	String transactionNo;
	long groupSeq;
	String groupName;
	String memberId;
	String memberName;
	String terminalId;

	String tranDate;
	String tranTime;
	String tranType;
	String msgStep;
	long tranAmt;
	long colNo;
	String cabinetNo;
	String tranSeqNo;

	String replyCode;
	String replyMsg;

	String regDate;
	String modDate;
	String memo;
	String modAdminId;
	String etc1;
	String etc2;
	String etc3;

	String cancelDate;
	String cancelTime;
	long prePoint;
	long postPoint;
	long productAmt;

	// 전문 구분(2)
	String messageType; // 포인트 취소 : 02, 망상취소 : 08
	// 입력매체 구분코드(1)
	char inputType; // 포인트 : P
	// 전문 버전(2) - AN
	String messageVersion; // T1
	// 전문 암호화 여부(1) - AN
	char cryptoFlag; // 암호화 안함 : 0, 암호화 :1
	// RFU(10) - AN
	String rfu; // 부가세로도 사용
}
