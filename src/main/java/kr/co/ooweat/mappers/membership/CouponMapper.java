package kr.co.ooweat.mappers.coupon_web;

import kr.co.ooweat.model.CouponSalesVO;
import kr.co.ooweat.model.CouponVO;
import kr.co.ooweat.model.SummaryVO;
import kr.co.ooweat.model.CouponConfVO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Map;

@Mapper
public interface CouponMapper {
    List<CouponVO> recentCouponTop7(Map<String, Object> map);
    List<SummaryVO> usageCoupon(Map<String, Object> map);
    int updateCouponStat(Map<String, String> couponMap);
    CouponVO getCouponCanvasInfo(String cpn);
    CouponConfVO getCouponConfig(Map<String, Object> map);

    int updateCouponConfig(CouponConfVO couponConfVO);

    List<CouponVO> getCouponIssuanceList(Map<String, Object> map);
    List<CouponSalesVO> getCouponSalesList(Map<String, Object> map);
    List<CouponSalesVO> getCouponUseList(String cpn);
    
    void updateCouponExpire(String expireDate);
    
    CouponVO getCouponInfo(String couponNo);
}
