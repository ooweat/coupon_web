<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
a
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta charset="UTF-8">
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, shrink-to-fit=no"
          name="viewport">
    <script type="text/javascript" src="/static/assets/js/jquery.js"></script>
    <title>쿠폰설정</title>
    <script type="text/javascript">
      function updateCouponConfig(groupSeq) {
        let useGiftYn = $('#useGiftYn').val();
        let useRuseYn = $('#useRuseYn').val();

        useGiftYn = $('#useGiftYn:checked').length > 0 ? "Y" : "N";
        useRuseYn = $('#useRuseYn:checked').length > 0 ? "Y" : "N";

        $.ajax({
          type: "POST",
          url: "/ajax/updateCouponConfig",
          data: {
            "groupSeq": groupSeq,
            "merchantName": $('#merchantName').val(),
            "mainCompCnt": $('#mainCompCnt').val(),
            "mainCompAmt": $('#mainCompAmt').val(),
            "termCnt": $('#termCnt').val(),
            "termAmt": $('#termAmt').val(),
            "useDay": $('#useDay').val(),
            "sendCnt": $('#sendCnt').val(),
            "usableCount": $('#usableCount').val() > 9999 ? 9999 : $('#usableCount').val(),
            "fixAmount": $('#fixAmount').val(),
            "useGiftYn": useGiftYn,
            "useRuseYn": useRuseYn
          },
          dataType: "json",
          cache: false,
          success: function (cmd) {
            if (cmd.code == '0000') {
              alert('수정이 완료되었습니다.')
              window.location.reload();
            }
          }, // success
          error: function (xhr, status) {
            alert(xhr + " : " + status);
            location.href("/");
          }
        });
      }
    </script>
