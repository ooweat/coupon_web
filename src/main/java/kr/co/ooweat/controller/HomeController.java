package kr.co.ooweat.controller;

import kr.co.ooweat.service.CouponService;
import kr.co.ooweat.service.DashboardService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

@Slf4j
@RestController
public class HomeController {
    @Autowired
    DashboardService dashboardService;

    @Autowired
    CouponService couponService;

    @RequestMapping("/")
    public ModelAndView index(HttpSession session) {
        ModelAndView mav = new ModelAndView();
        if(session.getAttribute("userId") != null){
                mav.setViewName("/dashboard.loading");
               return mav;
        }else{
            session.invalidate();
            mav.setViewName("/login");
            return mav;
        }
    }

    @RequestMapping(value = "/login", method = RequestMethod.GET)
    public ModelAndView login(HttpSession session) {
        //로그인 창 호출 시, 기존에 session 정보를 가지고 있었다면 Invalid
        session.invalidate();
        return new ModelAndView("/login");
    }

    @RequestMapping(value = "/logout", method = RequestMethod.GET)
    public ModelAndView logout(HttpSession session) {
        session.invalidate();
        return new ModelAndView("/login");
    }

    @RequestMapping(value = "/dashboard", method = RequestMethod.GET)
    public ModelAndView dashboard(HttpServletRequest request, HttpSession session) {
        ModelAndView mav = new ModelAndView();
        mav.addObject("session", session);
        mav.addObject("request", request);
        dashboardService.dashboardInit(mav);
        return mav;
    }

    @RequestMapping(value = "/cp", method = RequestMethod.GET)
    public ModelAndView canvasCp(HttpServletRequest request, HttpSession session) {
        ModelAndView mav = new ModelAndView();
        mav.addObject("session", session);
        couponService.canvasInit(mav, (String) request.getParameter("cpn"));
        return mav;
    }

    //기존 멤버십 사이트에서 발권된 쿠폰에 대응하기 위함
    @RequestMapping(value = "/cp.do", method = RequestMethod.GET)
    public ModelAndView canvasCpOrign(HttpServletRequest request, HttpSession session) {
        ModelAndView mav = new ModelAndView();
        mav.addObject("session", session);
        couponService.canvasInit(mav, (String) request.getParameter("cpn"));
        return mav;
    }


}
