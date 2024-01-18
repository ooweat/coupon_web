package kr.co.ooweat.service;

import kr.co.ooweat.mappers.coupon_web.CouponMapper;
import kr.co.ooweat.mappers.coupon_web.DashboardMapper;
import kr.co.ooweat.common.Util;
import kr.co.ooweat.mappers.coupon_web.GroupMapper;
import kr.co.ooweat.model.CouponVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import java.util.List;
import java.util.Map;
/**
 * The type Common service imp.
 */
@Slf4j
@Component
public class DashboardService {
    @Autowired
    private DashboardMapper dashboardMapper;
    @Autowired
    private CouponMapper couponMapper;

    @Autowired
    private GroupMapper groupMapper;

    public void dashboardInit(ModelAndView mav) {
        Map<String, Object> map = mav.getModelMap();
        HttpServletRequest request = (HttpServletRequest) map.get("request");
        HttpSession session = (HttpSession) map.get("session");
    
        mav.addObject("getGroupList",
            session.getAttribute("role").equals("system") ?
                groupMapper.getGroupList()
                : session.getAttribute("userGroupInfo"));
        map.put("groupSeq", (Long) session.getAttribute("groupSeq"));
        map.put("paramGroupSeq",
            request.getParameter("paramGroupSeq") == null ? (Long) session.getAttribute("groupSeq")
                : request.getParameter("paramGroupSeq"));
        map.put("role", session.getAttribute("role"));
        String month = request.getParameter("month") == null ?
                Util.dateUtils().MM() : request.getParameter("month");
        map.put("firstDayOfMonth", Util.dateUtils().firstDayOfMonth());
        map.put("today", Util.dateUtils().yyyyMMdd(0));
        map.put("thisMonth", Util.dateUtils().MM());
        map.put("yyyyMM", (
                request.getParameter("month") == null ?
                        Util.dateUtils().yyyyMM() : Util.dateUtils().yyyy() + month)
        );
        
        log.info("map: {}", map.toString());
        
        List<CouponVO> recentCouponTop7List = couponMapper.recentCouponTop7(map);
        //NOTE: coupon를 List에 담을 때, 암호화 여부에 따라 값을 복호화한다.
        for(CouponVO couponVO : recentCouponTop7List){
            if(couponVO.getRevMobile().length()>13){
                couponVO.setRevMobile(Util.AES256Security2("dec", couponVO.getRevMobile()).substring(0, 13));
            }
        }

        mav.addObject("recentCouponTop7", recentCouponTop7List);
        mav.addObject("usageCoupon", couponMapper.usageCoupon(map));
        mav.addObject("couponConfig", couponMapper.getCouponConfig(map));
        mav.addObject("month", month);
        mav.setViewName("dashboard.loading");
    }

}
