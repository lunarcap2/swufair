<% option Explicit %>
<!--#include virtual = "/common/common.asp"-->
<!--#include virtual = "/include/header/header.asp"-->
<!--#include virtual = "/wwwconf/function/db/DBConnection.asp"-->
<!--#include virtual = "/inc/function/code_function.asp"-->
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
	Dim mentorNo	: mentorNo		= Request("mentorNo")
	Dim page		: page			= Request("page")
	Dim pageSize	: pageSize		= 20

	If page = "" Then page=1
	page = CInt(page)

	If sDate = "" Then sDate = ""
	If eDate = "" Then eDate = ""
	If mentorNo = "" Then mentorNo = ""

	Dim stropt, i, ii
	stropt = "gubun="& gubun &"&schKeyword="&schKeyword &"&mentorNo="&mentorNo &"&sDate="&sDate &"&eDate="&eDate

	ConnectDB DBCon, Application("DBInfo_FAIR")

		ReDim Param(8)
		Param(0) = makeparam("@KW_GUBUN",adVarChar,adParamInput,100,gubun)
		Param(1) = makeparam("@KW",adVarChar,adParamInput,100,schKeyword)
		Param(2) = makeparam("@MENTORING_NO",adInteger,adParamInput,4,mentorNo)
		Param(3) = makeparam("@S_DATE",adVarChar,adParamInput,10,sDate)
		Param(4) = makeparam("@E_DATE",adVarChar,adParamInput,10,eDate)
		Param(5) = makeparam("@USER_ID",adVarChar,adParamInput,20,"")
		Param(6) = makeparam("@PAGE",adInteger,adParamInput,4,page)
		Param(7) = makeparam("@PAGE_SIZE",adInteger,adParamInput,4,pagesize)
		Param(8) = makeparam("@TOTAL_CNT",adInteger,adParamOutput,4,"")

		Dim arrRs, totalCnt, pageCount
		arrRs		= arrGetRsSP(DBcon, "asp_������_�������_��������_����Ʈ", Param, "", "")
		totalCnt	= getParamOutputValue(Param, "@TOTAL_CNT")
		pageCount	= Fix(((totalCnt-1)/PageSize) +1) 'int(totalCnt / pagesize) + 1


		' ��� �����о� ���� - �˻��ڽ� ��¿�
		ReDim Param(8)
		Param(0) = makeparam("@KW",adVarChar,adParamInput,100,"")
		Param(1) = makeparam("@S_DATE",adVarChar,adParamInput,10,"")
		Param(2) = makeparam("@E_DATE",adVarChar,adParamInput,10,"")
		Param(3) = makeparam("@MENTOR_NO",adInteger,adParamInput,4,"")
		Param(4) = makeparam("@USER_ID",adVarChar,adParamInput,20,"")
		Param(5) = makeparam("@PAGE",adInteger,adParamInput,4,1)
		Param(6) = makeparam("@PAGE_SIZE",adInteger,adParamInput,4,1000)
		Param(7) = makeparam("@TOTAL_CNT",adInteger,adParamOutput,4,"")
		Param(8) = makeparam("@MENTORING_DAY",adVarChar,adParamInput,10,"")

		Dim arrRsCounsel
		arrRsCounsel = arrGetRsSP(DBcon, "asp_������_�������_��Ȳ", Param, "", "")



		Dim strQuery, arrRsCnt
		strQuery = ""
		strQuery = strQuery & "SELECT COUNT(IDX) AS CNT FROM ���_�������� WITH(NOLOCK) UNION ALL "
		strQuery = strQuery & "SELECT COUNT(CNT) FROM (SELECT COUNT(IDX) AS CNT FROM ���_�������� WITH(NOLOCK) GROUP BY ���ξ��̵�) AS T"
		arrRsCnt = arrGetRsSql(DBcon, strQuery, "", "")

	DisconnectDB DBCon
