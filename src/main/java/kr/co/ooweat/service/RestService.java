package kr.co.ooweat.service;

import kr.co.ooweat.mappers.coupon_web.CouponMapper;
import kr.co.ooweat.mappers.coupon_web.GroupMapper;
import kr.co.ooweat.mappers.coupon_web.UserMapper;
import kr.co.ooweat.mappers.vanbt.VanbtMapper;
import kr.co.ooweat.common.Util;
import kr.co.ooweat.model.BizVO;
import kr.co.ooweat.model.CouponConfVO;
import kr.co.ooweat.model.CouponVO;
import kr.co.ooweat.model.GroupVO;
import kr.co.ooweat.model.MemberGroupVO;
import kr.co.ooweat.model.UserVO;
import lombok.extern.slf4j.Slf4j;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import java.io.*;
import java.util.*;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;

import static kr.co.ooweat.common.ResponseCode.*;
import static kr.co.ooweat.common.Util.JsonUtils.convertMapToJson;


/**
 * The type Common service imp.
 */
@Slf4j
@Component
public class RestService {
    @Autowired
    private UserMapper userMapper;
    @Autowired
    private CouponMapper couponMapper;
    @Autowired
    private GroupMapper groupMapper;
    @Autowired
    private VanbtMapper vanbtMapper;
    
    @Value("${upload.path}")
    private String uploadPath;
    
