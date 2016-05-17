<?php defined('BX_DOL') or die('hack attempt');
/**
 * Copyright (c) BoonEx Pty Limited - http://www.boonex.com/
 * CC-BY License - http://creativecommons.org/licenses/by/3.0/
 *
 * @defgroup    Groups Groups
 * @ingroup     TridentModules
 *
 * @{
 */

/**
 * Groups profiles module.
 */
class BxGroupsModule extends BxBaseModProfileModule
{
    function __construct(&$aModule)
    {
        parent::__construct($aModule);
    }

    /**
     * Get possible recipients for start conversation form
     */
    public function actionAjaxGetInitialMembers ()
    {
        $sTerm = bx_get('term');

        $a = BxDolService::call('system', 'profiles_search', array($sTerm), 'TemplServiceProfiles');

        header('Content-Type:text/javascript; charset=utf-8');
        echo(json_encode($a));
    }

    public function serviceActAsProfile ()
    {
        return false;
    }

    public function servicePrepareFields ($aFieldsProfile)
    {
        $aFieldsProfile['group_name'] = $aFieldsProfile['name'];
        $aFieldsProfile['group_desc'] = isset($aFieldsProfile['description']) ? $aFieldsProfile['description'] : '';
        unset($aFieldsProfile['name']);
        unset($aFieldsProfile['description']);
        return $aFieldsProfile;
    }

    public function serviceAddMutualConnection ($iGroupProfileId, $iInitiatorId, $iIgnoreJoinConfirmation = false)
    {        
        if (!($oGroupProfile = BxDolProfile::getInstance($iGroupProfileId)))
            return false;

        $aContentInfo = $this->_oDb->getContentInfoById((int)$oGroupProfile->getContentId());
        if (!$aContentInfo || (!$iIgnoreJoinConfirmation && $aContentInfo['join_confirmation']))
            return false;

        if (!($oConnection = BxDolConnection::getObjectInstance($this->_oConfig->CNF['OBJECT_CONNECTIONS'])))
            return false;

        return $oConnection->addConnection($oGroupProfile->id(), (int)$iInitiatorId);
    }

    public function serviceFansTable ()
    {
        $oGrid = BxDolGrid::getObjectInstance($this->_oConfig->CNF['OBJECT_GRID_CONNECTIONS']);
        if (!$oGrid)
            return false;

        return $oGrid->getCode();
    }

    public function serviceFans ($iContentId = 0)
    {
        if (!$iContentId)
            $iContentId = bx_process_input(bx_get('id'), BX_DATA_INT);
        if (!$iContentId)
            return false;

        $aContentInfo = $this->_oDb->getContentInfoById($iContentId);
        if (!$aContentInfo)
            return false;

        if (!($oGroupProfile = BxDolProfile::getInstanceByContentAndType($iContentId, $this->getName())))
            return false;

        bx_import('BxDolConnection');
        $s = $this->serviceBrowseConnectionsQuick ($oGroupProfile->id(), $this->_oConfig->CNF['OBJECT_CONNECTIONS'], BX_CONNECTIONS_CONTENT_TYPE_CONTENT, true);
        if (!$s)
            return MsgBox(_t('_sys_txt_empty'));
        return $s;
    }

    public function serviceBrowseJoinedEntries ($iProfileId = 0, $bDisplayEmptyMsg = false)
    {
        if (!$iProfileId)
            $iProfileId = bx_process_input(bx_get('profile_id'), BX_DATA_INT);
        if (!$iProfileId)
            return '';

        return $this->_serviceBrowse ('joined_entries', array('joined_profile' => $iProfileId), BX_DB_PADDING_DEF, $bDisplayEmptyMsg);
    }

