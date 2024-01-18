package kr.co.ooweat.service;

import com.github.pagehelper.Page;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import kr.co.ooweat.mappers.coupon_web.CouponMapper;
import kr.co.ooweat.common.Util;
import kr.co.ooweat.mappers.coupon_web.GroupMapper;
import kr.co.ooweat.model.CouponSalesVO;
import kr.co.ooweat.model.CouponVO;
import kr.co.ooweat.model.PageNavigation;
import lombok.extern.slf4j.Slf4j;
import org.apache.poi.hssf.usermodel.DVConstraint;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFDataFormat;
import org.apache.poi.hssf.usermodel.HSSFDataValidation;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.CellRangeAddress;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.util.CellRangeAddressList;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.ModelAndView;


/**
 * The type Common service imp.
 */
@Slf4j
@Component
public class CouponService {
    
    @Autowired
    private CouponMapper couponMapper;
    
    @Autowired
    private GroupMapper groupMapper;
    
    public void canvasInit(ModelAndView mav, String cpn) {
        mav.addObject("couponInfo", couponMapper.getCouponCanvasInfo(cpn));
        mav.addObject("couponUseList", couponMapper.getCouponUseList(cpn));
        mav.setViewName("cp.empty");
    }
    
    public void issuance(ModelAndView mav) {
        Map<String, Object> map = mav.getModelMap();
        HttpSession session = (HttpSession) map.get("session");
        Page<CouponVO> list = (Page<CouponVO>) couponMapper.getCouponIssuanceList(
            makeRequestForm(mav));
        //NOTE: coupon를 List에 담을 때, 암호화 여부에 따라 값을 복호화한다.
        for (CouponVO couponVO : list) {
            if (couponVO.getRevMobile().length() > 13) {
                couponVO.setRevMobile(
                    Util.AES256Security2("dec", couponVO.getRevMobile()).substring(0, 13));
            }
        }
        
        mav.addObject("pageInfo", new PageNavigation(list));
        mav.addObject("searchList", list);
        mav.addObject("getGroupList",
            session.getAttribute("role").equals("system") ?
                groupMapper.getGroupList()
                : session.getAttribute("userGroupInfo"));
        mav.addObject("searchCount", list.getTotal());
        mav.setViewName("coupon/issuance.loading");
    }
    
    public void sales(ModelAndView mav) {
        Map<String, Object> map = mav.getModelMap();
        HttpSession session = (HttpSession) map.get("session");
        Page<CouponSalesVO> list = (Page<CouponSalesVO>) couponMapper.getCouponSalesList(
            makeRequestForm(mav));
    
        mav.addObject("pageInfo", new PageNavigation(list));
        mav.addObject("searchList", list);
        mav.addObject("getGroupList",
            session.getAttribute("role").equals("system") ?
                groupMapper.getGroupList()
                : session.getAttribute("userGroupInfo"));
        mav.addObject("searchCount", list.getTotal());
        mav.setViewName("coupon/sales.loading");
    }
    
    public Map<String, Object> makeRequestForm(ModelAndView mav) {
        Map<String, Object> map = mav.getModelMap();
        HttpSession session = (HttpSession) map.get("session");
        HttpServletRequest request = (HttpServletRequest) map.get("request");
        
        map.put("sDate", request.getParameter("sDate") == null ? Util.dateUtils().yyyyMMdd()
            : request.getParameter("sDate"));
        map.put("eDate", request.getParameter("eDate") == null ? Util.dateUtils().yyyyMMdd()
            : request.getParameter("eDate"));
        map.put("firstDayOfMonth", Util.dateUtils().firstDayOfMonth());
        map.put("today", Util.dateUtils().yyyyMMdd(0));
        map.put("searchType",
            request.getParameter("searchType") == "" ? null : request.getParameter("searchType"));
        map.put("searchValue",
            request.getParameter("searchValue") == "" ? null : request.getParameter("searchValue"));
        map.put("searchOption", request.getParameter("searchOption") == "" ? null
            : request.getParameter("searchOption"));
        map.put("searchOptionValue", request.getParameter("searchOptionValue") == "" ? null
            : request.getParameter("searchOptionValue"));
        map.put("groupSeq", (Long) session.getAttribute("groupSeq"));
        map.put("paramGroupSeq",
            request.getParameter("paramGroupSeq") == null ? (Long) session.getAttribute("groupSeq")
                : request.getParameter("paramGroupSeq"));
        map.put("role", (String) session.getAttribute("role"));
        mav.addObject("hmap", map);
        return map;
    }
    
