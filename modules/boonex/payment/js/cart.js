function BxPaymentCart(oOptions) {
	this.init(oOptions);
}

BxPaymentCart.prototype.init = function(oOptions) {
	if($.isEmptyObject(oOptions))
		return;

	this._sActionsUrl = oOptions.sActionUrl;
    this._sObjName = oOptions.sObjName == undefined ? 'oPmtCart' : oOptions.sObjName;
    this._sAnimationEffect = oOptions.sAnimationEffect == undefined ? 'fade' : oOptions.sAnimationEffect;
    this._iAnimationSpeed = oOptions.iAnimationSpeed == undefined ? 'slow' : oOptions.iAnimationSpeed;

    this._sErrNothingSelected = '_bx_payment_err_nothing_selected';
};

BxPaymentCart.prototype.addToCart = function(iVendorId, iModuleId, iItemId, iItemCount, iNeedRedirect) {
    var oDate = new Date();
    var $this = this;

    if(!(iNeedRedirect = parseInt(iNeedRedirect)))
    	iNeedRedirect = 0;

    $.post(
        this._sActionsUrl + 'add_to_cart/' + iVendorId + '/' + iModuleId + '/' + iItemId + '/' + iItemCount + '/',
        {
            _t:oDate.getTime()
        },
        function(oData){
        	alert(oData.message);

            if(oData.code == 0) {
            	/*
            	 * TODO: Display counter somewhere if it's needed.
            	 * 
            	$('#bx-menu-object-sys_account_notifications').html(oData.total_quantity);
                $('#bx-payment-tbar-content').replaceWith(oData.content);
                */

            	if(iNeedRedirect == 1)
            		window.location.href = $this._sActionsUrl + 'cart';
            }
        },
        'json'
    );
};

/**
 * Isn't used yet.
 */
BxPaymentCart.prototype.deleteFromCart = function(iVendorId, iModuleId, iItemId) {
    var oDate = new Date();
    var $this = this;

    $.post(
        this._sActionsUrl + 'delete_from_cart/' + iVendorId + '/' + iModuleId + '/' + iItemId,
        {
            _t:oDate.getTime()
        },
        function(oData) {
            alert(oData.message);

            if(oData.code == 0) {
            	/*
            	 * TODO: Hide item if it's needed.
            	 * 
                $('#item-' + iVendorId + '-' + iModuleId + '-' + iItemId).bx_anim('hide', $this._sAnimationEffect, $this._iAnimationSpeed, function() {
                        $(this).remove();
                });
                 */
            }
        },
        'json'
    );
};

/**
 * Isn't used yet.
 */
BxPaymentCart.prototype.emptyCart = function(iVendorId) {
    var oDate = new Date();
    var $this = this;    

    $.post(
        this._sActionsUrl + 'empty_cart/' + iVendorId,
        {
            _t:oDate.getTime()
        },
        function(oData){
            if(oData.code == 0) {
            	/*
            	 * TODO: Hide vendor from vendors's list if it's needed.
            	 */
            }
            alert(oData.message);
        },
        'json'
    );
};

BxPaymentCart.prototype.toggle = function(oElement) {
	$(oElement).find('.sys-icon').toggleClass('caret-down').toggleClass('caret-right');
    $(oElement).parents('.bx-payment-box:first').find('.bx-payment-box-cnt').bx_anim('toggle', 'slide', this._iAnimationSpeed);
};

BxPaymentCart.prototype.onSubmit = function(oForm) {
    if($(oForm).find(":checkbox[name='items[]']:checked").length > 0)
    	return true;

    alert(_t(this._sErrNothingSelected));
	return false;
};