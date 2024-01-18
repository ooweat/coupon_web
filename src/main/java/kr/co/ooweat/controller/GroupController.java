package kr.co.ooweat.controller;

import kr.co.ooweat.service.GroupService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

@Slf4j
@RestController
@RequestMapping(value = "/group/")
public class GroupController {
    @Autowired
    GroupService groupService;

    @RequestMapping("client")
    public ModelAndView client(HttpServletRequest request, HttpSession session) {
        ModelAndView mav = new ModelAndView();
        mav.addObject("session", session);
        mav.addObject("request", request);
        groupService.client(mav);
        return mav;
    }

    @RequestMapping("clientInfo")
    public ModelAndView clientInfo(HttpServletRequest request, HttpSession session) {
        ModelAndView mav = new ModelAndView();
        mav.addObject("session", session);
        mav.addObject("request", request);
        groupService.clientInfo(mav);
        return mav;
    }
    
    @RequestMapping("setting")
    public ModelAndView setting(HttpServletRequest request, HttpSession session) {
        ModelAndView mav = new ModelAndView();
        mav.addObject("session", session);
        mav.addObject("request", request);
        groupService.setting(mav);
        return mav;
    }
    
    @RequestMapping("settingInfo")
    public ModelAndView settingInfo(HttpServletRequest request, HttpSession session) {
        ModelAndView mav = new ModelAndView();
        mav.addObject("session", session);
        mav.addObject("request", request);
        groupService.settingInfo(mav);
        return mav;
    }
    
    @RequestMapping("user")
    public ModelAndView user(HttpServletRequest request, HttpSession session) {
        ModelAndView mav = new ModelAndView();
        mav.addObject("session", session);
        mav.addObject("request", request);
        groupService.user(mav);
        return mav;
    }

    @RequestMapping("userInfo")
    public ModelAndView userInfo(HttpServletRequest request, HttpSession session) {
        ModelAndView mav = new ModelAndView();
        mav.addObject("session", session);
        mav.addObject("request", request);
        groupService.userInfo(mav);
        return mav;
    }

    @RequestMapping("userRegist")
    public ModelAndView userRegist(HttpServletRequest request, HttpSession session) {
        ModelAndView mav = new ModelAndView();
        mav.addObject("session", session);
        mav.addObject("request", request);
        groupService.userRegist(mav);
        return mav;
    }
}
