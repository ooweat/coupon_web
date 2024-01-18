package kr.co.ooweat.config;

import kr.co.ooweat.interceptor.PageInterceptor;
import kr.co.ooweat.interceptor.ParameterInterceptor;
import kr.co.ooweat.interceptor.SessionInterceptor;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {
    //TODO: 확장성을 염두에 두고 * 모든 접근
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/webjars/**").addResourceLocations("classpath:/static/webjars/",
                "classpath:/META-INFwebjars/");
        registry.addResourceHandler("/**").addResourceLocations("classpath:/static/", "classpath:/META-INF");
    }

    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/**")
                .allowedOrigins("*")
                .allowedMethods("GET", "POST")
                .maxAge(3000);
    }
    
    @Override
    public void addInterceptors(InterceptorRegistry registry){
        //2023.12.08 twkim session 인터셉터
        SessionInterceptor sessionInterceptor = new SessionInterceptor();
        registry.addInterceptor((HandlerInterceptor) sessionInterceptor)
            .addPathPatterns("/**")
            .excludePathPatterns(sessionInterceptor.allowList);
    
        //2023.12.08 twkim page 안터셉터
        PageInterceptor pageInterceptor = new PageInterceptor();
        registry.addInterceptor((HandlerInterceptor) pageInterceptor)
            .addPathPatterns(pageInterceptor.activeList)
            .excludePathPatterns(pageInterceptor.allowList);
    
        //2023.12.13 twkim group 안터셉터
        ParameterInterceptor parameterInterceptor = new ParameterInterceptor();
        registry.addInterceptor((HandlerInterceptor) parameterInterceptor)
            .addPathPatterns(parameterInterceptor.activeList)
            .excludePathPatterns(parameterInterceptor.allowList);
    }
}
