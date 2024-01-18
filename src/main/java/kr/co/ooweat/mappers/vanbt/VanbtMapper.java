package kr.co.ooweat.mappers.vanbt;

import kr.co.ooweat.model.BizVO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface VanbtMapper {
    List<BizVO> getVmmsCompanyList();
    List<BizVO> getBusinessList(String companySeq);
}
