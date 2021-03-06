<%@codepage="949" language="VBScript"%>
<%
'--------------------------------------------------------------------
'   Comment		: 개인회원 가입
' 	History		: 2020-04-20, 이샛별 
'---------------------------------------------------------------------
Session.CodePage  = 949			'한글
Response.CharSet  = "euc-kr"	'한글
Response.AddHeader "Pragma","no-cache"
Response.AddHeader "cache-control", "no-staff"
Response.Expires  = -1
%>

<!--#include virtual = "/common/common.asp"-->

<%
'If Request.ServerVariables("HTTPS") = "off" Then 
'	Response.redirect "https://"& Request.ServerVariables("HTTP_HOST") & Request.ServerVariables("URL") 
'End If


If request.Cookies(site_code & "WKC_F")("comid")<>"" Or request.Cookies(site_code & "WKP_F")("id")<>"" Then 
	Response.Write "<script language=javascript>"&_
		"alert('로그인 상태에서는 해당 페이지에 접근할 수 없습니다.\n로그아웃 후 이용 바랍니다.');"&_
		"location.href='/';"&_
		"</script>"
	Response.End 
End If
%>

<!--#include virtual = "/include/header/header.asp"-->
<script type="text/javascript">
	// SMS 인증 번호 전송
	/* start */
	function fnAuthSms() {		
		if ($("#mobileAuthNumChk").val() == "4") {
			alert("인증이 완료되었습니다.");
			$("#ment_txtPhone").hide();
			return;
		}

		$("#hd_idx").val("");

		var strEmail;
		var contact = $("#txtPhone").val();

		if (Authchk_ing) {
			alert("처리중 입니다. 잠시만 기다려 주세요.");
		} else {
			if(contact=="“-” 생략하고 숫자만 입력해 주세요."){
				contact="";
			}

			if(contact==""){
				alert("연락처를 입력해 주세요.");
				$("#txtPhone").focus();
				return;
			}

			if(contact.length<10){
				alert("정확한 연락처를 입력해 주세요.");
				$("#txtPhone").focus();
				return;
			}	
			else {
				Authchk_ing = true;

				var strUrl = "https://app.career.co.kr/sms/career/Authentication";

				var parm = {};

				parm.authCode	= "1";		// sms:1 | email:2
				parm.authvalue	= $("#txtPhone").val();		// 핸드폰 no( - 는 입력 해도 되고 안해도 됩니다.)
				parm.sitename	= "<%=site_short_name%>";	// sms 발송시 해당 내용으로 입력 됩니다.
				parm.sitecode	= "37";		// sitecode(꼭 해당 사이트 코드를 입력하세요) 발송 log 및 email 발송시 구분합니다. => 코드 정의(커리어 : 2, 박람회 : 37)
				parm.memkind	= "개인";
				parm.ip			= "";		// 개인 IP
				parm.callback	= "jsonp_sms_callback";

				$("#aMobile").text("인증번호 재전송");
				$.ajax({
					url: strUrl
					, dataType: "jsonp"
					, type: "post"
					, data: parm
					, success: function (data) {
						//alert("sccess : " + data.length);
					}
					, error: function (jqXHR, textStatus, errorThrown) {
						//alert(textStatus + ", " + errorThrown);
					}
				});
			}
		}
	}

	// Result 처리는 이곳에서 합니다.
	function jsonp_sms_callback(data) {
		Authchk_ing = false;
		if ($.trim(data.result) == "true") {
			$("#mobileAuthNumChk").val("1");

			$("#timeCntdown").show();
			fnDpFirst();
			fncDpTm(); //카운트

			$("#hd_idx").val(data.result_idx);
			alert("인증번호가 발송되었습니다.");
			$("#rsltAuthArea").show();
			$("#mobileAuthNumber").val("");
			$("#mobileAuthNumber").focus();
			$("#hd_kind").val("1");
		} else {
			$("#timeCntdown").hide();
			$("#rsltAuthArea").hide();
			$("#emailAuthNumChk").val("0");
			alert("인증번호 발송이 실패하였습니다.");
		}
	}
	/* end */

	// 인증번호 확인
	/* start */
	function fnAuth() {
		if ($("#hd_kind").val() == "1" && $("#mobileAuthNumChk").val() == "4") {
			alert("인증이 완료되었습니다.");
			$("#ment_txtPhone").hide();
			return;

		} else if ($.trim($("#hd_idx").val()) == "") {
			alert("인증번호가 맞지 않습니다. 인증번호를 확인해 주세요.");
			return;
		}

		$("#mobileAuthNumber").val($.trim($("#mobileAuthNumber").val()));
		if  ($("#hd_kind").val() == "1") {
			if ($.trim($("#mobileAuthNumber").val()) == "") {
				alert("인증번호를 입력해 주세요.");
				$("#mobileAuthNumber").focus();
				return;
			}
		}

		var strUrl	= "https://app.career.co.kr/sms/career/AuthenticationResult";
		var parms	= {};

		var strAuthKey = "";
		if ($("#hd_kind").val() == "2") {
			strAuthKey = $("#emailAuthNumber").val();
		} else if ($("#hd_kind").val() == "1") {
			strAuthKey = $("#mobileAuthNumber").val();
		} else {
			return;
		}

		if ($.trim($("#hd_idx").val()) == "" || ($.trim($("#emailAuthNumber").val()) == "" && $.trim($("#mobileAuthNumber").val()) == "")) {
			return;
		}

		parms.authCode	= $("#hd_kind").val();	// sms:1 | email:2

		parms.authvalue	= strAuthKey;			// 발송된 인증 KEY Value

		parms.idx		= $("#hd_idx").val();	// 발송된 인증 번호
		parms.callback	= "jsonp_result_callback";
		$.ajax({
			url: strUrl
				, dataType: "jsonp"
				, type: "post"
				, data: parms
				, success: function (data) {
					alert("sccess : " + data);
				}
				, error: function (jqXHR, textStatus, errorThrown) {
					//alert(textStatus + ", " + errorThrown);
				}
		});
	}

	//Result 처리는 이곳에서 합니다.
	function jsonp_result_callback(data) {
		if ($("#hd_kind").val() == "1") {
			if ($.trim(data.result_idx) == "Y") {
				alert("인증이 완료되었습니다.");
				$("#mobileAuthNumChk").val("4");
				$("#authproc").val("1");
				$("#timeCntdown").hide();
				$("#ment_txtPhone").hide();

				$("#ment_auth").text("인증완료");
				$("#ment_auth").show();
			} else {
				alert("입력한 인증번호가 다릅니다.");
				$("#mobileAuthNumChk").val("3");
				$("#timeCntdown").show();

				$("#ment_auth").text("인증실패");
				$("#ment_auth").show();
			}
		}
	}
	/* end */

	var emailchk_ing	= false;
	var Authchk_ing		= false;

	var min = 60;
	var sec = 60;
	var ctm;			// 표시 시간
	var inputtime = 3;	// 입력분
	var tstop;			// 타이머 정지

	Number.prototype.dptm = function () { return this < 10 ? '0' + this : this; } //분에 "0" 넣기

	function fnDpFirst() {
		clearTimeout(tstop);
		ctm = sec * inputtime;
	}

	function fncDpTm() {
		var cmi = Math.floor((ctm % (min * sec)) / sec).dptm();
		var csc = Math.floor(ctm % sec).dptm();

		//document.getElementById("ctm1").innerText = cmi + ' : ' + csc; //값 보여줌
		//document.getElementById("").innerText = '남은시간 ' + cmi + ' : ' + csc; //값 보여줌
		$("#timeCntdown").text('(' + cmi + ' : ' + csc + ")");

		if ((ctm--) <= 0) {
			ctm = sec * inputtime;
			clearTimeout(tstop);
			//재전송버튼
			//인증시간 초과 meassage
		}
		else {
			tstop = setTimeout("fncDpTm()", 1000);
		}
	}
	
	// 인증번호 검증 함수 호출
	function fnAuthNoChk(){
		fnAuth();
	}	

	// 휴대폰번호 중복 가입 검증
	function fn_chkJoin(){
		if($("#txtPhone").val()=="“-” 생략하고 숫자만 입력해 주세요."){
			$("#txtPhone").val("");
		}

		if($("#txtPhone").val()==""){
			alert("연락처를 입력해 주세요.");
			$("#txtPhone").focus();
			return;
		}

		if($("#txtPhone").val().length<10){
			alert("정확한 연락처를 입력해 주세요.");
			$("#txtPhone").focus();
			return;
		} else {
			$.ajax({
				type: "POST"
				, url: "phone_CheckAll.asp"
				, data: { user_phone: $("#txtPhone").val() }
				, dataType: "text"					
				, async: true
				, success: function (data) {
					// 기존 등록된 휴대폰번호가 존재하면 X, 없으면 O
					if (data.trim() == "X") {
						alert("입력하신 휴대폰번호로 회원 가입된 내역이 존재합니다.\n아이디 찾기를 이용하여 기존 가입하신 계정을 확인해 주세요.\n(우측 최상단 개인로그인 클릭> ID 찾기 이동)");
						return;
					} else {
						fnAuthSms();
					}
				}
				, error: function (XMLHttpRequest, textStatus, errorThrown) {
					alert(XMLHttpRequest.responseText);
				}

			});
		}	
	}

	// 입력 값 체크
	function fn_sumbit(){
		var rdoStudent	= $(":input:radio[name=rdoStudent]:checked").val(); // 재학생/타대학생 구분
		var txtStuNo	= $("#txtStuNo").val();				// 학번
		var txtId		= $("#txtId").val();				// 아이디
		var txtPass		= $("#txtPass").val();				// 비번
		var txtPassChk	= $("#txtPassChk").val();			// 비번확인
		var	txtName		= $("#txtName").val();				// 이름

//		var	txtBirth	= $("#txtBirth").val();				// 생년월일
//		var txtEmail	= $("#txtEmail").val();				// 이메일

		var txtUnivNm	= $("#txtUnivNm").val();			// 학교
		var txtMajor	= $("#txtMajor").val();				// 학과
		var selGrad		= $("#selGrad").val();				// 졸업 및 재학여부
		var rdoGender	= $(":input:radio[name=rdoGender]:checked").val(); // 성별

		var txtPhone	= $("#txtPhone").val();				// 휴대폰
		var chkAgrPrv	= $("#agreeallPer").is(":checked");	// 이용약관 및 개인정보 수집 동의


		// 재학생/타대생 구분에 따라 아이디 입력 값 체크 제어
		if (rdoStudent == "1"){
			if(txtStuNo==""){
				$("#ment_txtStuNo").text("학번을 입력해 주세요.");
				$("#ment_txtStuNo").show();
				$("#txtStuNo").focus();
				return;
			} else {
				$("#ment_txtStuNo").hide();
			}

			if($("#id_check").val() != "1"){
				alert("아이디로 사용할 학번 정보를 다시 확인해 주세요.");
				$("#txtStuNo").focus();
				return;
			}

		}else{
			if(txtId==""){
				$("#ment_txtId").text("아이디를 입력해 주세요.");
				$("#ment_txtId").show();
				$("#txtId").focus();
				return;
			} else {
				$("#ment_txtId").hide();
			}

			if($("#id_check").val() != "1"){
				alert("아이디를 다시 확인해 주세요.");
				$("#txtId").focus();
				return;
			}
		}

		/*if(txtId==""){
			$("#ment_txtId").text("아이디를 입력해 주세요.");
			$("#ment_txtId").show();
			$("#txtId").focus();
			return;
		} else {
			$("#ment_txtId").hide();
		}

		if($("#id_check").val() != "1"){
			alert("아이디를 다시 확인해 주세요.");
			$("#txtId").focus();
			return;
		}*/

		if(txtPass==""){
			$("#ment_txtPass").text("비밀번호를 입력해 주세요.");
			$("#ment_txtPass").show();
			$("#txtPass").focus();
			return;
		} else {
			$("#ment_txtPass").hide();
		}		


		if (txtPass.length < 8 || txtPass.length > 32) {
			$("#ment_txtPass").text("비밀번호는 8~32자 까지만 허용됩니다.");
			$("#ment_txtPass").show();
			$("#txtPass").focus();
			return;
		}
		
		/*if (txtId != "" && txtPass.search(txtId) > -1) {
			$("#ment_txtPass").text("비밀번호에 아이디가 포함되어 있습니다.");
			$("#ment_txtPass").show();
			$("#txtPass").focus();
			return;
		}*/
			
		var pattern1 = /[0-9]/;		// 숫자 
		var pattern2 = /[a-zA-Z]/;	// 문자 
		var pattern3 = /[~!@#$%^&*()_+|<>?:{}]/; // 특수문자
							
		if(!pattern1.test(txtPass) || !pattern2.test(txtPass) || !pattern3.test(txtPass)) {
			$("#ment_txtPass").text("비밀번호는 영문, 숫자 및 특수문자의 조합으로 생성해야 합니다");
			$("#ment_txtPass").show();
			$("#txtPass").focus();
			return;
		}else{
			/*if(txtPass.search(txtId) > -1) {
				$("#ment_txtPass").text("비밀번호에 아이디가 포함되어 있습니다.");
				$("#ment_txtPass").show();
				$("#txtPass").focus();
				return false;
			}else{*/
				$("#ment_txtPass").hide("");
			//}
		}


		if($("#pw_box").text()!=""){
			$("#ment_txtPass").text("입력하신 비밀번호가 보안상 매우 취약합니다.\n8~32자까지 영문, 숫자, 특수문자 등의 조합으로\n아이디와 무관한 문자열을 입력해 주세요.");
			$("#ment_txtPass").show();
			$("#txtPass").focus();
			return;
		} else {
			$("#ment_txtPass").hide();
		}

		if(txtPassChk==""){
			$("#ment_txtPassChk").text("비밀번호 확인란을 입력해 주세요.");
			$("#ment_txtPassChk").show();
			$("#txtPassChk").focus();
			return;
		} else {
			$("#ment_txtPassChk").hide();
		}

		if(txtPassChk!=txtPass){
			$("#ment_txtPassChk").text("비밀번호와 비밀번호 확인란에 입력한 정보가\n일치하지 않습니다. 다시 확인해 주세요.");
			$("#ment_txtPassChk").show();
			$("#txtPassChk").focus();
			return;
		} else {
			$("#ment_txtPassChk").hide();
		}

		if(txtName==""){
			$("#ment_txtName").text("이름을 입력해 주세요.");
			$("#ment_txtName").show();
			$("#txtName").focus();
			return;
		} else {
			$("#ment_txtName").hide();
		}

/*	
		if(txtBirth == "") {
			$("#ment_txtBirth").text("생년월일을 입력해 주세요.");
			$("#ment_txtBirth").show();
			$("#txtBirth").focus();
			return;
		} else {
			$("#ment_txtBirth").hide();
		}


		var year = txtBirth.split(".")[0];
		var month = txtBirth.split(".")[1];
		var day = txtBirth.split(".")[2];
		var oDate = new Date();

		if (year < oDate.getFullYear() -100 || year > oDate.getFullYear() +100 || month < 1 || month > 12 || day < 1 || day > 31) {
			$("#ment_txtBirth").text("잘못된 생년월일 형식입니다.");
			$("#ment_txtBirth").show();
			return;
		} else {
			$("#ment_txtBirth").hide();
		}

	
		if($("#txtEmail").val() == "") {
			$("#ment_txtEmail").text("이메일을 입력해 주세요.");
			$("#ment_txtEmail").show();
			$("#txtEmail").focus();
			return;
		} else {
			$("#ment_txtEmail").hide();
		}

		if(! email_check(txtEmail) ) {
			$("#ment_txtEmail").text("잘못된 이메일 형식입니다.");
			$("#ment_txtEmail").show();
			return;
		}
		else {
			$("#ment_txtEmail").hide();
		}
*/

		if(txtMajor==""){
			$("#ment_txtMajor").text("학과를 입력해 주세요.");
			$("#ment_txtMajor").show();
			$("#txtMajor").focus();
			return;
		} else {
			$("#ment_txtMajor").hide();
		}

		if (rdoStudent == "2"){
			if (rdoGender == undefined){
				$("#ment_rdoGender").text("성별을 선택해 주세요.");
				$("#ment_rdoGender").show();
				return;
			} else {
				$("#ment_rdoGender").hide();
			}
		}

		if (rdoStudent == "2"){
			if(txtUnivNm==""){
				$("#ment_txtUnivNm").text("재학/졸업한 대학교를 입력해 주세요.");
				$("#ment_txtUnivNm").show();
				$("#txtUnivNm").focus();
				return;
			} else {
				$("#ment_txtUnivNm").hide();
			}
		}

		if(selGrad==""){
			$("#ment_selGrad").text("졸업 및 재학여부를 선택해 주세요.");
			$("#ment_selGrad").show();
			$("#selGrad").focus();
			return;
		} else {
			$("#ment_selGrad").hide();
		}


		if(txtPhone==""){
			$("#ment_txtPhone").text("휴대폰번호를 입력해 주세요.");
			$("#ment_txtPhone").show();
			$("#txtPhone").focus();
			return;
		} else {
			$("#ment_txtPhone").hide();
		}

		if ($("#mobileAuthNumChk").val() != "4") {
			alert("휴대폰번호를 인증해 주세요.");
			$("#ment_txtPhone").text("휴대폰번호를 인증해 주세요.");
			$("#ment_txtPhone").show();
			$("#mobileAuthNumber").focus();
			return;
		} else {
			$("#ment_txtPhone").hide();
		}

		if (!chkAgrPrv) {
			alert("개인정보 수집에 동의해 주세요.");
			return;
		}

		var obj=document.frm1;
		if(confirm('입력하신 정보로 참가신청 하시겠습니까?')) {
			obj.method = "post";
			obj.action = "join_individual_proc.asp";
			obj.submit();
		}

	}

	function onlyNumber(event){
		event = event || window.event;
		var keyID = (event.which) ? event.which : event.keyCode;
		if ( (keyID >= 48 && keyID <= 57) || (keyID >= 96 && keyID <= 105) || keyID == 8 || keyID == 46 || keyID == 37 || keyID == 39 ) 
			return;
		else
			return false;
	}

	function removeChar(event) {
		event = event || window.event;
		var keyID = (event.which) ? event.which : event.keyCode;
		if ( keyID == 8 || keyID == 46 || keyID == 37 || keyID == 39 ) 
			return;
		else
			event.target.value = event.target.value.replace(/[^0-9]/g, "");
	}

	/*아이디-학번 중복 체크 시작*/
	function fn_checkStuNo() {
		$("#id_box").text("");
		$("#id_check").val("0");

		if($("#txtStuNo").val() == "") {
			$("ment_txtStuNo").text("학번을 입력해 주세요.");
			$("ment_txtStuNo").show();
			$("#txtStuNo").focus();
			return;
		}else if(!Validchar($("#txtStuNo").val(), num + alpha)){
			$("ment_txtStuNo").text("학번은 한글 및 특수문자를 지원하지 않습니다. 다시 입력해 주세요.");
			$("ment_txtStuNo").show();
			$("#txtStuNo").focus();
			return;
		}else if($("#txtStuNo").val().length < 6){
			$("ment_txtStuNo").text("학번은 7자 이상이어야 합니다.");
			$("ment_txtStuNo").show();
			return;
		}else{
			$.ajax({
				type: "POST"
				, url: "Id_CheckAll.asp"
				, data: { user_id: $("#txtStuNo").val() }
				, dataType: "text"					
				, async: true
				, success: function (data) {
					// 기존 등록된 아이디가 존재하면 X, 없으면 O
					if (data.trim() == "X") {
						//$("#id_box").addClass('bad').removeClass('good');
						$("ment_txtStuNo").text("탈퇴한 아이디 또는 이미 사용중인 아이디로, 이용하실 수 없습니다.");
						$("ment_txtStuNo").show();
						return;
					} else {
						$("#id_check").val("1");
						$("#chk_id").val($("#txtStuNo").val());
						//$("#id_box").addClass('good').removeClass('bad');
						//$("ment_txtStuNo").text("사용 가능한 아이디입니다.");
						$("ment_txtStuNo").hide();
						return;
					}
				}
				, error: function (XMLHttpRequest, textStatus, errorThrown) {
					alert(XMLHttpRequest.responseText);
				}

			});
		}
	}
	/*아이디-학번 중복 체크 끝*/

	/*아이디 중복 체크 시작*/
	function fn_checkID() {
		$("#txtId").val($("#txtId").val().toLowerCase());

		$("#id_box").text("");
		$("#id_check").val("0");

		var checkNumber		= $("#txtId").val().search(/[0-9]/g);	// 숫자 입력 체크
		var checkEnglish	= $("#txtId").val().search(/[a-z]/ig);	// 영문 입력 체크

		if($("#txtId").val() == "") {
			$("#ment_txtId").text("아이디를 입력해 주세요.");
			$("#ment_txtId").show();
			$("#txtId").focus();
			return;
		}else if(!Validchar($("#txtId").val(), num + alpha)){
			$("#ment_txtId").text("아이디는 한글 및 특수문자를 지원하지 않습니다. 다시 입력해 주세요.");
			$("#ment_txtId").show();
			$("#txtId").focus();
			return;
		}else if($("#txtId").val().length < 5){
			$("#ment_txtId").text("아이디는 최소 5자 이상이어야 합니다.");
			$("#ment_txtId").show();
			return;
		}else if(checkNumber <0 || checkEnglish <0){
			$("#ment_txtId").text("영문과 숫자를 혼용하여 입력해 주세요.");
			$("#ment_txtId").show();
			return;
		}else{
			if (/(\w)\1\1\1/.test($("#txtId").val())){	// 같은형식 문자 4글자 이상 사용 금지
				$("#ment_txtId").text("동일한 문자 연속 4글자 이상은 사용 금지합니다.");
				$("#ment_txtId").show();
				return;
			} else {
				$.ajax({
					type: "POST"
					, url: "Id_CheckAll.asp"
					, data: { user_id: $("#txtId").val() }
					, dataType: "text"					
					, async: true
					, success: function (data) {
						// 기존 등록된 아이디가 존재하면 X, 없으면 O
						if (data.trim() == "X") {
							//$("#id_box").addClass('bad').removeClass('good');
							$("#ment_txtId").text("탈퇴한 아이디 또는 이미 사용중인 아이디로, 이용하실 수 없습니다.");
							$("#ment_txtId").show();
							return;
						} else {
							$("#id_check").val("1");
							$("#chk_id").val($("#txtId").val());
							//$("#id_box").addClass('good').removeClass('bad');
							//$("#ment_txtId").text("사용 가능한 아이디입니다.");
							$("#ment_txtId").hide();
							return;
						}
					}
					, error: function (XMLHttpRequest, textStatus, errorThrown) {
						alert(XMLHttpRequest.responseText);
					}

				});
			}
		}
	}
	/*아이디 중복 체크 끝*/
	
	/*비밀번호 체크 시작*/
	function fn_checkPW() {
		var chk = false;
		var id	= $("#txtId").val();
		if ($('#txtPass').val().length == 0 ) {
			return;
		} else {
			if ($('#txtPass').val().length < 8 || $('#txtPass').val().length > 32) {
				$("#ment_txtPass").text("비밀번호는 8~32자 까지만 허용됩니다.");
				$("#ment_txtPass").show();
				return false;
			}
			/*
			if (id != "" && $('#txtPass').val().search(id) > -1) {
				$("#ment_txtPass").text("비밀번호에 아이디가 포함되어 있습니다.");
				$("#ment_txtPass").show();
				return false;
			}*/
				
			var pattern1 = /[0-9]/;		// 숫자 
			var pattern2 = /[a-zA-Z]/;	// 문자 
			var pattern3 = /[~!@#$%^&*()_+|<>?:{}]/; // 특수문자
								
			//if (!$('#txtPass').val().match(/([a-zA-Z0-9].*[!,@,#,$,%,^,&,*,?,_,~])|([!,@,#,$,%,^,&,*,?,_,~].*[a-zA-Z0-9])/)) {
			//if (!$('#txtPass').val().match(/^.*(?=.{6,20})(?=.*[0-9])(?=.*[a-zA-Z]).*$/)) {
			//if (!/^(?=.*[a-zA-Z])(?=.*[!@#$%^*+=-])(?=.*[0-9]).{8,25}$/.test($('#txtPass').val())) {
			if(!pattern1.test($('#txtPass').val()) || !pattern2.test($('#txtPass').val()) || !pattern3.test($('#txtPass').val())) {
				$("#ment_txtPass").text("비밀번호는 영문, 숫자 및 특수문자의 조합으로 생성해야 합니다");
				$("#ment_txtPass").show();
				return;
			}else{
				/*if($('#txtPass').val().search(id) > -1) {
					$("#ment_txtPass").text("비밀번호에 아이디가 포함되어 있습니다.");
					$("#ment_txtPass").show();
					return false;
				}else{*/
					$("#ment_txtPass").hide("");
				//}
			}
		}

		if ($('#txtPassChk').val().split(" ").join("") == "") {
			$("#ment_txtPassChk").text("비밀번호 확인을 입력해 주세요.");
			$("#ment_txtPassChk").show();
			return;
		} 

		if ($('#txtPass').val() != $('#txtPassChk').val()) {
			$("#ment_txtPassChk").text("비밀번호가 일치하지 않습니다.");
			$("#ment_txtPassChk").show();
			return;
		} else {
			$("#ment_txtPass").hide();
			$("#ment_txtPassChk").hide();
		}
		return chk;
	}
	/*비밀번호 체크 끝*/

	/*이메일 체크 시작*/
	function email_check( email ) {    
		var regex=/([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/;
		return (email != '' && email != 'undefined' && regex.test(email)); 
	}

	// check when email input lost foucus
	function fn_checkMail() {
	  var email = $("#txtEmail").val();

	  // if value is empty then exit
	  if( email == '' || email == 'undefined') return;

	  // valid check
	  if(! email_check(email) ) {
		$("#ment_txtEmail").text("잘못된 이메일 형식입니다.");
		$("#ment_txtEmail").show();
		return false;
	  }
	  else {
		$("#ment_txtEmail").hide();
		return false;
	  }
	}
	/*이메일 체크 끝*/

	function fn_checkBirth() {
		var birth = $("#txtBirth").val();
		if (birth == '' || birth == 'undefined') return;

		if (birth.length < 10) {
			$("#ment_txtBirth").text("잘못된 생년월일 형식입니다.");
			$("#ment_txtBirth").show();
			return;
		} else {
			$("#ment_txtBirth").hide();
		}
		
		var year = birth.split(".")[0];
		var month = birth.split(".")[1];
		var day = birth.split(".")[2];
		var oDate = new Date();

		if (year < oDate.getFullYear() -100 || year > oDate.getFullYear() +100 || month < 1 || month > 12 || day < 1 || day > 31) {
			$("#ment_txtBirth").text("잘못된 생년월일 형식입니다.");
			$("#ment_txtBirth").show();
		} else {
			$("#ment_txtBirth").hide();
		}

	}

	// 이름 입력 여부 체크
	function fn_checkNm() {
		if($("#txtName").val()==""){
			$("#ment_txtName").text("이름을 입력해 주세요.");
			$("#ment_txtName").show();
			$("#txtName").focus();
			return;
		} else {
			$("#ment_txtName").hide();
		}
	}

	// 학과정보 입력 여부 체크	
	function fn_checkMajor() {
		if($("#txtMajor").val()==""){
			$("#ment_txtMajor").text("학과를 입력해 주세요.");
			$("#ment_txtMajor").show();
			$("#txtMajor").focus();
			return;
		} else {
			$("#ment_txtMajor").hide();
		}	
	}

	// 휴대폰번호 입력 여부 체크	
	function fn_checkPhone() {
		if($("#txtPhone").val()==""){
			$("#ment_txtPhone").text("휴대폰번호를 입력해 주세요.");
			$("#ment_txtPhone").show();
			$("#txtPhone").focus();
			return;
		} else {
			$("#ment_txtPhone").hide();
		}

		if ($("#mobileAuthNumChk").val() != "4") {
			$("#ment_txtPhone").text("휴대폰번호를 인증해 주세요.");
			$("#ment_txtPhone").show();
			$("#txtPhone").focus();
			return;
		} else {
			$("#ment_txtPhone").hide();
		}
	}
	
	// 입력값 체크
	$(document).ready(function () {
		//$("#txtPass").val("");
		//$("#frm1")[0].reset();

		//아이디 중복 체크 - 학번(재학생일 경우)
		$("#txtStuNo").bind("keyup keydown", function () {
			fn_checkStuNo();
		});
		
		//아이디 중복 체크
		$("#txtId").bind("keyup keydown", function () {
			fn_checkID();
		});

		// 비번 유효성 체크
		$("#txtPass").bind("keyup keydown", function () {
//			$(this).attr('type', 'password'); 
			fn_checkPW();
		});

		// 비번 재확인 유효성 체크
		$("#txtPassChk").bind("keyup keydown", function () {
			fn_checkPW();
		});

		// 이름 입력 유무 체크
		$("#txtName").bind("keyup keydown", function () {
			fn_checkNm();
		});

		// 학과 입력 유무 체크
		$("#txtMajor").bind("keyup keydown", function () {
			fn_checkMajor();
		});

		// 휴대폰번호 입력 유무 체크
		$("#txtPhone").bind("keyup keydown", function () {
			fn_checkPhone();
		});

/*	
		// 이메일 주소 유효성 체크
		$("#txtEmail").bind("keyup keydown", function () {
			fn_checkMail();
		});

		// 생년월일 유효성 체크
		$("#txtBirth").bind("keyup", function() {
			fn_checkBirth();
		});
*/

	});

	// 졸업 및 재학여부 선택 값에 따라 입력 문구 표기
	function chageSelect(cd){	
		var gradCd = $(cd).val();

		if(gradCd==""){
			$("#ment_selGrad").text("졸업 및 재학여부를 선택해 주세요.");
			$("#ment_selGrad").show();
			$("#selGrad").focus();
			return;
		} else {
			$("#ment_selGrad").hide();
		}		
	}
</script>
</head>

<body id="membersWrap">
<!-- 상단 -->
<!--#include virtual = "/include/gnb/topMenu.asp"-->
<!-- 상단 -->


<!-- 컨텐츠 -->
<div id="contents" class="util">
	<div class="content sign_up">
		<div class="input_area">
			<div class="tit">
				<h3>참가신청</h3>
			</div>
			<div class="sign_up">

				<form method="post" name="frm1" autocomplete="off">
				<input type="hidden" name="id_check" id="id_check" value="" /><!-- 아이디 검증 여부(0/1) -->
				<input type="hidden" name="chk_id" id="chk_id" value=""><!-- 사용(입력) 아이디 -->
				<input type="hidden" name="hd_idx" id="hd_idx" value="" /><!-- 번호인증 idx -->
				<input type="hidden" name="mobileAuthNumChk" id="mobileAuthNumChk" value="0" />
				<input type="hidden" name="hd_kind" id="hd_kind" value="2" />
				<input type="hidden" name="authproc" id="authproc" value="" />

				<div class="rdi_box">
					<label class="radiobox">
						<input type="radio" class="rdi" name="rdoStudent" value="1" checked>
						<span>재학생</span>
					</label>
					<label class="radiobox">
						<input type="radio" class="rdi" name="rdoStudent" value="2">
						<span>타 대학생</span>
					</label>
					<script>
					$(document).ready(function(){
						$('#chkGenderArea').hide();
						$('#chkUnivArea').hide();
						$('#chkIdArea2').hide();	
						$("input:radio[name=rdoStudent]").click(function(){
							if($("input[name=rdoStudent]:checked").val() == "1"){
								$('#chkIdArea1').show();
								$('#chkIdArea2').hide();
								$('#chkUnivArea').hide();
								$('#chkGenderArea').hide();
							}else if($("input[name=rdoStudent]:checked").val() == "2"){
								$('#chkIdArea1').hide();
								$('#chkIdArea2').show();
								$('#chkUnivArea').show();
								$('#chkGenderArea').show();
							}
						});
					});
					</script>
				</div>

				<table class="tb">
					<colgroup>
						<col style="width:140px" />
						<col />
					</colgroup>
					<tbody>
						<tr class="stu_id" id="chkIdArea1">
							<th><span class="pil">필수</span>학번</th>
							<td>
								<input type="text" class="txt" id="txtStuNo" name="txtStuNo" maxlength="10" placeholder="학번를 입력해 주세요.">
								<p class="ment" id="ment_txtStuNo" style="display:none;"></p>
							</td>
						</tr>
						<tr class="id" id="chkIdArea2">
							<th><span class="pil">필수</span>아이디</th>
							<td>
								<input type="text" class="txt" id="txtId" name="txtId" maxlength="12" placeholder="아이디 (5~12자 영문, 숫자 입력)">
								<p class="ment" id="ment_txtId" style="display:none;"></p>
							</td>
						</tr>
						<tr>
							<th><span class="pil">필수</span>비밀번호</th>
							<td class="pass">
								<input type="password" class="txt" id="txtPass" name="txtPass" maxlength="32" placeholder="비밀번호 (8~32자 영문, 숫자, 특수문자 입력)">
								<span class="ment2" id="capslockMsg" style="display:none;">CapsLock is on</span>
								<p class="ment" id="ment_txtPass" style="display:none;"></p>
							</td>
						</tr>

						<tr>
							<th><span class="pil">필수</span>비밀번호(확인)</th>
							<td class="pass">
								<input type="password" class="txt" id="txtPassChk" name="txtPassChk" maxlength="32" placeholder="비밀번호 확인">
								<span class="ment2" id="capslockMsg2" style="display:none;">CapsLock is on</span>
								<p class="ment" id="ment_txtPassChk" style="display:none;"></p>
							</td>
						</tr>
						<tr>
							<th><span class="pil">필수</span>이름(실명)</th>
							<td>
								<input type="text" class="txt" id="txtName" name="txtName" maxlength="10" placeholder="이름 (실명입력)">
								<p class="ment" id="ment_txtName" style="display:none;"></p>
							</td>
						</tr>
						
						<!-- 생일, 이메일 항목 제외 -->
						<tr style="display:none;">
							<th>생년월일</th>
							<td>
								<input type="text" class="txt" id="txtBirth" name="txtBirth" maxlength="10" placeholder="생년월일 ex) yyyy.mm.dd" onkeyup="numCheck(this, 'int'); changeBirthType(this);">
								<p class="ment" id="ment_txtBirth" style="display:none;"></p>
							</td>
						</tr>
						<tr style="display:none;">
							<th>E-mail</th>
							<td>
								<input type="text" class="txt" id="txtEmail" name="txtEmail" maxlength="100" placeholder="이메일 주소">
								<p class="ment" id="ment_txtEmail" style="display:none;"></p>
							</td>
						</tr>
					
						<tr>
							<th><span class="pil">필수</span>학과</th>
							<td>
								<input type="text" class="txt" id="txtMajor" name="txtMajor" maxlength="20" placeholder="학과를 입력해 주세요.">
								<p class="ment" id="ment_txtMajor" style="display:none;">학과를 입력해 주세요.</p>
							</td>
						</tr>

						<tr class="gender" id="chkGenderArea">
							<th><span class="pil">필수</span>성별</th>
							<td>
								<div class="rdi_box tb">
									<label class="radiobox" for="rdoGender1">
										<input type="radio" class="rdi" id="rdoGender1" name="rdoGender" value="1">
										<span>남학생</span>
									</label>
									<label class="radiobox" for="rdoGender2">
										<input type="radio" class="rdi" id="rdoGender2" name="rdoGender" value="2">
										<span>여학생</span>
									</label>	
								</div>
								<p class="ment" id="ment_rdoGender" style="display:none;">성별을 입력해 주세요.</p>
							</td>
						</tr>
						<tr class="school_name" id="chkUnivArea">
							<th><span class="pil">필수</span>학교명</th>
							<td>
								<input type="text" class="txt" id="txtUnivNm" name="txtUnivNm" maxlength="20" placeholder="타 대학 학교명을 입력해 주세요.">
								<p class="ment" id="ment_txtUnivNm" style="display:none;">학교를 입력해 주세요.</p>
							</td>
						</tr>

						<tr>
							<th><span class="pil">필수</span>졸업 및 재학여부</th>
							<td>
								<span class="selectbox" style="width:206px;">
									<span class="">선택</span>
									<select id="selGrad" name="selGrad" title="졸업 및 재학여부" onchange="chageSelect(this);">
										<option value="">선택</option>
										<option value="1">졸업</option>
										<option value="2">졸업예정(4학년)</option>
										<option value="3">재학중</option>
										<!-- <option value="4">중퇴</option>
										<option value="5">자퇴</option> -->
										<option value="6">기타</option>
									</select>
								</span>
								<br>
								<p class="ment" id="ment_selGrad" style="display:none;">졸업 및 재학여부를 선택해 주세요.</p>
							</td>
						</tr>

						<tr>
							<th rowspan="2"><span class="pil">필수</span>휴대폰번호</th>
							<td class="call">
								<div class="number_box">
									<input type="text" class="txt" id="txtPhone" name="txtPhone" maxlength="13" placeholder="휴대폰번호" onkeyup="removeChar(event); changePhoneType(this);" onkeydown="return onlyNumber(event)">
									<button type="button" id="aMobile" onclick="fn_chkJoin(); return false;" style="cursor:pointer">인증번호 전송</button>
									<p class="ment" id="ment_txtPhone" style="display:none;"></p>
								</div>
								<div class="number_box" id="rsltAuthArea" style="display:none;">
									<input type="text" class="txt" id="mobileAuthNumber" name="mobileAuthNumber" maxlength="6" onkeyup="removeChar(event)" onkeydown="return onlyNumber(event)" placeholder="인증번호">
									<span class="time" id="timeCntdown" style="display:none;">(03:00)</span>
									<button type="button" onclick="fnAuthNoChk(); return false;" style="cursor:pointer">인증하기</button>
									<span class="cite" id="ment_auth" style="display:none">인증완료</span>
								</div>
							</td>
						</tr>
					</tbody>
				</table>
				<dl class="agree_dl">
					<dt>개인정보 수집동의</dt>
					<dd>
						개인정보 수집목적 : 본인여부 확인<br>
						개인정보 수집항목 : 이름, 휴대폰 번호, 학과, 졸업 및 재학 여부<br>
						개인정보 파기 : 행사 종료 후 파기
					</dd>
				</dl>
				<div class="chk_area">
					<label class="checkbox off" for="agreeallPer">
						<input class="chk" id="agreeallPer" name="agreeallPer" type="checkbox">
						<span><%=site_name%> 개인정보 수집에 동의합니다.</span>
					</label>	
				</div>
				<div class="btn_area">
					<a href="javascript:" onclick="fn_sumbit();" class="btn blue">참가신청 완료</a>
					<!-- <a href="/" class="btn gray">취소</a> -->
				</div>

				</form>

			</div><!-- sign_up -->
		</div>
	</div><!-- //content -->
</div><!-- //contents -->
<!--// 컨텐츠 -->


<!-- 하단 -->
<!--#include virtual = "/include/footer/footer.asp"-->
<!-- 하단 -->

</body>
</html>
<script type="text/javascript">
<!--
	// 캡스락 체크
	var txtPass		= document.getElementById("txtPass");
	var txtPassChk	= document.getElementById("txtPassChk");
	var capslockMsg	= document.getElementById("capslockMsg");	// capslock state return
	var capslockMsg2= document.getElementById("capslockMsg2");	// capslock state return

	txtPass.addEventListener("keyup", function(event) {
		if (event.getModifierState("CapsLock")) {
			capslockMsg.style.display	= "block";
		} else {
			capslockMsg.style.display	= "none";
		}		
	});

	txtPassChk.addEventListener("keyup", function(event) {
		if (event.getModifierState("CapsLock")) {
			capslockMsg2.style.display	= "block";
		} else {
			capslockMsg2.style.display	= "none";
		}
	});
//-->
</script>