</head>
<body>
<!-- Main Content -->
<div class="main-content">
    <div class="row">
        <div class="col-12 col-sm-10 offset-sm-1 col-md-8 offset-md-2 col-lg-8 offset-lg-2 col-xl-6 offset-xl-3">
            <div class="card card-primary">
                <div class="card-header"><h4>쿠폰설정</h4></div>
                <div class="card-body">
                    <form role="form" method="POST" name="formData" id="formData"
                          class="needs-validation" novalidate=""
                          action="/coupon/couponOK.do" onsubmit="loadingStart();">
                        <div class="row">
                            <div class="form-group col-lg-12 col-md-12 col-sm-12">
                                <label for="merchantName">쿠폰 표기 가맹점 명
                                    <i class="fas fa-question-circle title-i-line-height text-primary"
                                       data-toggle="tooltip" title=""
                                       data-original-title="쿠폰에 표기되는 가맹점 명입니다."></i>
                                </label>
                                <input id="merchantName" type="text" class="form-control"
                                       name="merchantName"
                                       value="${couponConfig.merchantName}" required=""
                                       autofocus="">
                                <div class="invalid-feedback">
                                    쿠폰에 표기될 가맹점명을 입력해주세요.
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="form-group col-lg-6 col-md-6 col-sm-12">
                                <label for="mainCompCnt">(한 달) 한도 건수
                                    <i class="fas fa-question-circle title-i-line-height text-primary"
                                       data-toggle="tooltip" title=""
                                       data-original-title="한 달 내 쿠폰을 발권할 수 있는 최대 건수 입니다. (0: 무제한)"></i>
                                </label>
                                <input id="mainCompCnt" type="number" class="form-control"
                                       name="mainCompCnt"
                                       min="100" max="999999" maxlength="6"
                                       value="${couponConfig.mainCompCnt}" required="" autofocus="">
                                <div class="invalid-feedback">
                                    ','(콤마) 를 제외한 숫자를 입력해주세요!
                                </div>
                            </div>
                            <div class="form-group col-lg-6 col-md-6 col-sm-12">
                                <label for="mainCompAmt">(한 달)한도 금액
                                    <i class="fas fa-question-circle title-i-line-height text-primary"
                                       data-toggle="tooltip" title=""
                                       data-original-title="한 달 내 쿠폰을 발권할 수 있는 최대 금액 입니다. (0: 무제한)"></i>
                                </label>
                                <input id="mainCompAmt" type="number" class="form-control"
                                       name="mainCompAmt"
                                       min="100" max="9999999" maxlength="6"
                                       value="${couponConfig.mainCompAmt}" required="" autofocus="">
                                <div class="invalid-feedback">
                                    ','(콤마) 를 제외한 숫자를 입력해주세요!
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="form-group col-lg-6 col-md-6 col-sm-12">
                                <label for="termCnt">(한 달)단말기 한도 건수
                                    <i class="fas fa-question-circle title-i-line-height text-primary"
                                       data-toggle="tooltip" title=""
                                       data-original-title="한 달 내 단말기에서 결제 가능한 최대 건수 입니다. (0: 무제한)"></i>
                                </label>
                                <input id="termCnt" type="number" class="form-control"
                                       name="termCnt"
                                       min="0" max="999999" maxlength="6"
                                       value="${couponConfig.termCnt}" required="" autofocus="">
                                <div class="invalid-feedback">
                                    ','(콤마) 를 제외한 숫자를 입력해주세요!
                                </div>
                            </div>
                            <div class="form-group col-lg-6 col-md-6 col-sm-12">
                                <label for="termAmt">(한 달)단말기 한도 금액
                                    <i class="fas fa-question-circle title-i-line-height text-primary"
                                       data-toggle="tooltip" title=""
                                       data-original-title="한 달 내 단말기에서 결제 가능한 최대 금액 입니다.(0: 무제한)"></i>
                                </label>
                                <input id="termAmt" type="number" class="form-control"
                                       name="termAmt"
                                       min="0" max="9999999" maxlength="6"
                                       value="${couponConfig.termAmt}" required="" autofocus="">
                                <div class="invalid-feedback">
                                    ','(콤마) 를 제외한 숫자를 입력해주세요!
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="form-group col-lg-6 col-md-6 col-sm-12">
                                <label for="useDay">유효기간
                                    <i class="fas fa-question-circle title-i-line-height text-primary"
                                       data-toggle="tooltip" title=""
                                       data-original-title="쿠폰을 사용할 수 있는 유효 기간입니다. 발권일 기준 + n 일 입니다."></i>
                                </label>
                                <input id="useDay" type="number" class="form-control" name="useDay"
                                       min="0" max="999" maxlength="3"
                                       value="${couponConfig.useDay}" required="" autofocus="">
                                <div class="invalid-feedback">
                                    ','(콤마) 를 제외한 숫자를 입력해주세요!
                                </div>
                            </div>
                            <div class="form-group col-lg-6 col-md-6 col-sm-12">
                                <label for="fixAmount">쿠폰 고정금액
                                    <i class="fas fa-question-circle title-i-line-height text-primary"
                                       data-toggle="tooltip" title=""
                                       data-original-title="고정금액을 설정할 경우, 다른 금액으로 발권이 불가"></i>
                                </label>
                                <input id="fixAmount" type="number" class="form-control"
                                       name="fixAmount"
                                       min="0" max="999" maxlength="3"
                                       value="${couponConfig.fixAmount}" required="" autofocus="">
                                <div class="invalid-feedback">
                                    ','(콤마) 를 제외한 숫자를 입력해주세요!
                                </div>
                            </div>
                        </div>
                        <%-- 추후 계정관리에서 사용가능한 옵션 처리 예정 --%>
                        <div class="row">
                            <div class="form-group col-lg-6 col-md-6 col-sm-12">
                                <label for="usableCount">다회권 고정 회수
                                    <i class="fas fa-question-circle title-i-line-height text-primary"
                                       data-toggle="tooltip" title=""
                                       data-original-title="다회권 고정 회수를 지정할 수 있습니다. 1~9999"></i>
                                </label>
                                <input id="usableCount" type="number" class="form-control"
                                       name="usableCount"
                                       min="1" max="9999" value="${couponConfig.usableCount}"
                                       required="" autofocus="">
                                <div class="invalid-feedback">
                                    ','(콤마) 를 제외한 숫자를 입력해주세요!
                                </div>
                            </div>
                            <div class="form-group col-lg-6 col-md-6 col-sm-12">
                                <label for="usableCouponType">쿠폰타입
                                    <i class="fas fa-question-circle title-i-line-height text-primary"
                                       data-toggle="tooltip" title=""
                                       data-original-title="활성화된 쿠폰입니다."></i>
                                </label>
                                <div class="selectgroup selectgroup-pills" id="usableCouponType">
                                    <c:if test="${groupSeq == '0' || couponConfig.useGiftYn eq 'Y'.charAt(0)}">
                                    <label class="selectgroup-item">
                                        <input type="checkbox" name="useGiftYn" id="useGiftYn"
                                               class="selectgroup-input"
                                               <c:if test="${groupSeq != '0'}">onClick="return false;"</c:if>
                                               <c:if test="${couponConfig.useGiftYn eq 'Y'.charAt(0)}">checked</c:if>>
                                        <span class="selectgroup-button">1회권</span>
                                    </label>
                                    </c:if>
                                    <c:if test="${groupSeq == '0' || couponConfig.useRuseYn eq 'Y'.charAt(0)}">
                                    <label class="selectgroup-item">
                                        <input type="checkbox" name="useRuseYn"
                                               id="useRuseYn" class="selectgroup-input"
                                               <c:if test="${groupSeq != '0'}">onClick="return false;"</c:if>
                                               <c:if test="${couponConfig.useRuseYn eq 'Y'.charAt(0)}">checked</c:if>>
                                        <span class="selectgroup-button">다회권</span>
                                    </label>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                        <c:if test="${couponConfig.modDate != null}">
                            <div class="row">
                                <div class="form-group col-lg-6 col-md-6 col-sm-12">
                                    <label for="modDate">수정일자
                                    </label>
                                    <input id="modDate" type="text" class="form-control"
                                           name="modDate"
                                           value="${couponConfig.modDate}" required="" autofocus=""
                                           readonly>
                                </div>
                            </div>
                        </c:if>
                        <c:choose>
                            <c:when test="${groupSeq == '0'}">
                                <div class="row">
                                    <div class="form-group col-6">
                                        <button type="button"
                                                onclick="updateCouponConfig(${couponConfig.groupSeq});"
                                                class="btn btn-primary btn-lg btn-block">수정
                                        </button>
                                    </div>
                                    <div class="form-group col-6">
                                        <button type="button"
                                                onclick="location.href='/group/setting'"
                                                class="btn btn-secondary btn-lg btn-block">
                                            목록
                                        </button>
                                    </div>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="row">
                                    <div class="form-group col-12">
                                        <button type="button"
                                                onclick="updateCouponConfig(${groupSeq});"
                                                class="btn btn-primary btn-lg btn-block">수정
                                        </button>
                                    </div>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
