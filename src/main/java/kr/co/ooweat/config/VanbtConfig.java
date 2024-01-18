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

import javax.sql.DataSource;

@Configuration
@MapperScan(value = "kr.co.ooweat.coupon_web.mappers.vanbt", sqlSessionFactoryRef = "vanbtSqlSessionFactory")
public class VanbtConfig {

    //TODO: Primary는 Maria

    @Bean(name = "vanbt")
    @ConfigurationProperties(prefix = "spring.datasource.vanbt")
    public DataSource vanbtDataSource() {
        return DataSourceBuilder.create().build();
    }

    @Bean(name = "vanbtSqlSessionFactory")
    public SqlSessionFactory vanbtSqlSessionFactory(@Qualifier("vanbt") DataSource vanbtDataSource, ApplicationContext applicationContext) throws Exception {
        SqlSessionFactoryBean sqlSessionFactoryBean = new SqlSessionFactoryBean();
        sqlSessionFactoryBean.setDataSource(vanbtDataSource);
        sqlSessionFactoryBean.setTypeAliasesPackage("kr.co.ooweat.coupon_web.model");
        sqlSessionFactoryBean.setMapperLocations(applicationContext.getResources("classpath:mappers/vanbt/*.xml"));
        return sqlSessionFactoryBean.getObject();
    }

    @Bean(name = "vanbtSessionTemplate")
    public SqlSessionTemplate vanbtSqlSessionTemplate(@Qualifier("vanbtSqlSessionFactory") SqlSessionFactory vanbtSqlSessionFactory) {
        return new SqlSessionTemplate(vanbtSqlSessionFactory);
    }
}
