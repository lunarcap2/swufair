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
	
	Dim i
	Dim mentor_day	: mentor_day		= Request("mentor_day")
	Dim mentor_titNo	: mentor_titNo	= Request("mentor_titNo")

	If mentor_day = "" Then mentor_day = "2020-11-09"
	

	ConnectDB DBCon, Application("DBInfo_FAIR")

		ReDim Param(2)
		Param(0) = makeparam("@consultDay",adVarChar,adParamInput,10,mentor_day)
		Param(1) = makeparam("@consultTime",adVarChar,adParamInput,2,"")
		Param(2) = makeparam("@consultNo",adInteger,adParamInput,4,mentor_titNo)

		Dim arrRsMentor
		arrRsMentor = arrGetRsSP(DBcon, "asp_������_���ڹ߼�_����Ʈ", Param, "", "")


		Dim strQuery, arrRs
		strQuery = ""
		strQuery = strQuery & "SELECT �������, ��Ϲ�ȣ FROM ���_���� WITH(NOLOCK) WHERE ������� = '" & mentor_day & "'"
		arrRs = arrGetRsSql(DBcon, strQuery, "", "")

	DisconnectDB DBCon
%>
<script type="text/javascript">
	$(document).ready(function () {
		var mentor_titNo = '<%=mentor_titNo%>';
		if (mentor_titNo != "") {
			$('#mentor_tit').val(mentor_titNo);
		}
	});
	
	//��¥Ŭ�� (�˻�)
	function fn_sch_mentor_day(_val) {
		var obj = document.frm_list;

		obj.mentor_day.value	= _val;
		obj.mentor_titNo.value	= "";
		obj.action = "send_sms_list.asp";
		obj.submit();
	}

	//��� ����
	function fn_pop_sms_view(_consult_day, _consult_no, _consult_time) {
		$("#consult_day").val(_consult_day);
		$("#consult_no").val(_consult_no);
		$("#consult_time").val(_consult_time);

		$.ajax({
			url: "./send_sms_view_pop.asp",
			type: "POST",
			dataType: "html",
			data: ({
				"montoring_date": _consult_day,
				"montoring_no": _consult_no,
				"montoring_time": _consult_time
			}),
			success: function (data) {
				$('#pop_sms_view').html(data);
			},
			error: function (req, status, err) {
				alert("ó�� ���� ������ �߻��Ͽ����ϴ�.\n" + err);
			}
		});
	}
	
	//��ܺ��� ����¡
	function fn_pop_sms_pageingView(_page) {	
		$.ajax({
			url: "./send_sms_view_pop.asp",
			type: "POST",
			dataType: "html",
			data: ({
				"page": _page,
				"montoring_date": $("#consult_day").val(),
				"montoring_no": $("#consult_no").val(),
				"montoring_time": $("#consult_time").val()
			}),
			success: function (data) {
				$('#pop_sms_view').html(data);
			},
			error: function (req, status, err) {
				alert("ó�� ���� ������ �߻��Ͽ����ϴ�.\n" + err);
			}
		});
	}

	function fn_sms_apply(obj, _val, _montoring_date, _montoring_time) {

		$('#mentor_no').val(_val);
		$('#user_hp').val("");
		$("#montoring_date").val(_montoring_date);
		$("#montoring_time").val(_montoring_time);
		
		var mentor_day = "<%=mentor_day%>";
		var mentor_time = $(obj).parents('tr').find('td').eq(0).text();
		
		var mentor_com = $(obj).parents('tr').find('td').eq(1).text();
		var mentor_name = $(obj).parents('tr').find('td').eq(3).text();
		var apply_cnt = $(obj).parents('tr').find('td').eq(4).text();
		var mentor_info = mentor_com;
		var mentor_day_data = mentor_day.split('-')[1] + "�� " + mentor_day.split('-')[2] + "��"

		var send_list = "";
		send_list = mentor_info + " " + mentor_day + " / " + mentor_time + " ��û�� " + apply_cnt;
		$('#sms_send_list').text(send_list);

		var str_sms = "";
		str_sms += "�ȳ��ϼ���. \n";
		str_sms += "<%=site_short_name%> ��繫�� �Դϴ�.\n";
		str_sms += "��û�Ͻ� ������� �Ͻÿ�\n";
		str_sms += "ȭ����� �ּҸ� �����帳�ϴ�.\n";
		str_sms += "\n";
		str_sms += "������� �Ͻ� : " + mentor_day_data + " / " + mentor_time + "\n";
		str_sms += "������ : " + mentor_info + "\n";
		str_sms += "ȭ����� �ּ� : \n";
		str_sms += "\n";
		str_sms += "����ÿ� ��ȭ�� [�й��̸�]���� ������ ���� �ʰ� �������ּ���.";
		
		$('#sms_cont').val("");
		$('#sms_cont').val(str_sms);
	}
	
	//���� ����
	function fn_sms_send() {

		if ($('#mentor_no').val() == "" && $('#user_hp').val() == "") {
			alert("���ڹ߼� ����ڸ� ����(�޼��� ����)���ּ���.");
			return
		}

		if(confirm("���ڸ� �߼� �Ͻðڽ��ϱ�?")) {
			$('#frm_sms').attr('action', 'proc_send_sms.asp');
			$('#frm_sms').submit();
		}

	}

	function fn_sch_consultTit() {
		var obj = document.frm_list;

		obj.mentor_titNo.value	= $("#mentor_tit").val();
		obj.action = "send_sms_list.asp";
		obj.submit();
	}

</script>
</head>

<body>

<!-- ��� -->
<!--#include virtual = "/include/gnb/topMenu.asp"-->