    public void couponExpire(String expireDate) {
        couponMapper.updateCouponExpire(expireDate);
    }
    
    public HSSFWorkbook getCouponIssaunceListExcel(ModelAndView mav) {
        Map<String, Object> map = mav.getModelMap();
        HttpServletRequest request = (HttpServletRequest) map.get("request");
        HttpSession session = (HttpSession) map.get("session");
        HSSFWorkbook workbook = new HSSFWorkbook();
        ;
        HSSFRow bodyRow = null;
        HSSFCell bodyCell = null;
        int colno = 0;
        
        HSSFFont font = (HSSFFont) workbook.createFont();
        font.setBoldweight(Font.BOLDWEIGHT_BOLD);
        HSSFDataFormat format = workbook.createDataFormat();
        // 테이블 헤더용 스타일
        HSSFCellStyle headStyle = workbook.createCellStyle();
        
        // 가는 경계선을 가집니다.
        headStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
        headStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
        headStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
        headStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
        
        // 배경색은 노란색입니다.
        headStyle.setFillForegroundColor(IndexedColors.LIGHT_YELLOW.getIndex());
        headStyle.setFillPattern(CellStyle.SOLID_FOREGROUND);
        
        // 데이터는 가운데 정렬합니다.
        headStyle.setAlignment(CellStyle.ALIGN_CENTER);
        headStyle.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        headStyle.setFont(font);
        
        // 테이블 헤더용 값 스타일
        HSSFCellStyle valueheadStyle = workbook.createCellStyle();
        valueheadStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
        valueheadStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
        valueheadStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
        valueheadStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
        valueheadStyle.setFillForegroundColor(IndexedColors.WHITE.getIndex());
        valueheadStyle.setFillPattern(CellStyle.SOLID_FOREGROUND);
        // 데이터는 가운데 정렬합니다.
        valueheadStyle.setAlignment(CellStyle.ALIGN_LEFT);
        valueheadStyle.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        valueheadStyle.setFont(font);
        
        HSSFCellStyle mumheadStyle = workbook.createCellStyle();
        
        // 가는 경계선을 가집니다.
        mumheadStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
        mumheadStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
        mumheadStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
        mumheadStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
        
        // 배경색은 노란색입니다.
        mumheadStyle.setFillForegroundColor(IndexedColors.LIGHT_YELLOW.getIndex());
        mumheadStyle.setFillPattern(CellStyle.SOLID_FOREGROUND);
        
        // 데이터는 가운데 정렬합니다.
        mumheadStyle.setAlignment(CellStyle.ALIGN_RIGHT);
        mumheadStyle.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        mumheadStyle.setFont(font);
        mumheadStyle.setDataFormat(format.getFormat("#,##0"));
        
        // 데이터용 경계 스타일 테두리만 지정
        HSSFCellStyle bodyStyle = workbook.createCellStyle();
        bodyStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
        bodyStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
        bodyStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
        bodyStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
        bodyStyle.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        bodyStyle.setDataFormat(format.getFormat("text"));
        
        HSSFCellStyle numBodyStyle = workbook.createCellStyle();
        numBodyStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
        numBodyStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
        numBodyStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
        numBodyStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
        numBodyStyle.setAlignment(HSSFCellStyle.ALIGN_RIGHT);
        numBodyStyle.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        numBodyStyle.setDataFormat(format.getFormat("#,##0"));
        
        // 시트생성
        HSSFSheet sheet = workbook.createSheet("쿠폰발권내역");
        int rowNo = 0;
        
        HSSFRow headerRow = sheet.createRow(rowNo++);
        headerRow.setHeight((short) 512);
        String[] pageheaderKey = {"조회기간",
            request.getParameter("sDate") + " ~ " + request.getParameter("eDate")};
        
        HSSFCell headerCell = null;
        for (int i = 0; i < pageheaderKey.length; i++) {
            headerCell = headerRow.createCell(i);
            if (i == 0) {
                headerCell.setCellStyle(headStyle);
            } else {
                headerCell.setCellStyle(valueheadStyle);
            }
            
            headerCell.setCellValue(pageheaderKey[i]);
        }
        sheet.addMergedRegion(
            new CellRangeAddress(rowNo - 1, rowNo - 1, 1, pageheaderKey.length - 1));
        headerRow = sheet.createRow(rowNo++);
        headerRow.setHeight((short) 212);
        headerRow = sheet.createRow(rowNo++);
        headerRow.setHeight((short) 212);
        
        ArrayList<String> tableHeader = new ArrayList<>();
        
        tableHeader.add("발권일자");
        tableHeader.add("발권시간");
        if (session.getAttribute("role").equals("system")) {
            tableHeader.add("그룹명");
        }
        tableHeader.add("연락처");
        tableHeader.add("발권금액");
        tableHeader.add("쿠폰타입");
        tableHeader.add("쿠폰번호");
        tableHeader.add("사용가능기간");
        tableHeader.add("쿠폰상태");
        tableHeader.add("발송횟수");
        
        headerRow.setHeight((short) 512);
        
        for (int i = 0; i < tableHeader.size(); i++) {
            sheet.autoSizeColumn(i);
            sheet.setColumnWidth(i, (sheet.getColumnWidth(i)) + 3024);
            headerCell = headerRow.createCell(i);
            headerCell.setCellStyle(headStyle);
            headerCell.setCellValue(tableHeader.get(i));
        }
        List<CouponVO> list = couponMapper.getCouponIssuanceList(makeRequestForm(mav));
        for (CouponVO couponVO : list) {
            bodyRow = sheet.createRow(rowNo++);
            colno = 0;
            
            bodyCell = bodyRow.createCell(colno++);
            bodyCell.setCellStyle(bodyStyle);
            bodyCell.setCellValue(couponVO.getRegDate());
            
            bodyCell = bodyRow.createCell(colno++);
            bodyCell.setCellStyle(bodyStyle);
            bodyCell.setCellValue(couponVO.getRegTime());
            
            if (session.getAttribute("role").equals("system")) {
                bodyCell = bodyRow.createCell(colno++);
                bodyCell.setCellStyle(bodyStyle);
                bodyCell.setCellValue(couponVO.getGroupName());
            }
            bodyCell = bodyRow.createCell(colno++);
            bodyCell.setCellStyle(bodyStyle);
            bodyCell.setCellValue(couponVO.getRevMobile());
            
            bodyCell = bodyRow.createCell(colno++);
            bodyCell.setCellStyle(bodyStyle);
            bodyCell.setCellValue(
                Util.stringUtils(String.valueOf(couponVO.getCouponAmt())).convertMoneyFormat()
                    + "원");
            
            bodyCell = bodyRow.createCell(colno++);
            bodyCell.setCellStyle(bodyStyle);
            bodyCell.setCellValue(couponVO.getCouponType());
            
            bodyCell = bodyRow.createCell(colno++);
            bodyCell.setCellStyle(bodyStyle);
            bodyCell.setCellValue(couponVO.getCouponNo());
            
            bodyCell = bodyRow.createCell(colno++);
            bodyCell.setCellStyle(bodyStyle);
            bodyCell.setCellValue(couponVO.getRegDate() + "~" + couponVO.getExpireDay());
            
            bodyCell = bodyRow.createCell(colno++);
            bodyCell.setCellStyle(bodyStyle);
            bodyCell.setCellValue(convertCouponStat(couponVO.getCouponStat()));
            
            bodyCell = bodyRow.createCell(colno++);
            bodyCell.setCellStyle(bodyStyle);
            bodyCell.setCellValue(couponVO.getSendCnt() + "번");
        }
        return workbook;
    }
    