    /**
     * @return CHECK_ACTION_RESULT_ALLOWED if access is granted or error message if access is forbidden.
     */
    public function checkAllowedView ($aDataEntry, $isPerformAction = false)
    {
        $oGroupProfile = BxDolProfile::getInstanceByContentAndType($aDataEntry[$this->_oConfig->CNF['FIELD_ID']], $this->getName());
        if ($oGroupProfile && ($oConnection = BxDolConnection::getObjectInstance($this->_oConfig->CNF['OBJECT_CONNECTIONS'])) && $oConnection->isConnected(bx_get_logged_profile_id(), $oGroupProfile->id(), true))
            return CHECK_ACTION_RESULT_ALLOWED;

        return parent::checkAllowedView ($aDataEntry, $isPerformAction);
    }

    /**
     * @return CHECK_ACTION_RESULT_ALLOWED if access is granted or error message if access is forbidden.
     */
    public function checkAllowedFanAdd (&$aDataEntry, $isPerformAction = false)
    {
        return $this->_checkAllowedConnect ($aDataEntry, $isPerformAction, $this->_oConfig->CNF['OBJECT_CONNECTIONS'], true, false);
    }

    /**
     * @return CHECK_ACTION_RESULT_ALLOWED if access is granted or error message if access is forbidden.
     */
    public function checkAllowedFanRemove (&$aDataEntry, $isPerformAction = false)
    {
        if (CHECK_ACTION_RESULT_ALLOWED === $this->_checkAllowedConnect ($aDataEntry, $isPerformAction, $this->_oConfig->CNF['OBJECT_CONNECTIONS'], false, true, true))
            return CHECK_ACTION_RESULT_ALLOWED;
        return $this->_checkAllowedConnect ($aDataEntry, $isPerformAction, $this->_oConfig->CNF['OBJECT_CONNECTIONS'], false, true, false);
    }

    public function checkAllowedManageAdmins ($mixedDataEntry, $isPerformAction = false)
    {
        $aDataEntry = is_array($mixedDataEntry) ? $mixedDataEntry : $this->_oDb->getContentInfoById((int)$mixedDataEntry);

        return parent::checkAllowedEdit ($aDataEntry, $isPerformAction);
    }

    public function checkAllowedEdit ($aDataEntry, $isPerformAction = false)
    {
        $oGroupProfile = BxDolProfile::getInstanceByContentAndType($aDataEntry[$this->_oConfig->CNF['FIELD_ID']], $this->getName());
        if ($this->_oDb->isAdmin($oGroupProfile->id(), bx_get_logged_profile_id()))
            return CHECK_ACTION_RESULT_ALLOWED;
        return parent::checkAllowedEdit ($aDataEntry, $isPerformAction);
    }

    public function checkAllowedChangeCover ($aDataEntry, $isPerformAction = false)
    {
        $oGroupProfile = BxDolProfile::getInstanceByContentAndType($aDataEntry[$this->_oConfig->CNF['FIELD_ID']], $this->getName());
        if ($this->_oDb->isAdmin($oGroupProfile->id(), bx_get_logged_profile_id()))
            return CHECK_ACTION_RESULT_ALLOWED;
        return parent::checkAllowedChangeCover ($aDataEntry, $isPerformAction);
    }

    public function checkAllowedDelete (&$aDataEntry, $isPerformAction = false)
    {
        $oGroupProfile = BxDolProfile::getInstanceByContentAndType($aDataEntry[$this->_oConfig->CNF['FIELD_ID']], $this->getName());
        if ($oGroupProfile && $this->_oDb->isAdmin($oGroupProfile->id(), bx_get_logged_profile_id()))
            return CHECK_ACTION_RESULT_ALLOWED;
        return parent::checkAllowedDelete ($aDataEntry, $isPerformAction);
    }

    protected function _checkAllowedConnect (&$aDataEntry, $isPerformAction, $sObjConnection, $isMutual, $isInvertResult, $isSwap = false)
    {
        $sResult = $this->checkAllowedView($aDataEntry);
        if (CHECK_ACTION_RESULT_ALLOWED !== $sResult)
            return $sResult;

        return parent::_checkAllowedConnect ($aDataEntry, $isPerformAction, $sObjConnection, $isMutual, $isInvertResult, $isSwap);
    }
}

/** @} */