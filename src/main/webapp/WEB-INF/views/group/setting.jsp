<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta charset="UTF-8">
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, shrink-to-fit=no" name="viewport">
    <script type="text/javascript" src="/assets/js/jquery.js"></script>
    <title></title>
</head>
<script type="text/javascript">
  $(function () {
    loadingStop();
  });

  function validationCheck3(page) {
    loadingStart();

    $('#page').val(page);
    $('#formData').submit();
    loadingStop();
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
                            <div class="row form-divider text-primary">
                                그룹별 쿠폰 설정 관리
                            </div>
                            <form method="POST" action="#" id="formData" name="formData">
                                <input type="hidden" name="page" id="page" value=""/>
                                <div class="row">
                                    <div class="col-lg-8 col-xl-8 col-md-8 mb-1">
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
                                                                            <c:if test="${paramGroupSeq != null ?
                                                                getGroupList.groupSeq==paramGroupSeq : getGroupList.groupSeq==0}">selected</c:if>>
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
                                        </div>
                                    </div>
                                    <div class="col-lg-1 col-xl-2 col-md-2 mb-1 p-0">
                                        <div class="col-lg-12 col-md-12 text-center p-0 w-100 h-100">
                                            <button type="submit" class="btn btn-primary w-100 h-100">
                                                조회하기
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                    <div class="card">
                        <div class="p-2 pb-0 mt-0 ml-2 mr-2">
                            <h6 class="pt-0">조회결과 <span class="text-muted">( <fmt:formatNumber
                                    value="${searchCount}"
                                    pattern="#,###"/> 건 )</span>
                            </h6>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-hover table-striped table-md fancy-table">
                                    <thead>
                                    <tr>
                                        <th>그룹명</th>
                                        <th class="text-center">그룹번호</th>
                                        <th class="text-center">유효기간</th>
                                        <th class="text-center">쿠폰 고정금액</th>
                                        <th class="text-center">발권한도(잔여/최대)</th>
                                        <%--<th>ooweat담당자</th>--%>
                                        <th class="text-center">등록일</th>
                                        <th class="text-center">수정일</th>
                                        <th class="text-center">부가기능</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                <c:choose>
                                    <c:when test="${searchCount>0}">
                                    <c:forEach var="groupList" items="${searchList}">
                                        <tr onclick="location.href='/group/settingInfo?paramGroupSeq=${groupList.groupSeq}'">
                                            <td><span class="btn btn-primary">${groupList.groupName}</span></td>
                                            <td class="text-center">${groupList.groupSeq}</td>
                                            <td class="text-center"><fmt:formatNumber value="${groupList.useDay}" pattern="#,###" />일</td>
                                            <td class="text-center"><fmt:formatNumber value="${groupList.fixAmount}" pattern="#,###" /></td>
                                            <td class="text-center">
                                                <fmt:formatNumber value="${groupList.mainCompCnt - groupList.usedCount}" pattern="#,###" /> /
                                                <fmt:formatNumber value="${groupList.mainCompCnt}" pattern="#,###" />
                                            </td>
                                            <td class="text-center">${groupList.regDate}</td>
                                            <td class="text-center">
                                                <c:if test="${groupList.modDate == null}">-</c:if>${groupList.modDate}
                                            </td>
                                            <td class="text-center" onclick="location.href='/group/settingInfo?paramGroupSeq=${groupList.groupSeq}'">
                                                <a href="#" class="btn btn-primary"><span>관리</span></a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr><td>결과 값을 찾을 수 없습니다. Not Found Err</td></tr>
                                    </c:otherwise>
                                </c:choose>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        <div class="card-footer text-center border-top">
                            <nav class="d-inline-block">
                                <ul class="pagination  justify-content-center">
                                    <li class="page-item"><a href="#" class="page-link"
                                                             onclick="validationCheck3('1')">처음</a>
                                    </li>
                                    <c:if test="${pageInfo.startPage>1}">
                                        <li class="page-item"><a href="#" class="page-link"
                                                                 onclick="validationCheck3('${pageInfo.startPage -1}')"><i
                                                class="custom-fas fas fa-chevron-left"></i></a></li>
                                    </c:if>
                                    <c:forEach var="i" begin="${pageInfo.startPage}"
                                               end="${pageInfo.endPage}">
                                        <li class="page-item <c:if test='${pageInfo.pageNum == i}'>active</c:if>">
                                            <a href="#" class="page-link"
                                               onclick="validationCheck3('${i}')">${i}</a>
                                        </li>
                                    </c:forEach>
                                    <c:if test="${(pageInfo.endPage - pageInfo.startPage) > 8}">
                                        <li class="page-item"><a href="#" class="page-link"
                                                                 onclick="validationCheck3('${pageInfo.endPage +1}')"><i
                                                class="custom-fas fas fa-chevron-right"></i></a>
                                        </li>
                                    </c:if>
                                    <li class="page-item"><a href="#" class="page-link"
                                                             onclick="validationCheck3('${pageInfo.page.getPages()}')">마지막</a>
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
