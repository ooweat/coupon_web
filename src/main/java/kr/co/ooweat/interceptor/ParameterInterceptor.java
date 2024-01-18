package kr.co.ooweat.interceptor;

import java.util.Arrays;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

@Slf4j
public class ParameterInterceptor implements HandlerInterceptor {
    
    public List activeList = Arrays.asList("/group/client", "/group/user", "/group/setting");
    public List allowList = Arrays.asList("/assets/**", "/static/**", "/resources/**", "/cp",
        "/login", "/dashboard");
    
    @Override
    public boolean preHandle(HttpServletRequest request,
        HttpServletResponse response, Object handler) throws Exception {
        
        request.setAttribute("paramGroupSeq", request.getParameter("paramGroupSeq") != null ?
            Long.parseLong(request.getParameter("paramGroupSeq")) : 0);
        
        log.info(request.getServletPath());
        if(request.getServletPath().equals("/group/user")){
            request.setAttribute("searchType",
                request.getParameter("searchType") != null ?
                    request.getParameter("searchType") : "0");
    
            request.setAttribute("searchValue",
                request.getParameter("searchValue") != null ?
                    request.getParameter("searchValue") : "");
        }

        return HandlerInterceptor.super.preHandle(request, response, handler);
    }
    
    @Override
    public void postHandle(HttpServletRequest request,
        HttpServletResponse response, Object handler, ModelAndView mav) throws Exception {
        mav.addObject("searchType", request.getAttribute("searchType"));
        mav.addObject("searchValue", request.getAttribute("searchValue"));
    }
    
    @Override
    public void afterCompletion(HttpServletRequest request,
        HttpServletResponse response, Object handler, Exception ex) throws Exception {
        
    }
}
