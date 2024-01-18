package kr.co.ooweat.model.coupon;

import lombok.Data;

@Data
public class CouponIssueVO {
    String userid;
    String amount;
    String cpntype;
    String balkey;
    String tel;
}
