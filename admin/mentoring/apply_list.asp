<% option Explicit %>
<!--#include virtual = "/common/common.asp"-->
<!--#include virtual = "/include/header/header.asp"-->
<!--#include virtual = "/wwwconf/function/db/DBConnection.asp"-->
<!--#include virtual = "/inc/function/paging.asp"-->
<!--#include virtual = "/inc/function/code_function.asp"-->
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
	Dim mentoring_date : mentoring_date = Request("mentoring_date")

	If page = "" Then page=1
	page = CInt(page)

	If sDate = "" Then sDate = ""
	If eDate = "" Then eDate = ""
	If mentorNo = "" Then mentorNo = ""
	If mentoring_date = "" Then mentoring_date = ""

	Dim stropt, i, ii
	stropt = "gubun="& gubun &"&schKeyword="&schKeyword &"&mentorNo="&mentorNo &"&sDate="&sDate &"&eDate="&eDate &"&mentoring_date="&mentoring_date

	ConnectDB DBCon, Application("DBInfo_FAIR")

		ReDim Param(10)
		Param(0) = makeparam("@KW_GUBUN",adVarChar,adParamInput,100,gubun)
		Param(1) = makeparam("@KW",adVarChar,adParamInput,100,schKeyword)
		Param(2) = makeparam("@MENTORING_NO",adInteger,adParamInput,4,mentorNo)
		Param(3) = makeparam("@S_DATE",adVarChar,adParamInput,10,sDate)
		Param(4) = makeparam("@E_DATE",adVarChar,adParamInput,10,eDate)
		Param(5) = makeparam("@USER_ID",adVarChar,adParamInput,20,"")
		Param(6) = makeparam("@PAGE",adInteger,adParamInput,4,page)
		Param(7) = makeparam("@PAGE_SIZE",adInteger,adParamInput,4,pagesize)
		Param(8) = makeparam("@TOTAL_CNT",adInteger,adParamOutput,4,"")
		Param(9) = makeparam("@MENTORING_DATE",adVarChar,adParamInput,10,mentoring_date)
		Param(10) = makeparam("@MENTORING_TIME",adVarChar,adParamInput,2,"")

		Dim arrRs, totalCnt, pageCount
		arrRs		= arrGetRsSP(DBcon, "asp_������_�������_��û_����Ʈ", Param, "", "")
		totalCnt	= getParamOutputValue(Param, "@TOTAL_CNT")
		pageCount	= Fix(((totalCnt-1)/PageSize) +1) 'int(totalCnt / pagesize) + 1



		ReDim Param(7)
		Param(0) = makeparam("@kw",adVarChar,adParamInput,100,"")
		Param(1) = makeparam("@S_DATE",adVarChar,adParamInput,10,"")
		Param(2) = makeparam("@E_DATE",adVarChar,adParamInput,10,"")
		Param(3) = makeparam("@MENTOR_NO",adInteger,adParamInput,4,"")
		Param(4) = makeparam("@USER_ID",adVarChar,adParamInput,20,"")
		Param(5) = makeparam("@PAGE",adInteger,adParamInput,4,1)
		Param(6) = makeparam("@PAGE_SIZE",adInteger,adParamInput,4,1000)
		Param(7) = makeparam("@TOTAL_CNT",adInteger,adParamOutput,4,"")

		Dim arrRsMentor
		arrRsMentor = arrGetRsSP(DBcon, "asp_������_�������_��Ȳ", Param, "", "")



		Dim strQuery, arrRsCnt
		strQuery = ""
		strQuery = strQuery & "SELECT COUNT(IDX) AS CNT FROM ���_��û���� WITH(NOLOCK) UNION ALL "
		strQuery = strQuery & "SELECT COUNT(CNT) FROM (SELECT COUNT(IDX) AS CNT FROM ���_��û���� WITH(NOLOCK) GROUP BY ���ξ��̵�) AS T"
		arrRsCnt = arrGetRsSql(DBcon, strQuery, "", "")

	DisconnectDB DBCon