<form method="post" id="frm_list" name="frm_list">
	<input type="hidden" id="mentor_day" name="mentor_day" value="<%=mentor_day%>">
	<input type="hidden" id="mentor_titNo" name="mentor_titNo" value="<%=mentor_titNo%>">
</form>

<!-- ������ -->
<div id="contents" class="admin">
	<div class="content">
		<div class="navi">
			<ul>
				<li><a href="#none;">Ȩ</a></li>
				<li><a href="#none;">������ Ư��&��� ���ڹ߼�</a></li>
			</ul>
		</div>
		<div class="send_area">
			<div class="tit">
				<h3>������ Ư��&��� ���ڹ߼�</h3>
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
			<a href="/admin/mentoring/send_sms_list.asp" class="on"><font size="2">������ Ư��&��� ���ڹ߼�</font></a>
			<a href="/admin/mentoring/lcture_send_sms_list.asp">��.â��Ư�� ���ڹ߼�</a>
			<a href="/admin/mentoring/mentor_list.asp"><font size="2">������ Ư��&��� ��������</font></a>
			<a href="/admin/mentoring/lcture_list.asp">��.â��Ư�� ��� ����</a>
		</div>
		<br>
		<!-- //�Ǹ޴� -->

			<div class="left_box">
				<h4>���ڹ߼� ��ü ������</h4>
				<ul class="lb_date">
					<% For i=0 To p_schedule_len %>
					<li><button type="button" <%If mentor_day = p_scheduleDate(i, 0) Then%>class="on"<%End If%> onclick="fn_sch_mentor_day('<%=p_scheduleDate(i, 0)%>')"><%=p_scheduleDate(i, 1)%></button></li>
					<% Next %>
				</ul>
				<script>
					$(".lb_date li button").click(function() {
						$(".lb_date button").removeClass("on");
						$(this).addClass("on"); 
						return false;
					});
				</script>
				
				<!--
				<span class="selectbox" style="width:434px;">
					<span class="">��ü</span>
					<select id="mentor_tit" name="mentor_tit" title="����" onchange="fn_sch_consultTit();">
						<option value="">��ü</option>
						<%
							If isArray(arrRs) Then
								For i=0 To UBound(arrRs,2)
						%>
						<option value="<%=arrRs(1,i)%>"><%=arrRs(0,i)%></option>
						<%
								Next
							End If
						%>
					</select>
				</span>
				<br><br>
				-->
				<table class="tb tc">
					<colgroup>
						<col />
						<col />
						<col />
						<col />
						<col />
					</colgroup>
					<thead>
						<tr>
							<th>�ð�</th>
							<th>����</th>
							<th>��û�ڼ�</th>
							<th>���</th>
							<th>�޼���</th>
						</tr>
					</thead>
					<tbody>
						<%
							If isArray(arrRsMentor) Then 
								For i=0 To UBound(arrRsMentor, 2)
								Dim consult_time, consult_tit, consult_applyCnt, consult_no, consult_day
								consult_time		= arrRsMentor(3, i)
								consult_tit			= arrRsMentor(4, i)
								consult_applyCnt	= arrRsMentor(0, i)
								consult_no			= arrRsMentor(1, i)
								consult_day			= arrRsMentor(2, i)


								' ����ȸ �ð� ����
								Dim arrVal, mentoring_stime, mentoring_etime
								arrVal = Split(consult_time,",")
								mentoring_stime = arrVal(0) & ":00~"
								mentoring_etime = arrVal(1) & ":00"
						%>
						<tr>
							<td><%=mentoring_stime & mentoring_etime%></td>
							<td><%=consult_tit%></td>
							<td><%=consult_applyCnt%>��</td>
							<% If consult_applyCnt > 0 Then %>
							<td>
								<a href="#pop1" class="btn gray pop" onclick="fn_pop_sms_view('<%=consult_day%>', '<%=consult_no%>', '<%=consult_time%>');">����</a>
								<input type="hidden" id="consult_day" name="consult_day" value=""/>
								<input type="hidden" id="consult_no" name="consult_no" value=""/>
								<input type="hidden" id="consult_time" name="consult_time" value=""/>
							</td>
							<td><a href="javascript:" class="btn blue" onclick="fn_sms_apply(this, '<%=consult_no%>', '<%=consult_day%>', '<%=consult_time%>')">����</a></td>
							<% Else %>
							<td></td>
							<td></td>
							<% End If %>
						</tr>
						<%
								Next
							Else
						%>
						<tr>
							<td colspan="5">�ش��Ͽ� ��ϵ� ������ Ư��&����� �����ϴ�.</td>
						</tr>
						<% End If %>
					</tbody>
				</table>
			</div>
			<div class="right_box">
			<form method="post" id="frm_sms" name="frm_sms">
				<input type="hidden" id="mentor_no" name="mentor_no" value="">
				<input type="hidden" id="user_hp" name="user_hp" value="">
				<input type="hidden" id="montoring_date" name="montoring_date" value="">
				<input type="hidden" id="montoring_time" name="montoring_time" value="">

				<textarea id="sms_cont" name="sms_cont"></textarea>
				<span>�߼۴�� : </span><span id="sms_send_list"></span>
				<br>
				<button type="button" onclick="fn_sms_send()">������</button>
			</form>
			</div>
		</div>
		
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
				<h3>��ܺ���</h3>
			</div>
			<div class="pop_body" id="pop_sms_view">
				
			</div>

			<div class="pop_footer">
				<div class="btn_area">
					<button type="button" class="btn blue" onclick="$(this).parents('.pop_up').hide().find('.dim').hide();">Ȯ��</button>
				</div>
			</div>

			<a href="#none" class="pop_close">�ݱ�</a>
		</div><!--.popWrap-->
	</div><!--.pop-->
	<span class="dim close"></span>
</div>

</body>
</html>
