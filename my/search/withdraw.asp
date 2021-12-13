<%
option Explicit
%>

<!--#include virtual = "/common/common.asp"-->
<!--#include virtual="/wwwconf/function/db/DBConnection.asp"-->
<!--#include virtual = "/include/header/header.asp"-->

<%
	Call FN_LoginLimit("1")    '����ȸ���� ���ٰ���
%>
	
<%
	ConnectDB DBCon, Application("DBInfo_FAIR")
	
	' my ī��Ʈ
	Dim resume_cnt, apply_cnt, scrap_cnt, att_company_cnt, rtn_value3
	ReDim param(0)

	param(0) = makeParam("@i_user_id", adVarChar, adParamInput, 20, user_id)

	rtn_value3		= arrGetRsSP(DBCon, "USP_MY_RESUME_STAT", param, "", "")
	
	resume_cnt			= rtn_value3(1,0) + rtn_value3(2,0) + rtn_value3(9,0)	' �̷¼�
	apply_cnt			= rtn_value3(3,0) + rtn_value3(4,0)						' �Ի����� ����
	scrap_cnt			= rtn_value3(5,0) + rtn_value3(6,0)						' ��ũ�� ����
	att_company_cnt		= rtn_value3(7,0)										' ���� ���»�
	
	DisconnectDB DBCon
%>

<script type="text/javascript">	
	function fn_keyup() {
		if (event.keyCode == 13) {
			fn_pwchk();
		}
	}

	function fn_pwchk() {
		if($('#user_pw').val() == "") {
			alert("��й�ȣ�� �Է��� �ּ���");
			$('#user_pw').focus();
            return;	
		}
		else {
			$.ajax({
				type: "POST"
				, url: "/my/search/withdraw_confirm.asp"
				, data: { user_pw: $("#user_pw").val() }
				, dataType: "html"
				, async: true
				, success: function (data) {
					if (data.trim() != '') {
						$('#confirm').css("display","block");	
					}
					else {
						alert("�Է��� ��й�ȣ�� ��ġ���� �ʽ��ϴ�.");
						$('#user_pw').focus();
			            return;
					}
				}
				, error: function (XMLHttpRequest, textStatus, errorThrown) {
					//alert(XMLHttpRequest.responseText);
				}
			});
		}
	}

	function fn_submit() {
		if ($('#user_nm').val() == "") {
			alert("�ʼ� �Է°��� �Է��� �ּ���");
			$('#user_nm').focus();
			return;
		}
		if ($('#hp_num').val() == "") {
			alert("�ʼ� �Է°��� �Է��� �ּ���");
			$('#hp_num').focus();
			return;
		}
		if ($('#user_reason').val() == "") {
			alert("�ʼ� �Է°��� �Է��� �ּ���");
			$('#user_reason').focus();
			return;
		}

		$("#frm").attr("action", "/my/search/withdraw_complet.asp");
		$('#frm').submit();
	}
</script>
</head>

<body>
<!-- ��� -->
<!--#include virtual = "/include/gnb/topMenu.asp"-->
<!-- ��� -->

