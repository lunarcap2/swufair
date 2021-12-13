<%@codepage="949" language="VBScript"%>
<%
'--------------------------------------------------------------------
'   Comment		: ����ȸ�� ����
' 	History		: 2020-04-20, �̻��� 
'---------------------------------------------------------------------
Session.CodePage  = 949			'�ѱ�
Response.CharSet  = "euc-kr"	'�ѱ�
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
		"alert('�α��� ���¿����� �ش� �������� ������ �� �����ϴ�.\n�α׾ƿ� �� �̿� �ٶ��ϴ�.');"&_
		"location.href='/';"&_
		"</script>"
	Response.End 
End If
%>

<!--#include virtual = "/include/header/header.asp"-->
<script type="text/javascript">
	// SMS ���� ��ȣ ����
	/* start */
	function fnAuthSms() {		
		if ($("#mobileAuthNumChk").val() == "4") {
			alert("������ �Ϸ�Ǿ����ϴ�.");
			$("#ment_txtPhone").hide();
			return;
		}

		$("#hd_idx").val("");

		var strEmail;
		var contact = $("#txtPhone").val();

		if (Authchk_ing) {
			alert("ó���� �Դϴ�. ��ø� ��ٷ� �ּ���.");
		} else {
			if(contact=="��-�� �����ϰ� ���ڸ� �Է��� �ּ���."){
				contact="";
			}

			if(contact==""){
				alert("����ó�� �Է��� �ּ���.");
				$("#txtPhone").focus();
				return;
			}

			if(contact.length<10){
				alert("��Ȯ�� ����ó�� �Է��� �ּ���.");
				$("#txtPhone").focus();
				return;
			}	
			else {
				Authchk_ing = true;

				var strUrl = "https://app.career.co.kr/sms/career/Authentication";

				var parm = {};

				parm.authCode	= "1";		// sms:1 | email:2
				parm.authvalue	= $("#txtPhone").val();		// �ڵ��� no( - �� �Է� �ص� �ǰ� ���ص� �˴ϴ�.)
				parm.sitename	= "<%=site_short_name%>";	// sms �߼۽� �ش� �������� �Է� �˴ϴ�.
				parm.sitecode	= "37";		// sitecode(�� �ش� ����Ʈ �ڵ带 �Է��ϼ���) �߼� log �� email �߼۽� �����մϴ�. => �ڵ� ����(Ŀ���� : 2, �ڶ�ȸ : 37)
				parm.memkind	= "����";
				parm.ip			= "";		// ���� IP
				parm.callback	= "jsonp_sms_callback";

				$("#aMobile").text("������ȣ ������");
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

	// Result ó���� �̰����� �մϴ�.
	function jsonp_sms_callback(data) {
		Authchk_ing = false;
		if ($.trim(data.result) == "true") {
			$("#mobileAuthNumChk").val("1");

			$("#timeCntdown").show();
			fnDpFirst();
			fncDpTm(); //ī��Ʈ

			$("#hd_idx").val(data.result_idx);
			alert("������ȣ�� �߼۵Ǿ����ϴ�.");
			$("#rsltAuthArea").show();
			$("#mobileAuthNumber").val("");
			$("#mobileAuthNumber").focus();
			$("#hd_kind").val("1");
		} else {
			$("#timeCntdown").hide();
			$("#rsltAuthArea").hide();
			$("#emailAuthNumChk").val("0");
			alert("������ȣ �߼��� �����Ͽ����ϴ�.");
		}
	}
	/* end */

	// ������ȣ Ȯ��
	/* start */
	function fnAuth() {
		if ($("#hd_kind").val() == "1" && $("#mobileAuthNumChk").val() == "4") {
			alert("������ �Ϸ�Ǿ����ϴ�.");
			$("#ment_txtPhone").hide();
			return;

		} else if ($.trim($("#hd_idx").val()) == "") {
			alert("������ȣ�� ���� �ʽ��ϴ�. ������ȣ�� Ȯ���� �ּ���.");
			return;
		}

		$("#mobileAuthNumber").val($.trim($("#mobileAuthNumber").val()));
		if  ($("#hd_kind").val() == "1") {
			if ($.trim($("#mobileAuthNumber").val()) == "") {
				alert("������ȣ�� �Է��� �ּ���.");
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

		parms.authvalue	= strAuthKey;			// �߼۵� ���� KEY Value

		parms.idx		= $("#hd_idx").val();	// �߼۵� ���� ��ȣ
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

	//Result ó���� �̰����� �մϴ�.
	function jsonp_result_callback(data) {
		if ($("#hd_kind").val() == "1") {
			if ($.trim(data.result_idx) == "Y") {
				alert("������ �Ϸ�Ǿ����ϴ�.");
				$("#mobileAuthNumChk").val("4");
				$("#authproc").val("1");
				$("#timeCntdown").hide();
				$("#ment_txtPhone").hide();

				$("#ment_auth").text("�����Ϸ�");
				$("#ment_auth").show();
			} else {
				alert("�Է��� ������ȣ�� �ٸ��ϴ�.");
				$("#mobileAuthNumChk").val("3");
				$("#timeCntdown").show();

				$("#ment_auth").text("��������");
				$("#ment_auth").show();
			}
		}
	}
	/* end */

	var emailchk_ing	= false;
	var Authchk_ing		= false;

	var min = 60;
	var sec = 60;
	var ctm;			// ǥ�� �ð�
	var inputtime = 3;	// �Էº�
	var tstop;			// Ÿ�̸� ����

	Number.prototype.dptm = function () { return this < 10 ? '0' + this : this; } //�п� "0" �ֱ�

	function fnDpFirst() {
		clearTimeout(tstop);
		ctm = sec * inputtime;
	}

	function fncDpTm() {
		var cmi = Math.floor((ctm % (min * sec)) / sec).dptm();
		var csc = Math.floor(ctm % sec).dptm();

		//document.getElementById("ctm1").innerText = cmi + ' : ' + csc; //�� ������
		//document.getElementById("").innerText = '�����ð� ' + cmi + ' : ' + csc; //�� ������
		$("#timeCntdown").text('(' + cmi + ' : ' + csc + ")");

		if ((ctm--) <= 0) {
			ctm = sec * inputtime;
			clearTimeout(tstop);
			//�����۹�ư
			//�����ð� �ʰ� meassage
		}
		else {
			tstop = setTimeout("fncDpTm()", 1000);
		}
	}
	
	// ������ȣ ���� �Լ� ȣ��
	function fnAuthNoChk(){
		fnAuth();
	}	

	// �޴�����ȣ �ߺ� ���� ����
	function fn_chkJoin(){
		if($("#txtPhone").val()=="��-�� �����ϰ� ���ڸ� �Է��� �ּ���."){
			$("#txtPhone").val("");
		}

		if($("#txtPhone").val()==""){
			alert("����ó�� �Է��� �ּ���.");
			$("#txtPhone").focus();
			return;
		}

		if($("#txtPhone").val().length<10){
			alert("��Ȯ�� ����ó�� �Է��� �ּ���.");
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
					// ���� ��ϵ� �޴�����ȣ�� �����ϸ� X, ������ O
					if (data.trim() == "X") {
						alert("�Է��Ͻ� �޴�����ȣ�� ȸ�� ���Ե� ������ �����մϴ�.\n���̵� ã�⸦ �̿��Ͽ� ���� �����Ͻ� ������ Ȯ���� �ּ���.\n(���� �ֻ�� ���ηα��� Ŭ��> ID ã�� �̵�)");
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

	// �Է� �� üũ
	function fn_sumbit(){
		var rdoStudent	= $(":input:radio[name=rdoStudent]:checked").val(); // ���л�/Ÿ���л� ����
		var txtStuNo	= $("#txtStuNo").val();				// �й�
		var txtId		= $("#txtId").val();				// ���̵�
		var txtPass		= $("#txtPass").val();				// ���
		var txtPassChk	= $("#txtPassChk").val();			// ���Ȯ��
		var	txtName		= $("#txtName").val();				// �̸�

//		var	txtBirth	= $("#txtBirth").val();				// �������
//		var txtEmail	= $("#txtEmail").val();				// �̸���

		var txtUnivNm	= $("#txtUnivNm").val();			// �б�
		var txtMajor	= $("#txtMajor").val();				// �а�
		var selGrad		= $("#selGrad").val();				// ���� �� ���п���
		var rdoGender	= $(":input:radio[name=rdoGender]:checked").val(); // ����

		var txtPhone	= $("#txtPhone").val();				// �޴���
		var chkAgrPrv	= $("#agreeallPer").is(":checked");	// �̿��� �� �������� ���� ����


		// ���л�/Ÿ��� ���п� ���� ���̵� �Է� �� üũ ����
		if (rdoStudent == "1"){
			if(txtStuNo==""){
				$("#ment_txtStuNo").text("�й��� �Է��� �ּ���.");
				$("#ment_txtStuNo").show();
				$("#txtStuNo").focus();
				return;
			} else {
				$("#ment_txtStuNo").hide();
			}

			if($("#id_check").val() != "1"){
				alert("���̵�� ����� �й� ������ �ٽ� Ȯ���� �ּ���.");
				$("#txtStuNo").focus();
				return;
			}

		}else{
			if(txtId==""){
				$("#ment_txtId").text("���̵� �Է��� �ּ���.");
				$("#ment_txtId").show();
				$("#txtId").focus();
				return;
			} else {
				$("#ment_txtId").hide();
			}

			if($("#id_check").val() != "1"){
				alert("���̵� �ٽ� Ȯ���� �ּ���.");
				$("#txtId").focus();
				return;
			}
		}

		/*if(txtId==""){
			$("#ment_txtId").text("���̵� �Է��� �ּ���.");
			$("#ment_txtId").show();
			$("#txtId").focus();
			return;
		} else {
			$("#ment_txtId").hide();
		}

		if($("#id_check").val() != "1"){
			alert("���̵� �ٽ� Ȯ���� �ּ���.");
			$("#txtId").focus();
			return;
		}*/

		if(txtPass==""){
			$("#ment_txtPass").text("��й�ȣ�� �Է��� �ּ���.");
			$("#ment_txtPass").show();
			$("#txtPass").focus();
			return;
		} else {
			$("#ment_txtPass").hide();
		}		


		if (txtPass.length < 8 || txtPass.length > 32) {
			$("#ment_txtPass").text("��й�ȣ�� 8~32�� ������ ���˴ϴ�.");
			$("#ment_txtPass").show();
			$("#txtPass").focus();
			return;
		}
		
		/*if (txtId != "" && txtPass.search(txtId) > -1) {
			$("#ment_txtPass").text("��й�ȣ�� ���̵� ���ԵǾ� �ֽ��ϴ�.");
			$("#ment_txtPass").show();
			$("#txtPass").focus();
			return;
		}*/
			
		var pattern1 = /[0-9]/;		// ���� 
		var pattern2 = /[a-zA-Z]/;	// ���� 
		var pattern3 = /[~!@#$%^&*()_+|<>?:{}]/; // Ư������
							
		if(!pattern1.test(txtPass) || !pattern2.test(txtPass) || !pattern3.test(txtPass)) {
			$("#ment_txtPass").text("��й�ȣ�� ����, ���� �� Ư�������� �������� �����ؾ� �մϴ�");
			$("#ment_txtPass").show();
			$("#txtPass").focus();
			return;
		}else{
			/*if(txtPass.search(txtId) > -1) {
				$("#ment_txtPass").text("��й�ȣ�� ���̵� ���ԵǾ� �ֽ��ϴ�.");
				$("#ment_txtPass").show();
				$("#txtPass").focus();
				return false;
			}else{*/
				$("#ment_txtPass").hide("");
			//}
		}


		if($("#pw_box").text()!=""){
			$("#ment_txtPass").text("�Է��Ͻ� ��й�ȣ�� ���Ȼ� �ſ� ����մϴ�.\n8~32�ڱ��� ����, ����, Ư������ ���� ��������\n���̵�� ������ ���ڿ��� �Է��� �ּ���.");
			$("#ment_txtPass").show();
			$("#txtPass").focus();
			return;
		} else {
			$("#ment_txtPass").hide();
		}

		if(txtPassChk==""){
			$("#ment_txtPassChk").text("��й�ȣ Ȯ�ζ��� �Է��� �ּ���.");
			$("#ment_txtPassChk").show();
			$("#txtPassChk").focus();
			return;
		} else {
			$("#ment_txtPassChk").hide();
		}

		if(txtPassChk!=txtPass){
			$("#ment_txtPassChk").text("��й�ȣ�� ��й�ȣ Ȯ�ζ��� �Է��� ������\n��ġ���� �ʽ��ϴ�. �ٽ� Ȯ���� �ּ���.");
			$("#ment_txtPassChk").show();
			$("#txtPassChk").focus();
			return;
		} else {
			$("#ment_txtPassChk").hide();
		}

		if(txtName==""){
			$("#ment_txtName").text("�̸��� �Է��� �ּ���.");
			$("#ment_txtName").show();
			$("#txtName").focus();
			return;
		} else {
			$("#ment_txtName").hide();
		}

/*	
		if(txtBirth == "") {
			$("#ment_txtBirth").text("��������� �Է��� �ּ���.");
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
			$("#ment_txtBirth").text("�߸��� ������� �����Դϴ�.");
			$("#ment_txtBirth").show();
			return;
		} else {
			$("#ment_txtBirth").hide();
		}

	
		if($("#txtEmail").val() == "") {
			$("#ment_txtEmail").text("�̸����� �Է��� �ּ���.");
			$("#ment_txtEmail").show();
			$("#txtEmail").focus();
			return;
		} else {
			$("#ment_txtEmail").hide();
		}

		if(! email_check(txtEmail) ) {
			$("#ment_txtEmail").text("�߸��� �̸��� �����Դϴ�.");
			$("#ment_txtEmail").show();
			return;
		}
		else {
			$("#ment_txtEmail").hide();
		}
*/

		if(txtMajor==""){
			$("#ment_txtMajor").text("�а��� �Է��� �ּ���.");
			$("#ment_txtMajor").show();
			$("#txtMajor").focus();
			return;
		} else {
			$("#ment_txtMajor").hide();
		}

		if (rdoStudent == "2"){
			if (rdoGender == undefined){
				$("#ment_rdoGender").text("������ ������ �ּ���.");
				$("#ment_rdoGender").show();
				return;
			} else {
				$("#ment_rdoGender").hide();
			}
		}

		if (rdoStudent == "2"){
			if(txtUnivNm==""){
				$("#ment_txtUnivNm").text("����/������ ���б��� �Է��� �ּ���.");
				$("#ment_txtUnivNm").show();
				$("#txtUnivNm").focus();
				return;
			} else {
				$("#ment_txtUnivNm").hide();
			}
		}

		if(selGrad==""){
			$("#ment_selGrad").text("���� �� ���п��θ� ������ �ּ���.");
			$("#ment_selGrad").show();
			$("#selGrad").focus();
			return;
		} else {
			$("#ment_selGrad").hide();
		}


		if(txtPhone==""){
			$("#ment_txtPhone").text("�޴�����ȣ�� �Է��� �ּ���.");
			$("#ment_txtPhone").show();
			$("#txtPhone").focus();
			return;
		} else {
			$("#ment_txtPhone").hide();
		}

		if ($("#mobileAuthNumChk").val() != "4") {
			alert("�޴�����ȣ�� ������ �ּ���.");
			$("#ment_txtPhone").text("�޴�����ȣ�� ������ �ּ���.");
			$("#ment_txtPhone").show();
			$("#mobileAuthNumber").focus();
			return;
		} else {
			$("#ment_txtPhone").hide();
		}

		if (!chkAgrPrv) {
			alert("�������� ������ ������ �ּ���.");
			return;
		}

		var obj=document.frm1;
		if(confirm('�Է��Ͻ� ������ ������û �Ͻðڽ��ϱ�?')) {
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

	/*���̵�-�й� �ߺ� üũ ����*/
	function fn_checkStuNo() {
		$("#id_box").text("");
		$("#id_check").val("0");

		if($("#txtStuNo").val() == "") {
			$("ment_txtStuNo").text("�й��� �Է��� �ּ���.");
			$("ment_txtStuNo").show();
			$("#txtStuNo").focus();
			return;
		}else if(!Validchar($("#txtStuNo").val(), num + alpha)){
			$("ment_txtStuNo").text("�й��� �ѱ� �� Ư�����ڸ� �������� �ʽ��ϴ�. �ٽ� �Է��� �ּ���.");
			$("ment_txtStuNo").show();
			$("#txtStuNo").focus();
			return;
		}else if($("#txtStuNo").val().length < 6){
			$("ment_txtStuNo").text("�й��� 7�� �̻��̾�� �մϴ�.");
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
					// ���� ��ϵ� ���̵� �����ϸ� X, ������ O
					if (data.trim() == "X") {
						//$("#id_box").addClass('bad').removeClass('good');
						$("ment_txtStuNo").text("Ż���� ���̵� �Ǵ� �̹� ������� ���̵��, �̿��Ͻ� �� �����ϴ�.");
						$("ment_txtStuNo").show();
						return;
					} else {
						$("#id_check").val("1");
						$("#chk_id").val($("#txtStuNo").val());
						//$("#id_box").addClass('good').removeClass('bad');
						//$("ment_txtStuNo").text("��� ������ ���̵��Դϴ�.");
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
	/*���̵�-�й� �ߺ� üũ ��*/

	/*���̵� �ߺ� üũ ����*/
	function fn_checkID() {
		$("#txtId").val($("#txtId").val().toLowerCase());

		$("#id_box").text("");
		$("#id_check").val("0");

		var checkNumber		= $("#txtId").val().search(/[0-9]/g);	// ���� �Է� üũ
		var checkEnglish	= $("#txtId").val().search(/[a-z]/ig);	// ���� �Է� üũ

		if($("#txtId").val() == "") {
			$("#ment_txtId").text("���̵� �Է��� �ּ���.");
			$("#ment_txtId").show();
			$("#txtId").focus();
			return;
		}else if(!Validchar($("#txtId").val(), num + alpha)){
			$("#ment_txtId").text("���̵�� �ѱ� �� Ư�����ڸ� �������� �ʽ��ϴ�. �ٽ� �Է��� �ּ���.");
			$("#ment_txtId").show();
			$("#txtId").focus();
			return;
		}else if($("#txtId").val().length < 5){
			$("#ment_txtId").text("���̵�� �ּ� 5�� �̻��̾�� �մϴ�.");
			$("#ment_txtId").show();
			return;
		}else if(checkNumber <0 || checkEnglish <0){
			$("#ment_txtId").text("������ ���ڸ� ȥ���Ͽ� �Է��� �ּ���.");
			$("#ment_txtId").show();
			return;
		}else{
			if (/(\w)\1\1\1/.test($("#txtId").val())){	// �������� ���� 4���� �̻� ��� ����
				$("#ment_txtId").text("������ ���� ���� 4���� �̻��� ��� �����մϴ�.");
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
						// ���� ��ϵ� ���̵� �����ϸ� X, ������ O
						if (data.trim() == "X") {
							//$("#id_box").addClass('bad').removeClass('good');
							$("#ment_txtId").text("Ż���� ���̵� �Ǵ� �̹� ������� ���̵��, �̿��Ͻ� �� �����ϴ�.");
							$("#ment_txtId").show();
							return;
						} else {
							$("#id_check").val("1");
							$("#chk_id").val($("#txtId").val());
							//$("#id_box").addClass('good').removeClass('bad');
							//$("#ment_txtId").text("��� ������ ���̵��Դϴ�.");
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
	/*���̵� �ߺ� üũ ��*/
	
	/*��й�ȣ üũ ����*/
	function fn_checkPW() {
		var chk = false;
		var id	= $("#txtId").val();
		if ($('#txtPass').val().length == 0 ) {
			return;
		} else {
			if ($('#txtPass').val().length < 8 || $('#txtPass').val().length > 32) {
				$("#ment_txtPass").text("��й�ȣ�� 8~32�� ������ ���˴ϴ�.");
				$("#ment_txtPass").show();
				return false;
			}
			/*
			if (id != "" && $('#txtPass').val().search(id) > -1) {
				$("#ment_txtPass").text("��й�ȣ�� ���̵� ���ԵǾ� �ֽ��ϴ�.");
				$("#ment_txtPass").show();
				return false;
			}*/
				
			var pattern1 = /[0-9]/;		// ���� 
			var pattern2 = /[a-zA-Z]/;	// ���� 
			var pattern3 = /[~!@#$%^&*()_+|<>?:{}]/; // Ư������
								
			//if (!$('#txtPass').val().match(/([a-zA-Z0-9].*[!,@,#,$,%,^,&,*,?,_,~])|([!,@,#,$,%,^,&,*,?,_,~].*[a-zA-Z0-9])/)) {
			//if (!$('#txtPass').val().match(/^.*(?=.{6,20})(?=.*[0-9])(?=.*[a-zA-Z]).*$/)) {
			//if (!/^(?=.*[a-zA-Z])(?=.*[!@#$%^*+=-])(?=.*[0-9]).{8,25}$/.test($('#txtPass').val())) {
			if(!pattern1.test($('#txtPass').val()) || !pattern2.test($('#txtPass').val()) || !pattern3.test($('#txtPass').val())) {
				$("#ment_txtPass").text("��й�ȣ�� ����, ���� �� Ư�������� �������� �����ؾ� �մϴ�");
				$("#ment_txtPass").show();
				return;
			}else{
				/*if($('#txtPass').val().search(id) > -1) {
					$("#ment_txtPass").text("��й�ȣ�� ���̵� ���ԵǾ� �ֽ��ϴ�.");
					$("#ment_txtPass").show();
					return false;
				}else{*/
					$("#ment_txtPass").hide("");
				//}
			}
		}

		if ($('#txtPassChk').val().split(" ").join("") == "") {
			$("#ment_txtPassChk").text("��й�ȣ Ȯ���� �Է��� �ּ���.");
			$("#ment_txtPassChk").show();
			return;
		} 

		if ($('#txtPass').val() != $('#txtPassChk').val()) {
			$("#ment_txtPassChk").text("��й�ȣ�� ��ġ���� �ʽ��ϴ�.");
			$("#ment_txtPassChk").show();
			return;
		} else {
			$("#ment_txtPass").hide();
			$("#ment_txtPassChk").hide();
		}
		return chk;
	}
	/*��й�ȣ üũ ��*/

	/*�̸��� üũ ����*/
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
		$("#ment_txtEmail").text("�߸��� �̸��� �����Դϴ�.");
		$("#ment_txtEmail").show();
		return false;
	  }
	  else {
		$("#ment_txtEmail").hide();
		return false;
	  }
	}
	/*�̸��� üũ ��*/

	function fn_checkBirth() {
		var birth = $("#txtBirth").val();
		if (birth == '' || birth == 'undefined') return;

		if (birth.length < 10) {
			$("#ment_txtBirth").text("�߸��� ������� �����Դϴ�.");
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
			$("#ment_txtBirth").text("�߸��� ������� �����Դϴ�.");
			$("#ment_txtBirth").show();
		} else {
			$("#ment_txtBirth").hide();
		}

	}

	// �̸� �Է� ���� üũ
	function fn_checkNm() {
		if($("#txtName").val()==""){
			$("#ment_txtName").text("�̸��� �Է��� �ּ���.");
			$("#ment_txtName").show();
			$("#txtName").focus();
			return;
		} else {
			$("#ment_txtName").hide();
		}
	}

	// �а����� �Է� ���� üũ	
	function fn_checkMajor() {
		if($("#txtMajor").val()==""){
			$("#ment_txtMajor").text("�а��� �Է��� �ּ���.");
			$("#ment_txtMajor").show();
			$("#txtMajor").focus();
			return;
		} else {
			$("#ment_txtMajor").hide();
		}	
	}

	// �޴�����ȣ �Է� ���� üũ	
	function fn_checkPhone() {
		if($("#txtPhone").val()==""){
			$("#ment_txtPhone").text("�޴�����ȣ�� �Է��� �ּ���.");
			$("#ment_txtPhone").show();
			$("#txtPhone").focus();
			return;
		} else {
			$("#ment_txtPhone").hide();
		}

		if ($("#mobileAuthNumChk").val() != "4") {
			$("#ment_txtPhone").text("�޴�����ȣ�� ������ �ּ���.");
			$("#ment_txtPhone").show();
			$("#txtPhone").focus();
			return;
		} else {
			$("#ment_txtPhone").hide();
		}
	}
	
	// �Է°� üũ
	$(document).ready(function () {
		//$("#txtPass").val("");
		//$("#frm1")[0].reset();

		//���̵� �ߺ� üũ - �й�(���л��� ���)
		$("#txtStuNo").bind("keyup keydown", function () {
			fn_checkStuNo();
		});
		
		//���̵� �ߺ� üũ
		$("#txtId").bind("keyup keydown", function () {
			fn_checkID();
		});

		// ��� ��ȿ�� üũ
		$("#txtPass").bind("keyup keydown", function () {
//			$(this).attr('type', 'password'); 
			fn_checkPW();
		});

		// ��� ��Ȯ�� ��ȿ�� üũ
		$("#txtPassChk").bind("keyup keydown", function () {
			fn_checkPW();
		});

		// �̸� �Է� ���� üũ
		$("#txtName").bind("keyup keydown", function () {
			fn_checkNm();
		});

		// �а� �Է� ���� üũ
		$("#txtMajor").bind("keyup keydown", function () {
			fn_checkMajor();
		});

		// �޴�����ȣ �Է� ���� üũ
		$("#txtPhone").bind("keyup keydown", function () {
			fn_checkPhone();
		});

/*	
		// �̸��� �ּ� ��ȿ�� üũ
		$("#txtEmail").bind("keyup keydown", function () {
			fn_checkMail();
		});

		// ������� ��ȿ�� üũ
		$("#txtBirth").bind("keyup", function() {
			fn_checkBirth();
		});
*/

	});

	// ���� �� ���п��� ���� ���� ���� �Է� ���� ǥ��
	function chageSelect(cd){	
		var gradCd = $(cd).val();

		if(gradCd==""){
			$("#ment_selGrad").text("���� �� ���п��θ� ������ �ּ���.");
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
<!-- ��� -->
<!--#include virtual = "/include/gnb/topMenu.asp"-->
<!-- ��� -->


<!-- ������ -->
<div id="contents" class="util">
	<div class="content sign_up">
		<div class="input_area">
			<div class="tit">
				<h3>������û</h3>
			</div>
			<div class="sign_up">

				<form method="post" name="frm1" autocomplete="off">
				<input type="hidden" name="id_check" id="id_check" value="" /><!-- ���̵� ���� ����(0/1) -->
				<input type="hidden" name="chk_id" id="chk_id" value=""><!-- ���(�Է�) ���̵� -->
				<input type="hidden" name="hd_idx" id="hd_idx" value="" /><!-- ��ȣ���� idx -->
				<input type="hidden" name="mobileAuthNumChk" id="mobileAuthNumChk" value="0" />
				<input type="hidden" name="hd_kind" id="hd_kind" value="2" />
				<input type="hidden" name="authproc" id="authproc" value="" />

				<div class="rdi_box">
					<label class="radiobox">
						<input type="radio" class="rdi" name="rdoStudent" value="1" checked>
						<span>���л�</span>
					</label>
					<label class="radiobox">
						<input type="radio" class="rdi" name="rdoStudent" value="2">
						<span>Ÿ ���л�</span>
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
							<th><span class="pil">�ʼ�</span>�й�</th>
							<td>
								<input type="text" class="txt" id="txtStuNo" name="txtStuNo" maxlength="10" placeholder="�й��� �Է��� �ּ���.">
								<p class="ment" id="ment_txtStuNo" style="display:none;"></p>
							</td>
						</tr>
						<tr class="id" id="chkIdArea2">
							<th><span class="pil">�ʼ�</span>���̵�</th>
							<td>
								<input type="text" class="txt" id="txtId" name="txtId" maxlength="12" placeholder="���̵� (5~12�� ����, ���� �Է�)">
								<p class="ment" id="ment_txtId" style="display:none;"></p>
							</td>
						</tr>
						<tr>
							<th><span class="pil">�ʼ�</span>��й�ȣ</th>
							<td class="pass">
								<input type="password" class="txt" id="txtPass" name="txtPass" maxlength="32" placeholder="��й�ȣ (8~32�� ����, ����, Ư������ �Է�)">
								<span class="ment2" id="capslockMsg" style="display:none;">CapsLock is on</span>
								<p class="ment" id="ment_txtPass" style="display:none;"></p>
							</td>
						</tr>

						<tr>
							<th><span class="pil">�ʼ�</span>��й�ȣ(Ȯ��)</th>
							<td class="pass">
								<input type="password" class="txt" id="txtPassChk" name="txtPassChk" maxlength="32" placeholder="��й�ȣ Ȯ��">
								<span class="ment2" id="capslockMsg2" style="display:none;">CapsLock is on</span>
								<p class="ment" id="ment_txtPassChk" style="display:none;"></p>
							</td>
						</tr>
						<tr>
							<th><span class="pil">�ʼ�</span>�̸�(�Ǹ�)</th>
							<td>
								<input type="text" class="txt" id="txtName" name="txtName" maxlength="10" placeholder="�̸� (�Ǹ��Է�)">
								<p class="ment" id="ment_txtName" style="display:none;"></p>
							</td>
						</tr>
						
						<!-- ����, �̸��� �׸� ���� -->
						<tr style="display:none;">
							<th>�������</th>
							<td>
								<input type="text" class="txt" id="txtBirth" name="txtBirth" maxlength="10" placeholder="������� ex) yyyy.mm.dd" onkeyup="numCheck(this, 'int'); changeBirthType(this);">
								<p class="ment" id="ment_txtBirth" style="display:none;"></p>
							</td>
						</tr>
						<tr style="display:none;">
							<th>E-mail</th>
							<td>
								<input type="text" class="txt" id="txtEmail" name="txtEmail" maxlength="100" placeholder="�̸��� �ּ�">
								<p class="ment" id="ment_txtEmail" style="display:none;"></p>
							</td>
						</tr>
					
						<tr>
							<th><span class="pil">�ʼ�</span>�а�</th>
							<td>
								<input type="text" class="txt" id="txtMajor" name="txtMajor" maxlength="20" placeholder="�а��� �Է��� �ּ���.">
								<p class="ment" id="ment_txtMajor" style="display:none;">�а��� �Է��� �ּ���.</p>
							</td>
						</tr>

						<tr class="gender" id="chkGenderArea">
							<th><span class="pil">�ʼ�</span>����</th>
							<td>
								<div class="rdi_box tb">
									<label class="radiobox" for="rdoGender1">
										<input type="radio" class="rdi" id="rdoGender1" name="rdoGender" value="1">
										<span>���л�</span>
									</label>
									<label class="radiobox" for="rdoGender2">
										<input type="radio" class="rdi" id="rdoGender2" name="rdoGender" value="2">
										<span>���л�</span>
									</label>	
								</div>
								<p class="ment" id="ment_rdoGender" style="display:none;">������ �Է��� �ּ���.</p>
							</td>
						</tr>
						<tr class="school_name" id="chkUnivArea">
							<th><span class="pil">�ʼ�</span>�б���</th>
							<td>
								<input type="text" class="txt" id="txtUnivNm" name="txtUnivNm" maxlength="20" placeholder="Ÿ ���� �б����� �Է��� �ּ���.">
								<p class="ment" id="ment_txtUnivNm" style="display:none;">�б��� �Է��� �ּ���.</p>
							</td>
						</tr>

						<tr>
							<th><span class="pil">�ʼ�</span>���� �� ���п���</th>
							<td>
								<span class="selectbox" style="width:206px;">
									<span class="">����</span>
									<select id="selGrad" name="selGrad" title="���� �� ���п���" onchange="chageSelect(this);">
										<option value="">����</option>
										<option value="1">����</option>
										<option value="2">��������(4�г�)</option>
										<option value="3">������</option>
										<!-- <option value="4">����</option>
										<option value="5">����</option> -->
										<option value="6">��Ÿ</option>
									</select>
								</span>
								<br>
								<p class="ment" id="ment_selGrad" style="display:none;">���� �� ���п��θ� ������ �ּ���.</p>
							</td>
						</tr>

						<tr>
							<th rowspan="2"><span class="pil">�ʼ�</span>�޴�����ȣ</th>
							<td class="call">
								<div class="number_box">
									<input type="text" class="txt" id="txtPhone" name="txtPhone" maxlength="13" placeholder="�޴�����ȣ" onkeyup="removeChar(event); changePhoneType(this);" onkeydown="return onlyNumber(event)">
									<button type="button" id="aMobile" onclick="fn_chkJoin(); return false;" style="cursor:pointer">������ȣ ����</button>
									<p class="ment" id="ment_txtPhone" style="display:none;"></p>
								</div>
								<div class="number_box" id="rsltAuthArea" style="display:none;">
									<input type="text" class="txt" id="mobileAuthNumber" name="mobileAuthNumber" maxlength="6" onkeyup="removeChar(event)" onkeydown="return onlyNumber(event)" placeholder="������ȣ">
									<span class="time" id="timeCntdown" style="display:none;">(03:00)</span>
									<button type="button" onclick="fnAuthNoChk(); return false;" style="cursor:pointer">�����ϱ�</button>
									<span class="cite" id="ment_auth" style="display:none">�����Ϸ�</span>
								</div>
							</td>
						</tr>
					</tbody>
				</table>
				<dl class="agree_dl">
					<dt>�������� ��������</dt>
					<dd>
						�������� �������� : ���ο��� Ȯ��<br>
						�������� �����׸� : �̸�, �޴��� ��ȣ, �а�, ���� �� ���� ����<br>
						�������� �ı� : ��� ���� �� �ı�
					</dd>
				</dl>
				<div class="chk_area">
					<label class="checkbox off" for="agreeallPer">
						<input class="chk" id="agreeallPer" name="agreeallPer" type="checkbox">
						<span><%=site_name%> �������� ������ �����մϴ�.</span>
					</label>	
				</div>
				<div class="btn_area">
					<a href="javascript:" onclick="fn_sumbit();" class="btn blue">������û �Ϸ�</a>
					<!-- <a href="/" class="btn gray">���</a> -->
				</div>

				</form>

			</div><!-- sign_up -->
		</div>
	</div><!-- //content -->
</div><!-- //contents -->
<!--// ������ -->


<!-- �ϴ� -->
<!--#include virtual = "/include/footer/footer.asp"-->
<!-- �ϴ� -->

</body>
</html>
<script type="text/javascript">
<!--
	// ĸ���� üũ
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