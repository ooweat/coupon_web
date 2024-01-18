package kr.co.ooweat.controller;

import kr.co.ooweat.model.BizVO;
import kr.co.ooweat.model.CouponConfVO;
import kr.co.ooweat.model.CouponVO;
import kr.co.ooweat.model.GroupVO;
import kr.co.ooweat.model.MemberGroupVO;
import kr.co.ooweat.model.UserVO;
import kr.co.ooweat.service.RestService;
import lombok.extern.slf4j.Slf4j;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.List;
import org.springframework.web.multipart.MultipartFile;


/**
 * The type Common controller.
 */
@Slf4j
@CrossOrigin(origins = "*", allowedHeaders = "*")
@org.springframework.web.bind.annotation.RestController
@EnableAutoConfiguration
@RequestMapping(value = "/ajax")
public class RestController {

    //private static final String ACCESS_CONTROL_ALLOW_CREDENTIALS = "Access-Control-Allow-Credentials";

    @Autowired
    private RestService restService;

    @PostMapping(value = "loginConfirm", consumes = MediaType.APPLICATION_FORM_URLENCODED_VALUE)
    public ResponseEntity<JSONObject> loginConfirm(HttpServletRequest request, HttpSession session) {
        return restService.loginConfirm(request, session);
    }

    @PostMapping(value = "updateCouponStat", consumes = MediaType.APPLICATION_FORM_URLENCODED_VALUE)
    public ResponseEntity<JSONObject> updateCouponStat(HttpServletRequest request) {
        return restService.updateCouponStat(request.getParameter("couponNo"), request.getParameter("couponStat"));
    }
    
    @PostMapping(value = "couponIssuance", consumes = MediaType.APPLICATION_FORM_URLENCODED_VALUE)
    public ResponseEntity<JSONObject> couponIssuance(CouponVO couponVO, HttpSession session) {
        return restService.couponIssuance(couponVO, session);
    }
    @PostMapping(value = "couponResend", consumes = MediaType.APPLICATION_FORM_URLENCODED_VALUE)
    public ResponseEntity<JSONObject> couponResend(CouponVO couponVO, HttpSession session) {
        return restService.couponResend(couponVO, session);
    }
    
    @PostMapping(value = "couponExcelIssuance")
    public int couponExcelIssuance(CouponVO couponVO, HttpSession session, @RequestParam("couponIssuanceByExcel") MultipartFile file) {
        return restService.couponExcelIssuance(couponVO, session, file);
    }

    @PostMapping(value = "updateCouponConfig", consumes = MediaType.APPLICATION_FORM_URLENCODED_VALUE)
    public ResponseEntity<JSONObject> updateCouponConfig(CouponConfVO couponConfVO) {
        return restService.updateCouponConfig(couponConfVO);
    }

    @PostMapping(value = "insertGroup", consumes = MediaType.APPLICATION_FORM_URLENCODED_VALUE)
    public ResponseEntity<JSONObject> insertGroup(HttpServletRequest request) {
        return restService.insertGroup((String) request.getParameter("groupName"));
    }

    @PostMapping(value = "updateGroup", consumes = MediaType.APPLICATION_FORM_URLENCODED_VALUE)
    public ResponseEntity<JSONObject> updateGroup(GroupVO groupVO) {
        return restService.updateGroup(groupVO);
    }

    @PostMapping(value = "updateGroupClient", consumes = MediaType.APPLICATION_FORM_URLENCODED_VALUE)
    public ResponseEntity<JSONObject> updateGroupClient(MemberGroupVO memberGroupVO) {
        return restService.updateGroupClient(memberGroupVO);
    }

    @PostMapping(value = "alreadyClientCheck", consumes = MediaType.APPLICATION_FORM_URLENCODED_VALUE)
    public ResponseEntity<JSONObject> alreadyClientCheck(MemberGroupVO memberGroupVO) {
        return restService.alreadyClientCheck(memberGroupVO);
    }

    @PostMapping(value = "getBusinessList")
    public List<BizVO> businessList(HttpServletRequest request) {
        return restService.getBusinessList((String) request.getParameter("companySeq"));
    }

    @PostMapping(value = "insertUser", consumes = MediaType.APPLICATION_FORM_URLENCODED_VALUE)
    public ResponseEntity<JSONObject> insertUser(UserVO userVO) {
        return restService.insertUser(userVO);
    }

    @PostMapping(value = "updateUser", consumes = MediaType.APPLICATION_FORM_URLENCODED_VALUE)
    public ResponseEntity<JSONObject> updateUser(UserVO userVO) {
        return restService.updateUser(userVO);
    }

    @PostMapping(value = "alreadyUserCheck", consumes = MediaType.APPLICATION_FORM_URLENCODED_VALUE)
    public ResponseEntity<JSONObject> alreadyUserCheck(String userId) {
        return restService.alreadyUserCheck(userId);
    }

    @PostMapping(value = "callGroupUserList", consumes = MediaType.APPLICATION_FORM_URLENCODED_VALUE)
    public List<UserVO> callGroupUserList(HttpServletRequest request) {
        return restService.callGroupUserList(request.getParameter("groupSeq"));
    }
    
    @PostMapping(value = "callGroupCouponConfig", consumes = MediaType.APPLICATION_FORM_URLENCODED_VALUE)
    public CouponConfVO callGroupCouponConfig(HttpServletRequest request) {
        return restService.callGroupCouponConfig(request.getParameter("paramGroupSeq"));
    }
}
