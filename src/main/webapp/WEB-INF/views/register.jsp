<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta http-equiv="X-UA-Compatible" content="ie=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<c:set var="root" value="${pageContext.request.contextPath}" />
	<script type="text/javascript" src="/assets/js/jquery.js"></script>
	<script type="text/javascript" src="/assets/js/scripts.js"></script>
	<script type="text/javascript" src="/assets/js/custom.js"></script>
	<title>로그인</title>
</head>
<body onload="initRegister();">
<div id="app">
	<section class="section">
		<div class="container mt-3">
			<div class="row">
				<div class="col-12 col-sm-10 offset-sm-1 col-md-8 offset-md-2 col-lg-8 offset-lg-2 col-xl-8 offset-xl-2">
					<div class="card card-primary">
						<div class="card-header"><h4>회원가입</h4></div>
						<div class="card-body">
							<form role="form" method="POST" action="/memberRegist.do" name="formData" id="formData"
								  class="needs-validation was-validated" novalidate="" onsubmit="finalCheck();">
								<div class="row">
									<div class="form-group col-12">
										<label for="memberName">이름</label>
										<input id="memberName" type="text" class="form-control" name="memberName"
											   minlength="2" maxlength="8" required="" autofocus="">
										<div class="invalid-feedback">
											2~8 글자 내외의 이름을 입력해주세요
										</div>
									</div>
								</div>
								<div class="row">
									<div class="form-group col-8">
										<label for="loginId">아이디(로그인 아이디)</label>
										<input id="loginId" type="text" class="form-control" name="loginId" tabindex="1"
											   minlength="5" maxlength="15" required="" autofocus="">
										<div class="invalid-feedback" id="idRequired">
											영어 또는 영어+숫자 조합의 5~15 글자 내외의 아이디 입력해주세요
										</div>
									</div>
									<div class="form-group col-4">
										<label for="duplicateCheck">중복검사</label>
										<button type="button" class="form-control btn btn-primary btn-lg"
												id="duplicateCheck" onclick="duplicate(params={param : $('#loginId').val()})">
											<i class="fas fa-check-circle" style="line-height: 200%;"></i>
										</button>
									</div>
									<div class="custom-control custom-checkbox" style="display: none;">
										<input type="checkbox" id="duplicateBool">
									</div>
								</div>
								<div class="row">
									<div class="form-group col-12">
										<label for="loginPw" class="d-block">비밀번호</label>
										<input id="loginPw" style="-webkit-text-security:disc;"
											   class="form-control pwstrength" data-indicator="pwindicator" name="loginPw"
											   minlength="5" maxlength="15" required="" autofocus="">
										<div id="pwindicator" class="pwindicator">
											<div class="bar"></div>
											<div class="label"></div>
										</div>
										<div class="invalid-feedback" id="passRequired">
											5~15 글자 내외의 비밀번호를 입력해주세요
										</div>
									</div>
								</div>
								<div class="row">
									<div class="form-group col-12">
										<label for="pwConfirm" class="d-block">비밀번호 확인</label>
										<input id="pwConfirm" style="-webkit-text-security:disc;"
											   class="form-control" required="" autofocus="">
										<div class="invalid-feedback" id="confirmRequired">

										</div>
									</div>
								</div>
								<div class="form-divider">
									정보제공동의
								</div>
								<div class="row">
									<div class="form-group col-12">
										<div class="custom-control custom-checkbox">
											<input type="checkbox" name="agree" class="custom-control-input" id="agree1"
												   required="" autofocus="">
											<label class="custom-control-label" for="agree1">
												<strong>
													<a href="/coupon_web3rd.do?target=page1" style='text-decoration: underline; font-weight: bold;' target="_blank">
														이용약관 및 멤버십 유의사항</a>에 동의합니다. (필수)</strong>
											</label>
											<div class="invalid-feedback">
												필수 내용 동의 후 진행이 완료됩니다.
											</div>
										</div>
									</div>
									<div class="form-group col-12">
										<div class="custom-control custom-checkbox">
											<input type="checkbox" name="agree" class="custom-control-input" id="agree2"
												   required="" autofocus="">
											<label class="custom-control-label" for="agree2">
												<strong>
													<a href="/coupon_web3rd.do?target=page2" style='text-decoration: underline; font-weight: bold;' target="_blank">
														제휴사<->ooweat 간 개인정보 제공</a>에 동의합니다. (필수)</strong>
											</label>
											<div class="invalid-feedback">
												필수 내용 동의 후 진행이 완료됩니다.
											</div>
										</div>
									</div>
								</div>
								<input type="hidden" name="paramSeq" value="${groupSeq}"/>
								<input type="hidden" name="paramGroupSeq" value="${groupSeq}"/>
								<div class="form-group">
									<button type="submit" class="btn btn-primary btn-lg btn-block">
										회원가입
									</button>
								</div>
							</form>
						</div>
					</div>
				</div>
			</div>
		</div>
	</section>