    public HSSFWorkbook getCouponSampleExcel(ModelAndView mav) {
        Map<String, Object> map = mav.getModelMap();
        HttpServletRequest request = (HttpServletRequest) map.get("request");
        HttpSession session = (HttpSession) map.get("session");
        HSSFWorkbook workbook = new HSSFWorkbook();
        HSSFRow bodyRow = null;
        HSSFCell bodyCell = null;
        int colno = 0;
        
        HSSFFont font = (HSSFFont) workbook.createFont();
        font.setBoldweight(Font.BOLDWEIGHT_BOLD);
        HSSFDataFormat format = workbook.createDataFormat();
        // 테이블 헤더용 스타일
        HSSFCellStyle headStyle = workbook.createCellStyle();
    
        // 가는 경계선을 가집니다.
        headStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
        headStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
        headStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
        headStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
    
        // 배경색은 노란색입니다.
        headStyle.setFillForegroundColor(IndexedColors.ROSE.getIndex());
        headStyle.setFillPattern(CellStyle.SOLID_FOREGROUND);
    
        // 데이터는 가운데 정렬합니다.
        headStyle.setAlignment(CellStyle.ALIGN_LEFT);
        headStyle.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        headStyle.setFont(font);
        //자동 줄 바꿈
        headStyle.setWrapText(true);
        
        // 테이블 헤더용 스타일
        HSSFCellStyle titleStyle = workbook.createCellStyle();
    
        // 가는 경계선을 가집니다.
        titleStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
        titleStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
        titleStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
        titleStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
    
        // 배경색은 노란색입니다.
        titleStyle.setFillForegroundColor(IndexedColors.LIGHT_YELLOW.getIndex());
        titleStyle.setFillPattern(CellStyle.SOLID_FOREGROUND);
    
        // 데이터는 가운데 정렬합니다.
        titleStyle.setAlignment(CellStyle.ALIGN_CENTER);
        titleStyle.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        titleStyle.setFont(font);
    
    
        // 테이블 헤더용 값 스타일
        HSSFCellStyle valueHeadStyle = workbook.createCellStyle();
        valueHeadStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
        valueHeadStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
        valueHeadStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
        valueHeadStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
        valueHeadStyle.setFillForegroundColor(IndexedColors.WHITE.getIndex());
        valueHeadStyle.setFillPattern(CellStyle.SOLID_FOREGROUND);
        // 데이터는 가운데 정렬합니다.
        valueHeadStyle.setAlignment(CellStyle.ALIGN_LEFT);
        valueHeadStyle.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        valueHeadStyle.setFont(font);
    
        //자동 줄 바꿈
        valueHeadStyle.setWrapText(true);
        
        HSSFCellStyle mumheadStyle = workbook.createCellStyle();
        
        // 가는 경계선을 가집니다.
        mumheadStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
        mumheadStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
        mumheadStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
        mumheadStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
        
        // 배경색은 노란색입니다.
        mumheadStyle.setFillForegroundColor(IndexedColors.LIGHT_YELLOW.getIndex());
        mumheadStyle.setFillPattern(CellStyle.SOLID_FOREGROUND);
        
        // 데이터는 가운데 정렬합니다.
        mumheadStyle.setAlignment(CellStyle.ALIGN_RIGHT);
        mumheadStyle.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        mumheadStyle.setFont(font);
        mumheadStyle.setDataFormat(format.getFormat("#,##0"));
        
        // 데이터용 경계 스타일 테두리만 지정
        HSSFCellStyle bodyStyle = workbook.createCellStyle();
        bodyStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
        bodyStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
        bodyStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
        bodyStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
        bodyStyle.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        bodyStyle.setDataFormat(format.getFormat("text"));
        
        HSSFCellStyle numBodyStyle = workbook.createCellStyle();
        numBodyStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
        numBodyStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
        numBodyStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
        numBodyStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
        numBodyStyle.setAlignment(HSSFCellStyle.ALIGN_RIGHT);
        numBodyStyle.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        numBodyStyle.setDataFormat(format.getFormat("#,##0"));
        
        // 시트생성
        HSSFSheet sheet = workbook.createSheet("쿠폰일괄등록");
        int rowNo = 0;
        
        HSSFRow headerRow = sheet.createRow(rowNo++);
        //headerRow.setHeight((short) 512);
        
        HSSFCell headerCell = null;
        headerCell = headerRow.createCell(0);
        headerCell.setCellStyle(headStyle);
        headerCell.setCellValue(
                 "※ 공란 또는 띄어쓰기는 입력할 수 없습니다.\n"
                +"※ 서식 변경 시, 오류가 발생합니다. 샘플을 수정 또는 복사하여 사용하세요.(텍스트 서식)\n"
                +"1. 연락처는 '-'(하이픈)을 포함하여 입력해주세요.\n"
                +"※ 연락처를 잘못 입력할 시 쿠폰이 발송되지 않습니다.\n"
                +"2. 금액은 '숫자' 만 입력해주세요.\n"
                +"※ 특수문자(',') 또는 텍스트 형식이 아닐 시, 입력되지 않습니다.\n"
                +"3. 쿠폰타입은 '셀 선택' 또는 '셀 내용을 입력' 해주세요.\n"
                +"※ 1회권, 다회권 외에 다른 값은 입력되지 않습니다."
                
                
        );
        headerRow.setHeight((short) 3000);
        sheet.addMergedRegion(
            new CellRangeAddress(rowNo - 1, rowNo - 1, 0, 2));
        
        
        headerRow = sheet.createRow(rowNo++);
        headerRow.setHeight((short) 212);
        headerRow = sheet.createRow(rowNo++);
        headerRow.setHeight((short) 212);
        
        ArrayList<String> tableHeader = new ArrayList<>();
    
        tableHeader.add("연락처");
        tableHeader.add("금액");
        if (request.getParameter("useRuseYn").equals("Y")) {
            tableHeader.add("쿠폰타입");
        }
        
        headerRow.setHeight((short) 512);
        
        for (int i = 0; i < tableHeader.size(); i++) {
            sheet.autoSizeColumn(i);
            sheet.setColumnWidth(i, (sheet.getColumnWidth(i)) + 3024);
            headerCell = headerRow.createCell(i);
            headerCell.setCellStyle(titleStyle);
            headerCell.setCellValue(tableHeader.get(i));
        }
        
        List<HashMap<String, String>> list = Arrays.asList(new HashMap<String, String>() {
            {
                put("phone", "010-1234-1234");
                put("amount", "1000");
                put("couponType", "1회권");
            }
        }, new HashMap<String, String>() {
            {
                put("phone", "010-1234-1234");
                put("amount", "1000");
                put("couponType", "다회권");
            }
        });
        
        for (HashMap<String, String> v : list) {
            bodyRow = sheet.createRow(rowNo++);
            colno = 0;
    
            bodyCell = bodyRow.createCell(colno++);
            bodyCell.setCellValue(v.get("phone"));
            bodyCell.setCellStyle(bodyStyle);
    
            bodyCell = bodyRow.createCell(colno++);
            bodyCell.setCellValue(v.get("amount"));
            bodyCell.setCellStyle(bodyStyle);
            
            if (request.getParameter("useRuseYn").equals("Y")) {
                String[] couponType = new String[]{"1회권", "다회권"};
                CellRangeAddressList addressList = new CellRangeAddressList();
                
                addressList.addCellRangeAddress(3, 2, 1000, 2);
                DVConstraint constraing = DVConstraint.createExplicitListConstraint(couponType);
                HSSFDataValidation dataValidation = new HSSFDataValidation(addressList, constraing);
    
                //공백무시 옵션 true : 무시, false: 무시안함
                dataValidation.setEmptyCellAllowed(false);
                
                //cell 선택시 설명메시지 보이기 옵션  true: 표시, false : 표시안함
                dataValidation.setShowPromptBox(true);
                dataValidation.createPromptBox("안내", "셀을 선택하여 발권할 쿠폰 종류를 선택하세요.");
                
                //cell 선택시 드롭다운박스 list 표시여부 설정 true : 안보이게, false : 보이게
                dataValidation.setSuppressDropDownArrow(false);
                sheet.addValidationData(dataValidation);
                bodyCell = bodyRow.createCell(colno++);
                bodyCell.setCellValue(v.get("couponType"));
                bodyCell.setCellStyle(bodyStyle);
                dataValidation.setErrorStyle(HSSFDataValidation.ErrorStyle.STOP);
            }
        }
        return workbook;
    }
    
