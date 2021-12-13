<!--#include virtual="/wwwconf/function/db/DBConnection.asp"-->
<!--#include virtual="/common/common.asp"--> 
<!--#include virtual="/inc/function/paging.asp"-->
<%
'--------------------------------------------------------------------
'   Comment		: �Խ��� ���� - ����Ʈ
' 	History		: 2020-07-17, �̻��� 
'--------------------------------------------------------------------
Session.CodePage  = 949			'�ѱ�
Response.CharSet  = "euc-kr"	'�ѱ�
Response.AddHeader "Pragma","no-cache"
Response.AddHeader "cache-control", "no-staff"
Response.Expires  = -1

If Request.ServerVariables("HTTPS") = "off" Then 
	Response.redirect "https://"& Request.ServerVariables("HTTP_HOST") & Request.ServerVariables("URL") 
End If

' ������ ������ ��쿡�� ���� ���   
If Request.Cookies(site_code & "WKADMIN")("admin_id")="" Then 
	Response.Write "<script language=javascript>"&_
		"alert('�ش� �޴��� ���� ���� ������ �����ϴ�.');"&_
		"location.href='/';"&_
		"</script>"
	response.End 
End If


Dim gubun		: gubun			= Request("gubun")		' �Խ��� ����
Dim target		: target		= Request("target")		' �˻�����(����:1, ����:2)
Dim schKeyword	: schKeyword	= Request("schKeyword") ' �˻���(����/����)  
Dim page		: page			= Request("page")
Dim pageSize	: pageSize		= 5

If page="" Then page=1
page = CInt(page)

If gubun	= "" Then gubun		= ""
If target	= "" Then target	= "1"

ConnectDB DBCon, Application("DBInfo_FAIR")

Dim Param(6)
Param(0) = makeparam("@gubun",adChar,adParamInput,1,gubun)
Param(1) = makeparam("@target",adChar,adParamInput,1,target)
Param(2) = makeparam("@kw",adVarChar,adParamInput,100,schKeyword)
Param(3) = makeparam("@page",adInteger,adParamInput,4,page)
Param(4) = makeparam("@pagesize",adInteger,adParamInput,4,pagesize)
Param(5) = makeparam("@totalcnt",adInteger,adParamOutput,4,"")

Dim arrayList(2)
arrayList(0) = arrGetRsSP(DBcon,"usp_board_list",Param,"","")
arrayList(1) = getParamOutputValue(Param,"@totalcnt")

Dim arrRs		: arrRs		= arrayList(0)
Dim Tcnt		: Tcnt		= arrayList(1)
Dim pageCount	: pageCount = Fix(((Tcnt-1)/PageSize) +1) 'int(Tcnt / pagesize) + 1


DisconnectDB DBCon


Dim stropt
stropt = "gubun="&gubun&"&schKeyword="&schKeyword
%>
<!--#include virtual = "/include/header/header.asp"-->
<script type="text/javascript">
	<!--
	function fn_board_add() {
		var url = "board_form.asp";
		location.href = url;	
	}

	// Ű���� �˻�
	function fn_search() {
		var obj = document.frm_list;
		obj.action	= "board_list.asp";
		obj.submit();
	}

	// �˻� �ʱ�ȭ
	function fn_reset() {
		var obj = document.frm_list;
		obj.schKeyword.value	= "";
		obj.action				= "board_list.asp";
		obj.submit();
	}
	//-->
