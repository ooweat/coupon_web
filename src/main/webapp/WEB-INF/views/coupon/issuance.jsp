<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta charset="UTF-8">
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, shrink-to-fit=no"
          name="viewport">
    <script type="text/javascript" src="/assets/js/jquery.js"></script>
    <script type="text/javascript" src="/assets/js/custom.js"></script>
    <script type="text/javascript" src="/assets/js/dashboard.js"></script>
    <script type="text/javascript" src="/assets/js/coupon_web-datepicker.js"></script>
</head>
<script type="text/javascript">
  $(function () {
    loadingStop();
  })
</script>
<body>
<!-- Main Content -->
<div class="main-content">
    <section class="section">
        <div class="section-body">
            <div class="row">
                <div class="col-12 col-md-12">
                    <div class="card card-primary custom-card">
                        <div class="card-body">
                            <div class="form-divider text-primary">
                                쿠폰 발권내역
                                <i class="fas fa-question-circle title-i-line-height text-primary"
                                   data-toggle="tooltip" title="" data-original-title=
                                           "${userName}에서 발권한 쿠폰내역을 볼 수 있어요"></i>
                            </div>
                            <form method="POST" action="#" id="formData" name="formData">
                                <input type="hidden" name="serviceType" id="serviceType"
                                       value="issuance"/>
                                <input type="hidden" name="page" id="page" value=""/>
                                <div class="row">
                                    <div class="col-md-11 mb-1">
                                        <div class="container-fluid border">
                                            <div class="row border-bottom">
                                                <div class="col-lg-2 col-sm-2 col-md-2 bg-light p-2">
                                                    그룹명
                                                    <i class="fas fa-question-circle title-i-line-height text-primary"
                                                       data-toggle="tooltip" title=""
                                                       data-original-title=
                                                               "계정에 등록된 가맹점을 의미해요!"></i>
                                                </div>
                                                <div class="col-lg-6 col-sm-6 col-md-6 py-2 m-auto-0">
                                                    <div class="">
                                                        <select id="paramGroupSeq"
                                                                name="paramGroupSeq"
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
                                                </div>
                                            </div>
                                            <div class="row border-bottom">
                                                <div class="col-lg-2 col-sm-2 col-md-2 bg-light p-2">
                                                    상세검색
                                                    <i class="fas fa-question-circle title-i-line-height text-primary"
                                                       data-toggle="tooltip" title=""
                                                       data-original-title=
                                                               "추가정보를 조회할 수 있어요!"></i>
                                                </div>
                                                <div class="row col-lg-7 col-sm-7 col-md-7 py-2 m-auto-0">
                                                    <div class="col-lg-4 col-md-4 col-sm-4 ps-0">
                                                        <select id="searchType" name="searchType"
                                                                onchange="_searchTypeValid()"
                                                                class="form-control select2 select2-hidden-accessible"
                                                                tabindex="-1" aria-hidden="true">>
                                                            <option value=""
                                                                    <c:if test="${hmap.searchType == ''}">selected</c:if>>
                                                                -선택-
                                                            </option>
                                                            <option value="TCB.COUPON_NO"
                                                                    <c:if test="${hmap.searchType == 'TCB.COUPON_NO'}">selected</c:if>>
                                                                쿠폰번호
                                                            </option>
                                                            <option value="TCB.REV_MOBILE"
                                                                    <c:if test="${hmap.searchType == 'TCB.REV_MOBILE'}">selected</c:if>>
                                                                연락처
                                                            </option>
                                                        </select>
                                                    </div>
                                                    <div class="col-lg-7 col-md-7 col-sm-7 ps-0">
                                                        <input type="text" name="searchValue"
                                                               class="form-control"
                                                               onkeyup="_searchValid(this)"
                                                               value="${hmap.searchValue}"
                                                               id="searchValue"
                                                               placeholder="내용(연락처는 '-' 포함하여 검색)">
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="row border-bottom">
                                                <div class="col-lg-2 col-sm-2 col-md-2 bg-light ps-2 py-2">
                                                    쿠폰상태
                                                </div>
                                                <div class="row col-lg-7 col-sm-7 col-md-7 py-2 m-auto-0">
                                                    <div class="col-lg-12 col-md-12 col-sm-12 ps-0 row ml-1">
                                                        <input type="hidden" name="searchOption"
                                                               id="searchOption"
                                                               value="TCB.COUPON_STAT"/>
                                                        <input type="hidden"
                                                               name="searchOptionValue"
                                                               id="searchOptionValue" value=""/>
                                                        <div class="custom-control custom-checkbox mr-1">
                                                            <input type="checkbox"
                                                                   data-checkboxes="couponStat"
                                                                   data-checkbox-role="dad"
                                                                   class="custom-control-input"
                                                                   id="checkbox-all"
                                                            <c:if test="${fn:contains(hmap.searchOptionValue, '0')
                                                            || hmap.searchOptionValue == null}">
                                                                   checked=""</c:if> value="0">
                                                            <label class="custom-control-label"
                                                                   for="checkbox-all">전체</label>
                                                        </div>
                                                        <div class="custom-control custom-checkbox mr-1">
                                                            <input type="checkbox"
                                                                   data-checkboxes="couponStat"
                                                                   class="custom-control-input"
                                                                   id="sCouponStat1"
                                                            <c:if test="${fn:contains(hmap.searchOptionValue, 'N')
                                                            || hmap.searchOptionValue == null}">
                                                                   checked=""</c:if> value="N">
                                                            <label class="custom-control-label"
                                                                   for="sCouponStat1">미사용</label>
                                                        </div>
                                                        <div class="custom-control custom-checkbox mr-1">
                                                            <input type="checkbox"
                                                                   data-checkboxes="couponStat"
                                                                   class="custom-control-input"
                                                                   id="sCouponStat2"
                                                            <c:if test="${fn:contains(hmap.searchOptionValue, 'L')
                                                            || hmap.searchOptionValue == null}">
                                                                   checked=""</c:if> value="L">
                                                            <label class="custom-control-label"
                                                                   for="sCouponStat2">잠금</label>
                                                        </div>
                                                        <div class="custom-control custom-checkbox mr-1">
                                                            <input type="checkbox"
                                                                   data-checkboxes="couponStat"
                                                                   class="custom-control-input"
                                                                   id="sCouponStat3"
                                                            <c:if test="${fn:contains(hmap.searchOptionValue, 'D')
                                                            || hmap.searchOptionValue == null}">
                                                                   checked=""</c:if> value="D">
                                                            <label class="custom-control-label"
                                                                   for="sCouponStat3">기간만료</label>
                                                        </div>
                                                        <div class="custom-control custom-checkbox mr-1">
                                                            <input type="checkbox"
                                                                   data-checkboxes="couponStat"
                                                                   class="custom-control-input"
                                                                   id="sCouponStat4"
                                                            <c:if test="${fn:contains(hmap.searchOptionValue, 'U')
                                                            || hmap.searchOptionValue == null}">
                                                                   checked=""</c:if> value="U">
                                                            <label class="custom-control-label"
                                                                   for="sCouponStat4">사용완료</label>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="row border-bottom"
                                                 style="border-bottom: 0px solid !important;">
                                                <div class="col-lg-2 col-md-2 bg-light p-2">기간검색
                                                </div>
                                                <div class="col-lg-10 col-sm-10 col-md-10 py-2 m-auto-0">
                                                    <div class="input-group daterange-btn form-inline col-lg-4 col-sm-6 col-md-6">
                                                        <input type="text" name="sDate"
                                                               maxlength="8"
                                                               class="form-control daterange-sdate"
                                                               value="${hmap.sDate}" id="sDate"
                                                               placeholder="시작일자">
                                                        <div class="date-hypen"> ~</div>
                                                        <input type="text" name="eDate"
                                                               maxlength="8"
                                                               class="form-control daterange-edate"
                                                               value="${hmap.eDate}" id="eDate"
                                                               placeholder="종료일자">
                                                    </div>
                                                </div>
                                            </div>
                                            <c:forEach var="summaryList" items="${summaryList}">
                                                <div class="form-row">
                                                    <div class="col-lg-6 col-sm-5 col-md-6 form-inline">
                                        <span
                                                <c:if test="${summaryList.sumType=='발권'}">class="text-warning"</c:if>
                                                <c:if test="${summaryList.sumType=='사용'}">class="text-primary"</c:if>
                                                <c:if test="${summaryList.sumType=='잠금/만료'}">class="text-danger"</c:if>
                                        >
                                            · 총 누적 <strong>'${summaryList.sumType}'</strong> 건수/금액 :</span>
                                                        <fmt:formatNumber
                                                                value="${summaryList.sumCount}"
                                                                pattern="#,###"/>건 /
                                                        <fmt:formatNumber
                                                                value="${summaryList.sumAmount}"
                                                                pattern="#,###"/>원

                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </div>
                                    <div class="col-md-1 mb-1 p-0">
                                        <div class="col-lg-12 col-md-12 text-center p-0 w-100 h-100">
                                            <button type="button" onclick="validationCheck(1)"
                                                    class="badge badge-pill badge-primary btn-lg w-100 h-100">
                                                조회하기
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                    <div class="card">
                        <div class="p-2 pb-1 mt-0 ml-2 mr-2">
                            <div class="float-left">
                                <h6 class="pt-0">조회결과 <span
                                        class="text-muted">( <fmt:formatNumber
                                        value="${searchCount}"
                                        pattern="#,###"/> 건 )</span>
                                </h6>
                            </div>
                            <div class="float-right">
                                <button class="btn btn-primary"
                                        onclick="excelDownload('issuance');">
                                    <i class="fas fa-file-download lh-0"></i> 엑셀 다운로드
                                </button>
                            </div>
                        </div>
                        <div class="card-body pt-0">
                            <div class="table-responsive">
                                <table class="table table-striped table-md fancy-table">
                                    <thead>
                                    <tr>
                                        <th class="text-center">그룹명</th>
                                        <th class="text-center">연락처</th>
                                        <th class="text-center">발권금액</th>
                                        <th class="text-center">쿠폰타입</th>
                                        <th class="text-center">쿠폰번호</th>
                                        <th class="text-center">사용가능기간</th>
                                        <th class="text-center">쿠폰상태</th>
                                        <th class="text-center">발송횟수</th>
                                        <th class="text-center">재발송</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach var="couponIssuance" items="${searchList}">
                                        <tr>
                                            <td class="text-center"
                                                onclick="location.href='/group/clientInfo?paramGroupSeq=${couponIssuance.groupSeq}'">
                                                <span title="${couponIssuance.groupName}"
                                                      class="tof-e width-150 height-30 btn btn-primary">${couponIssuance.groupName}</span>
                                            </td>
                                            <td class="font-weight-bold text-center">${couponIssuance.revMobile}</td>
                                            <td class="text-center"><fmt:formatNumber
                                                    value="${couponIssuance.couponAmt}"
                                                    pattern="#,###"/>
                                                원
                                            </td>
                                            <td class="text-center">${couponIssuance.couponType}</td>
                                            <td class="text-center"><a
                                                    href="/cp?cpn=${couponIssuance.couponNo}"
                                                    class="badge badge-pill badge-primary"
                                                    target="_blank">${couponIssuance.couponNo}</a>
                                            </td>
                                            <td class="text-center">${couponIssuance.regDate}
                                                ~ ${couponIssuance.expireDay}</td>
                                            <td>
                                                <select class="form-control"
                                                        tabindex="-1" aria-hidden="true"
                                                        id="dCouponStat"
                                                        onchange="
                                                                updateCouponStat(${couponIssuance.couponNo},  $(this).find('option:selected').val(), this)">
                                                    <option value="N"
                                                            <c:if test="${couponIssuance.couponStat eq 'N'}">selected="selected"</c:if>>
                                                        미사용
                                                    </option>
                                                    <option value="L"
                                                            <c:if test="${couponIssuance.couponStat eq 'L'}">selected="selected"</c:if>>
                                                        잠금
                                                    </option>
                                                    <option value="D"
                                                            <c:if test="${couponIssuance.couponStat eq 'D'}">selected="selected"</c:if>>
                                                        기간만료
                                                    </option>
                                                    <option value="U"
                                                            <c:if test="${couponIssuance.couponStat eq 'U'}">selected="selected"</c:if>>
                                                        사용완료
                                                    </option>
                                                    <option value="H"
                                                            <c:if test="${couponIssuance.couponStat eq 'H'}">selected="selected"</c:if>>
                                                        삭제
                                                    </option>
                                                </select>
                                            </td>
                                            <td class="text-center text-primary">${couponIssuance.sendCnt}번</td>
                                            <td class="text-center"><a href="#"
                                                                       class="btn btn-primary"
                                                                       onclick="couponReSend('${couponIssuance.couponNo}', '${couponIssuance.revMobile}');">재발송</a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        <div class="card-footer text-center border-top">
                            <nav class="d-inline-block">
                                <ul class="pagination  justify-content-center">
                                    <li class="page-item"><a href="#" class="page-link"
                                                             onclick="validationCheck('1')">처음</a>
                                    </li>
                                    <c:if test="${pageInfo.startPage>1}">
                                        <li class="page-item"><a href="#" class="page-link"
                                                                 onclick="validationCheck('${pageInfo.startPage -1}')"><i
                                                class="custom-fas fas fa-chevron-left"></i></a></li>
                                    </c:if>
                                    <c:forEach var="i" begin="${pageInfo.startPage}"
                                               end="${pageInfo.endPage}">
                                        <li class="page-item <c:if test='${pageInfo.pageNum == i}'>active</c:if>">
                                            <a href="#" class="page-link"
                                               onclick="validationCheck('${i}')">${i}</a>
                                        </li>
                                    </c:forEach>
                                    <c:if test="${(pageInfo.endPage - pageInfo.startPage) > 8}">
                                        <li class="page-item"><a href="#" class="page-link"
                                                                 onclick="validationCheck('${pageInfo.endPage +1}')"><i
                                                class="custom-fas fas fa-chevron-right"></i></a>
                                        </li>
                                    </c:if>
                                    <li class="page-item"><a href="#" class="page-link"
                                                             onclick="validationCheck('${pageInfo.page.getPages()}')">마지막</a>
                                    </li>
                                </ul>
                            </nav>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
</div>
</body>
</html>
