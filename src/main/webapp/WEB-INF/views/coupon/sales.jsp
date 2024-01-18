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
    <script type="text/javascript" src="/assets/js/custom.js"></script>
    <script type="text/javascript" src="/assets/js/coupon_web-datepicker.js"></script>
</head>
<script type="text/javascript">
  $(function () {
    loadingStop();
  })

  function onLoading(page){
    console.log("start");
    $('.loading_layer').show();
    console.log("showing");
    validationCheck(page);
  }
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
                                쿠폰 사용내역
                                <i class="fas fa-question-circle title-i-line-height text-primary"
                                   data-toggle="tooltip" title="" data-original-title=
                                           "${userName}에서 발권한 쿠폰의 사용내역을 볼 수 있어요"></i>
                            </div>
                            <form method="POST" action="#" id="formData" name="formData">
                                <input type="hidden" name="serviceType" id="serviceType" value="sales"/>
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
                                                                tabindex="-1" aria-hidden="true">>
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
                                                            <option value="TCS.TERMINAL_ID"
                                                                    <c:if test="${hmap.searchType == 'TCS.TERMINAL_ID'}">selected</c:if>>
                                                                단말기번호
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
                                            <div class="row border-bottom"
                                                 style="border-bottom: 0px solid !important;">
                                                <div class="col-lg-2 col-md-2 bg-light p-2">기간검색</div>
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
                                            <button type="button" onclick="validationCheck()"
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
                                        class="text-muted">( <fmt:formatNumber value="${searchCount}"
                                                                               pattern="#,###"/> 건 )</span>
                                </h6>
                            </div>
                            <div class="float-right">
                                <button class="btn btn-primary" onclick="excelDownload('sales');">
                                    <i class="fas fa-file-download lh-0"></i> 엑셀 다운로드</button>
                            </div>
                        </div>
                        <div class="card-body pt-0">
                            <div class="table-responsive">
                                <table class="table table-striped table-md fancy-table">
                                    <thead>
                                    <tr>
                                        <th class="text-center">그룹명</th>
                                        <c:if test="${role =='system'}">
                                        <th class="text-center">발권된 연락처</th>
                                        </c:if>
                                        <th class="text-center">쿠폰번호</th>
                                        <th class="text-center">TID</th>
                                        <th class="text-center" data-toggle="tooltip" title="" data-original-title=
                                                "TYPE: 쿠폰종류, BF: 사용 전 잔액, AMT: 사용 금액, AF: 사용 후 잔액">
                                            TYPE / (쿠폰금액-사용금액=잔액)
                                        </th>
                                        <th class="text-center">컬럼</th>
                                        <th class="text-center">거래결과</th>
                                        <th class="text-center">서버응답</th>
                                        <th class="text-center">승인일자</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach var="couponSales" items="${searchList}">
                                        <tr style="
                                        <c:choose>
                                        <c:when test="${couponSales.msgType=='승인'}">
                                                background-color: #f3ebff;
                                        </c:when>
                                        <c:when test="${couponSales.msgType=='조회'}">

                                        </c:when>
                                        <c:when test="${couponSales.msgType=='취소' || couponSales.msgType=='망취소'}">
                                                background-color: #ffcbcb;
                                        </c:when>
                                        </c:choose>
                                                ">
                                            <td onclick="location.href='/group/clientInfo?paramGroupSeq=${couponSales.groupSeq}'">
                                                <span title="${couponSales.groupName}"
                                                      class="tof-e width-150 height-30 btn btn-primary">${couponSales.groupName}</span>
                                            </td>
                                            <c:if test="${role =='system'}">
                                            <td class="font-weight-bold">${couponSales.revMobile}</td>
                                            </c:if>
                                            <td>
                                                <a href="/cp?cpn=${couponSales.couponNo}"
                                                   class="badge badge-pill badge-primary"
                                                   target="_blank">${couponSales.couponNo}</a>
                                            </td>
                                            <td>${couponSales.terminalId}</td>
                                            <td class="align-middle">
                                                <div class="media-progressbar">
                                                    <c:choose>
                                                        <c:when test="${couponSales.msgType=='승인' || couponSales.msgType=='잔액부족'}">
                                                            <div class="progress-text text-center">
                                                                    ${couponSales.couponType} / (
                                                                <fmt:formatNumber
                                                                        value="${couponSales.preAmt}"
                                                                        pattern="#,###"/>-<fmt:formatNumber
                                                                    value="${couponSales.tranAmt}"
                                                                    pattern="#,###"/>=<fmt:formatNumber
                                                                    value="${couponSales.aftAmt}"
                                                                    pattern="#,###"/> )
                                                            </div>
                                                            <c:if test="${couponSales.msgType=='승인'}">
                                                                <div class="progress m-auto"
                                                                     data-height="6"
                                                                     style="height: 6px; width: 80%;">
                                                                    <div class="progress-bar bg-success"
                                                                         data-width="100%"
                                                                         style="width: 100%;"></div>
                                                                </div>
                                                            </c:if>
                                                            <c:if test="${couponSales.msgType=='잔액부족'}">
                                                                <div class="progress m-auto"
                                                                     data-height="6"
                                                                     style="height: 6px; width: 80%;">
                                                                    <div class="progress-bar bg-danger"
                                                                         data-width="100%"
                                                                         style="width: 100%;"></div>
                                                                </div>
                                                            </c:if>

                                                        </c:when>
                                                        <c:when test="${couponSales.msgType=='조회'}">
                                                            <div class="progress-text text-center">
                                                                    쿠폰정보: ${couponSales.couponType} /
                                                                <fmt:formatNumber
                                                                        value="${couponSales.couponAmt}"
                                                                        pattern="#,###"/>원
                                                            </div>
                                                            <div class="progress m-auto" data-height="6"
                                                                 style="height: 6px; width: 80%;">
                                                                <div class="progress-bar bg-warning"
                                                                     data-width="50%"
                                                                     style="width: 50%;"></div>
                                                            </div>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div class="progress-text text-center">
                                                                    ${couponSales.couponType} / (
                                                                <fmt:formatNumber
                                                                        value="${couponSales.preAmt}"
                                                                        pattern="#,###"/>+<fmt:formatNumber
                                                                    value="${couponSales.tranAmt}"
                                                                    pattern="#,###"/>=<fmt:formatNumber
                                                                    value="${couponSales.aftAmt}"
                                                                    pattern="#,###"/> )
                                                            </div>
                                                            <div class="progress" data-height="6"
                                                                 style="height: 6px; width: 80%;">
                                                                <div class="progress-bar bg-danger"
                                                                     data-width="100%"
                                                                     style="width: 100%;"></div>
                                                            </div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </td>
                                            <td>${couponSales.colNo}</td>
                                            <td data-toggle="tooltip" title="" data-original-title=
                                                    "${couponSales.appNo}">
                                                <span class="badge badge-pill
                                            <c:choose>
                                                <c:when test="${couponSales.msgType=='조회'}">
                                                badge-warning
                                                </c:when>
                                                <c:when test="${couponSales.msgType=='승인'}">
                                                      badge-primary
                                                </c:when>
                                                <c:otherwise>
                                                    badge-danger
                                                </c:otherwise>
                                                </c:choose>
                                                "
                                                >${couponSales.msgType}</span>
                                            </td>
                                            <td>${couponSales.replyMsg}</td>
                                            <td class="font-weight-bold">${couponSales.regDate}</td>
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
                                                             onclick="onLoading('1')">처음</a>
                                    </li>
                                    <c:if test="${pageInfo.startPage>1}">
                                        <li class="page-item"><a href="#" class="page-link"
                                                                 onclick="onLoading('${pageInfo.startPage -1}')"><i
                                                class="custom-fas fas fa-chevron-left"></i></a></li>
                                    </c:if>
                                    <c:forEach var="i" begin="${pageInfo.startPage}"
                                               end="${pageInfo.endPage}">
                                        <li class="page-item <c:if test='${pageInfo.pageNum == i}'>active</c:if>">
                                            <a href="#" class="page-link"
                                               onclick="onLoading('${i}')">${i}</a>
                                        </li>
                                    </c:forEach>
                                    <c:if test="${(pageInfo.endPage - pageInfo.startPage) > 8}">
                                        <li class="page-item"><a href="#" class="page-link"
                                                                 onclick="onLoading('${pageInfo.endPage +1}')"><i
                                                class="custom-fas fas fa-chevron-right"></i></a>
                                        </li>
                                    </c:if>
                                    <li class="page-item"><a href="#" class="page-link"
                                                             onclick="onLoading('${pageInfo.page.getPages()}')">마지막</a>
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
