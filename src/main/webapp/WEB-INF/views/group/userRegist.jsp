<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta charset="UTF-8">
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, shrink-to-fit=no"
          name="viewport">
    <script type="text/javascript" src="/assets/js/jquery.js"></script>
    <title></title>
    <script type="text/javascript">
      function checkUsable() {
        if ($('#userId').val() == "" || $('#userId').val().length < 3) {
          alert("3 글자 이상의 아이디를 입력해주세요.");
          $('#userId').focus();
          return false;
        }
        $.ajax({
          type: "POST",
          url: "/ajax/alreadyUserCheck",
          data: {
            "userId": $("#userId").val(),
          },
          dataType: "json",
          cache: false,
          success: function (cmd) {
            if (cmd.code == '0000') {
              Swal.fire({
                title: '<strong>사용 가능</strong>',
                icon: 'success',
                html: '사용가능한 아이디 입니다.',
                showCloseButton: true,
                showCancelButton: false,
                focusConfirm: false,
                confirmButtonText: '확인',
                confirmButtonAriaLabel: 'Thumbs up, great!',
              }).then((click) => {
                $("#canUseUserId").val('Y');
              });
            } else {
              Swal.fire({
                title: '<strong>사용 불가능</strong>',
                icon: 'error',
                html: '이미 존재하는 아이디 입니다.',
                showCloseButton: true,
                showCancelButton: false,
                focusConfirm: false,
                confirmButtonText: '확인',
                confirmButtonAriaLabel: 'Thumbs up, great!',
              }).then((click) => {
                $("#canUseUserId").val('N');
              });
            }
            //console.log($("#canUseUserId").val());
          }, // success
          error: function () {
            alert('오류발생. 다시 시도해 주세요.');
          }
        });

      }

      function onRegist() {
        if ($('#userId').val() == "" || $('#userId').val().length < 3) {
          alert("3 글자 이상의 아이디를 입력해주세요.");
          $('#userId').focus();
          return;
        }
        if ($('#userPw').val() == "" || $('#userPw').val().length < 4) {
          alert("4글자 이상의 비밀번호를 입력해주세요.");
          $('#userPw').focus();
          return;
        }
        if ($('#userName').val() == "" || $('#userName').val().length < 3) {
          alert("3글자 이상의 사용자명을 입력해주세요.");
          $('#userName').focus();
          return;
        }

        $('#useDashboard').val($('#useDashboard').is(":checked") ?'Y':'N');
        $('#useCouponPublish').val($('#useCouponPublish').is(":checked") ?'Y':'N');
        $('#useCouponConfig').val($('#useCouponConfig').is(":checked") ?'Y':'N');
        $('#useCouponIssuanceHistory').val($('#useCouponIssuanceHistory').is(":checked") ?'Y':'N');
        $('#useCouponSalesHistory').val($('#useCouponSalesHistory').is(":checked") ?'Y':'N');

        $("#canUseUserId").val() == 'Y' ?
            confirmPost('/ajax/insertUser') :
            $("#canUseUserId").val() == 'S' ?
                alert("중복검사를 진행해주세요.") :
                alert("이미 등록된 아이디 입니다.");
      }
    </script>
