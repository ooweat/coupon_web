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
    <script type="text/javascript" src="/assets/js/jquery.qrcode.js"></script>
    <script type="text/javascript" src="/assets/js/qrcode.js"></script>
    <title>쿠폰 캔버스</title>
</head>
<body>
<!-- Main Content -->
<div class="main-content">
    <section class="section">
        <div class="section-body">
            <div class="row">
                <div class="col-12 col-sm-10 offset-sm-1 col-md-8 offset-md-2 col-lg-8 offset-lg-2 col-xl-8 offset-xl-2">
                    <div class="card card-primary">
                        <div class="card-header"><h4>포인트 적립/사용 내역</h4></div>
                        <div class="card-body">
                            <div class="card profile-widget">
                                <div class="profile-widget-header">
                                    <div class="rounded-circle avatar-item" id="qrcode" align="center"></div>
                                    <div align="center">1234567890</div>
                                    <script>
                                        //jQuery('#qrcode').qrcode("this plugin is great");
                                        $('#qrcode').qrcode({
                                            text	: "1234567890"
                                        });
                                    </script>

                                    <div class="profile-widget-items">
                                        <div class="profile-widget-item">
                                            <div class="card card-statistic-2 mb-0">
                                                <div class="card-icon">
                                                    <%--<i class="fas fa-dollar-sign"></i>--%>
                                                    <img src="/assets/img/icon_point1.png" alt="">
                                                </div>
                                                <div class="card-wrap">
                                                    <div class="card-header">
                                                        <h4>멤버십 포인트</h4>
                                                    </div>
                                                    <div class="card-body">
                                                        <div class="profile-widget-item-value"><span class="strong-font20">50</span> P</div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="profile-widget-description">
                                    <div class="summary">
                                        <div class="summary-item mt-0">
                                            <h6>최근 적립목록 <span class="text-muted">(TOP 5)</span></h6>
                                            <ul class="list-unstyled list-unstyled-border">
                                                <li class="media">
                                                    <div class="media-body">
                                                        <div class="media-right"><span class="text-danger text-fw-bold">+ 10</span> P</div>
                                                        <div class="media-title"><a href="#">핫식스</a></div>
                                                        <div class="text-muted text-small">by <div class="bullet"></div> 2021-12-13 10:16:01</div>
                                                    </div>
                                                </li>
                                                <li class="media">
                                                    <div class="media-body">
                                                        <div class="media-right"><span class="text-danger text-fw-bold">+ 10</span> P</div>
                                                        <div class="media-title"><a href="#">핫식스</a></div>
                                                        <div class="text-muted text-small">by <div class="bullet"></div> 2021-12-13 10:16:01</div>
                                                    </div>
                                                </li>
                                                <li class="media">
                                                    <div class="media-body">
                                                        <div class="media-right"><span class="text-danger text-fw-bold">+ 10</span> P</div>
                                                        <div class="media-title"><a href="#">핫식스</a></div>
                                                        <div class="text-muted text-small">by <div class="bullet"></div> 2021-12-13 10:16:01</div>
                                                    </div>
                                                </li>
                                                <li class="media">
                                                    <div class="media-body">
                                                        <div class="media-right"><span class="text-danger text-fw-bold">+ 10</span> P</div>
                                                        <div class="media-title"><a href="#">핫식스</a></div>
                                                        <div class="text-muted text-small">by <div class="bullet"></div> 2021-12-13 10:16:01</div>
                                                    </div>
                                                </li>
                                                <li class="media">
                                                    <div class="media-body">
                                                        <div class="media-right"><span class="text-danger text-fw-bold">+ 10</span> P</div>
                                                        <div class="media-title"><a href="#">핫식스</a></div>
                                                        <div class="text-muted text-small">by <div class="bullet"></div> 2021-12-13 10:16:01</div>
                                                    </div>
                                                </li>
                                            </ul>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
</div>
</body>
</html>
