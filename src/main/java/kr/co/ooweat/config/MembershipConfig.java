package kr.co.ooweat.config;

import org.apache.ibatis.session.SqlSessionFactory;
import org.mybatis.spring.SqlSessionFactoryBean;
import org.mybatis.spring.SqlSessionTemplate;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.boot.jdbc.DataSourceBuilder;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;

import javax.sql.DataSource;

@Configuration
@MapperScan(value = "kr.co.ooweat.coupon_web.mappers.coupon_web", sqlSessionFactoryRef = "coupon_webSqlSessionFactory")
public class coupon_webConfig {

    //TODO: Primary는 Maria

    @Primary
    @Bean(name = "coupon_web")
    @ConfigurationProperties(prefix = "spring.datasource.coupon_web")
    public DataSource coupon_webDataSource() {
        return DataSourceBuilder.create().build();
    }

    @Primary
    @Bean(name = "coupon_webSqlSessionFactory")
    public SqlSessionFactory coupon_webSqlSessionFactory(@Qualifier("coupon_web") DataSource coupon_webDataSource, ApplicationContext applicationContext) throws Exception {
        SqlSessionFactoryBean sqlSessionFactoryBean = new SqlSessionFactoryBean();
        sqlSessionFactoryBean.setDataSource(coupon_webDataSource);
        sqlSessionFactoryBean.setTypeAliasesPackage("kr.co.ooweat.coupon_web.model");
        sqlSessionFactoryBean.setMapperLocations(applicationContext.getResources("classpath:mappers/coupon_web/*.xml"));
        return sqlSessionFactoryBean.getObject();
    }

    @Primary
    @Bean(name = "coupon_webSessionTemplate")
    public SqlSessionTemplate coupon_webSqlSessionTemplate(@Qualifier("coupon_webSqlSessionFactory") SqlSessionFactory coupon_webSqlSessionFactory) {
        return new SqlSessionTemplate(coupon_webSqlSessionFactory);
    }
}