%>
<script type="text/javascript">

	$(document).ready(function () {
		var gubun = '<%=gubun%>';
		if (gubun != "") {
			$('#gubun').val(gubun);
		}

		var mentorNo = '<%=mentorNo%>';
		if (mentorNo != "") {
			$('#mentorNo').val(mentorNo);
		}
	});
	
	// �˻�
	function fn_search() {
		var obj = document.frm_list;
		obj.action = "question_list.asp";
		obj.submit();
	}

	// �˻� �ʱ�ȭ
	function fn_reset() {
		var obj = document.frm_list;
		obj.gubun.value			= "";
		obj.schKeyword.value	= "";
		obj.mentorNo.value		= "";		
		obj.sDate.value	= "";
		obj.eDate.value	= "";
		obj.action	= "question_list.asp";
		obj.submit();
	}
	
	// �������� 
	function fn_quest_view(obj) {
		var mento_info, mento_day, quest_cont
		mento_info	= $(obj).parents("tr").find("#mento_biz").text();
		mento_day	= $(obj).parents("tr").find("#mento_day").text();
		quest_cont	= $(obj).parents("tr").find("#quest_cont").val();
		
		$("#pop_mentor_info").text(mento_info);
		$("#pop_mentor_day").text(mento_day);
		$("#pop_quest_cont").text(quest_cont);
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
			<h3>��������</h3>
		</div>
		<div class="navi">
			<ul>
				<li><a href="javascript:">Ȩ</a></li>
				<li><a href="javascript:">��������</a></li>
			</ul>
		</div>

		<!-- �Ǹ޴� -->
		<br>
		<div class="s2_tab_tit">
			<!-- ���ݱ� ������� -->			
			<a href="/admin/board/board_list.asp">��������</a>
			<a href="/admin/mentoring/user_list.asp">������û ��Ȳ</a>
			<a href="/admin/mentoring/apply_list.asp"><font size="2">������ Ư��&��� ��û��</font></a>
			<a href="/admin/mentoring/lcture_apply_list.asp">��.â��Ư�� ��û��</a>
			<a href="/admin/mentoring/question_list.asp" class="on">��������</a>
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
										<!-- <option value="3">E-mail</option> -->
									</select>
								</span>
								<input type="text" class="txt" id="schKeyword" name="schKeyword" placeholder="�˻�� �Է��� �ּ���." value="<%=schKeyword%>" style="width:760px;">
							</div>
						</td>
					</tr>
					<tr>
						<th>�����о�</th>
						<td class="tb_sch">
							<span class="selectbox" style="width:434px;">
								<span class="">����</span>
								<select id="mentorNo" name="mentorNo" title="�����о�">
									<option value="">����</option>
									<%
									If isArray(arrRsCounsel) Then
										For i=0 To UBound(arrRsCounsel, 2)
									%>
									<option value="<%=arrRsCounsel(2, i)%>"><%=arrRsCounsel(3, i)%></option>
									<%
										Next
									End If
									%>
								</select>
							</span>
						</td>
					</tr>
					<tr>
						<th>�Ⱓ</th>
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
				<p class="txt">
					(�������� ��û�� : <span><%=FormatNumber(arrRsCnt(0, 1),0)%></span>��, �������� ��ϰǼ� : <span><%=FormatNumber(arrRsCnt(0, 0),0)%></span>�� / <%=Date()%> ����)
					<button type="button" class="btn down" onclick="location.href='/admin/excel_download/question_list.asp?<%=stropt%>'">EXCEL Down</button>
				</p>
			</div>

			<table class="tb">
				<colgroup>
					<col style="width:100px" />
					<col style="width:180px" />
					<col style="width:200px" />
					<col />
					<col style="width:200px" />
					<col style="width:100px" />
				</colgroup>
				<thead>
					<tr>
						<th>No</th>
						<th>�̸�(ID)</th>
						<th>���������</th>
						<th>�����о�</th>
						<th>��������ȸ �Ͻ�</th>
						<th>��������</th>
					</tr>
				</thead>
				<tbody>
					<%
					If isArray(arrRs) Then
						For i=0 To UBound(arrRs, 2)
					%>
					<tr>
						<td><%=arrRs(1, i)%></td>
						<td><%=arrRs(3, i)%>(<%=Replace(arrRs(2, i), "_wk", "")%>)</td>
						<td><%=arrRs(14, i)%></td>
						<td id="mento_biz"><%=arrRs(7, i)%></td>
						<td id="mento_day"><%=arrRs(9, i)%>&nbsp;<%=getInterviewTime(arrRs(10, i))%></td>
						<td>
							<input type="hidden" id="quest_cont" value="<%=arrRs(13, i)%>">
							<a href="#pop1" class="pop" onclick="fn_quest_view(this);">[��������]</a>
						</td>
					</tr>
					<%
						Next
					Else
					%>
					<tr>
						<td colspan="6" class="non_data">�˻������ �����ϴ�.</td>
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



<div class="pop_up" id="pop1">
	<div class="pop">
		<div class="pop_wrap">
			<div class="pop_head">
				<h3>������� ��������</h3>
			</div>
			<div class="pop_body">

				<div class="tb_area">
					<table class="tb tc">
						<colgroup>
							<col style="width:20%">
							<col style="width:30%">
							<col style="width:20%">
							<col>
						</colgroup>
						<tbody>
							<tr>
								<th>������</th>
								<td><span id="pop_mentor_info"></span></td>
								<th>���丵 �Ͻ�</th>
								<td><span id="pop_mentor_day"></span></td>
							</tr>
							<tr>
								<td colspan="4" class="input_txt">
									<textarea id="pop_quest_cont"></textarea>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
			<div class="pop_footer">
				<div class="btn_area">
					<button type="button" class="btn blue close" onclick="">Ȯ��</button>
				</div>
			</div>

			<a href="#none" class="pop_close">�ݱ�</a>
		</div><!--.popWrap-->
	</div><!--.pop-->
	<span class="dim close"></span>
</div>


</body>
</html>
