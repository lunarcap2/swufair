
	function chkNull(obj, msg) {
		if(obj.value.split(" ").join("") == "") {
			alert(msg);
			obj.focus();
			return false;
		} else {
			return true;
		}
	}

	function ischecked(obj,msg) {
		var sObj = eval(obj);
		var i = 0;
		for(i=0;i<sObj.length; i++) {
			if(sObj[i].checked) {
				return true;
			}
		}
		alert(msg);
		return false;
	}

	function isselected(obj,msg) {
		var sObj = eval(obj);
		if(sObj.selectedIndex > 0) {
			return true;
		}
		alert(msg);
		return false;
	}

	function chkLen(obj, minSize, maxSize, msg){
		if(minSize > maxSize){
			alert(obj.name + '�� ���� ���� üũ�� �߸��� ������ ����߽��ϴ�.');
			return false;
		}

		var objval_len = obj.value.length;
		var temp;

		for(i = 0; i < objval_len; i++) {
			temp = obj.value.charAt(i);
			if(escape(temp).length > 4)
			objval_len++;
		}

		if((objval_len < minSize) || (objval_len > maxSize)) {
			alert(msg);
			obj.focus();
			return false;
		} else {
			return true;
		}
	}
	
	//---------------------------------------------------------------------------------------------------
	// ��Ͻ� ���ڼ� üũ
	//---------------------------------------------------------------------------------------------------
	function FC_ChkTextLen(form, maxLen) {
		var f = form;
		var text = f.value;
		
		var i = 0;
		var li_byte = 0;
		var li_len = 0; 
		var ls_one_char = "";
		var text2 = "";
	 
		for (i=0; i< text.length; i++) {
			ls_one_char = text.charAt(i);

			if (escape(ls_one_char).length > 4) {
				li_byte += 2;
			} else {
				li_byte++;
			}

			if(li_byte <= maxLen) {
				li_len = i + 1;
			}
		}

		if (li_byte > maxLen) {
			alert( maxLen + " ���ڸ� �ʰ� �Է��Ҽ� �����ϴ�. \n �ʰ��� ������ �ڵ����� ���� �˴ϴ�. ");
			text2 = text.substr(0, li_len);
			f.value = text2;
		}

		f.focus();
	}
	
	/*
		���ڿͿ����� �Է¹ޱ�
		obj = ��ǲ�ڽ�
		return = void
		Ű �̺�Ʈ ���
	*/
	function NumEngCheck(obj){ 
		temp_value = obj.value.toString(); 
		regexp = /[^0-9a-zA-Z]/g; 
		repexp = ''; 
		temp_value = temp_value.replace(regexp,repexp); 
		obj.value = temp_value; 
	} 


	/*
		����,����,Ư�����ڸ� �Է¹ޱ�
		obj = ��ǲ�ڽ�
		return = void
		Ű �̺�Ʈ ���
	*/
	function NumEngSpecialCheck(obj){ 
		temp_value = obj.value.toString(); 
		regexp = /[^0-9a-zA-Z~!@\#$%^&*\()\-=+_'\"]/g; 
		repexp = ''; 
		temp_value = temp_value.replace(regexp,repexp); 
		obj.value = temp_value; 
	} 


	/*
		��� �Է¹ޱ�  (��ҹ���)
		obj = ��ǲ�ڽ�
		type = �Է�����
			'small' : �ҹ���
			'big' : �빮��
			'all' : ��ü
		return = void
		Ű �̺�Ʈ ���
	*/
	function engCheck(obj, type){ 
		temp_value = obj.value.toString(); 
		regexp = ''; 
		repexp = ''; 
		switch(type){ 
			case 'small':
				regexp = /[^a-z]/g;
				break; 
			case 'big':
				regexp = /[^A-Z]/g;
				break; 
			case 'all':
				regexp = /[^a-z]/i;
				break; 
			default :
				regexp = /[^a-z]/i;
				break;
		}

		temp_value = temp_value.replace(regexp,repexp); 
		obj.value = temp_value; 
	} 


	/*
		���ڸ� �Է¹ޱ�
		obj = ��ǲ�ڽ�
		type = �Է�����
			'int' : ���� ���� 
			'float' : ���� �Ǽ� 
			'-int' : ���� ���� ���� 
			'-float' : ���� �Ǽ� ���� 
		return = void
		Ű �̺�Ʈ ���
	*/
	function numCheck(obj, type){ 
		temp_value = obj.value.toString(); 
		regexp = /[^-\.0-9]/g; 
		repexp = ''; 
		temp_value = temp_value.replace(regexp,repexp); 
		regexp = ''; 
		repexp = ''; 
		switch(type){ 
			case 'int':
				regexp = /[^0-9]/g;
				repexp = '';
				break; 
			case 'float':
				regexp = /^(-?)([0-9]*)(\.?)([^0-9]*)([0-9]*)([^0-9]*)/;
				repexp = '$2$3$5';
				break;
			case '-int':
				regexp = /^(-?)([0-9]*)([^0-9]*)([0-9]*)([^0-9]*)/;
				repexp = '$1$2$4';
				break;
			case '-float':
				regexp = /^(-?)([0-9]*)(\.?)([^0-9]*)([0-9]*)([^0-9]*)/;
				repexp = '$1$2$3$5';
				break; 
			default :
				regexp = /[^0-9]/g;
				repexp = '';
				break; 
		} 

		temp_value = temp_value.replace(regexp,repexp); 
		obj.value = temp_value; 
	}

	function numCheck_alert(obj, type){ 
		temp_value = obj.value.toString(); 

		if(!Validchar(temp_value,num)) {
			alert('���ڸ� �Է��Ͻ� �� �ֽ��ϴ�');	
		}

		regexp = /[^-\.0-9]/g; 
		repexp = ''; 
		temp_value = temp_value.replace(regexp,repexp); 
		regexp = ''; 
		repexp = ''; 
		switch(type){ 
			case 'int':
				regexp = /[^0-9]/g;
				repexp = '';
				break; 
			case 'float':
				regexp = /^(-?)([0-9]*)(\.?)([^0-9]*)([0-9]*)([^0-9]*)/;
				repexp = '$2$3$5';
				break;
			case '-int':
				regexp = /^(-?)([0-9]*)([^0-9]*)([0-9]*)([^0-9]*)/;
				repexp = '$1$2$4';
				break;
			case '-float':
				regexp = /^(-?)([0-9]*)(\.?)([^0-9]*)([0-9]*)([^0-9]*)/;
				repexp = '$1$2$3$5';
				break; 
			default :
				regexp = /[^0-9]/g;
				repexp = '';
				break; 
		} 

		temp_value = temp_value.replace(regexp,repexp); 
		obj.value = temp_value; 
	}

	/* 
		�ѱ۸� �Է� �ޱ�
		obj = ��ǲ�ڽ�
		type = �Է�����
			'c' : �ʼ� ���� 
			's' : �ʼ� ���� + ���� ���� 
			'' : �ʼ�, ���� ���� 
		return = void
		�ѱ��� Ű�̺�Ʈ�� ��� �� ������ ������ onBlur, onChange, onFocus�̺�Ʈ ��� �ؾ���
	*/ 
	function korCheck(obj, type) { 
		temp_value = obj.value.toString(); 
		regexp = ''; 
		repexp = ''; 
		switch(type){ 
			case 'c':
				regexp = /[^��-����-�R]/g;
				break; 
			case 's':
				regexp = /[^��-����-�R\s]/g;
				break; 
			case '':
				regexp = /[^��-�R]/g;
				break; 
			default :
				regexp = /[^��-����-�R\s]/g; 
				break; 
		} 

		if(regexp.test(temp_value)) { 
			temp_value = temp_value.replace(regexp,repexp); 
			obj.value = temp_value; 
		} 
	} 

	function korCheck_confirm(obj, type) { 

		temp_value = obj.value.toString(); 
		regexp = ''; 
		repexp = ''; 
		switch(type){ 
			case 'c':
				regexp = /[^��-����-�R]/g;
				break; 
			case 's':
				regexp = /[^��-����-�R\s]/g;
				break; 
			case '':
				regexp = /[^��-�R]/g;
				break; 
			default :
				regexp = /[^��-����-�R\s]/g; 
				break; 
		} 

		if(regexp.test(temp_value)) { 
			return false;
		} else {
			return true;
		}
	} 


	function NumEngCheck_confirm(obj){ 
		temp_value = obj.value.toString(); 
		regexp = /[^0-9a-zA-Z]/g; 
		repexp = ''; 

		if(regexp.test(temp_value)) { 
			return false;
		} else {
			return true;
		}
	} 


	//�ֹι�ȣ �� �ڵ��̵�
	function nextTab(sObj, nObj, eLength) {
		if (sObj.value.length == eLength) {
			nObj.focus();
		}
	}

	
	function chkDateType(obj) {
		temp_value = obj.value.toString().length; 
		if (temp_value > 0 && temp_value < 6) {
			alert("��ȿ���� ���� ��¥�Դϴ�.");
			return;
		}
	}

	//��¥��ȯ yyyymm -> yyyy-mm
	function changeDateType(obj) {
		temp_value = obj.value.toString(); 
		if (temp_value.length == 6) {

			oDate = new Date();
			//oDate.setFullYear(temp_value.substring(0, 4));
			//oDate.setMonth(parseInt(temp_value.substring(4, 6)) - 1);

			var year = temp_value.substring(0, 4);
			var month = parseInt(temp_value.substring(4, 6));

			//if( oDate.getFullYear() != temp_value.substring(0, 4) || oDate.getMonth() + 1 != temp_value.substring(4, 6) ) {
			if (year < oDate.getFullYear() -100 || year > oDate.getFullYear() +100 || month < 1 || month > 12) {
				alert("��ȿ���� ���� ��¥�Դϴ�.");
				return;
			}

			obj.value = temp_value.substr(0, 4) + "." + temp_value.substr(4, 2);
		}
	}


	//�޴�����ȣ ��ȯ 0101231234 -> 010-123-1234
	function changePhoneType(obj) {
		temp_value = obj.value.toString().replace("-", "");

		if (temp_value.length > 3) {
			obj.value = temp_value.substr(0, 3) + "-" + temp_value.substr(3);
		}
		if (temp_value.length > 6) {
			obj.value = temp_value.substr(0, 3) + "-" + temp_value.substr(3, 3) + "-" + temp_value.substr(6);
		}
		if (temp_value.length == 11) {
			obj.value = temp_value.substr(0, 3) + "-" + temp_value.substr(3, 4) + "-" + temp_value.substr(7, 4);
		}

	}

	//������� ��ȯ 19900312 -> 1990.03.12
	function changeBirthType(obj) {
		temp_value = obj.value.toString().replace(".", "");

		if (temp_value.length > 4) {
			obj.value = temp_value.substr(0, 4) + "." + temp_value.substr(4);
		}
		if (temp_value.length > 6) {
			obj.value = temp_value.substr(0, 4) + "." + temp_value.substr(4, 2) + "." + temp_value.substr(6);
		}
	}