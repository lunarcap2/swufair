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
	Dim lctureDay	: lctureDay		= Request("lctureDay")
	Dim lctureTit	: lctureTit		= Request("lctureTit")
	Dim page		: page			= Request("page")
	Dim pageSize	: pageSize		= 20

	If page = "" Then page=1
	page = CInt(page)

	If lctureDay = "" Then lctureDay = ""
	If lctureTit = "" Then lctureTit = ""

	Dim stropt, i, ii
	stropt = "gubun=" & gubun & "&schKeyword=" & schKeyword & "&lctureDay=" & lctureDay & "&lctureTit=" & lctureTit

	ConnectDB DBCon, Application("DBInfo_FAIR")

		ReDim Param(6)
		Param(0) = makeparam("@KW_GUBUN",adVarChar,adParamInput,100,gubun)
		Param(1) = makeparam("@KW",adVarChar,adParamInput,100,schKeyword)
		Param(2) = makeparam("@S_DATE",adVarChar,adParamInput,10,lctureDay)
		Param(3) = makeparam("@LCTURE_TIT",adVarChar,adParamInput,100,lctureTit)
		Param(4) = makeparam("@PAGE",adInteger,adParamInput,4,page)
		Param(5) = makeparam("@PAGE_SIZE",adInteger,adParamInput,4,pagesize)
		Param(6) = makeparam("@TOTAL_CNT",adInteger,adParamOutput,4,"")

		Dim arrRs, totalCnt, pageCount
		arrRs		= arrGetRsSP(DBcon, "asp_������_Ư����û��_����Ʈ", Param, "", "")
		totalCnt	= getParamOutputValue(Param, "@TOTAL_CNT")
		pageCount	= Fix(((totalCnt-1)/PageSize) +1) 'int(totalCnt / pagesize) + 1

		Dim strQuery, arrRsCnt
		strQuery = ""
		strQuery = strQuery & "SELECT COUNT(IDX) AS CNT FROM ���丵_����_��û���� WITH(NOLOCK) UNION ALL "
		strQuery = strQuery & "SELECT COUNT(CNT) FROM (SELECT COUNT(IDX) AS CNT FROM ���丵_����_��û���� WITH(NOLOCK) GROUP BY ���ξ��̵�) AS T"
		arrRsCnt = arrGetRsSql(DBcon, strQuery, "", "")

	DisconnectDB DBCon
%>

