var $_isDaum = (document.domain.indexOf("daum.net") > 0);
//var $_cropDomain = ($_isDaum ? 'http://job2.careernet.co.kr' : 'http://hkpartner.career.co.kr');
var $_cropDomain = ($_isDaum ? 'http://job2.careernet.co.kr' : window.location.protocol + "//" + window.location.hostname);
var $_isPopup = (document.location.toString().indexOf('/my/resume/photo_write.asp')>0);

String.prototype.trim = function() {
	return this.replace(/^\s*|\s*$/g, '');
}

String.prototype.getbytes = function () {
	var str = this;
	// �Է¹��� ���ڿ��� escape() �� �̿��Ͽ� ��ȯ�Ѵ�.
	// ��ȯ�� ���ڿ� �� �����ڵ�(�ѱ� ��)�� ���������� %uxxxx�� ��ȯ�ȴ�.
	var temp_estr = escape(str);
	var s_index   = 0;
	var e_index   = 0;
	var temp_str  = "";
	var cnt       = 0;

	// ���ڿ� �߿��� �����ڵ带 ã�� �����ϸ鼭 ������ ����.
	while ((e_index = temp_estr.indexOf("%u", s_index)) >= 0)  // ������ ���ڿ��� �����Ѵٸ�
	{
		temp_str += temp_estr.substring(s_index, e_index);
		s_index = e_index + 6;
		cnt ++;
	}

	temp_str += temp_estr.substring(s_index);
	temp_str = unescape(temp_str);  // ���� ���ڿ��� �ٲ۴�.

	// �����ڵ�� 2����Ʈ �� ����ϰ� �������� 1����Ʈ�� ����Ѵ�.
	return ((cnt * 2) + temp_str.length) + "";
}


/*
*	���� ������� ���������������ǿ��� üũ
*/
function fn_agree_chk_daum() {
	$.get("/wwwconf/include/tools/ajax_daum_agree_chk.asp?dummy=" + Math.random()*99999, function(data) {
		var json = eval( "(" + data + ")" );
		if(json.ret_val==1) {
		} else if (json.ret_val==-1) {
			// alert('�� ���񽺸� �̿��ϱ� ���ؼ��� ����ȸ�� �α����� �ʿ��մϴ�.\n�α��� �� �̿��� �ֽñ� �ٶ��ϴ�.');
		} else {
			// alert('���� �������� �������Ǹ� ���ֽñ� �ٶ��ϴ�.');
		}
		$("#daum_agree").val(json.ret_val);
	});
}


/*
*	�α��� �̵�
*/
function fn_login_daum() {
	if($_isDaum) {
		location.href = "http://login.daum.net/accounts/loginform.do?url=" + encodeURIComponent(document.location);
	}
}

function fn_login_redirect() {
	if($_isPopup) {
		if(opener!=null && typeof(opener)!='unknown') {
			opener.location.href = "/my/";
		} else {
			var newWin = window.open("/my/");
			if(newWin==null) {
				alert('�˾��� ���ܵǾ����ϴ�.\n�˾������� �����ϰ� �ٽ� �õ����ֽñ� �ٶ��ϴ�.');
			}
		}
		self.close();
	} else {
		if($_isDaum) {
			location.href = "http://login.daum.net/accounts/loginform.do?url=" + encodeURIComponent(document.location);
		} else {
			location.href = "/my/login.asp?redir=" + encodeURIComponent(document.location);
		}
	}
}


/*
*	�α��� validate
*/
function fn_login_validate(formobj){

    formobj = formobj || document.toolsLoginForm;
	formobj.logtype.value = "1";
	
	if(formobj.id.value.split(" ").join("") == "") {
		alert('���̵� �Է��� �ּ���.');
		formobj.id.focus();
		return false;
	}
	if(formobj.pw.value.split(" ").join("") == "") {
		alert('��й�ȣ�� �Է��� �ּ���.');
		formobj.pw.focus();
		return false;
	}
	
	if(formobj.loginchk.value != "0") {
		alert("�� ���񽺴� ����ȸ�� �α����� �ʿ��� �����Դϴ�.");
	}
	
    if(formobj.logtype.value=="1") {
        //��������
        if (formobj.ssl.checked)	{
            saveSSL('p_ssl');
            formobj.action ="https://login.career.co.kr/career/my/login_check.asp";
        }
        else {
            unSaveSSL('p_ssl');
            formobj.action ="http://login.career.co.kr/career/my/login_check.asp";
        }
        //���̵�����
        if (formobj.save_id.checked)	{
            saveID('save_id', formobj.id.value);
			saveID("save_grade", formobj.logtype.value);
        }
        else {
            unSaveID('save_id', formobj.id.value);
			unSaveID("save_grade", formobj.logtype.value);
        }
    }

}

function setType(logtype) {
    document.toolsLoginForm.logtype.value=logtype;
}

/*
*	�ʱ� ȣ�� �Լ� (�α���,�޴�����)
*/
var $_menu_num = "1";
function fn_load() {
	if(document.toolsLoginForm) {
	    if (document.domain.indexOf("career.co.kr") > 0) {
			SaveIdCheck_new2(document.toolsLoginForm.save_id, document.toolsLoginForm.id, 'save_id', 'save_comid');
			sslSaveCheck_new(document.toolsLoginForm.ssl, 'p_ssl');
        }

        // ���̵� ����� ���̵�� ���� ���̵� �ߺ����� ���̴� �κ� ó��
        if (document.toolsLoginForm.save_id.value == "on") {
            $("#toolsLoginForm input[type=text]").removeClass("idoff").addClass("ion");
        }
		
		if($("#toolsLoginForm input[type=text]").val()!="") {
			$("#toolsLoginForm input[type=text]").removeClass("inputOn").addClass("ion");
		}
		
		$("#toolsLoginForm input[type=text]").bind("focus",function() {
			$(this).removeClass("idoff").addClass("ion");
		}).bind("blur",function() {
			if($(this).val()=="") {
				$(this).removeClass("ion").addClass("idoff");
			}
		});
		
		$("#toolsLoginForm input[type=password]").bind("focus",function() {
			$(this).removeClass("pwoff").addClass("ion");
		}).bind("blur",function() {
			if($(this).val()=="") {
				$(this).removeClass("ion").addClass("pwoff");
			}
		});
	}
	
	$("#tools_gnb ul li a img").each(function() {
		var imgsrc = $(this).attr("src");
		var menunum = $(this).attr("menunum");
		$(this).attr("src", (menunum == $_menu_num) ? imgsrc.replace("_off.gif","_on.gif") : imgsrc.replace("_on.gif","_off.gif"));
	});
}