%>
<script type="text/javascript">

	$(document).ready(function () {
		var gubun = '<%=gubun%>';
		if (gubun != "") {
			$('#gubun').val(gubun);
		}

		var mentoring_date = '<%=mentoring_date%>';
		if (mentoring_date != "") {
			$('#mentoring_date').val(mentoring_date);
			fn_set_mentorNo(mentoring_date);
		}
	});
	
	// �˻�
	function fn_search() {
		var obj = document.frm_list;
		obj.action = "apply_list.asp";
		obj.submit();
	}

	// �˻� �ʱ�ȭ
	function fn_reset() {
		var obj = document.frm_list;
		
		obj.gubun.value				= "";
		obj.schKeyword.value		= "";
		obj.mentoring_date.value	= "";
		$("#mentorNo").children("option:not(:first)").remove();

		obj.action					= "apply_list.asp";
		obj.submit();
	}

	function fn_set_mentorNo() {
		$("#mentorNo").children("option:not(:first)").remove();

		$.ajax({
			url: "./ajax_set_mentorNo.asp",
			type: "POST",
			dataType: "html",
			data: ({
				"sel_mentoring_date": $("#mentoring_date").val()
			}),
			success: function (data) {
				$("#mentorNo").append(data);

				var mentorNo = '<%=mentorNo%>';
				if (mentorNo != "") {
					$("#mentorNo").each(function() {
						$(this).find("option[value='" + mentorNo + "']").prop("selected",true);
						selectboxFnc(); //�����ڽ�
					});
				}
			},
			error: function (req, status, err) {
				alert("ó�� ���� ������ �߻��Ͽ����ϴ�.\n" + err);
			}
		});
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
			<h3>������ Ư��&��� ��û��</h3>
		</div>
		<div class="navi">
			<ul>
				<li><a href="#none;">Ȩ</a></li>
				<li><a href="#none;">������ Ư��&��� ��û��</a></li>
			</ul>
		</div>

		<!-- �Ǹ޴� -->
		<br>
		<div class="s2_tab_tit">
			<!-- ���ݱ� ������� -->			
			<a href="/admin/board/board_list.asp">��������</a>
			<a href="/admin/mentoring/user_list.asp">������û ��Ȳ</a>
			<a href="/admin/mentoring/apply_list.asp" class="on"><font size="2">������ Ư��&��� ��û��</font></a>
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
						<th>����</th>
						<td class="tb_sch">
							<span class="selectbox" style="width:206px;">
								<span class="">����</span>
								<select id="mentoring_date" name="mentoring_date" title="����" onchange="fn_set_mentorNo();">
									<option value="">����</option>
									<% For i=0 To p_schedule_len %>
									<option value="<%=p_scheduleDate(i, 0)%>"><%=p_scheduleDate(i, 1)%></option>
									<% Next %>
								</select>
							</span>
						</td>
					</tr>
					<tr>
						<th>������</th>
						<td class="tb_sch">
							<span class="selectbox" style="width:434px;">
								<span class="">����</span>
								<select id="mentorNo" name="mentorNo" title="�����">
									<option value="">����</option>
								</select>
							</span>
						</td>
					</tr>
					<!--
					<tr>
						<th>����</th>
						<td class="tb_sch">
							<div class="datePick">
								<span>
									<input type="text" class="datepicker" name="sDate" id="searchStartDate1" value="<%=sDate%>" style="width:206px;">
									<button type="button" class="btncalendar dateclick">��¥����</button>
								</span>
								<span class="hyphen">~</span>
								<span>
									<input type="text" class="datepicker" name="eDate" id="searchEndDate1" value="<%=eDate%>" style="width:206px;">
									<button type="button" class="btncalendar dateclick">��¥����</button>
								</span>
							</div>
						</td>
					</tr>
					-->
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
					(������� ��û�� : <span><%=arrRsCnt(0, 0)%></span> ��(�ߺ�����), <span><%=arrRsCnt(0, 1)%></span> �� (�ߺ�����) / <%=Date()%> ����)
					<button type="button" class="btn down" onclick="location.href='/admin/excel_download/apply_list.asp?<%=stropt%>'">EXCEL Down</button>
				</p>
			</div>
			<table class="tb">
				<colgroup>
					<col style="width:100px" />
					<col />
					<col />
					<col />

					<!--
					<col style="width:100px" />
					<col style="width:300px" />
					<col />
					<col style="width:280px" />
					<col style="width:280px" />
					-->
				</colgroup>
				<thead>
					<tr>
						<th rowspan="4">No</th>
						<th rowspan="4">����</th>
						<th colspan="4">��û�� ����</th>
					</tr>
					<tr>
						<th>�̸� (ID)</th>
						<th>�޴�����ȣ</th>
						<th>��� �Ͻ�</th>
						<th>��û��(�����)</th>
					</tr>
				</thead>
				<tbody>
					<%
					If isArray(arrRs) Then
					For i=0 To UBound(arrRs, 2)
					%>
					<tr>
						<td><%=arrRs(1, i)%></td>
						<td><%=arrRs(8, i)%></td>
						<td><%=arrRs(3, i)%>(<%=Replace(arrRs(2, i), "_wk", "")%>)</td>
						<td><%=arrRs(4, i)%></td>
						<td><%=arrRs(9, i)%><br><%=getInterviewTime(arrRs(12, i))%></td>
						<td><%=arrRs(6, i)%></td>
					</tr>
					<%
					Next
					Else
					%>
					<tr>
						<td colspan="6" class="non_data">
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

</body>
</html>
