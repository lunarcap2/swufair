<% Option Explicit %>
<!--#include virtual="/wwwconf/function/db/DBConnection.asp"-->
<!--#include virtual="/common/common.asp"--> 
<!--#include virtual="/inc/function/paging.asp"-->
<%
	' ������ ������ ��쿡�� ���� ���   
	If Request.Cookies(site_code & "WKADMIN")("admin_id")="" Then 
		Response.Write "<script language=javascript>"&_
			"alert('�ش� �޴��� ���� ���� ������ �����ϴ�.');"&_
			"location.href='/';"&_
			"</script>"
		response.End 
	End If

	Dim lcture_no : lcture_no = request("lcture_no")
	Dim mode, lcture_tit, searchStartDate, lcture_shour, lcture_smin, searchEndDate, lcture_ehour, lcture_emin, lcture_zoomurl, lcture_gubun
	Dim i, set_hour
	
	If lcture_no <> "" Then
		ConnectDB DBCon, Application("DBInfo_FAIR")
			
			mode = "edit"

			Dim strQuery, arrRs
			strQuery = ""
			strQuery = strQuery & " SELECT ���Ǹ�, CONVERT(CHAR(19), ���ǽ����Ͻ�, 20) AS ���ǽ����Ͻ�, CONVERT(CHAR(19), ���������Ͻ�, 20) AS ���������Ͻ�, ����URL, ����"
			strQuery = strQuery & " FROM ���丵_����_�⺻���� WITH(NOLOCK) WHERE ���ǹ�ȣ = " & lcture_no

			arrRs = arrGetRsSql(DBCon, strQuery, "", "")

			If isArray(arrRs) Then
				lcture_tit		= arrRs(0,0)
				searchStartDate	= Left(arrRs(1,0),10)					'Ư��_������
				lcture_shour	= Split(Mid(arrRs(1,0),12,13),":")(0)	'Ư��_���۽�
				lcture_smin		= Split(Mid(arrRs(1,0),12,13),":")(1)	'Ư��_���ۺ�
				searchEndDate	= Left(arrRs(2,0),10)					'Ư��_������
				lcture_ehour	= Split(Mid(arrRs(2,0),12,13),":")(0)	'Ư��_�����
				lcture_emin		= Split(Mid(arrRs(2,0),12,13),":")(1)	'Ư��_�����
				lcture_zoomurl	= arrRs(3,0)

				lcture_gubun	= arrRs(4,0)
			End If

		DisconnectDB DBCon
	End If
%>
<!--#include virtual = "/include/header/header.asp"-->
<script type="text/javascript">
	
	// ����
	function fn_submit() {

		if ($('#lcture_tit').val() == '') {
			alert('Ư������ �Է��� �ּ���.');
			$('#lcture_name').focus();
			return;
		}

		if ($('#searchStartDate').val() == '' || $('#searchEndDate').val() == '' || $('#lcture_shour').val() == '' || $('#lcture_ehour').val() == '') {
			alert('Ư�� �Ͻø� ��� �Է��� �ּ���.');
			return;
		}
		
		if ($('#lcture_zoomurl').val() == '') {
			alert('Zoom�ּҸ� �Է��� �ּ���.');
			$('#lcture_zoomurl').focus();
			return;
		}
		
		$("#proc_gubun").val("submit");

		document.frm.action = "./lcture_reg_proc.asp";
		document.frm.submit();
	}
	
	// ��ũ�׽�Ʈ
	function fn_chkUrl() {
		var lcture_zoomurl = $("#lcture_zoomurl").val();

		if (lcture_zoomurl.indexOf("http") < 0) {
			lcture_zoomurl = "http://" + lcture_zoomurl;
		}

		window.open(lcture_zoomurl);
	}

	$(document).ready(function () {

		var lcture_shour = '<%=lcture_shour%>';
		if (lcture_shour != "") {
			$('#lcture_shour').val(lcture_shour);
		}

		var lcture_ehour = '<%=lcture_ehour%>';
		if (lcture_ehour != "") {
			$('#lcture_ehour').val(lcture_ehour);
		}

		var lcture_gubun = "<%=lcture_gubun%>";
		$('[name="lcture_gubun"]').each(function() {
			if (lcture_gubun.indexOf(this.value) >= 0)
				this.checked = true;
		});

	});

	//����
	function fn_delete() {
		if (confirm("������ �ش� Ư���� ��û�� �ο��鵵 ���� �˴ϴ�. �����Ͻðڽ��ϱ�?")) {
			$("#proc_gubun").val("delete");

			document.frm.action = "./lcture_reg_proc.asp";
			document.frm.submit();
		}
	}

</script>
</head>

<body id="loginWrap">
<!-- ��� -->
<!--#include virtual = "/include/gnb/topMenu.asp"-->
<!-- ��� -->

