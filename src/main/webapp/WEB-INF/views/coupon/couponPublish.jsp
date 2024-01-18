<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta charset="UTF-8">
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, shrink-to-fit=no" name="viewport">
    <script type="text/javascript" src="/assets/js/jquery.js"></script>
    <script type="text/javascript" src="/assets/js/custom.js"></script>
    <title>Product Info</title>
</head>
<body>
<!-- Main Content -->
<div class="main-content">
    <div class="row">
        <div class="col-12 col-md-8 col-lg-8 col-xl-8">
            <div class="card card-primary">
                <div class="card-header"><h4>쿠폰등록</h4></div>
                <div class="card-body">
                    <form role="form" method="POST" name="formData" id="formData" class="needs-validation" novalidate=""
                          action="/coupon/couponOK.do" onsubmit="loadingStart();">
                        <div class="row">
                            <div class="form-group col-lg-4 col-md-4 col-sm-12">
                                <label for="userid">발급계정</label>
                                <input id="userid" type="text" class="form-control" name="userName"
                                       value="${userName}" required="" autofocus="" readonly>
                                <input type="hidden" name="userid" value="${userId}"/>
                            </div>
                            <div class="form-group col-lg-4 col-md-4 col-sm-12">
                                <label for="cpntype">쿠폰타입</label>
                                <select id="cpntype" name="cpntype"
                                        class="form-control select2 select2-hidden-accessible" tabindex="-1" aria-hidden="true">>
                                    <option value="GIFT">1회권</option>
                                    <option value="RUSE">다회권(고정)</option>
                                    <%--<option value="DISG">할인금액권</option>
                                    <option value="DISP">할인율권</option>--%>
                                </select>
                            </div>
                            <div class="form-group col-lg-4 col-md-4 col-sm-12">
                                <label for="amount">금액
                                    <i class="fas fa-question-circle title-i-line-height text-primary"
                                       data-toggle="tooltip" title="" data-original-title="','(콤마) 를 제외한 금액을 입력해주세요!"></i>
                                </label>
                                <input id="amount" type="number" class="form-control" name="amount"
                                       min="100" max="999999" maxlength="6" value="1000" required="" autofocus="">
                                <div class="invalid-feedback">
                                    ',' 를 제외한 숫자를 입력해주세요!(최소 100원)
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="form-group col-lg-4 col-md-4 col-sm-12">
                                <label for="tel">알림톡 수신 연락처
                                    <i class="fas fa-question-circle title-i-line-height text-primary"
                                       data-toggle="tooltip" title="" data-original-title="
                                       '-' 하이픈을 포함한 11자리를 입력해주세요! 해당 연락처로 카카오 알림톡이 전송됩니다."
                                    ></i>
                                </label>
                                <input id="tel" type="text" class="form-control" name="tel" minlength="11" maxlength="13"
                                       required="" autofocus="" onkeyup="addHyphenPhoneNo(this)">
                                <div class="invalid-feedback">
                                    올바른 휴대폰 번호를 11자리를 입력해주세요! ex)010-0000-0000
                                </div>
                            </div>
                            <%--마스터이면 보이지 않음--%>
                            <div class="form-group col-lg-6 col-md-6 col-sm-12">
                                <label for="paramGroupSeq">쿠폰 사용처
                                    <i class="fas fa-question-circle title-i-line-height text-primary"
                                       data-toggle="tooltip" title=""
                                       data-original-title="계정에 등록된 단말기에서만 사용 가능합니다."></i>
                                </label>
                                <select id="paramGroupSeq" name="paramGroupSeq"
                                        class="form-control select2 select2-hidden-accessible" tabindex="-1" aria-hidden="true">>
                                    <c:if test="${role =='system'}">
                                        <option value="0" selected>-전체-</option>
                                        <c:forEach var="getGroupList" items="${getGroupList}">
                                            <option value="${getGroupList.groupSeq}"
                                                    <c:if test="${hmap.paramGroupSeq != null ?
                                                                    getGroupList.groupSeq==hmap.paramGroupSeq : getGroupList.groupSeq==0}">selected</c:if>
                                            >
                                                    ${getGroupList.groupName}
                                            </option>
                                        </c:forEach>
                                    </c:if>
                                    <c:if test="${role !='system'}">
                                        <c:forEach var="getGroupList" items="${getGroupList}">
                                            <option value="${getGroupList.groupSeq}" <c:if test="${getGroupList.groupSeq==hmap.paramGroupSeq}">selected</c:if>>
                                                    ${getGroupList.groupName}
                                            </option>
                                        </c:forEach>
                                    </c:if>
                                </select>
                                <%--<select id="groupSeq" name="groupSeq"
                                        class="form-control select2 select2-hidden-accessible" tabindex="-1" aria-hidden="true">>
                                    <option value="" selected>-그룹선택-</option>
                                    <c:forEach var="getGroupList" items="${getGroupList}">
                                        <option value="${getGroupList.groupSeq}"
                                                <c:if test="${hmap.paramGroupSeq != null ?
                                                                    getGroupList.groupSeq==hmap.paramGroupSeq : getGroupList.groupSeq==0}">selected</c:if>
                                        >${getGroupList.groupName}</option>
                                    </c:forEach>
                                </select>--%>
                            </div>
                        </div>
                        <%--
                        <div class="form-divider">
                            부가정보
                        </div>
                        <div class="row">
                            <div class="form-group col-3">
                                <label class="form-label">사용구분</label>
                                <div class="selectgroup w-100">
                                    <label class="selectgroup-item">
                                        <input type="radio" name="validity" value="1" class="selectgroup-input"
                                               checked="checked">
                                        <span class="selectgroup-button">사용</span>
                                    </label>
                                    <label class="selectgroup-item">
                                        <input type="radio" name="validity" value="0" class="selectgroup-input">
                                        <span class="selectgroup-button">미사용</span>
                                    </label>
                                </div>
                            </div>
                            <div class="form-group col-3">
                                <label for="createDate">최초등록일자</label>
                                <input id="createDate" type="text" class="form-control"
                                       readonly="readonly" placeholder="자동기입">
                            </div>
                        </div>--%>
                        <div class="row">
                            <div class="form-group col-12">
                                <button type="submit" class="btn btn-primary btn-lg btn-block">
                                    등록
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