</div>
<script type="text/javascript">
	$(function () {
		$("#loginId").keyup(function () {
			var regType1 = /^[A-Za-z0-9+]*$/;
			if (regType1.test($("#loginId").val())) {
				$("#idRequired").html("아이디가 조건에 맞지 않습니다");
			}
		});
		$("#loginPw").keyup(function() {
			var value = $(this).val();
			var password = $("#pwConfirm").val();

			if (value.length == 0) {
				$("#passRequired").html("비밀번호를 입력해주세요");
			} else if (value != password) {
				$("#confirmRequired").html("입력하신 비밀번호와 다릅니다.");
			}
		});
		$("#pwConfirm").keyup(function() {
			if ($(this).val() != $('#loginPw').val()) {
				$(this).get(0).setCustomValidity('패스워드가 동일합니다.');
			} else {
				$(this).get(0).setCustomValidity('');
			}
		});
	})
	function duplicate(params){
		var data = params.param;
		var regType = /^[a-zA-Z0-9]*$/;
		if(4<params.param.length){
			if (!regType.test(data)) {
				$("#idRequired").html("아이디가 조건에 맞지 않습니다");
				alert("아이디가 조건에 맞지 않습니다");
			}else{
				$.ajax({
					cache : false,
					url : '/duplicateCheck.do',
					type : 'POST',
					data : params,
					success : function(data) {
						if(data>0){
							Swal.fire({
								title: '<strong>중복검사</strong>',
								icon: 'error',
								html: '이미 존재하는 아이디 입니다!',
								showCloseButton: true,
								showCancelButton: false,
								focusConfirm: false,
								confirmButtonText: '확인',
								confirmButtonAriaLabel: 'Thumbs up, great!',
							}).then((result)=>{
								$("#loginId").val("");
							});
						}else{
							Swal.fire({
								title: '<strong>중복검사</strong>',
								text: "사용이 가능합니다!",
								icon: 'success',
								showCancelButton: true,
								confirmButtonColor: '#6777ef',
								cancelButtonColor: '#fc544b',
								confirmButtonText: '사용하기',
								cancelButtonText: '취소'
							}).then((result)=>{
								if(result.isConfirmed){
									$("#duplicateBool").attr('checked',true);
									$("#loginPw").focus();
								}else{
									$("#duplicateBool").attr('checked',false);
									$("#loginId").focus();
								}
							});
						}
					}, // success
					error : function(xhr, status) {
						alert(xhr + " : " + status);
					}
				});}
		}else{
			alert("5~15 글자 내외의 아이디 입력해주세요");
		}
	}
	function finalCheck(){
		if(!$("#duplicateBool").attr("checked")){
			alert("중복검사를 진행해주세요");
		}
	}
	function initRegister(){
		Swal.fire({
			title: '<strong>이미 계정이 있으신가요?</strong>',

			icon: 'question',
			showCancelButton: true,
			buttons: true,
			dangerMode: true,
			confirmButtonColor: '#fd6f6f',
			cancelButtonColor: '#6777ef',
			confirmButtonText: '네! 있어요 :)',
			cancelButtonText: '가입이 필요해요!'
		}).then((result)=>{
			if(result.isConfirmed){
				location.href="/login.do"
			}
		});
	}
</script>
</body>
</html>