<!-- CONTENTS -->
<div id="career_container" class="searchIdWrap">
	
	<!--
	<div style="width:720px;padding-bottom: 10px;text-align: right;margin:0 auto;">
		<a href="/my/search/withdraw.asp">ȸ��Ż�� ã��</a>
    </div>
	-->

    <div id="career_contents">

        <div class="memberTab">
            <ul class="spl2">
                <li class="on"><a href="#memberPer" onclick="memberTabFnc(this,'.memberInfo.per','.memberInfo.comp');return false;" /><span>ȸ�� Ż��</span></a></li>
            </ul>
        </div><!-- .memberTab -->

        <div class="layoutBox">

			<div class="titArea">
				<h3>��й�ȣ �Է�</h3>
				<span class="txt">���� Ȯ���� ���� ��й�ȣ�� �ٽ� �ѹ� �Է� ��Ź�帳�ϴ�.</span>
			</div><!-- .titArea -->
			
			<div class="inputArea">
				<div class="inp bgNone">
					<label for="user_id">���̵�</label>
					<input type="text" id="user_id" class="txt tahoma" name="user_id" value="<%=Replace(user_id, "_wk", "")%>" disabled="">
				</div><!-- .inp -->
				<div class="inp bgNone">
					<label for="user_pw">��й�ȣ</label>
					<input type="password" id="user_pw" class="txt placehd" name="user_pw" placeholder="��й�ȣ �Է�" onkeyup="FC_ChkTextLen(this,32); fn_keyup();">
					<div class="rt">
						<button type="button" class="btn typeSky" onclick="fn_pwchk();">Ȯ��</button>
					</div><!-- .rt -->
				</div><!-- .inp -->
			</div><!-- .inputArea -->
                
			<!-- ����ȸ�� -->
			<div id="memberPer" class="memberInfo">
				<div class="currentArea">
					<strong class="tit">ȸ��Ż�� �� <em>������ ������ �����Ǿ� �̿��� �� ���� �˴ϴ�.</em></strong>
					<ul class="spl4">
						<li>
							<dl>
								<dt>�̷¼�</dt>
								<dd><a><%=resume_cnt%></a></dd>
							</dl>
						</li>
						<li>
							<dl>
								<dt>�Ի����� ����</dt>
								<dd><a><%=apply_cnt%></a></dd>
							</dl>
						</li>
						<li>
							<dl>
								<dt>��ũ�� ����</dt>
								<dd><a><%=scrap_cnt%></a></dd>
							</dl>
						</li>
						<li>
							<dl>
								<dt>���� ���»�</dt>
								<dd><a><%=att_company_cnt%></a></dd>
							</dl>
						</li>
					</ul>
				</div><!-- .currentArea -->
				
				
				<form name="frm" id="frm" method="post" action="">
					<input type="hidden" name="sitegubun" value="">
					
					<div id="confirm" style="display:none;">
						<div class="inputArea">
							<div class="inp">
								<label for="user_nm">�̸�</label>
								<input type="txt" id="user_nm" class="txt placehd" name="user_nm" placeholder="�̸� (�Ǹ��Է�)" />
							</div><!-- .inp -->
							<div class="inp">
								<label for="hp_num">�޴��� ��ȣ</label>
								<input type="txt" id="hp_num" class="txt placehd" name="hp_num" placeholder="�޴��� ��ȣ" maxlength="13" />
							</div><!-- .inp -->
							<div class="inp">
								<label for="user_reason">Ż�����</label>
								<input type="txt" id="user_reason" class="txt placehd" name="user_reason" placeholder="Ż�����" />
							</div><!-- .inp -->
						</div><!-- .inputArea -->

						<div class="btnWrap">
							<button type="button" class="btn typeSky" onclick="fn_submit()">ȸ��Ż�� ��û</button>
						</div>
					</div>
				</form>

				<div class="notiArea">
					<strong class="tit">ȸ��Ż�� ��û�� �� <em>������ ������ �ݵ�� Ȯ���Ͻñ� �ٶ��ϴ�.</em></strong>
					<ul>
						<li>�� ��Ÿ�ʵ� �ȼ� ��� �¶��� ����ä����� �α����� �� �� �����ϴ�.</li>
						<li>�� ���� �簡���ϴ��� ������ ���̵�� �簡���� �Ұ����մϴ�.</li>
						<li>�� �ڶ�ȸ ���� �ҽ��� ���� �� �����ϴ�.</li>
					</ul>
				</div><!-- .notiArea -->
			</div><!-- .memberInfo -->
			<!--// ����ȸ�� -->

        </div><!-- .layoutBox -->
    </div><!-- #career_contents -->
</div><!-- #career_container -->
<!--// CONTENTS -->

</body>
</html>