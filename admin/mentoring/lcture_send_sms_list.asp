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

	If mentor_day = "" Then mentor_day = "2020-11-09"
	

	ConnectDB DBCon, Application("DBInfo_FAIR")

		ReDim Param(1)
		Param(0) = makeparam("@consultDay",adVarChar,adParamInput,10,mentor_day)
		Param(1) = makeparam("@consultNo",adInteger,adParamInput,4,"")

		Dim arrRsMentor
		arrRsMentor = arrGetRsSP(DBcon, "asp_������_Ư�����ڹ߼�_����Ʈ", Param, "", "")

	DisconnectDB DBCon
%>
<script type="text/javascript">
	
	//��¥Ŭ�� (�˻�)
	function fn_sch_mentor_day(_val) {
		var obj = document.frm_list;

		obj.mentor_day.value	= _val;
		obj.action = "lcture_send_sms_list.asp";
		obj.submit();
	}

	//��� ����
	function fn_pop_sms_view(_consult_day, _consult_no) {
		$("#lcture_set_day").val(_consult_day);
		$("#lcture_set_no").val(_consult_no);

		$.ajax({
			url: "./lcture_send_sms_view_pop.asp",
			type: "POST",
			dataType: "html",
			data: ({
				"montoring_date": _consult_day,
				"montoring_no": _consult_no
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
			url: "./lcture_send_sms_view_pop.asp",
			type: "POST",
			dataType: "html",
			data: ({
				"page": _page,
				"montoring_date": $("#lcture_set_day").val(),
				"montoring_no": $("#lcture_set_no").val()
			}),
			success: function (data) {
				$('#pop_sms_view').html(data);
			},
			error: function (req, status, err) {
				alert("ó�� ���� ������ �߻��Ͽ����ϴ�.\n" + err);
			}
		});
	}

	function fn_sms_apply(obj, _val, _montoring_date) {

		$('#mentor_no').val(_val);
		$('#user_hp').val("");
		$("#montoring_date").val(_montoring_date);
		$("#montoring_time").val("");
		
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
		str_sms += "��û�Ͻ� Ư�� �Ͻÿ�\n";
		str_sms += "ȭ����� �ּҸ� �����帳�ϴ�.\n";
		str_sms += "\n";
		str_sms += "Ư�� �Ͻ� : " + mentor_day_data + " / " + mentor_time + "\n";
		str_sms += "Ư���� : " + mentor_info + "\n";
		str_sms += "ȭ����� �ּ� : \n";
		str_sms += "\n";
		str_sms += "���� �ʰ� ������ �ּ���.";
		
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
			$('#frm_sms').attr('action', 'proc_lcture_send_sms.asp');
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
</form>

<!-- ������ -->
<div id="contents" class="admin">
	<div class="content">
		<div class="navi">
			<ul>
				<li><a href="#none;">Ȩ</a></li>
				<li><a href="#none;">��.â��Ư�� ���ڹ߼�</a></li>
			</ul>
		</div>
		<div class="send_area">
			<div class="tit">
				<h3>��.â��Ư�� ���ڹ߼�</h3>
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
			<a href="/admin/mentoring/lcture_send_sms_list.asp" class="on">��.â��Ư�� ���ڹ߼�</a>
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
								Dim lcture_no, lcture_tit, lcture_day, lcture_stime, lcture_etime, lcture_applyCnt
								lcture_no		= arrRsMentor(0,i)	' ���ǹ�ȣ
								lcture_tit		= arrRsMentor(1,i)	' ���Ǹ�
								lcture_day		= arrRsMentor(2,i)	' ���ǽ�����
								lcture_stime	= arrRsMentor(3,i)	' ���ǽ��۽ð�
								lcture_etime	= arrRsMentor(4,i)	' ��������ð�
								lcture_applyCnt	= arrRsMentor(5,i)	' ��û�ڼ�
								
						%>
						<tr>
							<td><%=lcture_stime%>~<%=lcture_etime%></td>
							<td><%=lcture_tit%></td>
							<td><%=lcture_applyCnt%>��</td>
							<% If lcture_applyCnt > 0 Then %>
							<td>
								<a href="#pop1" class="btn gray pop" onclick="fn_pop_sms_view('<%=lcture_day%>', '<%=lcture_no%>');">����</a>
								<input type="hidden" id="lcture_set_day" name="lcture_set_day" value=""/>
								<input type="hidden" id="lcture_set_no" name="lcture_set_no" value=""/>
							</td>
							<td><a href="javascript:" class="btn blue" onclick="fn_sms_apply(this, '<%=lcture_no%>', '<%=lcture_day%>')">����</a></td>
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
							<td colspan="5">�ش��Ͽ� ��ϵ� ��.â��Ư���� �����ϴ�.</td>
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
