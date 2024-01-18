package kr.co.ooweat.service;

import com.github.pagehelper.Page;
import java.util.HashMap;
import kr.co.ooweat.mappers.coupon_web.CouponMapper;
import kr.co.ooweat.mappers.coupon_web.GroupMapper;
import kr.co.ooweat.mappers.vanbt.VanbtMapper;
import kr.co.ooweat.common.Util;
import kr.co.ooweat.model.CouponConfVO;
import kr.co.ooweat.model.GroupVO;
import kr.co.ooweat.model.PageNavigation;
import kr.co.ooweat.model.UserVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import java.util.Map;


/**
 * The type Common service imp.
 */
@Slf4j
@Component
public class GroupService {
    
    @Autowired
    private GroupMapper groupMapper;
    @Autowired
    private CouponMapper couponMapper;
    @Autowired
    private VanbtMapper vanbtMapper;
    
    public void client(ModelAndView mav) {
        Map<String, Object> map = mav.getModelMap();
        HttpServletRequest request = (HttpServletRequest) map.get("request");
        Page<GroupVO> list = (Page<GroupVO>) groupMapper.getGroupClientList(
            (long) request.getAttribute("paramGroupSeq")
        );
        mav.addObject("pageInfo", new PageNavigation(list));
        mav.addObject("searchList", list);
        mav.addObject("searchCount", list.getTotal());
        mav.addObject("getGroupList", groupMapper.getGroupList());
        mav.setViewName("group/client.loading");
    }
    
    public void clientInfo(ModelAndView mav) {
        Map<String, Object> map = mav.getModelMap();
        HttpServletRequest request = (HttpServletRequest) map.get("request");
        mav.addObject("groupInfo",
            groupMapper.groupInfo(Long.parseLong(request.getParameter("paramGroupSeq"))));
        mav.addObject("clientInfo",
            groupMapper.clientInfo(Long.parseLong(request.getParameter("paramGroupSeq"))));
        mav.addObject("getVmmsCompanyList", vanbtMapper.getVmmsCompanyList());
        mav.addObject("paramGroupSeq", request.getParameter("paramGroupSeq"));
        //mav.addObject("paramGroupName", request.getParameter("paramGroupName"));
        mav.setViewName("group/clientInfo.tiles");
    }
    
    public void user(ModelAndView mav) {
        Map<String, Object> map = mav.getModelMap();
        HttpServletRequest request = (HttpServletRequest) map.get("request");
        
        Page<UserVO> list = (Page<UserVO>) groupMapper.userList(
            (long) request.getAttribute("paramGroupSeq"),
            request.getParameter("searchType") != null ?
                request.getParameter("searchType") : "0",
            request.getParameter("searchType") != null ?
                request.getParameter("searchValue") : ""
        );
    
        HashMap<String, String> hmap = new HashMap();
        hmap.put("paramGroupSeq", String.valueOf((long) request.getAttribute("paramGroupSeq")));
        hmap.put("searchType", request.getParameter("searchType") != null ?
            request.getParameter("searchType") : "0");
        hmap.put("searchValue", request.getParameter("searchType") != null ?
            request.getParameter("searchValue") : "");
    
        mav.addObject("pageInfo", new PageNavigation(list));
        mav.addObject("hmap", hmap);
        mav.addObject("searchList", list);
        mav.addObject("searchCount", list.getTotal());
        mav.addObject("getGroupList", groupMapper.getGroupList());
        mav.setViewName("group/user.loading");
    }
    
    public void userInfo(ModelAndView mav) {
        Map<String, Object> map = mav.getModelMap();
        HttpServletRequest request = (HttpServletRequest) map.get("request");
        mav.addObject("userInfo",
            groupMapper.userInfo(Long.parseLong(request.getParameter("paramUserSeq"))));
        mav.addObject("getGroupList", groupMapper.getGroupList());
        mav.setViewName("group/userInfo.tiles");
    }
    
    public void userRegist(ModelAndView mav) {
        mav.addObject("getGroupList", groupMapper.getGroupList());
        mav.setViewName("group/userRegist.tiles");
    }
    
    public void setting(ModelAndView mav) {
        Map<String, Object> map = mav.getModelMap();
        HttpServletRequest request = (HttpServletRequest) map.get("request");
        Page<CouponConfVO> list = (Page<CouponConfVO>) groupMapper.getGroupSettingList(
            (long) request.getAttribute("paramGroupSeq"),
            Util.dateUtils().firstDayOfMonth(), Util.dateUtils().yyyyMMdd(0));
    
        mav.addObject("pageInfo", new PageNavigation(list));
        mav.addObject("searchList", list);
        mav.addObject("searchCount", list.getTotal());
        mav.addObject("getGroupList", groupMapper.getGroupList());
        mav.setViewName("group/setting.loading");
    }
    
    public void settingInfo(ModelAndView mav) {
        CouponService couponService = new CouponService();
        mav.addObject("couponConfig",
            couponMapper.getCouponConfig(couponService.makeRequestForm(mav)));
        mav.setViewName("coupon/settingInfo.tiles");
    }
}
