<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta charset="UTF-8">
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, shrink-to-fit=no"
          name="viewport">
    <script type="text/javascript" src="/assets/js/jquery.js"></script>
    <script type="text/javascript" src="/assets/js/dashboard.js"></script>
    <script type="text/javascript" src="/assets/js/custom.js"></script>
    <script type="text/javascript">
      /* 동적 실행 */
      $(function () {
        $('#${month}').addClass('active');
        if ($('.custom-switch-input:checked').length > 0) {
          $('#onceIssuance').hide();
          $('#multiIssuance').show();
        } else {
          $('#onceIssuance').show();
          $('#multiIssuance').hide();
        }

        let html = "";
        for (let i = 1; i <= 12; i++) {
          html += '<li><a href="dashboard?month=' + ('0' + i).slice(-2) + '" id="' + ('0'
              + i).slice(-2) + '" class="dropdown-item">';
          html += ('0' + i).slice(-2) + '월';
          html += '</a></li>';
          if (i == '${thisMonth}') {
            break;
          }
        }
        $('#monthUl').html(html);

        $('#usableCount').text() < 1 ? $('#publishBtn').hide() : $('#publishBtn').show();


      });

      function issuanceTypeToggle() {
        if ($('.custom-switch-input:checked').length > 0) {
          $('#onceIssuance').hide();
          $('#multiIssuance').show();
        } else {
          $('#onceIssuance').show();
          $('#multiIssuance').hide();
        }
      }

      async function insertGroup() {
        const {value: groupName} = await Swal.fire({
          title: '그룹명을 입력하세요.',
          input: 'text',
          inputLabel: '그룹명: 쿠폰 또는 포인트 사용 시 표기될 상호명',
          inputPlaceholder: '`사업자등록증`의 `상호` 또는 `법인(단체)`명',
          inputAttributes: {
            maxlength: 25,
            autocapitalize: 'off',
            autocorrect: 'off'
          }
        });
        if (groupName.length < 2) {
          alert('상호명은 최소 2글자 이상 입력해주세요.');
          return false;
        }

        $.ajax({
          type: "POST",
          url: "/ajax/insertGroup",
          data: {
            "groupName": groupName,
          },
          dataType: "json",
          cache: false,
          success: function (cmd) {
            if (cmd.code == '0000') {
              alert('등록이 완료되었습니다.');
              window.location.reload();
            }
          }, // success
          error: function () {
            alert('등록이 취소되었습니다.\n' +
                '동일한 그룹명이 존재할 수 있습니다.');
            location.href("/");
          }
        });
      }

      function showFileName() {

      }

      function sampleDownload(v){
        let form = document.createElement('form');
        form.setAttribute('method', 'POST');
        form.setAttribute('action', '/coupon/excelDownload');
        form.setAttribute('charset', 'UTF-8');

        let hiddenField = document.createElement('input');
        hiddenField.setAttribute('type', 'hidden');
        hiddenField.setAttribute('name', 'serviceType');
        hiddenField.setAttribute('value', v);
        form.appendChild(hiddenField);

        let hiddenField2 = document.createElement('input');
        hiddenField2.setAttribute('type', 'hidden');
        hiddenField2.setAttribute('name', 'useRuseYn');
        hiddenField2.setAttribute('value', "${couponConfig.useRuseYn}");
        form.appendChild(hiddenField2);

        document.body.appendChild(form);
        form.submit();
      }

    </script>
