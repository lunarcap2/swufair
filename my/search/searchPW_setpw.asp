<!--#include virtual = "/common/common.asp"-->
<!--#include virtual = "/include/header/header.asp"-->
<%
	Dim result_id, result_auth_type, result_auth_value
	result_id			= request("result_id")
	result_auth_type	= request("result_auth_type")
	result_auth_value	= request("result_auth_value")
%>
</head>
<body>
<!-- ��� -->
<!--#include virtual = "/include/gnb/topMenu.asp"-->
<!-- ��� -->

<!-- ������ -->
<div id="contents" class="util">
	<div class="content">
		<div class="input_area">
			<div class="tit">
				<h3>��й�ȣ �缳��<span>���ο� ��й�ȣ�� �Է��� �ּ���.</span></h3>
			</div>
			<div class="sch_area">
				<form id="frm" name="frm">
				<input type="hidden" id="user_id" name="user_id" value="<%=result_id%>">
				<input type="hidden" id="authType" name="authType" value="<%=result_auth_type%>">
				<input type="hidden" id="authValue" name="authValue" value="<%=result_auth_value%>">
				
				<table class="tb">
					<colgroup>
						<col style="width:140px" />
						<col />
					</colgroup>
					<tbody>
						<tr>
							<th><span class="pil">�ʼ�</span>��й�ȣ</th>
							<td>
								<input type="password" class="txt" id="new_pw1" name="new_pw1" maxlength="32" placeholder="��й�ȣ (8~32�� ����, ����, Ư������ �Է�)" value="">
								<span class="ment" id="capslockMsg" style="display:none;">CapsLock is on</span>
								<p class="ment" id="ment_new_pw1" style="display:none;">��й�ȣ�� �Է��� �ּ���.</p>
							</td>
						</tr>
						<tr>
							<th><span class="pil">�ʼ�</span>��й�ȣ Ȯ��</th>
							<td>
								<input type="password" class="txt" id="new_pw2" name="new_pw2" maxlength="32" placeholder="��й�ȣ Ȯ��" value="">
								<span class="ment" id="capslockMsg2" style="display:none;">CapsLock is on</span>
								<p class="ment" id="ment_new_pw2" style="display:none;">��й�ȣ Ȯ���� �Է��� �ּ���.</p>
							</td>
						</tr>
					</tbody>
				</table>
				</form>
				<p class="tb_ment">����, ����, Ư����ȣ�� �����Ͽ� 8�� �̻� ����� �ּ���.</p>
				<div class="btn_area">
					<a href="javascript:" class="btn blue" onclick="PW_Modify('USER');">��й�ȣ ����</a>
					<a href="javaScript:fn_reset();" class="btn gray">����ϱ�</a>
				</div>
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
	var txtPass		= document.getElementById("new_pw1");
	var txtPassChk	= document.getElementById("new_pw2");
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
	
	// �Է����� �ʱ�ȭ
	function fn_reset(){
		if ($("#new_pw1").val()!=""){
			if(confirm('��й�ȣ �缳���� ��� �Ͻðڽ��ϱ�?')) {	
				location.href = "/";	
			}	
		}else{
			location.href = "/";		
		}	
	}
//-->
</script>