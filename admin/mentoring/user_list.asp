<% option Explicit %>
<!--#include virtual = "/common/common.asp"-->
<!--#include virtual = "/include/header/header.asp"-->
<!--#include virtual = "/wwwconf/function/db/DBConnection.asp"-->
<!--#include virtual = "/inc/function/paging.asp"-->
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

	Dim gubun		: gubun			= Request("gubun")
	Dim schKeyword	: schKeyword	= Request("schKeyword") ' �˻���(����/����)
	Dim sDate		: sDate			= Request("sDate")
	Dim eDate		: eDate			= Request("eDate")
	Dim page		: page			= Request("page")
	Dim pageSize	: pageSize		= 20

	If page = "" Then page=1
	page = CInt(page)

	If sDate = "" Then sDate = ""
	If eDate = "" Then eDate = ""

	Dim stropt, i, ii
	stropt = "gubun="& gubun &"&schKeyword="&schKeyword &"&sDate="&sDate &"&eDate="&eDate

	ConnectDB DBCon, Application("DBInfo_FAIR")

		Dim Param(7)
		Param(0) = makeparam("@KW_GUBUN",adVarChar,adParamInput,100,gubun)
		Param(1) = makeparam("@KW",adVarChar,adParamInput,100,schKeyword)
		Param(2) = makeparam("@MENTORING_NO",adInteger,adParamInput,4,"")
		Param(3) = makeparam("@S_DATE",adVarChar,adParamInput,10,sDate)
		Param(4) = makeparam("@E_DATE",adVarChar,adParamInput,10,eDate)
		Param(5) = makeparam("@page",adInteger,adParamInput,4,page)
		Param(6) = makeparam("@pagesize",adInteger,adParamInput,4,pagesize)
		Param(7) = makeparam("@totalcnt",adInteger,adParamOutput,4,"")

		Dim arrRs, totalCnt, pageCount
		arrRs = arrGetRsSP(DBcon, "asp_������_ȸ������_��Ȳ", Param, "", "")
		totalCnt	= getParamOutputValue(Param, "@totalcnt")
		pageCount	= Fix(((totalCnt-1)/PageSize) +1) 'int(totalCnt / pagesize) + 1

	DisconnectDB DBCon
%>
<script type="text/javascript">

	$(document).ready(function () {
		var gubun = '<%=gubun%>';
		if (gubun != "") {
			$('#gubun').val(gubun);
		}
	});
	
	// �˻�
	function fn_search() {
		var obj = document.frm_list;
		obj.action = "user_list.asp";
		obj.submit();
	}

	// �˻� �ʱ�ȭ
	function fn_reset() {
		var obj = document.frm_list;
		obj.gubun.value	= "";
		obj.schKeyword.value	= "";
		obj.sDate.value	= "";
		obj.eDate.value	= "";
		obj.action				= "user_list.asp";
		obj.submit();
	}

	function fn_pop_user_info(obj, _val) {
		var user_id = _val;
		var user_name = $(obj).parents("tr").find("td").eq(1).text();
		var user_hp = $(obj).parents("tr").find("td").eq(3).text();
		var user_email = $(obj).parents("tr").find("td").eq(2).text();

		$("#pop_user_id").val(user_id);
		$("#pop_user_name").text(user_name);
		$("#pop_user_hp").val(user_hp);
		$("#pop_user_email").val(user_email);
	}

	function fn_user_edit() {
		if (confirm("ȸ�������� �����Ͻðڽ��ϱ�?")) {
			$("#frm_user_info").attr("action", "./proc_user_edit.asp");
			$("#frm_user_info").submit();
		}
	}

</script>
</head>

<body>

<!-- ��� -->
<!--#include virtual = "/include/gnb/topMenu.asp"-->