    public ResponseEntity<JSONObject> loginConfirm(HttpServletRequest request, HttpSession session) {
        try {
            UserVO user = userMapper.loginConfirm(request.getParameter("userId"), request.getParameter("userPw"));
            log.info(user.toString());

            List<Map<String, Object>> userGroupRow = new ArrayList<>();
            Map<String, Object> userGroupInfo = new HashMap<>();
            session.setAttribute("userSeq", user.getUserSeq());
            session.setAttribute("groupSeq", user.getGroupSeq());
            session.setAttribute("groupName", user.getGroupName());
            session.setAttribute("userName", user.getUserName());
            session.setAttribute("userId", user.getUserId());
            session.setAttribute("userPw", user.getUserPw());
            session.setAttribute("role", user.getRole());
            session.setAttribute("useYN", user.getUseYN());
            session.setAttribute("useDashboard", user.getUseDashboard());
            session.setAttribute("useCouponPublish", user.getUseCouponPublish());
            session.setAttribute("useCouponConfig", user.getUseCouponConfig());
            session.setAttribute("useCouponIssuanceHistory", user.getUseCouponIssuanceHistory());
            session.setAttribute("useCouponSalesHistory", user.getUseCouponSalesHistory());
            session.setAttribute("companySeq", user.getCompanySeq());
            session.setAttribute("companyName", user.getCompanyName());
            session.setAttribute("token", Util.encryptAES256(String.valueOf(user.getCompanySeq())));
    
            userGroupInfo.put("groupSeq", user.getGroupSeq());
            userGroupInfo.put("groupName", user.getGroupName());
            userGroupRow.add(userGroupInfo);
            session.setAttribute("userGroupInfo", userGroupRow);
            return new ResponseEntity<>(Util.jsonUtils().responseParsing(
                    SUCCESS_REQUEST.getCode(), SUCCESS_REQUEST.getMessage(), SUCCESS_REQUEST.getDescription()), HttpStatus.OK);

        } catch (NullPointerException e) {
            //NOTE: NullPointException
            //값이 없으면 기존에 있던 값도 invalidate 처리 2023.01.17 twkim
            session.invalidate();
            return new ResponseEntity<>(Util.jsonUtils().responseParsing(
                    ERROR_REQUEST.getCode(), ERROR_REQUEST.getMessage(), ERROR_REQUEST.getDescription()), HttpStatus.OK);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public ResponseEntity<JSONObject> updateCouponStat(String couponNo, String couponStat) {
        try {
            Map<String, String> couponMap = new HashMap<>();
            couponMap.put("couponNo", couponNo);
            couponMap.put("couponStat", couponStat);
            int updateCouponStat = couponMapper.updateCouponStat(couponMap);
            return new ResponseEntity<>(Util.jsonUtils().responseParsing(
                    SUCCESS_REQUEST.getCode(), SUCCESS_REQUEST.getMessage(), SUCCESS_REQUEST.getDescription()), HttpStatus.OK);

        } catch (NullPointerException e) {
            return new ResponseEntity<>(Util.jsonUtils().responseParsing(
                    ERROR_REQUEST.getCode(), ERROR_REQUEST.getMessage(), ERROR_REQUEST.getDescription()), HttpStatus.OK);
        }
    }
    
    public ResponseEntity<JSONObject> couponIssuance(CouponVO couponVO, HttpSession session) {
        Map<String, Object> map = new HashMap<>();
        map.put("token", session.getAttribute("token"));
        map.put("companySeq", session.getAttribute("companySeq"));
        map.put("group", couponVO.getGroupSeq());
        map.put("id", userMapper.findUserId(couponVO.getUserSeq()));
        map.put("type", couponVO.getCouponType());
        map.put("amount", couponVO.getCouponAmt());
        map.put("phone", couponVO.getRevMobile());
        
        return Util.callCouponApi(convertMapToJson(map));
    }
    
    public ResponseEntity<JSONObject> couponReSend(CouponVO couponVO, HttpSession session) {
        Map<String, Object> map = new HashMap<>();
        map.put("token", session.getAttribute("token"));
        map.put("companySeq", session.getAttribute("companySeq"));
        map.put("group", couponVO.getGroupSeq());
        map.put("id", userMapper.findUserId(couponVO.getUserSeq()));
        map.put("type", couponVO.getCouponType());
        
        return Util.callCouponApi(convertMapToJson(map));
    }

    public ResponseEntity<JSONObject> updateCouponConfig(CouponConfVO couponConfVO) {
        try {
            log.info(couponConfVO.toString());
            int updateCouponConfig = couponMapper.updateCouponConfig(couponConfVO);
            return new ResponseEntity<>(Util.jsonUtils().responseParsing(
                    SUCCESS_REQUEST.getCode(), SUCCESS_REQUEST.getMessage(), SUCCESS_REQUEST.getDescription()), HttpStatus.OK);

        } catch (NullPointerException e) {
            return new ResponseEntity<>(Util.jsonUtils().responseParsing(
                    ERROR_REQUEST.getCode(), ERROR_REQUEST.getMessage(), ERROR_REQUEST.getDescription()), HttpStatus.OK);
        }
    }

    public ResponseEntity<JSONObject> insertGroup(String groupName) {
        try {
            int groupInsert = groupMapper.insertGroup(groupName);
            int couponBinInsert = 0;
            int couponConfInsert = 0;

            //쿠폰 BIN 추가
            if (groupInsert > 0) {
                couponBinInsert = groupMapper.insertCouponBin(groupName);
            }

            //쿠폰 Conf 추가
            if (couponBinInsert > 0) {
                couponConfInsert = groupMapper.insertCouponConfig(groupName);
            }

            if (couponConfInsert > 0) {
                return new ResponseEntity<>(Util.jsonUtils().responseParsing(
                        SUCCESS_REQUEST.getCode(), SUCCESS_REQUEST.getMessage(), SUCCESS_REQUEST.getDescription()), HttpStatus.OK);
            }
            return new ResponseEntity<>(Util.jsonUtils().responseParsing(
                    ERROR_REQUEST.getCode(), ERROR_REQUEST.getMessage(), ERROR_REQUEST.getDescription()), HttpStatus.OK);
        } catch (NullPointerException e) {
            return new ResponseEntity<>(Util.jsonUtils().responseParsing(
                    ERROR_REQUEST.getCode(), ERROR_REQUEST.getMessage(), ERROR_REQUEST.getDescription()), HttpStatus.OK);
        }
    }

    public ResponseEntity<JSONObject> updateGroup(GroupVO groupVO) {
        try {
            int groupUpdate = groupMapper.updateGroup(groupVO);
            if (groupUpdate > 0) {
                return new ResponseEntity<>(Util.jsonUtils().responseParsing(
                    SUCCESS_REQUEST.getCode(), SUCCESS_REQUEST.getMessage(), SUCCESS_REQUEST.getDescription()), HttpStatus.OK);
            }
            return new ResponseEntity<>(Util.jsonUtils().responseParsing(
                ERROR_REQUEST.getCode(), ERROR_REQUEST.getMessage(), ERROR_REQUEST.getDescription()), HttpStatus.OK);
        } catch (NullPointerException e) {
            return new ResponseEntity<>(Util.jsonUtils().responseParsing(
                ERROR_REQUEST.getCode(), ERROR_REQUEST.getMessage(), ERROR_REQUEST.getDescription()), HttpStatus.OK);
        }
    }

    public List<BizVO> getBusinessList(String companySeq) {
        log.info(vanbtMapper.getBusinessList(companySeq).toString());
        return vanbtMapper.getBusinessList(companySeq);
    }

    public ResponseEntity<JSONObject> updateGroupClient(MemberGroupVO memberGroupVO) {
        log.info("memberGroupVO::{}", memberGroupVO);
        List<String> companySeqList = Arrays.asList(memberGroupVO.getEtc1().split(","));
        List<String> companyNameList = Arrays.asList(memberGroupVO.getCompanyName().split(","));
        List<String> businessNoList = Arrays.asList(memberGroupVO.getBusinessNo().split(","));
        List<String> businessNameList = Arrays.asList(memberGroupVO.getBusinessName().split(","));
        List<Map<String, Object>> mgList = new ArrayList<>();
        try {
            // 가독성을 위한 구형 for 문
            for (int i = 0; i < memberGroupVO.getEtc1().split(",").length; i++) {
                Map<String, Object> mgMap = new HashMap<>();
                mgMap.put("groupSeq", memberGroupVO.getGroupSeq());
                mgMap.put("businessNo", businessNoList.get(i));
                mgMap.put("companySeq", companySeqList.get(i));
                mgMap.put("companyName", companyNameList.get(i));
                mgMap.put("businessName", businessNameList.get(i));
                mgMap.put("adminID", "ADMIN");
                mgList.add(mgMap);
            }

            //TODO: 소속이 동구전자이면, BIN UPDATE
            if(mgList.get(0).get("companySeq").equals("1639")){
                groupMapper.updateCouponBinDonggu(memberGroupVO.getGroupSeq());
                log.info("동구전자 Coupon Bin 으로 Update 진행");
            }

            //기존 데이터가 있으면? 삭제 후에 진행
            if (groupMapper.checkClient(memberGroupVO.getGroupSeq()) > 0) {
                if (groupMapper.deleteClient(memberGroupVO.getGroupSeq()) > 0) {
                    groupMapper.insertClient(mgList);
                }

            } else {
                groupMapper.insertClient(mgList);
            }

            return new ResponseEntity<>(Util.jsonUtils().responseParsing(
                    SUCCESS_REQUEST.getCode(), SUCCESS_REQUEST.getMessage(), SUCCESS_REQUEST.getDescription()), HttpStatus.OK);
        } catch (NullPointerException e) {
            return new ResponseEntity<>(Util.jsonUtils().responseParsing(
                    ERROR_REQUEST.getCode(), ERROR_REQUEST.getMessage(), ERROR_REQUEST.getDescription()), HttpStatus.OK);
        }
    }

    public ResponseEntity<JSONObject> updateUser(UserVO userVO) {
        try {
            userVO.setUserPw(Util.empty(userVO.getUserPw()) ? "'"+userVO.getUserOriginPw()+"'" :
                "MD5('"+userVO.getUserPw()+"')");
            groupMapper.updateUser(userVO);
            return new ResponseEntity<>(Util.jsonUtils().responseParsing(
                    SUCCESS_REQUEST.getCode(), SUCCESS_REQUEST.getMessage(), SUCCESS_REQUEST.getDescription()), HttpStatus.OK);

        } catch (NullPointerException e) {
            return new ResponseEntity<>(Util.jsonUtils().responseParsing(
                    ERROR_REQUEST.getCode(), ERROR_REQUEST.getMessage(), ERROR_REQUEST.getDescription()), HttpStatus.OK);
        }
    }

    public ResponseEntity<JSONObject> insertUser(UserVO userVO) {
        try {
            groupMapper.insertUser(userVO);
            return new ResponseEntity<>(Util.jsonUtils().responseParsing(
                    SUCCESS_REQUEST.getCode(), SUCCESS_REQUEST.getMessage(), SUCCESS_REQUEST.getDescription()), HttpStatus.OK);

        } catch (NullPointerException e) {
            return new ResponseEntity<>(Util.jsonUtils().responseParsing(
                    ERROR_REQUEST.getCode(), ERROR_REQUEST.getMessage(), ERROR_REQUEST.getDescription()), HttpStatus.OK);
        }
    }

    public ResponseEntity<JSONObject> alreadyClientCheck(MemberGroupVO memberGroupVO) {
        try {
            List<MemberGroupVO> list = groupMapper.alreadyClientCheck(memberGroupVO);
            if (list.size() > 0) {
                return new ResponseEntity<>(Util.jsonUtils().responseParsing(
                        ALREADY_DATA.getCode(), ALREADY_DATA.getMessage(), "기등록된 그룹: "+list.get(0).getGroupName()), HttpStatus.OK);
            } else {
                return new ResponseEntity<>(Util.jsonUtils().responseParsing(
                        SUCCESS_REQUEST.getCode(), SUCCESS_REQUEST.getMessage(), SUCCESS_REQUEST.getDescription()), HttpStatus.OK);
            }

        } catch (NullPointerException e) {
            return new ResponseEntity<>(Util.jsonUtils().responseParsing(
                    ERROR_REQUEST.getCode(), ERROR_REQUEST.getMessage(), ERROR_REQUEST.getDescription()), HttpStatus.OK);
        }
    }

    public static void main(String[] args) {

    }

    public ResponseEntity<JSONObject> alreadyUserCheck(String userId) {
        try {
            return userMapper.alreadyUserCheck(userId) > 0 ? new ResponseEntity<>(Util.jsonUtils().responseParsing(
                ALREADY_DATA.getCode(), ALREADY_DATA.getMessage(), "기등록된 사용자: " + userId),
                HttpStatus.OK)
                :
                    new ResponseEntity<>(Util.jsonUtils().responseParsing(
                        SUCCESS_REQUEST.getCode(), SUCCESS_REQUEST.getMessage(),
                        SUCCESS_REQUEST.getDescription()), HttpStatus.OK);
        } catch (NullPointerException e) {
            return new ResponseEntity<>(Util.jsonUtils().responseParsing(
                ERROR_REQUEST.getCode(), ERROR_REQUEST.getMessage(),
                ERROR_REQUEST.getDescription()), HttpStatus.OK);
        }
    }

    public List<UserVO> callGroupUserList(String groupSeq) {
        return userMapper.callGroupUserList(Long.parseLong(groupSeq));
    }
    
    public int couponExcelIssuance(CouponVO couponVO, HttpSession session, MultipartFile file) {
        String fileName = StringUtils.cleanPath(file.getOriginalFilename());
        log.info(fileName);
        int reCode = 0;
        Workbook workbook = null;
        try {
            if(file.getOriginalFilename().endsWith("xlsx")){
                workbook = new XSSFWorkbook(file.getInputStream());
            }else if (file.getOriginalFilename().endsWith("xls")) {
                workbook = new HSSFWorkbook(file.getInputStream());
            }else{
                //throw new IllegalArgumentException("파일 형식 다름");
                return 0;
            }
    
            Map<String, Object> map = new HashMap<>();
            map.put("group", couponVO.getGroupSeq());
            map.put("id", userMapper.findUserId(couponVO.getUserSeq()));
            map.put("type", couponVO.getCouponType());
            map.put("token", session.getAttribute("token"));
            map.put("companySeq", session.getAttribute("companySeq"));
            
            Sheet worksheet = workbook.getSheetAt(0);
            for (int i = 3; i <= worksheet.getPhysicalNumberOfRows(); i++) {
                Row row = worksheet.getRow(i);
                if(row != null){
                    if(row.getCell(0) == null || row.getCell(0).toString() == ""){
                        break;
                    }
    
                    map.put("phone", String.valueOf(row.getCell(0)));
                    map.put("amount", Integer.parseInt(String.valueOf(row.getCell(1))));
                    
                    if(row.getCell(2) != null) {
                        map.put("type", String.valueOf(row.getCell(2)).equals("1회권") ? "GIFT" : "RUSE");
                    }
                    
                    ResponseEntity<JSONObject> response = Util.callCouponApi(convertMapToJson(map));
                    if(response.getBody().get("code").toString().equals("0000")){
                        reCode++;
                    }
                }
            }
        } catch (NullPointerException e) {
            return 0;
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
        return reCode;
    }
    
    public CouponConfVO callGroupCouponConfig(String groupSeq) {
        CouponConfVO couponConfVO = new CouponConfVO();
        Map<String, Object> map = new HashMap<>();
        map.put("paramGroupSeq", groupSeq);
        map.put("firstDayOfMonth", Util.dateUtils().firstDayOfMonth());
        map.put("today", Util.dateUtils().yyyyMMdd(0));
        couponConfVO = couponMapper.getCouponConfig(map);
        return couponConfVO;
    }
    
    public ResponseEntity<JSONObject> couponResend(CouponVO couponVO, HttpSession session) {
        Map<String, Object> map = new HashMap<>();
        map.put("token", session.getAttribute("token"));
        map.put("companySeq", session.getAttribute("companySeq"));
        couponVO = couponMapper.getCouponInfo(couponVO.getCouponNo());
        
        map.put("group", couponVO.getGroupSeq());
        map.put("id", couponVO.getUserId());
        map.put("type", couponVO.getCouponType());
        map.put("amount", couponVO.getCouponAmt());
        map.put("phone", couponVO.getRevMobile());
        map.put("couponNo", couponVO.getCouponNo());
    
        return Util.callCouponApi(convertMapToJson(map));
    }
}