<script type="text/javascript">
	$(document).ready(function () {
		var gubun = '<%=gubun%>';
		if (gubun != "") {
			$('#gubun').val(gubun);
		}

		var lctureDay = '<%=lctureDay%>';
		if (lctureDay != "") {
			$('#lctureDay').val(lctureDay);
			fn_set_lctureTit(lctureDay);
		}
	});

	// �˻�
	function fn_search() {
		var obj = document.frm_list;
		obj.action = "lcture_apply_list.asp";
		obj.submit();
	}

	// �˻� �ʱ�ȭ
	function fn_reset() {
		var obj = document.frm_list;
		
		obj.gubun.value			= "";
		obj.schKeyword.value	= "";
		obj.lctureDay.value		= "";
		$("#lctureTit").children("option:not(:first)").remove();
		
		obj.action				= "lcture_apply_list.asp";
		obj.submit();
	}

	//���ڼ��ÿ� ���� Ư������
	function fn_set_lctureTit() {
		$("#lctureTit").children("option:not(:first)").remove();

		$.ajax({
			url: "./ajax_set_lctureTit.asp",
			type: "POST",
			dataType: "html",
			data: ({
				"sel_lctureDay": $("#lctureDay").val()
			}),
			success: function (data) {
				$("#lctureTit").append(data);

				var lctureTit = '<%=lctureTit%>';
				if (lctureTit != "") {
					$("#lctureTit").each(function() {
						$(this).find("option[value='" + lctureTit + "']").prop("selected",true);
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

<div id="contents" class="admin">
	<div class="content">
		<div class="tit">
			<h3>��.â��Ư�� ��û��</h3>
		</div>

		<div class="navi">
			<ul>
				<li><a href="#none;">Ȩ</a></li>
				<li><a href="#none;">��.â��Ư�� ��û��</a></li>
			</ul>
		</div>

		<!-- �Ǹ޴� -->
		<br>
		<div class="s2_tab_tit">
			<!-- ���ݱ� ������� -->			
			<a href="/admin/board/board_list.asp">��������</a>
			<a href="/admin/mentoring/user_list.asp">������û ��Ȳ</a>
			<a href="/admin/mentoring/apply_list.asp"><font size="2">������ Ư��&��� ��û��</font></a>
			<a href="/admin/mentoring/lcture_apply_list.asp" class="on">��.â��Ư�� ��û��</a>
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
								<span class="selectbox" style="width:434px;">
									<span class="">����</span>
									<select id="lctureDay" name="lctureDay" title="Ư������" onchange="fn_set_lctureTit();">
										<option value="">����</option>
										<% For i=0 To p_schedule_len %>
										<option value="<%=p_scheduleDate(i, 0)%>"><%=p_scheduleDate(i, 1)%></option>
										<% Next %>
									</select>
								</span>
							</td>
						</tr>
						<tr>
							<th>Ư������</th>
							<td class="tb_sch">
								<span class="selectbox" style="width:434px;">
									<span class="">����</span>
									<select id="lctureTit" name="lctureTit" title="Ư����">
										<option value="">����</option>
									</select>
								</span>
							</td>
						</tr>
					</tbody>
				</table>

				<div class="btn_area right">
					<a href="javascript:" class="btn blue" onclick="fn_search();">�˻�</a>
					<a href="javascript:" class="btn gray" onclick="fn_reset();">�ʱ�ȭ</a>
				</div><!--btn_area -->
			</form>
		</div>

		<div class="list_area">
			<div class="left_box">
				<p class="txt">
					(Ư�� ��û�� : <span><%=arrRsCnt(0, 0)%></span> ��(�ߺ�����), <span><%=arrRsCnt(0, 1)%></span> �� (�ߺ�����) / <%=Date()%> ����)
					<button type="button" class="btn down" onclick="location.href='/admin/excel_download/lcture_apply_list.asp?<%=stropt%>'">EXCEL Down</button>
				</p>
			</div>

			<table class="tb">
				<colgroup>
					<col style="width:100px" />
					<col style="width:300px" />
					<col style="width:300px" />
					<col />
					<col />
					<col />
				</colgroup>

				<thead>
					<tr>
						<th rowspan="2">No</th>
						<th rowspan="2">Ư��</th>
						<th rowspan="2">�Ͻ�</th>
						<th colspan="3">��û�� ����</th>
					</tr>
					<tr>
						<th>�̸� (ID)</th>
						<th>�޴��� ��ȣ</th>
						<th>Ư�� ��û��</th>
					</tr>
				</thead>

				<tbody>
					<%
						If isArray(arrRs) Then
							For i=0 To UBound(arrRs,2)
							Dim lcture_no, lcture_tit, lcture_day, lcture_applyName, lcture_applyId, lcture_applyHp, lcture_applyDay
							lcture_no			= arrRs(1,i)	' No
							lcture_tit			= arrRs(2,i)	' ���Ǹ�
							lcture_day			= arrRs(3,i)	' ���ǽ����Ͻ�
							lcture_applyName	= arrRs(4,i)	' Ư����û��_����
							lcture_applyId		= arrRs(5,i)	' Ư����û��_���̵�
							lcture_applyHp		= arrRs(6,i)	' Ư����û��_�޴���
							lcture_applyDay		= arrRs(7,i)	' Ư����û��_�����
					%>
					<tr>
						<td><%=lcture_no%></td>
						<td><%=lcture_tit%></td>
						<td><%=lcture_day%></td>
						<td><%=lcture_applyName%>(<%=Replace(lcture_applyId,"_wk","")%>)</td>
						<td><%=lcture_applyHp%></td>
						<td><%=lcture_applyDay%></td>
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
		</div>
	</div>
</div>


<!-- �ϴ� -->
<!--#include virtual = "/include/footer/footer.asp"-->
<!-- �ϴ� -->

</body>
</html>
