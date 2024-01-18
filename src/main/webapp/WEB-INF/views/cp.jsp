<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta charset="UTF-8">
    <meta content="width=device-width, initial-scale=1, shrink-to-fit=no" name="viewport">
    <meta name="color-scheme" content="light only"/>
    <meta name="supported-color-schemes" content="light"/>

    <script type="text/javascript" src="/assets/js/jquery.js"></script>
    <script type="text/javascript" src="/assets/js/jquery.qrcode.js"></script>
    <script type="text/javascript" src="/assets/js/qrcode.js"></script>
    <script type="text/javascript"
            src="https://cdn.jsdelivr.net/npm/jsbarcode@3.11.5/dist/JsBarcode.all.min.js"></script>
    <script type="text/javascript" src="/assets/js/coupon.js"></script>
    <link href='http://www.openhiun.com/hangul/nanumbarungothic.css' rel='stylesheet'
          type='text/css'>
    <link href="/assets/css/coupon.css" rel="stylesheet">
    <title>쿠폰</title>
    <script type="text/javascript">
      $(function () {
        let i =10;
        setInterval(() => counting(i--), 1000);

        function counting(timer){
          $('#counting').text(timer);
          if(timer == 1){
            window.location.reload();
          }
        }
      });
      /*      $(function () {
              JsBarcode(".barcode").init();
            });*/

      function changeCode() {
        if ($('#qrcode').hasClass('show')) {
          $('#qrcode').hide();
          $('#qrcode').removeClass('show');
          $('#barcodeArea').show();
          JsBarcode(".barcode").init();
        } else {
          $('#qrcode').show();
          $('#qrcode').addClass('show');
          $('#barcodeArea').hide();
        }
      }

      function changeCodeView(param){
        if(param == "qr"){
          $('#qrcode').show();
          $('#qrcode').addClass('show');
          $('#barcodeArea').hide();
        } else if(param == "barcode"){
          $('#qrcode').hide();
          $('#qrcode').removeClass('show');
          $('#barcodeArea').show();
          JsBarcode(".barcode").init();
        }
      }
    </script>

</head>
<body id="main_content">
<input type="hidden" id="couponStat" value="${couponInfo.couponStat}"/>
<input type="hidden" id="groupName" value="${couponInfo.groupName}"/>

<%--QR 선택 시 발동하는 Coupon Modal --%>
<%--<div class="mask" role="dialog">
    <div class="rounded-circle avatar-item show" id="modalBarCode" align="center">
        <svg class="barcode"
             jsbarcode-format="auto"
             jsbarcode-value="${couponInfo.couponNo}"
             jsbarcode-textmargin="0"
             jsbarcode-fontoptions="bold">
        </svg>
    </div>
    <script>
      JsBarcode(".barcode").init();
      /*$('#modalBarCode').qrcode({
        text: "${couponInfo.couponNo}",
        width: 192,
        height: 192,
      });*/
    </script>
</div>
<div class="modal" role="alert">
    <button class="close" role="button">X</button>
</div>--%>

<div class="ticket-container">
    <div class="position-absolute" style=" right: 5%; z-index: 1; top: 2%; color: orange; font-weight: bold; font-size: 1rem" id="counting"></div>
    <%--상단 Header--%>
        <div class="row w-100">
            <div class="col-md-12 p-0">
                <div class="card mb-0">
                    <div class="card-body p-0 pt-1 m-auto">
                        <ul class="nav nav-pills" id="myTab" role="tablist">
                            <li class="nav-item">
                                <a class="nav-link active show" id="qr-tab" data-toggle="tab" href="#qr" role="tab" aria-controls="qr" aria-selected="true"
                                onclick="changeCodeView('qr')">QR코드</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" id="barcode-tab" data-toggle="tab" href="#barcode" role="tab" aria-controls="barcode" aria-selected="false"
                                   onclick="changeCodeView('barcode')">바코드</a>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    <%-- 상단 코드 섹션--%>
    <div class='ticket stamp'>
        <%--사용 완료 쿠폰--%>
        <div class="ticket-inner mt-1 mb-2" align="center">
            <div class='ticket-headline'>
                <c:choose>
                    <c:when test="${couponInfo.couponType == 'GIFT'}">
                        <div class="ticket-headline-text">
                            <fmt:formatNumber value="${couponInfo.couponAmt}" pattern="#,###"/> 원
                        </div>
                    </c:when>
                    <c:when test="${couponInfo.couponType == 'RUSE'}">
                        <div class="ticket-headline-text-long">
