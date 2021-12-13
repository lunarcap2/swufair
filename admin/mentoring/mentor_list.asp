<% Option Explicit %>
<!--#include virtual="/wwwconf/function/db/DBConnection.asp"-->
<!--#include virtual="/common/common.asp"--> 
<!--#include virtual="/inc/function/code_function.asp"--> 
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

	If Request.ServerVariables("HTTPS") = "off" Then 
		Response.redirect "https://"& Request.ServerVariables("HTTP_HOST") & Request.ServerVariables("URL") 
	End If


	Dim schKeyword	: schKeyword	= Request("schKeyword") ' �˻���(����/����)  
	Dim page		: page			= Request("page")
	Dim pageSize	: pageSize		= 20

	If page = "" Then page=1
	page = CInt(page)

	Dim stropt, i, ii
	stropt = "schKeyword="&schKeyword

	ConnectDB DBCon, Application("DBInfo_FAIR")

		Dim Param(7)
		Param(0) = makeparam("@kw",adVarChar,adParamInput,100,schKeyword)
		Param(1) = makeparam("@S_DATE",adVarChar,adParamInput,10,"")
		Param(2) = makeparam("@E_DATE",adVarChar,adParamInput,10,"")
		Param(3) = makeparam("@MENTOR_NO",adInteger,adParamInput,4,"")
		Param(4) = makeparam("@USER_ID",adVarChar,adParamInput,20,"")
		Param(5) = makeparam("@PAGE",adInteger,adParamInput,4,page)
		Param(6) = makeparam("@PAGE_SIZE",adInteger,adParamInput,4,pagesize)
		Param(7) = makeparam("@TOTAL_CNT",adInteger,adParamOutput,4,"")

		Dim arrRs, totalCnt, pageCount
		arrRs = arrGetRsSP(DBcon, "asp_������_�������_��Ȳ", Param, "", "")
		totalCnt	= getParamOutputValue(Param, "@TOTAL_CNT")
		pageCount	= Fix(((totalCnt-1)/PageSize) +1) 'int(totalCnt / pagesize) + 1

	DisconnectDB DBCon

%>
<!--#include virtual = "/include/header/header.asp"-->
<script type="text/javascript">
	
	// �˻�
	function fn_search() {
		var obj = document.frm_list;
		if ($("#schKeyword").val() == "") {
			alert("�˻�� �Է��� �ּ���.");
			$("#schKeyword").focus();
			return false;
		}
		obj.action = "mentor_list.asp";
		obj.submit();
	}

	// �˻� �ʱ�ȭ
	function fn_reset() {
		var obj = document.frm_list;
		obj.schKeyword.value	= "";
		obj.action				= "mentor_list.asp";
		obj.submit();
	}

</script>
</head>

<body id="loginWrap">
<!-- ��� -->
<!--#include virtual = "/include/gnb/topMenu.asp"-->
<!-- ��� -->

<!-- ���� -->
<div id="contents" class="admin">
	<div class="content">
		<div class="navi">
			<ul>
				<li><a href="#none;">Ȩ</a></li>
				<li><a href="#none;">������ Ư��&��� ��������</a></li>
			</ul>
		</div>
		<div class="list_area">
			<div class="tit">
				<h3>������ Ư��&��� ��������</h3>
			</div>

		<!-- �Ǹ޴� -->
		<br>
		<div class="s2_tab_tit">
			<!-- ���ݱ� ������� -->			
			<a href="/admin/board/board_list.asp">��������</a>
			<a href="/admin/mentoring/user_list.asp">������û ��Ȳ</a>
			<a href="/admin/mentoring/apply_list.asp"><font size="2">������ Ư��&��� ��û��</font></a>
			<a href="/admin/mentoring/lcture_apply_list.asp">��.â��Ư�� ��û��</a>
			<a href="/admin/mentoring/question_list.asp">��������</a>
			<a href="/admin/mentoring/send_sms_list.asp"><font size="2">������ Ư��&��� ���ڹ߼�</font></a>
			<a href="/admin/mentoring/lcture_send_sms_list.asp">��.â��Ư�� ���ڹ߼�</a>
			<a href="/admin/mentoring/mentor_list.asp" class="on"><font size="2">������ Ư��&��� ��������</font></a>
			<a href="/admin/mentoring/lcture_list.asp">��.â��Ư�� ��� ����</a>
		</div>
		<br>
		<!-- //�Ǹ޴� -->

			<div class="right_box">
				<form method="post" id="frm_list" name="frm_list">
				<div class="sch_box">
					<input type="text" class="txt" id="schKeyword" name="schKeyword" placeholder="�˻�� �Է��� �ּ���." value="<%=schKeyword%>">
					<button type="button" class="btn" onclick="fn_search();">�˻�</button>
					<button type="button" class="reset" onclick="fn_reset();">�ʱ�ȭ</button>
				</div>
				</form>
			</div>

			<table class="tb">
				<colgroup>
					<col style="width:100px">
					<col style="width:180px">
					<col>
					<col style="width:150px">
					<col style="width:150px">
					<col style="width:200px">
					<col style="width:150px">
				</colgroup>
				<thead>
					<tr>
						<th>No</th>
						<th>�ΰ�</th>
						<th>����(����)</th>
						<th>�����</th>
						<th>���ð�</th>
						<th>��û�ڼ�</th>
						<th>�����</th>
					</tr>
				</thead>
				<tbody>
					<%
					If isArray(arrRs) Then
					For i=0 To UBound(arrRs, 2)
					%>
					<tr>
						<td><%=arrRs(1, i)%></td>
						<td>
							<div class="logo_box">
								<img src="/files/mentor/<%=arrRs(7, i)%>">
							</div>
						</td>
						<td><a href="./mentor_reg.asp?mentor_no=<%=arrRs(2, i)%>"><%=arrRs(3, i)%></a></td>
						<td><%=arrRs(5, i)%></td>
						<td>
							<%
								If arrRs(6, i) <> "" Then
									Dim arrVal : arrVal = Split(arrRs(6, i),",")
									Response.write arrVal(0) & ":00~"
									Response.write arrVal(1) & ":00"
								End If	
							%>
						</td>
						<td>
							��û�� : <%=arrRs(15,i)%>��
							<br>
							�������� : <%=arrRs(18,i)%>��
						</td>
						<td><%=arrRs(14, i)%></td>
					</tr>
					<%
					Next
					Else
					%>
					<tr>
						<td colspan="7" class="non_data">
							�˻������ �����ϴ�.
						</td>
					</tr>
					<%
					End If
					%>
				</tbody>
			</table>
			<div class="btn_area right">
				<a href="./mentor_reg.asp" class="btn blue">������ Ư��&��� ���</a>
			</div><!--btn_area -->

			<% Call putPage(page, stropt, pageCount) %>
			
		</div><!-- list_area -->
	</div><!-- //content -->
</div>
<!-- //���� -->

<!-- �ϴ� -->
<!--#include virtual = "/include/footer/footer.asp"-->
<!-- �ϴ� -->
</body>	
</html>