<!-- ������ -->
<div id="contents" class="admin">
	<div class="content">
		<div class="tit">
			<h3>������û ��Ȳ</h3>
		</div>
		<div class="navi">
			<ul>
				<li><a href="#none;">Ȩ</a></li>
				<li><a href="#none;">������û ��Ȳ</a></li>
			</ul>
		</div>
		
		<!-- �Ǹ޴� -->
		<br>
		<div class="s2_tab_tit">
			<!-- ���ݱ� ������� -->			
			<a href="/admin/board/board_list.asp">��������</a>
			<a href="/admin/mentoring/user_list.asp" class="on">������û ��Ȳ</a>
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

		<div class="sch_area">
			<form method="post" id="frm_list" name="frm_list">
			<table class="tb">
				<colgroup>
					<col style="width:200px">
					<col>
				</colgroup>
				<tbody>
					<tr>
						<th>ȸ��</th>
						<td>
							<div class="sel_input">
								<span class="selectbox" style="width:206px;">
									<span class="">����</span>
									<select id="gubun" name="gubun" title="ȸ��">
										<option value="">����</option>
										<option value="1">�̸�</option>
										<option value="2">�޴���</option>
									</select>
								</span>
								<input type="text" class="txt" id="schKeyword" name="schKeyword" placeholder="�˻�� �Է��� �ּ���." value="<%=schKeyword%>" style="width:760px;">
							</div>
						</td>
					</tr>
					<tr>
						<th>�Ⱓ�˻�</th>
						<td class="tb_sch">
							<div class="datePick">
								<span>
									<input type="text" class="datepicker two" name="sDate" id="searchStartDate1" value="<%=sDate%>" style="width:206px;">
									<button type="button" class="btncalendar dateclick">��¥����</button>
								</span>
								<span class="hyphen">~</span>
								<span>
									<input type="text" class="datepicker two" name="eDate" id="searchEndDate1" value="<%=eDate%>" style="width:206px;">
									<button type="button" class="btncalendar dateclick">��¥����</button>
								</span>
							</div>
						</td>
					</tr>
				</tbody>
			</table>
			<div class="btn_area right">
				<a href="javascript:" class="btn blue" onclick="fn_search()">�˻�</a>
				<a href="javascript:" class="btn gray" onclick="fn_reset()">�ʱ�ȭ</a>
			</div><!--btn_area -->
			</form>
		</div>
		<div class="list_area">
			<div class="left_box">
				<p class="txt">(������û �� : <span><%=totalCnt%></span> ��, <%=Date()%> ����)</p>
				<button type="button" class="btn down" onclick="location.href='/admin/excel_download/user_list.asp?<%=stropt%>'">EXCEL Down</button>
			</div>

			<table class="tb">
				<colgroup>
					<col style="width:100px" />
					<col style="width:220px" />
					<col style="width:210px" />
					<col style="width:200px" />
					<col style="width:150px" />
					<col style="width:120px" />
					<col style="width:120px" />
					<col />
				</colgroup>
				<thead>
					<tr>
						<th>No</th>
						<th>�̸�(ID)</th>
						<th>�а�(���� �� ���п���)</th>
						<th>�޴�����ȣ</th>
						<th>������</th>
						<th>������� ��û</th>
						<th>�������� ���</th>
						<th>��������</th>
					</tr>
				</thead>
				<tbody>
					<%
						If isArray(arrRs) Then
							For i=0 To UBound(arrRs, 2)

							Dim graduated_state
							If arrRs(10, i) = "1" Then
								graduated_state = "����"
							ElseIf arrRs(10, i) = "2" Then
								graduated_state = "��������(4�г�)"
							ElseIf arrRs(10, i) = "3" Then
								graduated_state = "������"
							ElseIf arrRs(10, i) = "4" Then
								graduated_state = "����"
							ElseIf arrRs(10, i) = "5" Then
								graduated_state = "����"
							ElseIf arrRs(10, i) = "6" Then
								graduated_state = "��Ÿ"
							Else
								graduated_state = ""
							End If
					%>
					<tr>
						<td><%=arrRs(1, i)%></td>
						<td><%=arrRs(3, i)%>(<%=Replace(arrRs(2, i), "_wk", "")%>)</td>
						<td><%=arrRs(9, i)%><br><%=graduated_state%></td>
						<td><%=arrRs(4, i)%></td>
						<td><%=arrRs(8, i)%></td>
						<td><%=arrRs(6, i)%></td>
						<td><%=arrRs(7, i)%></td>
						<td><a href="#pop1" class="pop" onclick="fn_pop_user_info(this, '<%=arrRs(2, i)%>')">[��������]</a></td>
					</tr>
					<%
							Next
						Else
					%>
					<tr>
						<td colspan="8" class="non_data">
							�˻������ �����ϴ�.
						</td>
					</tr>
					<%
						End If 
					%>
				</tbody>
			</table>
			
			<% Call putPage(page, stropt, pageCount) %>
			
		</div><!-- list_area -->
	</div><!-- //content -->
</div><!-- //contents -->
<!--// ������ -->


<!-- �ϴ� -->
<!--#include virtual = "/include/footer/footer.asp"-->
<!-- �ϴ� -->


<form method="post" id="frm_user_info" name="frm_user_info">
<div class="pop_up" id="pop1">
	<div class="pop">
		<div class="pop_wrap">
			<div class="pop_head">
				<h3>ȸ������ ����</h3>
			</div>
			<div class="pop_body">
				<div class="tb_area">
					<table class="tb">
						<colgroup>
							<col style="width:200px">
							<col>
						</colgroup>
						<tbody>
							<tr>
								<th>�̸�(ID)</th>
								<input type="hidden" id="pop_user_id" name="pop_user_id" value="">
								<td id="pop_user_name">ȫ�浿 (Takdi78)</td>
							</tr>
							<tr>
								<th><span class="pil">�ʼ�</span>�޴���</th>
								<td><input type="text" class="txt" id="pop_user_hp" name="pop_user_hp" style="width:100%;" onkeyup="removeChar(event); changePhoneType(this);" onkeydown="return onlyNumber(event)"></td>
							</tr>

							<script type="text/javascript">
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
							</script>
							<!--
							<tr>
								<th><span class="pil">�ʼ�</span>�̸���</th>
								<td><input type="text" class="txt" id="pop_user_email" name="pop_user_email" style="width:100%;"></td>
							</tr>
							-->
						</tbody>
					</table>
				</div>
			</div>
			<div class="pop_footer">
				<div class="btn_area">
					<button type="button" class="btn blue" onclick="fn_user_edit()">����</button>
					<button type="button" class="btn gray close">���</button>
				</div>
			</div>
			<a href="#none" class="pop_close">�ݱ�</a>
		</div><!--.popWrap-->
	</div><!--.pop-->
	<span class="dim close"></span>
</div>
</form>


</body>
</html>
