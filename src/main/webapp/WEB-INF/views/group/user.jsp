<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta charset="UTF-8">
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, shrink-to-fit=no" name="viewport">
    <script type="text/javascript" src="/static/assets/js/jquery.js"></script>
    <title></title>
    <script type="text/javascript">
      $(function () {
        loadingStop();
      });

      function validationCheck2(page) {
        loadingStart();

        $('#page').val(page);

        if ($('#searchValue').val().length >0 &&
            ($('#searchType').val() == null || $('#searchType').val() == '')) {
          alert('검색타입을 선택해주세요.');
          $('#searchType').focus();
          event.preventDefault();
          loadingStop();
        } else if (
            ($('#searchType option:selected').val().includes('TCB') ||
                $('#searchType option:selected').val().includes('TCS')) &&
            ($('#searchValue').val() == null || $('#searchValue').val() == '')) {
          alert('검색내용을 입력해주세요.');
          $('#searchValue').focus();
          event.preventDefault();
          loadingStop();
        }  else {
          $('#formData').submit();
          loadingStop();
        }
      }
    </script>
</head>

<body>
<!-- Main Content -->
<div class="main-content">
    <section class="section">
        <div class="section-body">
            <div class="row">
                <div class="col-12 col-md-12">
                    <%--검색조건--%>
                    <div class="card card-primary custom-card">
                        <div class="card-body">
                            <div class="form-divider text-primary">
                                계정관리
                                <a class="btn btn-primary" href="/group/userRegist">신규등록
                                    <span
                                            class="badge badge-white">N</span></a>
                            </div>
                            <form method="POST" action="#" id="formData" name="formData">
                                <input type="hidden" name="page" id="page" value=""/>
                                <div class="row">
                                    <div class="col-md-11 mb-1">
                                        <div class="container-fluid border">
                                            <div class="row border-bottom">
                                                <div class="col-lg-2 col-sm-2 col-md-2 bg-light p-2">그룹명
                                                    <i class="fas fa-question-circle title-i-line-height text-primary"
                                                       data-toggle="tooltip" title="" data-original-title=
                                                               "계정에 등록된 가맹점을 의미해요!"></i>
                                                </div>
                                                <div class="col-lg-6 col-sm-6 col-md-6 py-2 m-auto-0">
                                                    <div class="">
                                                        <select id="paramGroupSeq" name="paramGroupSeq"
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
                                            <div class="row border-bottom">
                                                <div class="col-lg-2 col-sm-2 col-md-2 bg-light p-2">상세검색
                                                    <i class="fas fa-question-circle title-i-line-height text-primary"
                                                       data-toggle="tooltip" title="" data-original-title=
                                                               "추가정보를 조회할 수 있어요!"></i>
                                                </div>
                                                <div class="row col-lg-7 col-sm-7 col-md-7 py-2 m-auto-0">
                                                    <div class="col-lg-4 col-md-4 col-sm-4 ps-0">
                                                        <select id="searchType" name="searchType"
                                                                onchange="_searchTypeValid()"
                                                                class="form-control select2 select2-hidden-accessible"
                                                                tabindex="-1" aria-hidden="true">>
                                                            <option value="0"
                                                                    <c:if test="${searchType == ''}">selected</c:if>>
                                                                -선택-
                                                            </option>
                                                            <option value="TU.NAME"
                                                                    <c:if test="${searchType == 'TU.NAME'}">selected</c:if>>
                                                                사용자명
                                                            </option>
                                                            <option value="TU.ID"
                                                                    <c:if test="${searchType == 'TU.ID'}">selected</c:if>>
                                                                아이디
                                                            </option>
                                                        </select>
                                                    </div>
                                                    <div class="col-lg-7 col-md-7 col-sm-7 ps-0">
                                                        <input type="text" name="searchValue"
                                                               class="form-control"
                                                               onkeyup="_searchValid(this)"
                                                               value="${searchValue}" id="searchValue">
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-1 mb-1 p-0">
                                        <div class="col-lg-12 col-md-12 text-center p-0 w-100 h-100">
                                            <button type="button" onclick="validationCheck2('1');"
                                                    class="badge badge-pill badge-primary btn-lg w-100 h-100">
                                                조회하기
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                    <%--검색결과--%>
                    <div class="card">
                        <div class="card-header" id="custom-card-header">
                            <h6 class="mt-3">조회결과 <span class="text-muted">( <fmt:formatNumber value="${searchCount}" pattern="#,###" /> 건 )</span></h6>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-striped table-md fancy-table">
                                    <thead>
                                        <tr>
                                            <th>그룹명</th>
                                            <th class="text-center">그룹번호</th>
                                            <th class="text-center">아이디</th>
                                            <th class="text-center">사용자명</th>
                                            <th class="text-center">권한</th>
                                            <th class="text-center">등록일</th>
                                            <th class="text-center">수정일</th>
                                            <th class="text-center">부가기능</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                    <c:choose>
                                        <c:when test="${searchCount>0}">
                                            <c:forEach var="userList" items="${searchList}">
                                                <tr onclick="postParams('/group/userInfo', params={paramUserSeq : ${userList.userSeq}});">
                                                    <td><span class="btn btn-primary">${userList.groupName}</span></td>
                                                    <td class="text-center">${userList.groupSeq}</td>
                                                    <td class="text-center">${userList.userId}</td>
                                                    <td class="text-center">${userList.userName}</td>
                                                    <td class="text-center">
                                                        <c:choose>
                                                            <c:when test="${userList.role == 'system'}">
                                                                시스템계정(ooweat)
                                                            </c:when>
                                                            <c:when test="${userList.role == 'admin'}">
                                                                가맹관리자
                                                            </c:when>
                                                            <c:when test="${userList.role == 'merchant'}">
                                                                가맹점(운영자)
                                                            </c:when>
                                                        </c:choose>
                                                    </td>
                                                    <td class="text-center">${userList.regDate}</td>
                                                    <td class="text-center">
                                                        <c:if test="${userList.modDate == null}">-</c:if>${userList.modDate}
                                                    </td>
                                                    <td class="text-center" onclick="postParams('/group/userInfo', params={paramUserSeq : ${userList.userSeq}});">
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
                                                             onclick="validationCheck2('1')">처음</a>
                                    </li>
                                    <c:if test="${pageInfo.startPage>1}">
                                        <li class="page-item"><a href="#" class="page-link"
                                                                 onclick="validationCheck2('${pageInfo.startPage -1}')"><i
                                                class="custom-fas fas fa-chevron-left"></i></a></li>
                                    </c:if>
                                    <c:forEach var="i" begin="${pageInfo.startPage}"
                                               end="${pageInfo.endPage}">
                                        <li class="page-item <c:if test='${pageInfo.pageNum == i}'>active</c:if>">
                                            <a href="#" class="page-link"
                                               onclick="validationCheck2('${i}')">${i}</a>
                                        </li>
                                    </c:forEach>
                                    <c:if test="${(pageInfo.endPage - pageInfo.startPage) > 8}">
                                        <li class="page-item"><a href="#" class="page-link"
                                                                 onclick="validationCheck2('${pageInfo.endPage +1}')"><i
                                                class="custom-fas fas fa-chevron-right"></i></a>
                                        </li>
                                    </c:if>
                                    <li class="page-item"><a href="#" class="page-link"
                                                             onclick="validationCheck2('${pageInfo.page.getPages()}')">마지막</a>
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
