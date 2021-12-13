var inputFnc, selectboxFnc, checkboxFnc, radioboxFnc, cancelFnc, resetFnc, tabFnc, tooltipFnc, toggleFnc, toggle2Fnc, rnbWrapFnc, jobPostRnb, searchListFnc, multiSelectFnc, SelJobBoxFnc, sliderFnc;//2017-11-20 �߰�
(function ($) {
    $(function () {
        $(document).ready(function () {
            if ($('input.txt').length > 0) inputFnc();//��ǲ�ڽ�
            if ($('.selectbox select').length > 0) selectboxFnc();//����Ʈ�ڽ�
            if ($('input.chk').length > 0) checkboxFnc();//üũ�ڽ�
            if ($('input.rdi').length > 0) radioboxFnc();//�����ڽ�
            if ($('input.value, textarea.area').length > 0) $('input.value, textarea.area').check();//��ǲ�ؽ�Ʈ üũ
            if ($(".ellipsis").length > 0) $(".ellipsis").ellipsis(); //������
            if ($('.tabArea ul').length > 0) tabFnc();//�Ǹ޴�
            if ($('.sideStep').length > 0) jobPostRnb();//ä������� �����޴�
            if ($('#rnb').length > 0) rnbWrapFnc();//RNB
            if ($('.tooltipArea').length > 0) tooltipFnc();//����
            if ($('.inputSearch').length > 0) searchListFnc();//�ڰ���,������� �ڵ��ϼ��˻�
            if ($('.selectBtn').length > 0) hasListFnc();//���ü����ϱ⺯��
            if ($('.toggle').length > 0) toggle2Fnc();//����������� 2017-10-10 ����
            if ($('.tooltipArea.select').length > 0) toggle3Fnc();//����������� 2017-10-10 ����
            if ($('.selRecruitArea').length > 0) SelJobBoxFnc();//�����ڰ��� ������ 2017-10-16 �߰�
            if ($('.slider').length > 0) sliderFnc();//�󼼸����䰭 ���ø� �����̴� 2017-11-14 �߰�
            if ($('.jobPostWrap .layoutBox').length > 0) bgChaingeFnc();//ä������� ��� 2017-11-23 �߰�
        });//ready


        $(window).load(function () {//2017-11-29 �߰�
            if ($('.jobPostWrap').length > 0) topMoveFnc();////ä������� �����Ŀ��
        });

        topMoveFnc = function () {//ä������� �����Ŀ�� 2017-11-29 �߰�
            $('#guin_title').focus();//ä������
            var offset = $("#header").offset();
            $('html, body').animate({ scrollTop: offset.top }, 10);
        };


        inputFnc = function (obj) {//��ǲ�ڽ�
            var _this, _tmp, _bg = null;
            if (!obj)
                _this = $('input.txt, textarea.area');
            else
                _this = $(obj).find('input.txt, textarea.area');
            _this.unbind('focus blur').bind('focus', function () {
                _bg = ($(this).attr('class').indexOf('bg') > -1) ? true : false;
                $(this).addClass('on');//Ŭ���� ���
                if (_bg) $(this).removeClass('bg');
            }).bind('blur', function () {
                $(this).removeClass('on');//Ŭ���� ���
                if (_bg && $(this).val() == '') $(this).addClass('bg');
            });

            _this.bind('focus', function() {//��ǲ��� 2017-12-05 �߰�
				if (!$(this).val() || $(this).val()) $(this).addClass('bgnone');
			}).bind('blur', function() {
				if ($(this).val()) $(this).addClass('bgnone');
				else $(this).removeClass('bgnone');
			});
        };//��ǲ�ڽ�

        selectboxFnc = function (obj) {//����Ʈ�ڽ�
            var _select = null
            if (!obj)
                _select = $('.selectbox select');
            else
                _select = ($(obj).find('.selectbox select').length > 0) ? $(obj).find('.selectbox select') : $(obj);
                _select.unbind().each(function (index, value) {
                $(this).prev().html($(this).children('option:selected').text());
                if ($(this).val() == 'direct') {//�����Է�
                    $(this).parent().parent().find('.direct').css('display', 'inline');
                }
            }).bind('change keyup', function (evt) {
                $(this).prev().html($(this).children('option:selected').text());
                if ($(this).prev().is('.ellipsis')) $(this).prev().ellipsis();//������ ����  

                if ($(this).attr('name') == 'weekdays') { //�ٹ�����
                    if ($(this).val() == '5') { //�����Է��� ���
                        $(this).parent().parent().find('.direct').css('display', 'inline');
                        if (evt.type == 'change') $(this).parent().parent().find('.direct').focus();//�����Է� ��Ŀ�� �̵�
                    } else {
                        $(this).parent().parent().find('.direct').css('display', 'none');
                    }
                } else if ($(this).attr('name') == 'salary_month' || $(this).attr('name') == 'salary_annual') { //����
                    if ($(this).find("option[value='87']").length == 1) {//�����Է� ����
                        if ($(this).val() == '87') {
                            $(this).parent().parent().find('.direct').css('display', 'inline');
                            if (evt.type == 'change') $(this).parent().parent().find('.direct').focus();//�����Է� ��Ŀ�� �̵�
                        } else {
                            $(this).parent().parent().find('.direct').css('display', 'none');
                        }
                    }
                } else {
                    if ($(this).find("option[value='direct']").length == 1) {//�����Է� ����
                        if ($(this).val() == 'direct') {
                            $(this).parent().parent().find('.direct').css('display', 'inline');
                            if (evt.type == 'change') $(this).parent().parent().find('.direct').focus();//�����Է� ��Ŀ�� �̵�
                        } else {
                            $(this).parent().parent().find('.direct').css('display', 'none');
                        }
                    }
                }

        }).bind('focus', function () {
                $(this).prev().addClass('on');
            }).bind('blur', function () {
                $(this).prev().removeClass('on');
            });

        };//����Ʈ�ڽ�

        checkboxFnc = function () {//üũ�ڽ�
            var _chk = $('.chk').parent();
            _chk.each(function () {
                if ($(this).find('input').is(':checked')) {
                    $(this).removeClass('off').addClass('on');
                } else {
                    $(this).removeClass('on').addClass('off');
                }
            }).click(function () {
                if ($(this).find('input').is(':checked')) {
                    $(this).removeClass('off').addClass('on');
                } else {
                    $(this).removeClass('on').addClass('off');
                }
            });
        };//üũ�ڽ�

        radioboxFnc = function () {//�����ڽ�
            var _rdi = $('.rdi').parent();
            _rdi.each(function () {
                if ($(this).find('input').is(':checked')) {
                    $(this).removeClass('off').addClass('on');
                } else {
                    $(this).removeClass('on').addClass('off');
                }
            }).click(function () {
                var _name = $(this).find('input').attr('name');
                var _radio = $('label input[name$=' + _name + ']');
                var _index = _radio.parent().index(this);
                _radio.each(function (index, value) {
                    if (_index == index) {
                        $(this).checked = true;
                        $(this).parent().removeClass('off').addClass('on');
                    } else {
                        $(this).checked = false;
                        $(this).parent().removeClass('on').addClass('off');
                    }
                });
            });
        };//�����ڽ�

        $.fn.check = function (index) {//��ǲ�ؽ�Ʈ üũ
            return this.each(function (index, value) {
                var _default = $(this).attr('default');
                if (this.value == '' || this.value == _default) {
                    $(this).attr('value', _default);
                } else {
                    $(this).removeClass('value');
                }
                $(this).bind('focus', function () {
                    if (this.value == _default) {
                        this.value = '';
                    }
                    $(this).removeClass('value');
                }).bind('blur', function () {
                    if (this.value == '' || this.value == _default) {
                        this.value = _default;
                        $(this).addClass('value');
                    }
                });
            });
        };//��ǲ�ؽ�Ʈ üũ

        if(!$.fn.ellipsis) {//������ v3 2017-12-11 ����
			$.fn.ellipsis = function(index) {//v2�±����� �߰�, v3Ŭ���� �߰�
				return this.each(function(index, value) {
					var el = $(this);
					if(el.attr('ellipsis') != null) return false;
					if(el.css("overflow") == "hidden") {
						var _tmpObj = (el.find('span').length > 0) ? el.find('span') : null;
						var _tmpWidth = el.find('span').outerWidth() || 0;
						var _tmpClass = el.find('span').attr('class') || 0;
						var text = el.find('span').remove();
							text = el.html();
						var multiline = el.hasClass('multiline');
						var t = $(this.cloneNode(true))
						.hide()
						.css({
							'max-height':'none',
							'position':'absolute',
							'overflow':'visible'
						})
						.width(multiline ? el.width() - _tmpWidth : 'auto')
						.height(multiline ? 'auto' : el.height());
						el.after(t);
						function height() { return t.height() > el.height(); };
						function width() { return t.width() > el.width() - _tmpWidth; };
						var func = multiline ? height : width;
						while (text.length > 0 && func()) {
							text = text.substr(0, text.length - 1);
							t.html(text + "<em>...</em>");
							if(func())el.attr('title', el.text().replace(/[\t]/g, '').replace(/[\r\n]/g, ' '));//Ÿ��Ʋ �߰�
						}
						if(_tmpObj != null) el.html(t.html() + '<span'+ ((_tmpClass) ? ' class=\"'+_tmpClass+'\"' : '') +'>' +_tmpObj.html() + '</span>');//�±����� ����
						else el.html(t.html());
						t.remove();
						el.attr('ellipsis',true);
					}
				});
			};
		}//������

        displayFnc = function (obj, param) {//���÷���
            if ($(obj).length == 0) return false;;
            var _obj = $(obj);
            //var _find = _obj.find('a, input:text');
            switch (param) {
                case 'block':
                    if (_obj.get(0).tagName == 'TABLE') {
                        _obj.css('display', 'table');
                    } else if (_obj.get(0).tagName == 'TR') {
                        _obj.css('display', 'table-row');
                    } else {
                        _obj.css('display', 'block');
                    }
                    //if (navigator.appVersion.indexOf('MSIE 7') == -1 && _find.get(0) != undefined) _find.get(0).focus();//IE7 ��������
                    break;
                case 'none':
                    _obj.css('display', 'none');
                    break;
                case 'check':
                    _obj = $(obj).parent().parent().next();//���������׸� �˻�
                    if ($(obj).is(":checked") == true)
                        _obj.css('display', 'block');
                    else
                        _obj.css('display', 'none');
                    break;
                case 'textarea'://�����Է�
                    _obj = $(obj).parent().next();//�����׸� �˻�
                    if ($(obj).is(":checked") == true)
                        _obj.removeAttr('disabled').removeClass('disable').focus();
                    else
                        _obj.attr('disabled', 'disabled').addClass('disable');
                    break;
                case 'checkId':
                    var id = $(obj).attr('id');
                    if ($(obj).is(":checked") == true)
                        $('[id=' + id + 'Chk' + ']').css('display', 'block');
                    else
                        $('[id=' + id + 'Chk' + ']').css('display', 'none');
                    break;
                default:
                    return false;
            }
            return false;
        };//���÷���

        disableFnc = function (obj, param) {//��Ȱ��
            var _obj = $(obj);
            var _input = _obj.find('input.txt, input.rdi, input.chk, textarea.area');
            switch (param) {
                case 'disable':
                    _obj.addClass('disable');
                    if (_input.length > 0) _input.attr('readonly', 'readonly');
                    if (_input.length > 0) _input.attr('disabled', 'disabled');
                    selectboxFnc();
                    break;
                case 'active':
                    _obj.removeClass('disable');
                    if (_input.length > 0) _input.removeAttr('readonly');
                    if (_input.length > 0) _input.removeAttr('disabled');
                    break;
                case 'check'://üũ�ڽ�
                    if ((_obj.attr('class')) ? (_obj.attr('class') == 'disable') : false) {
                        _obj.removeClass('disable');
                        if (_input.length > 0) _input.removeAttr('readonly');
                    } else {
                        _obj.addClass('disable');
                        if (_input.length > 0) _input.attr('readonly', 'readonly');
                    }
                    break;
                default:
                    return false;
            }
        };//��Ȱ��

        cancelFnc = function (obj) {//��� ��ư
            $(obj).parent().find('input:text, input:checkbox, input:radio, textarea.area, span.selectbox, span.total').each(function (index, value) {
                inputReset(this);
            });
        };//��� ��ư

        resetFnc = function (obj) {//���� ��ư
            $(obj).parent().parent().prev().children().find('input:text, input:checkbox, input:radio, textarea.area, span.selectbox, span.total, label.checkbox , label.radiobox').each(function (index, value) {
                if ($(this).attr('class') != null && $(this).attr('class').indexOf('autoresize') == -1) inputReset(this);
            });//����/��å

            $(obj).parent().parent().prev().prev().children().children().find('input:text, input:checkbox, input:radio, textarea.area, span.selectbox, span.total, label.checkbox , label.radiobox').each(function (index, value) {
                if ($(this).attr('class') != null && $(this).attr('class').indexOf('autoresize') == -1) inputReset(this);
            });//������,�����Ļ�
        };//���� ��ư

        function inputReset(obj) {//���� ��ǲ
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
                case 'LABEL':
                    $(obj).removeClass('on');
                    break;
                default:
                    return false;
            }
        };//���� ��ǲ

        layerOpen = function (el) {//���̾��߾�����
            var temp = $('#' + el);
            var layer = $('.layerPop');
            var bg = temp.siblings().hasClass('dim');	//dimmed ���̾ �����ϱ� ���� boolean ����
            var dimmed = $('.dim')
            if (bg) {
                temp.parent().fadeIn(200);	//'dim' Ŭ������ �����ϸ� ���̾ ��Ÿ���� ����� dimmed �ȴ�.
            } else {
                temp.fadeIn(200);
            }
            $('body').css('overflow', 'hidden');
            // ȭ���� �߾ӿ� ���̾ ����.

            if (temp.outerWidth() >= $(window).innerWidth()) {
                dimmed.css('width', temp.outerWidth() + 'px');
                layer.css('overflow-x', 'scroll');
                temp.css({
                    'margin-left': '0',
                    'left': '0'
                });
            } else {
                dimmed.css('width', $(window).innerWidth() + 50 + 'px');
                layer.css('overflow-x', 'hidden');
                temp.css({
                    'margin-left': '-' + temp.outerWidth() / 2 + 'px',
                    'left': "50%"
                });
            };

            if (temp.outerHeight() >= $(window).innerHeight()) {
                dimmed.css('height', temp.outerHeight() + 'px');
                layer.css('overflow-y', 'scroll');
                temp.css({
                    'margin-top': '0',
                    'top': '0'
                });
            } else {
                dimmed.css('height', $(window).innerHeight() + 50 + 'px');
                layer.css('overflow-y', 'hidden');
                temp.css({
                    'margin-top': '-' + temp.outerHeight() / 2 + 'px',
                    'top': '50%'
                });

            };

            temp.find('.popHead .closeBtn, button.cancle').click(function (e) {
                if (bg) {
                    temp.parent().fadeOut(200); //'dim' Ŭ������ �����ϸ� ���̾ ������� �Ѵ�.
                } else {
                    temp.fadeOut(200);
                }
                $('body').css('overflow', '');
                e.preventDefault();
            });
            temp.siblings('.dim').click(function (e) {	//����� Ŭ���ϸ� ���̾ ������� �ϴ� �̺�Ʈ �ڵ鷯
                temp.parent().fadeOut(200);
                $('body').css('overflow', '');
                e.preventDefault();
            });

            $(window).resize(function () {
                if (temp.outerWidth() >= $(window).innerWidth()) {
                    dimmed.css('width', temp.outerWidth() + 'px');
                    layer.css('overflow-x', 'scroll');
                    temp.css({
                        'margin-left': '0',
                        'left': '0'
                    });
                } else {
                    dimmed.css('width', $(window).innerWidth() + 50 + 'px');
                    layer.css('overflow-x', 'hidden');
                    temp.css({
                        'margin-left': '-' + temp.outerWidth() / 2 + 'px',
                        'left': "50%"
                    });
                };

                if (temp.outerHeight() >= $(window).innerHeight()) {
                    dimmed.css('height', temp.outerHeight() + 'px');
                    layer.css('overflow-y', 'scroll');
                    temp.css({
                        'margin-top': '0',
                        'top': '0'
                    });
                } else {
                    dimmed.css('height', $(window).innerHeight() + 50 + 'px');
                    layer.css('overflow-y', 'hidden');
                    temp.css({
                        'margin-top': '-' + temp.outerHeight() / 2 + 'px',
                        'top': '50%'
                    });

                };
            });

            if (location.href.match("/biz/jobpost") != null) {
                chk_layer(el); //jobspost_step.js
            }
            
        };//���̾��߾�����

        function tooltipFnc() {//����
            $('.tooltipArea > button, .tooltipBtn').on('click', function () {
                var obj = $(this).next();

                if (obj.css('display') == 'none') {
                    $(this).addClass('on');
                    $('.tooltipArea .box').hide();
                    obj.css('display', 'block');
                } else {
                    $(this).removeClass('on')
                    obj.css('display', 'none');
                }
            });

            $('.tooltipArea .box > button').on('click', function () {
                $(this).parent().hide();
            });
        };//����

        function tooltipFnc() {//����
            $('.tooltipArea > button, .tooltipBtn').on('click', function () {
                var obj = $(this).next();

                if (obj.css('display') == 'none') {
                    $(this).addClass('on');
                    $('.tooltipArea .box').hide();
                    obj.css('display', 'block');
                } else {
                    $(this).removeClass('on')
                    obj.css('display', 'none');
                }
            });

            $('.tooltipArea .box > button').on('click', function () {
                $(this).parent().hide();
            });
        };//����


        //2017-10-10 ����
        toggleFnc = function (obj, obj2) {//���
            if ($(obj2).css('display') == 'none') {
                $(obj).addClass('on');
                $(obj2).css('display', 'block');
            } else {
                $(obj).removeClass('on');
                $(obj2).css('display', 'none');
            }
        }//���

        function toggle2Fnc() {//�����������
            $('.toggle').on('click', function () {
                var obj = $(this).next().find('>div')
                if (obj.css('display') == 'none') {
                    $('.tooltipArea .box').hide();
                    obj.css('display', 'block');
                } else {
                    obj.css('display', 'none');
                }
            });
        };//�����������
        //2017-10-10 ����

        tabFnc = function (obj, group, idx) {//�Ǹ޴�
            $(group).each(function (index, value) {
                if (idx == index) {
                    $(group).eq(index).show();
                    $(obj).parents('ul').find('li').eq(index).addClass('on');
                } else {
                    $(group).eq(index).hide();
                    $(obj).parents('ul').find('li').eq(index).removeClass('on');
                }
            });
        };//�Ǹ޴�

        popOpenFnc = function (obj) {//�˾�����
            $(obj).show();
        };//�˾�����

        popCloseFnc = function (obj) {//�˾��ݱ�
            $(obj).hide();
        };//�˾��ݱ�

        function rnbWrapFnc() {//RNB
            if ($('#rnb .fixArea').length == 0) return false;
            var _quick = $('#rnb .fixArea');
            var _tmp = null;
            var speed = 100;
            var objPosition = _quick.offset().top;
            var currentPosition = parseInt(_quick.css('top')) + 20;
            $(window).scroll(function () {
                var position = $(window).scrollTop();
                if (position > objPosition + currentPosition) {
                    //if (position > 398) {
                    if (_quick.css('position') != 'fixed') _quick.css({ 'position': 'fixed', 'top': 20 });
                    $('.topBtn').show();
                } else {
                    if (_quick.css('position') == 'fixed') _quick.css({ 'position': 'absolute', 'top': 0 });
                    $('.topBtn').hide();
                }
            });
            $(".topBtn a").click(function () {//top��ư
                $('html, body').animate({
                    scrollTop: 0
                }, 200);
                return false;
            });
        };//RNB

        jobPostRnb = function () {//ä������� ���̵�޴� 2017/11/29 ����
            //��ũ�� �ִϸ��̼�
            var $body = $('body');
            var htmlWrap = $('html, body');
            $body.on('click', '.sideStep ul a', function (e) {
                var offset = $($(this).attr('href')).offset(),
					marginTop = $(this).data('margin-top') || 0;
                if (!!offset) {
                    htmlWrap.stop().animate({ scrollTop: offset.top - marginTop });
                    e.preventDefault();
                }
            });

            //��ġ������ �޴� Ȱ��ȭ
            var $window = $(window),
				sectionBorderPadding = 120,
				lastEventToken,
				$sideStepMe = $('.sideStep'),
				$sideStep = $('.sideStep .inn'),
				idArray = [];
            $sideStep.find('li:first').addClass('on');//ù��° �޴��� on �߰�
            $window.on('scroll', function () {
                //������ �̺�Ʈ�� ó���ϵ���
                var closureToken = Math.floor((Math.random() * 1000000) + 1),
					windowScrollTop = $window.scrollTop(),
					tabOn, tmpOffset;

                lastEventToken = closureToken;

                if (windowScrollTop >= 90) {
                    $sideStep.css({ 'top': 0 });
					$sideStepMe.css({ 'margin-top': 0 });
                    $('.topBtn').show();
                } else {
                    $sideStep.css({ 'top': 120 });
					$sideStepMe.css({ 'margin-top': 0 });
                    $('.topBtn').hide();
                }

                $('.scSet').each(function (n) {
                    var id = $(this);
                    idArray[n] = id;
                });

                setTimeout(function () {
                    if (closureToken === lastEventToken) {
                        //right tab menu
                        tabOn = 0;
                        for (i = 0; i < idArray.length; i++) {
                            if (idArray[i].size() > 0) {
                                tmpOffset = idArray[i].offset();
                                if ((windowScrollTop + sectionBorderPadding) > tmpOffset.top) {
                                    tabOn = i;
                                } else {
                                    break;
                                }
                            }
                        };
                        $sideStep.find('li')
						.eq(tabOn).addClass('on')
						.siblings().removeClass('on');
                    }
                }, 200);
            });
            $(".topBtn a").click(function () {//top��ư
                $('html, body').animate({
                    scrollTop: 0
                }, 200);
                return false;
            });
        };//ä������� ���̵�޴�

        searchListFnc = function () {//�ڰ���/������� �˻�
            var _obj = $('.inputSearch');
            _obj.each(function () {
                $(this).on("keyup", function (e) {
                    var _autoHight = $(this).parent().find('.autoHight');
                    var _autoTxt = $(this).parent().find('.autoHight a');

                    if ($(this).val() == "") {
                        _autoHight.hide();
                    } else {
                        _autoHight.show();
                        _autoTxt.each(function () {
                            $(this).on("click", function (e) {
                                var _text = $(this).text()
                                var _inputBox = $(this).parent().parent().parent().parent().find('.inputSearch');
                                var _autoBox = _autoTxt.parent().parent().parent();
                                _inputBox.val(_text);
                                _autoBox.hide();
                            });
                        })
                    }
                });
            })
            $("body").click(function (e) {
                if (!$(".autoHight").has(e.target).length) {
                    $(".autoHight").hide();
                }
            });
        };

        searchTextFn = function () {
            var _obj = $('.autoHight a');

            _obj.each(function () {
                $(this).on("click", function (e) {
                    var _text = $(this).text()
                    var _inputBox = $(this).parent().parent().parent().prev().prev();
                    var _autoBox = _obj.parent().parent().parent();
                    _inputBox.val(_text);
                    _autoBox.hide();
                });
            })
        };//�ڰ���/������� �˻�

        AddlangFnc = function (obj) {//ä������� �ܱ��� ���̾� 2017-11-22 ����
            if ($('select[name=language_name]').length < 3) {
                var _html = '<div class="inp addLine">';
                _html += '		<span class="selectbox" style="width:151px">';
                _html += '			<span>����</span>';
                _html += '			<select title="����" name="language_name" onchange="ajax_code_langex(this);">';
                _html += '              <option value="">����</option>';
                _html += '				<option value="1">����</option>';
                _html += '				<option value="2">�Ϻ���</option>';
                _html += '				<option value="3">�߱���</option>';
                _html += '				<option value="4">��������</option>';
                _html += '				<option value="5">���Ͼ�</option>';
                _html += '			</select>';
                _html += '		</span><!-- .selectbox -->';
                _html += '		<span class="selectbox" style="width:281px">';
                _html += '			<span>���� ����</span>';
                _html += '			<select title="���� ����" name="language_exam" onchange="chk_sel(this);">';
                _html += '				<option value="">���� ����</option>';
                _html += '			</select>';
                _html += '		</span><!-- .selectbox -->';
                _html += '		<input type="text" class="txt color" name="language_score" style="width:71px" />';
                _html += '		<span class="txt">��(��) �̻�</span>';
                _html += '		<button type="button" class="btn delete" onclick="removeLineFnc(this);">����</button>';
                _html += '	</div>';

                $(obj).parent().parent().prev().append(_html);
                selectboxFnc();
            } else {
                alert('3���̻� ����� �� �����ϴ�.');
            }
        };//ä������� �ܱ��� ���̾��߰�

        AddLicenseFnc = function (obj) {//ä������� �ڰ��� ���̾� 2017-11-22 ����
            if ($('input[name=license_name]').length < 3) {
                var _html = '<div class="inp addLine">';
                _html += '		<input type="text" class="txt color inputSearch" id="" style="width:671px" onkeyup="ajax_code(this)" name="license_name" />';
                _html += '      <input type="hidden" name="license_code">';
                _html += '		<button type="button" class="btn delete" onclick="removeLineFnc(this);">����</button>';
                _html += '		<div class="autoHight" style="display:none">';
                _html += '		</div><!-- .autoHight -->';
                _html += '	</div>';

                $(obj).parent().parent().prev().append(_html);
                selectboxFnc();
                searchListFnc();
            } else {
                alert('3���̻� ����� �� �����ϴ�.');
            }
        };//ä������� �ڰ��� ���̾��߰�

        AddMajorFnc = function (obj) {//ä������� ������� 2017-11-22 ����
            if ($('input[name=special_subject_text]').length < 5) {
                var _html = '<div class="inp addLine">';
                _html += '		<input type="text" class="txt color inputSearch" id="" style="width:671px" onkeyup="ajax_code(this)" name="special_subject_text" />';
                _html += '      <input type="hidden" name="special_subject">';
                _html += '		<button type="button" class="btn delete" onclick="removeLineFnc(this);">����</button>';
                _html += '		<div class="autoHight" style="display:none">';
                _html += '		</div><!-- .autoHight -->';
                _html += '	</div>';

                $(obj).parent().parent().prev().append(_html);
                selectboxFnc();
                searchListFnc();
            } else {
                alert('5���̻� ����� �� �����ϴ�.');
            }
        };//ä������� ������� ���̾��߰�

        AddDivisionFnc = function (obj) {//ä������� �����κ� ���̾��߰�
            if ($('input[name=job_part]').length < 30) {
                var _html = '<div class="inp addLine">';
                _html += '		<input type="text" class="txt color" name="job_part" id="" style="width:377px"><button type="button" class="btn delete" onclick="removeLineFnc(this);">����</button>';
                _html += '		<button type="button" class="btn add" onclick="AddDivisionFnc(this);">�߰�</button>';
                _html += '	</div>';

                $(obj).parent().parent().append(_html);
                inputFnc();
                $('input.value, textarea.area').check();
            } else {
                alert('30���̻� ����� �� �����ϴ�.');
            }
        };//ä������� �����κ� ���̾��߰�

        AddProcedureFnc = function (obj) {//ä������� �������� ���̾��߰�
            if ($('input[name=choiceprocess]').length < 10) {
                var _html = '<li class="addLine">';
                _html += '		<span class="num">' + ($('input[name=choiceprocess]').length+1) + '.</span>';
                _html += '		<input type="text" name="choiceprocess" class="txt value color" default="�������� �Է�" />';
                _html += '		<button type="button" class="btn deleteS" onclick="removeLineFnc(this);">����</button>';
                _html += '	</li>';

                $(obj).parent().parent().prev().find('ol').append(_html);
                inputFnc();
                $('input.value, textarea.area').check();
            } else {
                alert('10���̻� ����� �� �����ϴ�.');
            }
        };//ä������� �������� ���̾��߰�

        AddQuestionFnc = function (obj) {//ä������� �������� ���̾��߰�
            if ($('input[name=priorAnswer]').length < 5){
                var _html = '<li class="addLine">';
                _html += '		<span class="num">' + ($('input[name=priorAnswer]').length + 1) + '.</span>';
                _html += '		<input type="text" name="priorAnswer" class="txt value color" default="�������� �Է����ּ���." />';
                _html += '		<button type="button" class="btn delete" onclick="removeLineFnc(this);">����</button>';
                _html += '	</li>';

                $(obj).parent().parent().prev().find('ol').append(_html);
                inputFnc();
                $('input.value, textarea.area').check();
            } else {
                alert('5���̻� ����� �� �����ϴ�.');
            }
        };//ä������� �������� ���̾��߰�

        AddAddressFnc = function (obj) {//ä������� �ٹ����� ���̾��߰�
            if ($('select[name=areaCode1]').length < 30) {
                var _html = '<div class="inp addLine">';
                _html += '		<span class="selectbox" style="width:218px">';
                _html += '			<span>�ü���</span>';
                _html += '			<select title="�� ����" name="areaCode1" onchange="ajax_acList(this);">';
                _html += '			    <option value="">�� ����</option>';
                _html += '			    <option value="1">����Ư����</option>';
                _html += '			    <option value="10">��걤����</option>';
                _html += '			    <option value="11">��õ������</option>';
                _html += '			    <option value="12">���󳲵�</option>';
                _html += '			    <option value="13">����ϵ�</option>';
                _html += '			    <option value="14">���ֵ�</option>';
                _html += '			    <option value="15">��û����</option>';
                _html += '			    <option value="16">��û�ϵ�</option>';
                _html += '			    <option value="2">������</option>';
                _html += '			    <option value="3">��⵵</option>';
                _html += '			    <option value="4">��󳲵�</option>';
                _html += '			    <option value="5">���ϵ�</option>';
                _html += '			    <option value="6">���ֱ�����</option>';
                _html += '			    <option value="7">�뱸������</option>';
                _html += '			    <option value="8">����������</option>';
                _html += '			    <option value="9">�λ걤����</option>';
                _html += '			    <option value="17">����</option>';
                _html += '			    <option value="30">������</option>';
                _html += '			    <option value="29">���Ѱ���Ư��</option>';
                _html += '			    <option value="25">�ƽþ�.�ߵ�</option>';
                _html += '			    <option value="26">������ī</option>';
                _html += '			    <option value="27">�Ƹ޸�ī</option>';
                _html += '			    <option value="23">����</option>';
                _html += '			    <option value="28">�����ƴϾ�</option>';
                _html += '			</select>';
                _html += '		</span><!-- .selectbox -->';
                _html += '		<span class="selectbox" style="width:281px">';
                _html += '			<span>�� ����</span>';
                _html += '			<select title="�� ����" name="areaCode2" onchange="chk_sel(this)">';
                _html += '				<option value="">�� ����</option>';
                _html += '			</select>';
                _html += '		</span><!-- .selectbox -->';
                _html += '		<button type="button" class="btn delete" onclick="removeLineFnc(this);">����</button>';
                _html += '	</div>';

                $(obj).parent().parent().prev().append(_html);
                selectboxFnc();
            } else {
                alert('30���̻� ����� �� �����ϴ�.');
            }
        };//ä������� �ٹ����� ���̾��߰�

        AddMetroFnc = function (obj) {//ä������� �α���ö ���̾� 2017-11-22 ����
            if ($('select[name=sw_a]').length < 2) {
                var _html = '<div class="inp addLine">';
                _html += '		<span class="selectbox" style="width:110px">';
                _html += '		    <span>����</span>';
                _html += '		    <select title="����" name="sw_a" onchange="ajax_sbList(this);" id="sw_a2">';
                _html += '		        <option value="">����</option>';
                _html += '		        <option value="01">������</option>';
                _html += '		        <option value="02">�λ�</option>';
                _html += '		        <option value="03">�뱸</option>';
                _html += '		        <option value="04">����</option>';
                _html += '		        <option value="05">����</option>';
                _html += '		    </select>';
                _html += '		</span><!-- .selectbox -->';
                _html += '		<span class="selectbox" style="width:151px">';
                _html += '		    <span>�뼱</span>';
                _html += '		    <select title="�뼱" name="sw_l" onchange="ajax_sbList(this);">';
                _html += '		        <option value="">�뼱</option>';
                _html += '		    </select>';
                _html += '		</span><!-- .selectbox -->';
                _html += '		<span class="selectbox" style="width:199px">';
                _html += '		    <span>����</span>';
                _html += '		    <select title="����" name="sb">';
                _html += '		        <option  value="">����</option>';
                _html += '		    </select>';
                _html += '		</span><!-- .selectbox -->';
                _html += '		<input type="text" class="txt color" name="enternum" id="" style="width:59px" onkeypress="return numkeyCheck(event);" />';
                _html += '		<span class="txt">�� �ⱸ</span>';
                _html += '		<span class="selectbox" style="width:101px">';
                _html += '		    <span>�Ÿ�</span>';
                _html += '		    <select title="�Ÿ�" name="dist">';
                _html += '		        <option value="">�Ÿ�</option>';
                _html += '		        <option value="10">10M</option>';
                _html += '		        <option value="100">100M</option>';
                _html += '		        <option value="150">150M</option>';
                _html += '		        <option value="300">300M</option>';
                _html += '		        <option value="500">500M</option>';
                _html += '		        <option value="1000">1Km</option>';
                _html += '		        <option value="2000">2Km</option>';
                _html += '		    </select>';
                _html += '		</span><!-- .selectbox -->';
                _html += '		<span class="txt">�̳�</span>';
                _html += '		<button type="button" class="btn delete" onclick="removeLineFnc(this);">����</button>';
                _html += '	</div>';

                $(obj).parent().parent().prev().append(_html);
                selectboxFnc();
            } else {
                alert('2���̻� ����� �� �����ϴ�.');
            }
        };//ä������� �α���ö ���̾��߰�

        removeLineFnc = function (obj) {//����Ʈ ���� ����
            $(obj).parent().remove();
            hasListFnc();
        };//����Ʈ ���� ����

        removeFnc = function (obj) {//����Ʈ �Ѱ� ����
            $(obj).remove();
        };//����Ʈ �Ѱ� ����

        resetLineFnc = function (obj) {//�߰��� ��ü ����Ʈ ����
            $(obj).parent().parent().prev().find('.addLine').remove();
            $(obj).parent().parent().prev().find('.inp .inputSearch').val('');

            // ����Ʈ�ڽ��� �ִ� ���, �ʱ�ȭ
            $(obj).parent().parent().prev().find('select').val('');
            $(obj).parent().parent().prev().find('input').val('');
            $(obj).parent().parent().prev().find('select').eq(0).prev().html($(obj).parent().parent().prev().find('select').eq(0).find(':selected').text());
            $(obj).parent().parent().prev().find('select').eq(1).prev().html($(obj).parent().parent().prev().find('select').eq(1).find(':selected').text());
            $(obj).parent().parent().prev().find('select').eq(2).prev().html($(obj).parent().parent().prev().find('select').eq(2).find(':selected').text());
            $(obj).parent().parent().prev().find('select').eq(3).prev().html($(obj).parent().parent().prev().find('select').eq(3).find(':selected').text());

            $(obj).parent().parent().prev().find('checkbox').prop("checked", false);
            $(obj).parent().parent().next().removeClass('on').addClass('off');
        };//�߰��� ��ü ����Ʈ ����

        hasListFnc = function () {//���ü�����ư����
            var _obj = $('.selectBtn');
            _obj.each(function() {
                if ($(this).find('li').length == 0) {
                    $(this).parent().parent().next().find('button span').html('�����ϱ�');
                    if($(this).parent().hasClass("welfare")) {//����������� �����Ļ�
                        var _nodata = '<li><span class="fc_gra9">��ϵ� �����Ļ��� �����ϴ�.</span></li>';
                        $(this).append(_nodata);
                    }//����������� �����Ļ�
                } else {
                    $(this).parent().parent().next().find('button span').html('�����ϱ�');

                }
            });
        };//���ü�����ư����

        mulSelBoxFnc = function (obj,obj2) {//���߼��ùڽ� 2017-10-16 ����
            if ($(obj).length == 0) return false;
            var _obj = $(obj);
            var _obj2 = $('#' + obj2);
            if(_obj.hasClass('on')){
                $('.multiSelect').hide();
                $('.mulSelBox').children().removeClass('on');
            } else{
                _obj.parent().children().removeClass('on');
                _obj.parent().find('.multiSelect').hide();
                _obj.addClass('on');
                _obj2.show();
                multiSelectFnc(obj);
            }
            $("body").on('click',function(e){
                if (!$(e.target).hasClass('on')){
                    $('.multiSelect').hide();
                    $('.mulSelBox').children().removeClass('on');
                };
            });
        };//���߼��ùڽ�

        function multiSelectFnc(obj) {//������ ����,����Ը�,���忩�� 2017-10-10 ����
            var _this;
            if (!obj)
                _this = $('.multiSelect');
            else
                _this = $(obj);
            var _lt = _this.find('.depth1');
            var _ltLi = _lt.children();
            var _rt = _this.find('.depth2');
            var _rtLi = _rt.children();
            var _selTxt = _rt.find('a');

            _ltLi.bind('click', function() {
                var _index = _ltLi.index($(this));
                _ltLi.each(function(index, value) {
                    if(_index == index) {
                        $(this).addClass('on');
                        $(this).parent().parent().next().find('.depth2').eq(index).show();
                    } else {
                        $(this).removeClass('on');
                        $(this).parent().parent().next().find('.depth2').eq(index).hide();
                    }
                });
                return false;
            });
            _rtLi.bind('click', function() {
                var _index = _rtLi.index($(this));
                _rtLi.each(function(index, value) {
                    if(_index == index) {
                        _mulSelVal = $(this).find('a').text();
                        _this.find('em').text(_mulSelVal);
                        $(this).addClass('on');
                        $(this).parents('.multiSelect').hide();
                        $(this).parents('.multiSelect').parent().removeClass('on');

                    } else {
                        $(this).removeClass('on');
                    }
                });
                return false;
            });

        }//������ ����,����Ը�,���忩��

        function toggle3Fnc() {//�����ڰ������� 2017-10-13 �߰�
            var _this = $('.tooltipArea.select');
            var _obj = _this.find('.tooltipBtn');
            var _objLi = _this.find('li');
            _objLi.bind('click', function() {
                var _objVal = $(this).text();
                _obj.removeClass('on');
                $(this).parent().parent().parent().find('.tooltipBtn span').text(_objVal);
                $(this).parent().parent().hide();
            });
        };//�����ڰ�������


        function SelJobBoxFnc(obj) {//�����ڰ��� ������ 2017-10-16 �߰�
            var _this;
            if (!obj)
                _this = $('.selRecruitArea');
            else
                _this = $(obj);
            var _obj = _this.find('.tit');
            var _objBox = _obj.next();
            var _objDl = _objBox.find('dl');
            var _objDd = _objBox.find('dd a');
            _obj.bind('click', function() {
                if($(this).hasClass('on')){
                    _obj.removeClass('on');
                    _objBox.hide();
                }else{
                    _obj.addClass('on');
                    _objBox.show();
                }
            });
            _objDd.bind('click', function() {
                _objVal = $(this).text();
                _obj.find('em').text(_objVal);
                _objDd.removeClass('on');
                $(this).addClass('on');
                _objBox.hide();
                _obj.removeClass('on');
                _objSort = _obj.find('span');
                if($(this).hasClass('ing')){
                    _obj.addClass('ing');
                    _obj.removeClass('end');
                    _objSort.html('<span>������</span>');
                } else{
                    _obj.addClass('end');
                    _obj.removeClass('ing');
                    _objSort.html('<span>����</span>');
                }
            });
            $("body").on('click',function(e){
                if (!$(e.target).hasClass('on')){
                    $('.multiSelect').hide();
                    $('.mulSelBox').children().removeClass('on');
                };
            });

        };//�����ڰ��� ������

        function sliderFnc(obj){//�󼼸����䰭 ���ø� �����̴� 2017-11-29 ����
            $('.slider li').each(function(){
                $(this).bind({
                    "click": function () {
                        fnSelTemplate($(this).attr('id'));
                        /*if(confirm("�����Ͻðڽ��ϱ�?"))
                        {
                            $('.slider li').removeClass('on');
                            $(this).addClass('on');
                        }*/
                    }
                });
            });

            var movSlider = $('.slider').bxSlider({
                infiniteLoop: false,
                speed: 300,        // �̵� �ӵ��� ����
                pager: false,      // ���� ��ġ ����¡ ǥ�� ���� ����
                moveSlides: 1,     // �����̵� �̵��� ����
                slideWidth: 152,   // �����̵� �ʺ�
                minSlides: 4,      // �ּ� ���� ����
                maxSlides: 5,      // �ִ� ���� ����
                slideMargin: 10,    // �����̵尣�� ����
                auto: false,        // �ڵ� ���� ����
                autoHover: true,   // ���콺 ȣ���� ���� ����
                touchEnabled: false,
                hideControlOnEnd: true,
                controls: true    // ���� ���� ��ư ���� ����
            });
            //���� ��ư�� Ŭ���ϸ� ���� �����̵�� ��ȯ
            $('.bt-prev').on('click', function () {
                movSlider.goToPrevSlide();  //���� �����̵� ��ʷ� �̵�
                return false;              //<a>�� ��ũ ����
            });
            //���� ��ư�� Ŭ���ϸ� ���� �����̵�� ��ȯ
            $('.bt-next').on('click', function () {
                movSlider.goToNextSlide();  //���� �����̵� ��ʷ� �̵�
                return false;
            });
        }

        function bgChaingeFnc() {//ä������� ��� 2017-11-23 �߰�
            $('.jobPostWrap .layoutBox:odd').addClass("bgWhite");
            $('.jobPostWrap .layoutBox:even').removeClass("bgWhite");
        };

        newWindowFull = function (obj) {//�̷¼����� ��ü�������˾� 2017-11-29 ����
            var wname = open(obj, "", 'top=0,left=0,width=' + (screen.availWidth) + ',height=' + (screen.availHeight) + ',toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=1,scrolling=0,scrollbars=1');
            wname.focus();
        };

        newWindowFnc = function (url, width, height) {//����,SMS�߼� �������˾� 2017-12-05 ����
            var attr = "width=" + width + ", height=" + height + ", resizable=no, scrollbars=yes, status=no";
            window.open(url, "", attr);
            return false;
        }

    });
})(jQuery);