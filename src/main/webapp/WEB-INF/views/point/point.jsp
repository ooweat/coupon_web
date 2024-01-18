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
    <script type="text/javascript" src="/assets/js/fancyTable.js"></script>
    <title>Point</title>
</head>
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
                                포인트 사용내역 <%--// 검색기능 비활성화--%>
                            </div>
                            <form method="GET" action="/point/point.do">
                                <div class="container-fluid border">
                                    <div class="row border-bottom">
                                        <div class="col-lg-2 col-sm-12 col-md-12 bg-light p-3">그룹명</div>
                                        <div class="col-lg-4 col-sm-12 col-md-12 py-2">
                                            <div class="">
                                                <select id="paramGroupSeq" name="paramGroupSeq"
                                                        class="form-control select2 select2-hidden-accessible"
                                                        tabindex="-1" aria-hidden="true">>
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
                                                            <option value="${getGroupList.groupSeq}"
                                                                    <c:if test="${getGroupList.groupSeq==hmap.paramGroupSeq}">selected</c:if>>
                                                                    ${getGroupList.groupName}
                                                            </option>
                                                        </c:forEach>
                                                    </c:if>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="col-lg-2 col-md-12 bg-light p-3">기간검색</div>
                                        <div class="col-lg-4 col-sm-12 col-md-12 py-2">
                                            <div class="input-group daterange-btn form-inline col-lg-12 col-sm-5 col-md-6">
                                                <input type="text" name="sDate" class="form-control daterange-sdate"
                                                       value="${hmap.sDate !=null ? hmap.sDate: today}"
                                                       readonly="readonly" placeholder="시작일자">
                                                <div class="date-hypen"> ~</div>
                                                <input type="text" name="eDate" class="form-control daterange-edate"
                                                       value="${hmap.eDate !=null ? hmap.eDate: today}"
                                                       readonly="readonly" placeholder="종료일자">
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-lg-12 text-center mt-4">
                                    <button type="submit" class="btn btn-primary btn-lg">
                                        조회
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                    <div class="card">
                        <div class="p-3 mt-2 ml-2 mr-2">
                            <h6 class="pt-2">조회결과 <span class="text-muted">( <fmt:formatNumber value="${searchCount}" pattern="#,###" /> 건 )</span></h6>
                        </div>
                        <div class="card-body pt-0">
                            <div class="table-responsive">
                                <table class="table table-hover table-striped table-md fancy-table">
                                    <thead>
                                        <tr>
                                            <th>그룹명</th>
                                            <th>회원명</th>
                                            <th>멤버십ID</th>
                                            <th>단말기ID</th>
                                            <th>포인트</th>
                                            <th>컬럼</th>
                                            <th>구분</th>
                                            <th>승인일시</th>
                                            <th>취소기능</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach var="searchList" items="${searchList}">
                                        <tr>
                                            <td><span class="btn btn-primary">${searchList.groupName}</span></td>
                                            <td>${searchList.memberName}</td>
                                            <td>${searchList.memberId}</td>
                                            <td>${searchList.terminalId}</td>
                                            <td data-toggle="tooltip" title="" data-original-title="
                                            <div class='bullet'></div>사용전 : <fmt:formatNumber value="${searchList.prePoint}" pattern="#,###" /> 원<br>
                                            <div class='bullet'></div>사용후 : <fmt:formatNumber value="${searchList.postPoint}" pattern="#,###" /> 원
                                            " data-html="true">
                                                <fmt:formatNumber value="${searchList.tranAmt}" pattern="#,###" /> 원
                                            </td>
                                            <td>${searchList.colNo} 번</td>

                                                <c:choose>
                                                    <c:when test="${searchList.msgStep=='승인' || searchList.msgStep=='적립' || searchList.msgStep=='조회'}">
                                                    <td>
                                                        <div class="badge
                                                        <c:if test="${searchList.msgStep=='승인'}">badge-info</c:if>
                                                        <c:if test="${searchList.msgStep=='적립' || searchList.msgStep=='조회'}">badge-warning</c:if>
                                                        ">${searchList.msgStep}</div>
                                                    </td>
                                                    <td>${searchList.regDate}</td>
                                                    <td>
                                                        <a href="#" class="btn btn-danger btn-action trigger--fire-modal-1"
                                                           onclick="cancelConfirmPost('/point/pointCancel.do',
	                                                           	   params={paramSeq : `${searchList.transactionNo}`,transactionNo:`${searchList.transactionNo}`,
                                                                   memberId:`${searchList.memberId}`,terminalId:`${searchList.terminalId}`,tranAmt:`${searchList.tranAmt}`,
                                                                   colNo:`${searchList.colNo}`, tranSeqNo:`${searchList.tranSeqNo}`,
                                                                   tranDate:`${searchList.tranDate}`,tranType:`${searchList.tranType}`,
                                                                   messageType: '02', inputType : 'P', messageVersion: 'T1', cryptoFlag: '0'
                                                                   ,page : 'pointCancel'
                                                                   
                                                                   });">
                                                            <i class="fas fa-trash" style="line-height: 200%;"></i>
                                                        </a>
                                                    </td>
                                                    </c:when>
                                                    <c:when test="${searchList.msgStep=='취소'||searchList.msgStep=='망취소'||searchList.msgStep=='적립취소'||searchList.msgStep=='적립망상'}">
                                                        <td class="text-decoration-trash">
                                                            <div class="badge badge-danger">${searchList.msgStep}</div>
                                                        </td>
                                                        <td class="text-decoration-trash">${searchList.regDate}</td>
                                                        <td>
                                                            <span class="btn btn-secondary"><i class="fas fa-trash" style="line-height: 200%;"></i></span>
                                                        </td>
                                                    </c:when>
                                                </c:choose>
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
        sortColumn:10, // column number for initial sorting
        sortOrder: 'descending', // 'desc', 'descending', 'asc', 'ascending', -1 (descending) and 1 (ascending)
        sortable: true,
        pagination: true, // default: false
        searchable: true,
        globalSearch: true,
        globalSearchExcludeColumns: [0,20] // exclude column 2 & 5
    });
</script>
<%--<script type="text/javascript">
    $(function () {
        loading_st();
    });
</script>--%>
</body>
</html>
