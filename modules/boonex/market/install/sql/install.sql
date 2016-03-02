
-- TABLE: entries
CREATE TABLE IF NOT EXISTS `bx_market_products` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `author` int(10) unsigned NOT NULL,
  `added` int(11) NOT NULL,
  `changed` int(11) NOT NULL,
  `thumb` int(11) NOT NULL,
  `package` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `text` text NOT NULL,
  `cat` int(11) NOT NULL,
  `price` int(11) NOT NULL,
  `views` int(11) NOT NULL default '0',
  `rate` float NOT NULL default '0',
  `votes` int(11) NOT NULL default '0',
  `comments` int(11) NOT NULL default '0',
  `reports` int(11) NOT NULL default '0',
  `allow_view_to` int(11) NOT NULL DEFAULT '3',
  `status` enum('active','hidden') NOT NULL DEFAULT 'active',
  PRIMARY KEY (`id`),
  FULLTEXT KEY `title_text` (`title`,`text`)
);

-- TABLE: customers
CREATE TABLE IF NOT EXISTS `bx_market_customers` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `client_id` int(11) unsigned NOT NULL default '0',
  `product_id` int(11) unsigned NOT NULL default '0',
  `order_id` varchar(32) collate utf8_unicode_ci NOT NULL default '',
  `count` int(11) unsigned NOT NULL default '0',
  `date` int(11) unsigned NOT NULL default '0',
  PRIMARY KEY (`id`),
  KEY `product_id` (`product_id`,`client_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- TABLE: storages & transcoders
CREATE TABLE IF NOT EXISTS `bx_market_files` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `profile_id` int(10) unsigned NOT NULL,
  `remote_id` varchar(255) NOT NULL,
  `path` varchar(255) NOT NULL,
  `file_name` varchar(255) NOT NULL,
  `mime_type` varchar(128) NOT NULL,
  `ext` varchar(32) NOT NULL,
  `size` int(11) NOT NULL,
  `added` int(11) NOT NULL,
  `modified` int(11) NOT NULL,
  `private` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `remote_id` (`remote_id`)
);

CREATE TABLE IF NOT EXISTS `bx_market_files2products` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `content_id` int(11) unsigned NOT NULL,
  `file_id` int(11) NOT NULL,
  `version` varchar(255) NOT NULL,
  `downloads` int(11) NOT NULL,
  `order` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `file_content` (`file_id`,`content_id`),
  KEY `content_id` (`content_id`)
);

CREATE TABLE IF NOT EXISTS `bx_market_photos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `profile_id` int(10) unsigned NOT NULL,
  `remote_id` varchar(255) NOT NULL,
  `path` varchar(255) NOT NULL,
  `file_name` varchar(255) NOT NULL,
  `mime_type` varchar(128) NOT NULL,
  `ext` varchar(32) NOT NULL,
  `size` int(11) NOT NULL,
  `added` int(11) NOT NULL,
  `modified` int(11) NOT NULL,
  `private` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `remote_id` (`remote_id`)
);

CREATE TABLE IF NOT EXISTS `bx_market_photos_resized` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `profile_id` int(10) unsigned NOT NULL,
  `remote_id` varchar(255) NOT NULL,
  `path` varchar(255) NOT NULL,
  `file_name` varchar(255) NOT NULL,
  `mime_type` varchar(128) NOT NULL,
  `ext` varchar(32) NOT NULL,
  `size` int(11) NOT NULL,
  `added` int(11) NOT NULL,
  `modified` int(11) NOT NULL,
  `private` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `remote_id` (`remote_id`)
);

-- TABLE: comments
CREATE TABLE IF NOT EXISTS `bx_market_cmts` (
  `cmt_id` int(11) NOT NULL AUTO_INCREMENT,
  `cmt_parent_id` int(11) NOT NULL DEFAULT '0',
  `cmt_vparent_id` int(11) NOT NULL DEFAULT '0',
  `cmt_object_id` int(11) NOT NULL DEFAULT '0',
  `cmt_author_id` int(10) unsigned NOT NULL DEFAULT '0',
  `cmt_level` int(11) NOT NULL DEFAULT '0',
  `cmt_text` text NOT NULL,
  `cmt_mood` tinyint(4) NOT NULL DEFAULT '0',
  `cmt_rate` int(11) NOT NULL DEFAULT '0',
  `cmt_rate_count` int(11) NOT NULL DEFAULT '0',
  `cmt_time` int(11) unsigned NOT NULL DEFAULT '0',
  `cmt_replies` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`cmt_id`),
  KEY `cmt_object_id` (`cmt_object_id`,`cmt_parent_id`)
);

