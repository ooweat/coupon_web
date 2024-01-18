package kr.co.ooweat.model;

import lombok.Data;

@Data
public class CouponSalesVO {
	long salesSeq;	//테이블 일련번호
	long balSeq;		//발급고유번호

	String couponNo;		//쿠폰번호
	String couponAmt;		//쿠폰금액
	String couponType;
	String transactionNo;	//거래일련번호
	String terminalId;		//단말기 ID
	String tranType;		//거래타입 : 12- 모바일쿠폰결제
	String msgType;			//메시지 타입 : 01: 승인, 02:취소, 06:조회, 08:망취소
	String tranSeqNo;		//단말기거래일련번호
	String tranDate;
	String tranTime;

	int preAmt;			//쿠폰거래전잔액 : 할인쿠폰일경우 할인금액이나 할인율
	int tranAmt;		//쿠폰거래금액조회(06) 경우 승인시 단말기 승인요청 금액
	int aftAmt;			//쿠폰거래후잔액 : 조회(06) 일 경우 거래전 잔액과 동일
	int rtnTranAmt;		//할인쿠폰일 경우 조회시 거래금액에 대해 실제거래할 금액을 리턴

	String appNo;			//승인번호
	String colNo;
	String productCode;
	String productName;

	String replyCode;
	String replyMsg;
	String memo;
	String orgTranDate;		//취소시 원거래일자 저장
	String orgAppNo;		//취소시 원승인번호 저장
	String cnlDate;			//최종상태 승인:01, 승인취소:02,망취소:08 취소시 원거래 상태 역시 변경

	String regDate;			//승인일
	String modDate;			//수정일
	String modAdminId;		//수정자 ID

	long groupSeq;
	String groupName;
	String revMobile;
}
