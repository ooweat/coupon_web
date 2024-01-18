package kr.co.ooweat.mappers.coupon_web;

import java.util.List;
import kr.co.ooweat.model.UserVO;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface UserMapper {
    UserVO loginConfirm(String userId, String userPw);
    int alreadyUserCheck(String userId);
    List<UserVO> callGroupUserList(long groupSeq);
    String findUserId(long userSeq);
}
