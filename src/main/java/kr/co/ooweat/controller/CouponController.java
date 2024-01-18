package kr.co.ooweat.controller;

import java.io.BufferedOutputStream;
import java.io.OutputStream;
import java.net.URLEncoder;
import javax.servlet.http.HttpServletResponse;
import kr.co.ooweat.service.CouponService;
import kr.co.ooweat.service.DashboardService;
import lombok.extern.slf4j.Slf4j;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

@Slf4j
@RestController
@RequestMapping(value = "/coupon/")
public class CouponController {
    @Autowired
    DashboardService dashboardService;

    @Autowired
    CouponService couponService;
    
    @RequestMapping("issuance")
    public ModelAndView couponIssuance(HttpServletRequest request, HttpSession session) {
        ModelAndView mav = new ModelAndView();
        mav.addObject("session", session);
        mav.addObject("request", request);
        couponService.issuance(mav);
        return mav;
    }
    
    @RequestMapping("sales")
    public ModelAndView couponSales(HttpServletRequest request, HttpSession session) {
        ModelAndView mav = new ModelAndView();
        mav.addObject("session", session);
        mav.addObject("request", request);
        couponService.sales(mav);
        return mav;
    }
    
    @RequestMapping("excelDownload")
    public void excelDownload(HttpServletRequest request, HttpServletResponse response, HttpSession session) {
        ModelAndView mav = new ModelAndView();
        mav.addObject("session", session);
        mav.addObject("request", request);
        mav.addObject("response", response);
    
        OutputStream out = null;
        try {
        
            String fileName = "";
            HSSFWorkbook workbook = new HSSFWorkbook();
            switch (request.getParameter("serviceType")){
                case "sample":
                    fileName = "쿠폰발권양식.xls";
                    workbook = couponService.getCouponSampleExcel(mav);
                    break;
                case "issuance":
                    fileName = "쿠폰발권내역_"+request.getParameter("sDate")+"-"+request.getParameter("eDate")+".xls";
                    workbook = couponService.getCouponIssaunceListExcel(mav);
                    break;
                case "sales":
                    fileName = "쿠폰사용내역"+request.getParameter("sDate")+"-"+request.getParameter("eDate")+".xls";
                    workbook = couponService.getCouponSalesListExcel(mav);
                    break;
            }
            response.reset();
            response.setHeader("Content-Disposition", "attachment;filename=" + URLEncoder.encode(fileName, "UTF-8"));
            response.setContentType("application/vnd.ms-excel");
            out = new BufferedOutputStream(response.getOutputStream());
        
            workbook.write(out);
            out.flush();
        
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