    public HSSFWorkbook getCouponSalesListExcel(ModelAndView mav) {
        Map<String, Object> map = mav.getModelMap();
        HttpServletRequest request = (HttpServletRequest) map.get("request");
        HttpSession session = (HttpSession) map.get("session");
        HSSFWorkbook workbook = new HSSFWorkbook();
        HSSFRow bodyRow = null;
        HSSFCell bodyCell = null;
        int colno = 0;
        
        HSSFFont font = (HSSFFont) workbook.createFont();
        font.setBoldweight(Font.BOLDWEIGHT_BOLD);
        HSSFDataFormat format = workbook.createDataFormat();
        // 테이블 헤더용 스타일
        HSSFCellStyle headStyle = workbook.createCellStyle();
        
        // 가는 경계선을 가집니다.
        headStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
        headStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
        headStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
        headStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
        
        // 배경색은 노란색입니다.
        headStyle.setFillForegroundColor(IndexedColors.LIGHT_YELLOW.getIndex());
        headStyle.setFillPattern(CellStyle.SOLID_FOREGROUND);
        
        // 데이터는 가운데 정렬합니다.
        headStyle.setAlignment(CellStyle.ALIGN_CENTER);
        headStyle.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        headStyle.setFont(font);
        
        // 테이블 헤더용 값 스타일
        HSSFCellStyle valueheadStyle = workbook.createCellStyle();
        valueheadStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
        valueheadStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
        valueheadStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
        valueheadStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
        valueheadStyle.setFillForegroundColor(IndexedColors.WHITE.getIndex());
        valueheadStyle.setFillPattern(CellStyle.SOLID_FOREGROUND);
        // 데이터는 가운데 정렬합니다.
        valueheadStyle.setAlignment(CellStyle.ALIGN_LEFT);
        valueheadStyle.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        valueheadStyle.setFont(font);
        
        HSSFCellStyle mumheadStyle = workbook.createCellStyle();
        
        // 가는 경계선을 가집니다.
        mumheadStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
        mumheadStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
        mumheadStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
        mumheadStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
        
        // 배경색은 노란색입니다.
        mumheadStyle.setFillForegroundColor(IndexedColors.LIGHT_YELLOW.getIndex());
        mumheadStyle.setFillPattern(CellStyle.SOLID_FOREGROUND);
        
        // 데이터는 가운데 정렬합니다.
        mumheadStyle.setAlignment(CellStyle.ALIGN_RIGHT);
        mumheadStyle.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        mumheadStyle.setFont(font);
        mumheadStyle.setDataFormat(format.getFormat("#,##0"));
        
        // 데이터용 경계 스타일 테두리만 지정
        HSSFCellStyle bodyStyle = workbook.createCellStyle();
        bodyStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
        bodyStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
        bodyStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
        bodyStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
        bodyStyle.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        bodyStyle.setDataFormat(format.getFormat("text"));
        
        HSSFCellStyle numBodyStyle = workbook.createCellStyle();
        numBodyStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
        numBodyStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
        numBodyStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
        numBodyStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
        numBodyStyle.setAlignment(HSSFCellStyle.ALIGN_RIGHT);
        numBodyStyle.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        numBodyStyle.setDataFormat(format.getFormat("#,##0"));
        
        // 시트생성
        HSSFSheet sheet = workbook.createSheet("쿠폰사용내역");
        int rowNo = 0;
        
        HSSFRow headerRow = sheet.createRow(rowNo++);
        headerRow.setHeight((short) 512);
        String[] pageheaderKey = {"조회기간",
            request.getParameter("sDate") + " ~ " + request.getParameter("eDate")};
        
        HSSFCell headerCell = null;
        for (int i = 0; i < pageheaderKey.length; i++) {
            headerCell = headerRow.createCell(i);
            if (i == 0) {
                headerCell.setCellStyle(headStyle);
            } else {
                headerCell.setCellStyle(valueheadStyle);
            }
            
            headerCell.setCellValue(pageheaderKey[i]);
        }
        sheet.addMergedRegion(
            new CellRangeAddress(rowNo - 1, rowNo - 1, 1, pageheaderKey.length - 1));
        headerRow = sheet.createRow(rowNo++);
        headerRow.setHeight((short) 212);
        headerRow = sheet.createRow(rowNo++);
        headerRow.setHeight((short) 212);
        
        ArrayList<String> tableHeader = new ArrayList<>();
        
        tableHeader.add("승인일자");
        tableHeader.add("승인시간");
        if (session.getAttribute("role").equals("system")) {
            tableHeader.add("그룹명");
            tableHeader.add("발권된 연락처");
        }
        tableHeader.add("쿠폰번호");
        tableHeader.add("TID");
        tableHeader.add("쿠폰타입");
        tableHeader.add("쿠폰금액");
        tableHeader.add("사용금액");
        tableHeader.add("쿠폰잔액");
        tableHeader.add("컬럼");
        tableHeader.add("거래결과");
        tableHeader.add("서버응답");
        
        headerRow.setHeight((short) 512);
        
        for (int i = 0; i < tableHeader.size(); i++) {
            sheet.autoSizeColumn(i);
            sheet.setColumnWidth(i, (sheet.getColumnWidth(i)) + 3024);
            headerCell = headerRow.createCell(i);
            headerCell.setCellStyle(headStyle);
            headerCell.setCellValue(tableHeader.get(i));
        }
        List<CouponSalesVO> list = couponMapper.getCouponSalesList(makeRequestForm(mav));
        for (CouponSalesVO couponSalesVO : list) {
            bodyRow = sheet.createRow(rowNo++);
            colno = 0;
            
            bodyCell = bodyRow.createCell(colno++);
            bodyCell.setCellStyle(bodyStyle);
            bodyCell.setCellValue(couponSalesVO.getTranDate());
            
            bodyCell = bodyRow.createCell(colno++);
            bodyCell.setCellStyle(bodyStyle);
            bodyCell.setCellValue(couponSalesVO.getTranTime());
            
            if (session.getAttribute("role").equals("system")) {
                bodyCell = bodyRow.createCell(colno++);
                bodyCell.setCellStyle(bodyStyle);
                bodyCell.setCellValue(couponSalesVO.getGroupName());
                
                bodyCell = bodyRow.createCell(colno++);
                bodyCell.setCellStyle(bodyStyle);
                bodyCell.setCellValue(couponSalesVO.getRevMobile());
            }
            
            bodyCell = bodyRow.createCell(colno++);
            bodyCell.setCellStyle(bodyStyle);
            bodyCell.setCellValue(couponSalesVO.getCouponNo());
            
            bodyCell = bodyRow.createCell(colno++);
            bodyCell.setCellStyle(bodyStyle);
            bodyCell.setCellValue(couponSalesVO.getTerminalId());
            
            bodyCell = bodyRow.createCell(colno++);
            bodyCell.setCellStyle(bodyStyle);
            bodyCell.setCellValue(couponSalesVO.getCouponType());
            
            bodyCell = bodyRow.createCell(colno++);
            bodyCell.setCellStyle(bodyStyle);
            bodyCell.setCellValue(
                Util.stringUtils(String.valueOf(couponSalesVO.getCouponAmt())).convertMoneyFormat()
                    + "원");
            
            bodyCell = bodyRow.createCell(colno++);
            bodyCell.setCellStyle(bodyStyle);
            bodyCell.setCellValue(
                Util.stringUtils(String.valueOf(couponSalesVO.getTranAmt())).convertMoneyFormat()
                    + "원");
            
            bodyCell = bodyRow.createCell(colno++);
            bodyCell.setCellStyle(bodyStyle);
            bodyCell.setCellValue(couponSalesVO.getMsgType().equals("조회") ? "0원" :
                Util.stringUtils(String.valueOf(couponSalesVO.getAftAmt())).convertMoneyFormat()
                    + "원");
            
            bodyCell = bodyRow.createCell(colno++);
            bodyCell.setCellStyle(bodyStyle);
            bodyCell.setCellValue(couponSalesVO.getColNo());
            
            bodyCell = bodyRow.createCell(colno++);
            bodyCell.setCellStyle(bodyStyle);
            bodyCell.setCellValue(couponSalesVO.getMsgType());
            
            bodyCell = bodyRow.createCell(colno++);
            bodyCell.setCellStyle(bodyStyle);
            bodyCell.setCellValue(couponSalesVO.getReplyMsg());
        }
        return workbook;
    }
    
    //2023.12.20 twkim 엑셀 내 별도 표기를 위해 모듈화
    private String convertCouponStat(String statCode) {
        String convertCouponStat = "";
        switch (statCode) {
            case "N":
                convertCouponStat = "미사용";
                break;
            case "L":
                convertCouponStat = "잠금";
                break;
            case "D":
                convertCouponStat = "기간만료";
                break;
            case "U":
                convertCouponStat = "사용완료";
                break;
        }
        return convertCouponStat;
    }
}
