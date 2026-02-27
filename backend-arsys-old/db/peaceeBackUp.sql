/*
 Navicat MySQL Data Transfer

 Source Server         : peacee
 Source Server Type    : MySQL
 Source Server Version : 100338 (10.3.38-MariaDB-0ubuntu0.20.04.1)
 Source Host           : localhost:3306
 Source Schema         : peacee

 Target Server Type    : MySQL
 Target Server Version : 100338 (10.3.38-MariaDB-0ubuntu0.20.04.1)
 File Encoding         : 65001

 Date: 25/10/2024 05:21:43
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for access_keys
-- ----------------------------
DROP TABLE IF EXISTS `access_keys`;
CREATE TABLE `access_keys` (
  `access_key_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `context` varchar(40) NOT NULL,
  `key_hash` varchar(40) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `assoc_id` bigint(20) DEFAULT NULL,
  `expiry_date` datetime NOT NULL,
  PRIMARY KEY (`access_key_id`),
  KEY `access_keys_user_id` (`user_id`),
  KEY `access_keys_hash` (`key_hash`,`user_id`,`context`),
  CONSTRAINT `access_keys_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Access keys are used to provide pseudo-login functionality for security-minimal tasks. Passkeys can be emailed directly to users, who can use them for a limited time in lieu of standard username and password.';

-- ----------------------------
-- Records of access_keys
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for announcement_settings
-- ----------------------------
DROP TABLE IF EXISTS `announcement_settings`;
CREATE TABLE `announcement_settings` (
  `announcement_setting_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `announcement_id` bigint(20) NOT NULL,
  `locale` varchar(14) NOT NULL DEFAULT '',
  `setting_name` varchar(255) NOT NULL,
  `setting_value` mediumtext DEFAULT NULL,
  PRIMARY KEY (`announcement_setting_id`),
  UNIQUE KEY `announcement_settings_unique` (`announcement_id`,`locale`,`setting_name`),
  KEY `announcement_settings_announcement_id` (`announcement_id`),
  CONSTRAINT `announcement_settings_announcement_id_foreign` FOREIGN KEY (`announcement_id`) REFERENCES `announcements` (`announcement_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='More data about announcements, including localized properties like names and contents.';

-- ----------------------------
-- Records of announcement_settings
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for announcement_type_settings
-- ----------------------------
DROP TABLE IF EXISTS `announcement_type_settings`;
CREATE TABLE `announcement_type_settings` (
  `announcement_type_setting_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `type_id` bigint(20) NOT NULL,
  `locale` varchar(14) NOT NULL DEFAULT '',
  `setting_name` varchar(255) NOT NULL,
  `setting_value` mediumtext DEFAULT NULL,
  `setting_type` varchar(6) NOT NULL,
  PRIMARY KEY (`announcement_type_setting_id`),
  UNIQUE KEY `announcement_type_settings_unique` (`type_id`,`locale`,`setting_name`),
  KEY `announcement_type_settings_type_id` (`type_id`),
  CONSTRAINT `announcement_type_settings_type_id_foreign` FOREIGN KEY (`type_id`) REFERENCES `announcement_types` (`type_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='More data about announcement types, including localized properties like their names.';

-- ----------------------------
-- Records of announcement_type_settings
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for announcement_types
-- ----------------------------
DROP TABLE IF EXISTS `announcement_types`;
CREATE TABLE `announcement_types` (
  `type_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `context_id` bigint(20) NOT NULL,
  PRIMARY KEY (`type_id`),
  KEY `announcement_types_context_id` (`context_id`),
  CONSTRAINT `announcement_types_context_id_foreign` FOREIGN KEY (`context_id`) REFERENCES `journals` (`journal_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Announcement types allow for announcements to optionally be categorized.';

-- ----------------------------
-- Records of announcement_types
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for announcements
-- ----------------------------
DROP TABLE IF EXISTS `announcements`;
CREATE TABLE `announcements` (
  `announcement_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `assoc_type` smallint(6) DEFAULT NULL,
  `assoc_id` bigint(20) NOT NULL,
  `type_id` bigint(20) DEFAULT NULL,
  `date_expire` date DEFAULT NULL,
  `date_posted` datetime NOT NULL,
  PRIMARY KEY (`announcement_id`),
  KEY `announcements_type_id` (`type_id`),
  KEY `announcements_assoc` (`assoc_type`,`assoc_id`),
  CONSTRAINT `announcements_type_id_foreign` FOREIGN KEY (`type_id`) REFERENCES `announcement_types` (`type_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Announcements are messages that can be presented to users e.g. on the homepage.';

-- ----------------------------
-- Records of announcements
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for author_settings
-- ----------------------------
DROP TABLE IF EXISTS `author_settings`;
CREATE TABLE `author_settings` (
  `author_setting_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `author_id` bigint(20) NOT NULL,
  `locale` varchar(14) NOT NULL DEFAULT '',
  `setting_name` varchar(255) NOT NULL,
  `setting_value` mediumtext DEFAULT NULL,
  PRIMARY KEY (`author_setting_id`),
  UNIQUE KEY `author_settings_unique` (`author_id`,`locale`,`setting_name`),
  KEY `author_settings_author_id` (`author_id`),
  CONSTRAINT `author_settings_author_id` FOREIGN KEY (`author_id`) REFERENCES `authors` (`author_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='More data about authors, including localized properties such as their name and affiliation.';

-- ----------------------------
-- Records of author_settings
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for authors
-- ----------------------------
DROP TABLE IF EXISTS `authors`;
CREATE TABLE `authors` (
  `author_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `email` varchar(90) NOT NULL,
  `include_in_browse` smallint(6) NOT NULL DEFAULT 1,
  `publication_id` bigint(20) NOT NULL,
  `seq` double(8,2) NOT NULL DEFAULT 0.00,
  `user_group_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`author_id`),
  KEY `authors_user_group_id` (`user_group_id`),
  KEY `authors_publication_id` (`publication_id`),
  CONSTRAINT `authors_publication_id_foreign` FOREIGN KEY (`publication_id`) REFERENCES `publications` (`publication_id`) ON DELETE CASCADE,
  CONSTRAINT `authors_user_group_id_foreign` FOREIGN KEY (`user_group_id`) REFERENCES `user_groups` (`user_group_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='The authors of a publication.';

-- ----------------------------
-- Records of authors
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for categories
-- ----------------------------
DROP TABLE IF EXISTS `categories`;
CREATE TABLE `categories` (
  `category_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `context_id` bigint(20) NOT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `seq` bigint(20) DEFAULT NULL,
  `path` varchar(255) NOT NULL,
  `image` text DEFAULT NULL,
  PRIMARY KEY (`category_id`),
  UNIQUE KEY `category_path` (`context_id`,`path`),
  KEY `category_context_id` (`context_id`),
  KEY `category_context_parent_id` (`context_id`,`parent_id`),
  KEY `category_parent_id` (`parent_id`),
  CONSTRAINT `categories_context_id_foreign` FOREIGN KEY (`context_id`) REFERENCES `journals` (`journal_id`) ON DELETE CASCADE,
  CONSTRAINT `categories_parent_id_foreign` FOREIGN KEY (`parent_id`) REFERENCES `categories` (`category_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Categories permit the organization of submissions into a heirarchical structure.';

-- ----------------------------
-- Records of categories
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for category_settings
-- ----------------------------
DROP TABLE IF EXISTS `category_settings`;
CREATE TABLE `category_settings` (
  `category_setting_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `category_id` bigint(20) NOT NULL,
  `locale` varchar(14) NOT NULL DEFAULT '',
  `setting_name` varchar(255) NOT NULL,
  `setting_value` mediumtext DEFAULT NULL,
  PRIMARY KEY (`category_setting_id`),
  UNIQUE KEY `category_settings_unique` (`category_id`,`locale`,`setting_name`),
  KEY `category_settings_category_id` (`category_id`),
  CONSTRAINT `category_settings_category_id_foreign` FOREIGN KEY (`category_id`) REFERENCES `categories` (`category_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='More data about categories, including localized properties such as names.';

-- ----------------------------
-- Records of category_settings
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for citation_settings
-- ----------------------------
DROP TABLE IF EXISTS `citation_settings`;
CREATE TABLE `citation_settings` (
  `citation_setting_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `citation_id` bigint(20) NOT NULL,
  `locale` varchar(14) NOT NULL DEFAULT '',
  `setting_name` varchar(255) NOT NULL,
  `setting_value` mediumtext DEFAULT NULL,
  `setting_type` varchar(6) NOT NULL,
  PRIMARY KEY (`citation_setting_id`),
  UNIQUE KEY `citation_settings_unique` (`citation_id`,`locale`,`setting_name`),
  KEY `citation_settings_citation_id` (`citation_id`),
  CONSTRAINT `citation_settings_citation_id` FOREIGN KEY (`citation_id`) REFERENCES `citations` (`citation_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Additional data about citations, including localized content.';

-- ----------------------------
-- Records of citation_settings
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for citations
-- ----------------------------
DROP TABLE IF EXISTS `citations`;
CREATE TABLE `citations` (
  `citation_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `publication_id` bigint(20) NOT NULL,
  `raw_citation` text NOT NULL,
  `seq` bigint(20) NOT NULL DEFAULT 0,
  PRIMARY KEY (`citation_id`),
  UNIQUE KEY `citations_publication_seq` (`publication_id`,`seq`),
  KEY `citations_publication` (`publication_id`),
  CONSTRAINT `citations_publication` FOREIGN KEY (`publication_id`) REFERENCES `publications` (`publication_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='A citation made by an associated publication.';

-- ----------------------------
-- Records of citations
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for completed_payments
-- ----------------------------
DROP TABLE IF EXISTS `completed_payments`;
CREATE TABLE `completed_payments` (
  `completed_payment_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `timestamp` datetime NOT NULL,
  `payment_type` bigint(20) NOT NULL,
  `context_id` bigint(20) NOT NULL,
  `user_id` bigint(20) DEFAULT NULL,
  `assoc_id` bigint(20) DEFAULT NULL,
  `amount` double(8,2) NOT NULL,
  `currency_code_alpha` varchar(3) DEFAULT NULL,
  `payment_method_plugin_name` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`completed_payment_id`),
  KEY `completed_payments_context_id` (`context_id`),
  KEY `completed_payments_user_id` (`user_id`),
  CONSTRAINT `completed_payments_context_id` FOREIGN KEY (`context_id`) REFERENCES `journals` (`journal_id`) ON DELETE CASCADE,
  CONSTRAINT `completed_payments_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='A list of completed (fulfilled) payments relating to a payment type such as a subscription payment.';

-- ----------------------------
-- Records of completed_payments
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for controlled_vocab_entries
-- ----------------------------
DROP TABLE IF EXISTS `controlled_vocab_entries`;
CREATE TABLE `controlled_vocab_entries` (
  `controlled_vocab_entry_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `controlled_vocab_id` bigint(20) NOT NULL,
  `seq` double(8,2) DEFAULT NULL,
  PRIMARY KEY (`controlled_vocab_entry_id`),
  KEY `controlled_vocab_entries_controlled_vocab_id` (`controlled_vocab_id`),
  KEY `controlled_vocab_entries_cv_id` (`controlled_vocab_id`,`seq`),
  CONSTRAINT `controlled_vocab_entries_controlled_vocab_id_foreign` FOREIGN KEY (`controlled_vocab_id`) REFERENCES `controlled_vocabs` (`controlled_vocab_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='The order that a word or phrase used in a controlled vocabulary should appear. For example, the order of keywords in a publication.';

-- ----------------------------
-- Records of controlled_vocab_entries
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for controlled_vocab_entry_settings
-- ----------------------------
DROP TABLE IF EXISTS `controlled_vocab_entry_settings`;
CREATE TABLE `controlled_vocab_entry_settings` (
  `controlled_vocab_entry_setting_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `controlled_vocab_entry_id` bigint(20) NOT NULL,
  `locale` varchar(14) NOT NULL DEFAULT '',
  `setting_name` varchar(255) NOT NULL,
  `setting_value` mediumtext DEFAULT NULL,
  `setting_type` varchar(6) NOT NULL,
  PRIMARY KEY (`controlled_vocab_entry_setting_id`),
  UNIQUE KEY `c_v_e_s_pkey` (`controlled_vocab_entry_id`,`locale`,`setting_name`),
  KEY `c_v_e_s_entry_id` (`controlled_vocab_entry_id`),
  CONSTRAINT `c_v_e_s_entry_id` FOREIGN KEY (`controlled_vocab_entry_id`) REFERENCES `controlled_vocab_entries` (`controlled_vocab_entry_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='More data about a controlled vocabulary entry, including localized properties such as the actual word or phrase.';

-- ----------------------------
-- Records of controlled_vocab_entry_settings
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for controlled_vocabs
-- ----------------------------
DROP TABLE IF EXISTS `controlled_vocabs`;
CREATE TABLE `controlled_vocabs` (
  `controlled_vocab_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `symbolic` varchar(64) NOT NULL,
  `assoc_type` bigint(20) NOT NULL DEFAULT 0,
  `assoc_id` bigint(20) NOT NULL DEFAULT 0,
  PRIMARY KEY (`controlled_vocab_id`),
  UNIQUE KEY `controlled_vocab_symbolic` (`symbolic`,`assoc_type`,`assoc_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Every word or phrase used in a controlled vocabulary. Controlled vocabularies are used for submission metadata like keywords and subjects, reviewer interests, and wherever a similar dictionary of words or phrases is required. Each entry corresponds to a word or phrase like "cellular reproduction" and a type like "submissionKeyword".';

-- ----------------------------
-- Records of controlled_vocabs
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for custom_issue_orders
-- ----------------------------
DROP TABLE IF EXISTS `custom_issue_orders`;
CREATE TABLE `custom_issue_orders` (
  `custom_issue_order_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `issue_id` bigint(20) NOT NULL,
  `journal_id` bigint(20) NOT NULL,
  `seq` double(8,2) NOT NULL DEFAULT 0.00,
  PRIMARY KEY (`custom_issue_order_id`),
  UNIQUE KEY `custom_issue_orders_unique` (`issue_id`),
  KEY `custom_issue_orders_issue_id` (`issue_id`),
  KEY `custom_issue_orders_journal_id` (`journal_id`),
  CONSTRAINT `custom_issue_orders_issue_id` FOREIGN KEY (`issue_id`) REFERENCES `issues` (`issue_id`) ON DELETE CASCADE,
  CONSTRAINT `custom_issue_orders_journal_id` FOREIGN KEY (`journal_id`) REFERENCES `journals` (`journal_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Ordering information for the issue list, when custom issue ordering is specified.';

-- ----------------------------
-- Records of custom_issue_orders
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for custom_section_orders
-- ----------------------------
DROP TABLE IF EXISTS `custom_section_orders`;
CREATE TABLE `custom_section_orders` (
  `custom_section_order_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `issue_id` bigint(20) NOT NULL,
  `section_id` bigint(20) NOT NULL,
  `seq` double(8,2) NOT NULL DEFAULT 0.00,
  PRIMARY KEY (`custom_section_order_id`),
  UNIQUE KEY `custom_section_orders_unique` (`issue_id`,`section_id`),
  KEY `custom_section_orders_issue_id` (`issue_id`),
  KEY `custom_section_orders_section_id` (`section_id`),
  CONSTRAINT `custom_section_orders_issue_id` FOREIGN KEY (`issue_id`) REFERENCES `issues` (`issue_id`) ON DELETE CASCADE,
  CONSTRAINT `custom_section_orders_section_id` FOREIGN KEY (`section_id`) REFERENCES `sections` (`section_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Ordering information for sections within issues, when issue-specific section ordering is specified.';

-- ----------------------------
-- Records of custom_section_orders
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for data_object_tombstone_oai_set_objects
-- ----------------------------
DROP TABLE IF EXISTS `data_object_tombstone_oai_set_objects`;
CREATE TABLE `data_object_tombstone_oai_set_objects` (
  `object_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `tombstone_id` bigint(20) NOT NULL,
  `assoc_type` bigint(20) NOT NULL,
  `assoc_id` bigint(20) NOT NULL,
  PRIMARY KEY (`object_id`),
  KEY `data_object_tombstone_oai_set_objects_tombstone_id` (`tombstone_id`),
  CONSTRAINT `data_object_tombstone_oai_set_objects_tombstone_id` FOREIGN KEY (`tombstone_id`) REFERENCES `data_object_tombstones` (`tombstone_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Relationships between tombstones and other data that can be collected in OAI sets, e.g. sections.';

-- ----------------------------
-- Records of data_object_tombstone_oai_set_objects
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for data_object_tombstone_settings
-- ----------------------------
DROP TABLE IF EXISTS `data_object_tombstone_settings`;
CREATE TABLE `data_object_tombstone_settings` (
  `tombstone_setting_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `tombstone_id` bigint(20) NOT NULL,
  `locale` varchar(14) NOT NULL DEFAULT '',
  `setting_name` varchar(255) NOT NULL,
  `setting_value` mediumtext DEFAULT NULL,
  `setting_type` varchar(6) NOT NULL COMMENT '(bool|int|float|string|object)',
  PRIMARY KEY (`tombstone_setting_id`),
  UNIQUE KEY `data_object_tombstone_settings_unique` (`tombstone_id`,`locale`,`setting_name`),
  KEY `data_object_tombstone_settings_tombstone_id` (`tombstone_id`),
  CONSTRAINT `data_object_tombstone_settings_tombstone_id` FOREIGN KEY (`tombstone_id`) REFERENCES `data_object_tombstones` (`tombstone_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='More data about data object tombstones, including localized content.';

-- ----------------------------
-- Records of data_object_tombstone_settings
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for data_object_tombstones
-- ----------------------------
DROP TABLE IF EXISTS `data_object_tombstones`;
CREATE TABLE `data_object_tombstones` (
  `tombstone_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `data_object_id` bigint(20) NOT NULL,
  `date_deleted` datetime NOT NULL,
  `set_spec` varchar(255) NOT NULL,
  `set_name` varchar(255) NOT NULL,
  `oai_identifier` varchar(255) NOT NULL,
  PRIMARY KEY (`tombstone_id`),
  KEY `data_object_tombstones_data_object_id` (`data_object_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Entries for published data that has been removed. Usually used in the OAI endpoint.';

-- ----------------------------
-- Records of data_object_tombstones
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for doi_settings
-- ----------------------------
DROP TABLE IF EXISTS `doi_settings`;
CREATE TABLE `doi_settings` (
  `doi_setting_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `doi_id` bigint(20) NOT NULL,
  `locale` varchar(14) NOT NULL DEFAULT '',
  `setting_name` varchar(255) NOT NULL,
  `setting_value` mediumtext DEFAULT NULL,
  PRIMARY KEY (`doi_setting_id`),
  UNIQUE KEY `doi_settings_unique` (`doi_id`,`locale`,`setting_name`),
  KEY `doi_settings_doi_id` (`doi_id`),
  CONSTRAINT `doi_settings_doi_id_foreign` FOREIGN KEY (`doi_id`) REFERENCES `dois` (`doi_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='More data about DOIs, including the registration agency.';

-- ----------------------------
-- Records of doi_settings
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for dois
-- ----------------------------
DROP TABLE IF EXISTS `dois`;
CREATE TABLE `dois` (
  `doi_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `context_id` bigint(20) NOT NULL,
  `doi` varchar(255) NOT NULL,
  `status` smallint(6) NOT NULL DEFAULT 1,
  PRIMARY KEY (`doi_id`),
  KEY `dois_context_id` (`context_id`),
  CONSTRAINT `dois_context_id_foreign` FOREIGN KEY (`context_id`) REFERENCES `journals` (`journal_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Stores all DOIs used in the system.';

-- ----------------------------
-- Records of dois
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for edit_decisions
-- ----------------------------
DROP TABLE IF EXISTS `edit_decisions`;
CREATE TABLE `edit_decisions` (
  `edit_decision_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `submission_id` bigint(20) NOT NULL,
  `review_round_id` bigint(20) DEFAULT NULL,
  `stage_id` bigint(20) DEFAULT NULL,
  `round` smallint(6) DEFAULT NULL,
  `editor_id` bigint(20) NOT NULL,
  `decision` smallint(6) NOT NULL,
  `date_decided` datetime NOT NULL,
  PRIMARY KEY (`edit_decision_id`),
  KEY `edit_decisions_submission_id` (`submission_id`),
  KEY `edit_decisions_editor_id` (`editor_id`),
  KEY `edit_decisions_review_round_id` (`review_round_id`),
  CONSTRAINT `edit_decisions_editor_id` FOREIGN KEY (`editor_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  CONSTRAINT `edit_decisions_review_round_id_foreign` FOREIGN KEY (`review_round_id`) REFERENCES `review_rounds` (`review_round_id`) ON DELETE CASCADE,
  CONSTRAINT `edit_decisions_submission_id` FOREIGN KEY (`submission_id`) REFERENCES `submissions` (`submission_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Editorial decisions recorded on a submission, such as decisions to accept or decline the submission, as well as decisions to send for review, send to copyediting, request revisions, and more.';

-- ----------------------------
-- Records of edit_decisions
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for email_log
-- ----------------------------
DROP TABLE IF EXISTS `email_log`;
CREATE TABLE `email_log` (
  `log_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `assoc_type` bigint(20) NOT NULL,
  `assoc_id` bigint(20) NOT NULL,
  `sender_id` bigint(20) NOT NULL,
  `date_sent` datetime NOT NULL,
  `event_type` bigint(20) DEFAULT NULL,
  `from_address` varchar(255) DEFAULT NULL,
  `recipients` text DEFAULT NULL,
  `cc_recipients` text DEFAULT NULL,
  `bcc_recipients` text DEFAULT NULL,
  `subject` varchar(255) DEFAULT NULL,
  `body` text DEFAULT NULL,
  PRIMARY KEY (`log_id`),
  KEY `email_log_assoc` (`assoc_type`,`assoc_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='A record of email messages that are sent in relation to an associated entity, such as a submission.';

-- ----------------------------
-- Records of email_log
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for email_log_users
-- ----------------------------
DROP TABLE IF EXISTS `email_log_users`;
CREATE TABLE `email_log_users` (
  `email_log_user_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `email_log_id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  PRIMARY KEY (`email_log_user_id`),
  UNIQUE KEY `email_log_user_id` (`email_log_id`,`user_id`),
  KEY `email_log_users_email_log_id` (`email_log_id`),
  KEY `email_log_users_user_id` (`user_id`),
  CONSTRAINT `email_log_users_email_log_id_foreign` FOREIGN KEY (`email_log_id`) REFERENCES `email_log` (`log_id`) ON DELETE CASCADE,
  CONSTRAINT `email_log_users_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='A record of users associated with an email log entry.';

-- ----------------------------
-- Records of email_log_users
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for email_templates
-- ----------------------------
DROP TABLE IF EXISTS `email_templates`;
CREATE TABLE `email_templates` (
  `email_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `email_key` varchar(255) NOT NULL COMMENT 'Unique identifier for this email.',
  `context_id` bigint(20) NOT NULL,
  `alternate_to` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`email_id`),
  UNIQUE KEY `email_templates_email_key` (`email_key`,`context_id`),
  KEY `email_templates_context_id` (`context_id`),
  KEY `email_templates_alternate_to` (`alternate_to`),
  CONSTRAINT `email_templates_context_id_foreign` FOREIGN KEY (`context_id`) REFERENCES `journals` (`journal_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Custom email templates created by each context, and overrides of the default templates.';

-- ----------------------------
-- Records of email_templates
-- ----------------------------
BEGIN;
INSERT INTO `email_templates` (`email_id`, `email_key`, `context_id`, `alternate_to`) VALUES (1, 'COPYEDIT_REQUEST', 1, 'DISCUSSION_NOTIFICATION_COPYEDITING');
INSERT INTO `email_templates` (`email_id`, `email_key`, `context_id`, `alternate_to`) VALUES (2, 'EDITOR_ASSIGN_SUBMISSION', 1, 'DISCUSSION_NOTIFICATION_SUBMISSION');
INSERT INTO `email_templates` (`email_id`, `email_key`, `context_id`, `alternate_to`) VALUES (3, 'EDITOR_ASSIGN_REVIEW', 1, 'DISCUSSION_NOTIFICATION_REVIEW');
INSERT INTO `email_templates` (`email_id`, `email_key`, `context_id`, `alternate_to`) VALUES (4, 'EDITOR_ASSIGN_PRODUCTION', 1, 'DISCUSSION_NOTIFICATION_PRODUCTION');
INSERT INTO `email_templates` (`email_id`, `email_key`, `context_id`, `alternate_to`) VALUES (5, 'LAYOUT_REQUEST', 1, 'DISCUSSION_NOTIFICATION_PRODUCTION');
INSERT INTO `email_templates` (`email_id`, `email_key`, `context_id`, `alternate_to`) VALUES (6, 'LAYOUT_COMPLETE', 1, 'DISCUSSION_NOTIFICATION_PRODUCTION');
COMMIT;

-- ----------------------------
-- Table structure for email_templates_default_data
-- ----------------------------
DROP TABLE IF EXISTS `email_templates_default_data`;
CREATE TABLE `email_templates_default_data` (
  `email_templates_default_data_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `email_key` varchar(255) NOT NULL COMMENT 'Unique identifier for this email.',
  `locale` varchar(14) NOT NULL DEFAULT 'en',
  `name` varchar(255) NOT NULL,
  `subject` varchar(255) NOT NULL,
  `body` text DEFAULT NULL,
  PRIMARY KEY (`email_templates_default_data_id`),
  UNIQUE KEY `email_templates_default_data_unique` (`email_key`,`locale`)
) ENGINE=InnoDB AUTO_INCREMENT=139 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Default email templates created for every installed locale.';

-- ----------------------------
-- Records of email_templates_default_data
-- ----------------------------
BEGIN;
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (1, 'PASSWORD_RESET_CONFIRM', 'id', '', 'Konfirmasi Reset Sandi', 'Kami menerima permintaan reset sandi untuk akun Anda di website {$siteTitle}.<br />\n<br />\nJika Anda tidak merasa mengajukan permintaan ini, abaikan pesan ini dan sandi Anda tidak akan diubah. Jika Anda memang ingin melakukan reset sandi, klik tautan berikut ini.<br />\n<br />\nReset sandi saya: {$lostPasswordUrl}<br />\n<br />\n{$siteContactName}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (2, 'PASSWORD_RESET_CONFIRM', 'en', 'Password Reset Confirm', 'Password Reset Confirmation', 'We have received a request to reset your password for the {$siteTitle} web site.<br />\n<br />\nIf you did not make this request, please ignore this email and your password will not be changed. If you wish to reset your password, click on the below URL.<br />\n<br />\nReset my password: {$lostPasswordUrl}<br />\n<br />\n{$siteContactName}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (3, 'USER_REGISTER', 'id', '', 'Registrasi Jurnal', '{$recipientName}<br />\n<br />\nAnda sekarang telah terdaftar sebagai pengguna di {$journalName}. Kami sertakan nama pengguna dan sandi Anda di email ini, keduanya diperlukan untuk semua kegiatan melalui website jurnal ini. Anda dapat keluar dari daftar pengguna jurnal kapan saja dengan menghubungi kami.<br />\n<br />\nNama pengguna: {$recipientUsername}<br />\nSandi: {$password}<br />\n<br />\nTerimakasih,<br />\n{$signature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (4, 'USER_REGISTER', 'en', 'User Created', 'Journal Registration', '{$recipientName}<br />\n<br />\nYou have now been registered as a user with {$journalName}. We have included your username and password in this email, which are needed for all work with this journal through its website. At any point, you can ask to be removed from the journal\'s list of users by contacting me.<br />\n<br />\nUsername: {$recipientUsername}<br />\nPassword: {$password}<br />\n<br />\nThank you,<br />\n{$signature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (5, 'USER_VALIDATE_CONTEXT', 'id', 'validasi Email (Registrasi Jurnal)', 'Validasi Akun Anda', '{$recipientName}<br />\n<br />\nAnda telah membuat akun di {$journalName}. Sebelum dapat menggunakannya, Anda perlu melakukan validasi akun email. Untuk melakukannya, klik tautan berikut ini:<br />\n<br />\n{$activateUrl}<br />\n<br />\nTerimakasih,<br />\n{$journalSignature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (6, 'USER_VALIDATE_CONTEXT', 'en', 'Validate Email (Journal Registration)', 'Validate Your Account', '{$recipientName}<br />\n<br />\nYou have created an account with {$journalName}, but before you can start using it, you need to validate your email account. To do this, simply follow the link below:<br />\n<br />\n{$activateUrl}<br />\n<br />\nThank you,<br />\n{$journalSignature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (7, 'USER_VALIDATE_SITE', 'id', '', 'Validasi Akun Kamu', '{$recipientName}<br />\n<br />\nKamu berhasi membuat akun paaa {$siteTitle}, tapi sebelum bisa menggunakannya, validasi akun email kamu terlebih dahulu dengan mengikuti petunjuk pada tautan berikut:<br />\n<br />\n{$activateUrl}<br />\n<br />\nTerima kasih,<br />\n{$siteSignature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (8, 'USER_VALIDATE_SITE', 'en', 'Validate Email (Site)', 'Validate Your Account', '{$recipientName}<br />\n<br />\nYou have created an account with {$siteTitle}, but before you can start using it, you need to validate your email account. To do this, simply follow the link below:<br />\n<br />\n{$activateUrl}<br />\n<br />\nThank you,<br />\n{$siteSignature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (9, 'REVIEWER_REGISTER', 'id', '', 'Registrasi sebagai Reviewer di {$journalName}', '<p>Yth {$recipientName},</p><p>Dengan mempertimbangkan keahlian Anda, kami memasukkan nama Anda dalam database reviewer di {$journalName}. THal ini tidak bersifat mengikat, hanya sekedar memudahkan kami untuk mengundang Anda untuk melakukan review terhadap suatu naskah. Ketika memperoleh undangan untuk melakukan review suatu naskah, Anda dapat melihat judul dan abstrak naskah tersebut, dan Anda berhak menentukan apakah akan menerima atau menolak undangan tersebut. Anda juga dapat meminta nama Anda dihapus dari daftar reviewer.</p><p>Kami menyertakan nama pengguna dan sandi Anda, yang digunakan dalam semua interaksi dengan jurnal melalui website. Anda dapat melakukan update profil, termasuk minat review Anda.</p><p>Username: {$recipientUsername}<br />Password: {$password}</p><p>Terima kasih,</p>{$signature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (10, 'REVIEWER_REGISTER', 'en', 'Reviewer Register', 'Registration as Reviewer with {$journalName}', '<p>Dear {$recipientName},</p><p>In light of your expertise, we have registered your name in the reviewer database for {$journalName}. This does not entail any form of commitment on your part, but simply enables us to approach you with a submission to possibly review. On being invited to review, you will have an opportunity to see the title and abstract of the paper in question, and you\'ll always be in a position to accept or decline the invitation. You can also ask at any point to have your name removed from this reviewer list.</p><p>We are providing you with a username and password, which is used in all interactions with the journal through its website. You may wish, for example, to update your profile, including your reviewing interests.</p><p>Username: {$recipientUsername}<br />Password: {$password}</p><p>Thank you,</p>{$signature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (11, 'ISSUE_PUBLISH_NOTIFY', 'id', 'Notifikasi Terbitan', 'Terbitan baru telah tersedia: {$issueIdentification} dari {$journalName}', '<p>Pembaca yang Budiman,</p><p>Kami dengan senang hati mengumumkan terbitan <a href=\"{$issueUrl}\">{$issueIdentification}</a> dari {$journalName}. Kami mengundang Anda untuk membaca dan membagikan terbitan ini kepada komunitas akademik Anda.</p><p>Terima kasih banyak kepada para penulis, mitra bestari, dan atas kontribusinya yang tak ternilai, dan kepada pembaca kami atas minatnya.</p><p>Salam hormat,</p>{$signature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (12, 'ISSUE_PUBLISH_NOTIFY', 'en', 'Issue Published Notify', 'Just published: {$issueIdentification} of {$journalName}', '<p>Dear {$recipientName},</p><p>We are pleased to announce the publication of <a href=\"{$issueUrl}\">{$issueIdentification}</a> of {$journalName}.  We invite you to read and share this work with your scholarly community.</p><p>Many thanks to our authors, reviewers, and editors for their valuable contributions, and to our readers for your continued interest.</p><p>Thank you,</p>{$signature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (13, 'SUBMISSION_ACK', 'id', '', 'Terima kasih atas naskah yang Anda kirimkan ke {$journalName}', '{$recipientName}:<br />\n<br />\nTerimakasih telah menyerahkan naskah, &quot;{$submissionTitle}&quot; ke {$journalName}. Dengan sistem manajemenn jurnal online yang kami gunakan, Anda dapat memantau kemajuan proses editorial naskah Anda melalui:<br />\n<br />\nURL Naskah: {$submissionUrl}<br />\nNama pengguna: {$recipientUsername}<br />\n<br />\nJika ada pertanyaan, silakan hubungi kami. Terimakasih telah mempercayakan publikasi karya Anda di jurnal kami.<br />\n<br />\n{$journalSignature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (14, 'SUBMISSION_ACK', 'en', 'Submission Confirmation', 'Thank you for your submission to {$journalName}', '<p>Dear {$recipientName},</p><p>Thank you for your submission to {$journalName}. We have received your submission, {$submissionTitle}, and a member of our editorial team will see it soon. You will be sent an email when an initial decision is made, and we may contact you for further information.</p><p>You can view your submission and track its progress through the editorial process at the following location:</p><p>Submission URL: {$authorSubmissionUrl}</p><p>If you have been logged out, you can login again with the username {$recipientUsername}.</p><p>If you have any questions, please contact me from your <a href=\"{$authorSubmissionUrl}\">submission dashboard</a>.</p><p>Thank you for considering {$journalName} as a venue for your work.</p>{$journalSignature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (15, 'SUBMISSION_ACK_NOT_USER', 'id', '', 'Konfirmasi pengiriman naskah', '<p>Yth {$recipientName},</p><p>Nama Anda ditulis sebagai co-author pada nasakah {$journalName}. Pengirim, {$submitterName}, memberikan rincian berikut:</p><p>{$submissionTitle}<br>{$authorsWithAffiliation}</p><p>Jika ada kekeliruan, atau tidak ingin nama Anda tercantum dalam naskah, silakan hubungi saya.</p><p>Terima kasih atas pertimbangannya memilih jurnal ini untuk menerbitkan karya Anda.</p><p>Salam Hormat,</p>{$journalSignature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (16, 'SUBMISSION_ACK_NOT_USER', 'en', 'Submission Confirmation (Other Authors)', 'Submission confirmation', '<p>Dear {$recipientName},</p><p>You have been named as a co-author on a submission to {$journalName}. The submitter, {$submitterName}, provided the following details:</p><p>{$submissionTitle}<br>{$authorsWithAffiliation}</p><p>If any of these details are incorrect, or you do not wish to be named on this submission, please contact me.</p><p>Thank you for considering {$journalName} as a venue for your work.</p><p>Kind regards,</p>{$journalSignature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (17, 'EDITOR_ASSIGN', 'id', '', 'Anda telah ditugaskan sebagai editor untuk naskah pada {$journalName}', '<p>Yth. {$recipientName},</p><p>Naskah berikut telah ditugaskan kepada Anda untuk diperiksa melalui proses editorial.</p><p><a href=\"{$submissionUrl}\">{$submissionTitle}</a><br />{$authors}</p><p><b>Abstract</b></p>{$submissionAbstract}<p>Jika telah sesuai dengan {$journalName}, lanjutkan naskah tersebut ke tahap dengan memilih \"Kirim ke Taha Review\" lalu tugaskan seorang mitra bestari dengan mengklik \"Tambahkan Mitra Bestari\".</p><p>Jika tidak sesuai dengan ketentuan jurnal, silakan naskah ditolak.</p><p>Terima kasih.</p><p>Salam hormat,</p>{$journalSignature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (18, 'EDITOR_ASSIGN', 'en', 'Editor Assigned', 'You have been assigned as an editor on a submission to {$journalName}', '<p>Dear {$recipientName},</p><p>The following submission has been assigned to you to see through the editorial process.</p><p><a href=\"{$submissionUrl}\">{$submissionTitle}</a><br />{$authors}</p><p><b>Abstract</b></p>{$submissionAbstract}<p>If you find the submission to be relevant for {$journalName}, please forward the submission to the review stage by selecting \"Send to Review\" and then assign reviewers by clicking \"Add Reviewer\".</p><p>If the submission is not appropriate for this journal, please decline the submission.</p><p>Thank you in advance.</p><p>Kind regards,</p>{$journalSignature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (19, 'REVIEW_CANCEL', 'id', '', 'Permohonan Review Dibatalkan', '<p>Yth {$recipientName},</p><p>Kami memutuskan untuk membatalkan permohonan review kami kepada Anda untuk naskah {$submissionTitle} pada {$journalName}.</p><p> Kami mohon maaf sebesar-besarnya untuk ketidaknyamanan ini dan kami harap di masa mendatang Anda dapat membantu proses review di jurnal ini.</p><p>Jika ada pertanyaan, silakan hubungi kami.</p>{$signature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (20, 'REVIEW_CANCEL', 'en', 'Reviewer Unassign', 'Request for Review Cancelled', '<p>Dear {$recipientName},</p><p>Recently, we asked you to review a submission to {$journalName}. We have decided to cancel the request for you to reivew the submission, {$submissionTitle}.</p><p>We apologize any inconvenience this may cause you and hope that we will be able to call on you to assist with this journal\'s review process in the future.</p><p>If you have any questions, please contact me.</p>{$signature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (21, 'REVIEW_REINSTATE', 'id', '', 'Bersediakah Anda mereview lagi pada {$journalName}?', '<p>Yang terhotmat {$recipientName}:</p><p>Kami membatalkan permintaan review kepada Anda untuk menelaah naskah, {$submissionTitle}, untuk {$journalName}. Kami mengubah keputusan dan kami berharap Anda tetap dapat membantu proses review jurnal kami.</p><p>Jika Anda bisa membantu review naskah ini, Anda bisa <a href=\"{$reviewAssignmentUrl}\">login ke jurnal</a> untuk mereview naskah, unggah hasil review, dan mengirim permintaan review Anda.</p><p>Jika ada pertanyaan, silakan hubungi saya.</p><p>Salam Hormat,</p>{$signature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (22, 'REVIEW_REINSTATE', 'en', 'Reviewer Reinstate', 'Can you still review something for {$journalName}?', '<p>Dear {$recipientName},</p><p>We recently cancelled our request for you to review a submission, {$submissionTitle}, for {$journalName}. We\'ve reversed that decision and we hope that you are still able to conduct the review.</p><p>If you are able to assist with this submission\'s review, you can <a href=\"{$reviewAssignmentUrl}\">login to the journal</a> to view the submission, upload review files, and submit your review request.</p><p>If you have any questions, please contact me.</p><p>Kind regards,</p>{$signature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (23, 'REVIEW_RESEND_REQUEST', 'id', '', '', '');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (24, 'REVIEW_RESEND_REQUEST', 'en', 'Resend Review Request to Reviewer', 'Requesting your review again for {$journalName}', '<p>Dear {$recipientName},</p><p>Recently, you declined our request to review a submission, {$submissionTitle}, for {$journalName}. I\'m writing to see if you are able to conduct the review after all.</p><p>We would be grateful if you\'re able to perform this review, but we understand if that is not possible at this time. Either way, please <a href=\"{$reviewAssignmentUrl}\">accept or decline the request</a> by {$responseDueDate}, so that we can find an alternate reviewer.<p>If you have any questions, please contact me.</p><p>Kind regards,</p>{$signature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (25, 'REVIEW_REQUEST', 'id', '', 'Undangan mereview', '<p>Yth. {$recipientName},</p><p>Kami memandang bahwa Anda merupakan reviewer yang tepat untuk naskah {$journalName}. Abstrak dan judul naskah tersebut disertakan di bawah ini, dan kami berharap Anda berkenan melakukannya.</p><p>Jika Anda berkenan mereview naskah ini, batas waktu yang ditentapkan adalah {$reviewDueDate}. Silakan login ke web jurnal untuk melihat, mengunggah file review, dan mengirimkan hasil telaah Anda dan ikuti langkah pada tautan berikut.</p><p><a href=\"{$reviewAssignmentUrl}\">{$submissionTitle}</a></p><p><b>Abstrak</b></p>{$submissionAbstract}<p>Silakan merespon dengan memilih <a href=\"{$reviewAssignmentUrl}\">menerima atau menolak</a> permintaan review sebelum <b>{$responseDueDate}</b></p><p>Silakan hubungi saya bila ada pertanyaan terkait naskah atau proses review.</p><p>Terima kasih telah mempertimbangkan permintaan kami. Bantuan Anda sangat berharga bagi Kami.</p><p>Salam hormat,</p>{$signature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (26, 'REVIEW_REQUEST', 'en', 'Review Request', 'Invitation to review', '<p>Dear {$recipientName},</p><p>I believe that you would serve as an excellent reviewer for a submission  to {$journalName}. The submission\'s title and abstract are below, and I hope that you will consider undertaking this important task for us.</p><p>If you are able to review this submission, your review is due by {$reviewDueDate}. You can view the submission, upload review files, and submit your review by logging into the journal site and following the steps at the link below.</p><p><a href=\"{$reviewAssignmentUrl}\">{$submissionTitle}</a></p><p><b>Abstract</b></p>{$submissionAbstract}<p>Please <a href=\"{$reviewAssignmentUrl}\">accept or decline</a> the review by <b>{$responseDueDate}</b>.</p><p>You may contact me with any questions about the submission or the review process.</p><p>Thank you for considering this request. Your help is much appreciated.</p><p>Kind regards,</p>{$signature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (27, 'REVIEW_REQUEST_SUBSEQUENT', 'id', '', 'Permintaan untuk mereview naskah hasil revisi', '<p>Yang terhormat {$recipientName},</p><p>Terima kasih telah mereview <a href=\"{$reviewAssignmentUrl}\">{$submissionTitle}</a>. Penulis telah mempertimbangkan saran mitra bestari dan saat ini telah mengirimkan versi revisi naskahnya. Kami menghubungi untuk menanyakan apakah Anda bersedia mereview pada putaran kedua untuk naskah ini.</p><p>Jika bersedia, batas waktu review berakhir sebelum {$reviewDueDate}. Anda dapat <a href=\"{$reviewAssignmentUrl}\">mengikuti tahapan review</a> untuk melihat naskah, mengunggah file review, dan mengirimkan komentar Anda.<p><p><a href=\"{$reviewAssignmentUrl }\"{$submissionTitle}</a></p><p>Abstrak</p>{$submissionAbstract}<p>Harap terima atau tolak permintaan review sebelum {$responseDueDate}.</p><p>Jangan sungkan menghubungi saya jika ada pertanyaan terkait naskah atau proses review.</p><p>Terima kasih telah mempertimbangkan permintaan kami. Bantuan Anda sangat berharga bagi kami.</p><p>Hormat kami,</p>{$signature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (28, 'REVIEW_REQUEST_SUBSEQUENT', 'en', 'Review Request Subsequent', 'Request to review a revised submission', '<p>Dear {$recipientName},</p><p>Thank you for your review of <a href=\"{$reviewAssignmentUrl}\">{$submissionTitle}</a>. The authors have considered the reviewers\' feedback and have now submitted a revised version of their work. I\'m writing to ask if you would conduct a second round of peer review for this submission.</p><p>If you are able to review this submission, your review is due by {$reviewDueDate}. You can <a href=\"{$reviewAssignmentUrl}\">follow the review steps</a> to view the submission, upload review files, and submit your review comments.<p><p><a href=\"{$reviewAssignmentUrl}\">{$submissionTitle}</a></p><p><b>Abstract</b></p>{$submissionAbstract}<p>Please <a href=\"{$reviewAssignmentUrl}\">accept or decline</a> the review by <b>{$responseDueDate}</b>.</p><p>Please feel free to contact me with any questions about the submission or the review process.</p><p>Thank you for considering this request. Your help is much appreciated.</p><p>Kind regards,</p>{$signature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (29, 'REVIEW_RESPONSE_OVERDUE_AUTO', 'id', '', 'Apakah Anda bersedia mereview naskah ini?', '<p>Yth {$recipientName},</p><p>Email pengingat otomatis ini dari {$journalName} merujuk pada permintaan review naskah, \"{$submissionTitle}.\"</p><p>Anda menerima email ini karena kami belum menerima konfirmasi yang menunjukkan apakah Anda bersedia mereview naskah tersebut.</p><p>Kami menunggu jawaban apakah Anda dapat mereview atau tidak menggunakan software pengelolaan naskah dengan menerima atau menolak permintaan review ini.</p><p>Jika bersedia, tenggat waktu reviewnya adalah {$reviewDueDate}. Silakan ikuti tahap review untuk melihat naskah, unggah file review, dan kirim komentar review Anda.</p><p>{$submissionTitle}</p><p><b>Abstrak</b></p>{$submissionAbstract}<p>Jangan sungkan menghubungi saya bial ada pertanyaan tentant naskah atau proses review.</p><p>Terima kasih telah mempertimbangkan permintaan kami. Terima kasih banyak atas bantuan Anda.</p><p>Salam hormat,</p>{$journalSignature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (30, 'REVIEW_RESPONSE_OVERDUE_AUTO', 'en', 'Review Response Overdue (Automated)', 'Will you be able to review this for us?', '<p>Dear {$recipientName},</p><p>This email is an automated reminder from {$journalName} in regards to our request for your review of the submission, \"{$submissionTitle}.\"</p><p>You are receiving this email because we have not yet received a confirmation from you indicating whether or not you are able to undertake the review of this submission.</p><p>Please let us know whether or not you are able to undertake this review by using our submission management software to accept or decline this request.</p><p>If you are able to review this submission, your review is due by {$reviewDueDate}. You can follow the review steps to view the submission, upload review files, and submit your review comments.</p><p><a href=\"{$reviewAssignmentUrl}\">{$submissionTitle}</a></p><p><b>Abstract</b></p>{$submissionAbstract}<p>Please feel free to contact me with any questions about the submission or the review process.</p><p>Thank you for considering this request. Your help is much appreciated.</p><p>Kind regards,</p>{$journalSignature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (31, 'REVIEW_CONFIRM', 'id', '', 'Dapat Melakukan Review', 'Editor:<br />\n<br />\nSaya dapat dan bersedia melakukan review terhadap naskah, &quot;{$submissionTitle},&quot; untuk {$journalName}. Terimakasih telah mempercayakan kepada saya, dan saya berencana untuk menyelesaikan review ini sesuai tenggat, {$reviewDueDate}, atau sebelumnya.<br />\n<br />\n{$senderName}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (32, 'REVIEW_CONFIRM', 'en', 'Review Confirm', 'Review accepted: {$reviewerName} accepted review assignment for #{$submissionId} {$authorsShort} — {$submissionTitle}', '<p>Dear {$recipientName},</p><p>{$reviewerName} has accepted the following review:</p><p><a href=\"{$submissionUrl}\">#{$submissionId} {$authorsShort} — {$submissionTitle}</a><br /><b>Type:</b> {$reviewMethod}</p><b>Review Due:</b> {$reviewDueDate}</p><p>Login to <a href=\"{$submissionUrl}\">view all reviewer assignments</a> for this submission.</p><br><br>—<br>This is an automated message from <a href=\"{$journalUrl}\">{$journalName}</a>.');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (33, 'REVIEW_DECLINE', 'id', '', 'Tidak Dapat Melakukan Review', 'Editor:<br />\n<br />\nMohon maaf saat ini saya tidak dapat melakukan review terhadap naskah, &quot;{$submissionTitle},&quot; untuk {$journalName}. Terimakasih telah mempercayakann kepada saya, dan lain waktu silakan menghubungi saya lagi.<br />\n<br />\n{$senderName}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (34, 'REVIEW_DECLINE', 'en', 'Review Decline', 'Unable to Review', 'Editors:<br />\n<br />\nI am afraid that at this time I am unable to review the submission, &quot;{$submissionTitle},&quot; for {$journalName}. Thank you for thinking of me, and another time feel free to call on me.<br />\n<br />\n{$senderName}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (35, 'REVIEW_ACK', 'id', '', 'Ucapan Terimakasih atas Review Artikel', '{$recipientName}:<br />\n<br />\nTerimakasih telah menyelesaikan review terhadap naskah, &quot;{$submissionTitle},&quot; untuk {$journalName}. Kami sangat menghargai kontribusi Anda terhadap kualitas karya yang kami publikasikan.');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (36, 'REVIEW_ACK', 'en', 'Review Acknowledgement', 'Thank you for your review', '<p>Dear {$recipientName},</p>\n<p>Thank you for completing your review of the submission, {$submissionTitle}, for {$journalName}. We appreciate your time and expertise in contributing to the quality of the work that we publish.</p>\n<p>It has been a pleasure to work with you as a reviewer for {$journalName}, and we hope to have the opportunity to work with you again in the future.</p>\n<p>Kind regards,</p>\n<p>{$signature}</p>');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (37, 'REVIEW_REMIND', 'id', '', 'Pengingat untuk menyelesaikan tugas review Anda', '<p> Yth {$recipientName},</p><p>Sekedar mengingatkan tentang permohonan kami untuk melakukan review terhadap naskah, \"{$submissionTitle},\" untuk {$journalName}. Kami mengharapkan telah menerima review ini pada {$reviewDueDate}, dan akan sangat berbahagia bila Anda dapat menyelesaikannya.</p><p>Silakan <a href=\"{$reviewAssignmentUrl}\">login ke jurnal</a> dan ikuti petunjuk review untuk melihat naskah, mengunggah file review, serta mengirim komentar review.</p><p>Jika butuh tambahan waktu, silakan hubungi saya. Kami menunggu tanggapan Anda.</p><p>Terima kasih atas perhatian Anda dan salam hormat,</p>{$signature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (38, 'REVIEW_REMIND', 'en', 'Review Reminder', 'A reminder to please complete your review', '<p>Dear {$recipientName},</p><p>Just a gentle reminder of our request for your review of the submission, \"{$submissionTitle},\" for {$journalName}. We were expecting to have this review by {$reviewDueDate} and we would be pleased to receive it as soon as you are able to prepare it.</p><p>You can <a href=\"{$reviewAssignmentUrl}\">login to the journal</a> and follow the review steps to view the submission, upload review files, and submit your review comments.</p><p>If you need an extension of the deadline, please contact me. I look forward to hearing from you.</p><p>Thank you in advance and kind regards,</p>{$signature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (39, 'REVIEW_REMIND_AUTO', 'id', '', 'Pengingat untuk menyelesaikan review Anda', '<p>Yth {$recipientName}:</p><p>Sekedar mengingatkan tentang permohonan kami untuk melakukan review terhadap naskah, \"{$submissionTitle}\" untuk {$journalName}. </p><p>Kami mengharapkan telah menerima review ini pada {$reviewDueDate} dan kami berterima kasih bila dapat menyelesaikannya lebih awal.</p><p>Silakan <a href=\"{$reviewAssignmentUrl}\">login ke jurnal</a> dan ikuti tahapan untuk melihat naskah, mengunggah file review, dan mwnambahkana komentar review.</p><p>Jika Anda membutuhkan tambahan waktu, silakan hubungi saya. Kami menunggu kabar dari Anda.</p><p>Terima kasih dan salam hormat,</p>{$journalSignature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (40, 'REVIEW_REMIND_AUTO', 'en', 'Review Reminder (Automated)', 'A reminder to please complete your review', '<p>Dear {$recipientName}:</p><p>This email is an automated reminder from {$journalName} in regards to our request for your review of the submission, \"{$submissionTitle}.\"</p><p>We were expecting to have this review by {$reviewDueDate} and we would be pleased to receive it as soon as you are able to prepare it.</p><p>Please <a href=\"{$reviewAssignmentUrl}\">login to the journal</a> and follow the review steps to view the submission, upload review files, and submit your review comments.</p><p>If you need an extension of the deadline, please contact me. I look forward to hearing from you.</p><p>Thank you in advance and kind regards,</p>{$journalSignature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (41, 'REVIEW_COMPLETE', 'id', '', '', '');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (42, 'REVIEW_COMPLETE', 'en', 'Review Completed', 'Review complete: {$reviewerName} recommends {$reviewRecommendation} for #{$submissionId} {$authorsShort} — {$submissionTitle}', '<p>Dear {$recipientName},</p><p>{$reviewerName} completed the following review:</p><p><a href=\"{$submissionUrl}\">#{$submissionId} {$authorsShort} — {$submissionTitle}</a><br /><b>Recommendation:</b> {$reviewRecommendation}<br /><b>Type:</b> {$reviewMethod}</p><p>Login to <a href=\"{$submissionUrl}\">view all files and comments</a> provided by this reviewer.</p>');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (43, 'REVIEW_EDIT', 'id', '', '', '');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (44, 'REVIEW_EDIT', 'en', 'Review Edited', 'Your review assignment has been changed for {$journalName}', '<p>Dear {$recipientName},</p><p>An editor has made changes to your review assignment for {$journalName}. Please review the details below and let us know if you have any questions.</p><p><a href=\"{$reviewAssignmentUrl}\">{$submissionTitle}</a><br /><b>Type:</b> {$reviewMethod}<br /><b>Accept or Decline By:</b> {$responseDueDate}<br /><b>Submit Review By:</b> {$reviewDueDate}</p><p>You can login to <a href=\"{$reviewAssignmentUrl}\">complete this review</a> at any time.</p>');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (45, 'EDITOR_DECISION_ACCEPT', 'id', '', 'Naskah Anda telah diterima pada {$journalName}', '<p>Yang terhormat {$recipientName},</p><p>Dengan senang hati saya informasikan bahwa kami telah memutuskan untuk menerima naskha Anda tanpa revisi lebih lanjut. Setelah review matang, kami memutuskan bahwa naskah Anda, {$submissionTitle}, memenuhi atau melebihi harapan kami. Kami sangat senang untuk menerbitkan artikel Anda di {$journalName} dan kami berterima kasih telah memilih jurnal kami sebagai tempat untuk karya Anda.</p><p>Naskah Anda sedang masuk edisi forthcoming dalam edisi {$journalName} dan Anda dipersilakan untuk memasukkannya ke dalam daftar publikasi Anda. Kami menghargai kerja keras untuk setiap karya dan mengucapkan selamat kepada Anda karena telah mencapai tahap ini.</p><p>Artikel Anda sedang dalam tahap pengeditan dan pemformatan salinan agas siap diterbitkan.</p><p >Anda akan segera menerima petunjuk lebih lanjut.</p><p>Jika memiliki pertanyaan, silakan hubungi saya melalui <a href=\"{$authorSubmissionUrl}\">dashbord naskah</a> Anda.</p><p >Hormat kami,</p>{$signature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (46, 'EDITOR_DECISION_ACCEPT', 'en', 'Submission Accepted', 'Your submission has been accepted to {$journalName}', '<p>Dear {$recipientName},</p><p>I am pleased to inform you that we have decided to accept your submission without further revision. After careful review, we found your submission, {$submissionTitle}, to meet or exceed our expectations. We are excited to publish your piece in {$journalName} and we thank you for choosing our journal as a venue for your work.</p><p>Your submission is now forthcoming in a future issue of {$journalName} and you are welcome to include it in your list of publications. We recognize the hard work that goes into every successful submission and we want to congratulate you on reaching this stage.</p><p>Your submission will now undergo copy editing and formatting to prepare it for publication.</p><p>You will shortly receive further instructions.</p><p>If you have any questions, please contact me from your <a href=\"{$authorSubmissionUrl}\">submission dashboard</a>.</p><p>Kind regards,</p>{$signature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (47, 'EDITOR_DECISION_SEND_TO_EXTERNAL', 'id', '', 'Keputusan Editor', '{$authors}:<br />\n<br />\nKami telah membuat keputusan terkait naskah yang Anda kirimkan ke {$journalName}, &quot;{$submissionTitle}&quot;.<br />\n<br />\nKeputusan kami adalah: Dikirimkan ke Reviewer Eksternal<br />\n<br />\nURL Naskah: {$submissionUrl}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (48, 'EDITOR_DECISION_SEND_TO_EXTERNAL', 'en', 'Sent to Review', 'Your submission has been sent for review', '<p>Dear {$recipientName},</p><p>I am pleased to inform you that an editor has reviewed your submission, {$submissionTitle}, and has decided to send it for peer review. An editor will identify qualified reviewers who will provide feedback on your submission.</p><p>{$reviewTypeDescription} You will hear from us with feedback from the reviewers and information about the next steps.</p><p>Please note that sending the submission to peer review does not guarantee that it will be published. We will consider the reviewers\' recommendations before deciding to accept the submission for publication. You may be asked to make revisions and respond to the reviewers\' comments before a final decision is made.</p><p>If you have any questions, please contact me from your submission dashboard.</p><p>{$signature}</p>');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (49, 'EDITOR_DECISION_SEND_TO_PRODUCTION', 'id', '', 'Tahap berikutnya menerbitkan naskah Anda', '{$authors}:<br />\n<br />\nProses editing naskah Anda, &quot;{$submissionTitle},&quot; telah selesai.  Kami sekarang mengirimkannya ke produksi.<br />\n<br />\nURL Naskah: {$submissionUrl}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (50, 'EDITOR_DECISION_SEND_TO_PRODUCTION', 'en', 'Sent to Production', 'Next steps for publishing your submission', '<p>Dear {$recipientName},</p><p>I am writing from {$journalName} to let you know that the editing of your submission, {$submissionTitle}, is complete. Your submission will now advance to the production stage, where the final galleys will be prepared for publication. We will contact you if we need any further assistance.</p><p>If you have any questions, please contact me from your <a href=\"{$authorSubmissionUrl}\">submission dashboard</a>.</p><p>Kind regards,</p>{$signature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (51, 'EDITOR_DECISION_REVISIONS', 'id', '', 'Naskah Anda telah direview dan kami menyarankan untuk segera mengirimkan revisinya', '{$authors}:<br />\n<br />\nKami telah membuat keputusan terkait naskah yang Anda kirimkan ke {$journalName}, &quot;{$submissionTitle}&quot;.<br />\n<br />\nKeputusan kami adalah: Perlu Revisi');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (52, 'EDITOR_DECISION_REVISIONS', 'en', 'Revisions Requested', 'Your submission has been reviewed and we encourage you to submit revisions', '<p>Dear {$recipientName},</p><p>Your submission {$submissionTitle} has been reviewed and we would like to encourage you to submit revisions that address the reviewers\' comments. An editor will review these revisions and if they address the concerns adequately, your submission may be accepted for publication.</p><p>The reviewers\' comments are included at the bottom of this email. Please respond to each point in the reviewers\' comments and identify what changes you have made. If you find any of the reviewer\'s comments to be unjustified or inappropriate, please explain your perspective.</p><p>When you have completed your revisions, you can upload revised documents along with your response to the reviewers\' comments at your <a href=\"{$authorSubmissionUrl}\">submission dashboard</a>. If you have been logged out, you can login again with the username {$recipientUsername}.</p><p>If you have any questions, please contact me from your <a href=\"{$authorSubmissionUrl}\">submission dashboard</a>.</p><p>We look forward to receiving your revised submission.</p><p>Kind regards,</p>{$signature}<hr><p>The following comments were received from reviewers.</p>{$allReviewerComments}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (53, 'EDITOR_DECISION_RESUBMIT', 'id', '', 'Naskah Anda telah direview - silakan revisi dan kirim ulang', '{$authors}:<br />\n<br />\nKami telah membuat keputusan terkait naskah yang Anda kirimkan ke {$journalName}, &quot;{$submissionTitle}&quot;.<br />\n<br />\nKeputusan kami adalah: Kirim Ulang untuk Review');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (54, 'EDITOR_DECISION_RESUBMIT', 'en', 'Resubmit for Review', 'Your submission has been reviewed - please revise and resubmit', '<p>Dear {$recipientName},</p><p>After reviewing your submission, {$submissionTitle}, the reviewers have recommended that your submission cannot be accepted for publication in its current form. However, we would like to encourage you to submit a revised version that addresses the reviewers\' comments. Your revisions will be reviewed by an editor and may be sent out for another round of peer review.</p><p>Please note that resubmitting your work does not guarantee that it will be accepted.</p><p>The reviewers\' comments are included at the bottom of this email. Please respond to each point and identify what changes you have made. If you find any of the reviewer\'s comments inappropriate, please explain your perspective. If you have questions about the recommendations in your review, please include these in your response.</p><p>When you have completed your revisions, you can upload revised documents along with your response to the reviewers\' comments <a href=\"{$authorSubmissionUrl}\">at your submission dashboard</a>. If you have been logged out, you can login again with the username {$recipientUsername}.</p><p>If you have any questions, please contact me from your <a href=\"{$authorSubmissionUrl}\">submission dashboard</a>.</p><p>We look forward to receiving your revised submission.</p><p>Kind regards,</p>{$signature}<hr><p>The following comments were received from reviewers.</p>{$allReviewerComments}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (55, 'EDITOR_DECISION_DECLINE', 'id', '', 'Naskah Anda ditolak', '{$authors}:<br />\n<br />\nKami telah membuat keputusan terkait naskah yang Anda kirimkan ke {$journalName}, &quot;{$submissionTitle}&quot;.<br />\n<br />\nKeputusan kami adalah: Naskah Ditolak');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (56, 'EDITOR_DECISION_DECLINE', 'en', 'Submission Declined', 'Your submission has been declined', '<p>Dear {$recipientName},</p><p>While we appreciate receiving your submission, we are unable to accept {$submissionTitle} for publication on the basis of the comments from reviewers.</p><p>The reviewers\' comments are included at the bottom of this email.</p><p>Thank you for submitting to {$journalName}. Although it is disappointing to have a submission declined, I hope you find the reviewers\' comments to be constructive and helpful.</p><p>You are now free to submit the work elsewhere if you choose to do so.</p><p>Kind regards,</p>{$signature}<hr><p>The following comments were received from reviewers.</p>{$allReviewerComments}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (57, 'EDITOR_DECISION_INITIAL_DECLINE', 'id', '', 'Naskah Anda ditolak', '\n			{$authors}:<br />\n<br />\nKami telah sampai pada keputusan mengenai naskah Anda {$journalName}, &quot;{$submissionTitle}&quot;.<br />\n<br />\nKeputusannya adalah: Menolak Naskah');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (58, 'EDITOR_DECISION_INITIAL_DECLINE', 'en', 'Submission Declined (Pre-Review)', 'Your submission has been declined', '<p>Dear {$recipientName},</p><p>I’m sorry to inform you that, after reviewing your submission, {$submissionTitle}, the editor has found that it does not meet our requirements for publication in {$journalName}.</p><p>I wish you success if you consider submitting your work elsewhere.</p><p>Kind regards,</p>{$signature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (59, 'EDITOR_RECOMMENDATION', 'id', '', 'Rekomendasi Penyunting', '{$editors}:<br />\n<br />\nRekomendasi berkaitan dengan  naskah {$journalName}, &quot;{$submissionTitle}&quot; adalah: {$recommendation}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (60, 'EDITOR_RECOMMENDATION', 'en', 'Recommendation Made', 'Editor Recommendation', '<p>Dear {$recipientName},</p><p>After considering the reviewers\' feedback, I would like to make the following recommendation regarding the submission {$submissionTitle}.</p><p>My recommendation is: {$recommendation}.</p><p>Please visit the submission\'s <a href=\"{$submissionUrl}\">editorial workflow</a> to act on this recommendation.</p><p>Please feel free to contact me with any questions.</p><p>Kind regards,</p><p>{$senderName}</p>');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (61, 'EDITOR_DECISION_NOTIFY_OTHER_AUTHORS', 'id', '', '', '');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (62, 'EDITOR_DECISION_NOTIFY_OTHER_AUTHORS', 'en', 'Notify Other Authors', 'An update regarding your submission', '<p>The following email was sent to {$submittingAuthorName} from {$journalName} regarding {$submissionTitle}.</p>\n<p>You are receiving a copy of this notification because you are identified as an author of the submission. Any instructions in the message below are intended for the submitting author, {$submittingAuthorName}, and no action is required of you at this time.</p>\n\n{$messageToSubmittingAuthor}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (63, 'EDITOR_DECISION_NOTIFY_REVIEWERS', 'id', '', '', '');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (64, 'EDITOR_DECISION_NOTIFY_REVIEWERS', 'en', 'Notify Reviewers of Decision', 'Thank you for your review', '<p>Dear {$recipientName},</p>\n<p>Thank you for completing your review of the submission, {$submissionTitle}, for {$journalName}. We appreciate your time and expertise in contributing to the quality of the work that we publish. We have shared your comments with the authors, along with our other reviewers\' comments and the editor\'s decision.</p>\n<p>Based on the feedback we received, we have notified the authors of the following:</p>\n<p>{$decisionDescription}</p>\n<p>Your recommendation was considered alongside the recommendations of other reviewers before coming to a decision. Occasionally the editor\'s decision may differ from the recommendation made by one or more reviewers. The editor considers many factors, and does not take these decisions lightly. We are grateful for our reviewers\' expertise and suggestions.</p>\n<p>It has been a pleasure to work with you as a reviewer for {$journalName}, and we hope to have the opportunity to work with you again in the future.</p>\n<p>Kind regards,</p>\n<p>{$signature}</p>');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (65, 'EDITOR_DECISION_NEW_ROUND', 'id', '', '', '');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (66, 'EDITOR_DECISION_NEW_ROUND', 'en', 'New Review Round Initiated', 'Your submission has been sent for another round of review', '<p>Dear {$recipientName},</p>\n<p>Your revised submission, {$submissionTitle}, has been sent for a new round of peer review. \nYou will hear from us with feedback from the reviewers and information about the next steps.</p>\n<p>If you have any questions, please contact me from your <a href=\"{$authorSubmissionUrl}\">submission dashboard</a>.</p>\n<p>Kind regards,</p>\n<p>{$signature}</p>\n');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (67, 'EDITOR_DECISION_REVERT_DECLINE', 'id', '', '', '');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (68, 'EDITOR_DECISION_REVERT_DECLINE', 'en', 'Reinstate Declined Submission', 'We have reversed the decision to decline your submission', '<p>Dear {$recipientName},</p>\n<p>The decision to decline your submission, {$submissionTitle}, has been reversed. \nAn editor will complete the round of review and you will be notified when a \ndecision is made.</p>\n<p>Occasionally, a decision to decline a submission will be recorded accidentally in \nour system and must be reverted. I apologize for any confusion this may have caused.</p>\n<p>We will contact you if we need any further assistance.</p>\n<p>If you have any questions, please contact me from your <a href=\"{$authorSubmissionUrl}\">submission dashboard</a>.</p>\n<p>Kind regards,</p>\n<p>{$signature}</p>\n');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (69, 'EDITOR_DECISION_REVERT_INITIAL_DECLINE', 'id', '', '', '');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (70, 'EDITOR_DECISION_REVERT_INITIAL_DECLINE', 'en', 'Reinstate Submission Declined Without Review', 'We have reversed the decision to decline your submission', '<p>Dear {$recipientName},</p>\n<p>The decision to decline your submission, {$submissionTitle}, has been reversed. \nAn editor will look further at your submission before deciding whether to decline \nthe submission or send it for review.</p>\n<p>Occasionally, a decision to decline a submission will be recorded accidentally in \nour system and must be reverted. I apologize for any confusion this may have caused.</p>\n<p>We will contact you if we need any further assistance.</p>\n<p>If you have any questions, please contact me from your <a href=\"{$authorSubmissionUrl}\">submission dashboard</a>.</p>\n<p>Kind regards,</p>\n<p>{$signature}</p>\n');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (71, 'EDITOR_DECISION_SKIP_REVIEW', 'id', '', 'Naskah Anda telah dikirim untuk proses copyediting', '<p>Yth. {$recipientName},</p>\n<p>Dengan senang hati kami menginformasikan bahwa kami telah memutuskan menerima naskah Anda tanpa melalui proses review. Naskah Anda, {$submissionTitle}, telah memenuhi ketentuan jurnal, dan tidak perlu melewati proses tersebut. Kami senang menerbitkan karya Anda di {$journalName} dan terima kasih atas pilihan ANda memilih jurnal kami sebagai media publikasi karya Anda.</p>\nNaskah Anda sekarang berstatus Akan terbit papa nomor {$journalName} dan membolehkan anda menambahkannya ke dalam daftar publikasi Anda. Kami menghargai kerja keras yang telah berhasil diterima dan selamat atas pencapaian Anda.</p>\n<p>Naskah Anda selanjutnay akan melalui proses copy edit dan pengaturan format agar siap diterbitkan. </p>\n<p>Kami akan segera mengirimkan panduan lanjutan.</p>\n<p>Jika ada pertanyaan, silakan hubungi saya melalui <a href=\"{$authorSubmissionUrl}\">dashboar naskah</a> Anda.</p>\n<p>Hormat Kami,</p>\n<p>{$signature}</p>\n');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (72, 'EDITOR_DECISION_SKIP_REVIEW', 'en', 'Submission Accepted (Without Review)', 'Your submission has been sent for copyediting', '<p>Dear {$recipientName},</p>\n<p>I am pleased to inform you that we have decided to accept your submission without peer review. We found your submission, {$submissionTitle}, to meet our expectations, and we do not require that work of this type undergo peer review. We are excited to publish your piece in {$journalName} and we thank you for choosing our journal as a venue for your work.</p>\nYour submission is now forthcoming in a future issue of {$journalName} and you are welcome to include it in your list of publications. We recognize the hard work that goes into every successful submission and we want to congratulate you on your efforts.</p>\n<p>Your submission will now undergo copy editing and formatting to prepare it for publication. </p>\n<p>You will shortly receive further instructions.</p>\n<p>If you have any questions, please contact me from your <a href=\"{$authorSubmissionUrl}\">submission dashboard</a>.</p>\n<p>Kind regards,</p>\n<p>{$signature}</p>\n');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (73, 'EDITOR_DECISION_BACK_FROM_PRODUCTION', 'id', '', '', '');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (74, 'EDITOR_DECISION_BACK_FROM_PRODUCTION', 'en', 'Submission Sent Back to Copyediting', 'Your submission has been sent back to copyediting', '<p>Dear {$recipientName},</p><p>Your submission, {$submissionTitle}, has been sent back to the copyediting stage, where it will undergo further copyediting and formatting to prepare it for publication.</p><p>Occasionally, a submission is sent to the production stage before it is ready for the final galleys to be prepared for publication. Your submission is still forthcoming. I apologize for any confusion.</p><p>If you have any questions, please contact me from your <a href=\"{$authorSubmissionUrl}\">submission dashboard</a>.</p><p>We will contact you if we need any further assistance.</p><p>Kind regards,</p><p>{$signature}</p>');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (75, 'EDITOR_DECISION_BACK_FROM_COPYEDITING', 'id', '', '', '');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (76, 'EDITOR_DECISION_BACK_FROM_COPYEDITING', 'en', 'Submission Sent Back from Copyediting', 'Your submission has been sent back to review', '<p>Dear {$recipientName},</p><p>Your submission, {$submissionTitle}, has been sent back to the review stage. It will undergo further review before it can be accepted for publication.</p><p>Occasionally, a decision to accept a submission will be recorded accidentally in our system and we must send it back to review. I apologize for any confusion this has caused. We will work to complete any further review quickly so that you have a final decision as soon as possible.</p><p>We will contact you if we need any further assistance.</p><p>If you have any questions, please contact me from your <a href=\"{$authorSubmissionUrl}\">submission dashboard</a>.</p><p>Kind regards,</p><p>{$signature}</p>');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (77, 'EDITOR_DECISION_CANCEL_REVIEW_ROUND', 'id', '', '', '');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (78, 'EDITOR_DECISION_CANCEL_REVIEW_ROUND', 'en', 'Review Round Cancelled', 'A review round for your submission has been cancelled', '<p>Dear {$recipientName},</p><p>We recently opened a new review round for your submission, {$submissionTitle}. We are closing this review round now.</p><p>Occasionally, a decision to open a round of review will be recorded accidentally in our system and we must cancel this review round. I apologize for any confusion this may have caused.</p><p>We will contact you if we need any further assistance.</p><p>If you have any questions, please contact me from your <a href=\"{$authorSubmissionUrl}\">submission dashboard</a>.</p><p>Kind regards,</p><p>{$signature}</p>');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (79, 'SUBSCRIPTION_NOTIFY', 'id', 'Notifikasi berlangganan', 'Pemberitahuan Langganan', '{$recipientName}:<br />\n<br />\nAnda sekarang telah terdaftar sebagai pelanggan di sistem manajemen jurnal online kami, {$journalName}, dengan jenis langganan:<br />\n<br />\n{$subscriptionType}<br />\n<br />\nUntuk mengakses konten yang hanya tersedia bagi pelanggan, silakan login ke sistem dengan menggunakan nama pengguna Anda, &quot;{$recipientUsername}&quot;.<br />\n<br />\nSetelah login, Anda dapat mengubah detail profil Anda dan sandi Anda kapanpun Anda kehendaki.<br />\n<br />\nJika Anda memiliki langganan institusi, pengguna di institusi Anda tidak perlu login karena semua akses secara otomatis diotentikasi oleh sistem.<br />\n<br />\nJika ada pertanyaan, silakan hubungi kami.<br />\n<br />\n{$subscriptionSignature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (80, 'SUBSCRIPTION_NOTIFY', 'en', 'Subscription Notify', 'Subscription Notification', '{$recipientName}:<br />\n<br />\nYou have now been registered as a subscriber in our online journal management system for {$journalName}, with the following subscription:<br />\n<br />\n{$subscriptionType}<br />\n<br />\nTo access content that is available only to subscribers, simply log in to the system with your username, &quot;{$recipientUsername}&quot;.<br />\n<br />\nOnce you have logged in to the system you can change your profile details and password at any point.<br />\n<br />\nPlease note that if you have an institutional subscription, there is no need for users at your institution to log in, since requests for subscription content will be automatically authenticated by the system.<br />\n<br />\nIf you have any questions, please feel free to contact me.<br />\n<br />\n{$subscriptionSignature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (81, 'OPEN_ACCESS_NOTIFY', 'id', 'Notifikasi Akses Terbuka', 'Gratis dibaca: {$issueIdentification} of {$journalName} sudah akses terbuka sekarang', '<p>Yth {$recipientName},</p><p>Dengan senang hati kami informasikan bahwa <a href=\"{$issueUrl}\">{$issueIdentification}</a> dari {$journalName} telah menjadikan terbitan Open Access. Langganan tidak diperlukan lagi untuk membaca terbitan ini.</p><p>Terima kasih atas perhatiannya.</p>{$journalSignature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (82, 'OPEN_ACCESS_NOTIFY', 'en', 'Open Access Notify', 'Free to read: {$issueIdentification} of {$journalName} is now open access', '<p>Dear {$recipientName},</p><p>We are pleased to inform you that <a href=\"{$issueUrl}\">{$issueIdentification}</a> of {$journalName} is now available under open access.  A subscription is no longer required to read this issue.</p><p>Thank you for your continuing interest in our work.</p>{$journalSignature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (83, 'SUBSCRIPTION_BEFORE_EXPIRY', 'id', 'Langganan Akan Segera Habis', 'Pemberitahuan Tanggal Berakhir Langganan', '{$recipientName}:<br />\n<br />\nLangganan {$journalName} Anda hampir berakhir.<br />\n<br />\n{$subscriptionType}<br />\nTanggal berakhir: {$expiryDate}<br />\n<br />\nUntuk terus memperoleh akses ke jurnal ini, silakan kunjungi website jurnal dan perbaharui langganan. Anda dapat login menggunakan nama pengguna Anda, &quot;{$recipientUsername}&quot;.<br />\n<br />\nJika ada pertanyaan, silakan hubungi kami.<br />\n<br />\n{$subscriptionSignature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (84, 'SUBSCRIPTION_BEFORE_EXPIRY', 'en', 'Subscription Expires Soon', 'Notice of Subscription Expiry', '{$recipientName}:<br />\n<br />\nYour {$journalName} subscription is about to expire.<br />\n<br />\n{$subscriptionType}<br />\nExpiry date: {$expiryDate}<br />\n<br />\nTo ensure the continuity of your access to this journal, please go to the journal website and renew your subscription. You are able to log in to the system with your username, &quot;{$recipientUsername}&quot;.<br />\n<br />\nIf you have any questions, please feel free to contact me.<br />\n<br />\n{$subscriptionSignature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (85, 'SUBSCRIPTION_AFTER_EXPIRY', 'id', 'Langganan habis', 'Langganan Berakhir', '{$recipientName}:<br />\n<br />\nLangganan {$journalName} Anda telah berakhir.<br />\n<br />\n{$subscriptionType}<br />\nTanggal berakhir: {$expiryDate}<br />\n<br />\nUntuk memperbaharui langganan Anda, silakan kunjungi website jurnal. Anda dapat login dengan menggunakan nama pengguna Anda, &quot;{$recipientUsername}&quot;.<br />\n<br />\nJika ada pertanyaan, silakan hubungi kami.<br />\n<br />\n{$subscriptionSignature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (86, 'SUBSCRIPTION_AFTER_EXPIRY', 'en', 'Subscription Expired', 'Subscription Expired', '{$recipientName}:<br />\n<br />\nYour {$journalName} subscription has expired.<br />\n<br />\n{$subscriptionType}<br />\nExpiry date: {$expiryDate}<br />\n<br />\nTo renew your subscription, please go to the journal website. You are able to log in to the system with your username, &quot;{$recipientUsername}&quot;.<br />\n<br />\nIf you have any questions, please feel free to contact me.<br />\n<br />\n{$subscriptionSignature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (87, 'SUBSCRIPTION_AFTER_EXPIRY_LAST', 'id', 'Langganan habis terakhir', 'Langganan Berakhir - Pengingat Terakhir', '{$recipientName}:<br />\n<br />\nLangganan {$journalName} Anda telah berakhir.<br />\nIni adalah pengingat terakhir yang diemailkan kepada Anda.<br />\n<br />\n{$subscriptionType}<br />\nTanggal berakhir: {$expiryDate}<br />\n<br />\nUntuk memperbaharui langganan Anda, silakan kunjungi website jurnal. Anda dapat login dengan menggunakan nama pengguna Anda, &quot;{$recipientUsername}&quot;.<br />\n<br />\nJika ada pertanyaan, silakan hubungi kami.<br />\n<br />\n{$subscriptionSignature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (88, 'SUBSCRIPTION_AFTER_EXPIRY_LAST', 'en', 'Subscription Expired Last', 'Subscription Expired - Final Reminder', '{$recipientName}:<br />\n<br />\nYour {$journalName} subscription has expired.<br />\nPlease note that this is the final reminder that will be emailed to you.<br />\n<br />\n{$subscriptionType}<br />\nExpiry date: {$expiryDate}<br />\n<br />\nTo renew your subscription, please go to the journal website. You are able to log in to the system with your username, &quot;{$recipientUsername}&quot;.<br />\n<br />\nIf you have any questions, please feel free to contact me.<br />\n<br />\n{$subscriptionSignature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (89, 'SUBSCRIPTION_PURCHASE_INDL', 'id', 'Beli Langganan Individu', 'Pembelian Langganan: Individu', 'Sebuah langganan individu telah dibeli online untuk {$journalName} dengan rincian berikut.<br />\n<br />\nJenis Langganan:<br />\n{$subscriptionType}<br />\n<br />\nPengguna:<br />\n{$subscriberDetails}<br />\n<br />\nInformasi Keanggotaan (jika ada):<br />\n{$membership}<br />\n<br />\nUntuk melihat atau mengubah langganan ini, silakan gunakan URL berikut ini.<br />\n<br />\nURL Langganan: {$subscriptionUrl}<br />\n');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (90, 'SUBSCRIPTION_PURCHASE_INDL', 'en', 'Purchase Individual Subscription', 'Subscription Purchase: Individual', 'An individual subscription has been purchased online for {$journalName} with the following details.<br />\n<br />\nSubscription Type:<br />\n{$subscriptionType}<br />\n<br />\nUser:<br />\n{$subscriberDetails}<br />\n<br />\nMembership Information (if provided):<br />\n{$membership}<br />\n<br />\nTo view or edit this subscription, please use the following URL.<br />\n<br />\nSubscription URL: {$subscriptionUrl}<br />\n');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (91, 'SUBSCRIPTION_PURCHASE_INSTL', 'id', 'Berlangganan Institusi', 'Pembelian Langganan: Institusi', 'Sebuah langganan institusi telah dibeli online untuk {$journalName} dengan rincian berikut. Untuk mengaktifkan langganan ini, silakan gunakan URL Langganan dan jadikan status langganan ke \'Aktif\'.<br />\n<br />\nJenis Langganan:<br />\n{$subscriptionType}<br />\n<br />\nInstitusi:<br />\n{$institutionName}<br />\n{$institutionMailingAddress}<br />\n<br />\nDomain (jika ada):<br />\n{$domain}<br />\n<br />\nIP Ranges (jika ada):<br />\n{$ipRanges}<br />\n<br />\nContact Person:<br />\n{$subscriberDetails}<br />\n<br />\nInformasi Keanggotaan (jika ada):<br />\n{$membership}<br />\n<br />\nUntuk melihat atau mengubah langganan ini, silakan gunakan URL berikut ini.<br />\n<br />\nURL Langganan: {$subscriptionUrl}<br />\n');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (92, 'SUBSCRIPTION_PURCHASE_INSTL', 'en', 'Purchase Institutional Subscription', 'Subscription Purchase: Institutional', 'An institutional subscription has been purchased online for {$journalName} with the following details. To activate this subscription, please use the provided Subscription URL and set the subscription status to \'Active\'.<br />\n<br />\nSubscription Type:<br />\n{$subscriptionType}<br />\n<br />\nInstitution:<br />\n{$institutionName}<br />\n{$institutionMailingAddress}<br />\n<br />\nDomain (if provided):<br />\n{$domain}<br />\n<br />\nIP Ranges (if provided):<br />\n{$ipRanges}<br />\n<br />\nContact Person:<br />\n{$subscriberDetails}<br />\n<br />\nMembership Information (if provided):<br />\n{$membership}<br />\n<br />\nTo view or edit this subscription, please use the following URL.<br />\n<br />\nSubscription URL: {$subscriptionUrl}<br />\n');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (93, 'SUBSCRIPTION_RENEW_INDL', 'id', 'Perbaharui Langganan Individu', 'Pembaharuan Langganan: Individu', 'Sebuah langganan individu telah diperbaharui online untuk {$journalName} dengan rincian berikut.<br />\n<br />\nJenis Langganan:<br />\n{$subscriptionType}<br />\n<br />\nPengguna:<br />\n{$subscriberDetails}<br />\n<br />\nInformasi Keanggotaan (jika ada):<br />\n{$membership}<br />\n<br />\nUntuk melihat atau mengubah langganan ini, silakan gunakan URL berikut ini.<br />\n<br />\nURL Langganan: {$subscriptionUrl}<br />\n');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (94, 'SUBSCRIPTION_RENEW_INDL', 'en', 'Renew Individual Subscription', 'Subscription Renewal: Individual', 'An individual subscription has been renewed online for {$journalName} with the following details.<br />\n<br />\nSubscription Type:<br />\n{$subscriptionType}<br />\n<br />\nUser:<br />\n{$subscriberDetails}<br />\n<br />\nMembership Information (if provided):<br />\n{$membership}<br />\n<br />\nTo view or edit this subscription, please use the following URL.<br />\n<br />\nSubscription URL: {$subscriptionUrl}<br />\n');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (95, 'SUBSCRIPTION_RENEW_INSTL', 'id', 'Perbaharui Langganann Institusi', 'Pembaharuan Langganan: Institusi', 'Sebuah langganan institusi telah diperbaharui online untuk {$journalName} dengan rincian berikut.<br />\n<br />\nJenis Langganan:<br />\n{$subscriptionType}<br />\n<br />\nInstitusi:<br />\n{$institutionName}<br />\n{$institutionMailingAddress}<br />\n<br />\nDomain (jika ada):<br />\n{$domain}<br />\n<br />\nIP Ranges (jika ada):<br />\n{$ipRanges}<br />\n<br />\nContact Person:<br />\n{$subscriberDetails}<br />\n<br />\nInformasi Keanggotaan (jika ada):<br />\n{$membership}<br />\n<br />\nUntuk melihat atau mengubah langganan ini, silakan gunakan URL berikut ini.<br />\n<br />\nURL Langganan: {$subscriptionUrl}<br />\n');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (96, 'SUBSCRIPTION_RENEW_INSTL', 'en', 'Renew Institutional Subscription', 'Subscription Renewal: Institutional', 'An institutional subscription has been renewed online for {$journalName} with the following details.<br />\n<br />\nSubscription Type:<br />\n{$subscriptionType}<br />\n<br />\nInstitution:<br />\n{$institutionName}<br />\n{$institutionMailingAddress}<br />\n<br />\nDomain (if provided):<br />\n{$domain}<br />\n<br />\nIP Ranges (if provided):<br />\n{$ipRanges}<br />\n<br />\nContact Person:<br />\n{$subscriberDetails}<br />\n<br />\nMembership Information (if provided):<br />\n{$membership}<br />\n<br />\nTo view or edit this subscription, please use the following URL.<br />\n<br />\nSubscription URL: {$subscriptionUrl}<br />\n');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (97, 'REVISED_VERSION_NOTIFY', 'id', '', 'Versi Revisi telah Diunggah', '<p>Yth {$recipientName},</p><p>Penulis telah mengunggah revisi naskahnya, <b>{$authorsShort} — {$submissionTitle}</b>. <p>Sebagai.editorp, silakan login dan <a href=\"{$submissionUrl}\">periksa revisinya</a> dan ambil keputusan apakah menerima, menolak, atau kirim.naskah untuk direview lebih lanjut.</p><br><br>—<br>Ini pesan otomatis dari <a href=\"{$journalUrl}\">{$journalName}</a>.');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (98, 'REVISED_VERSION_NOTIFY', 'en', 'Revised Version Notification', 'Revised Version Uploaded', '<p>Dear {$recipientName},</p><p>The author has uploaded revisions for the submission, <b>{$authorsShort} — {$submissionTitle}</b>. <p>As an assigned editor, we ask that you login and <a href=\"{$submissionUrl}\">view the revisions</a> and make a decision to accept, decline or send the submission for further review.</p><br><br>—<br>This is an automated message from <a href=\"{$journalUrl}\">{$journalName}</a>.');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (99, 'STATISTICS_REPORT_NOTIFICATION', 'id', '', 'Kegiatan redaksi selama {$month}, {$year}', '\n{$recipientName}, <br />\n<br />\nLaporan kondisi jurnal Anda untuk {$month}, {$year} sudah tersedia. Statistik utama Anda bulan ini tersaji sebagai berikut.<br />\n<ul>\n	<li>Naskah baru yang masuk bulan ini: {$newSubmissions}</li>\n	<li>Naskah ditolak bulan ini: {$declinedSubmissions}</li>\n	<li>Naskah yang diterima bulan ini: {$acceptedSubmissions}</li>\n	<li>Total naskah dalam sistem: {$totalSubmissions}</li>\n</ul>\nSelengkapnya, login untuk melihat <a href=\"{$editorialStatsLink}\">kecenderungan editorial</a> dan <a href=\"{$publicationStatsLink}\">statistik artikel yang dipublikasikan</a>. Salinan lengkap trend bulan ini terlampir.<br />\n<br />\nSalam Hormat,<br />\n{$journalSignature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (100, 'STATISTICS_REPORT_NOTIFICATION', 'en', 'Statistics Report Notification', 'Editorial activity for {$month}, {$year}', '\n{$recipientName}, <br />\n<br />\nYour journal health report for {$month}, {$year} is now available. Your key stats for this month are below.<br />\n<ul>\n	<li>New submissions this month: {$newSubmissions}</li>\n	<li>Declined submissions this month: {$declinedSubmissions}</li>\n	<li>Accepted submissions this month: {$acceptedSubmissions}</li>\n	<li>Total submissions in the system: {$totalSubmissions}</li>\n</ul>\nLogin to the journal to view more detailed <a href=\"{$editorialStatsLink}\">editorial trends</a> and <a href=\"{$publicationStatsLink}\">published article stats</a>. A full copy of this month\'s editorial trends is attached.<br />\n<br />\nSincerely,<br />\n{$journalSignature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (101, 'ANNOUNCEMENT', 'id', '', '{$announcementTitle}', '<b>{$announcementTitle}</b><br />\n<br />\n{$announcementSummary}<br />\n<br />\nKunjungi website kami untuk melihat <a href=\"{$announcementUrl}\">pengumuman selengkapnya</a>.');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (102, 'ANNOUNCEMENT', 'en', 'New Announcement', '{$announcementTitle}', '<b>{$announcementTitle}</b><br />\n<br />\n{$announcementSummary}<br />\n<br />\nVisit our website to read the <a href=\"{$announcementUrl}\">full announcement</a>.');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (103, 'DISCUSSION_NOTIFICATION_SUBMISSION', 'id', '', 'Pesan terkait {$journalName}', 'Silakan tuliskan pesan Anda.');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (104, 'DISCUSSION_NOTIFICATION_SUBMISSION', 'en', 'Discussion (Submission)', 'A message regarding {$journalName}', 'Please enter your message.');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (105, 'DISCUSSION_NOTIFICATION_REVIEW', 'id', '', 'Pesan terkait {$journalName}', 'Silakan tuliskan pesan Anda.');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (106, 'DISCUSSION_NOTIFICATION_REVIEW', 'en', 'Discussion (Review)', 'A message regarding {$journalName}', 'Please enter your message.');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (107, 'DISCUSSION_NOTIFICATION_COPYEDITING', 'id', '', 'Pesan terkait {$journalName}', 'Silakan tuliskan pesan Anda.');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (108, 'DISCUSSION_NOTIFICATION_COPYEDITING', 'en', 'Discussion (Copyediting)', 'A message regarding {$journalName}', 'Please enter your message.');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (109, 'DISCUSSION_NOTIFICATION_PRODUCTION', 'id', '', 'Pesan terkait {$journalName}', 'Silakan tuliskan pesan Anda.');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (110, 'DISCUSSION_NOTIFICATION_PRODUCTION', 'en', 'Discussion (Production)', 'A message regarding {$journalName}', 'Please enter your message.');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (111, 'COPYEDIT_REQUEST', 'id', '', 'Naskah {$submissionId} siap masuk ke tahap copyedit untuk {$contextAcronym}', '{$recipientName}:<br />\n<br />\nKami meminta Anda melakukan copyediting terhadap &quot;{$submissionTitle}&quot; untuk {$journalName} mengikuti langkah-langkah berikut.<br />\n1. Klik URL Naskah di bawah.<br />\n2. Buka semua file yang ada di file Draft dan lakukan copyediting, tambahkan Diskusi Copyediting sesuai kebutuhan.<br />\n3. Simpan file yang telah di-copyedit, dan unggah ke panel Sudah Copyedit.<br />\n4. Beritahu Editor bahwa semua file telah siap, dan bahwa proses Produksi dapat dimulai.<br />\n<br />\n{$journalName} URL: {$journalUrl}<br />\nURL Naskah: {$submissionUrl}<br />\nNama pengguna: {$recipientUsername}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (112, 'COPYEDIT_REQUEST', 'en', 'Request Copyedit', 'Submission {$submissionId} is ready to be copyedited for {$contextAcronym}', '<p>Dear {$recipientName},</p><p>A new submission is ready to be copyedited:</p><p><a href\"{$submissionUrl}\">{$submissionId} — {$submissionTitle}</a><br />{$journalName}</p><p>Please follow these steps to complete this task:</p><ol><li>Click on the Submission URL below.</li><li>Open any files available under Draft Files and edit the files. Use the Copyediting Discussions area if you need to contact the editor(s) or author(s).</li><li>Save the copyedited file(s) and upload them to the Copyedited panel.</li><li>Use the Copyediting Discussions to notify the editor(s) that all files have been prepared, and that the Production process may begin.</li></ol><p>If you are unable to undertake this work at this time or have any questions, please contact me. Thank you for your contribution to {$journalName}.</p><p>Kind regards,</p>{$signature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (113, 'EDITOR_ASSIGN_SUBMISSION', 'id', '', 'Anda telah ditugaskan sebagai editor untuk naskah pada {$journalName}', '<p>Yth. {$recipientName},</p><p>Naskah berikut telah ditugaskan kepada Anda untuk diperiksa melalui proses editorial.</p><p><a href=\"{$submissionUrl}\">{$submissionTitle}</a><br />{$authors}</p><p><b>Abstract</b></p>{$submissionAbstract}<p>Jika telah sesuai dengan {$journalName}, lanjutkan naskah tersebut ke tahap dengan memilih \"Kirim ke Taha Review\" lalu tugaskan seorang mitra bestari dengan mengklik \"Tambahkan Mitra Bestari\".</p><p>Jika tidak sesuai dengan ketentuan jurnal, silakan naskah ditolak.</p><p>Terima kasih.</p><p>Salam hormat,</p>{$journalSignature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (114, 'EDITOR_ASSIGN_SUBMISSION', 'en', 'Assign Editor', 'You have been assigned as an editor on a submission to {$journalName}', '<p>Dear {$recipientName},</p><p>The following submission has been assigned to you to see through the editorial process.</p><p><a href=\"{$submissionUrl}\">{$submissionTitle}</a><br />{$authors}</p><p><b>Abstract</b></p>{$submissionAbstract}<p>If you find the submission to be relevant for {$journalName}, please forward the submission to the review stage by selecting \"Send to Review\" and then assign reviewers by clicking \"Add Reviewer\".</p><p>If the submission is not appropriate for this journal, please decline the submission.</p><p>Thank you in advance.</p><p>Kind regards,</p>{$journalSignature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (115, 'EDITOR_ASSIGN_REVIEW', 'id', '', 'Anda telah ditugaskan sebagai editor untuk naskah pada {$journalName}', '<p>Yth {$recipientName},</p><p>Naskah berikut telah ditugaskan kepada Anda untuk ditangani selama proses review.</p><p><a href=\"{$submissionUrl}\">{$submissionTitle}</a><br />{$authors}</p><p><b>Abstrak</b></p>{$submissionAbstract}<p>Silakan login untuk <a href=\"{$submissionUrl}\">melihat naskah</a> dan tugaskan mitra bestari yang sesuai kualifikasi. Anda bisa menugaskan seorang mitra bestari dengan mengklik \"Tambah Mitra Bestari\".</p><p>Terima kasih.</p><p>Salam Hormat,</p>{$signature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (116, 'EDITOR_ASSIGN_REVIEW', 'en', 'Assign Editor', 'You have been assigned as an editor on a submission to {$journalName}', '<p>Dear {$recipientName},</p><p>The following submission has been assigned to you to see through the peer review process.</p><p><a href=\"{$submissionUrl}\">{$submissionTitle}</a><br />{$authors}</p><p><b>Abstract</b></p>{$submissionAbstract}<p>Please login to <a href=\"{$submissionUrl}\">view the submission</a> and assign qualified reviewers. You can assign a reviewer by clicking \"Add Reviewer\".</p><p>Thank you in advance.</p><p>Kind regards,</p>{$signature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (117, 'EDITOR_ASSIGN_PRODUCTION', 'id', '', 'Anda telah ditugaskan sebagai editor untuk naskah pada {$journalName}', '<p>Yth {$recipientName},</p><p>Naskah berikut telah ditugaskan kepada Anda untuk ditangani selama tahap produksi.</p><p><a href=\"{$submissionUrl}\">{$submissionTitle}</a><br />{$authors}</p><p><b>Abstrak</b></p>{$submissionAbstract}<p>Silakan login untuk <a href=\"{$submissionUrl}\">melihat naskah</a>. Bila file produksi telah siap, silakan unggah ke bagian <strong>Publikasi > Galei</strong>. Selanjutnya jadwalkan naskah untuk diterbitkan dengan mengklik tombol <strong>Jadwalkan untuk Diterbitkan</strong>.</p><p>Terima kasih.</p><p>Salam Hormat,</p>{$signature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (118, 'EDITOR_ASSIGN_PRODUCTION', 'en', 'Assign Editor', 'You have been assigned as an editor on a submission to {$journalName}', '<p>Dear {$recipientName},</p><p>The following submission has been assigned to you to see through the production stage.</p><p><a href=\"{$submissionUrl}\">{$submissionTitle}</a><br />{$authors}</p><p><b>Abstract</b></p>{$submissionAbstract}<p>Please login to <a href=\"{$submissionUrl}\">view the submission</a>. Once production-ready files are available, upload them under the <strong>Publication > Galleys</strong> section. Then schedule the work for publication by clicking the <strong>Schedule for Publication</strong> button.</p><p>Thank you in advance.</p><p>Kind regards,</p>{$signature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (119, 'LAYOUT_REQUEST', 'id', '', 'Naskah {$submissionId} siap masuk ke tahap produksi pada {$contextAcronym}', '<p>Yth. {$recipientName},</p><p>Naskah baru telah siap proses layout editing:</p><p><a href=\"{$submissionUrl}\">{$submissionId} — {$submissionTitle}</a><br />{$journalName}</p><ol><li>Klik URL Naskah di atas.</li><li>Unduh file Siap Cetak dan gunakan untuk membuat galley sesuai aturan jurnal.</li><li>Unggah galley ke bagian Publikasi naskah.</li><li>Gunakan fitur Diskusi Produksi untuk memberitahu editor bahwa file galley sudah siap.</li></ol><p>Jika tidak bisa mengerjakan sekarang atau ada pertanyaan, silakan hubungi saya. Terima kasih atas kontribusinya kepada jurnal ini.</p><p>Salam hormat,</p>{$signature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (120, 'LAYOUT_REQUEST', 'en', 'Ready for Production', 'Submission {$submissionId} is ready for production at {$contextAcronym}', '<p>Dear {$recipientName},</p><p>A new submission is ready for layout editing:</p><p><a href=\"{$submissionUrl}\">{$submissionId} — {$submissionTitle}</a><br />{$journalName}</p><ol><li>Click on the Submission URL above.</li><li>Download the Production Ready files and use them to create the galleys according to the journal\'s standards.</li><li>Upload the galleys to the Publication section of the submission.</li><li>Use the  Production Discussions to notify the editor that the galleys are ready.</li></ol><p>If you are unable to undertake this work at this time or have any questions, please contact me. Thank you for your contribution to this journal.</p><p>Kind regards,</p>{$signature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (121, 'LAYOUT_COMPLETE', 'id', 'Galei Selesai', 'Galley Selesai', '<p>Yang terhormat {$recipientName},<p><p>Galai sedang dipersiapkan untuk artikel berikut dan siap untuk peninjauan akhir.</p><p><a href=\"{$submissionUrl}\">{ $submissionTitle}</a><br />{$journalName}</p><p>Jika Anda memiliki pertanyaan, silakan hubungi saya.</p><p>Hormat kami,</p><p>{ $senderName}</p>');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (122, 'LAYOUT_COMPLETE', 'en', 'Galleys Complete', 'Galleys Complete', '<p>Dear {$recipientName},</p><p>Galleys have now been prepared for the following submission and are ready for final review.</p><p><a href=\"{$submissionUrl}\">{$submissionTitle}</a><br />{$journalName}</p><p>If you have any questions, please contact me.</p><p>Kind regards,</p><p>{$signature}</p>');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (123, 'VERSION_CREATED', 'id', '', '', '');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (124, 'VERSION_CREATED', 'en', 'Version Created', 'A new version was created for {$submissionTitle}', '<p>Dear {$recipientName}, </p><p>This is an automated message to inform you that a new version of your submission, {$submissionTitle}, was created. You can view this version from your submission dashboard at the following link:</p><p><a href=\"{$submissionUrl}\">{$submissionTitle}</a></p><hr><p>This is an automatic email sent from <a href=\"{$journalUrl}\">{$journalName}</a>.</p>');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (125, 'EDITORIAL_REMINDER', 'id', '', '', '');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (126, 'EDITORIAL_REMINDER', 'en', 'Editorial Reminder', 'Outstanding editorial tasks for {$journalName}', '<p>Dear {$recipientName},</p><p>You are currently assigned to {$numberOfSubmissions} submissions in <a href=\"{$journalUrl}\">{$journalName}</a>. The following submissions are <b>waiting for your response</b>.</p>{$outstandingTasks}<p>View all of your assignments in your <a href=\"{$submissionsUrl}\">submission dashboard</a>.</p><p>If you have any questions about your assignments, please contact {$contactName} at {$contactEmail}.</p>');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (127, 'SUBMISSION_SAVED_FOR_LATER', 'id', '', '', '');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (128, 'SUBMISSION_SAVED_FOR_LATER', 'en', 'Submission Saved for Later', 'Resume your submission to {$journalName}', '<p>Dear {$recipientName},</p><p>Your submission details have been saved in our system, but it has not yet been submitted for consideration. You can return to complete your submission at any time by following the link below.</p><p><a href=\"{$submissionWizardUrl}\">{$authorsShort} — {$submissionTitle}</a></p><hr><p>This is an automated email from <a href=\"{$journalUrl}\">{$journalName}</a>.</p>');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (129, 'SUBMISSION_NEEDS_EDITOR', 'id', '', '', '');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (130, 'SUBMISSION_NEEDS_EDITOR', 'en', 'Submission Needs Editor', 'A new submission needs an editor to be assigned: {$submissionTitle}', '<p>Dear {$recipientName},</p><p>The following submission has been submitted and there is no editor assigned.</p><p><a href=\"{$submissionUrl}\">{$submissionTitle}</a><br />{$authors}</p><p><b>Abstract</b></p>{$submissionAbstract}<p>Please assign an editor who will be responsible for the submission by clicking the title above and assigning an editor under the Participants section.</p><hr><p>This is an automated email from <a href=\"{$journalUrl}\">{$journalName}</a>.</p>');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (131, 'PAYMENT_REQUEST_NOTIFICATION', 'id', 'Permintaan Pembayaran', 'Notifikasi Permintaan Pembayaran', '<p>Yth {$recipientName},</p><p>Selamat atas diterimanya naskah Anda, {$submissionTitle}, pada {$journalName}. Saat ini, naskah terlah diterima, kami meminta Anda untuk melakukan pembayaran biaya publikasi.</p><p>Biaya ini mencakup biaya produksi hingga publikasi. Untuk melakukan pembayaran, buka halaman <a href=\"{$queuedPaymentUrl}\">{$queuedPaymentUrl}</a>.</p><p>Jika ada pertanyaan, silakan buka <a href=\"{$submissionGuidelinesUrl}\">Panduan Naskah</a></p>');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (132, 'PAYMENT_REQUEST_NOTIFICATION', 'en', 'Payment Request', 'Payment Request Notification', '<p>Dear {$recipientName},</p><p>Congratulations on the acceptance of your submission, {$submissionTitle}, to {$journalName}. Now that your submission has been accepted, we would like to request payment of the publication fee.</p><p>This fee covers the production costs of bringing your submission to publication. To make the payment, please visit <a href=\"{$queuedPaymentUrl}\">{$queuedPaymentUrl}</a>.</p><p>If you have any questions, please see our <a href=\"{$submissionGuidelinesUrl}\">Submission Guidelines</a></p>');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (133, 'ORCID_COLLECT_AUTHOR_ID', 'id', '', 'ORCID Naskah', 'Yang Kami Hormati {$recipientName},<br/>\n<br/>\nAnda telah terdaftar sebagai penulis naskah{$journalName}.<br/>\nUntuk mengonfirmasi kepenulisan tersebut, tambahkanlah id ORCID Anda pada naskah tersebut dengan membuka tautan berikut ini.<br/>\n<br/>\n<a href=\"{$authorOrcidUrl}\"><img id=\"orcid-id-logo\" src=\"https://info.orcid.org/wp-content/uploads/2020/12/ORCIDiD_icon16x16.png\" width=\'16\' height=\'16\' alt=\"ORCID iD icon\" style=\"display: block; margin: 0 .5em 0 0; padding: 0; float: left;\"/>Register atau hubungkan iD ORCID Anda</a><br/>\n<br/>\n<br>\n<a href=\"{$orcidAboutUrl}\">Informasi selengkapnya tentang ORCID pada {$journalName}</a><br/>\n<br/>\nBila ada pertanyaan, silakan hubungi kami.<br/>\n<br/>\n{$principalContactSignature}<br/>\n');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (134, 'ORCID_COLLECT_AUTHOR_ID', 'en', 'orcidCollectAuthorId', 'Submission ORCID', 'Dear {$recipientName},<br/>\n<br/>\nYou have been listed as an author on a manuscript submission to {$journalName}.<br/>\nTo confirm your authorship, please add your ORCID id to this submission by visiting the link provided below.<br/>\n<br/>\n<a href=\"{$authorOrcidUrl}\"><img id=\"orcid-id-logo\" src=\"https://info.orcid.org/wp-content/uploads/2020/12/ORCIDiD_icon16x16.png\" width=\'16\' height=\'16\' alt=\"ORCID iD icon\" style=\"display: block; margin: 0 .5em 0 0; padding: 0; float: left;\"/>Register or connect your ORCID iD</a><br/>\n<br/>\n<br>\n<a href=\"{$orcidAboutUrl}\">More information about ORCID at {$journalName}</a><br/>\n<br/>\nIf you have any questions, please contact me.<br/>\n<br/>\n{$principalContactSignature}<br/>\n');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (135, 'ORCID_REQUEST_AUTHOR_AUTHORIZATION', 'id', '', 'Meminta akses rekaman ORCID', 'Yang Kami Hormati {$recipientName},<br/>\n<br/>\nAnda telah terdaftar sebagai penulis naskah{$journalName}.<br/>\nUntuk mengonfirmasi kepenulisan tersebut, tambahkanlah id ORCID Anda pada naskah tersebut dengan membuka tautan berikut ini.<br/>\n<br/>\n<a href=\"{$authorOrcidUrl}\"><img id=\"orcid-id-logo\" src=\"https://info.orcid.org/wp-content/uploads/2020/12/ORCIDiD_icon16x16.png\" width=\'16\' height=\'16\' alt=\"ORCID iD icon\" style=\"display: block; margin: 0 .5em 0 0; padding: 0; float: left;\"/>Register atau hubungkan iD ORCID Anda</a><br/>\n<br/>\n<br>\n<a href=\"{$orcidAboutUrl}\">Informasi selengkapnya tentang ORCID pada {$journalName}</a><br/>\n<br/>\nBila ada pertanyaan, silakan hubungi kami.<br/>\n<br/>\n{$principalContactSignature}<br/>\n');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (136, 'ORCID_REQUEST_AUTHOR_AUTHORIZATION', 'en', 'orcidRequestAuthorAuthorization', 'Requesting ORCID record access', 'Dear {$recipientName},<br>\n<br>\nYou have been listed as an author on the manuscript submission \"{$submissionTitle}\" to {$journalName}.\n<br>\n<br>\nPlease allow us to add your ORCID id to this submission and also to add the submission to your ORCID profile on publication.<br>\nVisit the link to the official ORCID website, login with your profile and authorize the access by following the instructions.<br>\n<a href=\"{$authorOrcidUrl}\"><img id=\"orcid-id-logo\" src=\"https://info.orcid.org/wp-content/uploads/2020/12/ORCIDiD_icon16x16.png\" width=\'16\' height=\'16\' alt=\"ORCID iD icon\" style=\"display: block; margin: 0 .5em 0 0; padding: 0; float: left;\"/>Register or Connect your ORCID iD</a><br/>\n<br>\n<br>\n<a href=\"{$orcidAboutUrl}\">More about ORCID at {$journalName}</a><br/>\n<br>\nIf you have any questions, please contact me.<br>\n<br>\n{$principalContactSignature}<br>\n');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (137, 'MANUAL_PAYMENT_NOTIFICATION', 'id', 'Notifikasi Pembayaran Manual', 'Pemberitahuan Pembayaran Manual', 'Pembayaran manual harus diproses untuk jurnal {$journalName} dan pengguna {$senderName} (username &quot;{$senderUsername}&quot;).<br />\n<br />\nItem yang akan dibayar adalah &quot;{$paymentName}&quot;.<br />\nBiayanya {$paymentAmount} ({$paymentCurrencyCode}).<br />\n<br />\nSurat elektronik ini dibuat oleh plugin Pembayaran Manual OJS.');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (138, 'MANUAL_PAYMENT_NOTIFICATION', 'en', 'Manual Payment Notify', 'Manual Payment Notification', 'A manual payment needs to be processed for the journal {$journalName} and the user {senderName} (username &quot;{$senderUsername}&quot;).<br />\n<br />\nThe item being paid for is &quot;{$paymentName}&quot;.<br />\nThe cost is {$paymentAmount} ({$paymentCurrencyCode}).<br />\n<br />\nThis email was generated by Open Journal Systems\' Manual Payment plugin.');
COMMIT;

-- ----------------------------
-- Table structure for email_templates_settings
-- ----------------------------
DROP TABLE IF EXISTS `email_templates_settings`;
CREATE TABLE `email_templates_settings` (
  `email_template_setting_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `email_id` bigint(20) NOT NULL,
  `locale` varchar(14) NOT NULL DEFAULT '',
  `setting_name` varchar(255) NOT NULL,
  `setting_value` mediumtext DEFAULT NULL,
  PRIMARY KEY (`email_template_setting_id`),
  UNIQUE KEY `email_templates_settings_unique` (`email_id`,`locale`,`setting_name`),
  KEY `email_templates_settings_email_id` (`email_id`),
  CONSTRAINT `email_templates_settings_email_id` FOREIGN KEY (`email_id`) REFERENCES `email_templates` (`email_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='More data about custom email templates, including localized properties such as the subject and body.';

-- ----------------------------
-- Records of email_templates_settings
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for event_log
-- ----------------------------
DROP TABLE IF EXISTS `event_log`;
CREATE TABLE `event_log` (
  `log_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `assoc_type` bigint(20) NOT NULL,
  `assoc_id` bigint(20) NOT NULL,
  `user_id` bigint(20) DEFAULT NULL COMMENT 'NULL if it''s system or automated event',
  `date_logged` datetime NOT NULL,
  `event_type` bigint(20) DEFAULT NULL,
  `message` text DEFAULT NULL,
  `is_translated` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`log_id`),
  KEY `event_log_user_id` (`user_id`),
  KEY `event_log_assoc` (`assoc_type`,`assoc_id`),
  CONSTRAINT `event_log_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='A log of all events related to an object like a submission.';

-- ----------------------------
-- Records of event_log
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for event_log_settings
-- ----------------------------
DROP TABLE IF EXISTS `event_log_settings`;
CREATE TABLE `event_log_settings` (
  `event_log_setting_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `log_id` bigint(20) NOT NULL,
  `locale` varchar(14) NOT NULL DEFAULT '',
  `setting_name` varchar(255) NOT NULL,
  `setting_value` mediumtext DEFAULT NULL,
  PRIMARY KEY (`event_log_setting_id`),
  UNIQUE KEY `event_log_settings_unique` (`log_id`,`setting_name`,`locale`),
  KEY `event_log_settings_log_id` (`log_id`),
  KEY `event_log_settings_name_value` (`setting_name`(50),`setting_value`(150)),
  CONSTRAINT `event_log_settings_log_id` FOREIGN KEY (`log_id`) REFERENCES `event_log` (`log_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Data about an event log entry. This data is commonly used to display information about an event to a user.';

-- ----------------------------
-- Records of event_log_settings
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for failed_jobs
-- ----------------------------
DROP TABLE IF EXISTS `failed_jobs`;
CREATE TABLE `failed_jobs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='A log of all failed jobs.';

-- ----------------------------
-- Records of failed_jobs
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for files
-- ----------------------------
DROP TABLE IF EXISTS `files`;
CREATE TABLE `files` (
  `file_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `path` varchar(255) NOT NULL,
  `mimetype` varchar(255) NOT NULL,
  PRIMARY KEY (`file_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Records information in the database about files tracked by the system, linking them to the local filesystem.';

-- ----------------------------
-- Records of files
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for filter_groups
-- ----------------------------
DROP TABLE IF EXISTS `filter_groups`;
CREATE TABLE `filter_groups` (
  `filter_group_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `symbolic` varchar(255) DEFAULT NULL,
  `display_name` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `input_type` varchar(255) DEFAULT NULL,
  `output_type` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`filter_group_id`),
  UNIQUE KEY `filter_groups_symbolic` (`symbolic`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Filter groups are used to organized filters into named sets, which can be retrieved by the application for invocation.';

-- ----------------------------
-- Records of filter_groups
-- ----------------------------
BEGIN;
INSERT INTO `filter_groups` (`filter_group_id`, `symbolic`, `display_name`, `description`, `input_type`, `output_type`) VALUES (1, 'issue=>datacite-xml', 'plugins.importexport.datacite.displayName', 'plugins.importexport.datacite.description', 'class::classes.issue.Issue', 'xml::schema(http://schema.datacite.org/meta/kernel-4/metadata.xsd)');
INSERT INTO `filter_groups` (`filter_group_id`, `symbolic`, `display_name`, `description`, `input_type`, `output_type`) VALUES (2, 'article=>datacite-xml', 'plugins.importexport.datacite.displayName', 'plugins.importexport.datacite.description', 'class::classes.submission.Submission', 'xml::schema(http://schema.datacite.org/meta/kernel-4/metadata.xsd)');
INSERT INTO `filter_groups` (`filter_group_id`, `symbolic`, `display_name`, `description`, `input_type`, `output_type`) VALUES (3, 'galley=>datacite-xml', 'plugins.importexport.datacite.displayName', 'plugins.importexport.datacite.description', 'class::lib.pkp.classes.galley.Galley', 'xml::schema(http://schema.datacite.org/meta/kernel-4/metadata.xsd)');
INSERT INTO `filter_groups` (`filter_group_id`, `symbolic`, `display_name`, `description`, `input_type`, `output_type`) VALUES (4, 'issue=>crossref-xml', 'plugins.importexport.crossref.displayName', 'plugins.importexport.crossref.description', 'class::classes.issue.Issue[]', 'xml::schema(https://www.crossref.org/schemas/crossref5.3.1.xsd)');
INSERT INTO `filter_groups` (`filter_group_id`, `symbolic`, `display_name`, `description`, `input_type`, `output_type`) VALUES (5, 'article=>crossref-xml', 'plugins.importexport.crossref.displayName', 'plugins.importexport.crossref.description', 'class::classes.submission.Submission[]', 'xml::schema(https://www.crossref.org/schemas/crossref5.3.1.xsd)');
INSERT INTO `filter_groups` (`filter_group_id`, `symbolic`, `display_name`, `description`, `input_type`, `output_type`) VALUES (6, 'article=>dc11', 'plugins.metadata.dc11.articleAdapter.displayName', 'plugins.metadata.dc11.articleAdapter.description', 'class::classes.submission.Submission', 'metadata::APP\\plugins\\metadata\\dc11\\schema\\Dc11Schema(ARTICLE)');
INSERT INTO `filter_groups` (`filter_group_id`, `symbolic`, `display_name`, `description`, `input_type`, `output_type`) VALUES (7, 'article=>native-xml', 'plugins.importexport.native.displayName', 'plugins.importexport.native.description', 'class::classes.submission.Submission[]', 'xml::schema(plugins/importexport/native/native.xsd)');
INSERT INTO `filter_groups` (`filter_group_id`, `symbolic`, `display_name`, `description`, `input_type`, `output_type`) VALUES (8, 'native-xml=>article', 'plugins.importexport.native.displayName', 'plugins.importexport.native.description', 'xml::schema(plugins/importexport/native/native.xsd)', 'class::classes.submission.Submission[]');
INSERT INTO `filter_groups` (`filter_group_id`, `symbolic`, `display_name`, `description`, `input_type`, `output_type`) VALUES (9, 'issue=>native-xml', 'plugins.importexport.native.displayName', 'plugins.importexport.native.description', 'class::classes.issue.Issue[]', 'xml::schema(plugins/importexport/native/native.xsd)');
INSERT INTO `filter_groups` (`filter_group_id`, `symbolic`, `display_name`, `description`, `input_type`, `output_type`) VALUES (10, 'native-xml=>issue', 'plugins.importexport.native.displayName', 'plugins.importexport.native.description', 'xml::schema(plugins/importexport/native/native.xsd)', 'class::classes.issue.Issue[]');
INSERT INTO `filter_groups` (`filter_group_id`, `symbolic`, `display_name`, `description`, `input_type`, `output_type`) VALUES (11, 'issuegalley=>native-xml', 'plugins.importexport.native.displayName', 'plugins.importexport.native.description', 'class::classes.issue.IssueGalley[]', 'xml::schema(plugins/importexport/native/native.xsd)');
INSERT INTO `filter_groups` (`filter_group_id`, `symbolic`, `display_name`, `description`, `input_type`, `output_type`) VALUES (12, 'native-xml=>issuegalley', 'plugins.importexport.native.displayName', 'plugins.importexport.native.description', 'xml::schema(plugins/importexport/native/native.xsd)', 'class::classes.issue.IssueGalley[]');
INSERT INTO `filter_groups` (`filter_group_id`, `symbolic`, `display_name`, `description`, `input_type`, `output_type`) VALUES (13, 'author=>native-xml', 'plugins.importexport.native.displayName', 'plugins.importexport.native.description', 'class::classes.author.Author[]', 'xml::schema(plugins/importexport/native/native.xsd)');
INSERT INTO `filter_groups` (`filter_group_id`, `symbolic`, `display_name`, `description`, `input_type`, `output_type`) VALUES (14, 'native-xml=>author', 'plugins.importexport.native.displayName', 'plugins.importexport.native.description', 'xml::schema(plugins/importexport/native/native.xsd)', 'class::classes.author.Author[]');
INSERT INTO `filter_groups` (`filter_group_id`, `symbolic`, `display_name`, `description`, `input_type`, `output_type`) VALUES (15, 'SubmissionFile=>native-xml', 'plugins.importexport.native.displayName', 'plugins.importexport.native.description', 'class::lib.pkp.classes.submissionFile.SubmissionFile', 'xml::schema(plugins/importexport/native/native.xsd)');
INSERT INTO `filter_groups` (`filter_group_id`, `symbolic`, `display_name`, `description`, `input_type`, `output_type`) VALUES (16, 'native-xml=>SubmissionFile', 'plugins.importexport.native.displayName', 'plugins.importexport.native.description', 'xml::schema(plugins/importexport/native/native.xsd)', 'class::lib.pkp.classes.submissionFile.SubmissionFile[]');
INSERT INTO `filter_groups` (`filter_group_id`, `symbolic`, `display_name`, `description`, `input_type`, `output_type`) VALUES (17, 'article-galley=>native-xml', 'plugins.importexport.native.displayName', 'plugins.importexport.native.description', 'class::lib.pkp.classes.galley.Galley', 'xml::schema(plugins/importexport/native/native.xsd)');
INSERT INTO `filter_groups` (`filter_group_id`, `symbolic`, `display_name`, `description`, `input_type`, `output_type`) VALUES (18, 'native-xml=>ArticleGalley', 'plugins.importexport.native.displayName', 'plugins.importexport.native.description', 'xml::schema(plugins/importexport/native/native.xsd)', 'class::lib.pkp.classes.galley.Galley[]');
INSERT INTO `filter_groups` (`filter_group_id`, `symbolic`, `display_name`, `description`, `input_type`, `output_type`) VALUES (19, 'publication=>native-xml', 'plugins.importexport.native.displayName', 'plugins.importexport.native.description', 'class::classes.publication.Publication', 'xml::schema(plugins/importexport/native/native.xsd)');
INSERT INTO `filter_groups` (`filter_group_id`, `symbolic`, `display_name`, `description`, `input_type`, `output_type`) VALUES (20, 'native-xml=>Publication', 'plugins.importexport.native.displayName', 'plugins.importexport.native.description', 'xml::schema(plugins/importexport/native/native.xsd)', 'class::classes.publication.Publication[]');
INSERT INTO `filter_groups` (`filter_group_id`, `symbolic`, `display_name`, `description`, `input_type`, `output_type`) VALUES (21, 'user=>user-xml', 'plugins.importexport.users.displayName', 'plugins.importexport.users.description', 'class::lib.pkp.classes.user.User[]', 'xml::schema(lib/pkp/plugins/importexport/users/pkp-users.xsd)');
INSERT INTO `filter_groups` (`filter_group_id`, `symbolic`, `display_name`, `description`, `input_type`, `output_type`) VALUES (22, 'user-xml=>user', 'plugins.importexport.users.displayName', 'plugins.importexport.users.description', 'xml::schema(lib/pkp/plugins/importexport/users/pkp-users.xsd)', 'class::classes.users.User[]');
INSERT INTO `filter_groups` (`filter_group_id`, `symbolic`, `display_name`, `description`, `input_type`, `output_type`) VALUES (23, 'usergroup=>user-xml', 'plugins.importexport.users.displayName', 'plugins.importexport.users.description', 'class::lib.pkp.classes.security.UserGroup[]', 'xml::schema(lib/pkp/plugins/importexport/users/pkp-users.xsd)');
INSERT INTO `filter_groups` (`filter_group_id`, `symbolic`, `display_name`, `description`, `input_type`, `output_type`) VALUES (24, 'user-xml=>usergroup', 'plugins.importexport.native.displayName', 'plugins.importexport.native.description', 'xml::schema(lib/pkp/plugins/importexport/users/pkp-users.xsd)', 'class::lib.pkp.classes.security.UserGroup[]');
INSERT INTO `filter_groups` (`filter_group_id`, `symbolic`, `display_name`, `description`, `input_type`, `output_type`) VALUES (25, 'article=>pubmed-xml', 'plugins.importexport.pubmed.displayName', 'plugins.importexport.pubmed.description', 'class::classes.submission.Submission[]', 'xml::dtd');
INSERT INTO `filter_groups` (`filter_group_id`, `symbolic`, `display_name`, `description`, `input_type`, `output_type`) VALUES (26, 'article=>doaj-xml', 'plugins.importexport.doaj.displayName', 'plugins.importexport.doaj.description', 'class::classes.submission.Submission[]', 'xml::schema(plugins/importexport/doaj/doajArticles.xsd)');
INSERT INTO `filter_groups` (`filter_group_id`, `symbolic`, `display_name`, `description`, `input_type`, `output_type`) VALUES (27, 'article=>doaj-json', 'plugins.importexport.doaj.displayName', 'plugins.importexport.doaj.description', 'class::classes.submission.Submission', 'primitive::string');
COMMIT;

-- ----------------------------
-- Table structure for filter_settings
-- ----------------------------
DROP TABLE IF EXISTS `filter_settings`;
CREATE TABLE `filter_settings` (
  `filter_setting_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `filter_id` bigint(20) NOT NULL,
  `locale` varchar(14) NOT NULL DEFAULT '',
  `setting_name` varchar(255) NOT NULL,
  `setting_value` mediumtext DEFAULT NULL,
  `setting_type` varchar(6) NOT NULL,
  PRIMARY KEY (`filter_setting_id`),
  UNIQUE KEY `filter_settings_unique` (`filter_id`,`locale`,`setting_name`),
  KEY `filter_settings_id` (`filter_id`),
  CONSTRAINT `filter_settings_filter_id_foreign` FOREIGN KEY (`filter_id`) REFERENCES `filters` (`filter_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='More data about filters, including localized content.';

-- ----------------------------
-- Records of filter_settings
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for filters
-- ----------------------------
DROP TABLE IF EXISTS `filters`;
CREATE TABLE `filters` (
  `filter_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `filter_group_id` bigint(20) NOT NULL DEFAULT 0,
  `context_id` bigint(20) NOT NULL DEFAULT 0,
  `display_name` varchar(255) DEFAULT NULL,
  `class_name` varchar(255) DEFAULT NULL,
  `is_template` smallint(6) NOT NULL DEFAULT 0,
  `parent_filter_id` bigint(20) NOT NULL DEFAULT 0,
  `seq` bigint(20) NOT NULL DEFAULT 0,
  PRIMARY KEY (`filter_id`),
  KEY `filters_filter_group_id` (`filter_group_id`),
  CONSTRAINT `filters_filter_group_id_foreign` FOREIGN KEY (`filter_group_id`) REFERENCES `filter_groups` (`filter_group_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Filters represent a transformation of a supported piece of data from one form to another, such as a PHP object into an XML document.';

-- ----------------------------
-- Records of filters
-- ----------------------------
BEGIN;
INSERT INTO `filters` (`filter_id`, `filter_group_id`, `context_id`, `display_name`, `class_name`, `is_template`, `parent_filter_id`, `seq`) VALUES (1, 1, 0, 'DataCite XML export', 'APP\\plugins\\generic\\datacite\\filter\\DataciteXmlFilter', 0, 0, 0);
INSERT INTO `filters` (`filter_id`, `filter_group_id`, `context_id`, `display_name`, `class_name`, `is_template`, `parent_filter_id`, `seq`) VALUES (2, 2, 0, 'DataCite XML export', 'APP\\plugins\\generic\\datacite\\filter\\DataciteXmlFilter', 0, 0, 0);
INSERT INTO `filters` (`filter_id`, `filter_group_id`, `context_id`, `display_name`, `class_name`, `is_template`, `parent_filter_id`, `seq`) VALUES (3, 3, 0, 'DataCite XML export', 'APP\\plugins\\generic\\datacite\\filter\\DataciteXmlFilter', 0, 0, 0);
INSERT INTO `filters` (`filter_id`, `filter_group_id`, `context_id`, `display_name`, `class_name`, `is_template`, `parent_filter_id`, `seq`) VALUES (4, 4, 0, 'Crossref XML issue export', 'APP\\plugins\\generic\\crossref\\filter\\IssueCrossrefXmlFilter', 0, 0, 0);
INSERT INTO `filters` (`filter_id`, `filter_group_id`, `context_id`, `display_name`, `class_name`, `is_template`, `parent_filter_id`, `seq`) VALUES (5, 5, 0, 'Crossref XML article export', 'APP\\plugins\\generic\\crossref\\filter\\ArticleCrossrefXmlFilter', 0, 0, 0);
INSERT INTO `filters` (`filter_id`, `filter_group_id`, `context_id`, `display_name`, `class_name`, `is_template`, `parent_filter_id`, `seq`) VALUES (6, 6, 0, 'Extract metadata from a(n) Submission', 'APP\\plugins\\metadata\\dc11\\filter\\Dc11SchemaArticleAdapter', 0, 0, 0);
INSERT INTO `filters` (`filter_id`, `filter_group_id`, `context_id`, `display_name`, `class_name`, `is_template`, `parent_filter_id`, `seq`) VALUES (7, 7, 0, 'Native XML submission export', 'APP\\plugins\\importexport\\native\\filter\\ArticleNativeXmlFilter', 0, 0, 0);
INSERT INTO `filters` (`filter_id`, `filter_group_id`, `context_id`, `display_name`, `class_name`, `is_template`, `parent_filter_id`, `seq`) VALUES (8, 8, 0, 'Native XML submission import', 'APP\\plugins\\importexport\\native\\filter\\NativeXmlArticleFilter', 0, 0, 0);
INSERT INTO `filters` (`filter_id`, `filter_group_id`, `context_id`, `display_name`, `class_name`, `is_template`, `parent_filter_id`, `seq`) VALUES (9, 9, 0, 'Native XML issue export', 'APP\\plugins\\importexport\\native\\filter\\IssueNativeXmlFilter', 0, 0, 0);
INSERT INTO `filters` (`filter_id`, `filter_group_id`, `context_id`, `display_name`, `class_name`, `is_template`, `parent_filter_id`, `seq`) VALUES (10, 10, 0, 'Native XML issue import', 'APP\\plugins\\importexport\\native\\filter\\NativeXmlIssueFilter', 0, 0, 0);
INSERT INTO `filters` (`filter_id`, `filter_group_id`, `context_id`, `display_name`, `class_name`, `is_template`, `parent_filter_id`, `seq`) VALUES (11, 11, 0, 'Native XML issue galley export', 'APP\\plugins\\importexport\\native\\filter\\IssueGalleyNativeXmlFilter', 0, 0, 0);
INSERT INTO `filters` (`filter_id`, `filter_group_id`, `context_id`, `display_name`, `class_name`, `is_template`, `parent_filter_id`, `seq`) VALUES (12, 12, 0, 'Native XML issue galley import', 'APP\\plugins\\importexport\\native\\filter\\NativeXmlIssueGalleyFilter', 0, 0, 0);
INSERT INTO `filters` (`filter_id`, `filter_group_id`, `context_id`, `display_name`, `class_name`, `is_template`, `parent_filter_id`, `seq`) VALUES (13, 13, 0, 'Native XML author export', 'APP\\plugins\\importexport\\native\\filter\\AuthorNativeXmlFilter', 0, 0, 0);
INSERT INTO `filters` (`filter_id`, `filter_group_id`, `context_id`, `display_name`, `class_name`, `is_template`, `parent_filter_id`, `seq`) VALUES (14, 14, 0, 'Native XML author import', 'APP\\plugins\\importexport\\native\\filter\\NativeXmlAuthorFilter', 0, 0, 0);
INSERT INTO `filters` (`filter_id`, `filter_group_id`, `context_id`, `display_name`, `class_name`, `is_template`, `parent_filter_id`, `seq`) VALUES (15, 16, 0, 'Native XML submission file import', 'APP\\plugins\\importexport\\native\\filter\\NativeXmlArticleFileFilter', 0, 0, 0);
INSERT INTO `filters` (`filter_id`, `filter_group_id`, `context_id`, `display_name`, `class_name`, `is_template`, `parent_filter_id`, `seq`) VALUES (16, 15, 0, 'Native XML submission file export', 'PKP\\plugins\\importexport\\native\\filter\\SubmissionFileNativeXmlFilter', 0, 0, 0);
INSERT INTO `filters` (`filter_id`, `filter_group_id`, `context_id`, `display_name`, `class_name`, `is_template`, `parent_filter_id`, `seq`) VALUES (17, 17, 0, 'Native XML representation export', 'APP\\plugins\\importexport\\native\\filter\\ArticleGalleyNativeXmlFilter', 0, 0, 0);
INSERT INTO `filters` (`filter_id`, `filter_group_id`, `context_id`, `display_name`, `class_name`, `is_template`, `parent_filter_id`, `seq`) VALUES (18, 18, 0, 'Native XML representation import', 'APP\\plugins\\importexport\\native\\filter\\NativeXmlArticleGalleyFilter', 0, 0, 0);
INSERT INTO `filters` (`filter_id`, `filter_group_id`, `context_id`, `display_name`, `class_name`, `is_template`, `parent_filter_id`, `seq`) VALUES (19, 19, 0, 'Native XML Publication export', 'APP\\plugins\\importexport\\native\\filter\\PublicationNativeXmlFilter', 0, 0, 0);
INSERT INTO `filters` (`filter_id`, `filter_group_id`, `context_id`, `display_name`, `class_name`, `is_template`, `parent_filter_id`, `seq`) VALUES (20, 20, 0, 'Native XML publication import', 'APP\\plugins\\importexport\\native\\filter\\NativeXmlPublicationFilter', 0, 0, 0);
INSERT INTO `filters` (`filter_id`, `filter_group_id`, `context_id`, `display_name`, `class_name`, `is_template`, `parent_filter_id`, `seq`) VALUES (21, 21, 0, 'User XML user export', 'PKP\\plugins\\importexport\\users\\filter\\PKPUserUserXmlFilter', 0, 0, 0);
INSERT INTO `filters` (`filter_id`, `filter_group_id`, `context_id`, `display_name`, `class_name`, `is_template`, `parent_filter_id`, `seq`) VALUES (22, 22, 0, 'User XML user import', 'PKP\\plugins\\importexport\\users\\filter\\UserXmlPKPUserFilter', 0, 0, 0);
INSERT INTO `filters` (`filter_id`, `filter_group_id`, `context_id`, `display_name`, `class_name`, `is_template`, `parent_filter_id`, `seq`) VALUES (23, 23, 0, 'Native XML user group export', 'PKP\\plugins\\importexport\\users\\filter\\UserGroupNativeXmlFilter', 0, 0, 0);
INSERT INTO `filters` (`filter_id`, `filter_group_id`, `context_id`, `display_name`, `class_name`, `is_template`, `parent_filter_id`, `seq`) VALUES (24, 24, 0, 'Native XML user group import', 'PKP\\plugins\\importexport\\users\\filter\\NativeXmlUserGroupFilter', 0, 0, 0);
INSERT INTO `filters` (`filter_id`, `filter_group_id`, `context_id`, `display_name`, `class_name`, `is_template`, `parent_filter_id`, `seq`) VALUES (25, 25, 0, 'APP\\plugins\\importexport\\pubmed\\filter\\ArticlePubMedXmlFilter', 'APP\\plugins\\importexport\\pubmed\\filter\\ArticlePubMedXmlFilter', 0, 0, 0);
INSERT INTO `filters` (`filter_id`, `filter_group_id`, `context_id`, `display_name`, `class_name`, `is_template`, `parent_filter_id`, `seq`) VALUES (26, 26, 0, 'DOAJ XML export', 'APP\\plugins\\importexport\\doaj\\filter\\DOAJXmlFilter', 0, 0, 0);
INSERT INTO `filters` (`filter_id`, `filter_group_id`, `context_id`, `display_name`, `class_name`, `is_template`, `parent_filter_id`, `seq`) VALUES (27, 27, 0, 'DOAJ JSON export', 'APP\\plugins\\importexport\\doaj\\filter\\DOAJJsonFilter', 0, 0, 0);
COMMIT;

-- ----------------------------
-- Table structure for genre_settings
-- ----------------------------
DROP TABLE IF EXISTS `genre_settings`;
CREATE TABLE `genre_settings` (
  `genre_setting_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `genre_id` bigint(20) NOT NULL,
  `locale` varchar(14) NOT NULL DEFAULT '',
  `setting_name` varchar(255) NOT NULL,
  `setting_value` mediumtext DEFAULT NULL,
  `setting_type` varchar(6) NOT NULL COMMENT '(bool|int|float|string|object)',
  PRIMARY KEY (`genre_setting_id`),
  UNIQUE KEY `genre_settings_unique` (`genre_id`,`locale`,`setting_name`),
  KEY `genre_settings_genre_id` (`genre_id`),
  CONSTRAINT `genre_settings_genre_id_foreign` FOREIGN KEY (`genre_id`) REFERENCES `genres` (`genre_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='More data about file genres, including localized properties such as the genre name.';

-- ----------------------------
-- Records of genre_settings
-- ----------------------------
BEGIN;
INSERT INTO `genre_settings` (`genre_setting_id`, `genre_id`, `locale`, `setting_name`, `setting_value`, `setting_type`) VALUES (1, 1, 'en', 'name', 'Article Text', 'string');
INSERT INTO `genre_settings` (`genre_setting_id`, `genre_id`, `locale`, `setting_name`, `setting_value`, `setting_type`) VALUES (2, 1, 'id', 'name', 'File Utama Naskah', 'string');
INSERT INTO `genre_settings` (`genre_setting_id`, `genre_id`, `locale`, `setting_name`, `setting_value`, `setting_type`) VALUES (3, 2, 'en', 'name', 'Research Instrument', 'string');
INSERT INTO `genre_settings` (`genre_setting_id`, `genre_id`, `locale`, `setting_name`, `setting_value`, `setting_type`) VALUES (4, 2, 'id', 'name', 'Instrumen Penelitian', 'string');
INSERT INTO `genre_settings` (`genre_setting_id`, `genre_id`, `locale`, `setting_name`, `setting_value`, `setting_type`) VALUES (5, 3, 'en', 'name', 'Research Materials', 'string');
INSERT INTO `genre_settings` (`genre_setting_id`, `genre_id`, `locale`, `setting_name`, `setting_value`, `setting_type`) VALUES (6, 3, 'id', 'name', 'Bahan Penelitian', 'string');
INSERT INTO `genre_settings` (`genre_setting_id`, `genre_id`, `locale`, `setting_name`, `setting_value`, `setting_type`) VALUES (7, 4, 'en', 'name', 'Research Results', 'string');
INSERT INTO `genre_settings` (`genre_setting_id`, `genre_id`, `locale`, `setting_name`, `setting_value`, `setting_type`) VALUES (8, 4, 'id', 'name', 'Hasil Penelitian', 'string');
INSERT INTO `genre_settings` (`genre_setting_id`, `genre_id`, `locale`, `setting_name`, `setting_value`, `setting_type`) VALUES (9, 5, 'en', 'name', 'Transcripts', 'string');
INSERT INTO `genre_settings` (`genre_setting_id`, `genre_id`, `locale`, `setting_name`, `setting_value`, `setting_type`) VALUES (10, 5, 'id', 'name', 'Transkrip', 'string');
INSERT INTO `genre_settings` (`genre_setting_id`, `genre_id`, `locale`, `setting_name`, `setting_value`, `setting_type`) VALUES (11, 6, 'en', 'name', 'Data Analysis', 'string');
INSERT INTO `genre_settings` (`genre_setting_id`, `genre_id`, `locale`, `setting_name`, `setting_value`, `setting_type`) VALUES (12, 6, 'id', 'name', 'Analisis Data', 'string');
INSERT INTO `genre_settings` (`genre_setting_id`, `genre_id`, `locale`, `setting_name`, `setting_value`, `setting_type`) VALUES (13, 7, 'en', 'name', 'Data Set', 'string');
INSERT INTO `genre_settings` (`genre_setting_id`, `genre_id`, `locale`, `setting_name`, `setting_value`, `setting_type`) VALUES (14, 7, 'id', 'name', 'Data Set', 'string');
INSERT INTO `genre_settings` (`genre_setting_id`, `genre_id`, `locale`, `setting_name`, `setting_value`, `setting_type`) VALUES (15, 8, 'en', 'name', 'Source Texts', 'string');
INSERT INTO `genre_settings` (`genre_setting_id`, `genre_id`, `locale`, `setting_name`, `setting_value`, `setting_type`) VALUES (16, 8, 'id', 'name', 'Teks Sumber', 'string');
INSERT INTO `genre_settings` (`genre_setting_id`, `genre_id`, `locale`, `setting_name`, `setting_value`, `setting_type`) VALUES (17, 9, 'en', 'name', 'Multimedia', 'string');
INSERT INTO `genre_settings` (`genre_setting_id`, `genre_id`, `locale`, `setting_name`, `setting_value`, `setting_type`) VALUES (18, 9, 'id', 'name', 'Multimedia', 'string');
INSERT INTO `genre_settings` (`genre_setting_id`, `genre_id`, `locale`, `setting_name`, `setting_value`, `setting_type`) VALUES (19, 10, 'en', 'name', 'Image', 'string');
INSERT INTO `genre_settings` (`genre_setting_id`, `genre_id`, `locale`, `setting_name`, `setting_value`, `setting_type`) VALUES (20, 10, 'id', 'name', 'Gambar', 'string');
INSERT INTO `genre_settings` (`genre_setting_id`, `genre_id`, `locale`, `setting_name`, `setting_value`, `setting_type`) VALUES (21, 11, 'en', 'name', 'HTML Stylesheet', 'string');
INSERT INTO `genre_settings` (`genre_setting_id`, `genre_id`, `locale`, `setting_name`, `setting_value`, `setting_type`) VALUES (22, 11, 'id', 'name', 'HTML StyleSheet', 'string');
INSERT INTO `genre_settings` (`genre_setting_id`, `genre_id`, `locale`, `setting_name`, `setting_value`, `setting_type`) VALUES (23, 12, 'en', 'name', 'Other', 'string');
INSERT INTO `genre_settings` (`genre_setting_id`, `genre_id`, `locale`, `setting_name`, `setting_value`, `setting_type`) VALUES (24, 12, 'id', 'name', 'Lainnya', 'string');
COMMIT;

-- ----------------------------
-- Table structure for genres
-- ----------------------------
DROP TABLE IF EXISTS `genres`;
CREATE TABLE `genres` (
  `genre_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `context_id` bigint(20) NOT NULL,
  `seq` bigint(20) NOT NULL,
  `enabled` smallint(6) NOT NULL DEFAULT 1,
  `category` bigint(20) NOT NULL DEFAULT 1,
  `dependent` smallint(6) NOT NULL DEFAULT 0,
  `supplementary` smallint(6) NOT NULL DEFAULT 0,
  `required` smallint(6) NOT NULL DEFAULT 0 COMMENT 'Whether or not at least one file of this genre is required for a new submission.',
  `entry_key` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`genre_id`),
  KEY `genres_context_id` (`context_id`),
  CONSTRAINT `genres_context_id_foreign` FOREIGN KEY (`context_id`) REFERENCES `journals` (`journal_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='The types of submission files configured for each context, such as Article Text, Data Set, Transcript, etc.';

-- ----------------------------
-- Records of genres
-- ----------------------------
BEGIN;
INSERT INTO `genres` (`genre_id`, `context_id`, `seq`, `enabled`, `category`, `dependent`, `supplementary`, `required`, `entry_key`) VALUES (1, 1, 0, 1, 1, 0, 0, 1, 'SUBMISSION');
INSERT INTO `genres` (`genre_id`, `context_id`, `seq`, `enabled`, `category`, `dependent`, `supplementary`, `required`, `entry_key`) VALUES (2, 1, 1, 1, 3, 0, 1, 0, 'RESEARCHINSTRUMENT');
INSERT INTO `genres` (`genre_id`, `context_id`, `seq`, `enabled`, `category`, `dependent`, `supplementary`, `required`, `entry_key`) VALUES (3, 1, 2, 1, 3, 0, 1, 0, 'RESEARCHMATERIALS');
INSERT INTO `genres` (`genre_id`, `context_id`, `seq`, `enabled`, `category`, `dependent`, `supplementary`, `required`, `entry_key`) VALUES (4, 1, 3, 1, 3, 0, 1, 0, 'RESEARCHRESULTS');
INSERT INTO `genres` (`genre_id`, `context_id`, `seq`, `enabled`, `category`, `dependent`, `supplementary`, `required`, `entry_key`) VALUES (5, 1, 4, 1, 3, 0, 1, 0, 'TRANSCRIPTS');
INSERT INTO `genres` (`genre_id`, `context_id`, `seq`, `enabled`, `category`, `dependent`, `supplementary`, `required`, `entry_key`) VALUES (6, 1, 5, 1, 3, 0, 1, 0, 'DATAANALYSIS');
INSERT INTO `genres` (`genre_id`, `context_id`, `seq`, `enabled`, `category`, `dependent`, `supplementary`, `required`, `entry_key`) VALUES (7, 1, 6, 1, 3, 0, 1, 0, 'DATASET');
INSERT INTO `genres` (`genre_id`, `context_id`, `seq`, `enabled`, `category`, `dependent`, `supplementary`, `required`, `entry_key`) VALUES (8, 1, 7, 1, 3, 0, 1, 0, 'SOURCETEXTS');
INSERT INTO `genres` (`genre_id`, `context_id`, `seq`, `enabled`, `category`, `dependent`, `supplementary`, `required`, `entry_key`) VALUES (9, 1, 8, 1, 1, 1, 1, 0, 'MULTIMEDIA');
INSERT INTO `genres` (`genre_id`, `context_id`, `seq`, `enabled`, `category`, `dependent`, `supplementary`, `required`, `entry_key`) VALUES (10, 1, 9, 1, 2, 1, 0, 0, 'IMAGE');
INSERT INTO `genres` (`genre_id`, `context_id`, `seq`, `enabled`, `category`, `dependent`, `supplementary`, `required`, `entry_key`) VALUES (11, 1, 10, 1, 1, 1, 0, 0, 'STYLE');
INSERT INTO `genres` (`genre_id`, `context_id`, `seq`, `enabled`, `category`, `dependent`, `supplementary`, `required`, `entry_key`) VALUES (12, 1, 11, 1, 3, 0, 1, 0, 'OTHER');
COMMIT;

-- ----------------------------
-- Table structure for institution_ip
-- ----------------------------
DROP TABLE IF EXISTS `institution_ip`;
CREATE TABLE `institution_ip` (
  `institution_ip_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `institution_id` bigint(20) NOT NULL,
  `ip_string` varchar(40) NOT NULL,
  `ip_start` bigint(20) NOT NULL,
  `ip_end` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`institution_ip_id`),
  KEY `institution_ip_institution_id` (`institution_id`),
  KEY `institution_ip_start` (`ip_start`),
  KEY `institution_ip_end` (`ip_end`),
  CONSTRAINT `institution_ip_institution_id_foreign` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`institution_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Records IP address ranges and associates them with institutions.';

-- ----------------------------
-- Records of institution_ip
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for institution_settings
-- ----------------------------
DROP TABLE IF EXISTS `institution_settings`;
CREATE TABLE `institution_settings` (
  `institution_setting_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `institution_id` bigint(20) NOT NULL,
  `locale` varchar(14) NOT NULL DEFAULT '',
  `setting_name` varchar(255) NOT NULL,
  `setting_value` mediumtext DEFAULT NULL,
  PRIMARY KEY (`institution_setting_id`),
  UNIQUE KEY `institution_settings_unique` (`institution_id`,`locale`,`setting_name`),
  KEY `institution_settings_institution_id` (`institution_id`),
  CONSTRAINT `institution_settings_institution_id_foreign` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`institution_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='More data about institutions, including localized properties like names.';

-- ----------------------------
-- Records of institution_settings
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for institutional_subscriptions
-- ----------------------------
DROP TABLE IF EXISTS `institutional_subscriptions`;
CREATE TABLE `institutional_subscriptions` (
  `institutional_subscription_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `subscription_id` bigint(20) NOT NULL,
  `institution_id` bigint(20) NOT NULL,
  `mailing_address` varchar(255) DEFAULT NULL,
  `domain` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`institutional_subscription_id`),
  KEY `institutional_subscriptions_subscription_id` (`subscription_id`),
  KEY `institutional_subscriptions_institution_id` (`institution_id`),
  KEY `institutional_subscriptions_domain` (`domain`),
  CONSTRAINT `institutional_subscriptions_institution_id_foreign` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`institution_id`) ON DELETE CASCADE,
  CONSTRAINT `institutional_subscriptions_subscription_id` FOREIGN KEY (`subscription_id`) REFERENCES `subscriptions` (`subscription_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='A list of institutional subscriptions, linking a subscription with an institution.';

-- ----------------------------
-- Records of institutional_subscriptions
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for institutions
-- ----------------------------
DROP TABLE IF EXISTS `institutions`;
CREATE TABLE `institutions` (
  `institution_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `context_id` bigint(20) NOT NULL,
  `ror` varchar(255) DEFAULT NULL COMMENT 'ROR (Research Organization Registry) ID',
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`institution_id`),
  KEY `institutions_context_id` (`context_id`),
  CONSTRAINT `institutions_context_id_foreign` FOREIGN KEY (`context_id`) REFERENCES `journals` (`journal_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Institutions for statistics and subscriptions.';

-- ----------------------------
-- Records of institutions
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for issue_files
-- ----------------------------
DROP TABLE IF EXISTS `issue_files`;
CREATE TABLE `issue_files` (
  `file_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `issue_id` bigint(20) NOT NULL,
  `file_name` varchar(90) NOT NULL,
  `file_type` varchar(255) NOT NULL,
  `file_size` bigint(20) NOT NULL,
  `content_type` bigint(20) NOT NULL,
  `original_file_name` varchar(127) DEFAULT NULL,
  `date_uploaded` datetime NOT NULL,
  `date_modified` datetime NOT NULL,
  PRIMARY KEY (`file_id`),
  KEY `issue_files_issue_id` (`issue_id`),
  CONSTRAINT `issue_files_issue_id` FOREIGN KEY (`issue_id`) REFERENCES `issues` (`issue_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Relationships between issues and issue files, such as cover images.';

-- ----------------------------
-- Records of issue_files
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for issue_galley_settings
-- ----------------------------
DROP TABLE IF EXISTS `issue_galley_settings`;
CREATE TABLE `issue_galley_settings` (
  `issue_galley_setting_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `galley_id` bigint(20) NOT NULL,
  `locale` varchar(14) NOT NULL DEFAULT '',
  `setting_name` varchar(255) NOT NULL,
  `setting_value` mediumtext DEFAULT NULL,
  `setting_type` varchar(6) NOT NULL COMMENT '(bool|int|float|string|object)',
  PRIMARY KEY (`issue_galley_setting_id`),
  UNIQUE KEY `issue_galley_settings_unique` (`galley_id`,`locale`,`setting_name`),
  KEY `issue_galley_settings_galley_id` (`galley_id`),
  CONSTRAINT `issue_galleys_settings_galley_id` FOREIGN KEY (`galley_id`) REFERENCES `issue_galleys` (`galley_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='More data about issue galleys, including localized content such as labels.';

-- ----------------------------
-- Records of issue_galley_settings
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for issue_galleys
-- ----------------------------
DROP TABLE IF EXISTS `issue_galleys`;
CREATE TABLE `issue_galleys` (
  `galley_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `locale` varchar(14) DEFAULT NULL,
  `issue_id` bigint(20) NOT NULL,
  `file_id` bigint(20) NOT NULL,
  `label` varchar(255) DEFAULT NULL,
  `seq` double(8,2) NOT NULL DEFAULT 0.00,
  `url_path` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`galley_id`),
  KEY `issue_galleys_issue_id` (`issue_id`),
  KEY `issue_galleys_file_id` (`file_id`),
  KEY `issue_galleys_url_path` (`url_path`),
  CONSTRAINT `issue_galleys_file_id` FOREIGN KEY (`file_id`) REFERENCES `issue_files` (`file_id`) ON DELETE CASCADE,
  CONSTRAINT `issue_galleys_issue_id` FOREIGN KEY (`issue_id`) REFERENCES `issues` (`issue_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Issue galleys are representations of the entire issue in a single file, such as a complete issue PDF.';

-- ----------------------------
-- Records of issue_galleys
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for issue_settings
-- ----------------------------
DROP TABLE IF EXISTS `issue_settings`;
CREATE TABLE `issue_settings` (
  `issue_setting_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `issue_id` bigint(20) NOT NULL,
  `locale` varchar(14) NOT NULL DEFAULT '',
  `setting_name` varchar(255) NOT NULL,
  `setting_value` mediumtext DEFAULT NULL,
  PRIMARY KEY (`issue_setting_id`),
  UNIQUE KEY `issue_settings_unique` (`issue_id`,`locale`,`setting_name`),
  KEY `issue_settings_issue_id` (`issue_id`),
  KEY `issue_settings_name_value` (`setting_name`(50),`setting_value`(150)),
  CONSTRAINT `issue_settings_issue_id` FOREIGN KEY (`issue_id`) REFERENCES `issues` (`issue_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='More data about issues, including localized properties such as issue titles.';

-- ----------------------------
-- Records of issue_settings
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for issues
-- ----------------------------
DROP TABLE IF EXISTS `issues`;
CREATE TABLE `issues` (
  `issue_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `journal_id` bigint(20) NOT NULL,
  `volume` smallint(6) DEFAULT NULL,
  `number` varchar(40) DEFAULT NULL,
  `year` smallint(6) DEFAULT NULL,
  `published` smallint(6) NOT NULL DEFAULT 0,
  `date_published` datetime DEFAULT NULL,
  `date_notified` datetime DEFAULT NULL,
  `last_modified` datetime DEFAULT NULL,
  `access_status` smallint(6) NOT NULL DEFAULT 1,
  `open_access_date` datetime DEFAULT NULL,
  `show_volume` smallint(6) NOT NULL DEFAULT 0,
  `show_number` smallint(6) NOT NULL DEFAULT 0,
  `show_year` smallint(6) NOT NULL DEFAULT 0,
  `show_title` smallint(6) NOT NULL DEFAULT 0,
  `style_file_name` varchar(90) DEFAULT NULL,
  `original_style_file_name` varchar(255) DEFAULT NULL,
  `url_path` varchar(64) DEFAULT NULL,
  `doi_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`issue_id`),
  KEY `issues_journal_id` (`journal_id`),
  KEY `issues_doi_id` (`doi_id`),
  KEY `issues_url_path` (`url_path`),
  CONSTRAINT `issues_doi_id_foreign` FOREIGN KEY (`doi_id`) REFERENCES `dois` (`doi_id`) ON DELETE SET NULL,
  CONSTRAINT `issues_journal_id` FOREIGN KEY (`journal_id`) REFERENCES `journals` (`journal_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='A list of all journal issues, with identifying information like year, number, volume, etc.';

-- ----------------------------
-- Records of issues
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for job_batches
-- ----------------------------
DROP TABLE IF EXISTS `job_batches`;
CREATE TABLE `job_batches` (
  `id` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `total_jobs` int(11) NOT NULL,
  `pending_jobs` int(11) NOT NULL,
  `failed_jobs` int(11) NOT NULL,
  `failed_job_ids` text NOT NULL,
  `options` mediumtext DEFAULT NULL,
  `cancelled_at` int(11) DEFAULT NULL,
  `created_at` int(11) NOT NULL,
  `finished_at` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Job batches allow jobs to be collected into groups for managed processing.';

-- ----------------------------
-- Records of job_batches
-- ----------------------------
BEGIN;
INSERT INTO `job_batches` (`id`, `name`, `total_jobs`, `pending_jobs`, `failed_jobs`, `failed_job_ids`, `options`, `cancelled_at`, `created_at`, `finished_at`) VALUES ('9d533cb1-0bdb-4f54-9a23-e54f6a1e57f6', '', 0, 0, 0, '[]', 'a:0:{}', NULL, 1729808260, NULL);
COMMIT;

-- ----------------------------
-- Table structure for jobs
-- ----------------------------
DROP TABLE IF EXISTS `jobs`;
CREATE TABLE `jobs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `queue` varchar(255) NOT NULL,
  `payload` longtext NOT NULL,
  `attempts` tinyint(3) unsigned NOT NULL,
  `reserved_at` int(10) unsigned DEFAULT NULL,
  `available_at` int(10) unsigned NOT NULL,
  `created_at` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `jobs_queue_reserved_at_index` (`queue`,`reserved_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='All pending or in-progress jobs.';

-- ----------------------------
-- Records of jobs
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for journal_settings
-- ----------------------------
DROP TABLE IF EXISTS `journal_settings`;
CREATE TABLE `journal_settings` (
  `journal_setting_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `journal_id` bigint(20) NOT NULL,
  `locale` varchar(14) NOT NULL DEFAULT '',
  `setting_name` varchar(255) NOT NULL,
  `setting_value` mediumtext DEFAULT NULL,
  PRIMARY KEY (`journal_setting_id`),
  UNIQUE KEY `journal_settings_unique` (`journal_id`,`locale`,`setting_name`),
  KEY `journal_settings_journal_id` (`journal_id`),
  CONSTRAINT `journal_settings_journal_id` FOREIGN KEY (`journal_id`) REFERENCES `journals` (`journal_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=74 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='More data about journals, including localized properties like policies.';

-- ----------------------------
-- Records of journal_settings
-- ----------------------------
BEGIN;
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (1, 1, 'en', 'acronym', 'PEACEE');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (2, 1, 'id', 'acronym', NULL);
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (3, 1, 'en', 'authorGuidelines', '<p>Authors are invited to make a submission to this journal. All submissions will be assessed by an editor to determine whether they meet the aims and scope of this journal. Those considered to be a good fit will be sent for peer review before determining whether they will be accepted or rejected.</p><p>Before making a submission, authors are responsible for obtaining permission to publish any material included with the submission, such as photos, documents and datasets. All authors identified on the submission must consent to be identified as an author. Where appropriate, research should be approved by an appropriate ethics committee in accordance with the legal requirements of the study\'s country.</p><p>An editor may desk reject a submission if it does not meet minimum standards of quality. Before submitting, please ensure that the study design and research argument are structured and articulated properly. The title should be concise and the abstract should be able to stand on its own. This will increase the likelihood of reviewers agreeing to review the paper. When you\'re satisfied that your submission meets this standard, please follow the checklist below to prepare your submission.</p>');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (4, 1, 'id', 'authorGuidelines', '<p>Para penulis diundang untuk mengirimkan naskahnya ke jurnal ini. Semua naskah akan dinilai oleh seorang editor untuk menentukan apakah sudah sesuai dengan tujuan dan cakupan jurnal ini. Naskah yang sesuai akan dikirimkan untuk ditinjau oleh mitra bestari sebelum menentukan apakah naskah tersebut akan diterima atau ditolak.</p><p>Sebelum mengirim, penulis bertanggung jawab untuk memperoleh izin untuk menerbitkan semua materi yang disertakan dalam naskah, seperti foto, dokumen, dan kumpulan data. Semua penulis yang tertera dalam naskah harus memberikan persetujuan untuk diakui sebagai penulis. Bila diperlukan, penelitian harus disetujui oleh suatu komite etik yang tepat sesuai dengan persyaratan hukum negara tempat penelitian.</p><p>Editor dapat menolak sebuah naskah jika tidak memenuhi standar minimum kualitas. Sebelum mengirim, pastikan bahwa desain penelitian dan argumen penelitian terstruktur dan dirumuskan dengan baik. Judul harus singkat dan abstrak harus bisa berdiri sendiri. Hal ini akan meningkatkan kemungkinan reviewer bersedia mereview naskah tersebut. Setelah sudah yakin telah memenuhi ketentuan ini, silakan tandai daftar periksa di bawah ini untuk menyiapkan naskah Anda.</p>');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (5, 1, 'en', 'authorInformation', 'Interested in submitting to this journal? We recommend that you review the <a href=\"http://peacee.id/index.php/journal/about\">About the Journal</a> page for the journal\'s section policies, as well as the <a href=\"http://peacee.id/index.php/journal/about/submissions#authorGuidelines\">Author Guidelines</a>. Authors need to <a href=\"http://peacee.id/index.php/journal/user/register\">register</a> with the journal prior to submitting or, if already registered, can simply <a href=\"http://peacee.id/index.php/index/login\">log in</a> and begin the five-step process.');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (6, 1, 'id', 'authorInformation', 'Tertarik menerbitkan jurnal? Kami merekomendasikan Anda mereview halaman <a href=\"http://peacee.id/index.php/journal/about\">Tentang Kami </a>untuk kebijakan bagian jurnal serta <a href=\"http://peacee.id/index.php/journal/about/submissions#authorGuidelines\">Petunjuk Penulis </a>. Penulis perlu <a href=\"http://peacee.id/index.php/journal/user/register\">Mendaftar </a>dengan jurnal sebelum menyerahkan atau jika sudah terdaftar <a href=\"http://peacee.id/index.php/index/login\">login</a>dan mulai proses lima langkah.');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (7, 1, 'en', 'beginSubmissionHelp', '<p>Thank you for submitting to the . You will be asked to upload files, identify co-authors, and provide information such as the title and abstract.<p><p>Please read our <a href=\"http://peacee.id/index.php/journal/about/submissions\" target=\"_blank\">Submission Guidelines</a> if you have not done so already. When filling out the forms, provide as many details as possible in order to help our editors evaluate your work.</p><p>Once you begin, you can save your submission and come back to it later. You will be able to review and correct any information before you submit.</p>');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (8, 1, 'id', 'beginSubmissionHelp', '##default.submission.step.beforeYouBegin##');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (9, 1, '', 'contactEmail', 'deewahyu@upi.edu');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (10, 1, '', 'contactName', 'Didin Wahyudin');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (11, 1, 'en', 'contributorsHelp', '<p>Add details for all of the contributors to this submission. Contributors added here will be sent an email confirmation of the submission, as well as a copy of all editorial decisions recorded against this submission.</p><p>If a contributor can not be contacted by email, because they must remain anonymous or do not have an email account, please do not enter a fake email address. You can add information about this contributor in a message to the editor at a later step in the submission process.</p>');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (12, 1, 'id', 'contributorsHelp', '##default.submission.step.contributors##');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (13, 1, '', 'country', 'ID');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (14, 1, '', 'defaultReviewMode', '2');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (17, 1, 'en', 'detailsHelp', '<p>Please provide the following details to help us manage your submission in our system.</p>');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (18, 1, 'id', 'detailsHelp', '##default.submission.step.details##');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (19, 1, '', 'copySubmissionAckPrimaryContact', '0');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (20, 1, '', 'copySubmissionAckAddress', '');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (21, 1, '', 'emailSignature', '<br/><hr /><br/><p><a href=\"http://peacee.id/index.php/journal\"></a></p><p>{$mailingAddress}</p><p>{$contactName}, <a href=\"mailto: {$contactEmail}\">{$contactEmail}</a></p>');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (22, 1, '', 'enableDois', '1');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (23, 1, '', 'doiSuffixType', 'default');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (24, 1, '', 'registrationAgency', '');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (25, 1, '', 'disableSubmissions', '0');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (26, 1, '', 'editorialStatsEmail', '1');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (27, 1, 'en', 'forTheEditorsHelp', '<p>Please provide the following details in order to help our editorial team manage your submission.</p><p>When entering metadata, provide entries that you think would be most helpful to the person managing your submission. This information can be changed before publication.</p>');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (28, 1, 'id', 'forTheEditorsHelp', '##default.submission.step.forTheEditors##');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (29, 1, '', 'itemsPerPage', '25');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (30, 1, '', 'keywords', 'request');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (31, 1, 'en', 'librarianInformation', 'We encourage research librarians to list this journal among their library\'s electronic journal holdings. As well, it may be worth noting that this journal\'s open source publishing system is suitable for libraries to host for their faculty members to use with journals they are involved in editing (see <a href=\"https://pkp.sfu.ca/ojs\">Open Journal Systems</a>).');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (32, 1, 'id', 'librarianInformation', 'Kami mendorong pustakawan riset untuk mendaftar jurnal diantara pemegang jurnal eletronik perpustakaan. Begitu juga, ini mungkin berharga bahwa sistem penerbitan sumber terbuka jurnal cocok untuk perpustakaan untuk menjadi tuan rumah untuk anggota fakultas untuk menggunakan jurnal saat mereka terlibat dalam proses editing. (Kunjungi <a href=\"https://pkp.sfu.ca/ojs\">Open Journal Systems</a>).');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (33, 1, 'en', 'name', 'Progress in Electrical and Computer Engineering Education');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (34, 1, 'id', 'name', NULL);
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (35, 1, '', 'notifyAllAuthors', '1');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (36, 1, '', 'numPageLinks', '10');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (37, 1, '', 'numWeeksPerResponse', '4');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (38, 1, '', 'numWeeksPerReview', '4');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (39, 1, 'en', 'openAccessPolicy', 'This journal provides immediate open access to its content on the principle that making research freely available to the public supports a greater global exchange of knowledge.');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (40, 1, 'id', 'openAccessPolicy', 'Jurnal ini menyediakan akses terbuka yang pada prinsipnya membuat riset tersedia secara gratis untuk publik dan akan mensupport pertukaran pengetahuan global terbesar.');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (41, 1, 'en', 'privacyStatement', '<p>The names and email addresses entered in this journal site will be used exclusively for the stated purposes of this journal and will not be made available for any other purpose or to any other party.</p>');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (42, 1, 'id', 'privacyStatement', '<p>Nama dan alamat email yang dimasukkan di website ini hanya akan digunakan untuk tujuan yang sudah disebutkan, tidak akan disalahgunakan untuk tujuan lain atau untuk disebarluaskan ke pihak lain.</p>');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (43, 1, 'en', 'readerInformation', 'We encourage readers to sign up for the publishing notification service for this journal. Use the <a href=\"http://peacee.id/index.php/journal/user/register\">Register</a> link at the top of the home page for the journal. This registration will result in the reader receiving the Table of Contents by email for each new issue of the journal. This list also allows the journal to claim a certain level of support or readership. See the journal\'s <a href=\"http://peacee.id/index.php/journal/about/submissions#privacyStatement\">Privacy Statement</a>, which assures readers that their name and email address will not be used for other purposes.');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (44, 1, 'id', 'readerInformation', 'Kami mendorong pembaca untuk mendaftarkan diri di layanan notifikasi penerbitan untuk jurnal ini. Gunakan tautan <a href=\"http://peacee.id/index.php/journal/user/register\">Daftar</a>di bagian atas beranda jurnal. Dengan mendaftar, pembaca akan memperoleh email berisi Daftar Isi tiap ada terbitan jurnal baru. Daftar ini juga membuat jurnal dapat mengetahui tingkat dukungan atau jumlah pembaca. Lihat jurnal <a href=\"http://peacee.id/index.php/journal/about/submissions#privacyStatement\">Pernyataan Privasi</a>, yang meyakinkan pembaca bahwa nama dan alamat email yang didaftarkan tidak akan digunakan untuk tujuan lain.');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (45, 1, 'en', 'reviewHelp', '<p>Review the information you have entered before you complete your submission. You can change any of the details displayed here by clicking the edit button at the top of each section.</p><p>Once you complete your submission, a member of our editorial team will be assigned to review it. Please ensure the details you have entered here are as accurate as possible.</p>');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (46, 1, 'id', 'reviewHelp', '##default.submission.step.review##');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (47, 1, '', 'submissionAcknowledgement', 'allAuthors');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (48, 1, 'en', 'submissionChecklist', '<p>All submissions must meet the following requirements.</p><ul><li>This submission meets the requirements outlined in the <a href=\"http://peacee.id/index.php/journal/about/submissions\">Author Guidelines</a>.</li><li>This submission has not been previously published, nor is it before another journal for consideration.</li><li>All references have been checked for accuracy and completeness.</li><li>All tables and figures have been numbered and labeled.</li><li>Permission has been obtained to publish all photos, datasets and other material provided with this submission.</li></ul>');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (49, 1, 'id', 'submissionChecklist', '<p>Seluruh naskah harus memenuhi persyaratan berikut.</p><ul><li>Naskah ini memenuhi persyaratan yang disebutkan dalam <a href=\"http://peacee.id/index.php/journal/about/submissions\">Panduan bagi Penulis</a>.</li><li>Naskah ini belum perah diterbitkan, tidak pula sedang dalam pertimbangan jurnal lain.</li><li>Remua referensi telah diperiksa akurasi dan kelengkapannya.</li><li>Semua tabel dan gambat sudah diberi nomor dan judul.</li><li>Ijin telah diperoleh untuk menerbitkan semua foto, dataset dan bahan lain yang tersedia dalam naskah ini.</li></ul>');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (50, 1, '', 'submitWithCategories', '0');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (51, 1, '', 'supportedFormLocales', '[\"id\"]');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (52, 1, '', 'supportedLocales', '[\"en\",\"id\"]');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (53, 1, '', 'supportedSubmissionLocales', '[\"id\"]');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (54, 1, '', 'themePluginPath', 'default');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (55, 1, 'en', 'uploadFilesHelp', '<p>Provide any files our editorial team may need to evaluate your submission. In addition to the main work, you may wish to submit data sets, conflict of interest statements, or other supplementary files if these will be helpful for our editors.</p>');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (56, 1, 'id', 'uploadFilesHelp', '##default.submission.step.uploadFiles##');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (57, 1, '', 'enableGeoUsageStats', 'disabled');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (58, 1, '', 'enableInstitutionUsageStats', '0');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (59, 1, '', 'isSushiApiPublic', '1');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (60, 1, 'en', 'abbreviation', 'PEACEE');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (61, 1, 'id', 'abbreviation', NULL);
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (62, 1, 'en', 'clockssLicense', 'This journal utilizes the CLOCKSS system to create a distributed archiving system among participating libraries and permits those libraries to create permanent archives of the journal for purposes of preservation and restoration. <a href=\"https://clockss.org\">More...</a>');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (63, 1, 'id', 'clockssLicense', 'Journal ini memakai sistem CLOCKSS untum membuat sistem pengarsipan terdistribusi di antara pustaka yang turut berpartisipasi dan mengizinkan pustaka tersebut membuat arsip jurnal secara permanen untuk tujuan pemeliharaan dan pemulihan. <a href=\"https://clockss.org\">More...</a>');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (64, 1, '', 'copyrightYearBasis', 'issue');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (65, 1, '', 'enabledDoiTypes', '[\"publication\"]');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (66, 1, '', 'doiCreationTime', 'copyEditCreationTime');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (67, 1, '', 'enableOai', '1');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (68, 1, 'en', 'lockssLicense', 'This journal utilizes the LOCKSS system to create a distributed archiving system among participating libraries and permits those libraries to create permanent archives of the journal for purposes of preservation and restoration. <a href=\"https://www.lockss.org\">More...</a>');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (69, 1, 'id', 'lockssLicense', 'OJS sistem LOCKSS berfungsi sebagai sistem pengarsipan terdistribusi antar-perpustakaan yang menggunakan sistem ini dengan tujuan membuat arsip permanen (untuk preservasi dan restorasi). <a href=\"https://www.lockss.org\">Lanjut...</a>');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (70, 1, '', 'membershipFee', '0');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (71, 1, '', 'publicationFee', '0');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (72, 1, '', 'purchaseArticleFee', '0');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (73, 1, '', 'doiVersioning', '0');
COMMIT;

-- ----------------------------
-- Table structure for journals
-- ----------------------------
DROP TABLE IF EXISTS `journals`;
CREATE TABLE `journals` (
  `journal_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `path` varchar(32) NOT NULL,
  `seq` double(8,2) NOT NULL DEFAULT 0.00 COMMENT 'Used to order lists of journals',
  `primary_locale` varchar(14) NOT NULL,
  `enabled` smallint(6) NOT NULL DEFAULT 1 COMMENT 'Controls whether or not the journal is considered "live" and will appear on the website. (Note that disabled journals may still be accessible, but only if the user knows the URL.)',
  `current_issue_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`journal_id`),
  UNIQUE KEY `journals_path` (`path`),
  KEY `journals_issue_id` (`current_issue_id`),
  CONSTRAINT `journals_current_issue_id_foreign` FOREIGN KEY (`current_issue_id`) REFERENCES `issues` (`issue_id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='A list of all journals in the installation of OJS.';

-- ----------------------------
-- Records of journals
-- ----------------------------
BEGIN;
INSERT INTO `journals` (`journal_id`, `path`, `seq`, `primary_locale`, `enabled`, `current_issue_id`) VALUES (1, 'journal', 1.00, 'id', 1, NULL);
COMMIT;

-- ----------------------------
-- Table structure for library_file_settings
-- ----------------------------
DROP TABLE IF EXISTS `library_file_settings`;
CREATE TABLE `library_file_settings` (
  `library_file_setting_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `file_id` bigint(20) NOT NULL,
  `locale` varchar(14) NOT NULL DEFAULT '',
  `setting_name` varchar(255) NOT NULL,
  `setting_value` mediumtext DEFAULT NULL,
  `setting_type` varchar(6) NOT NULL COMMENT '(bool|int|float|string|object|date)',
  PRIMARY KEY (`library_file_setting_id`),
  UNIQUE KEY `library_file_settings_unique` (`file_id`,`locale`,`setting_name`),
  KEY `library_file_settings_file_id` (`file_id`),
  CONSTRAINT `library_file_settings_file_id_foreign` FOREIGN KEY (`file_id`) REFERENCES `library_files` (`file_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='More data about library files, including localized content such as names.';

-- ----------------------------
-- Records of library_file_settings
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for library_files
-- ----------------------------
DROP TABLE IF EXISTS `library_files`;
CREATE TABLE `library_files` (
  `file_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `context_id` bigint(20) NOT NULL,
  `file_name` varchar(255) NOT NULL,
  `original_file_name` varchar(255) NOT NULL,
  `file_type` varchar(255) NOT NULL,
  `file_size` bigint(20) NOT NULL,
  `type` smallint(6) NOT NULL,
  `date_uploaded` datetime NOT NULL,
  `date_modified` datetime NOT NULL,
  `submission_id` bigint(20) DEFAULT NULL,
  `public_access` smallint(6) DEFAULT 0,
  PRIMARY KEY (`file_id`),
  KEY `library_files_context_id` (`context_id`),
  KEY `library_files_submission_id` (`submission_id`),
  CONSTRAINT `library_files_context_id` FOREIGN KEY (`context_id`) REFERENCES `journals` (`journal_id`) ON DELETE CASCADE,
  CONSTRAINT `library_files_submission_id_foreign` FOREIGN KEY (`submission_id`) REFERENCES `submissions` (`submission_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Library files can be associated with the context (press/server/journal) or with individual submissions, and are typically forms, agreements, and other administrative documents that are not part of the scholarly content.';

-- ----------------------------
-- Records of library_files
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for metrics_context
-- ----------------------------
DROP TABLE IF EXISTS `metrics_context`;
CREATE TABLE `metrics_context` (
  `metrics_context_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `load_id` varchar(255) NOT NULL,
  `context_id` bigint(20) NOT NULL,
  `date` date NOT NULL,
  `metric` int(11) NOT NULL,
  PRIMARY KEY (`metrics_context_id`),
  KEY `metrics_context_load_id` (`load_id`),
  KEY `metrics_context_context_id` (`context_id`),
  CONSTRAINT `metrics_context_context_id_foreign` FOREIGN KEY (`context_id`) REFERENCES `journals` (`journal_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Daily statistics for views of the homepage.';

-- ----------------------------
-- Records of metrics_context
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for metrics_counter_submission_daily
-- ----------------------------
DROP TABLE IF EXISTS `metrics_counter_submission_daily`;
CREATE TABLE `metrics_counter_submission_daily` (
  `metrics_counter_submission_daily_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `load_id` varchar(255) NOT NULL,
  `context_id` bigint(20) NOT NULL,
  `submission_id` bigint(20) NOT NULL,
  `date` date NOT NULL,
  `metric_investigations` int(11) NOT NULL,
  `metric_investigations_unique` int(11) NOT NULL,
  `metric_requests` int(11) NOT NULL,
  `metric_requests_unique` int(11) NOT NULL,
  PRIMARY KEY (`metrics_counter_submission_daily_id`),
  UNIQUE KEY `msd_uc_load_id_context_id_submission_id_date` (`load_id`,`context_id`,`submission_id`,`date`),
  KEY `msd_load_id` (`load_id`),
  KEY `metrics_counter_submission_daily_context_id` (`context_id`),
  KEY `metrics_counter_submission_daily_submission_id` (`submission_id`),
  KEY `msd_context_id_submission_id` (`context_id`,`submission_id`),
  CONSTRAINT `msd_context_id_foreign` FOREIGN KEY (`context_id`) REFERENCES `journals` (`journal_id`) ON DELETE CASCADE,
  CONSTRAINT `msd_submission_id_foreign` FOREIGN KEY (`submission_id`) REFERENCES `submissions` (`submission_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Daily statistics matching the COUNTER R5 protocol for views and downloads of published submissions and galleys.';

-- ----------------------------
-- Records of metrics_counter_submission_daily
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for metrics_counter_submission_institution_daily
-- ----------------------------
DROP TABLE IF EXISTS `metrics_counter_submission_institution_daily`;
CREATE TABLE `metrics_counter_submission_institution_daily` (
  `metrics_counter_submission_institution_daily_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `load_id` varchar(255) NOT NULL,
  `context_id` bigint(20) NOT NULL,
  `submission_id` bigint(20) NOT NULL,
  `institution_id` bigint(20) NOT NULL,
  `date` date NOT NULL,
  `metric_investigations` int(11) NOT NULL,
  `metric_investigations_unique` int(11) NOT NULL,
  `metric_requests` int(11) NOT NULL,
  `metric_requests_unique` int(11) NOT NULL,
  PRIMARY KEY (`metrics_counter_submission_institution_daily_id`),
  UNIQUE KEY `msid_uc_load_id_context_id_submission_id_institution_id_date` (`load_id`,`context_id`,`submission_id`,`institution_id`,`date`),
  KEY `msid_load_id` (`load_id`),
  KEY `metrics_counter_submission_institution_daily_context_id` (`context_id`),
  KEY `metrics_counter_submission_institution_daily_submission_id` (`submission_id`),
  KEY `metrics_counter_submission_institution_daily_institution_id` (`institution_id`),
  KEY `msid_context_id_submission_id` (`context_id`,`submission_id`),
  CONSTRAINT `msid_context_id_foreign` FOREIGN KEY (`context_id`) REFERENCES `journals` (`journal_id`) ON DELETE CASCADE,
  CONSTRAINT `msid_institution_id_foreign` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`institution_id`) ON DELETE CASCADE,
  CONSTRAINT `msid_submission_id_foreign` FOREIGN KEY (`submission_id`) REFERENCES `submissions` (`submission_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Daily statistics matching the COUNTER R5 protocol for views and downloads from institutions.';

-- ----------------------------
-- Records of metrics_counter_submission_institution_daily
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for metrics_counter_submission_institution_monthly
-- ----------------------------
DROP TABLE IF EXISTS `metrics_counter_submission_institution_monthly`;
CREATE TABLE `metrics_counter_submission_institution_monthly` (
  `metrics_counter_submission_institution_monthly_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `context_id` bigint(20) NOT NULL,
  `submission_id` bigint(20) NOT NULL,
  `institution_id` bigint(20) NOT NULL,
  `month` int(11) NOT NULL,
  `metric_investigations` int(11) NOT NULL,
  `metric_investigations_unique` int(11) NOT NULL,
  `metric_requests` int(11) NOT NULL,
  `metric_requests_unique` int(11) NOT NULL,
  PRIMARY KEY (`metrics_counter_submission_institution_monthly_id`),
  UNIQUE KEY `msim_uc_context_id_submission_id_institution_id_month` (`context_id`,`submission_id`,`institution_id`,`month`),
  KEY `metrics_counter_submission_institution_monthly_context_id` (`context_id`),
  KEY `metrics_counter_submission_institution_monthly_submission_id` (`submission_id`),
  KEY `metrics_counter_submission_institution_monthly_institution_id` (`institution_id`),
  KEY `msim_context_id_submission_id` (`context_id`,`submission_id`),
  CONSTRAINT `msim_context_id_foreign` FOREIGN KEY (`context_id`) REFERENCES `journals` (`journal_id`) ON DELETE CASCADE,
  CONSTRAINT `msim_institution_id_foreign` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`institution_id`) ON DELETE CASCADE,
  CONSTRAINT `msim_submission_id_foreign` FOREIGN KEY (`submission_id`) REFERENCES `submissions` (`submission_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Monthly statistics matching the COUNTER R5 protocol for views and downloads from institutions.';

-- ----------------------------
-- Records of metrics_counter_submission_institution_monthly
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for metrics_counter_submission_monthly
-- ----------------------------
DROP TABLE IF EXISTS `metrics_counter_submission_monthly`;
CREATE TABLE `metrics_counter_submission_monthly` (
  `metrics_counter_submission_monthly_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `context_id` bigint(20) NOT NULL,
  `submission_id` bigint(20) NOT NULL,
  `month` int(11) NOT NULL,
  `metric_investigations` int(11) NOT NULL,
  `metric_investigations_unique` int(11) NOT NULL,
  `metric_requests` int(11) NOT NULL,
  `metric_requests_unique` int(11) NOT NULL,
  PRIMARY KEY (`metrics_counter_submission_monthly_id`),
  UNIQUE KEY `msm_uc_context_id_submission_id_month` (`context_id`,`submission_id`,`month`),
  KEY `metrics_counter_submission_monthly_context_id` (`context_id`),
  KEY `metrics_counter_submission_monthly_submission_id` (`submission_id`),
  KEY `msm_context_id_submission_id` (`context_id`,`submission_id`),
  CONSTRAINT `msm_context_id_foreign` FOREIGN KEY (`context_id`) REFERENCES `journals` (`journal_id`) ON DELETE CASCADE,
  CONSTRAINT `msm_submission_id_foreign` FOREIGN KEY (`submission_id`) REFERENCES `submissions` (`submission_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Monthly statistics matching the COUNTER R5 protocol for views and downloads of published submissions and galleys.';

-- ----------------------------
-- Records of metrics_counter_submission_monthly
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for metrics_issue
-- ----------------------------
DROP TABLE IF EXISTS `metrics_issue`;
CREATE TABLE `metrics_issue` (
  `metrics_issue_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `load_id` varchar(255) NOT NULL,
  `context_id` bigint(20) NOT NULL,
  `issue_id` bigint(20) NOT NULL,
  `issue_galley_id` bigint(20) DEFAULT NULL,
  `date` date NOT NULL,
  `metric` int(11) NOT NULL,
  PRIMARY KEY (`metrics_issue_id`),
  KEY `metrics_issue_load_id` (`load_id`),
  KEY `metrics_issue_context_id` (`context_id`),
  KEY `metrics_issue_issue_id` (`issue_id`),
  KEY `metrics_issue_issue_galley_id` (`issue_galley_id`),
  KEY `metrics_issue_context_id_issue_id` (`context_id`,`issue_id`),
  CONSTRAINT `metrics_issue_context_id_foreign` FOREIGN KEY (`context_id`) REFERENCES `journals` (`journal_id`) ON DELETE CASCADE,
  CONSTRAINT `metrics_issue_issue_galley_id_foreign` FOREIGN KEY (`issue_galley_id`) REFERENCES `issue_galleys` (`galley_id`) ON DELETE CASCADE,
  CONSTRAINT `metrics_issue_issue_id_foreign` FOREIGN KEY (`issue_id`) REFERENCES `issues` (`issue_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Daily statistics for views and downloads of published issues.';

-- ----------------------------
-- Records of metrics_issue
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for metrics_submission
-- ----------------------------
DROP TABLE IF EXISTS `metrics_submission`;
CREATE TABLE `metrics_submission` (
  `metrics_submission_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `load_id` varchar(255) NOT NULL,
  `context_id` bigint(20) NOT NULL,
  `submission_id` bigint(20) NOT NULL,
  `representation_id` bigint(20) DEFAULT NULL,
  `submission_file_id` bigint(20) unsigned DEFAULT NULL,
  `file_type` bigint(20) DEFAULT NULL,
  `assoc_type` bigint(20) NOT NULL,
  `date` date NOT NULL,
  `metric` int(11) NOT NULL,
  PRIMARY KEY (`metrics_submission_id`),
  KEY `ms_load_id` (`load_id`),
  KEY `metrics_submission_context_id` (`context_id`),
  KEY `metrics_submission_submission_id` (`submission_id`),
  KEY `metrics_submission_representation_id` (`representation_id`),
  KEY `metrics_submission_submission_file_id` (`submission_file_id`),
  KEY `ms_context_id_submission_id_assoc_type_file_type` (`context_id`,`submission_id`,`assoc_type`,`file_type`),
  CONSTRAINT `metrics_submission_context_id_foreign` FOREIGN KEY (`context_id`) REFERENCES `journals` (`journal_id`) ON DELETE CASCADE,
  CONSTRAINT `metrics_submission_representation_id_foreign` FOREIGN KEY (`representation_id`) REFERENCES `publication_galleys` (`galley_id`) ON DELETE CASCADE,
  CONSTRAINT `metrics_submission_submission_file_id_foreign` FOREIGN KEY (`submission_file_id`) REFERENCES `submission_files` (`submission_file_id`) ON DELETE CASCADE,
  CONSTRAINT `metrics_submission_submission_id_foreign` FOREIGN KEY (`submission_id`) REFERENCES `submissions` (`submission_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Daily statistics for views and downloads of published submissions and galleys.';

-- ----------------------------
-- Records of metrics_submission
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for metrics_submission_geo_daily
-- ----------------------------
DROP TABLE IF EXISTS `metrics_submission_geo_daily`;
CREATE TABLE `metrics_submission_geo_daily` (
  `metrics_submission_geo_daily_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `load_id` varchar(255) NOT NULL,
  `context_id` bigint(20) NOT NULL,
  `submission_id` bigint(20) NOT NULL,
  `country` varchar(2) NOT NULL DEFAULT '',
  `region` varchar(3) NOT NULL DEFAULT '',
  `city` varchar(255) NOT NULL DEFAULT '',
  `date` date NOT NULL,
  `metric` int(11) NOT NULL,
  `metric_unique` int(11) NOT NULL,
  PRIMARY KEY (`metrics_submission_geo_daily_id`),
  UNIQUE KEY `msgd_uc_load_context_submission_c_r_c_date` (`load_id`,`context_id`,`submission_id`,`country`,`region`,`city`,`date`),
  KEY `msgd_load_id` (`load_id`),
  KEY `metrics_submission_geo_daily_context_id` (`context_id`),
  KEY `metrics_submission_geo_daily_submission_id` (`submission_id`),
  KEY `msgd_context_id_submission_id` (`context_id`,`submission_id`),
  CONSTRAINT `msgd_context_id_foreign` FOREIGN KEY (`context_id`) REFERENCES `journals` (`journal_id`) ON DELETE CASCADE,
  CONSTRAINT `msgd_submission_id_foreign` FOREIGN KEY (`submission_id`) REFERENCES `submissions` (`submission_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Daily statistics by country, region and city for views and downloads of published submissions and galleys.';

-- ----------------------------
-- Records of metrics_submission_geo_daily
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for metrics_submission_geo_monthly
-- ----------------------------
DROP TABLE IF EXISTS `metrics_submission_geo_monthly`;
CREATE TABLE `metrics_submission_geo_monthly` (
  `metrics_submission_geo_monthly_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `context_id` bigint(20) NOT NULL,
  `submission_id` bigint(20) NOT NULL,
  `country` varchar(2) NOT NULL DEFAULT '',
  `region` varchar(3) NOT NULL DEFAULT '',
  `city` varchar(255) NOT NULL DEFAULT '',
  `month` int(11) NOT NULL,
  `metric` int(11) NOT NULL,
  `metric_unique` int(11) NOT NULL,
  PRIMARY KEY (`metrics_submission_geo_monthly_id`),
  UNIQUE KEY `msgm_uc_context_submission_c_r_c_month` (`context_id`,`submission_id`,`country`,`region`,`city`,`month`),
  KEY `metrics_submission_geo_monthly_context_id` (`context_id`),
  KEY `metrics_submission_geo_monthly_submission_id` (`submission_id`),
  KEY `msgm_context_id_submission_id` (`context_id`,`submission_id`),
  CONSTRAINT `msgm_context_id_foreign` FOREIGN KEY (`context_id`) REFERENCES `journals` (`journal_id`) ON DELETE CASCADE,
  CONSTRAINT `msgm_submission_id_foreign` FOREIGN KEY (`submission_id`) REFERENCES `submissions` (`submission_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Monthly statistics by country, region and city for views and downloads of published submissions and galleys.';

-- ----------------------------
-- Records of metrics_submission_geo_monthly
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for navigation_menu_item_assignment_settings
-- ----------------------------
DROP TABLE IF EXISTS `navigation_menu_item_assignment_settings`;
CREATE TABLE `navigation_menu_item_assignment_settings` (
  `navigation_menu_item_assignment_setting_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `navigation_menu_item_assignment_id` bigint(20) NOT NULL,
  `locale` varchar(14) NOT NULL DEFAULT '',
  `setting_name` varchar(255) NOT NULL,
  `setting_value` mediumtext DEFAULT NULL,
  `setting_type` varchar(6) NOT NULL,
  PRIMARY KEY (`navigation_menu_item_assignment_setting_id`),
  UNIQUE KEY `navigation_menu_item_assignment_settings_unique` (`navigation_menu_item_assignment_id`,`locale`,`setting_name`),
  KEY `navigation_menu_item_assignment_settings_n_m_i_a_id` (`navigation_menu_item_assignment_id`),
  CONSTRAINT `assignment_settings_navigation_menu_item_assignment_id` FOREIGN KEY (`navigation_menu_item_assignment_id`) REFERENCES `navigation_menu_item_assignments` (`navigation_menu_item_assignment_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='More data about navigation menu item assignments to navigation menus, including localized content.';

-- ----------------------------
-- Records of navigation_menu_item_assignment_settings
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for navigation_menu_item_assignments
-- ----------------------------
DROP TABLE IF EXISTS `navigation_menu_item_assignments`;
CREATE TABLE `navigation_menu_item_assignments` (
  `navigation_menu_item_assignment_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `navigation_menu_id` bigint(20) NOT NULL,
  `navigation_menu_item_id` bigint(20) NOT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `seq` bigint(20) DEFAULT 0,
  PRIMARY KEY (`navigation_menu_item_assignment_id`),
  KEY `navigation_menu_item_assignments_navigation_menu_id` (`navigation_menu_id`),
  KEY `navigation_menu_item_assignments_navigation_menu_item_id` (`navigation_menu_item_id`),
  CONSTRAINT `navigation_menu_item_assignments_navigation_menu_id_foreign` FOREIGN KEY (`navigation_menu_id`) REFERENCES `navigation_menus` (`navigation_menu_id`) ON DELETE CASCADE,
  CONSTRAINT `navigation_menu_item_assignments_navigation_menu_item_id_foreign` FOREIGN KEY (`navigation_menu_item_id`) REFERENCES `navigation_menu_items` (`navigation_menu_item_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Links navigation menu items to navigation menus.';

-- ----------------------------
-- Records of navigation_menu_item_assignments
-- ----------------------------
BEGIN;
INSERT INTO `navigation_menu_item_assignments` (`navigation_menu_item_assignment_id`, `navigation_menu_id`, `navigation_menu_item_id`, `parent_id`, `seq`) VALUES (1, 1, 1, 0, 0);
INSERT INTO `navigation_menu_item_assignments` (`navigation_menu_item_assignment_id`, `navigation_menu_id`, `navigation_menu_item_id`, `parent_id`, `seq`) VALUES (2, 1, 2, 0, 1);
INSERT INTO `navigation_menu_item_assignments` (`navigation_menu_item_assignment_id`, `navigation_menu_id`, `navigation_menu_item_id`, `parent_id`, `seq`) VALUES (3, 1, 3, 0, 2);
INSERT INTO `navigation_menu_item_assignments` (`navigation_menu_item_assignment_id`, `navigation_menu_id`, `navigation_menu_item_id`, `parent_id`, `seq`) VALUES (4, 1, 4, 3, 0);
INSERT INTO `navigation_menu_item_assignments` (`navigation_menu_item_assignment_id`, `navigation_menu_id`, `navigation_menu_item_id`, `parent_id`, `seq`) VALUES (5, 1, 5, 3, 1);
INSERT INTO `navigation_menu_item_assignments` (`navigation_menu_item_assignment_id`, `navigation_menu_id`, `navigation_menu_item_id`, `parent_id`, `seq`) VALUES (6, 1, 6, 3, 2);
INSERT INTO `navigation_menu_item_assignments` (`navigation_menu_item_assignment_id`, `navigation_menu_id`, `navigation_menu_item_id`, `parent_id`, `seq`) VALUES (7, 1, 7, 3, 3);
INSERT INTO `navigation_menu_item_assignments` (`navigation_menu_item_assignment_id`, `navigation_menu_id`, `navigation_menu_item_id`, `parent_id`, `seq`) VALUES (8, 2, 8, 0, 0);
INSERT INTO `navigation_menu_item_assignments` (`navigation_menu_item_assignment_id`, `navigation_menu_id`, `navigation_menu_item_id`, `parent_id`, `seq`) VALUES (9, 2, 9, 0, 1);
INSERT INTO `navigation_menu_item_assignments` (`navigation_menu_item_assignment_id`, `navigation_menu_id`, `navigation_menu_item_id`, `parent_id`, `seq`) VALUES (10, 2, 10, 0, 2);
INSERT INTO `navigation_menu_item_assignments` (`navigation_menu_item_assignment_id`, `navigation_menu_id`, `navigation_menu_item_id`, `parent_id`, `seq`) VALUES (11, 2, 11, 10, 0);
INSERT INTO `navigation_menu_item_assignments` (`navigation_menu_item_assignment_id`, `navigation_menu_id`, `navigation_menu_item_id`, `parent_id`, `seq`) VALUES (12, 2, 12, 10, 1);
INSERT INTO `navigation_menu_item_assignments` (`navigation_menu_item_assignment_id`, `navigation_menu_id`, `navigation_menu_item_id`, `parent_id`, `seq`) VALUES (13, 2, 13, 10, 2);
INSERT INTO `navigation_menu_item_assignments` (`navigation_menu_item_assignment_id`, `navigation_menu_id`, `navigation_menu_item_id`, `parent_id`, `seq`) VALUES (14, 2, 14, 10, 3);
INSERT INTO `navigation_menu_item_assignments` (`navigation_menu_item_assignment_id`, `navigation_menu_id`, `navigation_menu_item_id`, `parent_id`, `seq`) VALUES (15, 3, 15, 0, 0);
INSERT INTO `navigation_menu_item_assignments` (`navigation_menu_item_assignment_id`, `navigation_menu_id`, `navigation_menu_item_id`, `parent_id`, `seq`) VALUES (16, 3, 16, 0, 1);
INSERT INTO `navigation_menu_item_assignments` (`navigation_menu_item_assignment_id`, `navigation_menu_id`, `navigation_menu_item_id`, `parent_id`, `seq`) VALUES (17, 3, 17, 0, 2);
INSERT INTO `navigation_menu_item_assignments` (`navigation_menu_item_assignment_id`, `navigation_menu_id`, `navigation_menu_item_id`, `parent_id`, `seq`) VALUES (18, 3, 18, 0, 3);
INSERT INTO `navigation_menu_item_assignments` (`navigation_menu_item_assignment_id`, `navigation_menu_id`, `navigation_menu_item_id`, `parent_id`, `seq`) VALUES (19, 3, 19, 18, 0);
INSERT INTO `navigation_menu_item_assignments` (`navigation_menu_item_assignment_id`, `navigation_menu_id`, `navigation_menu_item_id`, `parent_id`, `seq`) VALUES (20, 3, 20, 18, 1);
INSERT INTO `navigation_menu_item_assignments` (`navigation_menu_item_assignment_id`, `navigation_menu_id`, `navigation_menu_item_id`, `parent_id`, `seq`) VALUES (21, 3, 21, 18, 2);
INSERT INTO `navigation_menu_item_assignments` (`navigation_menu_item_assignment_id`, `navigation_menu_id`, `navigation_menu_item_id`, `parent_id`, `seq`) VALUES (22, 3, 22, 18, 3);
INSERT INTO `navigation_menu_item_assignments` (`navigation_menu_item_assignment_id`, `navigation_menu_id`, `navigation_menu_item_id`, `parent_id`, `seq`) VALUES (23, 3, 23, 18, 4);
COMMIT;

-- ----------------------------
-- Table structure for navigation_menu_item_settings
-- ----------------------------
DROP TABLE IF EXISTS `navigation_menu_item_settings`;
CREATE TABLE `navigation_menu_item_settings` (
  `navigation_menu_item_setting_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `navigation_menu_item_id` bigint(20) NOT NULL,
  `locale` varchar(14) NOT NULL DEFAULT '',
  `setting_name` varchar(255) NOT NULL,
  `setting_value` longtext DEFAULT NULL,
  `setting_type` varchar(6) NOT NULL,
  PRIMARY KEY (`navigation_menu_item_setting_id`),
  UNIQUE KEY `navigation_menu_item_settings_unique` (`navigation_menu_item_id`,`locale`,`setting_name`),
  KEY `navigation_menu_item_settings_navigation_menu_item_id` (`navigation_menu_item_id`),
  CONSTRAINT `navigation_menu_item_settings_navigation_menu_id` FOREIGN KEY (`navigation_menu_item_id`) REFERENCES `navigation_menu_items` (`navigation_menu_item_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='More data about navigation menu items, including localized content such as names.';

-- ----------------------------
-- Records of navigation_menu_item_settings
-- ----------------------------
BEGIN;
INSERT INTO `navigation_menu_item_settings` (`navigation_menu_item_setting_id`, `navigation_menu_item_id`, `locale`, `setting_name`, `setting_value`, `setting_type`) VALUES (1, 1, '', 'titleLocaleKey', 'navigation.register', 'string');
INSERT INTO `navigation_menu_item_settings` (`navigation_menu_item_setting_id`, `navigation_menu_item_id`, `locale`, `setting_name`, `setting_value`, `setting_type`) VALUES (2, 2, '', 'titleLocaleKey', 'navigation.login', 'string');
INSERT INTO `navigation_menu_item_settings` (`navigation_menu_item_setting_id`, `navigation_menu_item_id`, `locale`, `setting_name`, `setting_value`, `setting_type`) VALUES (3, 3, '', 'titleLocaleKey', '{$loggedInUsername}', 'string');
INSERT INTO `navigation_menu_item_settings` (`navigation_menu_item_setting_id`, `navigation_menu_item_id`, `locale`, `setting_name`, `setting_value`, `setting_type`) VALUES (4, 4, '', 'titleLocaleKey', 'navigation.dashboard', 'string');
INSERT INTO `navigation_menu_item_settings` (`navigation_menu_item_setting_id`, `navigation_menu_item_id`, `locale`, `setting_name`, `setting_value`, `setting_type`) VALUES (5, 5, '', 'titleLocaleKey', 'common.viewProfile', 'string');
INSERT INTO `navigation_menu_item_settings` (`navigation_menu_item_setting_id`, `navigation_menu_item_id`, `locale`, `setting_name`, `setting_value`, `setting_type`) VALUES (6, 6, '', 'titleLocaleKey', 'navigation.admin', 'string');
INSERT INTO `navigation_menu_item_settings` (`navigation_menu_item_setting_id`, `navigation_menu_item_id`, `locale`, `setting_name`, `setting_value`, `setting_type`) VALUES (7, 7, '', 'titleLocaleKey', 'user.logOut', 'string');
INSERT INTO `navigation_menu_item_settings` (`navigation_menu_item_setting_id`, `navigation_menu_item_id`, `locale`, `setting_name`, `setting_value`, `setting_type`) VALUES (8, 8, '', 'titleLocaleKey', 'navigation.register', 'string');
INSERT INTO `navigation_menu_item_settings` (`navigation_menu_item_setting_id`, `navigation_menu_item_id`, `locale`, `setting_name`, `setting_value`, `setting_type`) VALUES (9, 9, '', 'titleLocaleKey', 'navigation.login', 'string');
INSERT INTO `navigation_menu_item_settings` (`navigation_menu_item_setting_id`, `navigation_menu_item_id`, `locale`, `setting_name`, `setting_value`, `setting_type`) VALUES (10, 10, '', 'titleLocaleKey', '{$loggedInUsername}', 'string');
INSERT INTO `navigation_menu_item_settings` (`navigation_menu_item_setting_id`, `navigation_menu_item_id`, `locale`, `setting_name`, `setting_value`, `setting_type`) VALUES (11, 11, '', 'titleLocaleKey', 'navigation.dashboard', 'string');
INSERT INTO `navigation_menu_item_settings` (`navigation_menu_item_setting_id`, `navigation_menu_item_id`, `locale`, `setting_name`, `setting_value`, `setting_type`) VALUES (12, 12, '', 'titleLocaleKey', 'common.viewProfile', 'string');
INSERT INTO `navigation_menu_item_settings` (`navigation_menu_item_setting_id`, `navigation_menu_item_id`, `locale`, `setting_name`, `setting_value`, `setting_type`) VALUES (13, 13, '', 'titleLocaleKey', 'navigation.admin', 'string');
INSERT INTO `navigation_menu_item_settings` (`navigation_menu_item_setting_id`, `navigation_menu_item_id`, `locale`, `setting_name`, `setting_value`, `setting_type`) VALUES (14, 14, '', 'titleLocaleKey', 'user.logOut', 'string');
INSERT INTO `navigation_menu_item_settings` (`navigation_menu_item_setting_id`, `navigation_menu_item_id`, `locale`, `setting_name`, `setting_value`, `setting_type`) VALUES (15, 15, '', 'titleLocaleKey', 'navigation.current', 'string');
INSERT INTO `navigation_menu_item_settings` (`navigation_menu_item_setting_id`, `navigation_menu_item_id`, `locale`, `setting_name`, `setting_value`, `setting_type`) VALUES (16, 16, '', 'titleLocaleKey', 'navigation.archives', 'string');
INSERT INTO `navigation_menu_item_settings` (`navigation_menu_item_setting_id`, `navigation_menu_item_id`, `locale`, `setting_name`, `setting_value`, `setting_type`) VALUES (17, 17, '', 'titleLocaleKey', 'manager.announcements', 'string');
INSERT INTO `navigation_menu_item_settings` (`navigation_menu_item_setting_id`, `navigation_menu_item_id`, `locale`, `setting_name`, `setting_value`, `setting_type`) VALUES (18, 18, '', 'titleLocaleKey', 'navigation.about', 'string');
INSERT INTO `navigation_menu_item_settings` (`navigation_menu_item_setting_id`, `navigation_menu_item_id`, `locale`, `setting_name`, `setting_value`, `setting_type`) VALUES (19, 19, '', 'titleLocaleKey', 'about.aboutContext', 'string');
INSERT INTO `navigation_menu_item_settings` (`navigation_menu_item_setting_id`, `navigation_menu_item_id`, `locale`, `setting_name`, `setting_value`, `setting_type`) VALUES (20, 20, '', 'titleLocaleKey', 'about.submissions', 'string');
INSERT INTO `navigation_menu_item_settings` (`navigation_menu_item_setting_id`, `navigation_menu_item_id`, `locale`, `setting_name`, `setting_value`, `setting_type`) VALUES (21, 21, '', 'titleLocaleKey', 'about.editorialTeam', 'string');
INSERT INTO `navigation_menu_item_settings` (`navigation_menu_item_setting_id`, `navigation_menu_item_id`, `locale`, `setting_name`, `setting_value`, `setting_type`) VALUES (22, 22, '', 'titleLocaleKey', 'manager.setup.privacyStatement', 'string');
INSERT INTO `navigation_menu_item_settings` (`navigation_menu_item_setting_id`, `navigation_menu_item_id`, `locale`, `setting_name`, `setting_value`, `setting_type`) VALUES (23, 23, '', 'titleLocaleKey', 'about.contact', 'string');
INSERT INTO `navigation_menu_item_settings` (`navigation_menu_item_setting_id`, `navigation_menu_item_id`, `locale`, `setting_name`, `setting_value`, `setting_type`) VALUES (24, 24, '', 'titleLocaleKey', 'common.search', 'string');
COMMIT;

-- ----------------------------
-- Table structure for navigation_menu_items
-- ----------------------------
DROP TABLE IF EXISTS `navigation_menu_items`;
CREATE TABLE `navigation_menu_items` (
  `navigation_menu_item_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `context_id` bigint(20) NOT NULL,
  `path` varchar(255) DEFAULT '',
  `type` varchar(255) DEFAULT '',
  PRIMARY KEY (`navigation_menu_item_id`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Navigation menu items are single elements within a navigation menu.';

-- ----------------------------
-- Records of navigation_menu_items
-- ----------------------------
BEGIN;
INSERT INTO `navigation_menu_items` (`navigation_menu_item_id`, `context_id`, `path`, `type`) VALUES (1, 0, NULL, 'NMI_TYPE_USER_REGISTER');
INSERT INTO `navigation_menu_items` (`navigation_menu_item_id`, `context_id`, `path`, `type`) VALUES (2, 0, NULL, 'NMI_TYPE_USER_LOGIN');
INSERT INTO `navigation_menu_items` (`navigation_menu_item_id`, `context_id`, `path`, `type`) VALUES (3, 0, NULL, 'NMI_TYPE_USER_DASHBOARD');
INSERT INTO `navigation_menu_items` (`navigation_menu_item_id`, `context_id`, `path`, `type`) VALUES (4, 0, NULL, 'NMI_TYPE_USER_DASHBOARD');
INSERT INTO `navigation_menu_items` (`navigation_menu_item_id`, `context_id`, `path`, `type`) VALUES (5, 0, NULL, 'NMI_TYPE_USER_PROFILE');
INSERT INTO `navigation_menu_items` (`navigation_menu_item_id`, `context_id`, `path`, `type`) VALUES (6, 0, NULL, 'NMI_TYPE_ADMINISTRATION');
INSERT INTO `navigation_menu_items` (`navigation_menu_item_id`, `context_id`, `path`, `type`) VALUES (7, 0, NULL, 'NMI_TYPE_USER_LOGOUT');
INSERT INTO `navigation_menu_items` (`navigation_menu_item_id`, `context_id`, `path`, `type`) VALUES (8, 1, NULL, 'NMI_TYPE_USER_REGISTER');
INSERT INTO `navigation_menu_items` (`navigation_menu_item_id`, `context_id`, `path`, `type`) VALUES (9, 1, NULL, 'NMI_TYPE_USER_LOGIN');
INSERT INTO `navigation_menu_items` (`navigation_menu_item_id`, `context_id`, `path`, `type`) VALUES (10, 1, NULL, 'NMI_TYPE_USER_DASHBOARD');
INSERT INTO `navigation_menu_items` (`navigation_menu_item_id`, `context_id`, `path`, `type`) VALUES (11, 1, NULL, 'NMI_TYPE_USER_DASHBOARD');
INSERT INTO `navigation_menu_items` (`navigation_menu_item_id`, `context_id`, `path`, `type`) VALUES (12, 1, NULL, 'NMI_TYPE_USER_PROFILE');
INSERT INTO `navigation_menu_items` (`navigation_menu_item_id`, `context_id`, `path`, `type`) VALUES (13, 1, NULL, 'NMI_TYPE_ADMINISTRATION');
INSERT INTO `navigation_menu_items` (`navigation_menu_item_id`, `context_id`, `path`, `type`) VALUES (14, 1, NULL, 'NMI_TYPE_USER_LOGOUT');
INSERT INTO `navigation_menu_items` (`navigation_menu_item_id`, `context_id`, `path`, `type`) VALUES (15, 1, NULL, 'NMI_TYPE_CURRENT');
INSERT INTO `navigation_menu_items` (`navigation_menu_item_id`, `context_id`, `path`, `type`) VALUES (16, 1, NULL, 'NMI_TYPE_ARCHIVES');
INSERT INTO `navigation_menu_items` (`navigation_menu_item_id`, `context_id`, `path`, `type`) VALUES (17, 1, NULL, 'NMI_TYPE_ANNOUNCEMENTS');
INSERT INTO `navigation_menu_items` (`navigation_menu_item_id`, `context_id`, `path`, `type`) VALUES (18, 1, NULL, 'NMI_TYPE_ABOUT');
INSERT INTO `navigation_menu_items` (`navigation_menu_item_id`, `context_id`, `path`, `type`) VALUES (19, 1, NULL, 'NMI_TYPE_ABOUT');
INSERT INTO `navigation_menu_items` (`navigation_menu_item_id`, `context_id`, `path`, `type`) VALUES (20, 1, NULL, 'NMI_TYPE_SUBMISSIONS');
INSERT INTO `navigation_menu_items` (`navigation_menu_item_id`, `context_id`, `path`, `type`) VALUES (21, 1, NULL, 'NMI_TYPE_EDITORIAL_TEAM');
INSERT INTO `navigation_menu_items` (`navigation_menu_item_id`, `context_id`, `path`, `type`) VALUES (22, 1, NULL, 'NMI_TYPE_PRIVACY');
INSERT INTO `navigation_menu_items` (`navigation_menu_item_id`, `context_id`, `path`, `type`) VALUES (23, 1, NULL, 'NMI_TYPE_CONTACT');
INSERT INTO `navigation_menu_items` (`navigation_menu_item_id`, `context_id`, `path`, `type`) VALUES (24, 1, NULL, 'NMI_TYPE_SEARCH');
COMMIT;

-- ----------------------------
-- Table structure for navigation_menus
-- ----------------------------
DROP TABLE IF EXISTS `navigation_menus`;
CREATE TABLE `navigation_menus` (
  `navigation_menu_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `context_id` bigint(20) NOT NULL,
  `area_name` varchar(255) DEFAULT '',
  `title` varchar(255) NOT NULL,
  PRIMARY KEY (`navigation_menu_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Navigation menus on the website are installed with the software as a default set, and can be customized.';

-- ----------------------------
-- Records of navigation_menus
-- ----------------------------
BEGIN;
INSERT INTO `navigation_menus` (`navigation_menu_id`, `context_id`, `area_name`, `title`) VALUES (1, 0, 'user', 'User Navigation Menu');
INSERT INTO `navigation_menus` (`navigation_menu_id`, `context_id`, `area_name`, `title`) VALUES (2, 1, 'user', 'User Navigation Menu');
INSERT INTO `navigation_menus` (`navigation_menu_id`, `context_id`, `area_name`, `title`) VALUES (3, 1, 'primary', 'Primary Navigation Menu');
COMMIT;

-- ----------------------------
-- Table structure for notes
-- ----------------------------
DROP TABLE IF EXISTS `notes`;
CREATE TABLE `notes` (
  `note_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `assoc_type` bigint(20) NOT NULL,
  `assoc_id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `date_created` datetime NOT NULL,
  `date_modified` datetime DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `contents` text DEFAULT NULL,
  PRIMARY KEY (`note_id`),
  KEY `notes_user_id` (`user_id`),
  KEY `notes_assoc` (`assoc_type`,`assoc_id`),
  CONSTRAINT `notes_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Notes allow users to annotate associated entities, such as submissions.';

-- ----------------------------
-- Records of notes
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for notification_settings
-- ----------------------------
DROP TABLE IF EXISTS `notification_settings`;
CREATE TABLE `notification_settings` (
  `notification_setting_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `notification_id` bigint(20) NOT NULL,
  `locale` varchar(14) DEFAULT NULL,
  `setting_name` varchar(64) NOT NULL,
  `setting_value` mediumtext NOT NULL,
  `setting_type` varchar(6) NOT NULL COMMENT '(bool|int|float|string|object)',
  PRIMARY KEY (`notification_setting_id`),
  UNIQUE KEY `notification_settings_unique` (`notification_id`,`locale`,`setting_name`),
  KEY `notification_settings_notification_id` (`notification_id`),
  CONSTRAINT `notification_settings_notification_id_foreign` FOREIGN KEY (`notification_id`) REFERENCES `notifications` (`notification_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='More data about notifications, including localized properties.';

-- ----------------------------
-- Records of notification_settings
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for notification_subscription_settings
-- ----------------------------
DROP TABLE IF EXISTS `notification_subscription_settings`;
CREATE TABLE `notification_subscription_settings` (
  `setting_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `setting_name` varchar(64) NOT NULL,
  `setting_value` mediumtext NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `context` bigint(20) NOT NULL,
  `setting_type` varchar(6) NOT NULL COMMENT '(bool|int|float|string|object)',
  PRIMARY KEY (`setting_id`),
  KEY `notification_subscription_settings_user_id` (`user_id`),
  KEY `notification_subscription_settings_context` (`context`),
  CONSTRAINT `notification_subscription_settings_context_foreign` FOREIGN KEY (`context`) REFERENCES `journals` (`journal_id`) ON DELETE CASCADE,
  CONSTRAINT `notification_subscription_settings_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Which email notifications a user has chosen to unsubscribe from.';

-- ----------------------------
-- Records of notification_subscription_settings
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for notifications
-- ----------------------------
DROP TABLE IF EXISTS `notifications`;
CREATE TABLE `notifications` (
  `notification_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `context_id` bigint(20) DEFAULT NULL,
  `user_id` bigint(20) DEFAULT NULL,
  `level` bigint(20) NOT NULL,
  `type` bigint(20) NOT NULL,
  `date_created` datetime NOT NULL,
  `date_read` datetime DEFAULT NULL,
  `assoc_type` bigint(20) DEFAULT NULL,
  `assoc_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`notification_id`),
  KEY `notifications_context_id` (`context_id`),
  KEY `notifications_user_id` (`user_id`),
  KEY `notifications_context_id_user_id` (`context_id`,`user_id`,`level`),
  KEY `notifications_context_id_level` (`context_id`,`level`),
  KEY `notifications_assoc` (`assoc_type`,`assoc_id`),
  KEY `notifications_user_id_level` (`user_id`,`level`),
  CONSTRAINT `notifications_context_id_foreign` FOREIGN KEY (`context_id`) REFERENCES `journals` (`journal_id`) ON DELETE CASCADE,
  CONSTRAINT `notifications_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='User notifications created during certain operations.';

-- ----------------------------
-- Records of notifications
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for oai_resumption_tokens
-- ----------------------------
DROP TABLE IF EXISTS `oai_resumption_tokens`;
CREATE TABLE `oai_resumption_tokens` (
  `oai_resumption_token_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `token` varchar(32) NOT NULL,
  `expire` bigint(20) NOT NULL,
  `record_offset` int(11) NOT NULL,
  `params` text DEFAULT NULL,
  PRIMARY KEY (`oai_resumption_token_id`),
  UNIQUE KEY `oai_resumption_tokens_unique` (`token`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='OAI resumption tokens are used to allow for pagination of large result sets into manageable pieces.';

-- ----------------------------
-- Records of oai_resumption_tokens
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for plugin_settings
-- ----------------------------
DROP TABLE IF EXISTS `plugin_settings`;
CREATE TABLE `plugin_settings` (
  `plugin_setting_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `plugin_name` varchar(80) NOT NULL,
  `context_id` bigint(20) NOT NULL,
  `setting_name` varchar(80) NOT NULL,
  `setting_value` mediumtext DEFAULT NULL,
  `setting_type` varchar(6) NOT NULL COMMENT '(bool|int|float|string|object)',
  PRIMARY KEY (`plugin_setting_id`),
  UNIQUE KEY `plugin_settings_unique` (`plugin_name`,`context_id`,`setting_name`),
  KEY `plugin_settings_plugin_name` (`plugin_name`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='More data about plugins, including localized properties. This table is frequently used to store plugin-specific configuration.';

-- ----------------------------
-- Records of plugin_settings
-- ----------------------------
BEGIN;
INSERT INTO `plugin_settings` (`plugin_setting_id`, `plugin_name`, `context_id`, `setting_name`, `setting_value`, `setting_type`) VALUES (1, 'defaultthemeplugin', 0, 'enabled', '1', 'bool');
INSERT INTO `plugin_settings` (`plugin_setting_id`, `plugin_name`, `context_id`, `setting_name`, `setting_value`, `setting_type`) VALUES (2, 'acronplugin', 0, 'enabled', '1', 'bool');
INSERT INTO `plugin_settings` (`plugin_setting_id`, `plugin_name`, `context_id`, `setting_name`, `setting_value`, `setting_type`) VALUES (3, 'acronplugin', 0, 'crontab', '[{\"className\":\"PKP\\\\task\\\\ReviewReminder\",\"frequency\":{\"hour\":24},\"args\":[]},{\"className\":\"PKP\\\\task\\\\StatisticsReport\",\"frequency\":{\"day\":\"1\"},\"args\":[]},{\"className\":\"APP\\\\tasks\\\\SubscriptionExpiryReminder\",\"frequency\":{\"day\":\"1\"},\"args\":[]},{\"className\":\"PKP\\\\task\\\\DepositDois\",\"frequency\":{\"hour\":24},\"args\":[]},{\"className\":\"PKP\\\\task\\\\RemoveUnvalidatedExpiredUsers\",\"frequency\":{\"day\":\"1\"},\"args\":[]},{\"className\":\"PKP\\\\task\\\\EditorialReminders\",\"frequency\":{\"day\":\"1\"},\"args\":[]},{\"className\":\"PKP\\\\task\\\\UpdateIPGeoDB\",\"frequency\":{\"day\":\"10\"},\"args\":[]},{\"className\":\"APP\\\\tasks\\\\UsageStatsLoader\",\"frequency\":{\"hour\":24},\"args\":[]},{\"className\":\"PKP\\\\task\\\\ProcessQueueJobs\",\"frequency\":{\"hour\":24},\"args\":[]},{\"className\":\"PKP\\\\task\\\\RemoveFailedJobs\",\"frequency\":{\"day\":\"1\"},\"args\":[]},{\"className\":\"APP\\\\tasks\\\\OpenAccessNotification\",\"frequency\":{\"hour\":24},\"args\":[]}]', 'object');
INSERT INTO `plugin_settings` (`plugin_setting_id`, `plugin_name`, `context_id`, `setting_name`, `setting_value`, `setting_type`) VALUES (4, 'usageeventplugin', 0, 'enabled', '1', 'bool');
INSERT INTO `plugin_settings` (`plugin_setting_id`, `plugin_name`, `context_id`, `setting_name`, `setting_value`, `setting_type`) VALUES (5, 'usageeventplugin', 0, 'uniqueSiteId', '', 'string');
INSERT INTO `plugin_settings` (`plugin_setting_id`, `plugin_name`, `context_id`, `setting_name`, `setting_value`, `setting_type`) VALUES (6, 'tinymceplugin', 0, 'enabled', '1', 'bool');
INSERT INTO `plugin_settings` (`plugin_setting_id`, `plugin_name`, `context_id`, `setting_name`, `setting_value`, `setting_type`) VALUES (7, 'developedbyblockplugin', 0, 'enabled', '0', 'bool');
INSERT INTO `plugin_settings` (`plugin_setting_id`, `plugin_name`, `context_id`, `setting_name`, `setting_value`, `setting_type`) VALUES (8, 'developedbyblockplugin', 0, 'seq', '0', 'int');
INSERT INTO `plugin_settings` (`plugin_setting_id`, `plugin_name`, `context_id`, `setting_name`, `setting_value`, `setting_type`) VALUES (9, 'languagetoggleblockplugin', 0, 'enabled', '1', 'bool');
INSERT INTO `plugin_settings` (`plugin_setting_id`, `plugin_name`, `context_id`, `setting_name`, `setting_value`, `setting_type`) VALUES (10, 'languagetoggleblockplugin', 0, 'seq', '4', 'int');
INSERT INTO `plugin_settings` (`plugin_setting_id`, `plugin_name`, `context_id`, `setting_name`, `setting_value`, `setting_type`) VALUES (11, 'defaultthemeplugin', 1, 'enabled', '1', 'bool');
INSERT INTO `plugin_settings` (`plugin_setting_id`, `plugin_name`, `context_id`, `setting_name`, `setting_value`, `setting_type`) VALUES (12, 'tinymceplugin', 1, 'enabled', '1', 'bool');
INSERT INTO `plugin_settings` (`plugin_setting_id`, `plugin_name`, `context_id`, `setting_name`, `setting_value`, `setting_type`) VALUES (13, 'developedbyblockplugin', 1, 'enabled', '0', 'bool');
INSERT INTO `plugin_settings` (`plugin_setting_id`, `plugin_name`, `context_id`, `setting_name`, `setting_value`, `setting_type`) VALUES (14, 'developedbyblockplugin', 1, 'seq', '0', 'int');
INSERT INTO `plugin_settings` (`plugin_setting_id`, `plugin_name`, `context_id`, `setting_name`, `setting_value`, `setting_type`) VALUES (15, 'informationblockplugin', 1, 'enabled', '1', 'bool');
INSERT INTO `plugin_settings` (`plugin_setting_id`, `plugin_name`, `context_id`, `setting_name`, `setting_value`, `setting_type`) VALUES (16, 'informationblockplugin', 1, 'seq', '7', 'int');
INSERT INTO `plugin_settings` (`plugin_setting_id`, `plugin_name`, `context_id`, `setting_name`, `setting_value`, `setting_type`) VALUES (17, 'subscriptionblockplugin', 1, 'enabled', '1', 'bool');
INSERT INTO `plugin_settings` (`plugin_setting_id`, `plugin_name`, `context_id`, `setting_name`, `setting_value`, `setting_type`) VALUES (18, 'subscriptionblockplugin', 1, 'seq', '2', 'int');
INSERT INTO `plugin_settings` (`plugin_setting_id`, `plugin_name`, `context_id`, `setting_name`, `setting_value`, `setting_type`) VALUES (19, 'languagetoggleblockplugin', 1, 'enabled', '1', 'bool');
INSERT INTO `plugin_settings` (`plugin_setting_id`, `plugin_name`, `context_id`, `setting_name`, `setting_value`, `setting_type`) VALUES (20, 'languagetoggleblockplugin', 1, 'seq', '4', 'int');
INSERT INTO `plugin_settings` (`plugin_setting_id`, `plugin_name`, `context_id`, `setting_name`, `setting_value`, `setting_type`) VALUES (21, 'resolverplugin', 1, 'enabled', '1', 'bool');
INSERT INTO `plugin_settings` (`plugin_setting_id`, `plugin_name`, `context_id`, `setting_name`, `setting_value`, `setting_type`) VALUES (22, 'pdfjsviewerplugin', 1, 'enabled', '1', 'bool');
INSERT INTO `plugin_settings` (`plugin_setting_id`, `plugin_name`, `context_id`, `setting_name`, `setting_value`, `setting_type`) VALUES (23, 'webfeedplugin', 1, 'enabled', '1', 'bool');
INSERT INTO `plugin_settings` (`plugin_setting_id`, `plugin_name`, `context_id`, `setting_name`, `setting_value`, `setting_type`) VALUES (24, 'webfeedplugin', 1, 'displayPage', 'homepage', 'string');
INSERT INTO `plugin_settings` (`plugin_setting_id`, `plugin_name`, `context_id`, `setting_name`, `setting_value`, `setting_type`) VALUES (25, 'webfeedplugin', 1, 'displayItems', '1', 'bool');
INSERT INTO `plugin_settings` (`plugin_setting_id`, `plugin_name`, `context_id`, `setting_name`, `setting_value`, `setting_type`) VALUES (26, 'webfeedplugin', 1, 'recentItems', '30', 'int');
INSERT INTO `plugin_settings` (`plugin_setting_id`, `plugin_name`, `context_id`, `setting_name`, `setting_value`, `setting_type`) VALUES (27, 'webfeedplugin', 1, 'includeIdentifiers', '0', 'bool');
INSERT INTO `plugin_settings` (`plugin_setting_id`, `plugin_name`, `context_id`, `setting_name`, `setting_value`, `setting_type`) VALUES (28, 'googlescholarplugin', 1, 'enabled', '1', 'bool');
INSERT INTO `plugin_settings` (`plugin_setting_id`, `plugin_name`, `context_id`, `setting_name`, `setting_value`, `setting_type`) VALUES (29, 'lensgalleyplugin', 1, 'enabled', '1', 'bool');
INSERT INTO `plugin_settings` (`plugin_setting_id`, `plugin_name`, `context_id`, `setting_name`, `setting_value`, `setting_type`) VALUES (30, 'htmlarticlegalleyplugin', 1, 'enabled', '1', 'bool');
INSERT INTO `plugin_settings` (`plugin_setting_id`, `plugin_name`, `context_id`, `setting_name`, `setting_value`, `setting_type`) VALUES (31, 'dublincoremetaplugin', 1, 'enabled', '1', 'bool');
COMMIT;

-- ----------------------------
-- Table structure for publication_categories
-- ----------------------------
DROP TABLE IF EXISTS `publication_categories`;
CREATE TABLE `publication_categories` (
  `publication_category_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `publication_id` bigint(20) NOT NULL,
  `category_id` bigint(20) NOT NULL,
  PRIMARY KEY (`publication_category_id`),
  UNIQUE KEY `publication_categories_id` (`publication_id`,`category_id`),
  KEY `publication_categories_publication_id` (`publication_id`),
  KEY `publication_categories_category_id` (`category_id`),
  CONSTRAINT `publication_categories_category_id_foreign` FOREIGN KEY (`category_id`) REFERENCES `categories` (`category_id`) ON DELETE CASCADE,
  CONSTRAINT `publication_categories_publication_id_foreign` FOREIGN KEY (`publication_id`) REFERENCES `publications` (`publication_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Associates publications (and thus submissions) with categories.';

-- ----------------------------
-- Records of publication_categories
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for publication_galley_settings
-- ----------------------------
DROP TABLE IF EXISTS `publication_galley_settings`;
CREATE TABLE `publication_galley_settings` (
  `publication_galley_setting_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `galley_id` bigint(20) NOT NULL,
  `locale` varchar(14) NOT NULL DEFAULT '',
  `setting_name` varchar(255) NOT NULL,
  `setting_value` mediumtext DEFAULT NULL,
  PRIMARY KEY (`publication_galley_setting_id`),
  UNIQUE KEY `publication_galley_settings_unique` (`galley_id`,`locale`,`setting_name`),
  KEY `publication_galley_settings_galley_id` (`galley_id`),
  KEY `publication_galley_settings_name_value` (`setting_name`(50),`setting_value`(150)),
  CONSTRAINT `publication_galley_settings_galley_id` FOREIGN KEY (`galley_id`) REFERENCES `publication_galleys` (`galley_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='More data about publication galleys, including localized content such as labels.';

-- ----------------------------
-- Records of publication_galley_settings
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for publication_galleys
-- ----------------------------
DROP TABLE IF EXISTS `publication_galleys`;
CREATE TABLE `publication_galleys` (
  `galley_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `locale` varchar(14) DEFAULT NULL,
  `publication_id` bigint(20) NOT NULL,
  `label` varchar(255) DEFAULT NULL,
  `submission_file_id` bigint(20) unsigned DEFAULT NULL,
  `seq` double(8,2) NOT NULL DEFAULT 0.00,
  `remote_url` varchar(2047) DEFAULT NULL,
  `is_approved` smallint(6) NOT NULL DEFAULT 0,
  `url_path` varchar(64) DEFAULT NULL,
  `doi_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`galley_id`),
  KEY `publication_galleys_publication_id` (`publication_id`),
  KEY `publication_galleys_submission_file_id` (`submission_file_id`),
  KEY `publication_galleys_doi_id` (`doi_id`),
  KEY `publication_galleys_url_path` (`url_path`),
  CONSTRAINT `publication_galleys_doi_id_foreign` FOREIGN KEY (`doi_id`) REFERENCES `dois` (`doi_id`) ON DELETE SET NULL,
  CONSTRAINT `publication_galleys_publication_id` FOREIGN KEY (`publication_id`) REFERENCES `publications` (`publication_id`) ON DELETE CASCADE,
  CONSTRAINT `publication_galleys_submission_file_id_foreign` FOREIGN KEY (`submission_file_id`) REFERENCES `submission_files` (`submission_file_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Publication galleys are representations of a publication in a specific format, e.g. a PDF.';

-- ----------------------------
-- Records of publication_galleys
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for publication_settings
-- ----------------------------
DROP TABLE IF EXISTS `publication_settings`;
CREATE TABLE `publication_settings` (
  `publication_setting_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `publication_id` bigint(20) NOT NULL,
  `locale` varchar(14) NOT NULL DEFAULT '',
  `setting_name` varchar(255) NOT NULL,
  `setting_value` mediumtext DEFAULT NULL,
  PRIMARY KEY (`publication_setting_id`),
  UNIQUE KEY `publication_settings_unique` (`publication_id`,`locale`,`setting_name`),
  KEY `publication_settings_name_value` (`setting_name`(50),`setting_value`(150)),
  KEY `publication_settings_publication_id` (`publication_id`),
  CONSTRAINT `publication_settings_publication_id` FOREIGN KEY (`publication_id`) REFERENCES `publications` (`publication_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='More data about publications, including localized properties such as the title and abstract.';

-- ----------------------------
-- Records of publication_settings
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for publications
-- ----------------------------
DROP TABLE IF EXISTS `publications`;
CREATE TABLE `publications` (
  `publication_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `access_status` bigint(20) DEFAULT 0,
  `date_published` date DEFAULT NULL,
  `last_modified` datetime DEFAULT NULL,
  `primary_contact_id` bigint(20) DEFAULT NULL,
  `section_id` bigint(20) DEFAULT NULL,
  `seq` double(8,2) NOT NULL DEFAULT 0.00,
  `submission_id` bigint(20) NOT NULL,
  `status` smallint(6) NOT NULL DEFAULT 1,
  `url_path` varchar(64) DEFAULT NULL,
  `version` bigint(20) DEFAULT NULL,
  `doi_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`publication_id`),
  KEY `publications_primary_contact_id` (`primary_contact_id`),
  KEY `publications_section_id` (`section_id`),
  KEY `publications_submission_id` (`submission_id`),
  KEY `publications_doi_id` (`doi_id`),
  KEY `publications_url_path` (`url_path`),
  CONSTRAINT `publications_doi_id_foreign` FOREIGN KEY (`doi_id`) REFERENCES `dois` (`doi_id`) ON DELETE SET NULL,
  CONSTRAINT `publications_primary_contact_id` FOREIGN KEY (`primary_contact_id`) REFERENCES `authors` (`author_id`) ON DELETE SET NULL,
  CONSTRAINT `publications_section_id` FOREIGN KEY (`section_id`) REFERENCES `sections` (`section_id`) ON DELETE SET NULL,
  CONSTRAINT `publications_submission_id` FOREIGN KEY (`submission_id`) REFERENCES `submissions` (`submission_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Each publication is one version of a submission.';

-- ----------------------------
-- Records of publications
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for queries
-- ----------------------------
DROP TABLE IF EXISTS `queries`;
CREATE TABLE `queries` (
  `query_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `assoc_type` bigint(20) NOT NULL,
  `assoc_id` bigint(20) NOT NULL,
  `stage_id` smallint(6) NOT NULL,
  `seq` double(8,2) NOT NULL DEFAULT 0.00,
  `date_posted` datetime DEFAULT NULL,
  `date_modified` datetime DEFAULT NULL,
  `closed` smallint(6) NOT NULL DEFAULT 0,
  PRIMARY KEY (`query_id`),
  KEY `queries_assoc_id` (`assoc_type`,`assoc_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Discussions, usually related to a submission, created by editors, authors and other editorial staff.';

-- ----------------------------
-- Records of queries
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for query_participants
-- ----------------------------
DROP TABLE IF EXISTS `query_participants`;
CREATE TABLE `query_participants` (
  `query_participant_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `query_id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  PRIMARY KEY (`query_participant_id`),
  UNIQUE KEY `query_participants_unique` (`query_id`,`user_id`),
  KEY `query_participants_query_id` (`query_id`),
  KEY `query_participants_user_id` (`user_id`),
  CONSTRAINT `query_participants_query_id_foreign` FOREIGN KEY (`query_id`) REFERENCES `queries` (`query_id`) ON DELETE CASCADE,
  CONSTRAINT `query_participants_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='The users assigned to a discussion.';

-- ----------------------------
-- Records of query_participants
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for queued_payments
-- ----------------------------
DROP TABLE IF EXISTS `queued_payments`;
CREATE TABLE `queued_payments` (
  `queued_payment_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `date_created` datetime NOT NULL,
  `date_modified` datetime NOT NULL,
  `expiry_date` date DEFAULT NULL,
  `payment_data` text DEFAULT NULL,
  PRIMARY KEY (`queued_payment_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Unfulfilled (queued) payments, i.e. payments that have not yet been completed via an online payment system.';

-- ----------------------------
-- Records of queued_payments
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for review_assignments
-- ----------------------------
DROP TABLE IF EXISTS `review_assignments`;
CREATE TABLE `review_assignments` (
  `review_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `submission_id` bigint(20) NOT NULL,
  `reviewer_id` bigint(20) NOT NULL,
  `competing_interests` text DEFAULT NULL,
  `recommendation` smallint(6) DEFAULT NULL,
  `date_assigned` datetime DEFAULT NULL,
  `date_notified` datetime DEFAULT NULL,
  `date_confirmed` datetime DEFAULT NULL,
  `date_completed` datetime DEFAULT NULL,
  `date_acknowledged` datetime DEFAULT NULL,
  `date_due` datetime DEFAULT NULL,
  `date_response_due` datetime DEFAULT NULL,
  `last_modified` datetime DEFAULT NULL,
  `reminder_was_automatic` smallint(6) NOT NULL DEFAULT 0,
  `declined` smallint(6) NOT NULL DEFAULT 0,
  `cancelled` smallint(6) NOT NULL DEFAULT 0,
  `date_rated` datetime DEFAULT NULL,
  `date_reminded` datetime DEFAULT NULL,
  `quality` smallint(6) DEFAULT NULL,
  `review_round_id` bigint(20) NOT NULL,
  `stage_id` smallint(6) NOT NULL,
  `review_method` smallint(6) NOT NULL DEFAULT 1,
  `round` smallint(6) NOT NULL DEFAULT 1,
  `step` smallint(6) NOT NULL DEFAULT 1,
  `review_form_id` bigint(20) DEFAULT NULL,
  `considered` smallint(6) DEFAULT NULL,
  `request_resent` smallint(6) NOT NULL DEFAULT 0,
  PRIMARY KEY (`review_id`),
  KEY `review_assignments_submission_id` (`submission_id`),
  KEY `review_assignments_reviewer_id` (`reviewer_id`),
  KEY `review_assignment_reviewer_round` (`review_round_id`,`reviewer_id`),
  KEY `review_assignments_form_id` (`review_form_id`),
  KEY `review_assignments_reviewer_review` (`reviewer_id`,`review_id`),
  CONSTRAINT `review_assignments_review_form_id_foreign` FOREIGN KEY (`review_form_id`) REFERENCES `review_forms` (`review_form_id`),
  CONSTRAINT `review_assignments_review_round_id_foreign` FOREIGN KEY (`review_round_id`) REFERENCES `review_rounds` (`review_round_id`),
  CONSTRAINT `review_assignments_reviewer_id_foreign` FOREIGN KEY (`reviewer_id`) REFERENCES `users` (`user_id`),
  CONSTRAINT `review_assignments_submission_id_foreign` FOREIGN KEY (`submission_id`) REFERENCES `submissions` (`submission_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Data about peer review assignments for all submissions.';

-- ----------------------------
-- Records of review_assignments
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for review_files
-- ----------------------------
DROP TABLE IF EXISTS `review_files`;
CREATE TABLE `review_files` (
  `review_file_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `review_id` bigint(20) NOT NULL,
  `submission_file_id` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`review_file_id`),
  UNIQUE KEY `review_files_unique` (`review_id`,`submission_file_id`),
  KEY `review_files_review_id` (`review_id`),
  KEY `review_files_submission_file_id` (`submission_file_id`),
  CONSTRAINT `review_files_review_id_foreign` FOREIGN KEY (`review_id`) REFERENCES `review_assignments` (`review_id`) ON DELETE CASCADE,
  CONSTRAINT `review_files_submission_file_id_foreign` FOREIGN KEY (`submission_file_id`) REFERENCES `submission_files` (`submission_file_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='A list of the submission files made available to each assigned reviewer.';

-- ----------------------------
-- Records of review_files
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for review_form_element_settings
-- ----------------------------
DROP TABLE IF EXISTS `review_form_element_settings`;
CREATE TABLE `review_form_element_settings` (
  `review_form_element_setting_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `review_form_element_id` bigint(20) NOT NULL,
  `locale` varchar(14) NOT NULL DEFAULT '',
  `setting_name` varchar(255) NOT NULL,
  `setting_value` mediumtext DEFAULT NULL,
  `setting_type` varchar(6) NOT NULL,
  PRIMARY KEY (`review_form_element_setting_id`),
  UNIQUE KEY `review_form_element_settings_unique` (`review_form_element_id`,`locale`,`setting_name`),
  KEY `review_form_element_settings_review_form_element_id` (`review_form_element_id`),
  CONSTRAINT `review_form_element_settings_review_form_element_id` FOREIGN KEY (`review_form_element_id`) REFERENCES `review_form_elements` (`review_form_element_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='More data about review form elements, including localized content such as question text.';

-- ----------------------------
-- Records of review_form_element_settings
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for review_form_elements
-- ----------------------------
DROP TABLE IF EXISTS `review_form_elements`;
CREATE TABLE `review_form_elements` (
  `review_form_element_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `review_form_id` bigint(20) NOT NULL,
  `seq` double(8,2) DEFAULT NULL,
  `element_type` bigint(20) DEFAULT NULL,
  `required` smallint(6) DEFAULT NULL,
  `included` smallint(6) DEFAULT NULL,
  PRIMARY KEY (`review_form_element_id`),
  KEY `review_form_elements_review_form_id` (`review_form_id`),
  CONSTRAINT `review_form_elements_review_form_id` FOREIGN KEY (`review_form_id`) REFERENCES `review_forms` (`review_form_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Each review form element represents a single question on a review form.';

-- ----------------------------
-- Records of review_form_elements
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for review_form_responses
-- ----------------------------
DROP TABLE IF EXISTS `review_form_responses`;
CREATE TABLE `review_form_responses` (
  `review_form_response_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `review_form_element_id` bigint(20) NOT NULL,
  `review_id` bigint(20) NOT NULL,
  `response_type` varchar(6) DEFAULT NULL,
  `response_value` text DEFAULT NULL,
  PRIMARY KEY (`review_form_response_id`),
  KEY `review_form_responses_review_form_element_id` (`review_form_element_id`),
  KEY `review_form_responses_review_id` (`review_id`),
  KEY `review_form_responses_unique` (`review_form_element_id`,`review_id`),
  CONSTRAINT `review_form_responses_review_form_element_id_foreign` FOREIGN KEY (`review_form_element_id`) REFERENCES `review_form_elements` (`review_form_element_id`) ON DELETE CASCADE,
  CONSTRAINT `review_form_responses_review_id_foreign` FOREIGN KEY (`review_id`) REFERENCES `review_assignments` (`review_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Each review form response records a reviewer''s answer to a review form element associated with a peer review.';

-- ----------------------------
-- Records of review_form_responses
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for review_form_settings
-- ----------------------------
DROP TABLE IF EXISTS `review_form_settings`;
CREATE TABLE `review_form_settings` (
  `review_form_setting_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `review_form_id` bigint(20) NOT NULL,
  `locale` varchar(14) NOT NULL DEFAULT '',
  `setting_name` varchar(255) NOT NULL,
  `setting_value` mediumtext DEFAULT NULL,
  `setting_type` varchar(6) NOT NULL,
  PRIMARY KEY (`review_form_setting_id`),
  UNIQUE KEY `review_form_settings_unique` (`review_form_id`,`locale`,`setting_name`),
  KEY `review_form_settings_review_form_id` (`review_form_id`),
  CONSTRAINT `review_form_settings_review_form_id` FOREIGN KEY (`review_form_id`) REFERENCES `review_forms` (`review_form_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='More data about review forms, including localized content such as names.';

-- ----------------------------
-- Records of review_form_settings
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for review_forms
-- ----------------------------
DROP TABLE IF EXISTS `review_forms`;
CREATE TABLE `review_forms` (
  `review_form_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `assoc_type` bigint(20) NOT NULL,
  `assoc_id` bigint(20) NOT NULL,
  `seq` double(8,2) DEFAULT NULL,
  `is_active` smallint(6) DEFAULT NULL,
  PRIMARY KEY (`review_form_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Review forms provide custom templates for peer reviews with several types of questions.';

-- ----------------------------
-- Records of review_forms
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for review_round_files
-- ----------------------------
DROP TABLE IF EXISTS `review_round_files`;
CREATE TABLE `review_round_files` (
  `review_round_file_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `submission_id` bigint(20) NOT NULL,
  `review_round_id` bigint(20) NOT NULL,
  `stage_id` smallint(6) NOT NULL,
  `submission_file_id` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`review_round_file_id`),
  UNIQUE KEY `review_round_files_unique` (`submission_id`,`review_round_id`,`submission_file_id`),
  KEY `review_round_files_submission_id` (`submission_id`),
  KEY `review_round_files_review_round_id` (`review_round_id`),
  KEY `review_round_files_submission_file_id` (`submission_file_id`),
  CONSTRAINT `review_round_files_review_round_id_foreign` FOREIGN KEY (`review_round_id`) REFERENCES `review_rounds` (`review_round_id`) ON DELETE CASCADE,
  CONSTRAINT `review_round_files_submission_file_id_foreign` FOREIGN KEY (`submission_file_id`) REFERENCES `submission_files` (`submission_file_id`) ON DELETE CASCADE,
  CONSTRAINT `review_round_files_submission_id_foreign` FOREIGN KEY (`submission_id`) REFERENCES `submissions` (`submission_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Records the files made available to reviewers for a round of reviews. These can be further customized on a per review basis with review_files.';

-- ----------------------------
-- Records of review_round_files
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for review_rounds
-- ----------------------------
DROP TABLE IF EXISTS `review_rounds`;
CREATE TABLE `review_rounds` (
  `review_round_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `submission_id` bigint(20) NOT NULL,
  `stage_id` bigint(20) DEFAULT NULL,
  `round` smallint(6) NOT NULL,
  `review_revision` bigint(20) DEFAULT NULL,
  `status` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`review_round_id`),
  UNIQUE KEY `review_rounds_submission_id_stage_id_round_pkey` (`submission_id`,`stage_id`,`round`),
  KEY `review_rounds_submission_id` (`submission_id`),
  CONSTRAINT `review_rounds_submission_id_foreign` FOREIGN KEY (`submission_id`) REFERENCES `submissions` (`submission_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Peer review assignments are organized into multiple rounds on a submission.';

-- ----------------------------
-- Records of review_rounds
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for scheduled_tasks
-- ----------------------------
DROP TABLE IF EXISTS `scheduled_tasks`;
CREATE TABLE `scheduled_tasks` (
  `scheduled_task_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `class_name` varchar(255) NOT NULL,
  `last_run` datetime DEFAULT NULL,
  PRIMARY KEY (`scheduled_task_id`),
  UNIQUE KEY `scheduled_tasks_unique` (`class_name`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='The last time each scheduled task was run.';

-- ----------------------------
-- Records of scheduled_tasks
-- ----------------------------
BEGIN;
INSERT INTO `scheduled_tasks` (`scheduled_task_id`, `class_name`, `last_run`) VALUES (1, 'PKP\\task\\ReviewReminder', '2024-10-24 22:17:40');
INSERT INTO `scheduled_tasks` (`scheduled_task_id`, `class_name`, `last_run`) VALUES (2, 'PKP\\task\\StatisticsReport', '2024-10-24 22:17:40');
INSERT INTO `scheduled_tasks` (`scheduled_task_id`, `class_name`, `last_run`) VALUES (3, 'APP\\tasks\\SubscriptionExpiryReminder', '2024-10-24 22:17:40');
INSERT INTO `scheduled_tasks` (`scheduled_task_id`, `class_name`, `last_run`) VALUES (4, 'PKP\\task\\DepositDois', '2024-10-24 22:17:40');
INSERT INTO `scheduled_tasks` (`scheduled_task_id`, `class_name`, `last_run`) VALUES (5, 'PKP\\task\\RemoveUnvalidatedExpiredUsers', '2024-10-24 22:17:40');
INSERT INTO `scheduled_tasks` (`scheduled_task_id`, `class_name`, `last_run`) VALUES (6, 'PKP\\task\\EditorialReminders', '2024-10-24 22:17:41');
INSERT INTO `scheduled_tasks` (`scheduled_task_id`, `class_name`, `last_run`) VALUES (7, 'PKP\\task\\UpdateIPGeoDB', '2024-10-24 22:17:41');
INSERT INTO `scheduled_tasks` (`scheduled_task_id`, `class_name`, `last_run`) VALUES (8, 'APP\\tasks\\UsageStatsLoader', '2024-10-24 22:17:43');
INSERT INTO `scheduled_tasks` (`scheduled_task_id`, `class_name`, `last_run`) VALUES (9, 'PKP\\task\\ProcessQueueJobs', '2024-10-24 22:17:43');
INSERT INTO `scheduled_tasks` (`scheduled_task_id`, `class_name`, `last_run`) VALUES (10, 'PKP\\task\\RemoveFailedJobs', '2024-10-24 22:17:43');
INSERT INTO `scheduled_tasks` (`scheduled_task_id`, `class_name`, `last_run`) VALUES (11, 'APP\\tasks\\OpenAccessNotification', '2024-10-24 22:17:43');
COMMIT;

-- ----------------------------
-- Table structure for section_settings
-- ----------------------------
DROP TABLE IF EXISTS `section_settings`;
CREATE TABLE `section_settings` (
  `section_setting_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `section_id` bigint(20) NOT NULL,
  `locale` varchar(14) NOT NULL DEFAULT '',
  `setting_name` varchar(255) NOT NULL,
  `setting_value` mediumtext DEFAULT NULL,
  PRIMARY KEY (`section_setting_id`),
  UNIQUE KEY `section_settings_unique` (`section_id`,`locale`,`setting_name`),
  KEY `section_settings_section_id` (`section_id`),
  CONSTRAINT `section_settings_section_id` FOREIGN KEY (`section_id`) REFERENCES `sections` (`section_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='More data about sections, including localized properties like section titles.';

-- ----------------------------
-- Records of section_settings
-- ----------------------------
BEGIN;
INSERT INTO `section_settings` (`section_setting_id`, `section_id`, `locale`, `setting_name`, `setting_value`) VALUES (1, 1, 'id', 'title', 'Articles');
INSERT INTO `section_settings` (`section_setting_id`, `section_id`, `locale`, `setting_name`, `setting_value`) VALUES (2, 1, 'id', 'abbrev', 'ART');
INSERT INTO `section_settings` (`section_setting_id`, `section_id`, `locale`, `setting_name`, `setting_value`) VALUES (3, 1, 'id', 'policy', 'Section default policy');
COMMIT;

-- ----------------------------
-- Table structure for sections
-- ----------------------------
DROP TABLE IF EXISTS `sections`;
CREATE TABLE `sections` (
  `section_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `journal_id` bigint(20) NOT NULL,
  `review_form_id` bigint(20) DEFAULT NULL,
  `seq` double(8,2) NOT NULL DEFAULT 0.00,
  `editor_restricted` smallint(6) NOT NULL DEFAULT 0,
  `meta_indexed` smallint(6) NOT NULL DEFAULT 0,
  `meta_reviewed` smallint(6) NOT NULL DEFAULT 1,
  `abstracts_not_required` smallint(6) NOT NULL DEFAULT 0,
  `hide_title` smallint(6) NOT NULL DEFAULT 0,
  `hide_author` smallint(6) NOT NULL DEFAULT 0,
  `is_inactive` smallint(6) NOT NULL DEFAULT 0,
  `abstract_word_count` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`section_id`),
  KEY `sections_journal_id` (`journal_id`),
  KEY `sections_review_form_id` (`review_form_id`),
  CONSTRAINT `sections_journal_id` FOREIGN KEY (`journal_id`) REFERENCES `journals` (`journal_id`) ON DELETE CASCADE,
  CONSTRAINT `sections_review_form_id` FOREIGN KEY (`review_form_id`) REFERENCES `review_forms` (`review_form_id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='A list of all sections into which submissions can be organized, forming the table of contents.';

-- ----------------------------
-- Records of sections
-- ----------------------------
BEGIN;
INSERT INTO `sections` (`section_id`, `journal_id`, `review_form_id`, `seq`, `editor_restricted`, `meta_indexed`, `meta_reviewed`, `abstracts_not_required`, `hide_title`, `hide_author`, `is_inactive`, `abstract_word_count`) VALUES (1, 1, NULL, 0.00, 0, 1, 1, 0, 0, 0, 0, NULL);
COMMIT;

-- ----------------------------
-- Table structure for sessions
-- ----------------------------
DROP TABLE IF EXISTS `sessions`;
CREATE TABLE `sessions` (
  `session_id` varchar(128) NOT NULL,
  `user_id` bigint(20) DEFAULT NULL,
  `ip_address` varchar(39) NOT NULL,
  `user_agent` varchar(255) DEFAULT NULL,
  `created` bigint(20) NOT NULL DEFAULT 0,
  `last_used` bigint(20) NOT NULL DEFAULT 0,
  `remember` smallint(6) NOT NULL DEFAULT 0,
  `data` text NOT NULL,
  `domain` varchar(255) DEFAULT NULL,
  UNIQUE KEY `sessions_pkey` (`session_id`),
  KEY `sessions_user_id` (`user_id`),
  CONSTRAINT `sessions_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Session data for logged-in users.';

-- ----------------------------
-- Records of sessions
-- ----------------------------
BEGIN;
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('1q7fv53ctaogl196qhq6msfrip', NULL, '180.244.128.69', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Mobile Safari/537.36', 1729808260, 1729808470, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1729808467;s:5:\"token\";s:32:\"9fe9a77271d8573988188b43d6de0e74\";}username|s:6:\"peacee\";', 'peacee.id');
COMMIT;

-- ----------------------------
-- Table structure for site
-- ----------------------------
DROP TABLE IF EXISTS `site`;
CREATE TABLE `site` (
  `site_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `redirect` bigint(20) NOT NULL DEFAULT 0 COMMENT 'If not 0, redirect to the specified journal/conference/... site.',
  `primary_locale` varchar(14) NOT NULL COMMENT 'Primary locale for the site.',
  `min_password_length` smallint(6) NOT NULL DEFAULT 6,
  `installed_locales` varchar(1024) NOT NULL DEFAULT 'en' COMMENT 'Locales for which support has been installed.',
  `supported_locales` varchar(1024) DEFAULT NULL COMMENT 'Locales supported by the site (for hosted journals/conferences/...).',
  `original_style_file_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`site_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='A singleton table describing basic information about the site.';

-- ----------------------------
-- Records of site
-- ----------------------------
BEGIN;
INSERT INTO `site` (`site_id`, `redirect`, `primary_locale`, `min_password_length`, `installed_locales`, `supported_locales`, `original_style_file_name`) VALUES (1, 0, 'en', 6, '[\"id\",\"en\"]', '[\"id\",\"en\"]', NULL);
COMMIT;

-- ----------------------------
-- Table structure for site_settings
-- ----------------------------
DROP TABLE IF EXISTS `site_settings`;
CREATE TABLE `site_settings` (
  `site_setting_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `setting_name` varchar(255) NOT NULL,
  `locale` varchar(14) NOT NULL DEFAULT '',
  `setting_value` mediumtext DEFAULT NULL,
  PRIMARY KEY (`site_setting_id`),
  UNIQUE KEY `site_settings_unique` (`setting_name`,`locale`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='More data about the site, including localized properties such as its name.';

-- ----------------------------
-- Records of site_settings
-- ----------------------------
BEGIN;
INSERT INTO `site_settings` (`site_setting_id`, `setting_name`, `locale`, `setting_value`) VALUES (1, 'contactEmail', 'en', 'deewahyu@upi.edu');
INSERT INTO `site_settings` (`site_setting_id`, `setting_name`, `locale`, `setting_value`) VALUES (2, 'contactName', 'id', 'Open Journal Systems');
INSERT INTO `site_settings` (`site_setting_id`, `setting_name`, `locale`, `setting_value`) VALUES (3, 'contactName', 'en', 'Open Journal Systems');
INSERT INTO `site_settings` (`site_setting_id`, `setting_name`, `locale`, `setting_value`) VALUES (4, 'compressStatsLogs', '', '0');
INSERT INTO `site_settings` (`site_setting_id`, `setting_name`, `locale`, `setting_value`) VALUES (5, 'enableGeoUsageStats', '', 'disabled');
INSERT INTO `site_settings` (`site_setting_id`, `setting_name`, `locale`, `setting_value`) VALUES (6, 'enableInstitutionUsageStats', '', '0');
INSERT INTO `site_settings` (`site_setting_id`, `setting_name`, `locale`, `setting_value`) VALUES (7, 'keepDailyUsageStats', '', '0');
INSERT INTO `site_settings` (`site_setting_id`, `setting_name`, `locale`, `setting_value`) VALUES (8, 'isSiteSushiPlatform', '', '0');
INSERT INTO `site_settings` (`site_setting_id`, `setting_name`, `locale`, `setting_value`) VALUES (9, 'isSushiApiPublic', '', '1');
INSERT INTO `site_settings` (`site_setting_id`, `setting_name`, `locale`, `setting_value`) VALUES (10, 'themePluginPath', '', 'default');
COMMIT;

-- ----------------------------
-- Table structure for stage_assignments
-- ----------------------------
DROP TABLE IF EXISTS `stage_assignments`;
CREATE TABLE `stage_assignments` (
  `stage_assignment_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `submission_id` bigint(20) NOT NULL,
  `user_group_id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `date_assigned` datetime NOT NULL,
  `recommend_only` smallint(6) NOT NULL DEFAULT 0,
  `can_change_metadata` smallint(6) NOT NULL DEFAULT 0,
  PRIMARY KEY (`stage_assignment_id`),
  UNIQUE KEY `stage_assignment` (`submission_id`,`user_group_id`,`user_id`),
  KEY `stage_assignments_user_group_id` (`user_group_id`),
  KEY `stage_assignments_user_id` (`user_id`),
  KEY `stage_assignments_submission_id` (`submission_id`),
  CONSTRAINT `stage_assignments_submission_id_foreign` FOREIGN KEY (`submission_id`) REFERENCES `submissions` (`submission_id`) ON DELETE CASCADE,
  CONSTRAINT `stage_assignments_user_group_id` FOREIGN KEY (`user_group_id`) REFERENCES `user_groups` (`user_group_id`) ON DELETE CASCADE,
  CONSTRAINT `stage_assignments_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Who can access a submission while it is in the editorial workflow. Includes all editorial and author assignments. For reviewers, see review_assignments.';

-- ----------------------------
-- Records of stage_assignments
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for static_page_settings
-- ----------------------------
DROP TABLE IF EXISTS `static_page_settings`;
CREATE TABLE `static_page_settings` (
  `static_page_setting_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `static_page_id` bigint(20) NOT NULL,
  `locale` varchar(14) NOT NULL DEFAULT '',
  `setting_name` varchar(255) NOT NULL,
  `setting_value` longtext DEFAULT NULL,
  `setting_type` varchar(6) NOT NULL COMMENT '(bool|int|float|string|object)',
  PRIMARY KEY (`static_page_setting_id`),
  KEY `static_page_settings_static_page_id` (`static_page_id`),
  CONSTRAINT `static_page_settings_static_page_id` FOREIGN KEY (`static_page_id`) REFERENCES `static_pages` (`static_page_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- ----------------------------
-- Records of static_page_settings
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for static_pages
-- ----------------------------
DROP TABLE IF EXISTS `static_pages`;
CREATE TABLE `static_pages` (
  `static_page_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `path` varchar(255) NOT NULL,
  `context_id` bigint(20) NOT NULL,
  PRIMARY KEY (`static_page_id`),
  KEY `static_pages_context_id` (`context_id`),
  CONSTRAINT `static_pages_context_id` FOREIGN KEY (`context_id`) REFERENCES `journals` (`journal_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- ----------------------------
-- Records of static_pages
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for subeditor_submission_group
-- ----------------------------
DROP TABLE IF EXISTS `subeditor_submission_group`;
CREATE TABLE `subeditor_submission_group` (
  `subeditor_submission_group_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `context_id` bigint(20) NOT NULL,
  `assoc_id` bigint(20) NOT NULL,
  `assoc_type` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `user_group_id` bigint(20) NOT NULL,
  PRIMARY KEY (`subeditor_submission_group_id`),
  UNIQUE KEY `section_editors_unique` (`context_id`,`assoc_id`,`assoc_type`,`user_id`,`user_group_id`),
  KEY `subeditor_submission_group_context_id` (`context_id`),
  KEY `subeditor_submission_group_user_id` (`user_id`),
  KEY `subeditor_submission_group_user_group_id` (`user_group_id`),
  KEY `subeditor_submission_group_assoc_id` (`assoc_id`,`assoc_type`),
  CONSTRAINT `section_editors_context_id` FOREIGN KEY (`context_id`) REFERENCES `journals` (`journal_id`) ON DELETE CASCADE,
  CONSTRAINT `subeditor_submission_group_user_group_id_foreign` FOREIGN KEY (`user_group_id`) REFERENCES `user_groups` (`user_group_id`) ON DELETE CASCADE,
  CONSTRAINT `subeditor_submission_group_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Subeditor assignments to e.g. sections and categories';

-- ----------------------------
-- Records of subeditor_submission_group
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for submission_comments
-- ----------------------------
DROP TABLE IF EXISTS `submission_comments`;
CREATE TABLE `submission_comments` (
  `comment_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `comment_type` bigint(20) DEFAULT NULL,
  `role_id` bigint(20) NOT NULL,
  `submission_id` bigint(20) NOT NULL,
  `assoc_id` bigint(20) NOT NULL,
  `author_id` bigint(20) NOT NULL,
  `comment_title` text NOT NULL,
  `comments` text DEFAULT NULL,
  `date_posted` datetime DEFAULT NULL,
  `date_modified` datetime DEFAULT NULL,
  `viewable` smallint(6) DEFAULT NULL,
  PRIMARY KEY (`comment_id`),
  KEY `submission_comments_submission_id` (`submission_id`),
  KEY `submission_comments_author_id` (`author_id`),
  CONSTRAINT `submission_comments_author_id_foreign` FOREIGN KEY (`author_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  CONSTRAINT `submission_comments_submission_id` FOREIGN KEY (`submission_id`) REFERENCES `submissions` (`submission_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Comments on a submission, e.g. peer review comments';

-- ----------------------------
-- Records of submission_comments
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for submission_file_revisions
-- ----------------------------
DROP TABLE IF EXISTS `submission_file_revisions`;
CREATE TABLE `submission_file_revisions` (
  `revision_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `submission_file_id` bigint(20) unsigned NOT NULL,
  `file_id` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`revision_id`),
  KEY `submission_file_revisions_submission_file_id` (`submission_file_id`),
  KEY `submission_file_revisions_file_id` (`file_id`),
  CONSTRAINT `submission_file_revisions_file_id_foreign` FOREIGN KEY (`file_id`) REFERENCES `files` (`file_id`) ON DELETE CASCADE,
  CONSTRAINT `submission_file_revisions_submission_file_id_foreign` FOREIGN KEY (`submission_file_id`) REFERENCES `submission_files` (`submission_file_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Revisions map submission_file entries to files on the data store.';

-- ----------------------------
-- Records of submission_file_revisions
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for submission_file_settings
-- ----------------------------
DROP TABLE IF EXISTS `submission_file_settings`;
CREATE TABLE `submission_file_settings` (
  `submission_file_setting_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `submission_file_id` bigint(20) unsigned NOT NULL,
  `locale` varchar(14) NOT NULL DEFAULT '',
  `setting_name` varchar(255) NOT NULL,
  `setting_value` mediumtext DEFAULT NULL,
  PRIMARY KEY (`submission_file_setting_id`),
  UNIQUE KEY `submission_file_settings_unique` (`submission_file_id`,`locale`,`setting_name`),
  KEY `submission_file_settings_submission_file_id` (`submission_file_id`),
  CONSTRAINT `submission_file_settings_submission_file_id_foreign` FOREIGN KEY (`submission_file_id`) REFERENCES `submission_files` (`submission_file_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Localized data about submission files like published metadata.';

-- ----------------------------
-- Records of submission_file_settings
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for submission_files
-- ----------------------------
DROP TABLE IF EXISTS `submission_files`;
CREATE TABLE `submission_files` (
  `submission_file_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `submission_id` bigint(20) NOT NULL,
  `file_id` bigint(20) unsigned NOT NULL,
  `source_submission_file_id` bigint(20) unsigned DEFAULT NULL,
  `genre_id` bigint(20) DEFAULT NULL,
  `file_stage` bigint(20) NOT NULL,
  `direct_sales_price` varchar(255) DEFAULT NULL,
  `sales_type` varchar(255) DEFAULT NULL,
  `viewable` smallint(6) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `uploader_user_id` bigint(20) DEFAULT NULL,
  `assoc_type` bigint(20) DEFAULT NULL,
  `assoc_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`submission_file_id`),
  KEY `submission_files_submission_id` (`submission_id`),
  KEY `submission_files_file_id` (`file_id`),
  KEY `submission_files_genre_id` (`genre_id`),
  KEY `submission_files_uploader_user_id` (`uploader_user_id`),
  KEY `submission_files_stage_assoc` (`file_stage`,`assoc_type`,`assoc_id`),
  KEY `submission_files_source_submission_file_id` (`source_submission_file_id`),
  CONSTRAINT `submission_files_file_id_foreign` FOREIGN KEY (`file_id`) REFERENCES `files` (`file_id`) ON DELETE CASCADE,
  CONSTRAINT `submission_files_genre_id_foreign` FOREIGN KEY (`genre_id`) REFERENCES `genres` (`genre_id`) ON DELETE SET NULL,
  CONSTRAINT `submission_files_source_submission_file_id_foreign` FOREIGN KEY (`source_submission_file_id`) REFERENCES `submission_files` (`submission_file_id`) ON DELETE CASCADE,
  CONSTRAINT `submission_files_submission_id` FOREIGN KEY (`submission_id`) REFERENCES `submissions` (`submission_id`) ON DELETE CASCADE,
  CONSTRAINT `submission_files_uploader_user_id_foreign` FOREIGN KEY (`uploader_user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='All files associated with a submission, such as those uploaded during submission, as revisions, or by copyeditors or layout editors for production.';

-- ----------------------------
-- Records of submission_files
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for submission_search_keyword_list
-- ----------------------------
DROP TABLE IF EXISTS `submission_search_keyword_list`;
CREATE TABLE `submission_search_keyword_list` (
  `keyword_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `keyword_text` varchar(60) NOT NULL,
  PRIMARY KEY (`keyword_id`),
  UNIQUE KEY `submission_search_keyword_text` (`keyword_text`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='A list of all keywords used in the search index';

-- ----------------------------
-- Records of submission_search_keyword_list
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for submission_search_object_keywords
-- ----------------------------
DROP TABLE IF EXISTS `submission_search_object_keywords`;
CREATE TABLE `submission_search_object_keywords` (
  `submission_search_object_keyword_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `object_id` bigint(20) NOT NULL,
  `keyword_id` bigint(20) NOT NULL,
  `pos` int(11) NOT NULL COMMENT 'Word position of the keyword in the object.',
  PRIMARY KEY (`submission_search_object_keyword_id`),
  UNIQUE KEY `submission_search_object_keywords_unique` (`object_id`,`pos`),
  KEY `submission_search_object_keywords_object_id` (`object_id`),
  KEY `submission_search_object_keywords_keyword_id` (`keyword_id`),
  CONSTRAINT `submission_search_object_keywords_keyword_id` FOREIGN KEY (`keyword_id`) REFERENCES `submission_search_keyword_list` (`keyword_id`) ON DELETE CASCADE,
  CONSTRAINT `submission_search_object_keywords_object_id_foreign` FOREIGN KEY (`object_id`) REFERENCES `submission_search_objects` (`object_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Relationships between search objects and keywords in the search index';

-- ----------------------------
-- Records of submission_search_object_keywords
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for submission_search_objects
-- ----------------------------
DROP TABLE IF EXISTS `submission_search_objects`;
CREATE TABLE `submission_search_objects` (
  `object_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `submission_id` bigint(20) NOT NULL,
  `type` int(11) NOT NULL COMMENT 'Type of item. E.g., abstract, fulltext, etc.',
  `assoc_id` bigint(20) DEFAULT NULL COMMENT 'Optional ID of an associated record (e.g., a file_id)',
  PRIMARY KEY (`object_id`),
  KEY `submission_search_objects_submission_id` (`submission_id`),
  CONSTRAINT `submission_search_object_submission` FOREIGN KEY (`submission_id`) REFERENCES `submissions` (`submission_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='A list of all search objects indexed in the search index';

-- ----------------------------
-- Records of submission_search_objects
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for submission_settings
-- ----------------------------
DROP TABLE IF EXISTS `submission_settings`;
CREATE TABLE `submission_settings` (
  `submission_setting_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `submission_id` bigint(20) NOT NULL,
  `locale` varchar(14) NOT NULL DEFAULT '',
  `setting_name` varchar(255) NOT NULL,
  `setting_value` mediumtext DEFAULT NULL,
  PRIMARY KEY (`submission_setting_id`),
  UNIQUE KEY `submission_settings_unique` (`submission_id`,`locale`,`setting_name`),
  KEY `submission_settings_submission_id` (`submission_id`),
  CONSTRAINT `submission_settings_submission_id_foreign` FOREIGN KEY (`submission_id`) REFERENCES `submissions` (`submission_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Localized data about submissions';

-- ----------------------------
-- Records of submission_settings
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for submissions
-- ----------------------------
DROP TABLE IF EXISTS `submissions`;
CREATE TABLE `submissions` (
  `submission_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `context_id` bigint(20) NOT NULL,
  `current_publication_id` bigint(20) DEFAULT NULL,
  `date_last_activity` datetime DEFAULT NULL,
  `date_submitted` datetime DEFAULT NULL,
  `last_modified` datetime DEFAULT NULL,
  `stage_id` bigint(20) NOT NULL DEFAULT 1,
  `locale` varchar(14) DEFAULT NULL,
  `status` smallint(6) NOT NULL DEFAULT 1,
  `submission_progress` varchar(50) NOT NULL DEFAULT 'start',
  `work_type` smallint(6) DEFAULT 0,
  PRIMARY KEY (`submission_id`),
  KEY `submissions_context_id` (`context_id`),
  KEY `submissions_publication_id` (`current_publication_id`),
  CONSTRAINT `submissions_context_id` FOREIGN KEY (`context_id`) REFERENCES `journals` (`journal_id`) ON DELETE CASCADE,
  CONSTRAINT `submissions_publication_id` FOREIGN KEY (`current_publication_id`) REFERENCES `publications` (`publication_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='All submissions submitted to the context, including incomplete, declined and unpublished submissions.';

-- ----------------------------
-- Records of submissions
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for subscription_type_settings
-- ----------------------------
DROP TABLE IF EXISTS `subscription_type_settings`;
CREATE TABLE `subscription_type_settings` (
  `subscription_type_setting_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `type_id` bigint(20) NOT NULL,
  `locale` varchar(14) NOT NULL DEFAULT '',
  `setting_name` varchar(255) NOT NULL,
  `setting_value` mediumtext DEFAULT NULL,
  `setting_type` varchar(6) NOT NULL,
  PRIMARY KEY (`subscription_type_setting_id`),
  UNIQUE KEY `subscription_type_settings_unique` (`type_id`,`locale`,`setting_name`),
  KEY `subscription_type_settings_type_id` (`type_id`),
  CONSTRAINT `subscription_type_settings_type_id` FOREIGN KEY (`type_id`) REFERENCES `subscription_types` (`type_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='More data about subscription types, including localized properties such as names.';

-- ----------------------------
-- Records of subscription_type_settings
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for subscription_types
-- ----------------------------
DROP TABLE IF EXISTS `subscription_types`;
CREATE TABLE `subscription_types` (
  `type_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `journal_id` bigint(20) NOT NULL,
  `cost` double(8,2) NOT NULL,
  `currency_code_alpha` varchar(3) NOT NULL,
  `duration` smallint(6) DEFAULT NULL,
  `format` smallint(6) NOT NULL,
  `institutional` smallint(6) NOT NULL DEFAULT 0,
  `membership` smallint(6) NOT NULL DEFAULT 0,
  `disable_public_display` smallint(6) NOT NULL,
  `seq` double(8,2) NOT NULL,
  PRIMARY KEY (`type_id`),
  KEY `subscription_types_journal_id` (`journal_id`),
  CONSTRAINT `subscription_types_journal_id` FOREIGN KEY (`journal_id`) REFERENCES `journals` (`journal_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Subscription types represent the kinds of subscriptions that a user or institution may have, such as an annual subscription or a discounted subscription.';

-- ----------------------------
-- Records of subscription_types
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for subscriptions
-- ----------------------------
DROP TABLE IF EXISTS `subscriptions`;
CREATE TABLE `subscriptions` (
  `subscription_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `journal_id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `type_id` bigint(20) NOT NULL,
  `date_start` date DEFAULT NULL,
  `date_end` datetime DEFAULT NULL,
  `status` smallint(6) NOT NULL DEFAULT 1,
  `membership` varchar(40) DEFAULT NULL,
  `reference_number` varchar(40) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  PRIMARY KEY (`subscription_id`),
  KEY `subscriptions_journal_id` (`journal_id`),
  KEY `subscriptions_user_id` (`user_id`),
  KEY `subscriptions_type_id` (`type_id`),
  CONSTRAINT `subscriptions_journal_id` FOREIGN KEY (`journal_id`) REFERENCES `journals` (`journal_id`) ON DELETE CASCADE,
  CONSTRAINT `subscriptions_type_id` FOREIGN KEY (`type_id`) REFERENCES `subscription_types` (`type_id`) ON DELETE CASCADE,
  CONSTRAINT `subscriptions_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='A list of subscriptions, both institutional and individual, for journals that use subscription-based publishing.';

-- ----------------------------
-- Records of subscriptions
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for temporary_files
-- ----------------------------
DROP TABLE IF EXISTS `temporary_files`;
CREATE TABLE `temporary_files` (
  `file_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `file_name` varchar(90) NOT NULL,
  `file_type` varchar(255) DEFAULT NULL,
  `file_size` bigint(20) NOT NULL,
  `original_file_name` varchar(127) DEFAULT NULL,
  `date_uploaded` datetime NOT NULL,
  PRIMARY KEY (`file_id`),
  KEY `temporary_files_user_id` (`user_id`),
  CONSTRAINT `temporary_files_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Temporary files, e.g. where files are kept during an upload process before they are moved somewhere more appropriate.';

-- ----------------------------
-- Records of temporary_files
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for usage_stats_institution_temporary_records
-- ----------------------------
DROP TABLE IF EXISTS `usage_stats_institution_temporary_records`;
CREATE TABLE `usage_stats_institution_temporary_records` (
  `usage_stats_temp_institution_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `load_id` varchar(255) NOT NULL,
  `line_number` bigint(20) NOT NULL,
  `institution_id` bigint(20) NOT NULL,
  PRIMARY KEY (`usage_stats_temp_institution_id`),
  UNIQUE KEY `usitr_load_id_line_number_institution_id` (`load_id`,`line_number`,`institution_id`),
  KEY `usi_institution_id` (`institution_id`),
  CONSTRAINT `usi_institution_id_foreign` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`institution_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Temporary stats for views and downloads from institutions based on visitor log records. Data in this table is provisional. See the metrics_* tables for compiled stats.';

-- ----------------------------
-- Records of usage_stats_institution_temporary_records
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for usage_stats_total_temporary_records
-- ----------------------------
DROP TABLE IF EXISTS `usage_stats_total_temporary_records`;
CREATE TABLE `usage_stats_total_temporary_records` (
  `usage_stats_temp_total_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `date` datetime NOT NULL,
  `ip` varchar(255) NOT NULL,
  `user_agent` varchar(255) NOT NULL,
  `line_number` bigint(20) NOT NULL,
  `canonical_url` varchar(255) NOT NULL,
  `issue_id` bigint(20) DEFAULT NULL,
  `issue_galley_id` bigint(20) DEFAULT NULL,
  `context_id` bigint(20) NOT NULL,
  `submission_id` bigint(20) DEFAULT NULL,
  `representation_id` bigint(20) DEFAULT NULL,
  `submission_file_id` bigint(20) unsigned DEFAULT NULL,
  `assoc_type` bigint(20) NOT NULL,
  `file_type` smallint(6) DEFAULT NULL,
  `country` varchar(2) NOT NULL DEFAULT '',
  `region` varchar(3) NOT NULL DEFAULT '',
  `city` varchar(255) NOT NULL DEFAULT '',
  `load_id` varchar(255) NOT NULL,
  PRIMARY KEY (`usage_stats_temp_total_id`),
  KEY `usage_stats_total_temporary_records_issue_id` (`issue_id`),
  KEY `usage_stats_total_temporary_records_issue_galley_id` (`issue_galley_id`),
  KEY `usage_stats_total_temporary_records_context_id` (`context_id`),
  KEY `usage_stats_total_temporary_records_submission_id` (`submission_id`),
  KEY `usage_stats_total_temporary_records_representation_id` (`representation_id`),
  KEY `usage_stats_total_temporary_records_submission_file_id` (`submission_file_id`),
  CONSTRAINT `ust_context_id_foreign` FOREIGN KEY (`context_id`) REFERENCES `journals` (`journal_id`) ON DELETE CASCADE,
  CONSTRAINT `ust_issue_galley_id_foreign` FOREIGN KEY (`issue_galley_id`) REFERENCES `issue_galleys` (`galley_id`) ON DELETE CASCADE,
  CONSTRAINT `ust_issue_id_foreign` FOREIGN KEY (`issue_id`) REFERENCES `issues` (`issue_id`) ON DELETE CASCADE,
  CONSTRAINT `ust_representation_id_foreign` FOREIGN KEY (`representation_id`) REFERENCES `publication_galleys` (`galley_id`) ON DELETE CASCADE,
  CONSTRAINT `ust_submission_file_id_foreign` FOREIGN KEY (`submission_file_id`) REFERENCES `submission_files` (`submission_file_id`) ON DELETE CASCADE,
  CONSTRAINT `ust_submission_id_foreign` FOREIGN KEY (`submission_id`) REFERENCES `submissions` (`submission_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Temporary stats totals based on visitor log records. Data in this table is provisional. See the metrics_* tables for compiled stats.';

-- ----------------------------
-- Records of usage_stats_total_temporary_records
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for usage_stats_unique_item_investigations_temporary_records
-- ----------------------------
DROP TABLE IF EXISTS `usage_stats_unique_item_investigations_temporary_records`;
CREATE TABLE `usage_stats_unique_item_investigations_temporary_records` (
  `usage_stats_temp_unique_item_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `date` datetime NOT NULL,
  `ip` varchar(255) NOT NULL,
  `user_agent` varchar(255) NOT NULL,
  `line_number` bigint(20) NOT NULL,
  `context_id` bigint(20) NOT NULL,
  `submission_id` bigint(20) NOT NULL,
  `representation_id` bigint(20) DEFAULT NULL,
  `submission_file_id` bigint(20) unsigned DEFAULT NULL,
  `assoc_type` bigint(20) NOT NULL,
  `file_type` smallint(6) DEFAULT NULL,
  `country` varchar(2) NOT NULL DEFAULT '',
  `region` varchar(3) NOT NULL DEFAULT '',
  `city` varchar(255) NOT NULL DEFAULT '',
  `load_id` varchar(255) NOT NULL,
  PRIMARY KEY (`usage_stats_temp_unique_item_id`),
  KEY `usii_context_id` (`context_id`),
  KEY `usii_submission_id` (`submission_id`),
  KEY `usii_representation_id` (`representation_id`),
  KEY `usii_submission_file_id` (`submission_file_id`),
  CONSTRAINT `usii_context_id_foreign` FOREIGN KEY (`context_id`) REFERENCES `journals` (`journal_id`) ON DELETE CASCADE,
  CONSTRAINT `usii_representation_id_foreign` FOREIGN KEY (`representation_id`) REFERENCES `publication_galleys` (`galley_id`) ON DELETE CASCADE,
  CONSTRAINT `usii_submission_file_id_foreign` FOREIGN KEY (`submission_file_id`) REFERENCES `submission_files` (`submission_file_id`) ON DELETE CASCADE,
  CONSTRAINT `usii_submission_id_foreign` FOREIGN KEY (`submission_id`) REFERENCES `submissions` (`submission_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Temporary stats on unique downloads based on visitor log records. Data in this table is provisional. See the metrics_* tables for compiled stats.';

-- ----------------------------
-- Records of usage_stats_unique_item_investigations_temporary_records
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for usage_stats_unique_item_requests_temporary_records
-- ----------------------------
DROP TABLE IF EXISTS `usage_stats_unique_item_requests_temporary_records`;
CREATE TABLE `usage_stats_unique_item_requests_temporary_records` (
  `usage_stats_temp_item_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `date` datetime NOT NULL,
  `ip` varchar(255) NOT NULL,
  `user_agent` varchar(255) NOT NULL,
  `line_number` bigint(20) NOT NULL,
  `context_id` bigint(20) NOT NULL,
  `submission_id` bigint(20) NOT NULL,
  `representation_id` bigint(20) DEFAULT NULL,
  `submission_file_id` bigint(20) unsigned DEFAULT NULL,
  `assoc_type` bigint(20) NOT NULL,
  `file_type` smallint(6) DEFAULT NULL,
  `country` varchar(2) NOT NULL DEFAULT '',
  `region` varchar(3) NOT NULL DEFAULT '',
  `city` varchar(255) NOT NULL DEFAULT '',
  `load_id` varchar(255) NOT NULL,
  PRIMARY KEY (`usage_stats_temp_item_id`),
  KEY `usir_context_id` (`context_id`),
  KEY `usir_submission_id` (`submission_id`),
  KEY `usir_representation_id` (`representation_id`),
  KEY `usir_submission_file_id` (`submission_file_id`),
  CONSTRAINT `usir_context_id_foreign` FOREIGN KEY (`context_id`) REFERENCES `journals` (`journal_id`) ON DELETE CASCADE,
  CONSTRAINT `usir_representation_id_foreign` FOREIGN KEY (`representation_id`) REFERENCES `publication_galleys` (`galley_id`) ON DELETE CASCADE,
  CONSTRAINT `usir_submission_file_id_foreign` FOREIGN KEY (`submission_file_id`) REFERENCES `submission_files` (`submission_file_id`) ON DELETE CASCADE,
  CONSTRAINT `usir_submission_id_foreign` FOREIGN KEY (`submission_id`) REFERENCES `submissions` (`submission_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Temporary stats on unique views based on visitor log records. Data in this table is provisional. See the metrics_* tables for compiled stats.';

-- ----------------------------
-- Records of usage_stats_unique_item_requests_temporary_records
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for user_group_settings
-- ----------------------------
DROP TABLE IF EXISTS `user_group_settings`;
CREATE TABLE `user_group_settings` (
  `user_group_setting_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_group_id` bigint(20) NOT NULL,
  `locale` varchar(14) NOT NULL DEFAULT '',
  `setting_name` varchar(255) NOT NULL,
  `setting_value` mediumtext DEFAULT NULL,
  PRIMARY KEY (`user_group_setting_id`),
  UNIQUE KEY `user_group_settings_unique` (`user_group_id`,`locale`,`setting_name`),
  KEY `user_group_settings_user_group_id` (`user_group_id`),
  CONSTRAINT `user_group_settings_user_group_id_foreign` FOREIGN KEY (`user_group_id`) REFERENCES `user_groups` (`user_group_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=105 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='More data about user groups, including localized properties such as the name.';

-- ----------------------------
-- Records of user_group_settings
-- ----------------------------
BEGIN;
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (1, 1, 'id', 'name', 'Admin Situs');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (2, 1, 'en', 'name', 'Site Admin');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (3, 2, '', 'nameLocaleKey', 'default.groups.name.manager');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (4, 2, '', 'abbrevLocaleKey', 'default.groups.abbrev.manager');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (5, 2, 'id', 'abbrev', 'JM');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (6, 2, 'id', 'name', 'Manajer Jurnal');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (7, 2, 'en', 'abbrev', 'JM');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (8, 2, 'en', 'name', 'Journal manager');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (9, 3, '', 'nameLocaleKey', 'default.groups.name.editor');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (10, 3, '', 'abbrevLocaleKey', 'default.groups.abbrev.editor');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (11, 3, 'id', 'abbrev', 'JE');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (12, 3, 'id', 'name', 'Editor Jurnal');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (13, 3, 'en', 'abbrev', 'JE');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (14, 3, 'en', 'name', 'Journal editor');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (15, 4, '', 'nameLocaleKey', 'default.groups.name.productionEditor');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (16, 4, '', 'abbrevLocaleKey', 'default.groups.abbrev.productionEditor');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (17, 4, 'id', 'abbrev', 'ProdE');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (18, 4, 'id', 'name', 'Editor produksi');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (19, 4, 'en', 'abbrev', 'ProdE');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (20, 4, 'en', 'name', 'Production editor');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (21, 5, '', 'nameLocaleKey', 'default.groups.name.sectionEditor');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (22, 5, '', 'abbrevLocaleKey', 'default.groups.abbrev.sectionEditor');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (23, 5, 'id', 'abbrev', 'EdBag');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (24, 5, 'id', 'name', 'Editor Bagian');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (25, 5, 'en', 'abbrev', 'SecE');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (26, 5, 'en', 'name', 'Section editor');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (27, 6, '', 'nameLocaleKey', 'default.groups.name.guestEditor');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (28, 6, '', 'abbrevLocaleKey', 'default.groups.abbrev.guestEditor');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (29, 6, 'id', 'abbrev', 'GE');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (30, 6, 'id', 'name', 'Editor Tamu');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (31, 6, 'en', 'abbrev', 'GE');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (32, 6, 'en', 'name', 'Guest editor');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (33, 7, '', 'nameLocaleKey', 'default.groups.name.copyeditor');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (34, 7, '', 'abbrevLocaleKey', 'default.groups.abbrev.copyeditor');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (35, 7, 'id', 'abbrev', 'CE');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (36, 7, 'id', 'name', 'Copyeditor');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (37, 7, 'en', 'abbrev', 'CE');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (38, 7, 'en', 'name', 'Copyeditor');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (39, 8, '', 'nameLocaleKey', 'default.groups.name.designer');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (40, 8, '', 'abbrevLocaleKey', 'default.groups.abbrev.designer');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (41, 8, 'id', 'abbrev', 'Desain');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (42, 8, 'id', 'name', 'Desainer');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (43, 8, 'en', 'abbrev', 'Design');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (44, 8, 'en', 'name', 'Designer');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (45, 9, '', 'nameLocaleKey', 'default.groups.name.funding');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (46, 9, '', 'abbrevLocaleKey', 'default.groups.abbrev.funding');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (47, 9, 'id', 'abbrev', 'FC');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (48, 9, 'id', 'name', 'Koordinator pendanaan');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (49, 9, 'en', 'abbrev', 'FC');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (50, 9, 'en', 'name', 'Funding coordinator');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (51, 10, '', 'nameLocaleKey', 'default.groups.name.indexer');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (52, 10, '', 'abbrevLocaleKey', 'default.groups.abbrev.indexer');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (53, 10, 'id', 'abbrev', 'IND');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (54, 10, 'id', 'name', 'Pengindeks');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (55, 10, 'en', 'abbrev', 'IND');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (56, 10, 'en', 'name', 'Indexer');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (57, 11, '', 'nameLocaleKey', 'default.groups.name.layoutEditor');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (58, 11, '', 'abbrevLocaleKey', 'default.groups.abbrev.layoutEditor');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (59, 11, 'id', 'abbrev', 'LE');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (60, 11, 'id', 'name', 'Editor Tata Letak');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (61, 11, 'en', 'abbrev', 'LE');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (62, 11, 'en', 'name', 'Layout Editor');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (63, 12, '', 'nameLocaleKey', 'default.groups.name.marketing');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (64, 12, '', 'abbrevLocaleKey', 'default.groups.abbrev.marketing');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (65, 12, 'id', 'abbrev', 'MS');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (66, 12, 'id', 'name', 'Koordinator penjualan dan pemasaran');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (67, 12, 'en', 'abbrev', 'MS');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (68, 12, 'en', 'name', 'Marketing and sales coordinator');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (69, 13, '', 'nameLocaleKey', 'default.groups.name.proofreader');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (70, 13, '', 'abbrevLocaleKey', 'default.groups.abbrev.proofreader');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (71, 13, 'id', 'abbrev', 'PR');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (72, 13, 'id', 'name', 'Proofreader');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (73, 13, 'en', 'abbrev', 'PR');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (74, 13, 'en', 'name', 'Proofreader');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (75, 14, '', 'nameLocaleKey', 'default.groups.name.author');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (76, 14, '', 'abbrevLocaleKey', 'default.groups.abbrev.author');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (77, 14, 'id', 'abbrev', 'AU');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (78, 14, 'id', 'name', 'Penulis');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (79, 14, 'en', 'abbrev', 'AU');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (80, 14, 'en', 'name', 'Author');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (81, 15, '', 'nameLocaleKey', 'default.groups.name.translator');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (82, 15, '', 'abbrevLocaleKey', 'default.groups.abbrev.translator');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (83, 15, 'id', 'abbrev', 'Trans');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (84, 15, 'id', 'name', 'Penerjemah');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (85, 15, 'en', 'abbrev', 'Trans');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (86, 15, 'en', 'name', 'Translator');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (87, 16, '', 'nameLocaleKey', 'default.groups.name.externalReviewer');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (88, 16, '', 'abbrevLocaleKey', 'default.groups.abbrev.externalReviewer');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (89, 16, 'id', 'abbrev', 'R');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (90, 16, 'id', 'name', 'Mitra Bestari');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (91, 16, 'en', 'abbrev', 'R');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (92, 16, 'en', 'name', 'Reviewer');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (93, 17, '', 'nameLocaleKey', 'default.groups.name.reader');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (94, 17, '', 'abbrevLocaleKey', 'default.groups.abbrev.reader');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (95, 17, 'id', 'abbrev', 'Baca');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (96, 17, 'id', 'name', 'Pembaca');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (97, 17, 'en', 'abbrev', 'Read');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (98, 17, 'en', 'name', 'Reader');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (99, 18, '', 'nameLocaleKey', 'default.groups.name.subscriptionManager');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (100, 18, '', 'abbrevLocaleKey', 'default.groups.abbrev.subscriptionManager');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (101, 18, 'id', 'abbrev', 'MReg');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (102, 18, 'id', 'name', 'Manajer Langganan');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (103, 18, 'en', 'abbrev', 'SubM');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (104, 18, 'en', 'name', 'Subscription Manager');
COMMIT;

-- ----------------------------
-- Table structure for user_group_stage
-- ----------------------------
DROP TABLE IF EXISTS `user_group_stage`;
CREATE TABLE `user_group_stage` (
  `user_group_stage_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `context_id` bigint(20) NOT NULL,
  `user_group_id` bigint(20) NOT NULL,
  `stage_id` bigint(20) NOT NULL,
  PRIMARY KEY (`user_group_stage_id`),
  UNIQUE KEY `user_group_stage_unique` (`context_id`,`user_group_id`,`stage_id`),
  KEY `user_group_stage_context_id` (`context_id`),
  KEY `user_group_stage_user_group_id` (`user_group_id`),
  KEY `user_group_stage_stage_id` (`stage_id`),
  CONSTRAINT `user_group_stage_context_id` FOREIGN KEY (`context_id`) REFERENCES `journals` (`journal_id`) ON DELETE CASCADE,
  CONSTRAINT `user_group_stage_user_group_id` FOREIGN KEY (`user_group_id`) REFERENCES `user_groups` (`user_group_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Which stages of the editorial workflow the user_groups can access.';

-- ----------------------------
-- Records of user_group_stage
-- ----------------------------
BEGIN;
INSERT INTO `user_group_stage` (`user_group_stage_id`, `context_id`, `user_group_id`, `stage_id`) VALUES (1, 1, 3, 1);
INSERT INTO `user_group_stage` (`user_group_stage_id`, `context_id`, `user_group_id`, `stage_id`) VALUES (2, 1, 3, 3);
INSERT INTO `user_group_stage` (`user_group_stage_id`, `context_id`, `user_group_id`, `stage_id`) VALUES (3, 1, 3, 4);
INSERT INTO `user_group_stage` (`user_group_stage_id`, `context_id`, `user_group_id`, `stage_id`) VALUES (4, 1, 3, 5);
INSERT INTO `user_group_stage` (`user_group_stage_id`, `context_id`, `user_group_id`, `stage_id`) VALUES (5, 1, 4, 4);
INSERT INTO `user_group_stage` (`user_group_stage_id`, `context_id`, `user_group_id`, `stage_id`) VALUES (6, 1, 4, 5);
INSERT INTO `user_group_stage` (`user_group_stage_id`, `context_id`, `user_group_id`, `stage_id`) VALUES (7, 1, 5, 1);
INSERT INTO `user_group_stage` (`user_group_stage_id`, `context_id`, `user_group_id`, `stage_id`) VALUES (8, 1, 5, 3);
INSERT INTO `user_group_stage` (`user_group_stage_id`, `context_id`, `user_group_id`, `stage_id`) VALUES (9, 1, 5, 4);
INSERT INTO `user_group_stage` (`user_group_stage_id`, `context_id`, `user_group_id`, `stage_id`) VALUES (10, 1, 5, 5);
INSERT INTO `user_group_stage` (`user_group_stage_id`, `context_id`, `user_group_id`, `stage_id`) VALUES (11, 1, 6, 1);
INSERT INTO `user_group_stage` (`user_group_stage_id`, `context_id`, `user_group_id`, `stage_id`) VALUES (12, 1, 6, 3);
INSERT INTO `user_group_stage` (`user_group_stage_id`, `context_id`, `user_group_id`, `stage_id`) VALUES (13, 1, 6, 4);
INSERT INTO `user_group_stage` (`user_group_stage_id`, `context_id`, `user_group_id`, `stage_id`) VALUES (14, 1, 6, 5);
INSERT INTO `user_group_stage` (`user_group_stage_id`, `context_id`, `user_group_id`, `stage_id`) VALUES (15, 1, 7, 4);
INSERT INTO `user_group_stage` (`user_group_stage_id`, `context_id`, `user_group_id`, `stage_id`) VALUES (16, 1, 8, 5);
INSERT INTO `user_group_stage` (`user_group_stage_id`, `context_id`, `user_group_id`, `stage_id`) VALUES (17, 1, 9, 1);
INSERT INTO `user_group_stage` (`user_group_stage_id`, `context_id`, `user_group_id`, `stage_id`) VALUES (18, 1, 9, 3);
INSERT INTO `user_group_stage` (`user_group_stage_id`, `context_id`, `user_group_id`, `stage_id`) VALUES (19, 1, 10, 5);
INSERT INTO `user_group_stage` (`user_group_stage_id`, `context_id`, `user_group_id`, `stage_id`) VALUES (20, 1, 11, 5);
INSERT INTO `user_group_stage` (`user_group_stage_id`, `context_id`, `user_group_id`, `stage_id`) VALUES (21, 1, 12, 4);
INSERT INTO `user_group_stage` (`user_group_stage_id`, `context_id`, `user_group_id`, `stage_id`) VALUES (22, 1, 13, 5);
INSERT INTO `user_group_stage` (`user_group_stage_id`, `context_id`, `user_group_id`, `stage_id`) VALUES (23, 1, 14, 1);
INSERT INTO `user_group_stage` (`user_group_stage_id`, `context_id`, `user_group_id`, `stage_id`) VALUES (24, 1, 14, 3);
INSERT INTO `user_group_stage` (`user_group_stage_id`, `context_id`, `user_group_id`, `stage_id`) VALUES (25, 1, 14, 4);
INSERT INTO `user_group_stage` (`user_group_stage_id`, `context_id`, `user_group_id`, `stage_id`) VALUES (26, 1, 14, 5);
INSERT INTO `user_group_stage` (`user_group_stage_id`, `context_id`, `user_group_id`, `stage_id`) VALUES (27, 1, 15, 1);
INSERT INTO `user_group_stage` (`user_group_stage_id`, `context_id`, `user_group_id`, `stage_id`) VALUES (28, 1, 15, 3);
INSERT INTO `user_group_stage` (`user_group_stage_id`, `context_id`, `user_group_id`, `stage_id`) VALUES (29, 1, 15, 4);
INSERT INTO `user_group_stage` (`user_group_stage_id`, `context_id`, `user_group_id`, `stage_id`) VALUES (30, 1, 15, 5);
INSERT INTO `user_group_stage` (`user_group_stage_id`, `context_id`, `user_group_id`, `stage_id`) VALUES (31, 1, 16, 3);
COMMIT;

-- ----------------------------
-- Table structure for user_groups
-- ----------------------------
DROP TABLE IF EXISTS `user_groups`;
CREATE TABLE `user_groups` (
  `user_group_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `context_id` bigint(20) NOT NULL,
  `role_id` bigint(20) NOT NULL,
  `is_default` smallint(6) NOT NULL DEFAULT 0,
  `show_title` smallint(6) NOT NULL DEFAULT 1,
  `permit_self_registration` smallint(6) NOT NULL DEFAULT 0,
  `permit_metadata_edit` smallint(6) NOT NULL DEFAULT 0,
  PRIMARY KEY (`user_group_id`),
  KEY `user_groups_user_group_id` (`user_group_id`),
  KEY `user_groups_context_id` (`context_id`),
  KEY `user_groups_role_id` (`role_id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='All defined user roles in a context, such as Author, Reviewer, Section Editor and Journal Manager.';

-- ----------------------------
-- Records of user_groups
-- ----------------------------
BEGIN;
INSERT INTO `user_groups` (`user_group_id`, `context_id`, `role_id`, `is_default`, `show_title`, `permit_self_registration`, `permit_metadata_edit`) VALUES (1, 0, 1, 1, 1, 0, 0);
INSERT INTO `user_groups` (`user_group_id`, `context_id`, `role_id`, `is_default`, `show_title`, `permit_self_registration`, `permit_metadata_edit`) VALUES (2, 1, 16, 1, 1, 0, 1);
INSERT INTO `user_groups` (`user_group_id`, `context_id`, `role_id`, `is_default`, `show_title`, `permit_self_registration`, `permit_metadata_edit`) VALUES (3, 1, 16, 1, 1, 0, 1);
INSERT INTO `user_groups` (`user_group_id`, `context_id`, `role_id`, `is_default`, `show_title`, `permit_self_registration`, `permit_metadata_edit`) VALUES (4, 1, 16, 1, 1, 0, 1);
INSERT INTO `user_groups` (`user_group_id`, `context_id`, `role_id`, `is_default`, `show_title`, `permit_self_registration`, `permit_metadata_edit`) VALUES (5, 1, 17, 1, 1, 0, 1);
INSERT INTO `user_groups` (`user_group_id`, `context_id`, `role_id`, `is_default`, `show_title`, `permit_self_registration`, `permit_metadata_edit`) VALUES (6, 1, 17, 1, 1, 0, 0);
INSERT INTO `user_groups` (`user_group_id`, `context_id`, `role_id`, `is_default`, `show_title`, `permit_self_registration`, `permit_metadata_edit`) VALUES (7, 1, 4097, 1, 1, 0, 0);
INSERT INTO `user_groups` (`user_group_id`, `context_id`, `role_id`, `is_default`, `show_title`, `permit_self_registration`, `permit_metadata_edit`) VALUES (8, 1, 4097, 1, 1, 0, 0);
INSERT INTO `user_groups` (`user_group_id`, `context_id`, `role_id`, `is_default`, `show_title`, `permit_self_registration`, `permit_metadata_edit`) VALUES (9, 1, 4097, 1, 1, 0, 0);
INSERT INTO `user_groups` (`user_group_id`, `context_id`, `role_id`, `is_default`, `show_title`, `permit_self_registration`, `permit_metadata_edit`) VALUES (10, 1, 4097, 1, 1, 0, 0);
INSERT INTO `user_groups` (`user_group_id`, `context_id`, `role_id`, `is_default`, `show_title`, `permit_self_registration`, `permit_metadata_edit`) VALUES (11, 1, 4097, 1, 1, 0, 0);
INSERT INTO `user_groups` (`user_group_id`, `context_id`, `role_id`, `is_default`, `show_title`, `permit_self_registration`, `permit_metadata_edit`) VALUES (12, 1, 4097, 1, 1, 0, 0);
INSERT INTO `user_groups` (`user_group_id`, `context_id`, `role_id`, `is_default`, `show_title`, `permit_self_registration`, `permit_metadata_edit`) VALUES (13, 1, 4097, 1, 1, 0, 0);
INSERT INTO `user_groups` (`user_group_id`, `context_id`, `role_id`, `is_default`, `show_title`, `permit_self_registration`, `permit_metadata_edit`) VALUES (14, 1, 65536, 1, 1, 1, 0);
INSERT INTO `user_groups` (`user_group_id`, `context_id`, `role_id`, `is_default`, `show_title`, `permit_self_registration`, `permit_metadata_edit`) VALUES (15, 1, 65536, 1, 1, 0, 0);
INSERT INTO `user_groups` (`user_group_id`, `context_id`, `role_id`, `is_default`, `show_title`, `permit_self_registration`, `permit_metadata_edit`) VALUES (16, 1, 4096, 1, 1, 1, 0);
INSERT INTO `user_groups` (`user_group_id`, `context_id`, `role_id`, `is_default`, `show_title`, `permit_self_registration`, `permit_metadata_edit`) VALUES (17, 1, 1048576, 1, 1, 1, 0);
INSERT INTO `user_groups` (`user_group_id`, `context_id`, `role_id`, `is_default`, `show_title`, `permit_self_registration`, `permit_metadata_edit`) VALUES (18, 1, 2097152, 1, 1, 0, 0);
COMMIT;

-- ----------------------------
-- Table structure for user_interests
-- ----------------------------
DROP TABLE IF EXISTS `user_interests`;
CREATE TABLE `user_interests` (
  `user_interest_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `controlled_vocab_entry_id` bigint(20) NOT NULL,
  PRIMARY KEY (`user_interest_id`),
  UNIQUE KEY `u_e_pkey` (`user_id`,`controlled_vocab_entry_id`),
  KEY `user_interests_user_id` (`user_id`),
  KEY `user_interests_controlled_vocab_entry_id` (`controlled_vocab_entry_id`),
  CONSTRAINT `user_interests_controlled_vocab_entry_id_foreign` FOREIGN KEY (`controlled_vocab_entry_id`) REFERENCES `controlled_vocab_entries` (`controlled_vocab_entry_id`) ON DELETE CASCADE,
  CONSTRAINT `user_interests_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Associates users with user interests (which are stored in the controlled vocabulary tables).';

-- ----------------------------
-- Records of user_interests
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for user_settings
-- ----------------------------
DROP TABLE IF EXISTS `user_settings`;
CREATE TABLE `user_settings` (
  `user_setting_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `locale` varchar(14) NOT NULL DEFAULT '',
  `setting_name` varchar(255) NOT NULL,
  `setting_value` mediumtext DEFAULT NULL,
  PRIMARY KEY (`user_setting_id`),
  UNIQUE KEY `user_settings_unique` (`user_id`,`locale`,`setting_name`),
  KEY `user_settings_user_id` (`user_id`),
  KEY `user_settings_locale_setting_name_index` (`setting_name`,`locale`),
  CONSTRAINT `user_settings_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='More data about users, including localized properties like their name and affiliation.';

-- ----------------------------
-- Records of user_settings
-- ----------------------------
BEGIN;
INSERT INTO `user_settings` (`user_setting_id`, `user_id`, `locale`, `setting_name`, `setting_value`) VALUES (1, 1, 'en', 'familyName', 'peacee');
INSERT INTO `user_settings` (`user_setting_id`, `user_id`, `locale`, `setting_name`, `setting_value`) VALUES (2, 1, 'en', 'givenName', 'peacee');
COMMIT;

-- ----------------------------
-- Table structure for user_user_groups
-- ----------------------------
DROP TABLE IF EXISTS `user_user_groups`;
CREATE TABLE `user_user_groups` (
  `user_user_group_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_group_id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  PRIMARY KEY (`user_user_group_id`),
  UNIQUE KEY `user_user_groups_unique` (`user_group_id`,`user_id`),
  KEY `user_user_groups_user_group_id` (`user_group_id`),
  KEY `user_user_groups_user_id` (`user_id`),
  CONSTRAINT `user_user_groups_user_group_id_foreign` FOREIGN KEY (`user_group_id`) REFERENCES `user_groups` (`user_group_id`) ON DELETE CASCADE,
  CONSTRAINT `user_user_groups_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Maps users to their assigned user_groups.';

-- ----------------------------
-- Records of user_user_groups
-- ----------------------------
BEGIN;
INSERT INTO `user_user_groups` (`user_user_group_id`, `user_group_id`, `user_id`) VALUES (1, 1, 1);
INSERT INTO `user_user_groups` (`user_user_group_id`, `user_group_id`, `user_id`) VALUES (2, 2, 1);
COMMIT;

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `user_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `username` varchar(32) NOT NULL,
  `password` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `url` varchar(2047) DEFAULT NULL,
  `phone` varchar(32) DEFAULT NULL,
  `mailing_address` varchar(255) DEFAULT NULL,
  `billing_address` varchar(255) DEFAULT NULL,
  `country` varchar(90) DEFAULT NULL,
  `locales` varchar(255) NOT NULL DEFAULT '[]',
  `gossip` text DEFAULT NULL,
  `date_last_email` datetime DEFAULT NULL,
  `date_registered` datetime NOT NULL,
  `date_validated` datetime DEFAULT NULL,
  `date_last_login` datetime DEFAULT NULL,
  `must_change_password` smallint(6) DEFAULT NULL,
  `auth_id` bigint(20) DEFAULT NULL,
  `auth_str` varchar(255) DEFAULT NULL,
  `disabled` smallint(6) NOT NULL DEFAULT 0,
  `disabled_reason` text DEFAULT NULL,
  `inline_help` smallint(6) DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `users_username` (`username`),
  UNIQUE KEY `users_email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='All registered users, including authentication data and profile data.';

-- ----------------------------
-- Records of users
-- ----------------------------
BEGIN;
INSERT INTO `users` (`user_id`, `username`, `password`, `email`, `url`, `phone`, `mailing_address`, `billing_address`, `country`, `locales`, `gossip`, `date_last_email`, `date_registered`, `date_validated`, `date_last_login`, `must_change_password`, `auth_id`, `auth_str`, `disabled`, `disabled_reason`, `inline_help`) VALUES (1, 'peacee', '$2y$10$xcq45yAS59tQXmSSQCaS8uLt3C9Y.FlKEkYNLtpKSoOGD6deqOE6K', 'deewahyu@upi.edu', NULL, NULL, NULL, NULL, NULL, '[]', NULL, NULL, '2024-10-24 22:17:29', NULL, '2024-10-24 22:18:01', NULL, NULL, NULL, 0, NULL, 1);
COMMIT;

-- ----------------------------
-- Table structure for versions
-- ----------------------------
DROP TABLE IF EXISTS `versions`;
CREATE TABLE `versions` (
  `version_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `major` int(11) NOT NULL DEFAULT 0 COMMENT 'Major component of version number, e.g. the 2 in OJS 2.3.8-0',
  `minor` int(11) NOT NULL DEFAULT 0 COMMENT 'Minor component of version number, e.g. the 3 in OJS 2.3.8-0',
  `revision` int(11) NOT NULL DEFAULT 0 COMMENT 'Revision component of version number, e.g. the 8 in OJS 2.3.8-0',
  `build` int(11) NOT NULL DEFAULT 0 COMMENT 'Build component of version number, e.g. the 0 in OJS 2.3.8-0',
  `date_installed` datetime NOT NULL,
  `current` smallint(6) NOT NULL DEFAULT 0 COMMENT '1 iff the version entry being described is currently active. This permits the table to store past installation history for forensic purposes.',
  `product_type` varchar(30) DEFAULT NULL COMMENT 'Describes the type of product this row describes, e.g. "plugins.generic" (for a generic plugin) or "core" for the application itself',
  `product` varchar(30) DEFAULT NULL COMMENT 'Uniquely identifies the product this version row describes, e.g. "ojs2" for OJS 2.x, "languageToggle" for the language toggle block plugin, etc.',
  `product_class_name` varchar(80) DEFAULT NULL COMMENT 'Specifies the class name associated with this product, for plugins, or the empty string where not applicable.',
  `lazy_load` smallint(6) NOT NULL DEFAULT 0 COMMENT '1 iff the row describes a lazy-load plugin; 0 otherwise',
  `sitewide` smallint(6) NOT NULL DEFAULT 0 COMMENT '1 iff the row describes a site-wide plugin; 0 otherwise',
  PRIMARY KEY (`version_id`),
  UNIQUE KEY `versions_unique` (`product_type`,`product`,`major`,`minor`,`revision`,`build`)
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Describes the installation and upgrade version history for the application and all installed plugins.';

-- ----------------------------
-- Records of versions
-- ----------------------------
BEGIN;
INSERT INTO `versions` (`version_id`, `major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES (1, 1, 0, 0, 0, '2024-10-24 22:17:31', 1, 'plugins.metadata', 'dc11', '', 0, 0);
INSERT INTO `versions` (`version_id`, `major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES (2, 1, 0, 0, 0, '2024-10-24 22:17:31', 1, 'plugins.blocks', 'developedBy', 'DevelopedByBlockPlugin', 1, 0);
INSERT INTO `versions` (`version_id`, `major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES (3, 1, 0, 0, 0, '2024-10-24 22:17:31', 1, 'plugins.blocks', 'information', 'InformationBlockPlugin', 1, 0);
INSERT INTO `versions` (`version_id`, `major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES (4, 1, 1, 0, 0, '2024-10-24 22:17:31', 1, 'plugins.blocks', 'subscription', 'SubscriptionBlockPlugin', 1, 0);
INSERT INTO `versions` (`version_id`, `major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES (5, 1, 0, 1, 0, '2024-10-24 22:17:31', 1, 'plugins.blocks', 'browse', 'BrowseBlockPlugin', 1, 0);
INSERT INTO `versions` (`version_id`, `major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES (6, 1, 0, 0, 0, '2024-10-24 22:17:31', 1, 'plugins.blocks', 'makeSubmission', 'MakeSubmissionBlockPlugin', 1, 0);
INSERT INTO `versions` (`version_id`, `major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES (7, 1, 0, 0, 0, '2024-10-24 22:17:31', 1, 'plugins.blocks', 'languageToggle', 'LanguageToggleBlockPlugin', 1, 0);
INSERT INTO `versions` (`version_id`, `major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES (8, 1, 0, 0, 0, '2024-10-24 22:17:31', 1, 'plugins.gateways', 'resolver', '', 0, 0);
INSERT INTO `versions` (`version_id`, `major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES (9, 1, 0, 1, 0, '2024-10-24 22:17:31', 1, 'plugins.generic', 'pdfJsViewer', 'PdfJsViewerPlugin', 1, 0);
INSERT INTO `versions` (`version_id`, `major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES (10, 1, 0, 0, 0, '2024-10-24 22:17:31', 1, 'plugins.generic', 'webFeed', 'WebFeedPlugin', 1, 0);
INSERT INTO `versions` (`version_id`, `major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES (11, 1, 2, 0, 0, '2024-10-24 22:17:31', 1, 'plugins.generic', 'staticPages', 'StaticPagesPlugin', 1, 0);
INSERT INTO `versions` (`version_id`, `major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES (12, 1, 2, 0, 0, '2024-10-24 22:17:31', 1, 'plugins.generic', 'customBlockManager', 'CustomBlockManagerPlugin', 1, 0);
INSERT INTO `versions` (`version_id`, `major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES (13, 1, 3, 0, 0, '2024-10-24 22:17:31', 1, 'plugins.generic', 'acron', 'AcronPlugin', 1, 1);
INSERT INTO `versions` (`version_id`, `major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES (14, 1, 0, 0, 0, '2024-10-24 22:17:31', 1, 'plugins.generic', 'driver', 'DRIVERPlugin', 1, 0);
INSERT INTO `versions` (`version_id`, `major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES (15, 2, 0, 0, 0, '2024-10-24 22:17:31', 1, 'plugins.generic', 'datacite', '', 0, 0);
INSERT INTO `versions` (`version_id`, `major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES (16, 1, 0, 0, 0, '2024-10-24 22:17:31', 1, 'plugins.generic', 'recommendBySimilarity', 'RecommendBySimilarityPlugin', 1, 1);
INSERT INTO `versions` (`version_id`, `major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES (17, 1, 1, 0, 0, '2024-10-24 22:17:31', 1, 'plugins.generic', 'googleScholar', 'GoogleScholarPlugin', 1, 0);
INSERT INTO `versions` (`version_id`, `major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES (18, 1, 0, 0, 0, '2024-10-24 22:17:31', 1, 'plugins.generic', 'usageEvent', '', 0, 0);
INSERT INTO `versions` (`version_id`, `major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES (19, 1, 0, 1, 0, '2024-10-24 22:17:31', 1, 'plugins.generic', 'lensGalley', 'LensGalleyPlugin', 1, 0);
INSERT INTO `versions` (`version_id`, `major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES (20, 1, 0, 0, 0, '2024-10-24 22:17:31', 1, 'plugins.generic', 'announcementFeed', 'AnnouncementFeedPlugin', 1, 0);
INSERT INTO `versions` (`version_id`, `major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES (21, 3, 0, 0, 0, '2024-10-24 22:17:31', 1, 'plugins.generic', 'crossref', '', 0, 0);
INSERT INTO `versions` (`version_id`, `major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES (22, 1, 0, 0, 0, '2024-10-24 22:17:31', 1, 'plugins.generic', 'tinymce', 'TinyMCEPlugin', 1, 0);
INSERT INTO `versions` (`version_id`, `major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES (23, 1, 0, 0, 1, '2024-10-24 22:17:31', 1, 'plugins.generic', 'recommendByAuthor', 'RecommendByAuthorPlugin', 1, 1);
INSERT INTO `versions` (`version_id`, `major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES (24, 1, 3, 4, 3, '2024-10-24 22:17:31', 1, 'plugins.generic', 'orcidProfile', 'OrcidProfilePlugin', 1, 0);
INSERT INTO `versions` (`version_id`, `major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES (25, 1, 0, 0, 0, '2024-10-24 22:17:31', 1, 'plugins.generic', 'googleAnalytics', 'GoogleAnalyticsPlugin', 1, 0);
INSERT INTO `versions` (`version_id`, `major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES (26, 1, 0, 0, 0, '2024-10-24 22:17:31', 1, 'plugins.generic', 'htmlArticleGalley', 'HtmlArticleGalleyPlugin', 1, 0);
INSERT INTO `versions` (`version_id`, `major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES (27, 0, 1, 0, 0, '2024-10-24 22:17:31', 1, 'plugins.generic', 'citationStyleLanguage', 'CitationStyleLanguagePlugin', 1, 0);
INSERT INTO `versions` (`version_id`, `major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES (28, 1, 0, 0, 0, '2024-10-24 22:17:31', 1, 'plugins.generic', 'dublinCoreMeta', 'DublinCoreMetaPlugin', 1, 0);
INSERT INTO `versions` (`version_id`, `major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES (29, 1, 0, 0, 0, '2024-10-24 22:17:31', 1, 'plugins.importexport', 'native', '', 0, 0);
INSERT INTO `versions` (`version_id`, `major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES (30, 1, 0, 0, 0, '2024-10-24 22:17:31', 1, 'plugins.importexport', 'users', '', 0, 0);
INSERT INTO `versions` (`version_id`, `major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES (31, 1, 0, 0, 0, '2024-10-24 22:17:31', 1, 'plugins.importexport', 'pubmed', '', 0, 0);
INSERT INTO `versions` (`version_id`, `major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES (32, 1, 0, 0, 0, '2024-10-24 22:17:31', 1, 'plugins.oaiMetadataFormats', 'rfc1807', '', 0, 0);
INSERT INTO `versions` (`version_id`, `major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES (33, 1, 0, 0, 0, '2024-10-24 22:17:31', 1, 'plugins.oaiMetadataFormats', 'dc', '', 0, 0);
INSERT INTO `versions` (`version_id`, `major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES (34, 1, 0, 0, 0, '2024-10-24 22:17:31', 1, 'plugins.oaiMetadataFormats', 'marcxml', '', 0, 0);
INSERT INTO `versions` (`version_id`, `major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES (35, 1, 0, 0, 0, '2024-10-24 22:17:31', 1, 'plugins.oaiMetadataFormats', 'marc', '', 0, 0);
INSERT INTO `versions` (`version_id`, `major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES (36, 1, 0, 0, 0, '2024-10-24 22:17:31', 1, 'plugins.paymethod', 'paypal', '', 0, 0);
INSERT INTO `versions` (`version_id`, `major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES (37, 1, 0, 0, 0, '2024-10-24 22:17:31', 1, 'plugins.paymethod', 'manual', '', 0, 0);
INSERT INTO `versions` (`version_id`, `major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES (38, 1, 0, 0, 0, '2024-10-24 22:17:31', 1, 'plugins.pubIds', 'urn', 'URNPubIdPlugin', 1, 0);
INSERT INTO `versions` (`version_id`, `major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES (39, 1, 0, 0, 0, '2024-10-24 22:17:31', 1, 'plugins.reports', 'articles', '', 0, 0);
INSERT INTO `versions` (`version_id`, `major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES (40, 1, 0, 0, 0, '2024-10-24 22:17:31', 1, 'plugins.reports', 'subscriptions', '', 0, 0);
INSERT INTO `versions` (`version_id`, `major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES (41, 2, 0, 1, 0, '2024-10-24 22:17:31', 1, 'plugins.reports', 'reviewReport', '', 0, 0);
INSERT INTO `versions` (`version_id`, `major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES (42, 1, 1, 0, 0, '2024-10-24 22:17:31', 1, 'plugins.reports', 'counterReport', '', 0, 0);
INSERT INTO `versions` (`version_id`, `major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES (43, 1, 0, 0, 0, '2024-10-24 22:17:31', 1, 'plugins.themes', 'default', 'DefaultThemePlugin', 1, 0);
INSERT INTO `versions` (`version_id`, `major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES (44, 3, 4, 0, 0, '2024-10-24 22:17:05', 1, 'core', 'ojs2', '', 0, 1);
INSERT INTO `versions` (`version_id`, `major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES (45, 1, 1, 0, 0, '2024-10-24 22:20:54', 1, 'plugins.importexport', 'doaj', '', 0, 0);
COMMIT;

SET FOREIGN_KEY_CHECKS = 1;
