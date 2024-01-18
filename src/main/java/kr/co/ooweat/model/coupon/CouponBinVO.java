package kr.co.ooweat.model.coupon;

import lombok.Data;

@Data
public class CouponBinVO {
    Integer binSeq;
    Integer groupSeq;
    String couponBin;
    String couponKey;
    String useYN;
    String regDate;
    String modDate;
}
