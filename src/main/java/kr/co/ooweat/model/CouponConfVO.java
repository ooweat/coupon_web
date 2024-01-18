package kr.co.ooweat.model;

import lombok.Data;

@Data
public class CouponConfVO {
    long groupSeq;
    String groupName;
    long mainCompCnt;   //쿠폰 발권 한도 / 0 이면 무제한 (이번 달)
    long mainCompAmt;   //쿠폰 발권 금액 한도 / 0 이면 무제한 (이번 달)
    long termCnt;   //단말기별 발권 한도 0 이면 무제한
    long termAmt;   //단말기별 금액 한도 0 이면 무제한
    int useDay;     //사용기한(발급일자로부터 n일)
    String useYN;   //사용유무
    String regDate; //등록일
    String modDate; //수정일
    long sendCnt;   //발송회수
    int usableCount; //쿠폰 당 사용 가능 횟수
    long fixAmount; //쿠폰 발권 시 고정 금액
    long usedCount; //사용한 횟수(이번 달)
    String merchantName;    //이용가능한 가맹점명
    char useGiftYn;   //1회권
    char useRuseYn;   //다회권
}
