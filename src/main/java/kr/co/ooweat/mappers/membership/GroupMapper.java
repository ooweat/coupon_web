package kr.co.ooweat.mappers.coupon_web;

import kr.co.ooweat.model.CouponConfVO;
import kr.co.ooweat.model.GroupVO;
import kr.co.ooweat.model.MemberGroupVO;
import kr.co.ooweat.model.UserVO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Map;

@Mapper
public interface GroupMapper {
    List<GroupVO> getGroupClientList(long paramGroupSeq);
    int insertGroup(String groupName);
    int updateGroup(GroupVO groupVO);
    GroupVO groupInfo(long paramGroupSeq);
    List<MemberGroupVO> clientInfo(long groupSeq);
    int insertClient(List<Map<String, Object>> mgList);
    int checkClient(long groupSeq);
    int deleteClient(long groupSeq);
    List<UserVO> userList(long paramGroupSeq, String searchType, String searchValue);
    UserVO userInfo(long userSeq);
    List<GroupVO> getGroupList();
    List<CouponConfVO> getGroupSettingList(long paramGroupSeq, String startDate, String endDate);
    
    int updateUser(UserVO userVO);
    int insertUser(UserVO userVO);
    int insertCouponBin(String groupName);
    int updateCouponBinDonggu(Long groupSeq);
    int insertCouponConfig(String groupName);

    List<MemberGroupVO> alreadyClientCheck(MemberGroupVO memberGroupVO);
}