<%--                            <span class="badge badge-light">회수</span>
                            <fmt:formatNumber value="${couponInfo.couponCount}" pattern="#,###"/> /
                            <fmt:formatNumber value="${couponInfo.couponConfCount}"
                                              pattern="#,###"/> 회
                            <br>--%>
                            <span class="badge badge-light">잔액</span>
                            <fmt:formatNumber value="${couponInfo.couponAmt}" pattern="#,###"/> 원
                        </div>

                    </c:when>
                </c:choose>
            </div>
            <div class='ticket-star'>
                <div class='fa fa-star-o'></div>
            </div>
            <div class='ticket-admit'>
                <%-- Barcode 사용시 --%>
                <div class="rounded-circle avatar-item" id="barcodeArea"
                     onclick="location.reload();" align="center" style="display: none;">
                    <svg class="barcode"
                         jsbarcode-format="auto"
                         jsbarcode-value="${couponInfo.couponNo}"
                         jsbarcode-textmargin="0"
                         jsbarcode-fontoptions="bold">
                    </svg>
                </div>
                <%--QR 사용시--%>
                <div class="rounded-circle avatar-item show" id="qrcode"
                     onclick="location.reload();" align="center"></div>
                <script>
                  $('#qrcode').qrcode({
                    text: "${couponInfo.couponNo}",
                    width: 120,
                    height: 120,
                  });
                </script>
            </div>
            <%--<div class='ticket-numbers'>${couponInfo.couponNo}</div>
            <div class='ticket-numbers second'>${couponInfo.couponNo}</div>--%>
            <%--<div class="button r mb-1" id="button-1">
                <input type="checkbox" class="checkbox" onclick="changeCode();"/>
                <div class="knobs"></div>
                <div class="layer"></div>
            </div>--%>
        </div>
        <div align="center">
            <div class="tof-e height-30 btn btn-primary">${couponInfo.groupName}</div>
        </div>
    </div>

    <%-- Bin Code에 따른 로고 이미지 추출 / 추후 로고가 많아지면 DB화 진행--%>
    <c:if test="${couponInfo.couponBin == '7801'}">
    <div id="couponLogo" class="mb-1 mt-1" align="center">
        <img src="/assets/img/donggu_CouponLogo.png"/>
    </div>
    </c:if>

    <%-- 내용 Section --%>
    <section class="section">
        <div class="section-body">
            <div>
                <div class="card mb-0">
                    <div class="card-body pt-0">
                        <div>
                            <div class="cp-subtitle">※유의사항※</div>
                            <div class="p-1 coupon-box">
                                ▶ 단말기의 쿠폰 인식을 위해 화면 밝기를 최대로 올려주세요.<br>
                                ▶ 코드 아래에 있는 슬라이드 버튼을 통해 QR 과 바코드를 변경할 수 있어요.<br><br>
                                ⦁ 특정 매장(${couponInfo.merchantName})에 한하여 사용 가능한 쿠폰<br>
                                <c:if test="${couponInfo.couponType == 'RUSE'}">
                                    ⦁ 권면가액 이하 사용 시 잔액은 <%--회수 내 --%>유효기간 까지 사용 가능 (단, 잔액은 환불 불가)<br>
                                </c:if>
                                ⦁ 타 할인쿠폰, 동일 행사 쿠폰 등 중복 사용 불가<br>
                                ⦁ 유효기간 당일까지만 사용가능<br>
                                ⦁ 별도 표기된 쿠폰은 사용불가<br><br>
                                ▶ 본 모바일 쿠폰은 무상제공(B2C) 발송 상품으로 유효기간 연장 및 환불 대상이 아닙니다.<br>
                                ▶ QR 코드 또는 바코드를 선택하면, 새로고침되어 쿠폰의 최신상태를 불러와요.<br>
                                ▶ 쿠폰 사용 관련 문의사항은 아래 교환처로 문의해주세요.<br><br>
                            </div>
                        </div>
                        <br>
                        <%--쿠폰 정보--%>
                        <div>
                            <div class="cp-subtitle">※쿠폰 정보※</div>
                            <table class="table table-striped table-md">
                                <tbody>
                                <tr>
                                    <td class="text-muted text-left">유효기간</td>
                                    <td class="text-right">${couponInfo.expireDay}</td>
                                </tr>
                                <tr>
                                    <td class="text-muted text-left">쿠폰번호</td>
                                    <td class="text-right">${couponInfo.couponNo}</td>
                                </tr>
                                <tr>
                                    <td class="text-muted text-left">교환처</td>
                                    <td class="text-right">${couponInfo.groupName}</td>
                                </tr>
                                <tr>
                                    <td class="text-muted text-left">쿠폰선물일</td>
                                    <td class="text-right">${couponInfo.regDate}</td>
                                </tr>
                                <tr>
                                    <td class="text-muted text-left">쿠폰상태</td>
                                    <td class="text-right">${couponInfo.couponStat}</td>
                                    <%--<c:choose>
                                        <c:when test="${couponInfo.couponType == 'GIFT'}">
                                            <td class="text-right">${couponInfo.couponStat}</td>
                                        </c:when>
                                        <c:when test="${couponInfo.couponType == 'RUSE'}">
                                            <td class="text-right">
                                                <fmt:formatNumber value="${couponInfo.couponCount}"
                                                                  pattern="#,###"/>/
                                                <fmt:formatNumber
                                                        value="${couponInfo.couponConfCount}"
                                                        pattern="#,###"/>
                                                회 가능
                                            </td>
                                        </c:when>
                                    </c:choose>--%>
                                </tr>
                                </tbody>
                            </table>
                        </div>
                        <br>
                        <%--쿠폰 사용내역--%>
                        <div id="useList">
                            <div class="cp-subtitle">※사용내역※</div>
                            <div class="card-body p-0">
                                <div class="summary-item">
                                    <ul class="list-unstyled list-unstyled-border">
                                        <c:forEach var="couponUseList"
                                                   items="${couponUseList}">
                                            <li class="media">
                                                <div class="media-body">
                                                    <div class="media-right"><fmt:formatNumber
                                                            value="${couponUseList.tranAmt}"
                                                            pattern="#,###"/>원
                                                    </div>
                                                    <div class="media-title"><a
                                                            href="#">${couponUseList.groupName}</a>
                                                    </div>
                                                    <div class="text-muted text-small">
                                                        <div class="bullet"></div>
                                                            ${couponUseList.regDate}
                                                    </div>
                                                    <div class="text-muted text-small">
                                                        <div class="bullet"></div>
                                                            ${couponUseList.couponType}
                                                    </div>
                                                    <div class="text-muted text-small">
                                                        <div class="bullet"></div>
                                                        잔액:
                                                        <fmt:formatNumber
                                                                value="${couponUseList.aftAmt}"
                                                                pattern="#,###"/>원
                                                    </div>
                                                </div>
                                            </li>
                                        </c:forEach>
                                    </ul>
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
