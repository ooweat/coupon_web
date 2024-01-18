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
    <script type="text/javascript" src="/assets/js/fancyTable.js"></script>
    <title>Coupon</title>
</head>
<body>
<!-- Main Content -->
<div class="main-content">
    <section class="section">
        <div class="section-body">
            <div class="row">
                <div class="col-12 col-md-8 col-lg-8 col-xl-8">
                    <div class="card card-primary custom-card">
                        <div class="card-body">
                            <div class="form-divider text-primary">
                                공지사항
                            </div>
<%--                            <form method="POST" action="#">--%>
<%--                                <div class="container-fluid border">--%>
<%--                                    <div class="row border-bottom">--%>
<%--                                        <div class="col-lg-2 col-sm-12 col-md-12 bg-light p-3">그룹명</div>--%>
<%--                                        <div class="col-lg-4 col-sm-12 col-md-12 py-2">--%>
<%--                                            <div class="">--%>
<%--                                                <select id="paramGroupSeq" name="paramGroupSeq"--%>
<%--                                                        class="form-control select2 select2-hidden-accessible" tabindex="-1" aria-hidden="true">>--%>
<%--                                                    <c:if test="${role =='system'}">--%>
<%--                                                        <option value="0" selected>-전체-</option>--%>
<%--                                                        <c:forEach var="getGroupList" items="${getGroupList}">--%>
<%--                                                            <option value="${getGroupList.groupSeq}"--%>
<%--                                                                    <c:if test="${hmap.paramGroupSeq != null ?--%>
<%--                                                                    getGroupList.groupSeq==hmap.paramGroupSeq : getGroupList.groupSeq==0}">selected</c:if>--%>
<%--                                                            >--%>
<%--                                                                    ${getGroupList.groupName}--%>
<%--                                                            </option>--%>
<%--                                                        </c:forEach>--%>
<%--                                                    </c:if>--%>
<%--                                                    <c:if test="${role !='system'}">--%>
<%--                                                        <c:forEach var="getGroupList" items="${getGroupList}">--%>
<%--                                                            <option value="${getGroupList.groupSeq}" <c:if test="${getGroupList.groupSeq==hmap.paramGroupSeq}">selected</c:if>>--%>
<%--                                                                    ${getGroupList.groupName}--%>
<%--                                                            </option>--%>
<%--                                                        </c:forEach>--%>
<%--                                                    </c:if>--%>
<%--                                                </select>--%>
<%--                                            </div>--%>
<%--                                        </div>--%>

<%--                                        <div class="col-lg-2 col-md-12 bg-light p-3">기간검색</div>--%>
<%--                                        <div class="col-lg-4 col-sm-12 col-md-12 py-2">--%>
<%--                                            <div class="input-group daterange-btn form-inline col-lg-12 col-sm-5 col-md-12">--%>
<%--                                                <div class="input-group-prepend">--%>
<%--                                                    <div class="input-group-text">--%>
<%--                                                        <i class="fas fa-calendar"></i>--%>
<%--                                                    </div>--%>
<%--                                                </div>--%>
<%--                                                <input type="text" name="sDate" class="form-control daterange-sdate"--%>
<%--                                                       value="${today}" readonly="readonly" placeholder="시작일자">--%>
<%--                                                <div class="date-hypen"> ~</div>--%>
<%--                                                <input type="text" name="eDate" class="form-control daterange-edate"--%>
<%--                                                       value="${today}" readonly="readonly" placeholder="종료일자">--%>
<%--                                            </div>--%>
<%--                                        </div>--%>
<%--                                    </div>--%>
<%--                                </div>--%>

<%--                            </form>--%>
<%--                            <div class="col-lg-12 text-center mt-4">--%>
<%--                                <button type="submit" class="btn btn-primary btn-lg">--%>
<%--                                    조회--%>
<%--                                </button>--%>
<%--                            </div>--%>
                        </div>
                    </div>
                    <div class="card">
                        <div class="row p-4">
                            <div class="col-md-6 col-xs-6">
                                <h6 class="pt-2">조회결과 <span class="text-muted">( <fmt:formatNumber value="${searchCount}" pattern="#,###" /> 건 )</span></h6>
                            </div>
                            <%--<div class="col-md-6 col-xs-6">
                                <div class="justify-content-md-end float-right">
                                    <a href="#" class="btn btn-outline-primary"><i class="fas fa-trash-alt lh-0"></i> 선택삭제</a>
                                    <a href="/notice/noticeRegist.do" class="btn btn-outline-primary ml-2"><i class="fas fa-edit lh-0"></i> 글쓰기</a>
                                </div>
                            </div>--%>
                        </div>
                        <div class="card-body pt-0">
                            <div class="table-responsive">
                                <table class="table table-striped table-md fancy-table">
                                    <thead>
                                    <tr>
                                        <th>번호</th>
                                        <th>그룹명</th>
                                        <th>분류</th>
                                        <th>제목</th>
                                        <th>게시기간</th>
                                        <c:if test="${role} == 'system'">
                                        <th>여부</th>
                                        <th>관리</th>
                                        </c:if>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach var="searchList" items="${searchList}">
                                        <tr onclick="postParams('/notice/noticeInfo.do',
                                                params={paramSeq : ${searchList.noticeSeq}, page : 'noticeInfo'});">
                                            <td>${searchList.noticeSeq}</td>
                                            <td>${searchList.groupName}</td>
                                            <td>${searchList.noticeType}</td>
                                            <td>${searchList.noticeTitle}</td>
                                            <td>${searchList.regDate} ~ ${searchList.expiryDate}</td>
                                            <c:if test="${role} == 'system'">
                                            <td>${searchList.useYN}</td>
                                            <td onclick="postParams('/notice/noticeInfo.do',
                                                    params={paramSeq : ${searchList.noticeSeq}, page : 'noticeInfo'});">
                                                <a href="#" class="btn btn-primary"><span>관리</span></a>
                                            </td>
                                            </c:if>
                                        </tr>
                                    </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
</div>
<script type="text/javascript">
    $(".fancy-table").fancyTable({
        sortColumn: 10, // column number for initial sorting
        sortOrder: 'descending', // 'desc', 'descending', 'asc', 'ascending', -1 (descending) and 1 (ascending)
        sortable: true,
        pagination: true, // default: false
        searchable: true,
        globalSearch: true,
        globalSearchExcludeColumns: [0, 20] // exclude column 2 & 5
    });
    $('#summernote').summernote({
        height: 300,                 // 에디터 높이
        minHeight: null,             // 최소 높이
        maxHeight: null,             // 최대 높이
        focus: true,                  // 에디터 로딩후 포커스를 맞출지 여부
        lang: "ko-KR",					// 한글 설정
        placeholder: '최대 2048자까지 쓸 수 있습니다',	//placeholder 설정
        callbacks: {	//여기 부분이 이미지를 첨부하는 부분
            onImageUpload : function(files) {
                uploadSummernoteImageFile(files[0],this);
            },
            onPaste: function (e) {
                var clipboardData = e.originalEvent.clipboardData;
                if (clipboardData && clipboardData.items && clipboardData.items.length) {
                    var item = clipboardData.items[0];
                    if (item.kind === 'file' && item.type.indexOf('image/') !== -1) {
                        e.preventDefault();
                    }
                }
            }
        }
    });
</script>
</body>
</html>
