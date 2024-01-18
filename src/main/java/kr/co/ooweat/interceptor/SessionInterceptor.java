package kr.co.ooweat.interceptor;

import java.util.Arrays;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

@Slf4j
public class SessionInterceptor implements HandlerInterceptor {
    
    public List allowList = Arrays.asList("/assets/**", "/static/**", "/resources/**", "/cp", "/login");
    @Override
    public boolean preHandle(HttpServletRequest request,
        HttpServletResponse response, Object handler) throws Exception {
        HttpSession session = request.getSession();
        
        if(request.getRequestURL().toString().contains("login")){
            return true;
        }
        if ((String) session.getAttribute("userId") != null) {
            if(session.getAttribute("role").equals("system")){
                //2023.12.19 twkim 시스템 계정의 경우, 세션 무제한
                session.setMaxInactiveInterval(-1);
            } else {
                session.setMaxInactiveInterval(180 * 60);
            }
            return true;
        } else {
            response.sendRedirect("/login");
            return false;
        }
    }
    
    @Override
    public void postHandle(HttpServletRequest request,
        HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {
        
    }
    
    @Override
    public void afterCompletion(HttpServletRequest request,
        HttpServletResponse response, Object handler, Exception ex) throws Exception {
        
    }
}
