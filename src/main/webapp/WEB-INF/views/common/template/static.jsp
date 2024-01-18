<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <%--<meta charset="UTF-8">--%>
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, shrink-to-fit=no"
          name="viewport">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <script type="text/javascript" src="/assets/js/jquery.js"></script>
    <title>Static Page</title>
    <script type="text/javascript">
      $(function () {
        if ('${userName}' == null || '${userName}' == '') {
          alert("세션이 만료되었습니다. \n" +
              "재로그인이 필요하여 로그인 페이지로 이동합니다.")
          window.location.assign('/login');
        }
      });
    </script>
</head>
<body>
<%--Header--%>
<div class="common-header">
    <div class="navbar-bg"></div>
    <nav class="navbar navbar-expand-lg main-navbar">
        <div class="form-inline mr-auto">
            <ul class="navbar-nav mr-3">
                <li><a href="#" data-toggle="sidebar" class="nav-link nav-link-lg"><i
                        class="fas fa-bars"></i></a></li>
            </ul>
        </div>
        <ul class="navbar-nav navbar-right">
            <li class="dropdown"><a href="#" data-toggle="dropdown"
                                    class="nav-link dropdown-toggle nav-link-lg nav-link-user">
                <div class="d-sm-none d-lg-inline-block" id="user_info">
                    <i class="fa-sharp fa-solid fa-shop"></i> ${userName}[${userId}]
                </div>
            </a>
                <div class="dropdown-menu dropdown-menu-right">
                    <c:if test="${userType != null}">
                        <div class="dropdown-title">설정정보</div>
                        <a href="#" onclick="postParams('/employee/management/company/companyInfo',
                                params={paramSeq : ${seq}, page : 'companyInfo'});"
                           class="dropdown-item has-icon">
                            <i class="far fa-user" style="float:none"></i> 계정정보수정
                        </a>
                    </c:if>
                    <a href="#" class="dropdown-item has-icon">
                        <i class="fas fa-user" style="float:none"></i>ID: ${userId}
                    </a>
                    <a href="#" class="dropdown-item has-icon">
                        <i class="fas fa-id-card" style="float:none"></i>권한: ${role}
                    </a>
                    <%--<div class="dropdown-divider"></div>--%>
                    <a href="/logout" class="dropdown-item has-icon text-danger">
                        <i class="fas fa-sign-out-alt" style="float:none"></i> Logout
                    </a>
                </div>
            </li>
        </ul>
    </nav>
    <%--Sidebar--%>
    <div class="main-sidebar">
        <aside id="sidebar-wrapper">
            <div class="sidebar-brand">
                <a href="/dashboard">coupon_web</a>
            </div>
            <div class="sidebar-brand sidebar-brand-sm">
                <a href="/dashboard">coupon_web</a>
            </div>
            <ul class="sidebar-menu">
                <%--멤버십--%>
                <li class="menu-header">멤버십 서비스</li>
                <li class="nav-item"><a class="nav-link" href="/dashboard"><i
                        class="far fa-clipboard"></i> <span>Dashboard</span></a></li>

                <c:if test="${role=='system'}">
                    <li class="nav-item dropdown">
                        <a href="#" class="nav-link has-dropdown" data-toggle="dropdown"><i
                                class="fas fa-users-cog"></i> <span>그룹사/계정</span></a>
                        <ul class="dropdown-menu" style="display: none;">
                            <li><a class="nav-link" href="/group/client">그룹 고객사 관리</a></li>
                            <li><a class="nav-link" href="/group/setting">그룹별 쿠폰 설정 관리</a></li>
                            <li><a class="nav-link" href="/group/user">계정 관리</a></li>
                        </ul>
                    </li>
                </c:if>
                <li class="nav-item dropdown">
                    <a href="#" class="nav-link has-dropdown" data-toggle="dropdown"><i
                            class="fas fa-barcode"></i>
                        <span>쿠폰</span></a>
                    <ul class="dropdown-menu" style="display: none;">
                        <c:if test="${role!='system'}">
                            <c:if test="${role=='system' || useCouponConfig eq 'Y'.charAt(0)}">
                            <li><a class="nav-link" href="/group/settingInfo?paramGroupSeq=${groupSeq}">쿠폰설정</a></li>
                            </c:if>
                        </c:if>
                        <c:if test="${role=='system' || useCouponIssuanceHistory eq 'Y'.charAt(0)}">
                        <li><a class="nav-link" href="/coupon/issuance">쿠폰발권내역</a></li>
                        </c:if>
                        <c:if test="${role=='system' || useCouponSalesHistory eq 'Y'.charAt(0)}">
                        <li><a class="nav-link" href="/coupon/sales">쿠폰사용내역</a></li>
                        </c:if>
                    </ul>
                </li>
                <%--임시 주석처리--%>
                <%--<li class="nav-item ">
                    <a href="/point/point" class="nav-link"><i class="fas fa-coins"></i>
                        <span>포인트</span></a>
                </li>
                <li class="nav-item ">
                    <a href="/member/member" class="nav-link"><i class="fas fa-users"></i>
                        <span>멤버십 회원</span></a>
                </li>
                <li class="nav-item dropdown">
                    <a href="#" class="nav-link has-dropdown" data-toggle="dropdown"><i class="far fa-bell"></i>
                        <span>공지사항</span></a>
                    <ul class="dropdown-menu" style="display: none;">
                        <li><a class="nav-link" href="/notice/notice">공지내역</a></li>
                        <c:if test="${role =='system'}">
                            <li><a class="nav-link" href="/notice/noticeRegist">공지등록</a></li>
                        </c:if>
                    </ul>
                </li>--%>
                <%--멤버십--%>
            </ul>

            <div class="mt-4 mb-4 p-3 hide-sidebar-mini">
                <a href="/logout" class="btn btn-danger btn-lg btn-block btn-icon-split">
                    <i class="fas fa-sign-out-alt"></i>Logout
                </a>
            </div>
        </aside>
    </div>
</div>
</body>
</html>