<!-- ������ -->
<form method="post" id="frm" name="frm">
<input type="hidden" id="proc_gubun" name="proc_gubun" value="">
<input type="hidden" id="lcture_no" name="lcture_no" value="<%=lcture_no%>">
<input type="hidden" id="mode" name="mode" value="<%=mode%>">

<div id="contents" class="admin">
	<div class="content">
		<div class="navi">
			<ul>
				<li><a href="#none;">Ȩ</a></li>
				<% If mode = "edit" Then %>
				<li><a href="#none;">��.â��Ư�� ��� ����</a></li>
				<% Else %>
				<li><a href="#none;">��.â��Ư�� ��� ���</a></li>
				<% End If %>
			</ul>
		</div>
		<div class="list_area view">
			<div class="tit">
				<% If mode = "edit" Then %>
				<h3>��.â��Ư�� ��� ����</h3>
				<% Else %>
				<h3>��.â��Ư�� ��� ���</h3>
				<% End If %>
			</div>
			<table class="tb">
				<colgroup>
					<col style="width:20%;">
					<col style="width:30%;">
					<col style="width:20%;">
					<col>
				</colgroup>
				<tbody>
					<tr>
						<th>Ư������</th>
						<td colspan="3">
							<div class="rdi_box">
								<label class="radiobox">
									<input type="radio" class="rdi" name="lcture_gubun" value="���Ư��" checked>
									<span>���Ư��</span>
								</label>
								<label class="radiobox">
									<input type="radio" class="rdi" name="lcture_gubun" value="â��Ư��">
									<span>â��Ư��</span>
								</label>
							</div>
						</td>
					</tr>
					<tr>
						<th>Ư����</th>
						<td colspan="3">
							<input type="text" class="txt" id="lcture_tit" name="lcture_tit" value="<%=lcture_tit%>" placeholder="Ư������ �Է��� �ּ���." style="width:100%;">
						</td>
					</tr>
					<tr>
						<th>Ư�� �Ͻ�</th>
						<td  colspan="3">
							<div class="time_box">
								<div class="datePick">
									<span>
										<input type="text" class="datepicker two" id="searchStartDate" name="lcture_sday" value="<%=searchStartDate%>" style="width:210px;">
										<button type="button" class="btncalendar dateclick">��¥����</button>
									</span>
								</div>

								<span class="selectbox" style="width:210px;">
									<span class="">����</span>
									<select id="lcture_shour" name="lcture_shour" title="�����">
										<option value="">����</option>
										<% 
											For i=0 To 24
											If Len(i) = 1 Then set_hour = "0" & i Else set_hour = i End If												
										%>
										<option value="<%=set_hour%>"><%=set_hour%>��</option>
										<% Next %>
									</select>
								</span>
								<em>��</em>
								<div class="datePick">
									<span>
										<input type="text" class="datepicker two" id="searchEndDate" name="lcture_eday" value="<%=searchEndDate%>" style="width:210px;">
										<button type="button" class="btncalendar dateclick">��¥����</button>
									</span>
								</div>

								<span class="selectbox" style="width:210px;">
									<span class="">����</span>
									<select id="lcture_ehour" name="lcture_ehour" title="�����">
										<option value="">����</option>
										<% 
											For i=0 To 24
											If Len(i) = 1 Then set_hour = "0" & i Else set_hour = i End If												
										%>
										<option value="<%=set_hour%>"><%=set_hour%>��</option>
										<% Next %>
									</select>
								</span>
								<em>��</em>
							</div>
						</td>
					</tr>
					<tr>
						<th>Zoom�ּ�</th>
						<td colspan="3">
							<input type="text" class="txt" id="lcture_zoomurl" name="lcture_zoomurl" value="<%=lcture_zoomurl%>" placeholder="Zoom �ּҸ� �Է��� �ּ���." style="width:80%;">
							&nbsp;
							<a href="javascript:;" type="_blank" class="btn blue" onclick="fn_chkUrl(); return false;">��ũ �׽�Ʈ</a>
						</td>
					</tr>
				</tbody>
			</table>
			<div class="btn_area right">
				<a href="lcture_list.asp" class="btn list">���</button>
				<a href="javascript:;" class="btn blue" onclick="fn_submit();">���� ����</button>
				<% If mode = "edit" Then %>
				<a href="javascript:;" class="btn gray" onclick="fn_delete();">����</button>
				<% End If %>
			</div>
		</div><!-- list_area view -->
	</div><!-- //content -->
</div><!-- //contents -->
</form>
<!--// ������ -->

<!-- �ϴ� -->
<!--#include virtual = "/include/footer/footer.asp"-->
<!-- �ϴ� -->
</body>	
</html>