</head>
<body>
<!-- Main Content -->
<div class="main-content">
    <div class="row">
        <div class="col-12 col-sm-10 offset-sm-1 col-md-8 offset-md-2 col-lg-8 offset-lg-2 col-xl-4 offset-xl-4">
            <div class="card card-primary">
                <div class="card-header"><h4>그룹계정 등록</h4></div>

                <div class="card-body">
                    <form role="form" method="POST" name="formData" id="formData"
                          class="needs-validation"
                          novalidate>
                        <input type="hidden" id="canUseUserId" value="S"/>
                        <div class="row">
                            <div class="form-group col-lg-12 col-md-12 col-sm-12">
                                <label for="userId">아이디</label>
                                <div class="nav-collapse">
                                    <input id="userId" type="text"
                                           class="form-control col-lg-8 col-md-8 col-sm-12"
                                           name="userId"
                                           required autofocus>
                                    <button type="button"
                                            class="form-control col-lg-4 col-md-4 col-sm-12 btn btn-primary"
                                            id="newEntry" onclick="checkUsable();">중복검사
                                    </button>
                                    <div class="invalid-feedback">
                                        내용을 입력해주세요!
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="form-group col-lg-12 col-md-12 col-sm-12">
                                <label for="userPw">비밀번호</label>
                                <input id="userPw" type="password" class="form-control"
                                       name="userPw"
                                       placeholder="비밀번호 입력" required autofocus=""
                                       autocomplete="new-password">
                                <div class="invalid-feedback">
                                    내용을 입력해주세요!
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="form-group col-lg-12 col-md-12 col-sm-12">
                                <label for="userName">사용자명</label>
                                <input id="userName" type="text" class="form-control"
                                       name="userName"
                                       placeholder="사용자명 입력" required="" autofocus=""
                                       autocomplete="new-password">
                                <div class="invalid-feedback">
                                    내용을 입력해주세요!
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="form-group col-lg-12 col-md-12 col-sm-12">
                                <label for="groupSeq">그룹</label>
                                <select id="groupSeq" name="groupSeq"
                                        class="form-control select2 select2-hidden-accessible"
                                        tabindex="-1"
                                        aria-hidden="true">>
                                    <c:forEach var="getGroupList" items="${getGroupList}">
                                        <option value="${getGroupList.groupSeq}">${getGroupList.groupName}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div class="row">
                            <div class="form-group col-lg-12 col-md-12 col-sm-12">
                                <label for="role">권한</label>
                                <select id="role" name="role"
                                        class="form-control select2 select2-hidden-accessible"
                                        tabindex="-1"
                                        aria-hidden="true">>
                                    <c:if test="${role=='system'}">
                                        <option value="system">
                                            시스템계정(ooweat)
                                        </option>
                                        <%--<option value="admin">
                                            가맹본부(일반관리자)</option>--%>
                                    </c:if>
                                    <option value="merchant" selected>
                                        가맹점(운영자)
                                    </option>
                                </select>
                            </div>
                        </div>
                        <div class="row">
                            <div class="form-group col-lg-12 col-md-12 col-sm-12">
                                <label for="pageAuth">페이지
                                    <i class="fas fa-question-circle title-i-line-height text-primary"
                                       data-toggle="tooltip" title=""
                                       data-original-title="체크된 페이지만 볼 수 있는 권한이에요"></i></label>
                                <div class="selectgroup selectgroup-pills" id="pageAuth">
                                    <label class="selectgroup-item">
                                        <input type="checkbox" name="useDashboard"
                                               id="useDashboard" class="selectgroup-input"
                                               checked="">
                                        <span class="selectgroup-button">Dashboard</span>
                                    </label>
                                    <label class="selectgroup-item">
                                        <input type="checkbox" name="useCouponPublish"
                                               id="useCouponPublish" class="selectgroup-input"
                                               checked="">
                                        <span class="selectgroup-button">쿠폰발권</span>
                                    </label>
                                    <label class="selectgroup-item">
                                        <input type="checkbox" name="useCouponConfig"
                                               id="useCouponConfig" class="selectgroup-input"
                                               checked="">
                                        <span class="selectgroup-button">쿠폰설정</span>
                                    </label>
                                    <label class="selectgroup-item">
                                        <input type="checkbox" name="useCouponIssuanceHistory"
                                               id="useCouponIssuanceHistory"
                                               class="selectgroup-input" checked="">
                                        <span class="selectgroup-button">쿠폰발권내역</span>
                                    </label>
                                    <label class="selectgroup-item">
                                        <input type="checkbox" name="useCouponSalesHistory"
                                               id="useCouponSalesHistory"
                                               class="selectgroup-input" checked="">
                                        <span class="selectgroup-button">쿠폰사용내역</span>
                                    </label>
                                </div>
                            </div>
                        </div>
                        <input type="hidden" name="modAdminId" value="${userId}"/>
                        <input type="hidden" name="page" value="userInsert"/>
                        <div class="row">
                            <div class="form-group col-6">
                                <button type="button"
                                        onclick="onRegist();"
                                        class="btn btn-primary btn-lg btn-block">
                                    등록
                                </button>
                            </div>
                            <div class="form-group col-6">
                                <button type="button" onclick="location.href='/group/user'"
                                        class="btn btn-secondary btn-lg btn-block">
                                    목록
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