<body onload="init();">
<div class="main-content">
    <%-- 매출그래프 데이터 --%>
    <c:forEach var="salesSummaryList" items="${salesSummaryList}">
        <input type="hidden" class="salesSummaryList"
               data-title="${salesSummaryList.week}"
               data-cnt="${salesSummaryList.salesCnt}"
               data-amt="${salesSummaryList.salesAmt}"/>
    </c:forEach>
    <section class="section">
        <div class="row">
            <div class="col-lg-5 col-md-12 col-12 col-sm-12">
                <div class="card card-statistic-2">
                    <div class="card-stats">
                        <div class="card-stats-title">누적 쿠폰현황
                            <div class="dropdown d-inline">
                                ${fn:substring(yyyyMM, 0, 4)}.
                                <a class="font-weight-600 dropdown-toggle" data-toggle="dropdown"
                                   href="#"
                                   id="orders-month" aria-expanded="false">${month}</a>월
                                <ul class="dropdown-menu dropdown-menu-sm"
                                    x-placement="bottom-start"
                                    style="position: absolute; transform: translate3d(0px, 18px, 0px); top: 0px; left: 0px; will-change: transform;"
                                    id="monthUl">
                                    <li class="dropdown-title">월 선택</li>
                                    <%--<li><a href="dashboard?month=01" id="01" class="dropdown-item">01월</a>
                                    </li>
                                    <li><a href="dashboard?month=02" id="02" class="dropdown-item">02월</a>
                                    </li>
                                    <li><a href="dashboard?month=03" id="03" class="dropdown-item">03월</a>
                                    </li>
                                    <li><a href="dashboard?month=04" id="04" class="dropdown-item">04월</a>
                                    </li>
                                    <li><a href="dashboard?month=05" id="05" class="dropdown-item">05월</a>
                                    </li>
                                    <li><a href="dashboard?month=06" id="06" class="dropdown-item">06월</a>
                                    </li>
                                    <li><a href="dashboard?month=07" id="07" class="dropdown-item">07월</a>
                                    </li>
                                    <li><a href="dashboard?month=08" id="08" class="dropdown-item">08월</a>
                                    </li>
                                    <li><a href="dashboard?month=09" id="09" class="dropdown-item">09월</a>
                                    </li>
                                    <li><a href="dashboard?month=10" id="10" class="dropdown-item">10월</a>
                                    </li>
                                    <li><a href="dashboard?month=11" id="11" class="dropdown-item">11월</a>
                                    </li>
                                    <li><a href="dashboard?month=12" id="12" class="dropdown-item">12월</a>
                                    </li>--%>
                                </ul>
                            </div>
                        </div>
                        <div class="card-stats-items">
                            <c:forEach var="usageCoupon" items="${usageCoupon}">
                                <c:set var="couponTotal"
                                       value="${couponTotal + (usageCoupon.sumCount)}"/>
                                <div class="card-stats-item">
                                    <div class="card-stats-item-count">
                                        <fmt:formatNumber value="${usageCoupon.sumCount}"
                                                          pattern="#,###"/>
                                    </div>
                                    <div class="card-stats-item-label">${usageCoupon.sumType}</div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                    <div class="card-icon shadow-primary bg-primary">
                        <i class="fas fa-archive"></i>
                    </div>
                    <div class="card-wrap">
                        <div class="card-header">
                            <h4>이번달 누적 발권 건수</h4>
                        </div>
                        <div class="card-body">
                            <fmt:formatNumber value="${couponTotal}" pattern="#,###"/>
                        </div>
                    </div>
                </div>
                <c:if test="${role == 'system'}">
                    <div class="wizard-steps">
                        <div class="wizard-step wizard-step-active" onclick="insertGroup()">
                            <div class="wizard-step-icon">
                                <i class="fas fa-server"></i>
                            </div>
                            <div class="wizard-step-label">
                                그룹등록
                            </div>
                        </div>
                        <div class="wizard-step wizard-step-active"
                             onclick="location.href='${root}/group/userRegist'">
                            <div class="wizard-step-icon">
                                <i class="far fa-user"></i>
                            </div>
                            <div class="wizard-step-label">
                                계정등록
                            </div>
                        </div>
                    </div>
                </c:if>
                <c:if test="${role == 'system' || useCouponPublish eq 'Y'.charAt(0)}">
                <form role="form" method="POST" name="formData" id="formData"
                      action="/ajax/couponExcelIssuance"
                      enctype="multipart/form-data" class="needs-validation" novalidate="">
                    <div class="card mb-3">
                        <div class="card-header">
                            <h4>쿠폰발권하기
                                <i class="fas fa-question-circle title-i-line-height text-primary"
                                   data-toggle="tooltip" title=""
                                   data-original-title="VMMS '${companyName}' 소속에 등록된 단말기에서만 사용 가능합니다."></i>
                            </h4>
                            <div>잔여 발권 회수:
                                <span class="text-danger" id="usableCount"><fmt:formatNumber
                                        value="${couponConfig.mainCompCnt-couponConfig.usedCount}"
                                        pattern="#,###"/></span> /
                                <span id="mainCompCnt"><fmt:formatNumber
                                        value="${couponConfig.mainCompCnt}"
                                        pattern="#,###"/>
                            </span>
                            </div>
                        </div>
                        <div>
                            <div class="card-body row">
                                <div class="form-group col-lg-4 col-md-4 col-sm-12 mb-0">
                                    <label for="paramGroupSeq">그룹</label>
                                    <select id="paramGroupSeq"
                                            name="paramGroupSeq"
                                            onchange="callGroupInfo('${userSeq}')"
                                            class="form-control select2 select2-hidden-accessible"
                                            tabindex="-1" aria-hidden="true">
                                        <c:if test="${role =='system'}">
                                            <c:forEach var="getGroupList"
                                                       items="${getGroupList}">
                                                <option value="${getGroupList.groupSeq}"
                                                        <c:if test="${hmap.paramGroupSeq != null ?
                                                                getGroupList.groupSeq==hmap.paramGroupSeq : getGroupList.groupSeq==0}">selected</c:if>>
                                                        ${getGroupList.groupName}
                                                </option>
                                            </c:forEach>
                                        </c:if>
                                        <c:if test="${role !='system'}">
                                            <option value="${groupSeq}"
                                                    selected>${groupName}</option>
                                        </c:if>
                                    </select>
                                </div>
                                <div class="form-group col-lg-4 col-md-4 col-sm-12 mb-0">
                                    <label for="paramUserSeq">계정</label>
                                    <select id="paramUserSeq"
                                            name="paramUserSeq"
                                            class="form-control select2 select2-hidden-accessible"
                                            tabindex="-1" aria-hidden="true">
                                        <option value="${userSeq}">${userName}</option>
                                    </select>
                                </div>
                                <div class="form-group col-lg-4 col-md-4 col-sm-12 mb-0">
                                    <label for="couponType">쿠폰타입</label>
                                    <select id="couponType" name="couponType"
                                            class="form-control select2 select2-hidden-accessible"
                                            tabindex="-1"
                                            aria-hidden="true">>
                                        <c:if test="${couponConfig.useGiftYn eq 'Y'.charAt(0)}">
                                            <option value="GIFT">1회권</option>
                                        </c:if>
                                        <%-- 추후 계정관리에서 사용가능한 옵션 처리 예정 --%>
                                        <c:if test="${couponConfig.useRuseYn eq 'Y'.charAt(0)}">
                                            <option value="RUSE">다회권(${couponConfig.usableCount}회권)
                                            </option>
                                        </c:if>
                                        <%--<option value="DISG">할인금액권</option>
                                        <option value="DISP">할인율권</option>--%>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <input type="hidden" id="userName" name="userName" value="${userName}"/>
                        <input type="hidden" id="userId" name="userId" value="${userId}"/>
                        <input type="hidden" id="userSeq" name="userSeq" value="${userSeq}"/>
                        <input type="hidden" id="groupSeq" name="groupSeq" value="${groupSeq}"/>
                        <div class="card-body pt-0 pb-0 row">
                            <div class="form-group col-lg-12 col-md-12 col-sm-12 mb-1">
                                <label for="issuanceType" class="mb-0 va-m">발권 유형 선택
                                    <i class="fas fa-question-circle title-i-line-height text-primary"
                                       data-toggle="tooltip" title=""
                                       data-original-title="개별발송 / 단체발송 중 하나를 선택하세요."></i>
                                </label>
                                <label class="custom-switch va-m">
                                    <input type="checkbox" name="custom-switch-checkbox"
                                           id="issuanceType" class="custom-switch-input"
                                           onchange="issuanceTypeToggle();">
                                    <span class="custom-switch-indicator"></span>
                                    <span class="custom-switch-description">일괄 발권은 체크하세요.</span>
                                </label>
                            </div>
                        </div>
                        <%-- 개별발권 --%>
                        <div class="card-body pt-0 pb-0 row" id="onceIssuance">
                            <div class="form-group col-lg-6 col-md-6 col-sm-12">
                                <label for="couponAmt">금액
                                    <i class="fas fa-question-circle title-i-line-height text-primary"
                                       data-toggle="tooltip" title=""
                                       data-original-title="', (콤마)' 를 제외한 금액을 입력해주세요!"></i>
                                </label>
                                <input id="couponAmt" type="text" class="form-control"
                                       name="couponAmt"
                                       min="0" max="999999" maxlength="6" required="" autofocus=""
                                <c:if test="${groupSeq != 0 && couponConfig.fixAmount !=0}">
                                       value="${couponConfig.fixAmount}" readonly
                                </c:if>
                                >
                                <div class="invalid-feedback">
                                    ', (콤마)' 를 제외한 숫자를 입력해주세요!(최소 100원)
                                </div>
                            </div>
                            <div class="form-group col-lg-6 col-md-6 col-sm-12">
                                <label for="revMobile">알림톡 수신 연락처
                                    <i class="fas fa-question-circle title-i-line-height text-primary"
                                       data-toggle="tooltip" title="" data-original-title="
                                       '-' 하이픈을 포함한 13자리를 입력해주세요! 해당 연락처로 카카오 알림톡이 전송됩니다."
                                    ></i>
                                </label>
                                <input id="revMobile" type="text" class="form-control"
                                       name="revMobile" minlength="11"
                                       maxlength="13" placeholder="010-0000-0000" required=""
                                       autofocus=""
                                       onkeyup="addHyphenPhoneNo(this)">
                                <div class="invalid-feedback">
                                    올바른 휴대폰 번호를 11자리를 입력해주세요! ex)010-0000-0000
                                </div>
                            </div>
                        </div>
                        <%-- 다수 발권 --%>
                        <div class="card-body pt-0 pb-0 row" id="multiIssuance">
                            <div class="form-group col-lg-12 col-md-12 col-sm-12 mb-1">
                                <div class="mb-1">
                                <label for="couponIssuanceByExcel">엑셀 업로드</label>
                                <i class="fas fa-question-circle title-i-line-height text-primary"
                                   data-toggle="tooltip" title="" data-original-title="
                                       기존에 설정된 서식에 맞추어 입력하여야만 정상 발송됩니다."></i>
                                </label>
                                <button class="btn btn-primary" onclick="sampleDownload('sample');">
                                    <i class="fas fa-file-download lh-0"></i> 양식 다운로드</button>
                                </div>
                                <div class="input-group">
                                    <div class="input-group-prepend">
                                        <div class="input-group-text">
                                            <i class="fas fa-file-upload"></i>
                                        </div>
                                    </div>
                                    <div class="custom-file">
                                        <input type="file" name="couponIssuanceByExcel"
                                               class="custom-file-input" id="couponIssuanceByExcel"
                                               onchange="$('#fileName').text(this.value.replace(/C:\\fakepath\\/, ''));"/>
                                        <label class="custom-file-label" id="fileName">파일
                                            첨부하기</label>
                                    </div>
                                </div>
                                <div class="form-text text-muted">업로드 가능한 최대 용량은 10MB 입니다.</div>
                            </div>
                        </div>

                        <div class="card-footer pt-0" id="publishBtn">
                            <a href="#" class="btn btn-primary w-100"
                               onclick="couponPublish();">발권하기</a>
                        </div>
                    </div>
                </form>
                </c:if>
            </div>
            <c:if test="${role == 'system' || useCouponIssuanceHistory eq 'Y'.charAt(0)}">
            <div class="col-lg-7 col-md-12 col-12 col-sm-12">
                <div class="card">
                    <div class="card-header">
                        <h4>최근 쿠폰 발권목록 TOP 7(이번 달)</h4>
                        <div class="card-header-action">
                            <a href="coupon/issuance" class="btn btn-primary">발권내역 전체보기</a>
                        </div>
                    </div>
                    <div class="card-body card-body ps-2 pe-2 pt-2 pb-2">
                        <div class="table-responsive">
                            <table class="table table-striped mb-0">
                                <thead>
                                <tr>
                                    <th>발권정보</th>
                                    <th>쿠폰번호</th>
                                    <th>쿠폰상태</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:if test="${recentCouponTop7.size() > 0}"><c:forEach
                                        var="recentCouponTop7" items="${recentCouponTop7}">
                                    <tr>
                                        <td>
                                            <div>
                                                <div class="bullet"></div>
                                                그룹: <a href="#">${recentCouponTop7.groupName}</a>
                                            </div>
                                            <div>
                                                <div class="bullet"></div>
                                                연락처: <a
                                                    href="tel:">${recentCouponTop7.revMobile}</a>
                                            </div>
                                            <div>
                                                <div class="bullet"></div>
                                                쿠폰유형: <a href="#">${recentCouponTop7.couponType}</a>
                                                <div class="bullet"></div>
                                                발권금액: <a href="#"><fmt:formatNumber
                                                    value="${recentCouponTop7.couponAmt}"
                                                    pattern="#,###"/> 원</a></div>
                                        </td>
                                        <td><a href="/cp?cpn=${recentCouponTop7.couponNo}"
                                               class="btn btn-primary"><i
                                                class="fa fa-qrcode"></i> ${recentCouponTop7.couponNo}
                                        </a></td>
                                        <td><select class="form-control" id="dCouponStat"
                                                    onchange="updateCouponStat(${recentCouponTop7.couponNo},  $(this).find('option:selected').val())">
                                            <option value="N"
                                                    <c:if test="${recentCouponTop7.couponStat eq 'N'}">selected="selected"</c:if>>
                                                미사용
                                            </option>
                                            <option value="L"
                                                    <c:if test="${recentCouponTop7.couponStat eq 'L'}">selected="selected"</c:if>>
                                                잠금
                                            </option>
                                            <option value="D"
                                                    <c:if test="${recentCouponTop7.couponStat eq 'D'}">selected="selected"</c:if>>
                                                기간만료
                                            </option>
                                            <option value="U"
                                                    <c:if test="${recentCouponTop7.couponStat eq 'U'}">selected="selected"</c:if>>
                                                사용완료
                                            </option>
                                            <option value="H"
                                                    <c:if test="${couponIssuance.couponStat eq 'H'}">selected="selected"</c:if>>
                                                삭제
                                            </option>
                                        </select></td>
                                    </tr>
                                </c:forEach></c:if>
                                <c:if test="${recentCouponTop7.size() == 0}">
                                    <tr>
                                        <td>이번 달에 발권하신 쿠폰 내역이 없습니다.</td>
                                    </tr>
                                </c:if>
                                </tbody>
                            </table>
                        </div>
                        <div class="text-center pt-2 pb-2">
                            <a href="coupon/issuance" class="btn btn-primary btn-lg btn-round">
                                발권내역 전체보기
                            </a>
                        </div>
                    </div>
                </div>
            </div>
            </c:if>
        </div>
    </section>
</div>
<script type="text/javascript" src="/assets/js/dashboard.js"></script>
</body>
</html>