-- TABLE: votes
CREATE TABLE IF NOT EXISTS `bx_market_votes` (
  `object_id` int(11) NOT NULL default '0',
  `count` int(11) NOT NULL default '0',
  `sum` int(11) NOT NULL default '0',
  UNIQUE KEY `object_id` (`object_id`)
) ENGINE=MYISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `bx_market_votes_track` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `object_id` int(11) NOT NULL default '0',
  `author_id` int(11) NOT NULL default '0',
  `author_nip` int(11) unsigned NOT NULL default '0',
  `value` tinyint(4) NOT NULL default '0',
  `date` int(11) NOT NULL default '0',
  PRIMARY KEY (`id`),
  KEY `vote` (`object_id`, `author_nip`)
) ENGINE=MYISAM DEFAULT CHARSET=utf8;

-- TABLE: views
CREATE TABLE `bx_market_views_track` (
  `object_id` int(11) NOT NULL default '0',
  `viewer_id` int(11) NOT NULL default '0',
  `viewer_nip` int(11) unsigned NOT NULL default '0',
  `date` int(11) NOT NULL default '0',
  KEY `id` (`object_id`,`viewer_id`,`viewer_nip`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- TABLE: metas
CREATE TABLE `bx_market_meta_keywords` (
  `object_id` int(10) unsigned NOT NULL,
  `keyword` varchar(255) NOT NULL,
  KEY `object_id` (`object_id`),
  KEY `keyword` (`keyword`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `bx_market_meta_locations` (
  `object_id` int(10) unsigned NOT NULL,
  `lat` double NOT NULL,
  `lng` double NOT NULL,
  `country` varchar(2) NOT NULL,
  `state` varchar(255) NOT NULL,
  `city` varchar(255) NOT NULL,
  `zip` varchar(255) NOT NULL,
  PRIMARY KEY (`object_id`),
  KEY `country_state_city` (`country`,`state`(8),`city`(8))
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- TABLE: reports
CREATE TABLE IF NOT EXISTS `bx_market_reports` (
  `object_id` int(11) NOT NULL default '0',
  `count` int(11) NOT NULL default '0',
  UNIQUE KEY `object_id` (`object_id`)
) ENGINE=MYISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `bx_market_reports_track` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `object_id` int(11) NOT NULL default '0',
  `author_id` int(11) NOT NULL default '0',
  `author_nip` int(11) unsigned NOT NULL default '0',
  `type` varchar(32) NOT NULL default '',
  `text` text NOT NULL default '',
  `date` int(11) NOT NULL default '0',
  PRIMARY KEY (`id`),
  KEY `report` (`object_id`, `author_nip`)
) ENGINE=MYISAM DEFAULT CHARSET=utf8;


-- STORAGES & TRANSCODERS
INSERT INTO `sys_objects_storage` (`object`, `engine`, `params`, `token_life`, `cache_control`, `levels`, `table_files`, `ext_mode`, `ext_allow`, `ext_deny`, `quota_size`, `current_size`, `quota_number`, `current_number`, `max_file_size`, `ts`) VALUES
('bx_market_files', 'Local', '', 360, 2592000, 3, 'bx_market_files', 'allow-deny', 'zip', '', 0, 0, 0, 0, 0, 0),
('bx_market_photos', 'Local', '', 360, 2592000, 3, 'bx_market_photos', 'allow-deny', 'jpg,jpeg,jpe,gif,png', '', 0, 0, 0, 0, 0, 0),
('bx_market_photos_resized', 'Local', '', 360, 2592000, 3, 'bx_market_photos_resized', 'allow-deny', 'jpg,jpeg,jpe,gif,png', '', 0, 0, 0, 0, 0, 0);

INSERT INTO `sys_objects_transcoder` (`object`, `storage_object`, `source_type`, `source_params`, `private`, `atime_tracking`, `atime_pruning`, `ts`) VALUES 
('bx_market_preview', 'bx_market_photos_resized', 'Storage', 'a:1:{s:6:"object";s:16:"bx_market_photos";}', 'no', '1', '2592000', '0'),
('bx_market_gallery', 'bx_market_photos_resized', 'Storage', 'a:1:{s:6:"object";s:16:"bx_market_photos";}', 'no', '1', '2592000', '0');

INSERT INTO `sys_transcoder_filters` (`transcoder_object`, `filter`, `filter_params`, `order`) VALUES 
('bx_market_preview', 'Resize', 'a:3:{s:1:"w";s:3:"128";s:1:"h";s:3:"128";s:11:"crop_resize";s:1:"1";}', '0'),
('bx_market_gallery', 'Resize', 'a:1:{s:1:"w";s:3:"500";}', '0');

-- FORMS
INSERT INTO `sys_objects_form`(`object`, `module`, `title`, `action`, `form_attrs`, `table`, `key`, `uri`, `uri_title`, `submit_name`, `params`, `deletable`, `active`, `override_class_name`, `override_class_file`) VALUES 
('bx_market', 'bx_market', '_bx_market_form_entry', '', 'a:1:{s:7:\"enctype\";s:19:\"multipart/form-data\";}', 'bx_market_products', 'id', '', '', 'do_submit', '', 0, 1, 'BxMarketFormEntry', 'modules/boonex/market/classes/BxMarketFormEntry.php');

INSERT INTO `sys_form_displays`(`object`, `display_name`, `module`, `view_mode`, `title`) VALUES 
('bx_market', 'bx_market_entry_add', 'bx_market', 0, '_bx_market_form_entry_display_add'),
('bx_market', 'bx_market_entry_delete', 'bx_market', 0, '_bx_market_form_entry_display_delete'),
('bx_market', 'bx_market_entry_edit', 'bx_market', 0, '_bx_market_form_entry_display_edit'),
('bx_market', 'bx_market_entry_view', 'bx_market', 1, '_bx_market_form_entry_display_view');

INSERT INTO `sys_form_inputs`(`object`, `module`, `name`, `value`, `values`, `checked`, `type`, `caption_system`, `caption`, `info`, `required`, `collapsed`, `html`, `attrs`, `attrs_tr`, `attrs_wrapper`, `checker_func`, `checker_params`, `checker_error`, `db_pass`, `db_params`, `editable`, `deletable`) VALUES 
('bx_market', 'bx_market', 'allow_view_to', '', '', 0, 'custom', '_bx_market_form_entry_input_sys_allow_view_to', '_bx_market_form_entry_input_allow_view_to', '', 1, 0, 0, '', '', '', '', '', '', '', '', 0, 0),
('bx_market', 'bx_market', 'delete_confirm', 1, '', 0, 'checkbox', '_bx_market_form_entry_input_sys_delete_confirm', '_bx_market_form_entry_input_delete_confirm', '_bx_market_form_entry_input_delete_confirm_info', 1, 0, 0, '', '', '', 'Avail', '', '_bx_market_form_entry_input_delete_confirm_error', '', '', 1, 0),
('bx_market', 'bx_market', 'do_publish', '_bx_market_form_entry_input_do_publish', '', 0, 'submit', '_bx_market_form_entry_input_sys_do_publish', '', '', 0, 0, 0, '', '', '', '', '', '', '', '', 1, 0),
('bx_market', 'bx_market', 'do_submit', '_bx_market_form_entry_input_do_submit', '', 0, 'submit', '_bx_market_form_entry_input_sys_do_submit', '', '', 0, 0, 0, '', '', '', '', '', '', '', '', 1, 0),
('bx_market', 'bx_market', 'location', '', '', 0, 'custom', '_sys_form_input_sys_location', '', '', 0, 0, 0, '', '', '', '', '', '', '', '', 1, 0),
('bx_market', 'bx_market', 'pictures', '', '', 0, 'files', '_bx_market_form_entry_input_sys_pictures', '_bx_market_form_entry_input_pictures', '', 0, 0, 0, '', '', '', '', '', '', '', '', 1, 0),
('bx_market', 'bx_market', 'files', '', '', 0, 'files', '_bx_market_form_entry_input_sys_files', '_bx_market_form_entry_input_files', '', 0, 0, 0, '', '', '', '', '', '', '', '', 1, 0),
('bx_market', 'bx_market', 'text', '', '', 0, 'textarea', '_bx_market_form_entry_input_sys_text', '_bx_market_form_entry_input_text', '', 1, 0, 2, '', '', '', 'Avail', '', '_bx_market_form_entry_input_text_err', 'XssHtml', '', 1, 0),
('bx_market', 'bx_market', 'title', '', '', 0, 'text', '_bx_market_form_entry_input_sys_title', '_bx_market_form_entry_input_title', '', 1, 0, 0, '', '', '', 'Avail', '', '_bx_market_form_entry_input_title_err', 'Xss', '', 1, 0),
('bx_market', 'bx_market', 'cat', '', '#!bx_market_cats', 0, 'select', '_bx_market_form_entry_input_sys_cat', '_bx_market_form_entry_input_cat', '', 1, 0, 0, '', '', '', 'avail', '', '_bx_market_form_entry_input_cat_err', 'Xss', '', 1, 0),
('bx_market', 'bx_market', 'price', '', '#!bx_market_prices', 0, 'radio_set', '_bx_market_form_entry_input_sys_price', '_bx_market_form_entry_input_price', '', 1, 0, 0, '', '', '', 'avail', '', '_bx_market_form_entry_input_price_err', 'Xss', '', 1, 0);

INSERT INTO `sys_form_display_inputs`(`display_name`, `input_name`, `visible_for_levels`, `active`, `order`) VALUES 
('bx_market_entry_add', 'delete_confirm', 2147483647, 0, 1),
('bx_market_entry_add', 'title', 2147483647, 1, 2),
('bx_market_entry_add', 'cat', 2147483647, 1, 3),
('bx_market_entry_add', 'text', 2147483647, 1, 4),
('bx_market_entry_add', 'pictures', 2147483647, 1, 5),
('bx_market_entry_add', 'files', 2147483647, 1, 6),
('bx_market_entry_add', 'price', 2147483647, 1, 7),
('bx_market_entry_add', 'allow_view_to', 2147483647, 1, 8),
('bx_market_entry_add', 'location', 2147483647, 1, 9),
('bx_market_entry_add', 'do_submit', 2147483647, 0, 10),
('bx_market_entry_add', 'do_publish', 2147483647, 1, 11),
('bx_market_entry_delete', 'location', 2147483647, 0, 0),
('bx_market_entry_delete', 'cat', 2147483647, 0, 0),
('bx_market_entry_delete', 'price', 2147483647, 0, 0),
('bx_market_entry_delete', 'pictures', 2147483647, 0, 0),
('bx_market_entry_delete', 'files', 2147483647, 0, 0),
('bx_market_entry_delete', 'text', 2147483647, 0, 0),
('bx_market_entry_delete', 'do_publish', 2147483647, 0, 0),
('bx_market_entry_delete', 'title', 2147483647, 0, 0),
('bx_market_entry_delete', 'allow_view_to', 2147483647, 0, 0),
('bx_market_entry_delete', 'delete_confirm', 2147483647, 1, 1),
('bx_market_entry_delete', 'do_submit', 2147483647, 1, 2),
('bx_market_entry_edit', 'do_publish', 2147483647, 0, 1),
('bx_market_entry_edit', 'delete_confirm', 2147483647, 0, 2),
('bx_market_entry_edit', 'title', 2147483647, 1, 3),
('bx_market_entry_edit', 'cat', 2147483647, 1, 4),
('bx_market_entry_edit', 'text', 2147483647, 1, 5),
('bx_market_entry_edit', 'pictures', 2147483647, 1, 6),
('bx_market_entry_edit', 'files', 2147483647, 1, 7),
('bx_market_entry_edit', 'price', 2147483647, 1, 8),
('bx_market_entry_edit', 'allow_view_to', 2147483647, 1, 9),
('bx_market_entry_edit', 'location', 2147483647, 1, 10),
('bx_market_entry_edit', 'do_submit', 2147483647, 1, 11),
('bx_market_entry_view', 'location', 2147483647, 0, 0),
('bx_market_entry_view', 'cat', 2147483647, 0, 0),
('bx_market_entry_view', 'price', 2147483647, 0, 0),
('bx_market_entry_view', 'pictures', 2147483647, 0, 0),
('bx_market_entry_view', 'files', 2147483647, 0, 0),
('bx_market_entry_view', 'delete_confirm', 2147483647, 0, 0),
('bx_market_entry_view', 'text', 2147483647, 1, 0),
('bx_market_entry_view', 'do_publish', 2147483647, 0, 0),
('bx_market_entry_view', 'title', 2147483647, 0, 0),
('bx_market_entry_view', 'do_submit', 2147483647, 0, 0),
('bx_market_entry_view', 'allow_view_to', 2147483647, 0, 0);

-- PRE-VALUES
INSERT INTO `sys_form_pre_lists`(`key`, `title`, `module`, `use_for_sets`) VALUES
('bx_market_cats', '_bx_market_pre_lists_cats', 'bx_market', '0'),
('bx_market_prices', '_bx_market_pre_lists_prices', 'bx_market', '0');

INSERT INTO `sys_form_pre_values`(`Key`, `Value`, `Order`, `LKey`, `LKey2`) VALUES
('bx_market_cats', '', 0, '_sys_please_select', ''),
('bx_market_cats', '1', 1, '_bx_market_cat_administration', ''),
('bx_market_cats', '2', 2, '_bx_market_cat_adult', ''),
('bx_market_cats', '3', 3, '_bx_market_cat_advertisement', ''),
('bx_market_cats', '4', 4, '_bx_market_cat_affiliates', ''),
('bx_market_cats', '5', 5, '_bx_market_cat_authentication', ''),
('bx_market_cats', '6', 6, '_bx_market_cat_calendars', ''),
('bx_market_cats', '7', 7, '_bx_market_cat_communication', ''),
('bx_market_cats', '8', 8, '_bx_market_cat_content', ''),
('bx_market_cats', '9', 9, '_bx_market_cat_conversion', ''),
('bx_market_cats', '10', 10, '_bx_market_cat_core_changes', ''),
('bx_market_cats', '11', 11, '_bx_market_cat_dating', ''),
('bx_market_cats', '12', 12, '_bx_market_cat_documentation', ''),
('bx_market_cats', '13', 13, '_bx_market_cat_ecommerce', ''),
('bx_market_cats', '14', 14, '_bx_market_cat_events', ''),
('bx_market_cats', '15', 15, '_bx_market_cat_feedback', ''),
('bx_market_cats', '16', 16, '_bx_market_cat_flash', ''),
('bx_market_cats', '17', 17, '_bx_market_cat_games', ''),
('bx_market_cats', '18', 18, '_bx_market_cat_graphics', ''),
('bx_market_cats', '19', 19, '_bx_market_cat_hosting', ''),
('bx_market_cats', '20', 20, '_bx_market_cat_integrations', ''),
('bx_market_cats', '21', 21, '_bx_market_cat_location', ''),
('bx_market_cats', '22', 22, '_bx_market_cat_management', ''),
('bx_market_cats', '23', 23, '_bx_market_cat_mobile', ''),
('bx_market_cats', '24', 24, '_bx_market_cat_multimedia', ''),
('bx_market_cats', '25', 25, '_bx_market_cat_music', ''),
('bx_market_cats', '26', 26, '_bx_market_cat_navigation', ''),
('bx_market_cats', '27', 27, '_bx_market_cat_other', ''),
('bx_market_cats', '28', 28, '_bx_market_cat_performance', ''),
('bx_market_cats', '29', 29, '_bx_market_cat_photos', ''),
('bx_market_cats', '30', 30, '_bx_market_cat_search', ''),
('bx_market_cats', '31', 31, '_bx_market_cat_security', ''),
('bx_market_cats', '32', 32, '_bx_market_cat_services', ''),
('bx_market_cats', '33', 33, '_bx_market_cat_social', ''),
('bx_market_cats', '34', 34, '_bx_market_cat_spam_prevention', ''),
('bx_market_cats', '35', 35, '_bx_market_cat_statistics', ''),
('bx_market_cats', '36', 36, '_bx_market_cat_templates', ''),
('bx_market_cats', '37', 37, '_bx_market_cat_tools', ''),
('bx_market_cats', '38', 38, '_bx_market_cat_translations', ''),
('bx_market_cats', '39', 39, '_bx_market_cat_video', ''),

('bx_market_prices', '1', 1, '_bx_market_cat_price_1', ''),
('bx_market_prices', '2', 2, '_bx_market_cat_price_2', ''),
('bx_market_prices', '3', 3, '_bx_market_cat_price_3', ''),
('bx_market_prices', '4', 4, '_bx_market_cat_price_4', ''),
('bx_market_prices', '5', 5, '_bx_market_cat_price_5', '');

-- COMMENTS
INSERT INTO `sys_objects_cmts` (`Name`, `Table`, `CharsPostMin`, `CharsPostMax`, `CharsDisplayMax`, `Nl2br`, `PerView`, `PerViewReplies`, `BrowseType`, `IsBrowseSwitch`, `PostFormPosition`, `NumberOfLevels`, `IsDisplaySwitch`, `IsRatable`, `ViewingThreshold`, `IsOn`, `RootStylePrefix`, `BaseUrl`, `ObjectVote`, `TriggerTable`, `TriggerFieldId`, `TriggerFieldAuthor`, `TriggerFieldTitle`, `TriggerFieldComments`, `ClassName`, `ClassFile`) VALUES
('bx_market', 'bx_market_cmts', 1, 5000, 1000, 1, 5, 3, 'tail', 1, 'bottom', 1, 1, 1, -3, 1, 'cmt', 'page.php?i=view-product&id={object_id}', '', 'bx_market_products', 'id', 'author', 'title', 'comments', '', '');

-- VOTES
INSERT INTO `sys_objects_vote` (`Name`, `TableMain`, `TableTrack`, `PostTimeout`, `MinValue`, `MaxValue`, `IsUndo`, `IsOn`, `TriggerTable`, `TriggerFieldId`, `TriggerFieldAuthor`, `TriggerFieldRate`, `TriggerFieldRateCount`, `ClassName`, `ClassFile`) VALUES 
('bx_market', 'bx_market_votes', 'bx_market_votes_track', '604800', '1', '1', '0', '1', 'bx_market_products', 'id', 'author', 'rate', 'votes', 'BxMarketVote', 'modules/boonex/market/classes/BxMarketVote.php');

-- REPORTS
INSERT INTO `sys_objects_report` (`name`, `table_main`, `table_track`, `is_on`, `base_url`, `trigger_table`, `trigger_field_id`, `trigger_field_author`, `trigger_field_count`, `class_name`, `class_file`) VALUES 
('bx_market', 'bx_market_reports', 'bx_market_reports_track', '1', 'page.php?i=view-product&id={object_id}', 'bx_market_products', 'id', 'author', 'reports', '', '');

-- VIEWS
INSERT INTO `sys_objects_view` (`name`, `table_track`, `period`, `is_on`, `trigger_table`, `trigger_field_id`, `trigger_field_count`, `class_name`, `class_file`) VALUES 
('bx_market', 'bx_market_views_track', '86400', '1', 'bx_market_products', 'id', 'views', '', '');

-- STUDIO: page & widget
INSERT INTO `sys_std_pages`(`index`, `name`, `header`, `caption`, `icon`) VALUES
(3, 'bx_market', '_bx_market', '_bx_market', 'bx_market@modules/boonex/market/|std-pi.png');
SET @iPageId = LAST_INSERT_ID();

SET @iParentPageId = (SELECT `id` FROM `sys_std_pages` WHERE `name` = 'home');
SET @iParentPageOrder = (SELECT MAX(`order`) FROM `sys_std_pages_widgets` WHERE `page_id` = @iParentPageId);
INSERT INTO `sys_std_widgets` (`page_id`, `module`, `url`, `click`, `icon`, `caption`, `cnt_notices`, `cnt_actions`) VALUES
(@iPageId, 'bx_market', '{url_studio}module.php?name=bx_market', '', 'bx_market@modules/boonex/market/|std-wi.png', '_bx_market', '', 'a:4:{s:6:"module";s:6:"system";s:6:"method";s:11:"get_actions";s:6:"params";a:0:{}s:5:"class";s:18:"TemplStudioModules";}');
INSERT INTO `sys_std_pages_widgets` (`page_id`, `widget_id`, `order`) VALUES
(@iParentPageId, LAST_INSERT_ID(), IF(ISNULL(@iParentPageOrder), 1, @iParentPageOrder + 1));