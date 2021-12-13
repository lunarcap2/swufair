/* JS Document 2014-11-17 skydown@career.co.kr */
var keywordFnc, quickmenuFnc, expandFnc, cancelFnc, resetFnc, cloneFnc, addFnc, moveFnc, prevcopyFnc, disableFnc, layerFnc, displayFnc, tooltipFnc, modifyFnc, checkallFnc, selectboxFnc, inputFnc, checkboxFnc, radioboxFnc;
(function ($) {
	$(function () {
		$(document).ready(function () {
            if ($('.selectbox select').length > 0) selectboxFnc();//����Ʈ�ڽ�
            if ($('input.chk').length > 0) checkboxFnc();//üũ�ڽ�
            if ($('input.rdi').length > 0) radioboxFnc();//�����ڽ�
            if ($('input.txt').length > 0) inputFnc();//��ǲ�ڽ�
            if ($('input.placehd').length > 0) $('input.placehd').placeholder();//��ǲ�ڽ�
            if ($('input.value, textarea.area').length > 0) $('input.value, textarea.area').inputcheckFnc();//��ǲ�ؽ�Ʈ üũ�ڽ�
            if ( $(".ellipsis").length > 0) $(".ellipsis").ellipsis();//������
			if ($('.termsView').length > 0) termsFnc();//�������
			quickmenuFnc();//���޴�
			layerFnc.init();//�˾� ���̾�
			modifyFnc();//���ü���
			keywordFnc();//Ű�����Է�
			fileboxFnc();//ã�ƺ���
			tabStyle();//������
		});//ready

		quickmenuFnc = function() {//���޴�
			if ($('#quickmenu .quickmenu').length == 0) return false;
			var _quick = $('#quickmenu .quickmenu');
			var _tmp = null;
			var speed = 100;
			var objPosition = _quick.offset().top;
			var currentPosition = parseInt(_quick.css('top')) - 10;
			$(window).scroll(function () {
				var position = $(window).scrollTop();
				if (position > objPosition + currentPosition) {
					if (_quick.css('position') != 'fixed') _quick.css({'position':'fixed', 'top':'10px'});
				} else {
					if (_quick.css('position') == 'fixed') _quick.css({'position':'absolute', 'top' : 0});
				}
			});
		};//���޴�
		expandFnc = function (obj) {//��ġ�� ��ư
			var _obj = $(obj).children();
			var _height = parseInt(_obj.parent().prev().css('height')) * 3;

			if (_obj.attr('src').indexOf('btn_expand') > -1) {
				_obj.attr({'src' : _obj.attr('src').replace('btn_expand', 'btn_fold'), 'alt' : '����'});
				_obj.parent().prev().css('height', _height + 'px' ).addClass('vert');
			} else {
				_obj.attr({'src' : _obj.attr('src').replace('btn_fold', 'btn_expand'), 'alt' : '��ġ��'});
				_obj.parent().prev().removeAttr('style').removeClass('vert');
			}
			$('html, body').animate({//���� ��ũ�� ��ġ�� �̵�
				scrollTop: _obj.parent().prev().offset().top
			}, 500);
		};//��ġ�� ��ư
		cancelFnc = function (obj) {//��� ��ư
			$(obj).parent().find('input:text, input:checkbox, input:radio, textarea.area, span.selectbox, span.total').each(function (index, value) {
				inputReset(this);
			});
		};//��� ��ư
		resetFnc = function (obj) {//���� ��ư
			$(obj).parent().next().find('input:text, input:checkbox, input:radio, textarea.area, span.selectbox, span.total').each(function (index, value) {
				if ($(this).attr('class') != null && $(this).attr('class').indexOf('autoresize') == -1) inputReset(this);
			});
		};//���� ��ư
		function inputReset (obj) {//���� ��ǲ
			switch (obj.tagName) {
				case 'INPUT':
					if ($(obj).attr('type') == 'text') {
						$(obj).val('');
						$(obj).removeAttr('disabled');//�������
					} else {
						$(obj).attr('checked', false);
					}
					break;
				case 'SPAN':
					if ($(obj).attr('class').indexOf('total') > -1) {
						$(obj).find('strong').text('0');
					}
					if ($(obj).attr('class').indexOf('selectbox') > -1) {
						$(obj).find('> select > option').eq(0).prop('selected', true);
						//$(obj).find('> span').text($(obj).find('> select > option').prop('selectedIndex', 0).val());
						$(obj).find('> span').text($(obj).find('> select > option:selected').text());
					}
					break;
				case 'TEXTAREA':
					$(obj).val('');
					break;
				case 'SELECT':
					$(obj).get(0).selectedIndex = 0;
					selectboxFnc($(obj));
					break;
				default:
					return false;
			}
		}//���� ��ǲ
		cloneFnc = function (obj, param, total) {//�߰�, ���� ��ư
			var _dur = 300;
			//var _clone = ($(obj).parent().parent().parent().attr('class').indexOf('group') == -1) ? $(obj).parent().parent().prev() : $(obj).parent().parent().parent();
			var _clone = ($(obj).parent().parent().parent().attr('class').indexOf('group') == -1) ? $(obj).parent().parent().parent().find('.group').last() : $(obj).parent().parent().parent();//��� ������ ����
			var _group = _clone.parent().find('.group');
			switch(param) {
				case 'add'://��ǲ Ÿ�Ժ� �ʱ�ȭ ����
					if (_group.length < total) {
						_clone.clone(true).insertAfter(_clone);
						if (_clone.next('.group').length > 0) {
							_clone.next('.group').find('.stitle.first').removeClass('first');
							_clone.next('.group').addClass('clone');
						} else {//���� ������
							_clone.parent().find('.stitle:last-child').last().removeClass('first');
							_clone.parent().find('.group:last-child').last().addClass('clone');
						}
						_clone.parent().find('.group').each(function (index, value) {//������ ID, NAME �缳��
							var _index = index;
							$(this).find('label, input:hidden, input:text, .selectbox select, textarea.area').each(function (index, value) {
								switch ($(this).get(0).tagName) {
									case 'LABEL':
										$(this).attr('for', $(this).attr('for').replace(/\d+|\_/g, '') + (index + 1) + '_' + (_index + 1));
										$(this).find('input').attr('id', $(this).find('input').attr('id').replace(/\d+|\_/g, '') + (index + 1) + '_' + (_index + 1));
										$(this).find('input').attr('name', $(this).find('input').attr('name').replace(/\d+/g, '') + (_index + 1));
										break;
									case 'TEXTAREA':
									case 'INPUT':
									case 'SELECT':
										if ($(this).attr('id'))
											$(this).attr('id', $(this).attr('id').replace(/\d+|\_/g, '') + (index + 1) + '_' + (_index + 1));
										break;
									default:
										return false;
								}
								if(_index == _group.length) {//�Է��׸� �ʱ�ȭ
									if($(this).get(0).tagName == 'INPUT' || $(this).get(0).tagName == 'TEXTAREA') {
										$(this).val('');
										$(this).attr('checked', false);
									} else if($(this).get(0).tagName == 'SELECT') {
										$(this).get(0).selectedIndex = 0;
										selectboxFnc($(this));
									} else if($(this).get(0).tagName == 'LABEL') {
										$(this).find('input').attr('checked', false);
									}
								} else {
									if($(this).is('.lb.on')) {
										$(this).find('input').attr('checked', true);
									}
								}
							});
						});
						$('html, body').animate({//���� ��ũ�� ��ġ�� �̵�
							scrollTop: (_clone.next('.group').length > 0) ? _clone.next('.group').offset().top : _clone.parent().find('.group:last-child').offset().top
						}, _dur, function() {
							//
						}).promise().done(function() {
							_clone.next('.group').find('.fncbutton button').is(function () {
								_clone.next('.group').find('.fncbutton button').get(0).focus();
								selectboxFnc(_clone.next('.group'));//����Ʈ�ڽ� �缳��
								inputFnc(_clone.next('.group'));//��ǲ �缳��
							 });
						});
					}
					break;
				case 'del':
					if (_group.length > 1) {
						if (_clone.prev('.group').length > 0) {
							_clone.prev('.group').find('.fncbutton button').is(function () {
								_clone.prev('.group').find('.fncbutton button').get(1).focus();
							});
							$('html, body').animate({//���� ��ũ�� ��ġ�� �̵�
								scrollTop: _clone.prev('.group').offset().top
							}, _dur);
						} else {
							$('html, body').animate({//���� ��ũ�� ��ġ�� �̵�
								scrollTop: _group.offset().top
							}, _dur, function() {
								//
							}).promise().done(function() {
								_group.find('.fncbutton button').get(1).focus();
							});
						}
						_clone.remove();
						if (_group.index(_clone) == 0)
							$(_group.get(1)).removeClass('clone');
						_clone.parent().find('.group').each(function (index, value) {//������ ID, NAME �缳��
							var _index = index;
							$(this).find('label, input:hidden, input:text, .selectbox select, textarea.area').each(function (index, value) {
								switch ($(this).get(0).tagName) {
									case 'LABEL':
										$(this).attr('for', $(this).attr('for').replace(/\d+|\_/g, '') + (index + 1) + '_' + (_index + 1));
										$(this).find('input').attr('id', $(this).find('input').attr('id').replace(/\d+|\_/g, '') + (index + 1) + '_' + (_index + 1));
										$(this).find('input').attr('name', $(this).find('input').attr('name').replace(/\d+/g, '') + (_index + 1));
										break;
									case 'TEXTAREA':
									case 'INPUT':
									case 'SELECT':
										if ($(this).attr('id'))
											$(this).attr('id', $(this).attr('id').replace(/\d+|\_/g, '') + (index + 1) + '_' + (_index + 1));
										break;
									default:
										return false;
								}
							});
						});
					} else {
						//
					}
					break;
				default:
					return false;
			}
		}//�߰�, ���� ��ư
		delFnc = function (obj) {//���� ��ư [�ڱ�Ұ��� ������]
			var _dur = 300;
			var _obj = $(obj).parent().parent().parent();
			var _group = _obj.parent().find('.group');
			_obj.hide();
			if (_group.length == 2) {
				_obj.parent().hide();
				$('html, body').animate({//���� ��ũ�� ��ġ�� �̵�
					scrollTop: _obj.parent().parent().offset().top
				}, _dur).promise().done(function() {
					_obj.remove();
				});
			} else {
				$('html, body').animate({//���� ��ũ�� ��ġ�� �̵�
					scrollTop: _obj.prev('.group').offset().top
				}, _dur).promise().done(function() {
					_obj.prev('.group').find('.button button.btn').is(function () {
						_obj.prev('.group').find('.button button.btn').get(0).focus();
					 });
					_obj.remove();
				});
			}
			_obj.parent().find('.group').filter(function (index) {
				return $(this).css('display') === 'block';
			}).each(function (index, value) {//������ ID, NAME �缳��
				var _index = index;
				$(this).find('label, input:hidden, input:text, .selectbox select, textarea.area').each(function (index, value) {
					switch ($(this).get(0).tagName) {
						case 'LABEL':
							$(this).attr('for', $(this).attr('for').replace(/\d+|\_/g, '') + (index + 1) + '_' + (_index + 1));
							$(this).find('input').attr('id', $(this).find('input').attr('id').replace(/\d+|\_/g, '') + (index + 1) + '_' + (_index + 1));
							$(this).find('input').attr('name', $(this).find('input').attr('name').replace(/\d+/g, '') + (_index + 1));
							break;
						case 'TEXTAREA':
						case 'INPUT':
						case 'SELECT':
							if ($(this).attr('id'))
								$(this).attr('id', $(this).attr('id').replace(/\d+|\_/g, '') + (index + 1) + '_' + (_index + 1));
							break;
						default:
							return false;
					}
				});
			});

		}//���� ��ư
		addFnc = function (obj1, obj2, total) {//�߰� ��ư [�ڱ�Ұ��� ������]
			var _val = (obj1.tagName == 'BUTTON') ? $(obj1).parent().parent().prev('input.txt').val() : $(obj1).next('span').text();
			var _clone = $(obj2).find('.group:first-child');
			var _group = $(obj2).find('.group');
			if ($(obj1).is('input:checked') == true || obj1.tagName == 'BUTTON') {
				if (_group.length < total + 1) {
					if ($(obj2).css('display') == 'none') $(obj2).show();
					_clone.clone(true).insertAfter(_group.last()).removeAttr('style');
					if ($(obj1).parent().parent().prev(':text').length > 0) {//�����Է� �߰�
						_group.last().next().find('input:text.autoresize').val(_val);
					} else {//üũ ���
						_group.last().next().find('input:text.autoresize').val($(obj1).next('span').text()).attr('disabled','disabled');
						_group.last().next().find('button.modify').remove();
					}
					inputFnc(_group.last().next());//��ǲ �缳��
					if (obj1.tagName == 'BUTTON') {
						$('html, body').animate({//���� ��ũ�� ��ġ�� �̵�
							scrollTop: _group.last().next().offset().top
						}, 500).promise().done(function() {
							//
						});
					}
					_clone.parent().find('.group').filter(function (index) {
						return $(this).css('display') === 'block';
					}).each(function (index, value) {//������ ID, NAME �缳��
						var _index = index;
						$(this).find('label, input:hidden, input:text, .selectbox select, textarea.area').each(function (index, value) {
							switch ($(this).get(0).tagName) {
								case 'LABEL':
									$(this).attr('for', $(this).attr('for').replace(/\d+|\_/g, '') + (index + 1) + '_' + (_index + 1));
									$(this).find('input').attr('id', $(this).find('input').attr('id').replace(/\d+|\_/g, '') + (index + 1) + '_' + (_index + 1));
									$(this).find('input').attr('name', $(this).find('input').attr('name').replace(/\d+/g, '') + (_index + 1));
									break;
								case 'TEXTAREA':
								case 'INPUT':
								case 'SELECT':
									if ($(this).attr('id'))
										$(this).attr('id', $(this).attr('id').replace(/\d+|\_/g, '') + (index + 1) + '_' + (_index + 1));
									break;
								default:
									return false;
							}
							if(_index == _group.length) {//�Է��׸� �ʱ�ȭ
								if($(this).get(0).tagName == 'INPUT' || $(this).get(0).tagName == 'TEXTAREA') {
									$(this).val('');
									$(this).attr('checked', false);
								} else if($(this).get(0).tagName == 'SELECT') {
									$(this).get(0).selectedIndex = 0;
									selectboxFnc($(this));
								} else if($(this).get(0).tagName == 'LABEL') {
									$(this).find('input').attr('checked', false);
								}
							} else {
								if($(this).is('.lb.on')) {
									$(this).find('input').attr('checked', true);
								}
							}
						});
					});
				} else {
					//
				}
			} else {//üũ ��Ȱ��
				if (_group.length == 2) $(obj2).hide();
				_group.find('input:text.autoresize').each(function (index, value) {
					if ($(this).val() == _val) $(this).parent().parent().parent().parent().remove();
				});
			}
		}//�߰� ��ư
		moveFnc = function (obj, param) {//�̵���ư ��ư
			var _this = $(obj).parent().parent().parent();
			var _group = _this.parent().find('.group');
			var _index = _group.index(_this);
			switch(param) {
				case 'up':
					if (_index > 0 && _this.prev().css('display') != 'none') {
						_group.eq(_index-1).before(_group.eq(_index));
					}
					break;
				case 'down':
					if (_index < _group.length) {
						_group.eq(_index+1).after(_group.eq(_index));
					}
					break;
				default:
					return false;
			}
		}//�̵���ư ��ư
		prevcopyFnc = function (obj, param, total) {//�����߰� ��ư, ��ǲ Ÿ�Ժ� �ʱ�ȭ ����
			var _div = $(obj).parent().parent().parent();
			var _clone = $(obj).parent().parent().prev();
			var _group = _clone.parent().find('.grp');
			switch(param) {
				case 'add':
					if (_group.length < total) {
						_clone.clone(true).insertAfter(_clone);
						_clone.next('.grp').addClass('clone');
						_clone.parent().find('.button button.del').removeClass('off');
						_clone.parent().find('.grp').each(function (index, value) {//������ ID, NAME �缳��
							var _index = index;
							$(this).find('label, input:text').each(function (index, value) {
								switch ($(this).get(0).tagName) {
									case 'LABEL':
										$(this).attr('for', $(this).attr('for').replace(/\d+|\_/g, '') + (index + 1) + '_' + (_index + 1));
										$(this).find('input').attr('id', $(this).find('input').attr('id').replace(/\d+|\_/g, '') + (index + 1) + '_' + (_index + 1));
										$(this).find('input').attr('name', $(this).find('input').attr('name').replace(/\d+/g, '') + (_index + 1));
										break;
									case 'TEXTAREA':
									case 'INPUT':
									case 'SELECT':
										if ($(this).attr('id'))
											$(this).attr('id', $(this).attr('id').replace(/\d+|\_/g, '') + (index + 1) + '_' + (_index + 1));
										break;
									default:
										return false;
								}
								if(_index == _group.length) {//�Է��׸� �ʱ�ȭ
									if($(this).get(0).tagName == 'INPUT' || $(this).get(0).tagName == 'TEXTAREA') {
										$(this).val('');
										$(this).attr('checked', false);
									} else if($(this).get(0).tagName == 'SELECT') {
										$(this).get(0).selectedIndex = 0;
										selectboxFnc($(this));
									} else if($(this).get(0).tagName == 'LABEL') {
										$(this).find('input').attr('checked', false);
									}
								} else {
									if($(this).is('.lb.on')) {
										$(this).find('input').attr('checked', true);
									}
								}
							});
						});
					}
					break;
				case 'del':
					if (_group.length > 1) {
						_clone.remove();
						if (_group.index(_clone) == 1)
							_div.find('.button button.del').addClass('off');
					} else {
						//
					}
					break;
				default:
					return false;
			}
		}//�����߰� ��ư
		disableFnc = function (obj, param) {//��Ȱ��
			var _obj = $(obj);
			var _input = _obj.find('input.txt, input.rdi, input.chk, textarea.area');
			switch(param) {
				case 'disable':
					_obj.addClass('disable');
					if (_input.length > 0) _input.attr('readonly','readonly');
					selectboxFnc();
					break;
				case 'active':
					_obj.removeClass('disable');
					if (_input.length > 0) _input.removeAttr('readonly');
					break;
				case 'check'://üũ�ڽ�
					if ((_obj.attr('class')) ? (_obj.attr('class') == 'disable') : false) {
						_obj.removeClass('disable');
						if (_input.length > 0) _input.removeAttr('readonly');
					} else {
						_obj.addClass('disable');
						if (_input.length > 0) _input.attr('readonly','readonly');
					}
					break;
				default:
					return false;
			}
		};//��Ȱ��
		layerFnc = {//�˾� ���̾�
			val: {
				motion : 50,
				duration : 300,
				layer : null,
				inner : null,
				tmpscroll : null
			},
			init: function () {//�ʱ�ȭ
				this.close();
			},
			close: function () {//���̾� �ݱ�
				var _close = $('.popupLayer > .popupInner > .close > button.btn');
				_close.click(function () {
					$(this).parent().parent().parent().animate({
						opacity: 0
					}, layerFnc.val.duration, function () {
						$(this).removeAttr('style').find('> .popupInner').removeAttr('style');
						$('html, body').animate({//���� ��ũ�� ��ġ�� �̵�
							scrollTop: layerFnc.val.tmpscroll
						}, 500);
					});
				});
			},
			show: function (param) {//���̾� ���̱�
				if ($(param).length == 0) return false;
				this.val.layer = $(param);
				this.val.inner = $(param + '> .popupInner');
				this.height();
				this.val.tmpscroll = $(document).scrollTop();
				$('html, body').animate({
					scrollTop: this.val.inner.offset().top - layerFnc.val.motion
				}, 500).promise().done(function() {
					layerFnc.val.inner.delay(150).animate({
						'opacity' : 1,
						'margin-top' : 0
					}, layerFnc.val.duration, function () {
						layerFnc.val.inner.find('a, input, button').get(0).focus();
					});
				});
			},
			hide: function (param) {//���̾� ���߱�
				this.val.layer = $(param);
				this.val.inner = $(param + '> .popupInner');
				this.val.inner.animate({
					'opacity' : 0,
					'margin-top' : this.val.motion
				}, this.val.duration);
			},
			height: function () {//���̾� ���� �ʱ�ȭ
				this.val.layer.css({
					'height' : $('body').height(),
					'display' : 'block'
				});
				this.val.inner.css({
					'margin-left' : '-' + (this.val.inner.width() / 2) - parseInt(this.val.inner.css('borderLeftWidth')) + 'px',
					'margin-top' : this.val.motion
				});
			}
		};//�˾� ���̾�
		displayFnc = function (obj, param) {//���÷���
			if ($(obj).length == 0) return false;
			var _obj = $(obj);
			//var _find = _obj.find('a, input:text');
			switch(param) {
				case 'block':
					if (_obj.get(0).tagName == 'TABLE') {
						_obj.css('display','table');
					} else if (_obj.get(0).tagName == 'TR') {
						_obj.css('display','table-row');
					} else {
						_obj.css('display','block');
					}
					//if (navigator.appVersion.indexOf('MSIE 7') == -1 && _find.get(0) != undefined) _find.get(0).focus();//IE7 ��������
					break;
				case 'none':
					_obj.css('display','none');
					break;
				case 'check':
					_obj = $(obj).parent().next();//�����׸� �˻�
					if ($(obj).is(":checked") == true || _obj.css('display') == 'none')
						_obj.css('display','block');
					else
						_obj.css('display','none');
					break;
				default:
					return false;
			}
			return false;
		};//���÷���
		tooltipFnc = function (obj) {//���� ���̾�
			var _dur = 100;
			var _obj = $('#' + obj);
			var _mb = (_obj.css('bottom') != 'auto') ? '-10px' : 0;
			var _mt = (_obj.css('top') != 'auto') ? '-10px' : 0;
			if (_obj.css('display') == 'none') {
				_obj.css({'display':'block','opacity':0, marginBottom : _mb, marginTop : _mt}).clearQueue().animate({
					opacity: 1,
					marginBottom: _mb,
					marginBottom: _mt
				},_dur);
			} else {
				_obj.clearQueue().animate({
					opacity: 0
				},_dur, function () {
					$(this).removeAttr('style');
				});
			}
			return false;
		};//���� ���̾�
		modifyFnc = function (obj) {//���ü���
			var _obj = null;
			if (!obj) {//���̺� �ʱ�ȭ
				_obj = ($('.allmodify').length > 0) ? $('.allmodify') : null;
				if (_obj != null) {
					if (_obj.find('input:checkbox').is(':checked')) {
						_obj.next('.tb').addClass('on');//���̺� on/off
					}
				} else {
					return false;
				}
			} else {
				_obj = $('#' + obj);
			}
			if (_obj.attr('class').indexOf('on') > -1) {
				_obj.removeClass('on');
			} else {
				_obj.addClass('on');
			}
			return false;
		};//���ü���
		inputFnc = function (obj) {//��ǲ�ڽ� 2017-12-05 ����
			var _this, _tmp, _bg = null;
			if (!obj)
				_this = $('input.txt, textarea.area, span.selectbox');
			else
				_this = $(obj).find('input.txt, textarea.area, span.selectbox');
			_this.unbind('focus blur').each(function (index, value) {
				if ($(this).attr('class').indexOf('autoresize') > -1) $(this).attr('size', resizeInput).bind('keyup textchange', resizeInput);//�������� �ʱ�ȭ
				if ($(this).val() != null && $(this).val() != '') $(this).removeClass('bg');//����̹��� �ʱ�ȭ
			}).bind('focus', function () {
				_tmp = this.value;
				_bg = ($(this).attr('class').indexOf('bg') > -1) ? true : false;
				//if ($(this).attr('class').indexOf('normal') == -1) this.value = '';
				$(this).addClass('on');
				$(this).parent().addClass('on');//ȸ�������Է�
				if(_bg) $(this).removeClass('bg');
			}).bind('blur', function () {
				//if (this.value == '' && $(this).attr('class').indexOf('normal') == -1) this.value = _tmp;
				$(this).removeClass('on');
				$(this).parent().removeClass('on');//ȸ�������Է�
				if (_bg && $(this).val() == '') $(this).addClass('bg');
			}).bind('keyup', function (e) {
				//if (e.keyCode == 27 && this.value != null) this.value = '';//this.value = _tmp;
			});
		}//��ǲ�ڽ�

        $.fn.inputcheckFnc = function(index) {//��ǲ�ؽ�Ʈ üũ
            return this.each(function(index, value) {
                var _default = $(this).attr('default');
                var _type = $(this).attr('type');
                if(this.value == '' || this.value == _default) {
                    $(this).attr('value', _default);
                    $(this).attr('type', 'text');
                } else {
                    $(this).removeClass('value');
                    $(this).attr('type', _type);
                }
                $(this).bind('focus', function() {
                    if(this.value == _default) {
                        this.value = '';
                        this.type = _type;
                    }
                    $(this).removeClass('value')
                }).bind('blur', function() {
                    if(this.value == '' || this.value == _default) {
                        this.value = _default;
                        this.type = 'text';
                        $(this).addClass('value');
                    }
                });
            });
        };//��ǲ�ؽ�Ʈ üũ
		$.event.special.textchange = {//Detecting Text Changes
			setup: function (data, namespaces) {
			  $(this).data('lastValue', this.contentEditable === 'true' ? $(this).html() : $(this).val());
				$(this).bind('keyup.textchange', $.event.special.textchange.handler);
				$(this).bind('cut.textchange paste.textchange input.textchange', $.event.special.textchange.delayedHandler);
			},
			teardown: function (namespaces) {
				$(this).unbind('.textchange');
			},
			handler: function (event) {
				$.event.special.textchange.triggerIfChanged($(this));
			},
			delayedHandler: function (event) {
				var element = $(this);
				setTimeout(function () {
					$.event.special.textchange.triggerIfChanged(element);
				}, 25);
			},
			triggerIfChanged: function (element) {
			  var current = element[0].contentEditable === 'true' ? element.html() : element.val();
				if (current !== element.data('lastValue')) {
					element.trigger('textchange',  [element.data('lastValue')]);
					element.data('lastValue', current);
				}
			}
		};//Detecting Text Changes
		function resizeInput() {//��ǲ ��������
			var _obj = $(this)
			var _val = _obj.val();
			var _tmp = (_obj.next('.hidden').length == 0) ? $('<div class="txt hidden" style="display:none;"></div>').insertAfter(_obj) : _obj.next('.hidden');
			var _width = parseInt(_tmp.text(_obj.val()).css('width')) + 22;
			_obj.css('width',_width).next('.hidden').remove();
		}//��ǲ ��������
		keywordFnc = function () {//Ű�����Է�
			$('.keywordbox input:text').each(function (index, value) {
			}).unbind('focusin focusout').bind('focusin', function () {
				$(this).parent().addClass('on');
				$(this).next().stop().show(1);
			}).bind('focusout', function () {
				$(this).parent().removeClass('on');
				$(this).next().stop().hide(1, function () {$(this).removeAttr('style');});
			}).next().unbind('mouseenter mouseleave focusin focusout').bind('mouseenter focusin', function () {
				$(this).parent().addClass('on');
				$(this).stop().show(1).addClass('on');
			}).bind('mouseleave focusout', function (e) {
				$(this).stop().hide(1, function () {
					$(this).removeClass('on').removeAttr('style');
					$(this).prev().removeClass('on');
					$(this).parent().removeClass('on');
				});
			}).find('a').unbind('click focusin focusout').bind('click keydown', function (e) {
				if (e.which == 13 || e.type == 'click') {//ENTER, CLICK
					$(this).parent().parent().parent().prev().val($(this).text());
					$(this).parent().parent().parent().removeAttr('style').removeClass('on').stop().hide(0);
					return false;
				} else if (e.keyCode == 38) {//UP
					$(this).parent().prev().find('> a').focus();
					$(this).parent().parent().parent().prev().val($(this).parent().prev().text());
					return false;
				} else if (e.keyCode == 40) {//DOWN
					$(this).parent().next().find('> a').focus();
					$(this).parent().parent().parent().prev().val($(this).parent().next().text());
					return false;
				}
			}).bind('focusin', function () {
				$(this).parent().parent().parent().stop().show(1);
			}).bind('focusout', function () {
				$(this).parent().parent().parent().stop().hide(1);
			});
		}//Ű�����Է�
		function fileboxFnc() {//ã�ƺ���
			$('.filebox input:file').each(function (index, value) {
				$(this).prev().val($(this).val());
			}).bind('click change', function () {
				$(this).prev().val($(this).val());
			}).bind('focus', function () {
				$(this).prev().addClass('on');
			}).bind('blur', function () {
				$(this).prev().removeClass('on');
			});
		}//ã�ƺ���
		selectboxFnc = function (obj) {//����Ʈ�ڽ�
			var _select = null
			if (!obj)
				_select = $('.selectbox select');
			else
				_select = ($(obj).find('.selectbox select').length > 0) ? $(obj).find('.selectbox select') : $(obj);
			_select.unbind().each(function (index, value) {
				$(this).prev().html($(this).children('option:selected').text());
				if ($(this).val() == 'direct') {//�����Է�
					$(this).parent().prev().css('display', 'inline');
				}
			}).bind('change keyup', function (evt) {
				$(this).prev().html($(this).children('option:selected').text());
				if ($(this).prev().is('.ellipsis')) $(this).prev().ellipsis();//������ ����
				if ($(this).find("option[value='direct']").length == 1) {//�����Է� ����
					if ($(this).val() == 'direct') {
						$(this).parent().prev().css('display', 'inline');
						if (evt.type == 'change') $(this).parent().prev().focus();//�����Է� ��Ŀ�� �̵�
					} else {
						$(this).parent().prev().css('display', 'none');
					}
				}
			}).bind('focus', function () {
				$(this).prev().addClass('on');
			}).bind('blur', function () {
				$(this).prev().removeClass('on');
			});
		}//����Ʈ�ڽ�
		checkboxFnc = function () {//üũ�ڽ� 2017-12-27 ����
			var _chk = $('.chk');
			_chk.each(function() {
				if ($(this).is(':checked')) {
					$(this).prop('checked', true).parent().removeClass('off').addClass('on');
				} else {
					$(this).prop('checked', false).parent().removeClass('on').addClass('off');
				}
			}).click(function() {
				if ($(this).is(':checked')) {
					$(this).prop('checked', true).parent().removeClass('off').addClass('on');
				} else {
					$(this).prop('checked', false).parent().removeClass('on').addClass('off');
				}
			});
		}//üũ�ڽ�
		radioboxFnc = function () {//�����ڽ�
			var _rdi = $('.rdi').parent();
			_rdi.each(function() {
				if ($(this).find('input').is(':checked')) {
					$(this).removeClass('off').addClass('on');
				} else {
					$(this).removeClass('on').addClass('off');
				}
			}).click(function() {
				var _name = $(this).find('input').attr('name');
				var _radio = $('label input[name='+_name+']');
				var _index = _radio.parent().index(this);
				_radio.each(function(index, value) {
					if (_index == index) {
						$(this).checked = true;
						$(this).parent().removeClass('off').addClass('on');
					} else {
						$(this).checked = false;
						$(this).parent().removeClass('on').addClass('off');
					}
				});
			});
		}//�����ڽ�
		function tabStyle() {//������
			$('.certiTab li a').click(function() {
				var _index = $('.certiTab li a').index(this);
				$('.certiTab li a img').each(function(index,value) {
					if (_index == index) {
						$(this).attr('src', $(this).attr('src').replace('_off.gif','_on.gif'));
						$('.certiCont').get(index).style.display = 'block';
					} else {
						$(this).attr('src', $(this).attr('src').replace('_on.gif','_off.gif'));
						$('.certiCont').get(index).style.display = 'none';
					}
				});
				return false;
			});
		}//������
		$.fn.ellipsis = function() {//������
			return this.each(function() {
				var el = $(this);
				if (el.css("overflow") == "hidden") {
					var text = el.html();
					var multiline = el.hasClass('multiline');
					var t = $(this.cloneNode(true))
					.hide()
					.css({
						'max-height':'none',
						'position':'absolute',
						'overflow':'visible'
					})
					.width(multiline ? el.width() : 'auto')
					.height(multiline ? 'auto' : el.height());
					el.after(t);
					function height() { return t.height() > el.height(); };
					function width() { return t.width() > el.width(); };
					var func = multiline ? height : width;
					while (text.length > 0 && func()) {
						text = text.substr(0, text.length - 1);
						t.html(text + "<em>...</em>");
					}
					el.attr('title', el.text().replace(/[\t]/g, '').replace(/[\r\n]/g, ' '));
					el.html(t.html());
					t.remove();
				}
			});
		};//������
		var browser = (function() {//������ üũ
			var s = navigator.userAgent.toLowerCase();
			var match = /(webkit)[ \/](\w.]+)/.exec(s) ||
			/(opera)(?:.*version)?[ \/](\w.]+)/.exec(s) ||
			/(msie) ([\w.]+)/.exec(s) ||
			/(mozilla)(?:.*? rv:([\w.]+))?/.exec(s) ||
			[];
			return { name: match[1] || "", version: match[2] || "0" };
		}());//������ üũ
		$.fn.popupWindow = function(instanceSettings){//������ �˾�
			$.fn.popupWindow.defaultSettings = {
				centerBrowser:0, // center window over browser window? {1 (YES) or 0 (NO)}. overrides top and left
				centerScreen:0, // center window over entire screen? {1 (YES) or 0 (NO)}. overrides top and left
				height:500, // sets the height in pixels of the window.
				left:0, // left position when the window appears.
				location:0, // determines whether the address bar is displayed {1 (YES) or 0 (NO)}.
				menubar:0, // determines whether the menu bar is displayed {1 (YES) or 0 (NO)}.
				resizable:0, // whether the window can be resized {1 (YES) or 0 (NO)}. Can also be overloaded using resizable.
				scrollbars:0, // determines whether scrollbars appear on the window {1 (YES) or 0 (NO)}.
				status:0, // whether a status line appears at the bottom of the window {1 (YES) or 0 (NO)}.
				width:500, // sets the width in pixels of the window.
				windowName:null, // name of window set from the name attribute of the element that invokes the click
				windowURL:null, // url used for the popup
				top:0, // top position when the window appears.
				toolbar:0 // determines whether a toolbar (includes the forward and back buttons) is displayed {1 (YES) or 0 (NO)}.
			};
			settings = $.extend({}, $.fn.popupWindow.defaultSettings, instanceSettings || {});
			var windowFeatures =	'height=' + settings.height +
							',width=' + settings.width +
							',toolbar=' + settings.toolbar +
							',scrollbars=' + settings.scrollbars +
							',status=' + settings.status +
							',resizable=' + settings.resizable +
							',location=' + settings.location +
							',menuBar=' + settings.menubar;
			settings.windowName = this.name || settings.windowName;
			settings.windowURL = this.href || settings.windowURL;
			var centeredY,centeredX;
			if (settings.centerBrowser) {
				if (browser.name == 'msie') {//hacked together for IE browsers
					centeredY = (window.screenTop - 120) + ((((document.documentElement.clientHeight + 120)/2) - (settings.height/2)));
					centeredX = window.screenLeft + ((((document.body.offsetWidth + 20)/2) - (settings.width/2)));
				} else {
					centeredY = window.screenY + (((window.outerHeight/2) - (settings.height/2)));
					centeredX = window.screenX + (((window.outerWidth/2) - (settings.width/2)));
				}
				window.open(settings.windowURL, settings.windowName, windowFeatures+',left=' + centeredX +',top=' + centeredY).focus();
			} else if (settings.centerScreen) {
				centeredY = (screen.height - settings.height)/2 - 40;
				centeredX = (screen.width - settings.width)/2;
				window.open(settings.windowURL, settings.windowName, windowFeatures+',left=' + centeredX +',top=' + centeredY).focus();
			} else {
				window.open(settings.windowURL, settings.windowName, windowFeatures+',left=' + settings.left +',top=' + settings.top).focus();
			}
			return false;
		};//������ �˾�

		function termsFnc() {//�������
			$('.termsView').on('click',function(){
				var obj = $(this).parent().parent().next().find('.terms');
				if(obj.css('display') == 'none') {
					$(this).addClass('on');
					obj.show();
				} else {
					$(this).removeClass('on');
					obj.hide();
				}
			});
		};//�������


		// ����ȸ�� ��й�ȣ �缳�� ����Ȯ��
		$('#aMobile').click(function(){
			$('#aMobileNum').show();
		});
		$('#aEmail').click(function(){
			$('#aEmailNum').show();
		});

		// ���ȸ�� ��й�ȣ �缳�� ����Ȯ��
		$('#aMobile_biz').click(function(){
			$('#aMobile_bizNum').show();
		});
		$('#aEmail_biz').click(function(){
			$('#aEmail_bizNum').show();
		});

	});//$
})(jQuery);