</script>
</head>
<body>

	<!-- ��� -->
	<!--#include virtual = "/include/gnb/topMenu.asp"-->
	<!-- ��� -->


	<!-- ���� -->
	<div id="contents" class="admin">
		<div class="content">
			<div class="navi">
				<ul>
					<li><a href="#none;">Ȩ</a></li>
					<li><a href="#none;">��������</a></li>
				</ul>
			</div>
			<div class="list_area">
				<div class="tit">
					<h3>��������</h3>
				</div>

				<!-- �Ǹ޴� -->
				<br>
				<div class="s2_tab_tit">
					<!-- ���ݱ� ������� -->			
					<a href="/admin/board/board_list.asp" class="on">��������</a>
					<a href="/admin/mentoring/user_list.asp">������û ��Ȳ</a>
					<a href="/admin/mentoring/apply_list.asp"><font size="2">������ Ư��&��� ��û��</font></a>
					<a href="/admin/mentoring/lcture_apply_list.asp">��.â��Ư�� ��û��</a>
					<a href="/admin/mentoring/question_list.asp">��������</a>
					<a href="/admin/mentoring/send_sms_list.asp"><font size="2">������ Ư��&��� ���ڹ߼�</font></a>
					<a href="/admin/mentoring/lcture_send_sms_list.asp">��.â��Ư�� ���ڹ߼�</a>
					<a href="/admin/mentoring/mentor_list.asp"><font size="2">������ Ư��&��� ��������</font></a>
					<a href="/admin/mentoring/lcture_list.asp">��.â��Ư�� ��� ����</a>
				</div>
				<br>
				<!-- //�Ǹ޴� -->

				<form method="post" id="frm_list" name="frm_list">
				<div class="right_box">
					<div class="sch_box">
						<input type="text" class="txt" id="schKeyword" name="schKeyword" placeholder="�˻�� �Է��� �ּ���." value="<%=schKeyword%>">
						<button type="button" class="btn" onclick="fn_search();">�˻�</button>
					</div>
				</div>
				</form>

				<table class="tb">
					<colgroup>
						<col style="width:100px">
						<col>
						<col style="width:200px">
					</colgroup>
					<thead>
						<tr>
							<th>No</th>
							<th>����</th>
							<th>�����</th>
						</tr>
					</thead>
					<tbody>
						<%
						Dim No : No = Tcnt - (PageSize * (page -1)) + 1
						Dim i, rs_seq, rs_gubun, rs_gubun_str, rs_title, rs_content, rs_regNm, rs_viewCnt, rs_regDt
						If IsArray(arrRs) Then
							For i=0 To UBound(arrRs,2)
								rs_seq		= Trim(arrRs(0,i))	' ��Ϲ�ȣ
								rs_gubun	= Trim(arrRs(1,i))	' �Խ��Ǳ���
								rs_title	= Trim(arrRs(5,i))	' ����
								rs_content	= Trim(arrRs(6,i))	' ����
								rs_regNm	= Trim(arrRs(3,i))	' ����ڸ�
								rs_viewCnt	= Trim(arrRs(7,i))	' ��ȸ��
								rs_regDt	= Left(Trim(arrRs(9,i)),10)	' �������

								Select Case rs_gubun
									Case 1 : rs_gubun_str = "��������"
									Case 2 : rs_gubun_str = "���ֹ�������(FAQ)"
									Case 3 : rs_gubun_str = "�̺�Ʈ"
								End Select

								No = No - 1
						%>
						<tr>
							<td><%=No%></td>
							<td class="subject">
								<a href="./board_form.asp?seq=<%=rs_seq%>&<%=stropt%>&page=<%=page%>"><%=rs_title%></a>
							</td>
							<td><%=rs_regDt%></td>
						</tr>
						<%
							Next
						Else
						%>
						<tr>
							<td colspan="3" class="non_data">
								�˻������ �����ϴ�.
							</td>
						</tr>
						<%
						End If
						%>
					</tbody>
				</table>
				<div class="btn_area right">
					<a href="javascript:" class="btn blue" onclick="fn_board_add();">�۾���</a>
				</div><!--btn_area -->

				<%Call putPage(page, stropt, pageCount)%>
				
			</div><!-- list_area -->
		</div><!-- //content -->
	</div>
	<!-- //���� -->


	<!-- �ϴ� -->
	<!--#include virtual = "/include/footer/footer.asp"-->
	<!-- �ϴ� -->

</body>
</html>