<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta http-equiv="X-UA-Compatible" content="ie=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>로그인</title>
	<c:set var="root" value="${pageContext.request.contextPath}" />

	<!-- General CSS Files -->
	<link rel="stylesheet" href="/assets/css/bootstrap.min.css" >
	<link rel="stylesheet" href="/assets/css/fontawesome.min.css">
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.2.0/css/all.min.css" >
	<script type="text/javascript" src="/assets/js/jquery.js"></script>
	<script type="text/javascript" src="/assets/js/custom.js"></script>
	<!-- Template CSS -->
	<link rel="stylesheet" href="/assets/css/style.css">
	<link rel="stylesheet" href="/assets/css/components.css">
	<link rel="stylesheet" href="/assets/css/custom.css">

</head>
<body>
<div id="app">
	<section class="section">
		<div class="d-flex flex-wrap align-items-stretch">
			<div class="col-lg-4 col-md-6 col-12 order-lg-1 min-vh-100 order-2 bg-white">
				<div class="p-4 m-3">
					<%--logo--%>
					<div align="center">
						<img src="/assets/img/logo/logo.png" alt="logo" class="mb-5 mt-2">
						<h4 class="text-dark font-weight-normal">Welcome to <span class="font-weight-bold">coupon_web</span></h4>
						<p class="text-muted">ooweat 멤버십 서비스에 오신 것을 환영합니다. <br/></p>
					</div>
					<form method="POST" action="/loginConfirm.do" id="formData" class="needs-validation" novalidate="">
						<div class="form-group col-12">
							<div class="selectgroup w-100">
								<label class="selectgroup-item">
									<input type="radio" id="loginFlag" name="loginFlag" value="1" class="selectgroup-input" checked>
									<span class="selectgroup-button">관리자</span>
								</label>
							</div>
						</div>
						<div class="form-group">
							<label for="userId" id="idText">ID</label>
							<input id="userId" type="text" class="form-control" name="userId" tabindex="1" required autofocus
								   placeholder="아이디">
							<div class="invalid-feedback">
								아이디를 입력하여 주세요.
							</div>
						</div>

						<div class="form-group">
							<div class="d-block">
								<label for="userPw" id="pwText" class="control-label">Password</label>
							</div>
							<input id="userPw" type="password" class="form-control" name="userPw" tabindex="2" required
								   placeholder="패스워드">
							<div class="invalid-feedback">
								비밀번호를 입력하여 주세요.
							</div>
						</div>
						<div class="form-group text-right">

							<button type="submit" id="loginBtn" class="btn btn-primary btn-lg btn-icon icon-right width-100-per" tabindex="4">
								로그인
							</button>
						</div>
					</form>
						<div class="mt-1 text-center" id="newRegister">
							계정이 없으십니까? <a href="auth-register.html">회원가입 하러가기</a>
						</div>
					<div class="text-center mt-1 text-small">
						Copyright &copy; ooweat.
						<div class="mt-2">
							<div class="bullet"></div><a href="http://www.ooweat.co.kr/other/privacy.php">개인정보 취급방침</a>
						</div>
					</div>
				</div>
				<div class="bullet"></div><span class="text-muted">브라우저 요구사항이 충족되지 못할 시에는 이용이 원활하지 않을 수 있습니다.</span>
			</div>
			<div class="col-lg-8 col-12 order-lg-2 order-1 min-vh-100 background-walk-y position-relative
			overlay-gradient-bottom" data-background="/assets/img/unsplash/back.jpg">

				<div class="absolute-bottom-left index-2">
					<div class="text-light p-5 pb-2">
						<div class="mb-5 pb-3">
							<h1 class="mb-2 display-4 font-weight-bold">ooweat</h1>
							<h5 class="font-weight-normal text-muted-transparent">카드결제단말기시스템</h5>
						</div>
						<%--Photo by <a class="text-light bb" target="_blank"
									href="/assets/img/unsplash/chris_pic.jpg">Chris Kim</a>--%>
					</div>
				</div>
				<div class="absolute-bottom-left index-2 pamphletscroll-down" align="center" style="height: 10%;">
					<img src="/assets/img/unsplash/down.gif" style="height: 100%;">
				</div>
			</div>
		</div>
	</section>
</div>
<script type="text/javascript">
	$(function () {
		//최초 값 설정
		if($("#loginFlag").val()=='1'){
			$("#idText").text('관리자 ID');
			$("#pwText").text('관리자 PW');
			$("#newRegister").css('display', 'none');
		}else {
			$("#idText").text('회원 ID');
			$("#pwText").text('회원 PW');
			$("#newRegister").css('display', 'block');
		}

		//변경 시 설정
		$("input[name='loginFlag']:radio").change(function () {
			if(this.value=='1'){
				$("#idText").text('관리자 ID');
				$("#pwText").text('관리자 PW');
				$("#userId").val('');
				$("#userPw").val('');
				$("#newRegister").css('display', 'none');
				$("#formData").attr('action','/loginConfirm.do');
			}else {
				$("#idText").text('회원 ID');
				$("#pwText").text('회원 PW');
				$("#newRegister").css('display', 'block');
				$("#userId").val('');
				$("#userPw").val('');
				$("#formData").attr('action','/memberLogin.do');
			}
		});

		$(".memberHandler").click(function () {
			alert('hello');
		});
	})
</script>
<!-- General JS Scripts -->
<script type="text/javascript" src="/assets/js/jquery.js"></script>
<script type="text/javascript" src="/assets/js/popper.min.js"></script>
<script type="text/javascript" src="/assets/js/bootstrap.min.js"></script>
<script type="text/javascript" src="/assets/js/jquery.nicescroll.min.js"></script>
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.24.0/moment.min.js"></script>
<script type="text/javascript" src="/assets/js/stisla.js"></script>

<!-- JS Libraies -->

<!-- Template JS File -->
<script type="text/javascript" src="/assets/js/scripts.js"></script>
<script type="text/javascript" src="/assets/js/custom.js"></script>

<!-- Page Specific JS File -->
</body>
</html>
