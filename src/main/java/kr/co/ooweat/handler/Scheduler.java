package kr.co.ooweat.handler;

import kr.co.ooweat.common.Util;
import kr.co.ooweat.service.CouponService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

@Slf4j
@Component
@EnableAutoConfiguration
public class Scheduler {
    @Autowired
    CouponService couponService;
    @Scheduled(cron = "${batch.ones.0AM.crond}") // 00시 한 번
    public void ones9AM(){
        log.info("lol");
        couponService.couponExpire(Util.dateUtils().yyyyMMdd(-1));
    }
}
