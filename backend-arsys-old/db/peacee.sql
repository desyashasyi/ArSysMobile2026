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

 Date: 25/10/2024 04:50:03
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
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='More data about authors, including localized properties such as their name and affiliation.';

-- ----------------------------
-- Records of author_settings
-- ----------------------------
BEGIN;
INSERT INTO `author_settings` (`author_setting_id`, `author_id`, `locale`, `setting_name`, `setting_value`) VALUES (1, 1, 'en', 'affiliation', '');
INSERT INTO `author_settings` (`author_setting_id`, `author_id`, `locale`, `setting_name`, `setting_value`) VALUES (2, 1, 'en', 'biography', '');
INSERT INTO `author_settings` (`author_setting_id`, `author_id`, `locale`, `setting_name`, `setting_value`) VALUES (3, 1, '', 'country', 'ID');
INSERT INTO `author_settings` (`author_setting_id`, `author_id`, `locale`, `setting_name`, `setting_value`) VALUES (4, 1, 'en', 'familyName', 'Adrian');
INSERT INTO `author_settings` (`author_setting_id`, `author_id`, `locale`, `setting_name`, `setting_value`) VALUES (5, 1, 'en', 'givenName', 'Ronald');
INSERT INTO `author_settings` (`author_setting_id`, `author_id`, `locale`, `setting_name`, `setting_value`) VALUES (6, 1, '', 'orcid', '');
INSERT INTO `author_settings` (`author_setting_id`, `author_id`, `locale`, `setting_name`, `setting_value`) VALUES (7, 1, '', 'url', '');
INSERT INTO `author_settings` (`author_setting_id`, `author_id`, `locale`, `setting_name`, `setting_value`) VALUES (8, 2, 'en', 'affiliation', '');
INSERT INTO `author_settings` (`author_setting_id`, `author_id`, `locale`, `setting_name`, `setting_value`) VALUES (9, 2, 'en', 'biography', '');
INSERT INTO `author_settings` (`author_setting_id`, `author_id`, `locale`, `setting_name`, `setting_value`) VALUES (10, 2, '', 'country', 'ID');
INSERT INTO `author_settings` (`author_setting_id`, `author_id`, `locale`, `setting_name`, `setting_value`) VALUES (11, 2, 'en', 'familyName', 'Adrian');
INSERT INTO `author_settings` (`author_setting_id`, `author_id`, `locale`, `setting_name`, `setting_value`) VALUES (12, 2, 'en', 'givenName', 'Ronald');
INSERT INTO `author_settings` (`author_setting_id`, `author_id`, `locale`, `setting_name`, `setting_value`) VALUES (13, 2, '', 'orcid', '');
INSERT INTO `author_settings` (`author_setting_id`, `author_id`, `locale`, `setting_name`, `setting_value`) VALUES (14, 2, '', 'url', '');
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='The authors of a publication.';

-- ----------------------------
-- Records of authors
-- ----------------------------
BEGIN;
INSERT INTO `authors` (`author_id`, `email`, `include_in_browse`, `publication_id`, `seq`, `user_group_id`) VALUES (1, 'ronald.adr@gmail.com', 1, 1, 0.00, 14);
INSERT INTO `authors` (`author_id`, `email`, `include_in_browse`, `publication_id`, `seq`, `user_group_id`) VALUES (2, 'ronald.adr@gmail.com', 1, 2, 0.00, 14);
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='The order that a word or phrase used in a controlled vocabulary should appear. For example, the order of keywords in a publication.';

-- ----------------------------
-- Records of controlled_vocab_entries
-- ----------------------------
BEGIN;
INSERT INTO `controlled_vocab_entries` (`controlled_vocab_entry_id`, `controlled_vocab_id`, `seq`) VALUES (1, 7, 1.00);
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='More data about a controlled vocabulary entry, including localized properties such as the actual word or phrase.';

-- ----------------------------
-- Records of controlled_vocab_entry_settings
-- ----------------------------
BEGIN;
INSERT INTO `controlled_vocab_entry_settings` (`controlled_vocab_entry_setting_id`, `controlled_vocab_entry_id`, `locale`, `setting_name`, `setting_value`, `setting_type`) VALUES (1, 1, 'en', 'submissionKeyword', 'tes2', 'string');
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
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Every word or phrase used in a controlled vocabulary. Controlled vocabularies are used for submission metadata like keywords and subjects, reviewer interests, and wherever a similar dictionary of words or phrases is required. Each entry corresponds to a word or phrase like "cellular reproduction" and a type like "submissionKeyword".';

-- ----------------------------
-- Records of controlled_vocabs
-- ----------------------------
BEGIN;
INSERT INTO `controlled_vocabs` (`controlled_vocab_id`, `symbolic`, `assoc_type`, `assoc_id`) VALUES (1, 'interest', 0, 0);
INSERT INTO `controlled_vocabs` (`controlled_vocab_id`, `symbolic`, `assoc_type`, `assoc_id`) VALUES (6, 'submissionAgency', 1048588, 1);
INSERT INTO `controlled_vocabs` (`controlled_vocab_id`, `symbolic`, `assoc_type`, `assoc_id`) VALUES (11, 'submissionAgency', 1048588, 2);
INSERT INTO `controlled_vocabs` (`controlled_vocab_id`, `symbolic`, `assoc_type`, `assoc_id`) VALUES (4, 'submissionDiscipline', 1048588, 1);
INSERT INTO `controlled_vocabs` (`controlled_vocab_id`, `symbolic`, `assoc_type`, `assoc_id`) VALUES (9, 'submissionDiscipline', 1048588, 2);
INSERT INTO `controlled_vocabs` (`controlled_vocab_id`, `symbolic`, `assoc_type`, `assoc_id`) VALUES (2, 'submissionKeyword', 1048588, 1);
INSERT INTO `controlled_vocabs` (`controlled_vocab_id`, `symbolic`, `assoc_type`, `assoc_id`) VALUES (7, 'submissionKeyword', 1048588, 2);
INSERT INTO `controlled_vocabs` (`controlled_vocab_id`, `symbolic`, `assoc_type`, `assoc_id`) VALUES (5, 'submissionLanguage', 1048588, 1);
INSERT INTO `controlled_vocabs` (`controlled_vocab_id`, `symbolic`, `assoc_type`, `assoc_id`) VALUES (10, 'submissionLanguage', 1048588, 2);
INSERT INTO `controlled_vocabs` (`controlled_vocab_id`, `symbolic`, `assoc_type`, `assoc_id`) VALUES (3, 'submissionSubject', 1048588, 1);
INSERT INTO `controlled_vocabs` (`controlled_vocab_id`, `symbolic`, `assoc_type`, `assoc_id`) VALUES (8, 'submissionSubject', 1048588, 2);
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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='A record of email messages that are sent in relation to an associated entity, such as a submission.';

-- ----------------------------
-- Records of email_log
-- ----------------------------
BEGIN;
INSERT INTO `email_log` (`log_id`, `assoc_type`, `assoc_id`, `sender_id`, `date_sent`, `event_type`, `from_address`, `recipients`, `cc_recipients`, `bcc_recipients`, `subject`, `body`) VALUES (1, 1048585, 1, 0, '2024-10-09 08:23:35', 805306373, '\"Didin Wahyudin\" <deewahyu@upi.edu>', '\"peacee peacee\" <fpteupi@gmail.com>', '', '', 'A new submission needs an editor to be assigned: tes', '<p>Dear peacee peacee,</p><p>The following submission has been submitted and there is no editor assigned.</p><p><a href=\"http://peacee.id/index.php/journal/workflow/access/1\">tes</a><br />Ronald Adrian</p><p><b>Abstract</b></p><p>tes</p><p>Please assign an editor who will be responsible for the submission by clicking the title above and assigning an editor under the Participants section.</p><hr><p>This is an automated email from <a href=\"http://peacee.id/index.php/journal\">Progress in Electrical and Computer Engineering Education</a>.</p>');
INSERT INTO `email_log` (`log_id`, `assoc_type`, `assoc_id`, `sender_id`, `date_sent`, `event_type`, `from_address`, `recipients`, `cc_recipients`, `bcc_recipients`, `subject`, `body`) VALUES (2, 1048585, 1, 0, '2024-10-09 08:23:35', 536870914, '\"Didin Wahyudin\" <deewahyu@upi.edu>', '\"Ronald Adrian\" <ronald.adr@gmail.com>', '', '', 'Thank you for your submission to Progress in Electrical and Computer Engineering Education', '<p>Dear Ronald Adrian,</p><p>Thank you for your submission to Progress in Electrical and Computer Engineering Education. We have received your submission, tes, and a member of our editorial team will see it soon. You will be sent an email when an initial decision is made, and we may contact you for further information.</p><p>You can view your submission and track its progress through the editorial process at the following location:</p><p>Submission URL: http://peacee.id/index.php/journal/authorDashboard/submission/1</p><p>If you have been logged out, you can login again with the username ra12345.</p><p>If you have any questions, please contact me from your <a href=\"http://peacee.id/index.php/journal/authorDashboard/submission/1\">submission dashboard</a>.</p><p>Thank you for considering Progress in Electrical and Computer Engineering Education as a venue for your work.</p><br><br>—<br><p>This is an automated message from <a href=\"http://peacee.id/index.php/peacee\">Progress in Electrical and Computer Engineering Education</a>.</p>');
INSERT INTO `email_log` (`log_id`, `assoc_type`, `assoc_id`, `sender_id`, `date_sent`, `event_type`, `from_address`, `recipients`, `cc_recipients`, `bcc_recipients`, `subject`, `body`) VALUES (3, 1048585, 2, 0, '2024-10-09 08:26:10', 805306373, '\"Didin Wahyudin\" <deewahyu@upi.edu>', '\"peacee peacee\" <fpteupi@gmail.com>', '', '', 'A new submission needs an editor to be assigned: tes2', '<p>Dear peacee peacee,</p><p>The following submission has been submitted and there is no editor assigned.</p><p><a href=\"http://peacee.id/index.php/journal/workflow/access/2\">tes2</a><br />Ronald Adrian</p><p><b>Abstract</b></p><p>tes2</p><p>Please assign an editor who will be responsible for the submission by clicking the title above and assigning an editor under the Participants section.</p><hr><p>This is an automated email from <a href=\"http://peacee.id/index.php/journal\">Progress in Electrical and Computer Engineering Education</a>.</p>');
INSERT INTO `email_log` (`log_id`, `assoc_type`, `assoc_id`, `sender_id`, `date_sent`, `event_type`, `from_address`, `recipients`, `cc_recipients`, `bcc_recipients`, `subject`, `body`) VALUES (4, 1048585, 2, 0, '2024-10-09 08:26:10', 536870914, '\"Didin Wahyudin\" <deewahyu@upi.edu>', '\"Ronald Adrian\" <ronald.adr@gmail.com>', '', '', 'Thank you for your submission to Progress in Electrical and Computer Engineering Education', '<p>Dear Ronald Adrian,</p><p>Thank you for your submission to Progress in Electrical and Computer Engineering Education. We have received your submission, tes2, and a member of our editorial team will see it soon. You will be sent an email when an initial decision is made, and we may contact you for further information.</p><p>You can view your submission and track its progress through the editorial process at the following location:</p><p>Submission URL: http://peacee.id/index.php/journal/authorDashboard/submission/2</p><p>If you have been logged out, you can login again with the username ra12345.</p><p>If you have any questions, please contact me from your <a href=\"http://peacee.id/index.php/journal/authorDashboard/submission/2\">submission dashboard</a>.</p><p>Thank you for considering Progress in Electrical and Computer Engineering Education as a venue for your work.</p><br><br>—<br><p>This is an automated message from <a href=\"http://peacee.id/index.php/peacee\">Progress in Electrical and Computer Engineering Education</a>.</p>');
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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='A record of users associated with an email log entry.';

-- ----------------------------
-- Records of email_log_users
-- ----------------------------
BEGIN;
INSERT INTO `email_log_users` (`email_log_user_id`, `email_log_id`, `user_id`) VALUES (1, 1, 1);
INSERT INTO `email_log_users` (`email_log_user_id`, `email_log_id`, `user_id`) VALUES (2, 2, 4);
INSERT INTO `email_log_users` (`email_log_user_id`, `email_log_id`, `user_id`) VALUES (3, 3, 1);
INSERT INTO `email_log_users` (`email_log_user_id`, `email_log_id`, `user_id`) VALUES (4, 4, 4);
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
) ENGINE=InnoDB AUTO_INCREMENT=70 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Default email templates created for every installed locale.';

-- ----------------------------
-- Records of email_templates_default_data
-- ----------------------------
BEGIN;
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (1, 'PASSWORD_RESET_CONFIRM', 'en', 'Password Reset Confirm', 'Password Reset Confirmation', 'We have received a request to reset your password for the {$siteTitle} web site.<br />\n<br />\nIf you did not make this request, please ignore this email and your password will not be changed. If you wish to reset your password, click on the below URL.<br />\n<br />\nReset my password: {$lostPasswordUrl}<br />\n<br />\n{$siteContactName}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (2, 'USER_REGISTER', 'en', 'User Created', 'Journal Registration', '{$recipientName}<br />\n<br />\nYou have now been registered as a user with {$journalName}. We have included your username and password in this email, which are needed for all work with this journal through its website. At any point, you can ask to be removed from the journal\'s list of users by contacting me.<br />\n<br />\nUsername: {$recipientUsername}<br />\nPassword: {$password}<br />\n<br />\nThank you,<br />\n{$signature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (3, 'USER_VALIDATE_CONTEXT', 'en', 'Validate Email (Journal Registration)', 'Validate Your Account', '{$recipientName}<br />\n<br />\nYou have created an account with {$journalName}, but before you can start using it, you need to validate your email account. To do this, simply follow the link below:<br />\n<br />\n{$activateUrl}<br />\n<br />\nThank you,<br />\n{$journalSignature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (4, 'USER_VALIDATE_SITE', 'en', 'Validate Email (Site)', 'Validate Your Account', '{$recipientName}<br />\n<br />\nYou have created an account with {$siteTitle}, but before you can start using it, you need to validate your email account. To do this, simply follow the link below:<br />\n<br />\n{$activateUrl}<br />\n<br />\nThank you,<br />\n{$siteSignature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (5, 'REVIEWER_REGISTER', 'en', 'Reviewer Register', 'Registration as Reviewer with {$journalName}', '<p>Dear {$recipientName},</p><p>In light of your expertise, we have registered your name in the reviewer database for {$journalName}. This does not entail any form of commitment on your part, but simply enables us to approach you with a submission to possibly review. On being invited to review, you will have an opportunity to see the title and abstract of the paper in question, and you\'ll always be in a position to accept or decline the invitation. You can also ask at any point to have your name removed from this reviewer list.</p><p>We are providing you with a username and password, which is used in all interactions with the journal through its website. You may wish, for example, to update your profile, including your reviewing interests.</p><p>Username: {$recipientUsername}<br />Password: {$password}</p><p>Thank you,</p>{$signature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (6, 'ISSUE_PUBLISH_NOTIFY', 'en', 'Issue Published Notify', 'Just published: {$issueIdentification} of {$journalName}', '<p>Dear {$recipientName},</p><p>We are pleased to announce the publication of <a href=\"{$issueUrl}\">{$issueIdentification}</a> of {$journalName}.  We invite you to read and share this work with your scholarly community.</p><p>Many thanks to our authors, reviewers, and editors for their valuable contributions, and to our readers for your continued interest.</p><p>Thank you,</p>{$signature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (7, 'SUBMISSION_ACK', 'en', 'Submission Confirmation', 'Thank you for your submission to {$journalName}', '<p>Dear {$recipientName},</p><p>Thank you for your submission to {$journalName}. We have received your submission, {$submissionTitle}, and a member of our editorial team will see it soon. You will be sent an email when an initial decision is made, and we may contact you for further information.</p><p>You can view your submission and track its progress through the editorial process at the following location:</p><p>Submission URL: {$authorSubmissionUrl}</p><p>If you have been logged out, you can login again with the username {$recipientUsername}.</p><p>If you have any questions, please contact me from your <a href=\"{$authorSubmissionUrl}\">submission dashboard</a>.</p><p>Thank you for considering {$journalName} as a venue for your work.</p>{$journalSignature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (8, 'SUBMISSION_ACK_NOT_USER', 'en', 'Submission Confirmation (Other Authors)', 'Submission confirmation', '<p>Dear {$recipientName},</p><p>You have been named as a co-author on a submission to {$journalName}. The submitter, {$submitterName}, provided the following details:</p><p>{$submissionTitle}<br>{$authorsWithAffiliation}</p><p>If any of these details are incorrect, or you do not wish to be named on this submission, please contact me.</p><p>Thank you for considering {$journalName} as a venue for your work.</p><p>Kind regards,</p>{$journalSignature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (9, 'EDITOR_ASSIGN', 'en', 'Editor Assigned', 'You have been assigned as an editor on a submission to {$journalName}', '<p>Dear {$recipientName},</p><p>The following submission has been assigned to you to see through the editorial process.</p><p><a href=\"{$submissionUrl}\">{$submissionTitle}</a><br />{$authors}</p><p><b>Abstract</b></p>{$submissionAbstract}<p>If you find the submission to be relevant for {$journalName}, please forward the submission to the review stage by selecting \"Send to Review\" and then assign reviewers by clicking \"Add Reviewer\".</p><p>If the submission is not appropriate for this journal, please decline the submission.</p><p>Thank you in advance.</p><p>Kind regards,</p>{$journalSignature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (10, 'REVIEW_CANCEL', 'en', 'Reviewer Unassign', 'Request for Review Cancelled', '<p>Dear {$recipientName},</p><p>Recently, we asked you to review a submission to {$journalName}. We have decided to cancel the request for you to reivew the submission, {$submissionTitle}.</p><p>We apologize any inconvenience this may cause you and hope that we will be able to call on you to assist with this journal\'s review process in the future.</p><p>If you have any questions, please contact me.</p>{$signature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (11, 'REVIEW_REINSTATE', 'en', 'Reviewer Reinstate', 'Can you still review something for {$journalName}?', '<p>Dear {$recipientName},</p><p>We recently cancelled our request for you to review a submission, {$submissionTitle}, for {$journalName}. We\'ve reversed that decision and we hope that you are still able to conduct the review.</p><p>If you are able to assist with this submission\'s review, you can <a href=\"{$reviewAssignmentUrl}\">login to the journal</a> to view the submission, upload review files, and submit your review request.</p><p>If you have any questions, please contact me.</p><p>Kind regards,</p>{$signature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (12, 'REVIEW_RESEND_REQUEST', 'en', 'Resend Review Request to Reviewer', 'Requesting your review again for {$journalName}', '<p>Dear {$recipientName},</p><p>Recently, you declined our request to review a submission, {$submissionTitle}, for {$journalName}. I\'m writing to see if you are able to conduct the review after all.</p><p>We would be grateful if you\'re able to perform this review, but we understand if that is not possible at this time. Either way, please <a href=\"{$reviewAssignmentUrl}\">accept or decline the request</a> by {$responseDueDate}, so that we can find an alternate reviewer.<p>If you have any questions, please contact me.</p><p>Kind regards,</p>{$signature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (13, 'REVIEW_REQUEST', 'en', 'Review Request', 'Invitation to review', '<p>Dear {$recipientName},</p><p>I believe that you would serve as an excellent reviewer for a submission  to {$journalName}. The submission\'s title and abstract are below, and I hope that you will consider undertaking this important task for us.</p><p>If you are able to review this submission, your review is due by {$reviewDueDate}. You can view the submission, upload review files, and submit your review by logging into the journal site and following the steps at the link below.</p><p><a href=\"{$reviewAssignmentUrl}\">{$submissionTitle}</a></p><p><b>Abstract</b></p>{$submissionAbstract}<p>Please <a href=\"{$reviewAssignmentUrl}\">accept or decline</a> the review by <b>{$responseDueDate}</b>.</p><p>You may contact me with any questions about the submission or the review process.</p><p>Thank you for considering this request. Your help is much appreciated.</p><p>Kind regards,</p>{$signature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (14, 'REVIEW_REQUEST_SUBSEQUENT', 'en', 'Review Request Subsequent', 'Request to review a revised submission', '<p>Dear {$recipientName},</p><p>Thank you for your review of <a href=\"{$reviewAssignmentUrl}\">{$submissionTitle}</a>. The authors have considered the reviewers\' feedback and have now submitted a revised version of their work. I\'m writing to ask if you would conduct a second round of peer review for this submission.</p><p>If you are able to review this submission, your review is due by {$reviewDueDate}. You can <a href=\"{$reviewAssignmentUrl}\">follow the review steps</a> to view the submission, upload review files, and submit your review comments.<p><p><a href=\"{$reviewAssignmentUrl}\">{$submissionTitle}</a></p><p><b>Abstract</b></p>{$submissionAbstract}<p>Please <a href=\"{$reviewAssignmentUrl}\">accept or decline</a> the review by <b>{$responseDueDate}</b>.</p><p>Please feel free to contact me with any questions about the submission or the review process.</p><p>Thank you for considering this request. Your help is much appreciated.</p><p>Kind regards,</p>{$signature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (15, 'REVIEW_RESPONSE_OVERDUE_AUTO', 'en', 'Review Response Overdue (Automated)', 'Will you be able to review this for us?', '<p>Dear {$recipientName},</p><p>This email is an automated reminder from {$journalName} in regards to our request for your review of the submission, \"{$submissionTitle}.\"</p><p>You are receiving this email because we have not yet received a confirmation from you indicating whether or not you are able to undertake the review of this submission.</p><p>Please let us know whether or not you are able to undertake this review by using our submission management software to accept or decline this request.</p><p>If you are able to review this submission, your review is due by {$reviewDueDate}. You can follow the review steps to view the submission, upload review files, and submit your review comments.</p><p><a href=\"{$reviewAssignmentUrl}\">{$submissionTitle}</a></p><p><b>Abstract</b></p>{$submissionAbstract}<p>Please feel free to contact me with any questions about the submission or the review process.</p><p>Thank you for considering this request. Your help is much appreciated.</p><p>Kind regards,</p>{$journalSignature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (16, 'REVIEW_CONFIRM', 'en', 'Review Confirm', 'Review accepted: {$reviewerName} accepted review assignment for #{$submissionId} {$authorsShort} — {$submissionTitle}', '<p>Dear {$recipientName},</p><p>{$reviewerName} has accepted the following review:</p><p><a href=\"{$submissionUrl}\">#{$submissionId} {$authorsShort} — {$submissionTitle}</a><br /><b>Type:</b> {$reviewMethod}</p><b>Review Due:</b> {$reviewDueDate}</p><p>Login to <a href=\"{$submissionUrl}\">view all reviewer assignments</a> for this submission.</p><br><br>—<br>This is an automated message from <a href=\"{$journalUrl}\">{$journalName}</a>.');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (17, 'REVIEW_DECLINE', 'en', 'Review Decline', 'Unable to Review', 'Editors:<br />\n<br />\nI am afraid that at this time I am unable to review the submission, &quot;{$submissionTitle},&quot; for {$journalName}. Thank you for thinking of me, and another time feel free to call on me.<br />\n<br />\n{$senderName}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (18, 'REVIEW_ACK', 'en', 'Review Acknowledgement', 'Thank you for your review', '<p>Dear {$recipientName},</p>\n<p>Thank you for completing your review of the submission, {$submissionTitle}, for {$journalName}. We appreciate your time and expertise in contributing to the quality of the work that we publish.</p>\n<p>It has been a pleasure to work with you as a reviewer for {$journalName}, and we hope to have the opportunity to work with you again in the future.</p>\n<p>Kind regards,</p>\n<p>{$signature}</p>');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (19, 'REVIEW_REMIND', 'en', 'Review Reminder', 'A reminder to please complete your review', '<p>Dear {$recipientName},</p><p>Just a gentle reminder of our request for your review of the submission, \"{$submissionTitle},\" for {$journalName}. We were expecting to have this review by {$reviewDueDate} and we would be pleased to receive it as soon as you are able to prepare it.</p><p>You can <a href=\"{$reviewAssignmentUrl}\">login to the journal</a> and follow the review steps to view the submission, upload review files, and submit your review comments.</p><p>If you need an extension of the deadline, please contact me. I look forward to hearing from you.</p><p>Thank you in advance and kind regards,</p>{$signature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (20, 'REVIEW_REMIND_AUTO', 'en', 'Review Reminder (Automated)', 'A reminder to please complete your review', '<p>Dear {$recipientName}:</p><p>This email is an automated reminder from {$journalName} in regards to our request for your review of the submission, \"{$submissionTitle}.\"</p><p>We were expecting to have this review by {$reviewDueDate} and we would be pleased to receive it as soon as you are able to prepare it.</p><p>Please <a href=\"{$reviewAssignmentUrl}\">login to the journal</a> and follow the review steps to view the submission, upload review files, and submit your review comments.</p><p>If you need an extension of the deadline, please contact me. I look forward to hearing from you.</p><p>Thank you in advance and kind regards,</p>{$journalSignature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (21, 'REVIEW_COMPLETE', 'en', 'Review Completed', 'Review complete: {$reviewerName} recommends {$reviewRecommendation} for #{$submissionId} {$authorsShort} — {$submissionTitle}', '<p>Dear {$recipientName},</p><p>{$reviewerName} completed the following review:</p><p><a href=\"{$submissionUrl}\">#{$submissionId} {$authorsShort} — {$submissionTitle}</a><br /><b>Recommendation:</b> {$reviewRecommendation}<br /><b>Type:</b> {$reviewMethod}</p><p>Login to <a href=\"{$submissionUrl}\">view all files and comments</a> provided by this reviewer.</p>');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (22, 'REVIEW_EDIT', 'en', 'Review Edited', 'Your review assignment has been changed for {$journalName}', '<p>Dear {$recipientName},</p><p>An editor has made changes to your review assignment for {$journalName}. Please review the details below and let us know if you have any questions.</p><p><a href=\"{$reviewAssignmentUrl}\">{$submissionTitle}</a><br /><b>Type:</b> {$reviewMethod}<br /><b>Accept or Decline By:</b> {$responseDueDate}<br /><b>Submit Review By:</b> {$reviewDueDate}</p><p>You can login to <a href=\"{$reviewAssignmentUrl}\">complete this review</a> at any time.</p>');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (23, 'EDITOR_DECISION_ACCEPT', 'en', 'Submission Accepted', 'Your submission has been accepted to {$journalName}', '<p>Dear {$recipientName},</p><p>I am pleased to inform you that we have decided to accept your submission without further revision. After careful review, we found your submission, {$submissionTitle}, to meet or exceed our expectations. We are excited to publish your piece in {$journalName} and we thank you for choosing our journal as a venue for your work.</p><p>Your submission is now forthcoming in a future issue of {$journalName} and you are welcome to include it in your list of publications. We recognize the hard work that goes into every successful submission and we want to congratulate you on reaching this stage.</p><p>Your submission will now undergo copy editing and formatting to prepare it for publication.</p><p>You will shortly receive further instructions.</p><p>If you have any questions, please contact me from your <a href=\"{$authorSubmissionUrl}\">submission dashboard</a>.</p><p>Kind regards,</p>{$signature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (24, 'EDITOR_DECISION_SEND_TO_EXTERNAL', 'en', 'Sent to Review', 'Your submission has been sent for review', '<p>Dear {$recipientName},</p><p>I am pleased to inform you that an editor has reviewed your submission, {$submissionTitle}, and has decided to send it for peer review. An editor will identify qualified reviewers who will provide feedback on your submission.</p><p>{$reviewTypeDescription} You will hear from us with feedback from the reviewers and information about the next steps.</p><p>Please note that sending the submission to peer review does not guarantee that it will be published. We will consider the reviewers\' recommendations before deciding to accept the submission for publication. You may be asked to make revisions and respond to the reviewers\' comments before a final decision is made.</p><p>If you have any questions, please contact me from your submission dashboard.</p><p>{$signature}</p>');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (25, 'EDITOR_DECISION_SEND_TO_PRODUCTION', 'en', 'Sent to Production', 'Next steps for publishing your submission', '<p>Dear {$recipientName},</p><p>I am writing from {$journalName} to let you know that the editing of your submission, {$submissionTitle}, is complete. Your submission will now advance to the production stage, where the final galleys will be prepared for publication. We will contact you if we need any further assistance.</p><p>If you have any questions, please contact me from your <a href=\"{$authorSubmissionUrl}\">submission dashboard</a>.</p><p>Kind regards,</p>{$signature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (26, 'EDITOR_DECISION_REVISIONS', 'en', 'Revisions Requested', 'Your submission has been reviewed and we encourage you to submit revisions', '<p>Dear {$recipientName},</p><p>Your submission {$submissionTitle} has been reviewed and we would like to encourage you to submit revisions that address the reviewers\' comments. An editor will review these revisions and if they address the concerns adequately, your submission may be accepted for publication.</p><p>The reviewers\' comments are included at the bottom of this email. Please respond to each point in the reviewers\' comments and identify what changes you have made. If you find any of the reviewer\'s comments to be unjustified or inappropriate, please explain your perspective.</p><p>When you have completed your revisions, you can upload revised documents along with your response to the reviewers\' comments at your <a href=\"{$authorSubmissionUrl}\">submission dashboard</a>. If you have been logged out, you can login again with the username {$recipientUsername}.</p><p>If you have any questions, please contact me from your <a href=\"{$authorSubmissionUrl}\">submission dashboard</a>.</p><p>We look forward to receiving your revised submission.</p><p>Kind regards,</p>{$signature}<hr><p>The following comments were received from reviewers.</p>{$allReviewerComments}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (27, 'EDITOR_DECISION_RESUBMIT', 'en', 'Resubmit for Review', 'Your submission has been reviewed - please revise and resubmit', '<p>Dear {$recipientName},</p><p>After reviewing your submission, {$submissionTitle}, the reviewers have recommended that your submission cannot be accepted for publication in its current form. However, we would like to encourage you to submit a revised version that addresses the reviewers\' comments. Your revisions will be reviewed by an editor and may be sent out for another round of peer review.</p><p>Please note that resubmitting your work does not guarantee that it will be accepted.</p><p>The reviewers\' comments are included at the bottom of this email. Please respond to each point and identify what changes you have made. If you find any of the reviewer\'s comments inappropriate, please explain your perspective. If you have questions about the recommendations in your review, please include these in your response.</p><p>When you have completed your revisions, you can upload revised documents along with your response to the reviewers\' comments <a href=\"{$authorSubmissionUrl}\">at your submission dashboard</a>. If you have been logged out, you can login again with the username {$recipientUsername}.</p><p>If you have any questions, please contact me from your <a href=\"{$authorSubmissionUrl}\">submission dashboard</a>.</p><p>We look forward to receiving your revised submission.</p><p>Kind regards,</p>{$signature}<hr><p>The following comments were received from reviewers.</p>{$allReviewerComments}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (28, 'EDITOR_DECISION_DECLINE', 'en', 'Submission Declined', 'Your submission has been declined', '<p>Dear {$recipientName},</p><p>While we appreciate receiving your submission, we are unable to accept {$submissionTitle} for publication on the basis of the comments from reviewers.</p><p>The reviewers\' comments are included at the bottom of this email.</p><p>Thank you for submitting to {$journalName}. Although it is disappointing to have a submission declined, I hope you find the reviewers\' comments to be constructive and helpful.</p><p>You are now free to submit the work elsewhere if you choose to do so.</p><p>Kind regards,</p>{$signature}<hr><p>The following comments were received from reviewers.</p>{$allReviewerComments}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (29, 'EDITOR_DECISION_INITIAL_DECLINE', 'en', 'Submission Declined (Pre-Review)', 'Your submission has been declined', '<p>Dear {$recipientName},</p><p>I’m sorry to inform you that, after reviewing your submission, {$submissionTitle}, the editor has found that it does not meet our requirements for publication in {$journalName}.</p><p>I wish you success if you consider submitting your work elsewhere.</p><p>Kind regards,</p>{$signature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (30, 'EDITOR_RECOMMENDATION', 'en', 'Recommendation Made', 'Editor Recommendation', '<p>Dear {$recipientName},</p><p>After considering the reviewers\' feedback, I would like to make the following recommendation regarding the submission {$submissionTitle}.</p><p>My recommendation is: {$recommendation}.</p><p>Please visit the submission\'s <a href=\"{$submissionUrl}\">editorial workflow</a> to act on this recommendation.</p><p>Please feel free to contact me with any questions.</p><p>Kind regards,</p><p>{$senderName}</p>');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (31, 'EDITOR_DECISION_NOTIFY_OTHER_AUTHORS', 'en', 'Notify Other Authors', 'An update regarding your submission', '<p>The following email was sent to {$submittingAuthorName} from {$journalName} regarding {$submissionTitle}.</p>\n<p>You are receiving a copy of this notification because you are identified as an author of the submission. Any instructions in the message below are intended for the submitting author, {$submittingAuthorName}, and no action is required of you at this time.</p>\n\n{$messageToSubmittingAuthor}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (32, 'EDITOR_DECISION_NOTIFY_REVIEWERS', 'en', 'Notify Reviewers of Decision', 'Thank you for your review', '<p>Dear {$recipientName},</p>\n<p>Thank you for completing your review of the submission, {$submissionTitle}, for {$journalName}. We appreciate your time and expertise in contributing to the quality of the work that we publish. We have shared your comments with the authors, along with our other reviewers\' comments and the editor\'s decision.</p>\n<p>Based on the feedback we received, we have notified the authors of the following:</p>\n<p>{$decisionDescription}</p>\n<p>Your recommendation was considered alongside the recommendations of other reviewers before coming to a decision. Occasionally the editor\'s decision may differ from the recommendation made by one or more reviewers. The editor considers many factors, and does not take these decisions lightly. We are grateful for our reviewers\' expertise and suggestions.</p>\n<p>It has been a pleasure to work with you as a reviewer for {$journalName}, and we hope to have the opportunity to work with you again in the future.</p>\n<p>Kind regards,</p>\n<p>{$signature}</p>');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (33, 'EDITOR_DECISION_NEW_ROUND', 'en', 'New Review Round Initiated', 'Your submission has been sent for another round of review', '<p>Dear {$recipientName},</p>\n<p>Your revised submission, {$submissionTitle}, has been sent for a new round of peer review. \nYou will hear from us with feedback from the reviewers and information about the next steps.</p>\n<p>If you have any questions, please contact me from your <a href=\"{$authorSubmissionUrl}\">submission dashboard</a>.</p>\n<p>Kind regards,</p>\n<p>{$signature}</p>\n');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (34, 'EDITOR_DECISION_REVERT_DECLINE', 'en', 'Reinstate Declined Submission', 'We have reversed the decision to decline your submission', '<p>Dear {$recipientName},</p>\n<p>The decision to decline your submission, {$submissionTitle}, has been reversed. \nAn editor will complete the round of review and you will be notified when a \ndecision is made.</p>\n<p>Occasionally, a decision to decline a submission will be recorded accidentally in \nour system and must be reverted. I apologize for any confusion this may have caused.</p>\n<p>We will contact you if we need any further assistance.</p>\n<p>If you have any questions, please contact me from your <a href=\"{$authorSubmissionUrl}\">submission dashboard</a>.</p>\n<p>Kind regards,</p>\n<p>{$signature}</p>\n');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (35, 'EDITOR_DECISION_REVERT_INITIAL_DECLINE', 'en', 'Reinstate Submission Declined Without Review', 'We have reversed the decision to decline your submission', '<p>Dear {$recipientName},</p>\n<p>The decision to decline your submission, {$submissionTitle}, has been reversed. \nAn editor will look further at your submission before deciding whether to decline \nthe submission or send it for review.</p>\n<p>Occasionally, a decision to decline a submission will be recorded accidentally in \nour system and must be reverted. I apologize for any confusion this may have caused.</p>\n<p>We will contact you if we need any further assistance.</p>\n<p>If you have any questions, please contact me from your <a href=\"{$authorSubmissionUrl}\">submission dashboard</a>.</p>\n<p>Kind regards,</p>\n<p>{$signature}</p>\n');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (36, 'EDITOR_DECISION_SKIP_REVIEW', 'en', 'Submission Accepted (Without Review)', 'Your submission has been sent for copyediting', '<p>Dear {$recipientName},</p>\n<p>I am pleased to inform you that we have decided to accept your submission without peer review. We found your submission, {$submissionTitle}, to meet our expectations, and we do not require that work of this type undergo peer review. We are excited to publish your piece in {$journalName} and we thank you for choosing our journal as a venue for your work.</p>\nYour submission is now forthcoming in a future issue of {$journalName} and you are welcome to include it in your list of publications. We recognize the hard work that goes into every successful submission and we want to congratulate you on your efforts.</p>\n<p>Your submission will now undergo copy editing and formatting to prepare it for publication. </p>\n<p>You will shortly receive further instructions.</p>\n<p>If you have any questions, please contact me from your <a href=\"{$authorSubmissionUrl}\">submission dashboard</a>.</p>\n<p>Kind regards,</p>\n<p>{$signature}</p>\n');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (37, 'EDITOR_DECISION_BACK_FROM_PRODUCTION', 'en', 'Submission Sent Back to Copyediting', 'Your submission has been sent back to copyediting', '<p>Dear {$recipientName},</p><p>Your submission, {$submissionTitle}, has been sent back to the copyediting stage, where it will undergo further copyediting and formatting to prepare it for publication.</p><p>Occasionally, a submission is sent to the production stage before it is ready for the final galleys to be prepared for publication. Your submission is still forthcoming. I apologize for any confusion.</p><p>If you have any questions, please contact me from your <a href=\"{$authorSubmissionUrl}\">submission dashboard</a>.</p><p>We will contact you if we need any further assistance.</p><p>Kind regards,</p><p>{$signature}</p>');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (38, 'EDITOR_DECISION_BACK_FROM_COPYEDITING', 'en', 'Submission Sent Back from Copyediting', 'Your submission has been sent back to review', '<p>Dear {$recipientName},</p><p>Your submission, {$submissionTitle}, has been sent back to the review stage. It will undergo further review before it can be accepted for publication.</p><p>Occasionally, a decision to accept a submission will be recorded accidentally in our system and we must send it back to review. I apologize for any confusion this has caused. We will work to complete any further review quickly so that you have a final decision as soon as possible.</p><p>We will contact you if we need any further assistance.</p><p>If you have any questions, please contact me from your <a href=\"{$authorSubmissionUrl}\">submission dashboard</a>.</p><p>Kind regards,</p><p>{$signature}</p>');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (39, 'EDITOR_DECISION_CANCEL_REVIEW_ROUND', 'en', 'Review Round Cancelled', 'A review round for your submission has been cancelled', '<p>Dear {$recipientName},</p><p>We recently opened a new review round for your submission, {$submissionTitle}. We are closing this review round now.</p><p>Occasionally, a decision to open a round of review will be recorded accidentally in our system and we must cancel this review round. I apologize for any confusion this may have caused.</p><p>We will contact you if we need any further assistance.</p><p>If you have any questions, please contact me from your <a href=\"{$authorSubmissionUrl}\">submission dashboard</a>.</p><p>Kind regards,</p><p>{$signature}</p>');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (40, 'SUBSCRIPTION_NOTIFY', 'en', 'Subscription Notify', 'Subscription Notification', '{$recipientName}:<br />\n<br />\nYou have now been registered as a subscriber in our online journal management system for {$journalName}, with the following subscription:<br />\n<br />\n{$subscriptionType}<br />\n<br />\nTo access content that is available only to subscribers, simply log in to the system with your username, &quot;{$recipientUsername}&quot;.<br />\n<br />\nOnce you have logged in to the system you can change your profile details and password at any point.<br />\n<br />\nPlease note that if you have an institutional subscription, there is no need for users at your institution to log in, since requests for subscription content will be automatically authenticated by the system.<br />\n<br />\nIf you have any questions, please feel free to contact me.<br />\n<br />\n{$subscriptionSignature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (41, 'OPEN_ACCESS_NOTIFY', 'en', 'Open Access Notify', 'Free to read: {$issueIdentification} of {$journalName} is now open access', '<p>Dear {$recipientName},</p><p>We are pleased to inform you that <a href=\"{$issueUrl}\">{$issueIdentification}</a> of {$journalName} is now available under open access.  A subscription is no longer required to read this issue.</p><p>Thank you for your continuing interest in our work.</p>{$journalSignature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (42, 'SUBSCRIPTION_BEFORE_EXPIRY', 'en', 'Subscription Expires Soon', 'Notice of Subscription Expiry', '{$recipientName}:<br />\n<br />\nYour {$journalName} subscription is about to expire.<br />\n<br />\n{$subscriptionType}<br />\nExpiry date: {$expiryDate}<br />\n<br />\nTo ensure the continuity of your access to this journal, please go to the journal website and renew your subscription. You are able to log in to the system with your username, &quot;{$recipientUsername}&quot;.<br />\n<br />\nIf you have any questions, please feel free to contact me.<br />\n<br />\n{$subscriptionSignature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (43, 'SUBSCRIPTION_AFTER_EXPIRY', 'en', 'Subscription Expired', 'Subscription Expired', '{$recipientName}:<br />\n<br />\nYour {$journalName} subscription has expired.<br />\n<br />\n{$subscriptionType}<br />\nExpiry date: {$expiryDate}<br />\n<br />\nTo renew your subscription, please go to the journal website. You are able to log in to the system with your username, &quot;{$recipientUsername}&quot;.<br />\n<br />\nIf you have any questions, please feel free to contact me.<br />\n<br />\n{$subscriptionSignature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (44, 'SUBSCRIPTION_AFTER_EXPIRY_LAST', 'en', 'Subscription Expired Last', 'Subscription Expired - Final Reminder', '{$recipientName}:<br />\n<br />\nYour {$journalName} subscription has expired.<br />\nPlease note that this is the final reminder that will be emailed to you.<br />\n<br />\n{$subscriptionType}<br />\nExpiry date: {$expiryDate}<br />\n<br />\nTo renew your subscription, please go to the journal website. You are able to log in to the system with your username, &quot;{$recipientUsername}&quot;.<br />\n<br />\nIf you have any questions, please feel free to contact me.<br />\n<br />\n{$subscriptionSignature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (45, 'SUBSCRIPTION_PURCHASE_INDL', 'en', 'Purchase Individual Subscription', 'Subscription Purchase: Individual', 'An individual subscription has been purchased online for {$journalName} with the following details.<br />\n<br />\nSubscription Type:<br />\n{$subscriptionType}<br />\n<br />\nUser:<br />\n{$subscriberDetails}<br />\n<br />\nMembership Information (if provided):<br />\n{$membership}<br />\n<br />\nTo view or edit this subscription, please use the following URL.<br />\n<br />\nSubscription URL: {$subscriptionUrl}<br />\n');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (46, 'SUBSCRIPTION_PURCHASE_INSTL', 'en', 'Purchase Institutional Subscription', 'Subscription Purchase: Institutional', 'An institutional subscription has been purchased online for {$journalName} with the following details. To activate this subscription, please use the provided Subscription URL and set the subscription status to \'Active\'.<br />\n<br />\nSubscription Type:<br />\n{$subscriptionType}<br />\n<br />\nInstitution:<br />\n{$institutionName}<br />\n{$institutionMailingAddress}<br />\n<br />\nDomain (if provided):<br />\n{$domain}<br />\n<br />\nIP Ranges (if provided):<br />\n{$ipRanges}<br />\n<br />\nContact Person:<br />\n{$subscriberDetails}<br />\n<br />\nMembership Information (if provided):<br />\n{$membership}<br />\n<br />\nTo view or edit this subscription, please use the following URL.<br />\n<br />\nSubscription URL: {$subscriptionUrl}<br />\n');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (47, 'SUBSCRIPTION_RENEW_INDL', 'en', 'Renew Individual Subscription', 'Subscription Renewal: Individual', 'An individual subscription has been renewed online for {$journalName} with the following details.<br />\n<br />\nSubscription Type:<br />\n{$subscriptionType}<br />\n<br />\nUser:<br />\n{$subscriberDetails}<br />\n<br />\nMembership Information (if provided):<br />\n{$membership}<br />\n<br />\nTo view or edit this subscription, please use the following URL.<br />\n<br />\nSubscription URL: {$subscriptionUrl}<br />\n');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (48, 'SUBSCRIPTION_RENEW_INSTL', 'en', 'Renew Institutional Subscription', 'Subscription Renewal: Institutional', 'An institutional subscription has been renewed online for {$journalName} with the following details.<br />\n<br />\nSubscription Type:<br />\n{$subscriptionType}<br />\n<br />\nInstitution:<br />\n{$institutionName}<br />\n{$institutionMailingAddress}<br />\n<br />\nDomain (if provided):<br />\n{$domain}<br />\n<br />\nIP Ranges (if provided):<br />\n{$ipRanges}<br />\n<br />\nContact Person:<br />\n{$subscriberDetails}<br />\n<br />\nMembership Information (if provided):<br />\n{$membership}<br />\n<br />\nTo view or edit this subscription, please use the following URL.<br />\n<br />\nSubscription URL: {$subscriptionUrl}<br />\n');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (49, 'REVISED_VERSION_NOTIFY', 'en', 'Revised Version Notification', 'Revised Version Uploaded', '<p>Dear {$recipientName},</p><p>The author has uploaded revisions for the submission, <b>{$authorsShort} — {$submissionTitle}</b>. <p>As an assigned editor, we ask that you login and <a href=\"{$submissionUrl}\">view the revisions</a> and make a decision to accept, decline or send the submission for further review.</p><br><br>—<br>This is an automated message from <a href=\"{$journalUrl}\">{$journalName}</a>.');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (50, 'STATISTICS_REPORT_NOTIFICATION', 'en', 'Statistics Report Notification', 'Editorial activity for {$month}, {$year}', '\n{$recipientName}, <br />\n<br />\nYour journal health report for {$month}, {$year} is now available. Your key stats for this month are below.<br />\n<ul>\n	<li>New submissions this month: {$newSubmissions}</li>\n	<li>Declined submissions this month: {$declinedSubmissions}</li>\n	<li>Accepted submissions this month: {$acceptedSubmissions}</li>\n	<li>Total submissions in the system: {$totalSubmissions}</li>\n</ul>\nLogin to the journal to view more detailed <a href=\"{$editorialStatsLink}\">editorial trends</a> and <a href=\"{$publicationStatsLink}\">published article stats</a>. A full copy of this month\'s editorial trends is attached.<br />\n<br />\nSincerely,<br />\n{$journalSignature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (51, 'ANNOUNCEMENT', 'en', 'New Announcement', '{$announcementTitle}', '<b>{$announcementTitle}</b><br />\n<br />\n{$announcementSummary}<br />\n<br />\nVisit our website to read the <a href=\"{$announcementUrl}\">full announcement</a>.');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (52, 'DISCUSSION_NOTIFICATION_SUBMISSION', 'en', 'Discussion (Submission)', 'A message regarding {$journalName}', 'Please enter your message.');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (53, 'DISCUSSION_NOTIFICATION_REVIEW', 'en', 'Discussion (Review)', 'A message regarding {$journalName}', 'Please enter your message.');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (54, 'DISCUSSION_NOTIFICATION_COPYEDITING', 'en', 'Discussion (Copyediting)', 'A message regarding {$journalName}', 'Please enter your message.');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (55, 'DISCUSSION_NOTIFICATION_PRODUCTION', 'en', 'Discussion (Production)', 'A message regarding {$journalName}', 'Please enter your message.');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (56, 'COPYEDIT_REQUEST', 'en', 'Request Copyedit', 'Submission {$submissionId} is ready to be copyedited for {$contextAcronym}', '<p>Dear {$recipientName},</p><p>A new submission is ready to be copyedited:</p><p><a href\"{$submissionUrl}\">{$submissionId} — {$submissionTitle}</a><br />{$journalName}</p><p>Please follow these steps to complete this task:</p><ol><li>Click on the Submission URL below.</li><li>Open any files available under Draft Files and edit the files. Use the Copyediting Discussions area if you need to contact the editor(s) or author(s).</li><li>Save the copyedited file(s) and upload them to the Copyedited panel.</li><li>Use the Copyediting Discussions to notify the editor(s) that all files have been prepared, and that the Production process may begin.</li></ol><p>If you are unable to undertake this work at this time or have any questions, please contact me. Thank you for your contribution to {$journalName}.</p><p>Kind regards,</p>{$signature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (57, 'EDITOR_ASSIGN_SUBMISSION', 'en', 'Assign Editor', 'You have been assigned as an editor on a submission to {$journalName}', '<p>Dear {$recipientName},</p><p>The following submission has been assigned to you to see through the editorial process.</p><p><a href=\"{$submissionUrl}\">{$submissionTitle}</a><br />{$authors}</p><p><b>Abstract</b></p>{$submissionAbstract}<p>If you find the submission to be relevant for {$journalName}, please forward the submission to the review stage by selecting \"Send to Review\" and then assign reviewers by clicking \"Add Reviewer\".</p><p>If the submission is not appropriate for this journal, please decline the submission.</p><p>Thank you in advance.</p><p>Kind regards,</p>{$journalSignature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (58, 'EDITOR_ASSIGN_REVIEW', 'en', 'Assign Editor', 'You have been assigned as an editor on a submission to {$journalName}', '<p>Dear {$recipientName},</p><p>The following submission has been assigned to you to see through the peer review process.</p><p><a href=\"{$submissionUrl}\">{$submissionTitle}</a><br />{$authors}</p><p><b>Abstract</b></p>{$submissionAbstract}<p>Please login to <a href=\"{$submissionUrl}\">view the submission</a> and assign qualified reviewers. You can assign a reviewer by clicking \"Add Reviewer\".</p><p>Thank you in advance.</p><p>Kind regards,</p>{$signature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (59, 'EDITOR_ASSIGN_PRODUCTION', 'en', 'Assign Editor', 'You have been assigned as an editor on a submission to {$journalName}', '<p>Dear {$recipientName},</p><p>The following submission has been assigned to you to see through the production stage.</p><p><a href=\"{$submissionUrl}\">{$submissionTitle}</a><br />{$authors}</p><p><b>Abstract</b></p>{$submissionAbstract}<p>Please login to <a href=\"{$submissionUrl}\">view the submission</a>. Once production-ready files are available, upload them under the <strong>Publication > Galleys</strong> section. Then schedule the work for publication by clicking the <strong>Schedule for Publication</strong> button.</p><p>Thank you in advance.</p><p>Kind regards,</p>{$signature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (60, 'LAYOUT_REQUEST', 'en', 'Ready for Production', 'Submission {$submissionId} is ready for production at {$contextAcronym}', '<p>Dear {$recipientName},</p><p>A new submission is ready for layout editing:</p><p><a href=\"{$submissionUrl}\">{$submissionId} — {$submissionTitle}</a><br />{$journalName}</p><ol><li>Click on the Submission URL above.</li><li>Download the Production Ready files and use them to create the galleys according to the journal\'s standards.</li><li>Upload the galleys to the Publication section of the submission.</li><li>Use the  Production Discussions to notify the editor that the galleys are ready.</li></ol><p>If you are unable to undertake this work at this time or have any questions, please contact me. Thank you for your contribution to this journal.</p><p>Kind regards,</p>{$signature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (61, 'LAYOUT_COMPLETE', 'en', 'Galleys Complete', 'Galleys Complete', '<p>Dear {$recipientName},</p><p>Galleys have now been prepared for the following submission and are ready for final review.</p><p><a href=\"{$submissionUrl}\">{$submissionTitle}</a><br />{$journalName}</p><p>If you have any questions, please contact me.</p><p>Kind regards,</p><p>{$signature}</p>');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (62, 'VERSION_CREATED', 'en', 'Version Created', 'A new version was created for {$submissionTitle}', '<p>Dear {$recipientName}, </p><p>This is an automated message to inform you that a new version of your submission, {$submissionTitle}, was created. You can view this version from your submission dashboard at the following link:</p><p><a href=\"{$submissionUrl}\">{$submissionTitle}</a></p><hr><p>This is an automatic email sent from <a href=\"{$journalUrl}\">{$journalName}</a>.</p>');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (63, 'EDITORIAL_REMINDER', 'en', 'Editorial Reminder', 'Outstanding editorial tasks for {$journalName}', '<p>Dear {$recipientName},</p><p>You are currently assigned to {$numberOfSubmissions} submissions in <a href=\"{$journalUrl}\">{$journalName}</a>. The following submissions are <b>waiting for your response</b>.</p>{$outstandingTasks}<p>View all of your assignments in your <a href=\"{$submissionsUrl}\">submission dashboard</a>.</p><p>If you have any questions about your assignments, please contact {$contactName} at {$contactEmail}.</p>');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (64, 'SUBMISSION_SAVED_FOR_LATER', 'en', 'Submission Saved for Later', 'Resume your submission to {$journalName}', '<p>Dear {$recipientName},</p><p>Your submission details have been saved in our system, but it has not yet been submitted for consideration. You can return to complete your submission at any time by following the link below.</p><p><a href=\"{$submissionWizardUrl}\">{$authorsShort} — {$submissionTitle}</a></p><hr><p>This is an automated email from <a href=\"{$journalUrl}\">{$journalName}</a>.</p>');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (65, 'SUBMISSION_NEEDS_EDITOR', 'en', 'Submission Needs Editor', 'A new submission needs an editor to be assigned: {$submissionTitle}', '<p>Dear {$recipientName},</p><p>The following submission has been submitted and there is no editor assigned.</p><p><a href=\"{$submissionUrl}\">{$submissionTitle}</a><br />{$authors}</p><p><b>Abstract</b></p>{$submissionAbstract}<p>Please assign an editor who will be responsible for the submission by clicking the title above and assigning an editor under the Participants section.</p><hr><p>This is an automated email from <a href=\"{$journalUrl}\">{$journalName}</a>.</p>');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (66, 'PAYMENT_REQUEST_NOTIFICATION', 'en', 'Payment Request', 'Payment Request Notification', '<p>Dear {$recipientName},</p><p>Congratulations on the acceptance of your submission, {$submissionTitle}, to {$journalName}. Now that your submission has been accepted, we would like to request payment of the publication fee.</p><p>This fee covers the production costs of bringing your submission to publication. To make the payment, please visit <a href=\"{$queuedPaymentUrl}\">{$queuedPaymentUrl}</a>.</p><p>If you have any questions, please see our <a href=\"{$submissionGuidelinesUrl}\">Submission Guidelines</a></p>');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (67, 'ORCID_COLLECT_AUTHOR_ID', 'en', 'orcidCollectAuthorId', 'Submission ORCID', 'Dear {$recipientName},<br/>\n<br/>\nYou have been listed as an author on a manuscript submission to {$journalName}.<br/>\nTo confirm your authorship, please add your ORCID id to this submission by visiting the link provided below.<br/>\n<br/>\n<a href=\"{$authorOrcidUrl}\"><img id=\"orcid-id-logo\" src=\"https://info.orcid.org/wp-content/uploads/2020/12/ORCIDiD_icon16x16.png\" width=\'16\' height=\'16\' alt=\"ORCID iD icon\" style=\"display: block; margin: 0 .5em 0 0; padding: 0; float: left;\"/>Register or connect your ORCID iD</a><br/>\n<br/>\n<br>\n<a href=\"{$orcidAboutUrl}\">More information about ORCID at {$journalName}</a><br/>\n<br/>\nIf you have any questions, please contact me.<br/>\n<br/>\n{$principalContactSignature}<br/>\n');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (68, 'ORCID_REQUEST_AUTHOR_AUTHORIZATION', 'en', 'orcidRequestAuthorAuthorization', 'Requesting ORCID record access', 'Dear {$recipientName},<br>\n<br>\nYou have been listed as an author on the manuscript submission \"{$submissionTitle}\" to {$journalName}.\n<br>\n<br>\nPlease allow us to add your ORCID id to this submission and also to add the submission to your ORCID profile on publication.<br>\nVisit the link to the official ORCID website, login with your profile and authorize the access by following the instructions.<br>\n<a href=\"{$authorOrcidUrl}\"><img id=\"orcid-id-logo\" src=\"https://info.orcid.org/wp-content/uploads/2020/12/ORCIDiD_icon16x16.png\" width=\'16\' height=\'16\' alt=\"ORCID iD icon\" style=\"display: block; margin: 0 .5em 0 0; padding: 0; float: left;\"/>Register or Connect your ORCID iD</a><br/>\n<br>\n<br>\n<a href=\"{$orcidAboutUrl}\">More about ORCID at {$journalName}</a><br/>\n<br>\nIf you have any questions, please contact me.<br>\n<br>\n{$principalContactSignature}<br>\n');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (69, 'MANUAL_PAYMENT_NOTIFICATION', 'en', 'Manual Payment Notify', 'Manual Payment Notification', 'A manual payment needs to be processed for the journal {$journalName} and the user {senderName} (username &quot;{$senderUsername}&quot;).<br />\n<br />\nThe item being paid for is &quot;{$paymentName}&quot;.<br />\nThe cost is {$paymentAmount} ({$paymentCurrencyCode}).<br />\n<br />\nThis email was generated by Open Journal Systems\' Manual Payment plugin.');
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
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='A log of all events related to an object like a submission.';

-- ----------------------------
-- Records of event_log
-- ----------------------------
BEGIN;
INSERT INTO `event_log` (`log_id`, `assoc_type`, `assoc_id`, `user_id`, `date_logged`, `event_type`, `message`, `is_translated`) VALUES (1, 1048585, 1, 4, '2024-10-09 08:21:26', 268435458, 'submission.event.general.metadataUpdated', 0);
INSERT INTO `event_log` (`log_id`, `assoc_type`, `assoc_id`, `user_id`, `date_logged`, `event_type`, `message`, `is_translated`) VALUES (2, 1048585, 1, 4, '2024-10-09 08:21:27', 268435458, 'submission.event.general.metadataUpdated', 0);
INSERT INTO `event_log` (`log_id`, `assoc_type`, `assoc_id`, `user_id`, `date_logged`, `event_type`, `message`, `is_translated`) VALUES (3, 1048585, 1, 4, '2024-10-09 08:21:41', 268435458, 'submission.event.general.metadataUpdated', 0);
INSERT INTO `event_log` (`log_id`, `assoc_type`, `assoc_id`, `user_id`, `date_logged`, `event_type`, `message`, `is_translated`) VALUES (4, 515, 1, 4, '2024-10-09 08:21:53', 1342177281, 'submission.event.fileUploaded', 0);
INSERT INTO `event_log` (`log_id`, `assoc_type`, `assoc_id`, `user_id`, `date_logged`, `event_type`, `message`, `is_translated`) VALUES (5, 1048585, 1, 4, '2024-10-09 08:21:53', 1342177288, 'submission.event.fileRevised', 0);
INSERT INTO `event_log` (`log_id`, `assoc_type`, `assoc_id`, `user_id`, `date_logged`, `event_type`, `message`, `is_translated`) VALUES (6, 515, 1, 4, '2024-10-09 08:21:57', 1342177296, 'submission.event.fileEdited', 0);
INSERT INTO `event_log` (`log_id`, `assoc_type`, `assoc_id`, `user_id`, `date_logged`, `event_type`, `message`, `is_translated`) VALUES (7, 1048585, 1, 4, '2024-10-09 08:23:35', 268435457, 'submission.event.submissionSubmitted', 0);
INSERT INTO `event_log` (`log_id`, `assoc_type`, `assoc_id`, `user_id`, `date_logged`, `event_type`, `message`, `is_translated`) VALUES (8, 1048585, 2, 4, '2024-10-09 08:25:12', 268435458, 'submission.event.general.metadataUpdated', 0);
INSERT INTO `event_log` (`log_id`, `assoc_type`, `assoc_id`, `user_id`, `date_logged`, `event_type`, `message`, `is_translated`) VALUES (9, 1048585, 2, 4, '2024-10-09 08:25:12', 268435458, 'submission.event.general.metadataUpdated', 0);
INSERT INTO `event_log` (`log_id`, `assoc_type`, `assoc_id`, `user_id`, `date_logged`, `event_type`, `message`, `is_translated`) VALUES (10, 1048585, 2, 4, '2024-10-09 08:25:25', 268435458, 'submission.event.general.metadataUpdated', 0);
INSERT INTO `event_log` (`log_id`, `assoc_type`, `assoc_id`, `user_id`, `date_logged`, `event_type`, `message`, `is_translated`) VALUES (11, 515, 2, 4, '2024-10-09 08:25:44', 1342177281, 'submission.event.fileUploaded', 0);
INSERT INTO `event_log` (`log_id`, `assoc_type`, `assoc_id`, `user_id`, `date_logged`, `event_type`, `message`, `is_translated`) VALUES (12, 1048585, 2, 4, '2024-10-09 08:25:44', 1342177288, 'submission.event.fileRevised', 0);
INSERT INTO `event_log` (`log_id`, `assoc_type`, `assoc_id`, `user_id`, `date_logged`, `event_type`, `message`, `is_translated`) VALUES (13, 515, 2, 4, '2024-10-09 08:25:46', 1342177296, 'submission.event.fileEdited', 0);
INSERT INTO `event_log` (`log_id`, `assoc_type`, `assoc_id`, `user_id`, `date_logged`, `event_type`, `message`, `is_translated`) VALUES (14, 1048585, 2, 4, '2024-10-09 08:26:10', 268435457, 'submission.event.submissionSubmitted', 0);
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
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Data about an event log entry. This data is commonly used to display information about an event to a user.';

-- ----------------------------
-- Records of event_log_settings
-- ----------------------------
BEGIN;
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (1, 4, '', 'fileId', '1');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (2, 4, 'en', 'filename', 'contoh.pdf');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (3, 4, '', 'fileStage', '2');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (4, 4, '', 'submissionFileId', '1');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (5, 4, '', 'submissionId', '1');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (6, 4, '', 'username', 'ra12345');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (7, 5, '', 'fileId', '1');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (8, 5, 'en', 'filename', 'contoh.pdf');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (9, 5, '', 'fileStage', '2');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (10, 5, '', 'submissionFileId', '1');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (11, 5, '', 'submissionId', '1');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (12, 5, '', 'username', 'ra12345');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (13, 6, '', 'fileId', '1');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (14, 6, 'en', 'filename', 'contoh.pdf');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (15, 6, '', 'fileStage', '2');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (16, 6, '', 'submissionFileId', '1');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (17, 6, '', 'submissionId', '1');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (18, 6, '', 'username', 'ra12345');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (19, 11, '', 'fileId', '2');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (20, 11, 'en', 'filename', 'contoh.pdf');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (21, 11, '', 'fileStage', '2');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (22, 11, '', 'submissionFileId', '2');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (23, 11, '', 'submissionId', '2');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (24, 11, '', 'username', 'ra12345');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (25, 12, '', 'fileId', '2');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (26, 12, 'en', 'filename', 'contoh.pdf');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (27, 12, '', 'fileStage', '2');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (28, 12, '', 'submissionFileId', '2');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (29, 12, '', 'submissionId', '2');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (30, 12, '', 'username', 'ra12345');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (31, 13, '', 'fileId', '2');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (32, 13, 'en', 'filename', 'contoh.pdf');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (33, 13, '', 'fileStage', '2');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (34, 13, '', 'submissionFileId', '2');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (35, 13, '', 'submissionId', '2');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (36, 13, '', 'username', 'ra12345');
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='A log of all failed jobs.';

-- ----------------------------
-- Records of failed_jobs
-- ----------------------------
BEGIN;
INSERT INTO `failed_jobs` (`id`, `connection`, `queue`, `payload`, `exception`, `failed_at`) VALUES (1, 'database', 'queue', '{\"uuid\":\"6907b35a-b407-4260-a999-214cc4c1f77e\",\"displayName\":\"PKP\\\\jobs\\\\notifications\\\\StatisticsReportMail\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":null,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":null,\"retryUntil\":null,\"data\":{\"commandName\":\"PKP\\\\jobs\\\\notifications\\\\StatisticsReportMail\",\"command\":\"O:43:\\\"PKP\\\\jobs\\\\notifications\\\\StatisticsReportMail\\\":7:{s:10:\\\"\\u0000*\\u0000userIds\\\";O:29:\\\"Illuminate\\\\Support\\\\Collection\\\":2:{s:8:\\\"\\u0000*\\u0000items\\\";a:1:{i:0;i:1;}s:28:\\\"\\u0000*\\u0000escapeWhenCastingToString\\\";b:0;}s:12:\\\"\\u0000*\\u0000contextId\\\";i:1;s:12:\\\"\\u0000*\\u0000dateStart\\\";O:17:\\\"DateTimeImmutable\\\":3:{s:4:\\\"date\\\";s:26:\\\"2024-08-01 00:00:00.000000\\\";s:13:\\\"timezone_type\\\";i:3;s:8:\\\"timezone\\\";s:3:\\\"UTC\\\";}s:10:\\\"\\u0000*\\u0000dateEnd\\\";O:17:\\\"DateTimeImmutable\\\":3:{s:4:\\\"date\\\";s:26:\\\"2024-09-01 00:00:00.000000\\\";s:13:\\\"timezone_type\\\";i:3;s:8:\\\"timezone\\\";s:3:\\\"UTC\\\";}s:10:\\\"connection\\\";s:8:\\\"database\\\";s:5:\\\"queue\\\";s:5:\\\"queue\\\";s:7:\\\"batchId\\\";s:36:\\\"9ce7c9aa-16bd-41a5-9933-82edc341c49d\\\";}\"}}', '{\"message\":\"Class \\\"IntlDateFormatter\\\" not found\",\"code\":0,\"file\":\"\\/var\\/www\\/peacee.id\\/ojs-app\\/lib\\/pkp\\/jobs\\/notifications\\/StatisticsReportMail.php\",\"line\":67,\"trace\":[{\"file\":\"\\/var\\/www\\/peacee.id\\/ojs-app\\/lib\\/pkp\\/lib\\/vendor\\/laravel\\/framework\\/src\\/Illuminate\\/Container\\/BoundMethod.php\",\"line\":36,\"function\":\"handle\",\"class\":\"PKP\\\\jobs\\\\notifications\\\\StatisticsReportMail\",\"type\":\"->\"},{\"file\":\"\\/var\\/www\\/peacee.id\\/ojs-app\\/lib\\/pkp\\/lib\\/vendor\\/laravel\\/framework\\/src\\/Illuminate\\/Container\\/Util.php\",\"line\":41,\"function\":\"Illuminate\\\\Container\\\\{closure}\",\"class\":\"Illuminate\\\\Container\\\\BoundMethod\",\"type\":\"::\"},{\"file\":\"\\/var\\/www\\/peacee.id\\/ojs-app\\/lib\\/pkp\\/lib\\/vendor\\/laravel\\/framework\\/src\\/Illuminate\\/Container\\/BoundMethod.php\",\"line\":93,\"function\":\"unwrapIfClosure\",\"class\":\"Illuminate\\\\Container\\\\Util\",\"type\":\"::\"},{\"file\":\"\\/var\\/www\\/peacee.id\\/ojs-app\\/lib\\/pkp\\/lib\\/vendor\\/laravel\\/framework\\/src\\/Illuminate\\/Container\\/BoundMethod.php\",\"line\":37,\"function\":\"callBoundMethod\",\"class\":\"Illuminate\\\\Container\\\\BoundMethod\",\"type\":\"::\"},{\"file\":\"\\/var\\/www\\/peacee.id\\/ojs-app\\/lib\\/pkp\\/lib\\/vendor\\/laravel\\/framework\\/src\\/Illuminate\\/Container\\/Container.php\",\"line\":661,\"function\":\"call\",\"class\":\"Illuminate\\\\Container\\\\BoundMethod\",\"type\":\"::\"},{\"file\":\"\\/var\\/www\\/peacee.id\\/ojs-app\\/lib\\/pkp\\/lib\\/vendor\\/laravel\\/framework\\/src\\/Illuminate\\/Bus\\/Dispatcher.php\",\"line\":128,\"function\":\"call\",\"class\":\"Illuminate\\\\Container\\\\Container\",\"type\":\"->\"},{\"file\":\"\\/var\\/www\\/peacee.id\\/ojs-app\\/lib\\/pkp\\/lib\\/vendor\\/laravel\\/framework\\/src\\/Illuminate\\/Pipeline\\/Pipeline.php\",\"line\":141,\"function\":\"Illuminate\\\\Bus\\\\{closure}\",\"class\":\"Illuminate\\\\Bus\\\\Dispatcher\",\"type\":\"->\"},{\"file\":\"\\/var\\/www\\/peacee.id\\/ojs-app\\/lib\\/pkp\\/lib\\/vendor\\/laravel\\/framework\\/src\\/Illuminate\\/Pipeline\\/Pipeline.php\",\"line\":116,\"function\":\"Illuminate\\\\Pipeline\\\\{closure}\",\"class\":\"Illuminate\\\\Pipeline\\\\Pipeline\",\"type\":\"->\"},{\"file\":\"\\/var\\/www\\/peacee.id\\/ojs-app\\/lib\\/pkp\\/lib\\/vendor\\/laravel\\/framework\\/src\\/Illuminate\\/Bus\\/Dispatcher.php\",\"line\":132,\"function\":\"then\",\"class\":\"Illuminate\\\\Pipeline\\\\Pipeline\",\"type\":\"->\"},{\"file\":\"\\/var\\/www\\/peacee.id\\/ojs-app\\/lib\\/pkp\\/lib\\/vendor\\/laravel\\/framework\\/src\\/Illuminate\\/Queue\\/CallQueuedHandler.php\",\"line\":124,\"function\":\"dispatchNow\",\"class\":\"Illuminate\\\\Bus\\\\Dispatcher\",\"type\":\"->\"},{\"file\":\"\\/var\\/www\\/peacee.id\\/ojs-app\\/lib\\/pkp\\/lib\\/vendor\\/laravel\\/framework\\/src\\/Illuminate\\/Pipeline\\/Pipeline.php\",\"line\":141,\"function\":\"Illuminate\\\\Queue\\\\{closure}\",\"class\":\"Illuminate\\\\Queue\\\\CallQueuedHandler\",\"type\":\"->\"},{\"file\":\"\\/var\\/www\\/peacee.id\\/ojs-app\\/lib\\/pkp\\/lib\\/vendor\\/laravel\\/framework\\/src\\/Illuminate\\/Pipeline\\/Pipeline.php\",\"line\":116,\"function\":\"Illuminate\\\\Pipeline\\\\{closure}\",\"class\":\"Illuminate\\\\Pipeline\\\\Pipeline\",\"type\":\"->\"},{\"file\":\"\\/var\\/www\\/peacee.id\\/ojs-app\\/lib\\/pkp\\/lib\\/vendor\\/laravel\\/framework\\/src\\/Illuminate\\/Queue\\/CallQueuedHandler.php\",\"line\":126,\"function\":\"then\",\"class\":\"Illuminate\\\\Pipeline\\\\Pipeline\",\"type\":\"->\"},{\"file\":\"\\/var\\/www\\/peacee.id\\/ojs-app\\/lib\\/pkp\\/lib\\/vendor\\/laravel\\/framework\\/src\\/Illuminate\\/Queue\\/CallQueuedHandler.php\",\"line\":70,\"function\":\"dispatchThroughMiddleware\",\"class\":\"Illuminate\\\\Queue\\\\CallQueuedHandler\",\"type\":\"->\"},{\"file\":\"\\/var\\/www\\/peacee.id\\/ojs-app\\/lib\\/pkp\\/lib\\/vendor\\/laravel\\/framework\\/src\\/Illuminate\\/Queue\\/Jobs\\/Job.php\",\"line\":98,\"function\":\"call\",\"class\":\"Illuminate\\\\Queue\\\\CallQueuedHandler\",\"type\":\"->\"},{\"file\":\"\\/var\\/www\\/peacee.id\\/ojs-app\\/lib\\/pkp\\/lib\\/vendor\\/laravel\\/framework\\/src\\/Illuminate\\/Queue\\/Worker.php\",\"line\":425,\"function\":\"fire\",\"class\":\"Illuminate\\\\Queue\\\\Jobs\\\\Job\",\"type\":\"->\"},{\"file\":\"\\/var\\/www\\/peacee.id\\/ojs-app\\/lib\\/pkp\\/lib\\/vendor\\/laravel\\/framework\\/src\\/Illuminate\\/Queue\\/Worker.php\",\"line\":375,\"function\":\"process\",\"class\":\"Illuminate\\\\Queue\\\\Worker\",\"type\":\"->\"},{\"file\":\"\\/var\\/www\\/peacee.id\\/ojs-app\\/lib\\/pkp\\/lib\\/vendor\\/laravel\\/framework\\/src\\/Illuminate\\/Queue\\/Worker.php\",\"line\":326,\"function\":\"runJob\",\"class\":\"Illuminate\\\\Queue\\\\Worker\",\"type\":\"->\"},{\"file\":\"\\/var\\/www\\/peacee.id\\/ojs-app\\/lib\\/pkp\\/classes\\/core\\/PKPQueueProvider.php\",\"line\":104,\"function\":\"runNextJob\",\"class\":\"Illuminate\\\\Queue\\\\Worker\",\"type\":\"->\"},{\"file\":\"\\/var\\/www\\/peacee.id\\/ojs-app\\/lib\\/pkp\\/classes\\/queue\\/JobRunner.php\",\"line\":220,\"function\":\"runJobInQueue\",\"class\":\"PKP\\\\core\\\\PKPQueueProvider\",\"type\":\"->\"},{\"file\":\"\\/var\\/www\\/peacee.id\\/ojs-app\\/lib\\/pkp\\/classes\\/core\\/PKPQueueProvider.php\",\"line\":128,\"function\":\"processJobs\",\"class\":\"PKP\\\\queue\\\\JobRunner\",\"type\":\"->\"},{\"function\":\"PKP\\\\core\\\\{closure}\",\"class\":\"PKP\\\\core\\\\PKPQueueProvider\",\"type\":\"->\"}]}', '2024-09-01 14:22:39');
INSERT INTO `failed_jobs` (`id`, `connection`, `queue`, `payload`, `exception`, `failed_at`) VALUES (2, 'database', 'queue', '{\"uuid\":\"227e7fc9-1b14-4991-b443-e2edf29cdb83\",\"displayName\":\"PKP\\\\jobs\\\\notifications\\\\StatisticsReportMail\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":null,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":null,\"retryUntil\":null,\"data\":{\"commandName\":\"PKP\\\\jobs\\\\notifications\\\\StatisticsReportMail\",\"command\":\"O:43:\\\"PKP\\\\jobs\\\\notifications\\\\StatisticsReportMail\\\":7:{s:10:\\\"\\u0000*\\u0000userIds\\\";O:29:\\\"Illuminate\\\\Support\\\\Collection\\\":2:{s:8:\\\"\\u0000*\\u0000items\\\";a:1:{i:0;i:1;}s:28:\\\"\\u0000*\\u0000escapeWhenCastingToString\\\";b:0;}s:12:\\\"\\u0000*\\u0000contextId\\\";i:1;s:12:\\\"\\u0000*\\u0000dateStart\\\";O:17:\\\"DateTimeImmutable\\\":3:{s:4:\\\"date\\\";s:26:\\\"2024-09-01 00:00:00.000000\\\";s:13:\\\"timezone_type\\\";i:3;s:8:\\\"timezone\\\";s:3:\\\"UTC\\\";}s:10:\\\"\\u0000*\\u0000dateEnd\\\";O:17:\\\"DateTimeImmutable\\\":3:{s:4:\\\"date\\\";s:26:\\\"2024-10-01 00:00:00.000000\\\";s:13:\\\"timezone_type\\\";i:3;s:8:\\\"timezone\\\";s:3:\\\"UTC\\\";}s:10:\\\"connection\\\";s:8:\\\"database\\\";s:5:\\\"queue\\\";s:5:\\\"queue\\\";s:7:\\\"batchId\\\";s:36:\\\"9d2357af-e5e3-4269-844b-45e0f6e23f80\\\";}\"}}', '{\"message\":\"Class \\\"IntlDateFormatter\\\" not found\",\"code\":0,\"file\":\"\\/var\\/www\\/peacee.id\\/ojs-app\\/lib\\/pkp\\/jobs\\/notifications\\/StatisticsReportMail.php\",\"line\":67,\"trace\":[{\"file\":\"\\/var\\/www\\/peacee.id\\/ojs-app\\/lib\\/pkp\\/lib\\/vendor\\/laravel\\/framework\\/src\\/Illuminate\\/Container\\/BoundMethod.php\",\"line\":36,\"function\":\"handle\",\"class\":\"PKP\\\\jobs\\\\notifications\\\\StatisticsReportMail\",\"type\":\"->\"},{\"file\":\"\\/var\\/www\\/peacee.id\\/ojs-app\\/lib\\/pkp\\/lib\\/vendor\\/laravel\\/framework\\/src\\/Illuminate\\/Container\\/Util.php\",\"line\":41,\"function\":\"Illuminate\\\\Container\\\\{closure}\",\"class\":\"Illuminate\\\\Container\\\\BoundMethod\",\"type\":\"::\"},{\"file\":\"\\/var\\/www\\/peacee.id\\/ojs-app\\/lib\\/pkp\\/lib\\/vendor\\/laravel\\/framework\\/src\\/Illuminate\\/Container\\/BoundMethod.php\",\"line\":93,\"function\":\"unwrapIfClosure\",\"class\":\"Illuminate\\\\Container\\\\Util\",\"type\":\"::\"},{\"file\":\"\\/var\\/www\\/peacee.id\\/ojs-app\\/lib\\/pkp\\/lib\\/vendor\\/laravel\\/framework\\/src\\/Illuminate\\/Container\\/BoundMethod.php\",\"line\":37,\"function\":\"callBoundMethod\",\"class\":\"Illuminate\\\\Container\\\\BoundMethod\",\"type\":\"::\"},{\"file\":\"\\/var\\/www\\/peacee.id\\/ojs-app\\/lib\\/pkp\\/lib\\/vendor\\/laravel\\/framework\\/src\\/Illuminate\\/Container\\/Container.php\",\"line\":661,\"function\":\"call\",\"class\":\"Illuminate\\\\Container\\\\BoundMethod\",\"type\":\"::\"},{\"file\":\"\\/var\\/www\\/peacee.id\\/ojs-app\\/lib\\/pkp\\/lib\\/vendor\\/laravel\\/framework\\/src\\/Illuminate\\/Bus\\/Dispatcher.php\",\"line\":128,\"function\":\"call\",\"class\":\"Illuminate\\\\Container\\\\Container\",\"type\":\"->\"},{\"file\":\"\\/var\\/www\\/peacee.id\\/ojs-app\\/lib\\/pkp\\/lib\\/vendor\\/laravel\\/framework\\/src\\/Illuminate\\/Pipeline\\/Pipeline.php\",\"line\":141,\"function\":\"Illuminate\\\\Bus\\\\{closure}\",\"class\":\"Illuminate\\\\Bus\\\\Dispatcher\",\"type\":\"->\"},{\"file\":\"\\/var\\/www\\/peacee.id\\/ojs-app\\/lib\\/pkp\\/lib\\/vendor\\/laravel\\/framework\\/src\\/Illuminate\\/Pipeline\\/Pipeline.php\",\"line\":116,\"function\":\"Illuminate\\\\Pipeline\\\\{closure}\",\"class\":\"Illuminate\\\\Pipeline\\\\Pipeline\",\"type\":\"->\"},{\"file\":\"\\/var\\/www\\/peacee.id\\/ojs-app\\/lib\\/pkp\\/lib\\/vendor\\/laravel\\/framework\\/src\\/Illuminate\\/Bus\\/Dispatcher.php\",\"line\":132,\"function\":\"then\",\"class\":\"Illuminate\\\\Pipeline\\\\Pipeline\",\"type\":\"->\"},{\"file\":\"\\/var\\/www\\/peacee.id\\/ojs-app\\/lib\\/pkp\\/lib\\/vendor\\/laravel\\/framework\\/src\\/Illuminate\\/Queue\\/CallQueuedHandler.php\",\"line\":124,\"function\":\"dispatchNow\",\"class\":\"Illuminate\\\\Bus\\\\Dispatcher\",\"type\":\"->\"},{\"file\":\"\\/var\\/www\\/peacee.id\\/ojs-app\\/lib\\/pkp\\/lib\\/vendor\\/laravel\\/framework\\/src\\/Illuminate\\/Pipeline\\/Pipeline.php\",\"line\":141,\"function\":\"Illuminate\\\\Queue\\\\{closure}\",\"class\":\"Illuminate\\\\Queue\\\\CallQueuedHandler\",\"type\":\"->\"},{\"file\":\"\\/var\\/www\\/peacee.id\\/ojs-app\\/lib\\/pkp\\/lib\\/vendor\\/laravel\\/framework\\/src\\/Illuminate\\/Pipeline\\/Pipeline.php\",\"line\":116,\"function\":\"Illuminate\\\\Pipeline\\\\{closure}\",\"class\":\"Illuminate\\\\Pipeline\\\\Pipeline\",\"type\":\"->\"},{\"file\":\"\\/var\\/www\\/peacee.id\\/ojs-app\\/lib\\/pkp\\/lib\\/vendor\\/laravel\\/framework\\/src\\/Illuminate\\/Queue\\/CallQueuedHandler.php\",\"line\":126,\"function\":\"then\",\"class\":\"Illuminate\\\\Pipeline\\\\Pipeline\",\"type\":\"->\"},{\"file\":\"\\/var\\/www\\/peacee.id\\/ojs-app\\/lib\\/pkp\\/lib\\/vendor\\/laravel\\/framework\\/src\\/Illuminate\\/Queue\\/CallQueuedHandler.php\",\"line\":70,\"function\":\"dispatchThroughMiddleware\",\"class\":\"Illuminate\\\\Queue\\\\CallQueuedHandler\",\"type\":\"->\"},{\"file\":\"\\/var\\/www\\/peacee.id\\/ojs-app\\/lib\\/pkp\\/lib\\/vendor\\/laravel\\/framework\\/src\\/Illuminate\\/Queue\\/Jobs\\/Job.php\",\"line\":98,\"function\":\"call\",\"class\":\"Illuminate\\\\Queue\\\\CallQueuedHandler\",\"type\":\"->\"},{\"file\":\"\\/var\\/www\\/peacee.id\\/ojs-app\\/lib\\/pkp\\/lib\\/vendor\\/laravel\\/framework\\/src\\/Illuminate\\/Queue\\/Worker.php\",\"line\":425,\"function\":\"fire\",\"class\":\"Illuminate\\\\Queue\\\\Jobs\\\\Job\",\"type\":\"->\"},{\"file\":\"\\/var\\/www\\/peacee.id\\/ojs-app\\/lib\\/pkp\\/lib\\/vendor\\/laravel\\/framework\\/src\\/Illuminate\\/Queue\\/Worker.php\",\"line\":375,\"function\":\"process\",\"class\":\"Illuminate\\\\Queue\\\\Worker\",\"type\":\"->\"},{\"file\":\"\\/var\\/www\\/peacee.id\\/ojs-app\\/lib\\/pkp\\/lib\\/vendor\\/laravel\\/framework\\/src\\/Illuminate\\/Queue\\/Worker.php\",\"line\":326,\"function\":\"runJob\",\"class\":\"Illuminate\\\\Queue\\\\Worker\",\"type\":\"->\"},{\"file\":\"\\/var\\/www\\/peacee.id\\/ojs-app\\/lib\\/pkp\\/classes\\/core\\/PKPQueueProvider.php\",\"line\":104,\"function\":\"runNextJob\",\"class\":\"Illuminate\\\\Queue\\\\Worker\",\"type\":\"->\"},{\"file\":\"\\/var\\/www\\/peacee.id\\/ojs-app\\/lib\\/pkp\\/classes\\/queue\\/JobRunner.php\",\"line\":220,\"function\":\"runJobInQueue\",\"class\":\"PKP\\\\core\\\\PKPQueueProvider\",\"type\":\"->\"},{\"file\":\"\\/var\\/www\\/peacee.id\\/ojs-app\\/lib\\/pkp\\/classes\\/core\\/PKPQueueProvider.php\",\"line\":128,\"function\":\"processJobs\",\"class\":\"PKP\\\\queue\\\\JobRunner\",\"type\":\"->\"},{\"function\":\"PKP\\\\core\\\\{closure}\",\"class\":\"PKP\\\\core\\\\PKPQueueProvider\",\"type\":\"->\"}]}', '2024-10-01 04:53:27');
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Records information in the database about files tracked by the system, linking them to the local filesystem.';

-- ----------------------------
-- Records of files
-- ----------------------------
BEGIN;
INSERT INTO `files` (`file_id`, `path`, `mimetype`) VALUES (1, 'journals/1/articles/1/67063d21071cb.pdf', 'application/pdf');
INSERT INTO `files` (`file_id`, `path`, `mimetype`) VALUES (2, 'journals/1/articles/2/67063e088a3a3.pdf', 'application/pdf');
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
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='More data about file genres, including localized properties such as the genre name.';

-- ----------------------------
-- Records of genre_settings
-- ----------------------------
BEGIN;
INSERT INTO `genre_settings` (`genre_setting_id`, `genre_id`, `locale`, `setting_name`, `setting_value`, `setting_type`) VALUES (1, 1, 'en', 'name', 'Article Text', 'string');
INSERT INTO `genre_settings` (`genre_setting_id`, `genre_id`, `locale`, `setting_name`, `setting_value`, `setting_type`) VALUES (2, 2, 'en', 'name', 'Research Instrument', 'string');
INSERT INTO `genre_settings` (`genre_setting_id`, `genre_id`, `locale`, `setting_name`, `setting_value`, `setting_type`) VALUES (3, 3, 'en', 'name', 'Research Materials', 'string');
INSERT INTO `genre_settings` (`genre_setting_id`, `genre_id`, `locale`, `setting_name`, `setting_value`, `setting_type`) VALUES (4, 4, 'en', 'name', 'Research Results', 'string');
INSERT INTO `genre_settings` (`genre_setting_id`, `genre_id`, `locale`, `setting_name`, `setting_value`, `setting_type`) VALUES (5, 5, 'en', 'name', 'Transcripts', 'string');
INSERT INTO `genre_settings` (`genre_setting_id`, `genre_id`, `locale`, `setting_name`, `setting_value`, `setting_type`) VALUES (6, 6, 'en', 'name', 'Data Analysis', 'string');
INSERT INTO `genre_settings` (`genre_setting_id`, `genre_id`, `locale`, `setting_name`, `setting_value`, `setting_type`) VALUES (7, 7, 'en', 'name', 'Data Set', 'string');
INSERT INTO `genre_settings` (`genre_setting_id`, `genre_id`, `locale`, `setting_name`, `setting_value`, `setting_type`) VALUES (8, 8, 'en', 'name', 'Source Texts', 'string');
INSERT INTO `genre_settings` (`genre_setting_id`, `genre_id`, `locale`, `setting_name`, `setting_value`, `setting_type`) VALUES (9, 9, 'en', 'name', 'Multimedia', 'string');
INSERT INTO `genre_settings` (`genre_setting_id`, `genre_id`, `locale`, `setting_name`, `setting_value`, `setting_type`) VALUES (10, 10, 'en', 'name', 'Image', 'string');
INSERT INTO `genre_settings` (`genre_setting_id`, `genre_id`, `locale`, `setting_name`, `setting_value`, `setting_type`) VALUES (11, 11, 'en', 'name', 'HTML Stylesheet', 'string');
INSERT INTO `genre_settings` (`genre_setting_id`, `genre_id`, `locale`, `setting_name`, `setting_value`, `setting_type`) VALUES (12, 12, 'en', 'name', 'Other', 'string');
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
INSERT INTO `job_batches` (`id`, `name`, `total_jobs`, `pending_jobs`, `failed_jobs`, `failed_job_ids`, `options`, `cancelled_at`, `created_at`, `finished_at`) VALUES ('9cdb66c1-7360-4c63-9163-896338d44eb8', '', 0, 0, 0, '[]', 'a:0:{}', NULL, 1724661357, NULL);
INSERT INTO `job_batches` (`id`, `name`, `total_jobs`, `pending_jobs`, `failed_jobs`, `failed_job_ids`, `options`, `cancelled_at`, `created_at`, `finished_at`) VALUES ('9ce7c9aa-16bd-41a5-9933-82edc341c49d', '', 2, 1, 1, '[\"6907b35a-b407-4260-a999-214cc4c1f77e\"]', 'a:0:{}', 1725193359, 1725193348, 1725193359);
INSERT INTO `job_batches` (`id`, `name`, `total_jobs`, `pending_jobs`, `failed_jobs`, `failed_job_ids`, `options`, `cancelled_at`, `created_at`, `finished_at`) VALUES ('9d2357af-e5e3-4269-844b-45e0f6e23f80', '', 2, 1, 1, '[\"227e7fc9-1b14-4991-b443-e2edf29cdb83\"]', 'a:0:{}', 1727751207, 1727751205, 1727751207);
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
) ENGINE=InnoDB AUTO_INCREMENT=111 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='All pending or in-progress jobs.';

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
) ENGINE=InnoDB AUTO_INCREMENT=82 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='More data about journals, including localized properties like policies.';

-- ----------------------------
-- Records of journal_settings
-- ----------------------------
BEGIN;
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (1, 1, 'en', 'acronym', 'PEACEE');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (2, 1, 'en', 'authorGuidelines', '<p>Authors are invited to make a submission to this journal. All submissions will be assessed by an editor to determine whether they meet the aims and scope of this journal. Those considered to be a good fit will be sent for peer review before determining whether they will be accepted or rejected.</p><p>Before making a submission, authors are responsible for obtaining permission to publish any material included with the submission, such as photos, documents and datasets. All authors identified on the submission must consent to be identified as an author. Where appropriate, research should be approved by an appropriate ethics committee in accordance with the legal requirements of the study\'s country.</p><p>An editor may desk reject a submission if it does not meet minimum standards of quality. Before submitting, please ensure that the study design and research argument are structured and articulated properly. The title should be concise and the abstract should be able to stand on its own. This will increase the likelihood of reviewers agreeing to review the paper. When you\'re satisfied that your submission meets this standard, please follow the checklist below to prepare your submission.</p>');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (3, 1, 'en', 'authorInformation', 'Interested in submitting to this journal? We recommend that you review the <a href=\"http://peacee.id/index.php/peacee/about\">About the Journal</a> page for the journal\'s section policies, as well as the <a href=\"http://peacee.id/index.php/peacee/about/submissions#authorGuidelines\">Author Guidelines</a>. Authors need to <a href=\"http://peacee.id/index.php/peacee/user/register\">register</a> with the journal prior to submitting or, if already registered, can simply <a href=\"http://peacee.id/index.php/index/login\">log in</a> and begin the five-step process.');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (4, 1, 'en', 'beginSubmissionHelp', '<p>Thank you for submitting to the Progress in Electrical and Computer Engineering Education. You will be asked to upload files, identify co-authors, and provide information such as the title and abstract.<p><p>Please read our <a href=\"http://peacee.id/index.php/peacee/about/submissions\" target=\"_blank\">Submission Guidelines</a> if you have not done so already. When filling out the forms, provide as many details as possible in order to help our editors evaluate your work.</p><p>Once you begin, you can save your submission and come back to it later. You will be able to review and correct any information before you submit.</p>');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (5, 1, '', 'contactEmail', 'deewahyu@upi.edu');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (6, 1, '', 'contactName', 'Didin Wahyudin');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (7, 1, 'en', 'contributorsHelp', '<p>Add details for all of the contributors to this submission. Contributors added here will be sent an email confirmation of the submission, as well as a copy of all editorial decisions recorded against this submission.</p><p>If a contributor can not be contacted by email, because they must remain anonymous or do not have an email account, please do not enter a fake email address. You can add information about this contributor in a message to the editor at a later step in the submission process.</p>');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (8, 1, '', 'country', 'ID');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (9, 1, '', 'defaultReviewMode', '2');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (11, 1, 'en', 'detailsHelp', '<p>Please provide the following details to help us manage your submission in our system.</p>');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (12, 1, '', 'copySubmissionAckPrimaryContact', '0');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (13, 1, '', 'copySubmissionAckAddress', '');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (14, 1, '', 'emailSignature', '<br><br>—<br><p>This is an automated message from <a href=\"http://peacee.id/index.php/peacee\">Progress in Electrical and Computer Engineering Education</a>.</p>');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (15, 1, '', 'enableDois', '1');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (16, 1, '', 'doiSuffixType', 'default');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (17, 1, '', 'registrationAgency', '');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (18, 1, '', 'disableSubmissions', '0');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (19, 1, '', 'editorialStatsEmail', '1');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (20, 1, 'en', 'forTheEditorsHelp', '<p>Please provide the following details in order to help our editorial team manage your submission.</p><p>When entering metadata, provide entries that you think would be most helpful to the person managing your submission. This information can be changed before publication.</p>');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (21, 1, '', 'itemsPerPage', '25');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (22, 1, '', 'keywords', 'request');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (23, 1, 'en', 'librarianInformation', 'We encourage research librarians to list this journal among their library\'s electronic journal holdings. As well, it may be worth noting that this journal\'s open source publishing system is suitable for libraries to host for their faculty members to use with journals they are involved in editing (see <a href=\"https://pkp.sfu.ca/ojs\">Open Journal Systems</a>).');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (24, 1, 'en', 'name', 'Progress in Electrical and Computer Engineering Education');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (25, 1, '', 'notifyAllAuthors', '1');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (26, 1, '', 'numPageLinks', '10');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (27, 1, '', 'numWeeksPerResponse', '4');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (28, 1, '', 'numWeeksPerReview', '4');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (29, 1, 'en', 'openAccessPolicy', 'This journal provides immediate open access to its content on the principle that making research freely available to the public supports a greater global exchange of knowledge.');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (30, 1, 'en', 'privacyStatement', '<p>The names and email addresses entered in this journal site will be used exclusively for the stated purposes of this journal and will not be made available for any other purpose or to any other party.</p>');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (31, 1, 'en', 'readerInformation', 'We encourage readers to sign up for the publishing notification service for this journal. Use the <a href=\"http://peacee.id/index.php/peacee/user/register\">Register</a> link at the top of the home page for the journal. This registration will result in the reader receiving the Table of Contents by email for each new issue of the journal. This list also allows the journal to claim a certain level of support or readership. See the journal\'s <a href=\"http://peacee.id/index.php/peacee/about/submissions#privacyStatement\">Privacy Statement</a>, which assures readers that their name and email address will not be used for other purposes.');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (32, 1, 'en', 'reviewHelp', '<p>Review the information you have entered before you complete your submission. You can change any of the details displayed here by clicking the edit button at the top of each section.</p><p>Once you complete your submission, a member of our editorial team will be assigned to review it. Please ensure the details you have entered here are as accurate as possible.</p>');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (33, 1, '', 'submissionAcknowledgement', 'allAuthors');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (34, 1, 'en', 'submissionChecklist', '<p>All submissions must meet the following requirements.</p><ul><li>This submission meets the requirements outlined in the <a href=\"http://peacee.id/index.php/peacee/about/submissions\">Author Guidelines</a>.</li><li>This submission has not been previously published, nor is it before another journal for consideration.</li><li>All references have been checked for accuracy and completeness.</li><li>All tables and figures have been numbered and labeled.</li><li>Permission has been obtained to publish all photos, datasets and other material provided with this submission.</li></ul>');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (35, 1, '', 'submitWithCategories', '0');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (36, 1, '', 'supportedFormLocales', '[\"en\"]');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (37, 1, '', 'supportedLocales', '[\"en\"]');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (38, 1, '', 'supportedSubmissionLocales', '[\"en\"]');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (39, 1, '', 'themePluginPath', 'default');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (40, 1, 'en', 'uploadFilesHelp', '<p>Provide any files our editorial team may need to evaluate your submission. In addition to the main work, you may wish to submit data sets, conflict of interest statements, or other supplementary files if these will be helpful for our editors.</p>');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (41, 1, '', 'enableGeoUsageStats', 'disabled');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (42, 1, '', 'enableInstitutionUsageStats', '0');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (43, 1, '', 'isSushiApiPublic', '1');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (44, 1, 'en', 'abbreviation', 'PEACEE');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (45, 1, 'en', 'clockssLicense', 'This journal utilizes the CLOCKSS system to create a distributed archiving system among participating libraries and permits those libraries to create permanent archives of the journal for purposes of preservation and restoration. <a href=\"https://clockss.org\">More...</a>');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (46, 1, '', 'copyrightYearBasis', 'issue');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (47, 1, '', 'enabledDoiTypes', '[\"publication\"]');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (48, 1, '', 'doiCreationTime', 'copyEditCreationTime');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (49, 1, '', 'enableOai', '1');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (50, 1, 'en', 'lockssLicense', 'This journal utilizes the LOCKSS system to create a distributed archiving system among participating libraries and permits those libraries to create permanent archives of the journal for purposes of preservation and restoration. <a href=\"https://www.lockss.org\">More...</a>');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (51, 1, '', 'membershipFee', '0');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (52, 1, '', 'publicationFee', '0');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (53, 1, '', 'purchaseArticleFee', '0');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (54, 1, '', 'doiVersioning', '0');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (55, 1, 'en', 'about', '<p>About The Journal</p>\n<p>peacee</p>');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (56, 1, 'en', 'description', '<p>Journal Summary</p>\n<p>peacee</p>');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (57, 1, 'en', 'editorialTeam', '<p>Electrical Team</p>\n<p>peacee</p>');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (58, 1, '', 'publisherInstitution', 'Universitas Pendidikan Indonesia');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (59, 1, '', 'sidebar', '[\"subscriptionblockplugin\",\"AnnouncementFeedBlockPlugin\",\"informationblockplugin\",\"WebFeedBlockPlugin\",\"languagetoggleblockplugin\"]');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (60, 1, 'en', 'dateFormatLong', '%e %B %Y');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (61, 1, 'en', 'dateFormatShort', '%d-%m-%Y');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (62, 1, 'en', 'datetimeFormatLong', '%e %B %Y - %H:%M');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (63, 1, 'en', 'datetimeFormatShort', '%d-%m-%Y %H:%M');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (64, 1, 'en', 'timeFormat', '%H:%M');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (78, 1, 'en', 'favicon', '{\"name\":\"Favicon.png\",\"uploadName\":\"favicon_en.png\",\"width\":926,\"height\":883,\"dateUploaded\":\"2024-08-29 01:57:38\",\"altText\":\"Favicon\"}');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (80, 1, 'en', 'pageFooter', '<p>Progress in Electrical and Computer Engineering Education</p>\n<p>Contact :</p>');
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
INSERT INTO `journals` (`journal_id`, `path`, `seq`, `primary_locale`, `enabled`, `current_issue_id`) VALUES (1, 'journal', 1.00, 'en', 1, NULL);
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
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Daily statistics for views of the homepage.';

-- ----------------------------
-- Records of metrics_context
-- ----------------------------
BEGIN;
INSERT INTO `metrics_context` (`metrics_context_id`, `load_id`, `context_id`, `date`, `metric`) VALUES (1, 'usage_events_20240826.log', 1, '2024-08-26', 15);
INSERT INTO `metrics_context` (`metrics_context_id`, `load_id`, `context_id`, `date`, `metric`) VALUES (2, 'usage_events_20240827.log', 1, '2024-08-27', 11);
INSERT INTO `metrics_context` (`metrics_context_id`, `load_id`, `context_id`, `date`, `metric`) VALUES (3, 'usage_events_20240828.log', 1, '2024-08-28', 29);
INSERT INTO `metrics_context` (`metrics_context_id`, `load_id`, `context_id`, `date`, `metric`) VALUES (4, 'usage_events_20240829.log', 1, '2024-08-29', 28);
INSERT INTO `metrics_context` (`metrics_context_id`, `load_id`, `context_id`, `date`, `metric`) VALUES (5, 'usage_events_20240830.log', 1, '2024-08-30', 2);
INSERT INTO `metrics_context` (`metrics_context_id`, `load_id`, `context_id`, `date`, `metric`) VALUES (6, 'usage_events_20240901.log', 1, '2024-09-01', 1);
INSERT INTO `metrics_context` (`metrics_context_id`, `load_id`, `context_id`, `date`, `metric`) VALUES (7, 'usage_events_20240902.log', 1, '2024-09-02', 1);
INSERT INTO `metrics_context` (`metrics_context_id`, `load_id`, `context_id`, `date`, `metric`) VALUES (8, 'usage_events_20240905.log', 1, '2024-09-05', 1);
INSERT INTO `metrics_context` (`metrics_context_id`, `load_id`, `context_id`, `date`, `metric`) VALUES (9, 'usage_events_20240906.log', 1, '2024-09-06', 33);
INSERT INTO `metrics_context` (`metrics_context_id`, `load_id`, `context_id`, `date`, `metric`) VALUES (10, 'usage_events_20240907.log', 1, '2024-09-07', 3);
INSERT INTO `metrics_context` (`metrics_context_id`, `load_id`, `context_id`, `date`, `metric`) VALUES (11, 'usage_events_20240909.log', 1, '2024-09-09', 4);
INSERT INTO `metrics_context` (`metrics_context_id`, `load_id`, `context_id`, `date`, `metric`) VALUES (12, 'usage_events_20240916.log', 1, '2024-09-16', 1);
INSERT INTO `metrics_context` (`metrics_context_id`, `load_id`, `context_id`, `date`, `metric`) VALUES (13, 'usage_events_20240917.log', 1, '2024-09-17', 1);
INSERT INTO `metrics_context` (`metrics_context_id`, `load_id`, `context_id`, `date`, `metric`) VALUES (14, 'usage_events_20240918.log', 1, '2024-09-18', 2);
INSERT INTO `metrics_context` (`metrics_context_id`, `load_id`, `context_id`, `date`, `metric`) VALUES (15, 'usage_events_20240927.log', 1, '2024-09-27', 1);
INSERT INTO `metrics_context` (`metrics_context_id`, `load_id`, `context_id`, `date`, `metric`) VALUES (16, 'usage_events_20241001.log', 1, '2024-10-01', 13);
INSERT INTO `metrics_context` (`metrics_context_id`, `load_id`, `context_id`, `date`, `metric`) VALUES (17, 'usage_events_20241003.log', 1, '2024-10-03', 6);
INSERT INTO `metrics_context` (`metrics_context_id`, `load_id`, `context_id`, `date`, `metric`) VALUES (18, 'usage_events_20241006.log', 1, '2024-10-06', 2);
INSERT INTO `metrics_context` (`metrics_context_id`, `load_id`, `context_id`, `date`, `metric`) VALUES (19, 'usage_events_20241008.log', 1, '2024-10-08', 1);
INSERT INTO `metrics_context` (`metrics_context_id`, `load_id`, `context_id`, `date`, `metric`) VALUES (20, 'usage_events_20241007.log', 1, '2024-10-07', 1);
INSERT INTO `metrics_context` (`metrics_context_id`, `load_id`, `context_id`, `date`, `metric`) VALUES (21, 'usage_events_20241009.log', 1, '2024-10-09', 4);
INSERT INTO `metrics_context` (`metrics_context_id`, `load_id`, `context_id`, `date`, `metric`) VALUES (22, 'usage_events_20241010.log', 1, '2024-10-10', 10);
INSERT INTO `metrics_context` (`metrics_context_id`, `load_id`, `context_id`, `date`, `metric`) VALUES (23, 'usage_events_20241012.log', 1, '2024-10-12', 3);
INSERT INTO `metrics_context` (`metrics_context_id`, `load_id`, `context_id`, `date`, `metric`) VALUES (24, 'usage_events_20241011.log', 1, '2024-10-11', 5);
INSERT INTO `metrics_context` (`metrics_context_id`, `load_id`, `context_id`, `date`, `metric`) VALUES (25, 'usage_events_20241013.log', 1, '2024-10-13', 4);
INSERT INTO `metrics_context` (`metrics_context_id`, `load_id`, `context_id`, `date`, `metric`) VALUES (26, 'usage_events_20241014.log', 1, '2024-10-14', 3);
INSERT INTO `metrics_context` (`metrics_context_id`, `load_id`, `context_id`, `date`, `metric`) VALUES (27, 'usage_events_20241017.log', 1, '2024-10-17', 1);
INSERT INTO `metrics_context` (`metrics_context_id`, `load_id`, `context_id`, `date`, `metric`) VALUES (28, 'usage_events_20241016.log', 1, '2024-10-16', 3);
INSERT INTO `metrics_context` (`metrics_context_id`, `load_id`, `context_id`, `date`, `metric`) VALUES (29, 'usage_events_20241018.log', 1, '2024-10-18', 1);
INSERT INTO `metrics_context` (`metrics_context_id`, `load_id`, `context_id`, `date`, `metric`) VALUES (30, 'usage_events_20241020.log', 1, '2024-10-20', 4);
INSERT INTO `metrics_context` (`metrics_context_id`, `load_id`, `context_id`, `date`, `metric`) VALUES (31, 'usage_events_20241019.log', 1, '2024-10-19', 2);
INSERT INTO `metrics_context` (`metrics_context_id`, `load_id`, `context_id`, `date`, `metric`) VALUES (32, 'usage_events_20241021.log', 1, '2024-10-21', 3);
INSERT INTO `metrics_context` (`metrics_context_id`, `load_id`, `context_id`, `date`, `metric`) VALUES (33, 'usage_events_20241022.log', 1, '2024-10-22', 1);
INSERT INTO `metrics_context` (`metrics_context_id`, `load_id`, `context_id`, `date`, `metric`) VALUES (34, 'usage_events_20241023.log', 1, '2024-10-23', 2);
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
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Links navigation menu items to navigation menus.';

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
INSERT INTO `navigation_menu_item_assignments` (`navigation_menu_item_assignment_id`, `navigation_menu_id`, `navigation_menu_item_id`, `parent_id`, `seq`) VALUES (24, 3, 15, 0, 0);
INSERT INTO `navigation_menu_item_assignments` (`navigation_menu_item_assignment_id`, `navigation_menu_id`, `navigation_menu_item_id`, `parent_id`, `seq`) VALUES (25, 3, 19, 0, 1);
INSERT INTO `navigation_menu_item_assignments` (`navigation_menu_item_assignment_id`, `navigation_menu_id`, `navigation_menu_item_id`, `parent_id`, `seq`) VALUES (26, 3, 16, 0, 2);
INSERT INTO `navigation_menu_item_assignments` (`navigation_menu_item_assignment_id`, `navigation_menu_id`, `navigation_menu_item_id`, `parent_id`, `seq`) VALUES (27, 3, 17, 0, 3);
INSERT INTO `navigation_menu_item_assignments` (`navigation_menu_item_assignment_id`, `navigation_menu_id`, `navigation_menu_item_id`, `parent_id`, `seq`) VALUES (28, 3, 18, 0, 4);
INSERT INTO `navigation_menu_item_assignments` (`navigation_menu_item_assignment_id`, `navigation_menu_id`, `navigation_menu_item_id`, `parent_id`, `seq`) VALUES (29, 3, 20, 18, 5);
INSERT INTO `navigation_menu_item_assignments` (`navigation_menu_item_assignment_id`, `navigation_menu_id`, `navigation_menu_item_id`, `parent_id`, `seq`) VALUES (30, 3, 21, 18, 6);
INSERT INTO `navigation_menu_item_assignments` (`navigation_menu_item_assignment_id`, `navigation_menu_id`, `navigation_menu_item_id`, `parent_id`, `seq`) VALUES (31, 3, 22, 18, 7);
INSERT INTO `navigation_menu_item_assignments` (`navigation_menu_item_assignment_id`, `navigation_menu_id`, `navigation_menu_item_id`, `parent_id`, `seq`) VALUES (32, 3, 23, 18, 8);
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
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='More data about navigation menu items, including localized content such as names.';

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
INSERT INTO `navigation_menu_item_settings` (`navigation_menu_item_setting_id`, `navigation_menu_item_id`, `locale`, `setting_name`, `setting_value`, `setting_type`) VALUES (25, 19, 'en', 'title', 'About the Journal Peacee', 'string');
INSERT INTO `navigation_menu_item_settings` (`navigation_menu_item_setting_id`, `navigation_menu_item_id`, `locale`, `setting_name`, `setting_value`, `setting_type`) VALUES (26, 19, 'en', 'content', '', 'string');
INSERT INTO `navigation_menu_item_settings` (`navigation_menu_item_setting_id`, `navigation_menu_item_id`, `locale`, `setting_name`, `setting_value`, `setting_type`) VALUES (27, 19, 'en', 'remoteUrl', '', 'string');
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
INSERT INTO `navigation_menu_items` (`navigation_menu_item_id`, `context_id`, `path`, `type`) VALUES (19, 1, '', 'NMI_TYPE_ABOUT');
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
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='More data about notifications, including localized properties.';

-- ----------------------------
-- Records of notification_settings
-- ----------------------------
BEGIN;
INSERT INTO `notification_settings` (`notification_setting_id`, `notification_id`, `locale`, `setting_name`, `setting_value`, `setting_type`) VALUES (8, 8, '', 'contents', 'This is a kind reminder for you to check your journal\'s health through the editorial report.', 'string');
INSERT INTO `notification_settings` (`notification_setting_id`, `notification_id`, `locale`, `setting_name`, `setting_value`, `setting_type`) VALUES (9, 9, '', 'contents', 'This is a kind reminder for you to check your journal\'s health through the editorial report.', 'string');
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
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='User notifications created during certain operations.';

-- ----------------------------
-- Records of notifications
-- ----------------------------
BEGIN;
INSERT INTO `notifications` (`notification_id`, `context_id`, `user_id`, `level`, `type`, `date_created`, `date_read`, `assoc_type`, `assoc_id`) VALUES (8, 1, 1, 3, 16777258, '2024-09-01 12:22:30', '2024-10-20 04:44:43', 0, 0);
INSERT INTO `notifications` (`notification_id`, `context_id`, `user_id`, `level`, `type`, `date_created`, `date_read`, `assoc_type`, `assoc_id`) VALUES (9, 1, 1, 3, 16777258, '2024-10-01 02:53:26', '2024-10-20 04:44:43', 0, 0);
INSERT INTO `notifications` (`notification_id`, `context_id`, `user_id`, `level`, `type`, `date_created`, `date_read`, `assoc_type`, `assoc_id`) VALUES (18, 1, NULL, 3, 16777220, '2024-10-09 08:23:34', NULL, 1048585, 1);
INSERT INTO `notifications` (`notification_id`, `context_id`, `user_id`, `level`, `type`, `date_created`, `date_read`, `assoc_type`, `assoc_id`) VALUES (19, 1, NULL, 3, 16777222, '2024-10-09 08:23:34', NULL, 1048585, 1);
INSERT INTO `notifications` (`notification_id`, `context_id`, `user_id`, `level`, `type`, `date_created`, `date_read`, `assoc_type`, `assoc_id`) VALUES (20, 1, NULL, 3, 16777223, '2024-10-09 08:23:34', NULL, 1048585, 1);
INSERT INTO `notifications` (`notification_id`, `context_id`, `user_id`, `level`, `type`, `date_created`, `date_read`, `assoc_type`, `assoc_id`) VALUES (21, 1, NULL, 3, 16777224, '2024-10-09 08:23:34', NULL, 1048585, 1);
INSERT INTO `notifications` (`notification_id`, `context_id`, `user_id`, `level`, `type`, `date_created`, `date_read`, `assoc_type`, `assoc_id`) VALUES (22, 1, 1, 3, 16777247, '2024-10-09 08:23:35', '2024-10-20 04:44:43', 1048585, 1);
INSERT INTO `notifications` (`notification_id`, `context_id`, `user_id`, `level`, `type`, `date_created`, `date_read`, `assoc_type`, `assoc_id`) VALUES (23, 1, NULL, 3, 16777220, '2024-10-09 08:26:09', NULL, 1048585, 2);
INSERT INTO `notifications` (`notification_id`, `context_id`, `user_id`, `level`, `type`, `date_created`, `date_read`, `assoc_type`, `assoc_id`) VALUES (24, 1, NULL, 3, 16777222, '2024-10-09 08:26:09', NULL, 1048585, 2);
INSERT INTO `notifications` (`notification_id`, `context_id`, `user_id`, `level`, `type`, `date_created`, `date_read`, `assoc_type`, `assoc_id`) VALUES (25, 1, NULL, 3, 16777223, '2024-10-09 08:26:09', NULL, 1048585, 2);
INSERT INTO `notifications` (`notification_id`, `context_id`, `user_id`, `level`, `type`, `date_created`, `date_read`, `assoc_type`, `assoc_id`) VALUES (26, 1, NULL, 3, 16777224, '2024-10-09 08:26:09', NULL, 1048585, 2);
INSERT INTO `notifications` (`notification_id`, `context_id`, `user_id`, `level`, `type`, `date_created`, `date_read`, `assoc_type`, `assoc_id`) VALUES (27, 1, 1, 3, 16777247, '2024-10-09 08:26:10', '2024-10-20 04:44:43', 1048585, 2);
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
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='More data about plugins, including localized properties. This table is frequently used to store plugin-specific configuration.';

-- ----------------------------
-- Records of plugin_settings
-- ----------------------------
BEGIN;
INSERT INTO `plugin_settings` (`plugin_setting_id`, `plugin_name`, `context_id`, `setting_name`, `setting_value`, `setting_type`) VALUES (1, 'defaultthemeplugin', 0, 'enabled', '1', 'bool');
INSERT INTO `plugin_settings` (`plugin_setting_id`, `plugin_name`, `context_id`, `setting_name`, `setting_value`, `setting_type`) VALUES (2, 'acronplugin', 0, 'enabled', '1', 'bool');
INSERT INTO `plugin_settings` (`plugin_setting_id`, `plugin_name`, `context_id`, `setting_name`, `setting_value`, `setting_type`) VALUES (3, 'acronplugin', 0, 'crontab', '[{\"className\":\"APP\\\\plugins\\\\importexport\\\\doaj\\\\DOAJInfoSender\",\"frequency\":{\"hour\":24},\"args\":[]},{\"className\":\"PKP\\\\task\\\\ReviewReminder\",\"frequency\":{\"hour\":24},\"args\":[]},{\"className\":\"PKP\\\\task\\\\StatisticsReport\",\"frequency\":{\"day\":\"1\"},\"args\":[]},{\"className\":\"APP\\\\tasks\\\\SubscriptionExpiryReminder\",\"frequency\":{\"day\":\"1\"},\"args\":[]},{\"className\":\"PKP\\\\task\\\\DepositDois\",\"frequency\":{\"hour\":24},\"args\":[]},{\"className\":\"PKP\\\\task\\\\RemoveUnvalidatedExpiredUsers\",\"frequency\":{\"day\":\"1\"},\"args\":[]},{\"className\":\"PKP\\\\task\\\\EditorialReminders\",\"frequency\":{\"day\":\"1\"},\"args\":[]},{\"className\":\"PKP\\\\task\\\\UpdateIPGeoDB\",\"frequency\":{\"day\":\"10\"},\"args\":[]},{\"className\":\"APP\\\\tasks\\\\UsageStatsLoader\",\"frequency\":{\"hour\":24},\"args\":[]},{\"className\":\"PKP\\\\task\\\\ProcessQueueJobs\",\"frequency\":{\"hour\":24},\"args\":[]},{\"className\":\"PKP\\\\task\\\\RemoveFailedJobs\",\"frequency\":{\"day\":\"1\"},\"args\":[]},{\"className\":\"APP\\\\tasks\\\\OpenAccessNotification\",\"frequency\":{\"hour\":24},\"args\":[]}]', 'object');
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
INSERT INTO `plugin_settings` (`plugin_setting_id`, `plugin_name`, `context_id`, `setting_name`, `setting_value`, `setting_type`) VALUES (32, 'defaultthemeplugin', 1, 'typography', 'lato', 'string');
INSERT INTO `plugin_settings` (`plugin_setting_id`, `plugin_name`, `context_id`, `setting_name`, `setting_value`, `setting_type`) VALUES (33, 'defaultthemeplugin', 1, 'baseColour', '#1E6292', 'string');
INSERT INTO `plugin_settings` (`plugin_setting_id`, `plugin_name`, `context_id`, `setting_name`, `setting_value`, `setting_type`) VALUES (34, 'defaultthemeplugin', 1, 'showDescriptionInJournalIndex', 'true', 'string');
INSERT INTO `plugin_settings` (`plugin_setting_id`, `plugin_name`, `context_id`, `setting_name`, `setting_value`, `setting_type`) VALUES (35, 'defaultthemeplugin', 1, 'useHomepageImageAsHeader', 'true', 'string');
INSERT INTO `plugin_settings` (`plugin_setting_id`, `plugin_name`, `context_id`, `setting_name`, `setting_value`, `setting_type`) VALUES (36, 'defaultthemeplugin', 1, 'displayStats', 'bar', 'string');
INSERT INTO `plugin_settings` (`plugin_setting_id`, `plugin_name`, `context_id`, `setting_name`, `setting_value`, `setting_type`) VALUES (37, 'immersionthemeplugin', 1, 'enabled', '1', 'bool');
INSERT INTO `plugin_settings` (`plugin_setting_id`, `plugin_name`, `context_id`, `setting_name`, `setting_value`, `setting_type`) VALUES (38, 'announcementfeedplugin', 1, 'enabled', '1', 'bool');
INSERT INTO `plugin_settings` (`plugin_setting_id`, `plugin_name`, `context_id`, `setting_name`, `setting_value`, `setting_type`) VALUES (39, 'immersionthemeplugin', 1, 'journalDescriptionColour', '#1A1818', 'string');
INSERT INTO `plugin_settings` (`plugin_setting_id`, `plugin_name`, `context_id`, `setting_name`, `setting_value`, `setting_type`) VALUES (40, 'immersionthemeplugin', 1, 'immersionAnnouncementsColor', '#1E1D1D', 'string');
INSERT INTO `plugin_settings` (`plugin_setting_id`, `plugin_name`, `context_id`, `setting_name`, `setting_value`, `setting_type`) VALUES (41, 'immersionthemeplugin', 1, 'displayStats', 'bar', 'string');
INSERT INTO `plugin_settings` (`plugin_setting_id`, `plugin_name`, `context_id`, `setting_name`, `setting_value`, `setting_type`) VALUES (42, 'immersionthemeplugin', 1, 'sectionDescriptionSetting', 'enable', 'string');
INSERT INTO `plugin_settings` (`plugin_setting_id`, `plugin_name`, `context_id`, `setting_name`, `setting_value`, `setting_type`) VALUES (43, 'immersionthemeplugin', 1, 'journalDescription', '1', 'string');
INSERT INTO `plugin_settings` (`plugin_setting_id`, `plugin_name`, `context_id`, `setting_name`, `setting_value`, `setting_type`) VALUES (44, 'customblockmanagerplugin', 1, 'enabled', '1', 'bool');
INSERT INTO `plugin_settings` (`plugin_setting_id`, `plugin_name`, `context_id`, `setting_name`, `setting_value`, `setting_type`) VALUES (45, 'staticpagesplugin', 1, 'enabled', '1', 'bool');
INSERT INTO `plugin_settings` (`plugin_setting_id`, `plugin_name`, `context_id`, `setting_name`, `setting_value`, `setting_type`) VALUES (46, 'browsebysectionplugin', 1, 'enabled', '1', 'bool');
INSERT INTO `plugin_settings` (`plugin_setting_id`, `plugin_name`, `context_id`, `setting_name`, `setting_value`, `setting_type`) VALUES (47, 'googleanalyticsplugin', 1, 'enabled', '1', 'bool');
INSERT INTO `plugin_settings` (`plugin_setting_id`, `plugin_name`, `context_id`, `setting_name`, `setting_value`, `setting_type`) VALUES (48, 'makesubmissionblockplugin', 1, 'enabled', '1', 'bool');
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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='More data about publications, including localized properties such as the title and abstract.';

-- ----------------------------
-- Records of publication_settings
-- ----------------------------
BEGIN;
INSERT INTO `publication_settings` (`publication_setting_id`, `publication_id`, `locale`, `setting_name`, `setting_value`) VALUES (1, 1, '', 'categoryIds', '[]');
INSERT INTO `publication_settings` (`publication_setting_id`, `publication_id`, `locale`, `setting_name`, `setting_value`) VALUES (2, 1, 'en', 'title', 'tes');
INSERT INTO `publication_settings` (`publication_setting_id`, `publication_id`, `locale`, `setting_name`, `setting_value`) VALUES (3, 1, 'en', 'abstract', '<p>tes</p>');
INSERT INTO `publication_settings` (`publication_setting_id`, `publication_id`, `locale`, `setting_name`, `setting_value`) VALUES (4, 2, '', 'categoryIds', '[]');
INSERT INTO `publication_settings` (`publication_setting_id`, `publication_id`, `locale`, `setting_name`, `setting_value`) VALUES (5, 2, 'en', 'title', 'tes2');
INSERT INTO `publication_settings` (`publication_setting_id`, `publication_id`, `locale`, `setting_name`, `setting_value`) VALUES (6, 2, 'en', 'abstract', '<p>tes2</p>');
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Each publication is one version of a submission.';

-- ----------------------------
-- Records of publications
-- ----------------------------
BEGIN;
INSERT INTO `publications` (`publication_id`, `access_status`, `date_published`, `last_modified`, `primary_contact_id`, `section_id`, `seq`, `submission_id`, `status`, `url_path`, `version`, `doi_id`) VALUES (1, 0, NULL, '2024-10-09 08:21:41', 1, 1, 0.00, 1, 1, NULL, 1, NULL);
INSERT INTO `publications` (`publication_id`, `access_status`, `date_published`, `last_modified`, `primary_contact_id`, `section_id`, `seq`, `submission_id`, `status`, `url_path`, `version`, `doi_id`) VALUES (2, 0, NULL, '2024-10-09 08:25:25', 2, 1, 0.00, 2, 1, NULL, 1, NULL);
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
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='The last time each scheduled task was run.';

-- ----------------------------
-- Records of scheduled_tasks
-- ----------------------------
BEGIN;
INSERT INTO `scheduled_tasks` (`scheduled_task_id`, `class_name`, `last_run`) VALUES (1, 'PKP\\task\\ReviewReminder', '2024-10-24 15:44:16');
INSERT INTO `scheduled_tasks` (`scheduled_task_id`, `class_name`, `last_run`) VALUES (2, 'PKP\\task\\StatisticsReport', '2024-10-01 02:53:24');
INSERT INTO `scheduled_tasks` (`scheduled_task_id`, `class_name`, `last_run`) VALUES (3, 'APP\\tasks\\SubscriptionExpiryReminder', '2024-10-01 02:53:24');
INSERT INTO `scheduled_tasks` (`scheduled_task_id`, `class_name`, `last_run`) VALUES (4, 'PKP\\task\\DepositDois', '2024-10-24 15:44:16');
INSERT INTO `scheduled_tasks` (`scheduled_task_id`, `class_name`, `last_run`) VALUES (5, 'PKP\\task\\RemoveUnvalidatedExpiredUsers', '2024-10-01 02:53:24');
INSERT INTO `scheduled_tasks` (`scheduled_task_id`, `class_name`, `last_run`) VALUES (6, 'PKP\\task\\EditorialReminders', '2024-10-01 02:53:24');
INSERT INTO `scheduled_tasks` (`scheduled_task_id`, `class_name`, `last_run`) VALUES (7, 'PKP\\task\\UpdateIPGeoDB', '2024-10-10 00:18:44');
INSERT INTO `scheduled_tasks` (`scheduled_task_id`, `class_name`, `last_run`) VALUES (8, 'APP\\tasks\\UsageStatsLoader', '2024-10-24 15:44:16');
INSERT INTO `scheduled_tasks` (`scheduled_task_id`, `class_name`, `last_run`) VALUES (9, 'PKP\\task\\ProcessQueueJobs', '2024-10-24 15:44:16');
INSERT INTO `scheduled_tasks` (`scheduled_task_id`, `class_name`, `last_run`) VALUES (10, 'PKP\\task\\RemoveFailedJobs', '2024-10-01 02:53:24');
INSERT INTO `scheduled_tasks` (`scheduled_task_id`, `class_name`, `last_run`) VALUES (11, 'APP\\tasks\\OpenAccessNotification', '2024-10-24 15:44:17');
INSERT INTO `scheduled_tasks` (`scheduled_task_id`, `class_name`, `last_run`) VALUES (12, 'APP\\plugins\\importexport\\doaj\\DOAJInfoSender', '2024-10-24 15:44:16');
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
INSERT INTO `section_settings` (`section_setting_id`, `section_id`, `locale`, `setting_name`, `setting_value`) VALUES (1, 1, 'en', 'title', 'Articles');
INSERT INTO `section_settings` (`section_setting_id`, `section_id`, `locale`, `setting_name`, `setting_value`) VALUES (2, 1, 'en', 'abbrev', 'ART');
INSERT INTO `section_settings` (`section_setting_id`, `section_id`, `locale`, `setting_name`, `setting_value`) VALUES (3, 1, 'en', 'policy', 'Section default policy');
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
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('02oh418eq8cfcb995h8ano42ie', 1, '180.244.132.21', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.6.1 Safari/605.1.15', 1724798801, 1724799875, 1, 'csrf|a:2:{s:9:\"timestamp\";i:1724799875;s:5:\"token\";s:32:\"975d87609c0e0b304f7477cfd1094255\";}username|s:6:\"peacee\";userId|i:1;', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('04jjdlsoki491ohdjgd96bglam', NULL, '212.143.94.254', 'Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/111.0.5563.65 Safari/537.36', 1725607188, 1725607188, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('05qsnm9eu99rbgl91eacbge5hh', NULL, '114.122.103.143', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36', 1725002855, 1725002861, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1725002861;s:5:\"token\";s:32:\"7bbca5cbdc86de6df43e3b8e4a9de82f\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('0bf1b7lnb88vdbu2mk2ff6n8mu', NULL, '52.214.85.203', 'Pandalytics/2.0 (https://domainsbot.com/pandalytics/)', 1725462166, 1725462166, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1725462166;s:5:\"token\";s:32:\"81008e60b43d4e7d90ae2c3f0ab63bf9\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('0d9e4aqoun01ubfd6bu1l8rpml', NULL, '168.151.116.249', 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/99.0.4844.47 Mobile/15E148 Safari/604.1', 1727755447, 1727755447, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('0dpc5j4vpn1rdlufq77stue6c3', NULL, '103.23.244.234', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:129.0) Gecko/20100101 Firefox/129.0', 1724717483, 1724717483, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('0fgpmcngtbur0b6ir8c6o9i8ps', NULL, '205.169.39.20', 'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36', 1724662452, 1724662452, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1724662452;s:5:\"token\";s:32:\"d8659905e372ac942f079170eb1ae1aa\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('0l6o5sl3v1devltng0i2p0nvqv', NULL, '95.164.158.211', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/107.0.0.0 Safari/537.36', 1728520508, 1728520508, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('0n98i6au22p7a92efrf5b0b8ri', NULL, '205.169.39.7', 'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36', 1724896782, 1724896782, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('0olinluoiejbm4j4arv77bq54l', NULL, '52.79.250.85', 'CheckMarkNetwork/1.0 (+http://www.checkmarknetwork.com/spider.html)', 1729217070, 1729217070, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('0rf9016dl9l8t7gomtcnld879i', NULL, '44.236.207.248', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/124.0.0.0 Safari/537.36', 1729288424, 1729288425, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('0urhggb965856c03v8jujhki5l', NULL, '3.91.23.249', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/107.0.0.0 Safari/537.36', 1729115501, 1729115501, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('10o85kg9rs1brikh6ao5iabdoq', NULL, '114.122.110.62', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Mobile Safari/537.36', 1729804312, 1729804318, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('11n87qu1u8rl8c5b6afigoas1v', NULL, '223.113.128.211', 'curl/7.29.0', 1729062266, 1729062266, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('16b4sgpi898fnrmet757pib58e', NULL, '205.169.39.25', 'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36', 1724662439, 1724662439, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('1dtf3mgckv65u98uigdv83vm55', NULL, '167.71.19.185', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', 1728612370, 1728612370, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('1f63lk1dtquc5dsj8uc02qksvb', NULL, '35.243.23.34', 'Mozilla/5.0 (Android 13; Mobile; rv:109.0) Gecko/112.0 Firefox/112.0 AppEngine-Google; (+http://code.google.com/appengine; appid: s~virustotalcloud)', 1727751206, 1727751206, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1727751207;s:5:\"token\";s:32:\"36c8235d48a0ef5c3a00800fb400be61\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('1f6ia7k3mb1vkbm3e37gsm84cj', NULL, '205.169.39.25', 'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36', 1724896734, 1724896734, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('1lg4dd2ar1hal9ptd5sua9843d', NULL, '185.156.172.172', 'Mozilla/5.0 (iPhone; CPU iPhone OS 17_2_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.2 Mobile/15E148 Safari/604.1', 1725607212, 1725607212, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('1ll15q7dfkieg3016jem3olegd', NULL, '205.169.39.25', 'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36', 1724662440, 1724662440, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1724662440;s:5:\"token\";s:32:\"b15d6fdf1e4f7c18cb77996b6a55e20e\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('1slq606gi84ce1tkd0s7gq9735', NULL, '165.22.58.169', 'Mozilla/5.0 (X11; Ubuntu; Linux i686; rv:28.0) Gecko/20100101 Firefox/28.0', 1729692261, 1729692261, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('20i1beqs7kqqeurs9aq22tmqj3', NULL, '64.227.167.66', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', 1728676362, 1728676362, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('230sk0eb2nh63hoeecmb24eep6', NULL, '198.245.77.187', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/107.0.0.0 Safari/537.36', 1729115500, 1729115500, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('235cep36nrmugii7u2gmkml7ta', NULL, '103.23.244.234', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36 Edg/128.0.0.0', 1724721500, 1724728190, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1724728184;s:5:\"token\";s:32:\"d85108572a4c7e6c8b129efc5552a453\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('26opmejjpvgvio7ncptss6smkf', NULL, '152.42.252.250', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', 1725680124, 1725680128, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1725680125;s:5:\"token\";s:32:\"efe801e8ea97ecf055d07a04ef981136\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('27dh40pbqjhdl1ah39d7073vpv', NULL, '118.193.46.107', 'Mozilla/5.0 (Linux; Android 11; vivo 1906; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/87.0.4280.141 Mobile Safari/537.36 VivoBrowser/8.9.0.0 uni-app Html5Plus/1.0', 1728676689, 1728676689, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('27jusilvkl7bni9bk1gsr5mbte', NULL, '106.75.66.166', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/586.40 (KHTML, like Gecko) Chrome/79.0.2180 Safari/537.36', 1728896295, 1728896295, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('2at0svo3fel5nv58lg6cqa1adq', NULL, '57.141.5.28', 'meta-externalagent/1.1 (+https://developers.facebook.com/docs/sharing/webmasters/crawler)', 1726956936, 1726956936, 0, 'currentLocale|s:2:\"en\";', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('2bt5rlu2q998nkfdjai3mpgpho', NULL, '119.13.212.80', 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/99.0.4844.47 Mobile/15E148 Safari/604.1', 1728780148, 1728780148, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('2cmji786v36ku253ic3vikg00n', NULL, '52.79.250.85', 'CheckMarkNetwork/1.0 (+http://www.checkmarknetwork.com/spider.html)', 1729217069, 1729217069, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('2kfon8ihdhfpj9ih6rcuj8a3h7', NULL, '168.151.132.203', 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/99.0.4844.47 Mobile/15E148 Safari/604.1', 1727755456, 1727755456, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('2pfjnkld0gt264pmck2hi32290', NULL, '106.161.65.206', 'Mozilla/5.0 (iPhone; CPU iPhone OS 17_3_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.3.1 Mobile/15E148 Safari/604.1', 1725608063, 1725608063, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1725608063;s:5:\"token\";s:32:\"441fe25d33665da0bebb963cfa739f81\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('2pq5n1iilmq3fb4gm0i0l3fdrf', NULL, '52.70.151.67', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/107.0.0.0 Safari/537.36', 1728720283, 1728720283, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('2t2vf4isjh8fu5thrq5qq6r9nv', NULL, '18.221.251.95', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36 Edg/114.0.1823.51', 1727751204, 1727751204, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('2vqbtbp3m4026jesddt1it4oa6', NULL, '69.171.249.113', 'facebookexternalhit/1.1 (+http://www.facebook.com/externalhit_uatext.php)', 1728521112, 1728521112, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('35ugjj8ur77vigkasa3dkdvntc', NULL, '94.102.63.27', 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/45.0.2454.85 Safari/537.36', 1725607265, 1725607266, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1725607266;s:5:\"token\";s:32:\"29c00c7298aca3def5949ab92c3ad654\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('39b4perhotprlhfo6cqnr3blbi', NULL, '95.164.156.71', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/107.0.0.0 Safari/537.36', 1729374747, 1729374747, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('39kqb554ks2up3o4riov2mg3jn', 1, '103.23.244.234', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36', 1724662284, 1724662347, 1, 'csrf|a:2:{s:9:\"timestamp\";i:1724662347;s:5:\"token\";s:32:\"c2e9abf0e14e6a83795dfca6d6886c5c\";}userId|i:1;username|s:6:\"peacee\";', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('3eveg56nap77n85e8pa3eglk6h', NULL, '152.39.247.92', 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/99.0.4844.47 Mobile/15E148 Safari/604.1', 1728520951, 1728520951, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('3fu0epleauje2o8bf2o048brt7', NULL, '205.169.39.44', 'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36', 1724896592, 1724896592, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('3gbm468m1a8md4toj43qkbkjeo', NULL, '180.244.129.29', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36', 1724661647, 1724661648, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('3hrdq4hrii5it9lvnhj0577iq3', NULL, '103.77.234.214', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36', 1725608064, 1725608064, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1725608064;s:5:\"token\";s:32:\"d66af43f0990642f127f8469464d1f2e\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('3ikov3vlap94dh3g4joiqq4sc7', NULL, '173.252.70.3', 'facebookexternalhit/1.1 (+http://www.facebook.com/externalhit_uatext.php)', 1725901854, 1725901854, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('3je63cn4n82ogdt04l2i1t3puf', NULL, '52.79.250.85', 'CheckMarkNetwork/1.0 (+http://www.checkmarknetwork.com/spider.html)', 1729217070, 1729217070, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('3jugf5t9hsahlcujnbmbtg6qcb', NULL, '205.169.39.26', 'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36', 1724896353, 1724896353, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1724896353;s:5:\"token\";s:32:\"626f5a2a819a7c75acc4ebf38c4636dd\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('3m7pvk811a9q905huokrcef5rf', NULL, '103.87.68.59', 'Mozilla/5.0 (iPhone; CPU iPhone OS 17_2_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.2 Mobile/15E148 Safari/604.1', 1725607227, 1725607227, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1725607227;s:5:\"token\";s:32:\"b927d8c8cdd361556f03ca41a0835979\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('3miico23pusq2s68m30puaaeha', NULL, '179.61.240.38', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36', 1725608066, 1725608066, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1725608066;s:5:\"token\";s:32:\"5c6a768e7960c889489f62854ade29c7\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('3sgc13h5t31gmpksb0a7vesai0', NULL, '180.244.128.69', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Mobile Safari/537.36', 1729784656, 1729785553, 0, 'currentLocale|s:2:\"en\";', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('3ues6eq56i6c9m74jfmo19uoav', NULL, '185.204.0.106', 'Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0; MRSPUTNIK 2, 4, 0, 386; MRA 5.6 (build 03399); .NET CLR 1.1.4322; .NET CLR 2.0.50727; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729; msn OptimizedIE8;RURU)', 1728890251, 1728890251, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('4218t6rfiuqd4efi9470uiuoua', NULL, '114.122.83.250', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Mobile Safari/537.36', 1727928620, 1727928763, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1727928621;s:5:\"token\";s:32:\"d1744d1d86f787f69251c4fd289d1e88\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('43s8qgiljb37ap4k6qtmu4o4sb', NULL, '114.122.110.62', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Mobile Safari/537.36', 1729804311, 1729804311, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('455uok9a5aaolm9q6acjbrkngj', NULL, '198.199.86.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, seperti Gecko) Chrome/58.0.3029.110 Safari/537.3', 1724922264, 1724922264, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('467eargj6k32lcu0j7jecnp9t7', NULL, '173.252.83.17', 'facebookexternalhit/1.1 (+http://www.facebook.com/externalhit_uatext.php)', 1726707485, 1726707485, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1726707486;s:5:\"token\";s:32:\"33d8b904ce23b432aeccd2b2ef9c5edf\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('48dbc4ahrgjm3b3l9ab1ffptcj', NULL, '35.243.23.34', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/112.0.0.0 Safari/537.36 AppEngine-Google; (+http://code.google.com/appengine; appid: s~virustotalcloud)', 1727751214, 1727751214, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('4cs0fal7laog8e89eda3ggmqad', NULL, '52.214.85.203', 'Pandalytics/2.0 (https://domainsbot.com/pandalytics/)', 1725462163, 1725462163, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('4dg18uf8d7e5gij7vmv23r352k', NULL, '93.127.186.191', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:40.0) Gecko/20100101 Firefox/40.0', 1726263341, 1726263341, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('4ds32ng7njjsdgvbg97286i21j', NULL, '114.122.70.237', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36', 1725193359, 1725193360, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1725193360;s:5:\"token\";s:32:\"c6d38c22c4799c483eb07ccc1adfc10b\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('4gh3df5bud13n7pulcjjjmba72', NULL, '103.23.244.234', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36 Edg/128.0.0.0', 1725266845, 1725266845, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1725266845;s:5:\"token\";s:32:\"e482c8205d306b331c08cd592746fc8c\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('4grvgs8vodoluljel43meob18c', NULL, '18.237.158.138', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.102 Safari/537.36 Edge/18.19582', 1724841004, 1724841004, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1724841004;s:5:\"token\";s:32:\"753c4558417f963f36bbc53365117aec\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('4h4017dlcek9u59o87pomrrl6q', NULL, '205.169.39.17', 'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36', 1724662292, 1724662292, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1724662292;s:5:\"token\";s:32:\"0e311b8226e57de629c75a5addd3717c\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('4iejm4dscdblld7ukbta8ihn6l', NULL, '193.200.105.12', 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/99.0.4844.47 Mobile/15E148 Safari/604.1', 1728780147, 1728780147, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('4kvofbm1i441ft4qe4ef0u3282', NULL, '103.23.244.234', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:129.0) Gecko/20100101 Firefox/129.0', 1724717483, 1724717483, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('4r5d0tam6mmou1s7ck7lp98s4k', NULL, '134.209.183.43', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', 1727402138, 1727402138, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1727402139;s:5:\"token\";s:32:\"7ece48f39ff194977b6c7203efda15cd\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('4th15fvqe55flkgenntqpr5990', NULL, '205.169.39.32', 'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36', 1724662441, 1724662441, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('519npc0q9he2505r7s47ota6u8', NULL, '180.244.132.173', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.6.1 Safari/605.1.15', 1724749513, 1724749513, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1724749513;s:5:\"token\";s:32:\"5c8b9c7337209455b378aa09555c85e5\";}userId|i:1;username|s:6:\"peacee\";', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('51uvrrbqibjm7lglku9ufe9i99', NULL, '45.81.148.28', 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_1_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.1 Mobile/15E148 Safari/604.1', 1725609681, 1725609682, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1725609681;s:5:\"token\";s:32:\"198baa3bc5c34dffcdf571126b7d9321\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('56r2ad5t99faq6a08fl8fb3t6d', NULL, '45.81.148.126', 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_1_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.1 Mobile/15E148 Safari/604.1', 1725609755, 1725609755, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1725609755;s:5:\"token\";s:32:\"9f23f47ec665f9965d1c85df71ba49ab\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('56uoae30ffijtp2diosfo6gkbb', NULL, '45.114.240.217', 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/99.0.4844.47 Mobile/15E148 Safari/604.1', 1728780149, 1728780149, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('570bf1s3fuq4mpmumubcf20kfj', NULL, '205.169.39.21', 'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36', 1724896717, 1724896717, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1724896717;s:5:\"token\";s:32:\"3240b537f7991be9ddb285b223daab08\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('57vg42ot2iob36iumsv19qodft', NULL, '205.169.39.20', 'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36', 1724721757, 1724721757, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1724721757;s:5:\"token\";s:32:\"1d73f4890ec7936af249a43c5965aa29\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('59n1gm0tmc3aheka0rlnq0khea', NULL, '103.23.244.234', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36 Edg/128.0.0.0', 1724827138, 1724837568, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1724837568;s:5:\"token\";s:32:\"3dc4508506f07d3a943391746ca80061\";}username|s:6:\"peacee\";', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('5a549rie0kmnv7mbbhekbjb7c8', NULL, '205.169.39.26', 'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36', 1728244320, 1728244320, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('5fdlgke90fh2qmegs69ejk259g', NULL, '205.169.39.21', 'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36', 1724662441, 1724662441, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('5k2v6bi7nb0bfb6t46vteqf3o7', NULL, '87.103.246.30', 'Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.1; Trident/5.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; .NET4.0C; .NET4.0E; Tablet PC 2.0; MAXTHON 2.0)', 1729042537, 1729042537, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('5mu82htst1tabgrplruv93fmfl', NULL, '57.141.3.11', 'facebookexternalhit/1.1 (+http://www.facebook.com/externalhit_uatext.php)', 1726163015, 1726163015, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('5o56cm8lvjb3oiqrgotkfas0v2', NULL, '205.169.39.23', 'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36', 1724662342, 1724662342, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1724662342;s:5:\"token\";s:32:\"eece24f759843a16769a033001be36f1\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('5pg9i73asg2q9p01s998vqtm4k', NULL, '95.164.156.25', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/107.0.0.0 Safari/537.36', 1728520509, 1728520509, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('5r0gc01nciae07v62ikr6pluq8', NULL, '103.77.234.214', 'Mozilla/5.0 (iPhone; CPU iPhone OS 17_1_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.1.2 Mobile/15E148 Safari/604.1', 1725608098, 1725608098, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('5rtk5g4oaqob6qdslg6hk92df1', NULL, '128.90.165.221', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36', 1725607226, 1725607226, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1725607226;s:5:\"token\";s:32:\"11ccfe467fb8ffc5461a28f39aa9a4e3\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('60s5kgtijc01m23o6p5fdvfd9e', NULL, '93.159.230.28', 'Mozilla/5.0 (Linux; arm_64; Android 12; CPH2205) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 YaBrowser/23.3.3.86.00 SA/3 Mobile Safari/537.36', 1727752562, 1727752563, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1727752563;s:5:\"token\";s:32:\"80729d1a89b69d15adc1c991d003c31f\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('61t283397ok1ugg42eu281scbg', NULL, '205.169.39.20', 'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36', 1724662345, 1724662345, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('627k09itc4v5s7u9onpfdnp5d8', NULL, '57.141.3.27', 'facebookexternalhit/1.1 (+http://www.facebook.com/externalhit_uatext.php)', 1725901890, 1725901890, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1725901890;s:5:\"token\";s:32:\"c2e7c82e1aca0bfd5f2d11f9a3dc6e6f\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('62a6lqhccf7updn8k8au7rqtvl', NULL, '205.169.39.8', 'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36', 1724896557, 1724896557, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('63kupalqd3lo5u411oksr0ppa3', NULL, '79.98.181.179', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36', 1725607230, 1725607230, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('66rpp2ttnq27mjvthktietmcr3', NULL, '54.78.68.2', 'Mozilla/5.0 (compatible; NetcraftSurveyAgent/1.0; +info@netcraft.com)', 1728331513, 1728331513, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('6bo3cgrlvtl3iempbm8m5tvvd4', NULL, '103.23.244.234', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.36', 1728446832, 1728446832, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1728446832;s:5:\"token\";s:32:\"daed92b485ab268903b80c7b8b04deed\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('6k237ljtb3knab0nu67lu8h0o2', NULL, '205.169.39.13', 'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36', 1724896353, 1724896353, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('6rd0oqm305p5hdgdtpqe6lfc1d', NULL, '54.78.30.199', 'Mozilla/4.0 (compatible; Netcraft Web Server Survey)', 1727721335, 1727721335, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('6sfdcbjhmnatd71id6ts6ldbmi', 1, '103.178.218.145', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36', 1725854812, 1725949352, 1, 'csrf|a:2:{s:9:\"timestamp\";i:1725861411;s:5:\"token\";s:32:\"c2200fb864f5e3baf90a0b484bf4e55c\";}userId|i:1;username|s:6:\"peacee\";', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('6tjohep8ibun0sipe2aq104ds1', NULL, '57.141.3.20', 'facebookexternalhit/1.1 (+http://www.facebook.com/externalhit_uatext.php)', 1726162767, 1726162767, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1726162767;s:5:\"token\";s:32:\"461e31a9f8c0b6ae7be34188c4befb55\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('70cbkti1ii1nfmapub80frnf1a', NULL, '103.171.157.226', 'Mozilla/5.0 (X11; Linux x86_64; rv:83.0) Gecko/20100101 Firefox/83.0', 1729394571, 1729394572, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('70tbs1jgklr0dhaa9vfnfqscse', NULL, '44.203.194.48', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/107.0.0.0 Safari/537.36', 1728607574, 1728607574, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('7241ts6kcntsdg64le0nmo73vd', NULL, '103.23.244.234', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:129.0) Gecko/20100101 Firefox/129.0', 1725510578, 1725510580, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1725510578;s:5:\"token\";s:32:\"8056ec7b3e0ce711fa0a2a9625644359\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('73vvsrds60dqee15t53mp3sjck', NULL, '205.169.39.43', 'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36', 1724827461, 1724827461, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('764cenglt215gtht7ouaetr352', NULL, '18.237.198.15', 'Mozilla/5.0 (Linux; Android 8.0.0; SM-G965U Build/R16NW) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.111 Mobile Safari/537.36', 1724840210, 1724840210, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('7at2qhgiehqfpesn68636f5l0h', NULL, '147.185.132.76', 'Expanse, a Palo Alto Networks company, searches across the global IPv4 space multiple times per day to identify customers&#39; presences on the Internet. If you would like to be excluded from our scans, please send IP addresses/domains to: scaninfo@paloal', 1729572401, 1729572401, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('7bs5ani4mgvtdrksjnkees0hk2', NULL, '43.252.28.165', 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/99.0.4844.47 Mobile/15E148 Safari/604.1', 1728520952, 1728520952, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('7bt7rt53p7b7dka2t4sat26i5s', NULL, '18.221.251.95', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36 Edg/114.0.1823.51', 1727751205, 1727751205, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1727751205;s:5:\"token\";s:32:\"a33da1e6cdcb405911b3308109f6ee43\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('7dqru7pn2k56cbes3enlt298lr', NULL, '205.169.39.47', 'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36', 1724662358, 1724662358, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1724662358;s:5:\"token\";s:32:\"d1535c761a946d310e073e220d2b44e4\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('7f8vtvunfsoqhi4lt7qe771tpc', NULL, '103.23.244.234', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.36', 1728533956, 1728533969, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1728533969;s:5:\"token\";s:32:\"7feea73da5ac93d90a4ae37db98f32b6\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('7jhrj4a43t81pvbmot8h2mq2db', NULL, '205.169.39.4', 'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36', 1724896662, 1724896662, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('7lv3tlf6cdam6am3s80faus9rg', NULL, '103.23.244.234', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.36 Edg/129.0.0.0', 1728367369, 1728367370, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1728367370;s:5:\"token\";s:32:\"9df4ab5c04a20ed270efee91a81bbf74\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('7qt0kr9htffbs6esh5uhqr8cp1', NULL, '168.151.240.170', 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/99.0.4844.47 Mobile/15E148 Safari/604.1', 1729730545, 1729730545, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('7uc7hmibgj5d5ht8i43aj1uedm', NULL, '106.75.101.79', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 8_0_2) AppleWebKit/576.39 (KHTML, like Gecko) Chrome/72.0.363 Safari/537.36', 1729596463, 1729596463, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('80so7gddu531m2ge80q6ukb1fp', NULL, '198.199.86.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, seperti Gecko) Chrome/58.0.3029.110 Safari/537.3', 1724922253, 1724922253, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1724922253;s:5:\"token\";s:32:\"8ae95e9698046faf99f743fa1e33bdc5\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('851bqo1j32l6kad1dj52ruvcjo', NULL, '79.98.181.179', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36', 1725607230, 1725607230, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1725607230;s:5:\"token\";s:32:\"c7d04028d5ca0659837211c327d4aef3\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('85en2v55an51vnb4lh3kskg6jn', NULL, '205.169.39.24', 'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36', 1724896707, 1724896707, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('88vs7j9c3ajgf6330seps09p3m', NULL, '168.151.166.116', 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/99.0.4844.47 Mobile/15E148 Safari/604.1', 1728607552, 1728607552, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('89q135orfp1hmho4ugjr5gcdvn', NULL, '132.145.66.116', 'Mozilla/5.0 (compatible; GrapeshotCrawler/2.0; +http://www.grapeshot.co.uk/crawler.php)', 1727931929, 1727931929, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1727931929;s:5:\"token\";s:32:\"9f4d9eca9afd51bc27bd9cf02aa5a629\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('89rqo1se6mtel4aln0e28h7sqv', NULL, '34.234.11.9', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/107.0.0.0 Safari/537.36', 1728722494, 1728722495, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('8ef0p739r84h9svs0qs7t2j2ia', NULL, '103.23.244.234', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:129.0) Gecko/20100101 Firefox/129.0', 1724662269, 1724662433, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1724662433;s:5:\"token\";s:32:\"36a8116e2ff93a5b61900c12d25a9478\";}username|s:6:\"peacee\";', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('8ep5bvu3icn3kver9g4hnjgqad', NULL, '44.211.247.151', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/107.0.0.0 Safari/537.36', 1728520510, 1728520510, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('8ghul45u0205mmjhaivlnvnnck', NULL, '44.212.57.230', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/107.0.0.0 Safari/537.36', 1729115502, 1729115502, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('8go25vp5v0dpgo850q90svn745', NULL, '165.231.141.142', 'Mozilla/5.0 (iPhone; CPU iPhone OS 17_5_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.5 Mobile/15E148 Safari/604.1', 1725607359, 1725607359, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('8h46qdt7uu07gkicojdeopemms', NULL, '80.82.70.198', 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/45.0.2454.85 Safari/537.36', 1725607188, 1725607189, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1725607188;s:5:\"token\";s:32:\"8aaaad99ef706f4ff07ae2fdd84606d7\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('8ia572pq4efvjaq9aad09b8m7c', NULL, '173.252.83.41', 'facebookexternalhit/1.1 (+http://www.facebook.com/externalhit_uatext.php)', 1726343366, 1726343366, 0, 'currentLocale|s:2:\"en\";', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('8m34hslhbf8vt0bg353bk4bs58', NULL, '205.169.39.140', 'Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.61 Safari/537.36', 1727754819, 1727754820, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1727754820;s:5:\"token\";s:32:\"c9e4f821501dfcc15f60cb450615d6f3\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('8olcjt7prn1dmj5ajq4rpm1v62', NULL, '154.194.20.53', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36', 1725607245, 1725607246, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1725607245;s:5:\"token\";s:32:\"bd2c6665691008afbc1b22d3d721c2a0\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('8pfpcgp5jv7n83rpbdf3jnuo77', NULL, '103.57.36.228', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_1) AppleWebKit/601.2.4 (KHTML, like Gecko) Version/9.0.1 Safari/601.2.4 facebookexternalhit/1.1 Facebot Twitterbot/1.0', 1727959970, 1727959970, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1727959970;s:5:\"token\";s:32:\"410e818feceadde586a0ca8ee807456f\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('8uemal8puf7c4l5vgj0chi3ob5', NULL, '100.26.206.67', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/107.0.0.0 Safari/537.36', 1728722494, 1728722494, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('91pcf7vrcuhe7fn1i0769bps1v', NULL, '205.169.39.20', 'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36', 1724896683, 1724896683, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('92s7nqd7qt80naacj651sddm51', NULL, '45.139.64.103', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/107.0.0.0 Safari/537.36', 1728607570, 1728607570, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('92udtndga4rednv8stqg1ap91l', NULL, '180.244.139.131', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Mobile Safari/537.36', 1724675280, 1724675554, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('93vvnuv4deb14dir80n83ctl2k', NULL, '168.151.131.209', 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/99.0.4844.47 Mobile/15E148 Safari/604.1', 1727755456, 1727755456, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1727755457;s:5:\"token\";s:32:\"f61d9c2eb504c43172cf5f181965d9e7\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('97vfpotveejos0krqpisrip3uu', NULL, '205.169.39.7', 'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36', 1724896701, 1724896701, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('9a0qlkk18g65lfokr0j718m8e9', NULL, '18.237.198.15', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.102 Safari/537.36 Edge/18.19582', 1724840210, 1724840210, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('9b0qf07ijccsknlom1slmknd7q', NULL, '69.171.249.41', 'facebookexternalhit/1.1 (+http://www.facebook.com/externalhit_uatext.php)', 1726161187, 1726161187, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('9ct3t3gvfmgvsscq98gtvsas1g', NULL, '152.39.133.67', 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/99.0.4844.47 Mobile/15E148 Safari/604.1', 1729730545, 1729730545, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('9cv45v26n1p0e1qececg57truq', NULL, '114.122.83.250', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Mobile Safari/537.36', 1727928619, 1727928619, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('9e9u9dq1tmtu442oht2fhm05af', NULL, '38.154.186.13', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/107.0.0.0 Safari/537.36', 1728722493, 1728722493, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('9ep1r56vk04um39sk835be83s8', NULL, '152.39.231.23', 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/99.0.4844.47 Mobile/15E148 Safari/604.1', 1727755447, 1727755447, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1727755448;s:5:\"token\";s:32:\"c67f3671c2794cb519741aa27fe478cd\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('9l11mjc9hdrs19qcicrifddke0', NULL, '57.141.3.26', 'facebookexternalhit/1.1 (+http://www.facebook.com/externalhit_uatext.php)', 1726161314, 1726161314, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1726161314;s:5:\"token\";s:32:\"23c8c60f329d780cb1351ad6d2e6e159\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('9mfm10lj35tdg4lpog3ngetq7s', NULL, '180.244.132.233', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.6.1 Safari/605.1.15', 1724798161, 1724798194, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1724798194;s:5:\"token\";s:32:\"975d87609c0e0b304f7477cfd1094255\";}username|s:6:\"peacee\";', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('9vaduh75c3sm2tt1o4h96rtgcq', NULL, '205.169.39.50', 'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36', 1728723535, 1728723535, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('9vbuda0lgrgk3pu8fjv90gacg4', NULL, '165.231.141.142', 'Mozilla/5.0 (iPhone; CPU iPhone OS 17_2_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.2 Mobile/15E148 Safari/604.1', 1725607213, 1725607213, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('a5p0fa9tdf51slsp3llcu0b4qm', NULL, '45.80.210.92', 'Mozilla/5.0 (iPhone; CPU iPhone OS 17_5_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.5 Mobile/15E148 Safari/604.1', 1725607492, 1725607493, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1725607492;s:5:\"token\";s:32:\"a247cf433bed68a53ccae7d58544fa9d\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('a7sl3kua68b7ks0jog6lro8mve', NULL, '54.74.142.1', 'Pandalytics/2.0 (https://domainsbot.com/pandalytics/)', 1727800055, 1727800055, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1727800055;s:5:\"token\";s:32:\"5c4a573b2f3deeef17b2d30324bdc7b0\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('a9665bgvivthu3aspu06ki6cl1', NULL, '40.80.158.10', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.6422.114 Safari/537.36', 1725631113, 1725631114, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1725631113;s:5:\"token\";s:32:\"b161c576d16245d8eef7f63ef4a7078f\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('abcvtt47fqrao7n62ngchkjnrq', NULL, '103.57.36.228', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:130.0) Gecko/20100101 Firefox/130.0', 1726455756, 1726455756, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('af77b2hka6ips4ik5fo40cuuko', NULL, '205.169.39.20', 'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36', 1724662345, 1724662345, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('afdj86kk00fdhu5pe610fjgmfl', NULL, '223.113.128.211', 'curl/7.29.0', 1728868660, 1728868660, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('agqrk0k7eqe8be0ach9rbfsqi1', NULL, '80.82.70.198', 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/45.0.2454.85 Safari/537.36', 1725607267, 1725607267, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1725607266;s:5:\"token\";s:32:\"29c00c7298aca3def5949ab92c3ad654\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('ah64m6lldohsupkkesir1j4sr2', NULL, '173.252.107.112', 'facebookexternalhit/1.1 (+http://www.facebook.com/externalhit_uatext.php)', 1726344006, 1726344006, 0, 'currentLocale|s:2:\"en\";', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('aj4ugpu50cf301j47gj9d9npnp', NULL, '80.255.7.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.6613.18 Safari/537.36', 1725607119, 1725607123, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1725607122;s:5:\"token\";s:32:\"cb21a2c7c39ba3a1dfe4b95fd076739e\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('ak783kuiga0fjq0mv6619icrnb', NULL, '205.169.39.21', 'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36', 1724662403, 1724662403, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('akp6h1vl3paj0ln7gedqcuhduj', NULL, '173.252.107.114', 'facebookexternalhit/1.1 (+http://www.facebook.com/externalhit_uatext.php)', 1726341043, 1726341043, 0, 'currentLocale|s:2:\"en\";', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('am0npjaq78kmrhg2rg7trjerfh', NULL, '173.252.107.2', 'facebookexternalhit/1.1 (+http://www.facebook.com/externalhit_uatext.php)', 1726341012, 1726341012, 0, 'currentLocale|s:2:\"en\";', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('amv7n0ftjdktq4vb5vs2r6mnvj', NULL, '173.252.83.5', 'facebookexternalhit/1.1 (+http://www.facebook.com/externalhit_uatext.php)', 1726957882, 1726957882, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1726957882;s:5:\"token\";s:32:\"b8e6fa88c26ffba197e553d75636cd0e\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('anns1atm87l4l9ifgpliks2jcf', NULL, '208.70.244.23', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:79.0) Gecko/20100101 Firefox/79.0', 1724817618, 1724817618, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('aq98mfnejqlf2d9t78b5gti7g4', NULL, '141.11.89.158', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.129 Safari/537.36', 1726103454, 1726103454, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('atcu43jqin3fcu9u0q7nkibpth', NULL, '69.171.230.27', 'meta-externalagent/1.1 (+https://developers.facebook.com/docs/sharing/webmasters/crawler)', 1726342777, 1726342777, 0, 'currentLocale|s:2:\"en\";', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('b34dq4rmtmvomck47f6m2m9sde', NULL, '44.212.57.230', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/107.0.0.0 Safari/537.36', 1728720284, 1728720284, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('baag5ssphikbdbt6p03cbnor4a', NULL, '111.7.100.25', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/92.0.4515.107 Safari/537.36', 1728931471, 1728931471, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('baf7oh6v2ddnqmj9rh20jps9r4', NULL, '205.169.39.13', 'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36', 1724896355, 1724896355, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1724896355;s:5:\"token\";s:32:\"8cfab20207c67e228a4392ded6cf0c1b\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('bgl9i2gr9umt7s7611osk0usvt', NULL, '205.169.39.19', 'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36', 1724827236, 1724827236, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1724827236;s:5:\"token\";s:32:\"263d31ee4ef92d7905ae9a434791442d\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('bitnkrp18qg9929ohbh5ol09pp', NULL, '173.252.69.1', 'facebookexternalhit/1.1 (+http://www.facebook.com/externalhit_uatext.php)', 1726162520, 1726162520, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('bkjjm4vm8ourhmvs1utpk7c48u', NULL, '34.71.214.216', 'Mozilla/5.0 (X11; Ubuntu; Linux i686 on x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/53.0.2820.59 Safari/537.36', 1727751225, 1727751227, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1727751225;s:5:\"token\";s:32:\"9f05266c4882ef7b66304f3b9a9dc715\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('bsr343pj72sn3eii35bmdjfme2', NULL, '132.145.64.33', 'Mozilla/5.0 (compatible; GrapeshotCrawler/2.0; +http://www.grapeshot.co.uk/crawler.php)', 1727933147, 1727933147, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('btjuj4u5807klufo08i76nt5kq', NULL, '103.23.244.234', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:129.0) Gecko/20100101 Firefox/129.0', 1724896701, 1724922730, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1724922730;s:5:\"token\";s:32:\"0fc58662209a36832d7cccc3d79333dc\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('c0u9a41dr5eivqd0gc9iuqkvje', NULL, '45.81.148.126', 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_1_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.1 Mobile/15E148 Safari/604.1', 1725609842, 1725609843, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1725609842;s:5:\"token\";s:32:\"1befb3963afd3ca988d08992a86e2533\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('c45fpqtojnbr82fk504mv12jn9', NULL, '104.164.15.21', 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/99.0.4844.47 Mobile/15E148 Safari/604.1', 1728520951, 1728520951, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('c5e7qofc38agiv2jckabaej570', NULL, '106.75.66.166', 'Mozilla/5.0 (Windows NT 7_0_2; Win64; x64) AppleWebKit/575.44 (KHTML, like Gecko) Chrome/73.0.2329 Safari/537.36', 1728896281, 1728896281, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('caa1r28nnuu614pf2s1df18806', NULL, '209.127.108.177', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/107.0.0.0 Safari/537.36', 1728722492, 1728722492, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('cb7jt78bv4mqpvcllplail413n', 1, '180.244.139.109', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.6.1 Safari/605.1.15', 1724718897, 1724718908, 1, 'csrf|a:2:{s:9:\"timestamp\";i:1724718908;s:5:\"token\";s:32:\"d55126c477bcea6223f6e50555ddc2bd\";}userId|i:1;username|s:6:\"peacee\";', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('cflsu4aqk8eajj38ferfvh8kl1', NULL, '87.103.246.30', 'Mozilla/5.0 (compatible; AhrefsBot/2.0; +http://ahrefs.com/robot/),gzip(gfe) (via docs.google.com/viewer)', 1729042536, 1729042536, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('cki5dgcg7jl2jktcph109fk4cf', NULL, '93.159.230.28', 'Mozilla/5.0 (Linux; arm_64; Android 12; CPH2205) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 YaBrowser/23.3.3.86.00 SA/3 Mobile Safari/537.36', 1728947470, 1728947470, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('cl1visrgot2l0sj9oq90bjefjd', NULL, '95.164.100.189', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36', 1728540309, 1728540309, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('cqkda4sjrus9749dtkl1pq6nk6', NULL, '205.169.39.11', 'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36', 1724728900, 1724728900, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1724728900;s:5:\"token\";s:32:\"0b00ee7534c2b2861db9fcfd14514b3b\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('cudpjvur7a1k3btf9kte8jvdi6', NULL, '167.71.19.185', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', 1728612370, 1728612370, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('cvn1lreqmjprj9apiup9ltpb1q', NULL, '3.82.122.124', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/85.0.4183.102 Safari/537.36', 1725607221, 1725607221, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1725607221;s:5:\"token\";s:32:\"b62bdaaae0f117cef79e1cf3dda801de\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('cvrc38vpi92bc8rdcd0v61ar6d', NULL, '54.78.68.2', 'Mozilla/5.0 (compatible; NetcraftSurveyAgent/1.0; +info@netcraft.com)', 1728331515, 1728331515, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1728331515;s:5:\"token\";s:32:\"90e94f1d6a3fbde774c2f14b2063fee2\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('d1fuejpc25it7443mc5607r4so', NULL, '205.169.39.7', 'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36', 1724896702, 1724896702, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1724896702;s:5:\"token\";s:32:\"243633adab250b2c4133e9fd57050238\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('d30r3ds44jdbj6n1ijqu4dkttl', NULL, '159.89.201.220', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.69 Safari/537.36', 1725983934, 1725983935, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('d4epv7rpsmdgthpjmlhr50rke1', NULL, '35.243.23.35', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/112.0.0.0 Safari/537.36 AppEngine-Google; (+http://code.google.com/appengine; appid: s~virustotalcloud)', 1727751214, 1727751214, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1727751214;s:5:\"token\";s:32:\"4ecf1b1f406638a1710f44dded1a20ca\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('d7haa8dap8gkvcji2s9da7diq6', NULL, '138.122.193.58', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/107.0.0.0 Safari/537.36', 1728720281, 1728720281, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('d7o8h3sbsg5k9i4gr5umjkhkoe', NULL, '114.122.105.21', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Mobile Safari/537.36', 1724848881, 1724848881, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('d9l14d9m7d3n7dpr0sbg6gdf57', NULL, '52.55.253.144', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.6533.99 Safari/537.36', 1727758764, 1727758765, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1727758764;s:5:\"token\";s:32:\"0bdab8bae553a2887348d9e5db71be57\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('dd54nv49dudeqf1jdgklnapgef', NULL, '205.169.39.23', 'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36', 1724662341, 1724662341, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('ddgeafa5rm2rjbn75a9sebdkd9', NULL, '103.108.94.167', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36 Edg/120.0.0.0', 1725608065, 1725608065, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('de5ujdfsm36nbqtnsj0cqnskel', NULL, '69.171.249.57', 'facebookexternalhit/1.1 (+http://www.facebook.com/externalhit_uatext.php)', 1726708998, 1726708998, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('dev106rih6bk9gr9jqf1ntvaqu', NULL, '152.42.252.250', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', 1725680124, 1725680127, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1725680125;s:5:\"token\";s:32:\"1c15ddff456c8f9c9499043af484e2a7\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('dji7h6strbtgjq18luv0la4eii', NULL, '132.145.67.248', 'Mozilla/5.0 (compatible; GrapeshotCrawler/2.0; +http://www.grapeshot.co.uk/crawler.php)', 1724849719, 1724849719, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1724849719;s:5:\"token\";s:32:\"b025f4cb0167d32706cedc552deeee8d\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('dl21vt2lhqkba4aij4mf33480j', NULL, '209.127.106.154', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/107.0.0.0 Safari/537.36', 1729374748, 1729374748, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('dlsd7qbecjmak69ihj0m64qpr0', NULL, '167.71.231.158', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', 1725015641, 1725015641, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('dn0kl8f0i3kk2dt8gcej7p4akq', NULL, '165.22.58.169', 'Mozilla/5.0 (X11; Ubuntu; Linux i686; rv:28.0) Gecko/20100101 Firefox/28.0', 1729487180, 1729487180, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('dqrmu5u8po61ep9eb16a270mu8', NULL, '212.143.94.254', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/122.0.0.0 Safari/537.36', 1725607190, 1725607190, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1725607190;s:5:\"token\";s:32:\"e4784ddc3bef6cb57241c5754a7ae82d\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('e1eu3fu2psiohc53nqipp8mtg6', NULL, '103.23.244.234', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:129.0) Gecko/20100101 Firefox/129.0', 1725510876, 1725510876, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1725510876;s:5:\"token\";s:32:\"03d867b51dc1594398a1bcb674e47532\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('e4p82683k5e3nkuailu5t85bc1', NULL, '91.92.217.156', 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/99.0.4844.47 Mobile/15E148 Safari/604.1', 1728607553, 1728607553, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('e5eckslss3ka9huoacf93nn34j', NULL, '165.22.58.169', 'Mozilla/5.0 (X11; Ubuntu; Linux i686; rv:28.0) Gecko/20100101 Firefox/28.0', 1729692258, 1729692259, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('e5n097esid47lpssn7jo386mp0', NULL, '167.71.239.146', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4240.193 Safari/537.36', 1728857537, 1728857541, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('e6nkslu41bf7n9e6adgvnsgqbs', NULL, '35.243.23.33', 'Mozilla/5.0 (Android 13; Mobile; rv:109.0) Gecko/112.0 Firefox/112.0 AppEngine-Google; (+http://code.google.com/appengine; appid: s~virustotalcloud)', 1727751204, 1727751204, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('e8h12ajnata2ckdl8tkeae3p89', NULL, '119.12.183.80', 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/99.0.4844.47 Mobile/15E148 Safari/604.1', 1727755458, 1727755458, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1727755457;s:5:\"token\";s:32:\"f61d9c2eb504c43172cf5f181965d9e7\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('eaacafn8m3d3gg2404ekuin24r', NULL, '69.171.249.24', 'meta-externalagent/1.1 (+https://developers.facebook.com/docs/sharing/webmasters/crawler)', 1726342947, 1726342947, 0, 'currentLocale|s:2:\"en\";', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('eca7s5ud8e7n1a3a02grcqbl4t', NULL, '173.252.70.4', 'facebookexternalhit/1.1 (+http://www.facebook.com/externalhit_uatext.php)', 1726161628, 1726161628, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('edhfmalbbhu20sj75u527amm1f', NULL, '18.237.198.15', 'Mozilla/5.0 (Linux; Android 8.0.0; SM-G965U Build/R16NW) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.111 Mobile Safari/537.36', 1724840210, 1724840210, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1724840210;s:5:\"token\";s:32:\"b6c7a19d9f3bc01889e2f646d72aad36\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('eeim6l8r5cmapltiaq1psp6lm6', NULL, '79.98.181.251', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36', 1725607230, 1725607230, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1725607230;s:5:\"token\";s:32:\"ae552fff93a8332612fa1d4634342c1f\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('ef031iipkg9li5e9fh3l71nf7p', NULL, '18.237.198.15', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.102 Safari/537.36 Edge/18.19582', 1724840210, 1724840210, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1724840210;s:5:\"token\";s:32:\"39c0c0d662e44959707dbaa35ffe032a\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('eg3hfv7d6fjg2rt9tia24mpsbl', NULL, '159.65.79.118', 'Mozilla/5.0 (Windows NT 10.0; WOW64; rv:82.0) Gecko/20100101 Firefox/82.0', 1725694667, 1725694667, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1725694667;s:5:\"token\";s:32:\"fd82cf7ce54c264d4d845cc4714bcd1b\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('egm51hgcv7vs6moe3q517hsd7o', NULL, '180.244.129.72', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Mobile Safari/537.36', 1728232533, 1728232534, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1728232534;s:5:\"token\";s:32:\"46d02de9eca972edec692669aa58af7f\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('eoopnkrl1a0c603rm4p1qb64is', NULL, '205.169.39.19', 'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36', 1724748449, 1724748449, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1724748449;s:5:\"token\";s:32:\"29c2c2fb2bc9255de8354859afed1615\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('ep3molk6ffhh5lmnqq2tmhhto5', NULL, '69.171.230.3', 'meta-externalagent/1.1 (+https://developers.facebook.com/docs/sharing/webmasters/crawler)', 1726341641, 1726341641, 0, 'currentLocale|s:2:\"en\";', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('f0hbblnnp073nj170bp0rotunu', NULL, '188.241.177.182', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/84.0.4147.89 Safari/537.36', 1725664721, 1725664721, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1725664722;s:5:\"token\";s:32:\"e1dae81bbc845f0121078f824660859d\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('f1826ftlki3o2s6tg1ukb4o9am', NULL, '103.4.19.25', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.135 Safari/537.36 Edge/12.246', 1725607857, 1725607857, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1725607857;s:5:\"token\";s:32:\"a9743ffe8b68f62926bf6a0a3925e4cf\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('f38psc8lan5gps6qmni1ji95tm', NULL, '205.169.39.7', 'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36', 1724896415, 1724896415, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1724896415;s:5:\"token\";s:32:\"da0a9c0689866c783ce35334b5ed122f\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('f3f6csbbnqo0blvmffcas0hm7j', NULL, '180.244.139.65', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Mobile Safari/537.36', 1729511733, 1729511772, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('f7g431rqjc7klb0a4987b5trv1', NULL, '3.15.185.6', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36 Edg/114.0.1823.51', 1727751205, 1727751205, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1727751205;s:5:\"token\";s:32:\"36ef2b02a63581189eb7257a9a1b68f9\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('f7pb2ndf1d7k4t6rt7fb8gf2bg', NULL, '18.237.158.138', 'Mozilla/5.0 (Linux; Android 8.0.0; SM-G965U Build/R16NW) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.111 Mobile Safari/537.36', 1724841010, 1724841011, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1724841010;s:5:\"token\";s:32:\"d43e7184b915eb97d23f78b41c03c474\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('f89n0o94iv98s00agefda9k3j3', NULL, '114.122.103.139', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.36', 1728462899, 1728462957, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('f91t0n1spunvb26k1h8eeo6rf5', 1, '180.244.133.27', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36', 1724672479, 1724673145, 1, 'csrf|a:2:{s:9:\"timestamp\";i:1724673146;s:5:\"token\";s:32:\"1e377ade10ff24c944fd44ef4413fa6d\";}userId|i:1;username|s:6:\"peacee\";', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('f9ol1hjjdh0leqde21decv6fi3', NULL, '57.141.3.21', 'facebookexternalhit/1.1 (+http://www.facebook.com/externalhit_uatext.php)', 1726710340, 1726710340, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1726710340;s:5:\"token\";s:32:\"9079b044307c0c6e6c470048a0e0bed3\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('fc6u4fcl6nrrdcm120545s7umd', NULL, '205.169.39.32', 'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36', 1724662441, 1724662441, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1724662441;s:5:\"token\";s:32:\"6cea34ef4f994d7484d69685138704f7\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('fd4vp4n4v4p6bdprd4075j8vve', NULL, '205.169.39.24', 'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36', 1724662403, 1724662403, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('ffa1601s4irvll3apibo74d4m1', NULL, '57.141.3.14', 'facebookexternalhit/1.1 (+http://www.facebook.com/externalhit_uatext.php)', 1726343254, 1726343254, 0, 'currentLocale|s:2:\"en\";', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('ffs07a1b3pa1nqc45icbjorrgq', NULL, '114.122.103.219', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Mobile Safari/537.36', 1724667859, 1724667859, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1724667859;s:5:\"token\";s:32:\"945685b3a6d709cc923b317c15720f68\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('fieqo716butjhnvpbll8hrss6c', NULL, '93.127.186.191', 'Mozilla/5.0 (Linux; Android 9; Pixel XL) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/76.0.3809.111 Mobile Safari/537.36', 1726409006, 1726409006, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('fn8ujk11i3pq26sfhgtustic7b', NULL, '205.210.31.9', '', 1729388589, 1729388589, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('fpvu045fssl46secoqpbh9sdkb', NULL, '180.244.129.72', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Mobile Safari/537.36', 1728313968, 1728313968, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1728313969;s:5:\"token\";s:32:\"aa0aac58866692569b39dd933826cf30\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('fqi0gt4v4f3r6la37be4dq86gr', NULL, '106.75.101.79', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 9_2_2) AppleWebKit/599.40 (KHTML, like Gecko) Chrome/98.0.2127 Safari/537.36', 1729596484, 1729596484, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('frj3dv2mp671ihq9umub083ngg', NULL, '180.244.132.36', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Mobile Safari/537.36', 1725631894, 1725631894, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1725631895;s:5:\"token\";s:32:\"370edd417bb04c75f2ccb74cf88be705\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('g3udbc2bkraj4t80o83mppq58f', NULL, '205.169.39.140', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.79 Safari/537.36', 1727754829, 1727754830, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1727754830;s:5:\"token\";s:32:\"9051f9b3844ccfb9320e233a549844ac\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('g50ttnp3i543o3svm0m1650jq2', NULL, '93.115.5.169', 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/99.0.4844.47 Mobile/15E148 Safari/604.1', 1728520952, 1728520952, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('g5itos64a7ejrt1a7i9cvgivo8', NULL, '206.189.132.117', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', 1728498013, 1728498013, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('g9lqtnoto3k62lpbqq95uc6410', NULL, '38.108.182.77', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36', 1725607252, 1725607253, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1725607252;s:5:\"token\";s:32:\"ffb9aefe3161f1f896c7d50593c9d8f1\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('garsk4oukb3p6c2auim83u45a9', NULL, '103.57.38.20', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.36', 1729398825, 1729401681, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1729401681;s:5:\"token\";s:32:\"15a125d438258161607aaf8fb7353f84\";}username|s:6:\"peacee\";', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('gbcj9hsglhk5hm4023ur5iuag4', NULL, '165.231.141.142', 'Mozilla/5.0 (iPhone; CPU iPhone OS 17_5_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.5 Mobile/15E148 Safari/604.1', 1725607336, 1725607336, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('gc0r0fdlv4iumclh1cc1asfnmf', NULL, '205.169.39.7', 'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36', 1724662274, 1724662274, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('gf22iel0envanne7u4orjvigj5', NULL, '173.252.83.57', 'facebookexternalhit/1.1 (+http://www.facebook.com/externalhit_uatext.php)', 1726708728, 1726708728, 0, 'currentLocale|s:2:\"en\";', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('gfo81460ubk52fmhdiep34u3v8', NULL, '34.203.236.164', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/107.0.0.0 Safari/537.36', 1728607573, 1728607573, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('gjvop8mh8n6im800frrc0cl84f', NULL, '110.50.81.197', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36', 1728462282, 1728462284, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1728462283;s:5:\"token\";s:32:\"51f3a1452130d5d936365ea2cc9886ea\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('gm0ejt34hjgg25f336rqt2aiu4', NULL, '66.220.149.61', 'facebookexternalhit/1.1 (+http://www.facebook.com/externalhit_uatext.php)', 1726227747, 1726227747, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('grs0h4hp7rgo2jncthvnnjtfpp', NULL, '205.169.39.26', 'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36', 1724896353, 1724896353, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('gs68kk6iitq6p4f56mdts7tvj0', NULL, '173.252.107.112', 'facebookexternalhit/1.1 (+http://www.facebook.com/externalhit_uatext.php)', 1726162988, 1726162988, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1726162988;s:5:\"token\";s:32:\"6588dff6ecbb8fe94f9a2d63d4e08259\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('gsr68iat6ih9r9onrg0psjr8gk', NULL, '205.169.39.26', 'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36', 1724903283, 1724903283, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('gssud390d0lq7kvbq4uf6mmtsk', 1, '202.43.94.33', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.36', 1728446814, 1728521836, 1, 'csrf|a:2:{s:9:\"timestamp\";i:1728521837;s:5:\"token\";s:32:\"e62c7b3c104106a206e3f1ffd63c2a49\";}userId|i:1;username|s:6:\"peacee\";', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('h0bl64bs03vjekg4a0eq9svmea', 1, '180.244.139.111', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.6.1 Safari/605.1.15', 1724719687, 1724720177, 1, 'csrf|a:2:{s:9:\"timestamp\";i:1724720177;s:5:\"token\";s:32:\"d55126c477bcea6223f6e50555ddc2bd\";}userId|i:1;username|s:6:\"peacee\";', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('h1c6nhmr367bt0ol97g6c504o2', NULL, '57.141.3.19', 'facebookexternalhit/1.1 (+http://www.facebook.com/externalhit_uatext.php)', 1726161853, 1726161853, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1726161854;s:5:\"token\";s:32:\"6aedc4dddc49f96406a64c54c8aae25b\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('h1fj2jd38c85chbi4vftic2sah', NULL, '66.56.90.146', 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/99.0.4844.47 Mobile/15E148 Safari/604.1', 1728780139, 1728780139, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('h43opkilnpa1r0n6p42tt0rb39', NULL, '114.122.70.237', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36', 1725193342, 1725193342, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('h4kp0ul4tsaa2j5ao4k978i8nd', NULL, '205.169.39.45', 'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36', 1724662410, 1724662410, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('h6tbngrpht95vmhjs7mpnkes84', NULL, '3.15.185.6', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36 Edg/114.0.1823.51', 1727751204, 1727751204, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('hg9ilsmh22gs41pa7pdhvbtc2t', NULL, '64.227.167.66', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', 1728676360, 1728676360, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('hin4fs0tjrogib2a8hq2eijlgb', NULL, '117.132.188.205', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/107.0.0.0 Safari/537.36', 1729180375, 1729180375, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('hjbvlcvjfhnp2b8i7c1itdlov1', NULL, '180.244.128.69', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Mobile Safari/537.36', 1729785572, 1729787285, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('hlpmu6hpjd5tk29ovcpmsr0s75', NULL, '103.23.244.234', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:129.0) Gecko/20100101 Firefox/129.0', 1724827312, 1724837048, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1724837048;s:5:\"token\";s:32:\"5e773d2693eb17f6fed3e35d45d40996\";}username|s:6:\"peacee\";', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('hmrvo5nhvqnm3r3javqjlca6d3', NULL, '45.80.210.92', 'Mozilla/5.0 (iPhone; CPU iPhone OS 17_5_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.5 Mobile/15E148 Safari/604.1', 1725607224, 1725607224, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1725607224;s:5:\"token\";s:32:\"a791fdf21f1076b0be50a7bf67aaba05\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('hrqn2cfe3tcikhe4ce5mufk2ku', NULL, '103.23.244.234', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:129.0) Gecko/20100101 Firefox/129.0', 1725510876, 1725510876, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('hvkv9b0j5fru4evmsu6q4gun1u', NULL, '103.57.39.154', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.36', 1728784436, 1728784436, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('i2j2nanpdv9c65qp92ma1eno59', NULL, '38.154.214.182', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/107.0.0.0 Safari/537.36', 1728527969, 1728527969, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('ic66ul827prhtukhr5lg8rakrb', NULL, '203.209.219.44', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/109.0.5414.46 Safari/537.36', 1725607985, 1725607985, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1725607985;s:5:\"token\";s:32:\"7baddb5b4dbc9d250bc75e5fc0969d59\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('if56ge6ag9cqk5o7u2qrbcbpjp', NULL, '185.161.203.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/97.0.4692.71 Safari/537.36', 1728530384, 1728530385, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('ihnmqs6thc7c9t6ulehjnka8vr', NULL, '173.252.83.7', 'facebookexternalhit/1.1 (+http://www.facebook.com/externalhit_uatext.php)', 1726708064, 1726708064, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1726708064;s:5:\"token\";s:32:\"8be40f99b76da52c4d6b0fe2d13dbbb2\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('iiset9f6q6qa9va6i2f9b8o21l', NULL, '103.23.244.234', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Mobile Safari/537.36', 1727931325, 1727931656, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1727931656;s:5:\"token\";s:32:\"d1744d1d86f787f69251c4fd289d1e88\";}currentLocale|s:2:\"en\";', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('imfpond3prbpm7qmuds44cev1t', NULL, '205.169.39.8', 'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36', 1724662345, 1724662345, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('ip9f1olp7ptatqob5ckvcrl503', NULL, '114.122.76.107', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Mobile Safari/537.36', 1724661768, 1724661776, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1724661777;s:5:\"token\";s:32:\"d156c98792f9d3657a099d7b1ae1e7b8\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('iusn0s61i0uipu0v784l31jlir', NULL, '103.178.218.145', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36', 1725854812, 1725854812, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('j0m1r1rvja51u3a3iei87h9bol', NULL, '205.210.31.9', '', 1729388589, 1729388589, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('j2rnc1mr3ac72dua0uqaijlte9', 3, '180.244.133.27', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36', 1724672764, 1724673053, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1724673053;s:5:\"token\";s:32:\"0c8e456efccebb6cdce25f7ca4fabc88\";}username|s:5:\"deasy\";userId|i:3;', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('j583jdijikrimjmd0fi5s4q4ud', NULL, '205.169.39.21', 'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36', 1724662441, 1724662441, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1724662441;s:5:\"token\";s:32:\"36af89ab607ca4a7d6c07f9c3e6195e5\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('j99q5soqgmp5vnljfniu800bql', NULL, '103.77.234.219', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36', 1725608399, 1725608401, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1725608399;s:5:\"token\";s:32:\"82b87ab1699743a35f999a21c66fdc91\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('jadjl3sia6mpb7l1eajafhkttr', NULL, '69.171.249.24', 'facebookexternalhit/1.1 (+http://www.facebook.com/externalhit_uatext.php)', 1726162040, 1726162040, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1726162040;s:5:\"token\";s:32:\"107620c1d4ad37124d774594c3871501\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('jc29q40pvote0g8cfbj5evocik', NULL, '205.169.39.23', 'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36', 1724728777, 1724728777, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('jg6nv8maqg1atvoo7etu504242', NULL, '103.108.92.87', 'Mozilla/5.0 (iPhone; CPU iPhone OS 17_5_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.5 Mobile/15E148 Safari/604.1', 1725608064, 1725608064, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('jgauqgsqv1emcosvvvf0jfioc3', NULL, '17.241.219.188', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4 Safari/605.1.15 (Applebot/0.1; +http://www.apple.com/go/applebot)', 1724905936, 1724905936, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1724905937;s:5:\"token\";s:32:\"03a41cd55400194b0ae4fd79c5847df0\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('ji8h39uqqh6kqkiunvvtolgugj', 4, '202.43.94.33', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.36', 1728461839, 1728462370, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1728462370;s:5:\"token\";s:32:\"1269244bf96deb08e7e3253bccc535d5\";}username|s:7:\"ra12345\";userId|i:4;', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('jid520p8ub8hjlptsn5rcdm762', NULL, '34.72.176.129', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/92.0.4515.159 Safari/537.36', 1727754800, 1727754801, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1727754801;s:5:\"token\";s:32:\"75cda023f79e179848d986eb9fa0fdd6\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('jpjju7a1gc9p3vsst52evie61g', NULL, '165.22.58.169', 'Mozilla/5.0 (X11; Ubuntu; Linux i686; rv:28.0) Gecko/20100101 Firefox/28.0', 1729487177, 1729487179, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('jshobebcqoj89qh0ltmj0ig2m7', NULL, '205.169.39.15', 'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36', 1724662348, 1724662348, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('k2l4ovnk2j36fq605lpi8aoo4k', NULL, '205.169.39.48', 'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36', 1724728756, 1724728756, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1724728756;s:5:\"token\";s:32:\"d7d1c3739567dbe4916853b482443842\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('k5ep1v2f6ksp979jdunpjhgo3m', NULL, '205.169.39.11', 'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36', 1724721736, 1724721736, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1724721737;s:5:\"token\";s:32:\"d6aeadfd0705b65d4e14a9a63d0a78cc\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('k5kvjr49lqgc0vfkf9p7lkfsh9', NULL, '129.227.46.176', 'Mozila/5.0', 1728528263, 1728528263, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('k5uqhg0skmd54ogfo2skomve95', NULL, '103.57.36.228', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:130.0) Gecko/20100101 Firefox/130.0', 1726455756, 1726455756, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1726455756;s:5:\"token\";s:32:\"e339a2ebde93767d14d8bd44d7fc1076\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('k67r5uerlsbkuvhnqn3gk68pq4', NULL, '205.169.39.18', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/117.0.5938.132 Safari/537.36', 1727755841, 1727755842, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1727755842;s:5:\"token\";s:32:\"a9b25011b3763102ac9dee3be148e81a\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('k8nr8b2r48bkrkj99h3lhr2b8c', NULL, '205.169.39.43', 'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36', 1724896799, 1724896799, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('kbedchm9jvtd87gmit7gfepgmh', NULL, '205.169.39.21', 'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36', 1724896717, 1724896717, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('kbeshdc3jc0cetpu5p86no9ab1', NULL, '129.227.46.171', 'Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; WOW64; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET4.0C; .NET4.0E)', 1729756339, 1729756339, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('kc0c933bq073rh7tuii7t78d2p', NULL, '205.169.39.13', 'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36', 1724662329, 1724662329, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1724662329;s:5:\"token\";s:32:\"6475d40a75e6cc064e60d6ff9bfc0db7\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('kfi6t050cju438rhqpsrb9sk37', NULL, '114.122.76.193', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36', 1724880258, 1724880259, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1724880259;s:5:\"token\";s:32:\"ec8e8161d8302114f39e0b7682dc04cb\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('kfr71smkoou9uafo3ja679pc6n', NULL, '129.227.46.176', 'Mozilla/5.0 (Windows NT 6.1; Trident/7.0; yie11; rv:11.0) like Gecko', 1729392660, 1729392660, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('kkcjvgakuc1q8alvditdp4mmbu', NULL, '208.70.244.23', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:79.0) Gecko/20100101 Firefox/79.0', 1726465158, 1726465158, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('kq3fcjhgg2m9ukli9mjif28iq0', NULL, '152.42.252.250', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', 1725680125, 1725680128, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1725680126;s:5:\"token\";s:32:\"6ccf0b128890c3edc7a2c0a086579ce7\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('kta2di6snhdrdeej8vimcomftl', NULL, '69.171.249.3', 'facebookexternalhit/1.1 (+http://www.facebook.com/externalhit_uatext.php)', 1726161833, 1726161833, 0, 'currentLocale|s:2:\"en\";', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('l2ivrlt8glm8haamdrct0s5lel', NULL, '66.220.149.40', 'meta-externalagent/1.1 (+https://developers.facebook.com/docs/sharing/webmasters/crawler)', 1726342786, 1726342786, 0, 'currentLocale|s:2:\"en\";', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('l96m9ed9m1b46rrdtuim95egbp', NULL, '134.209.183.43', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', 1727402137, 1727402137, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('lck2r6q8e1la3cppd18ootpohk', NULL, '205.169.39.26', 'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36', 1724896847, 1724896847, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('le1fnb185rp5dat14lal1315oa', NULL, '35.243.23.33', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/112.0.0.0 Safari/537.36 AppEngine-Google; (+http://code.google.com/appengine; appid: s~virustotalcloud)', 1727751215, 1727751215, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1727751215;s:5:\"token\";s:32:\"8582f35a3778e5d2a2aba9083f11cd2f\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('lgvo0br9jso1f6aieji1ldgl2f', NULL, '54.173.67.244', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/107.0.0.0 Safari/537.36', 1729374749, 1729374749, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('lhnijgujeee5bn98ka3h7lrhro', NULL, '205.169.39.26', 'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36', 1724896669, 1724896669, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('li21sddbj8s5gu53cl3eogaptl', NULL, '66.220.149.10', 'meta-externalagent/1.1 (+https://developers.facebook.com/docs/sharing/webmasters/crawler)', 1726162467, 1726162467, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('lid5778v8kn28no02hvjugh7g0', NULL, '173.252.107.13', 'meta-externalagent/1.1 (+https://developers.facebook.com/docs/sharing/webmasters/crawler)', 1726162159, 1726162159, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1726162159;s:5:\"token\";s:32:\"3ac7d4e27f5d874e6f6b3a2ea264b9db\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('livgeek3ji1gke1lrat4k4o318', NULL, '165.231.141.142', 'Mozilla/5.0 (iPhone; CPU iPhone OS 17_1_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.1.2 Mobile/15E148 Safari/604.1', 1725607229, 1725607229, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('lluncafde0uc2fmedth3nam5u6', NULL, '191.102.162.208', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/107.0.0.0 Safari/537.36', 1729115498, 1729115498, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('lm2e7vovsapk18dti8g8s4lkai', NULL, '45.81.148.169', 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_1_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.1 Mobile/15E148 Safari/604.1', 1725609744, 1725609744, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1725609744;s:5:\"token\";s:32:\"804810cdb0e3fdd9c2dd5127f5e23dca\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('ln8kua1ns6kh37d9v98glcjoir', NULL, '205.169.39.17', 'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36', 1724896354, 1724896354, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('lnc1jodidns18esmfmu49is0l4', NULL, '45.134.140.242', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/97.0.4692.71 Safari/537.36', 1728539092, 1728539092, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('lnsipce9ei5g2vihpu608h0328', NULL, '205.169.39.15', 'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36', 1724662349, 1724662349, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1724662349;s:5:\"token\";s:32:\"030747630742efd91308d2470129ba47\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('lqd0fi1nnce3r2bcq8qnt0h9cd', NULL, '34.208.129.5', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.97 Safari/537.36', 1727345781, 1727345781, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('lt0nn3m92iotb2hnfusl9ebjuk', NULL, '173.252.107.115', 'meta-externalagent/1.1 (+https://developers.facebook.com/docs/sharing/webmasters/crawler)', 1726161562, 1726161562, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1726161562;s:5:\"token\";s:32:\"d7c6c000a60083881f10f6e0f4b62648\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('ltjmlhvv8rug6dp9q9o9154brs', 1, '180.244.129.29', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.6.1 Safari/605.1.15', 1724661354, 1724664481, 1, 'csrf|a:2:{s:9:\"timestamp\";i:1724664481;s:5:\"token\";s:32:\"0748e1d7c51e61dda0e37bf2bc01257e\";}userId|i:1;username|s:6:\"peacee\";', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('m1e3q6p1706lbsogml795bqqme', NULL, '212.143.94.254', 'Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/111.0.5563.65 Safari/537.36', 1725607189, 1725607189, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1725607189;s:5:\"token\";s:32:\"15909cd0bbfea1d067a3fa7fc84f137c\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('m43fmjvjhqgffvt24i60lgbsd0', NULL, '205.169.39.47', 'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36', 1724662358, 1724662358, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('m7lg0gilq4qdcus9vcs9mptv81', NULL, '129.227.46.176', 'Go-http-client/1.1', 1728528265, 1728528265, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('mccird8koou76f9qgjae1ksfeb', NULL, '54.91.154.80', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/107.0.0.0 Safari/537.36', 1728527977, 1728527978, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('mdj0qcjo7os6mm8irk7jpko3rg', NULL, '38.154.198.57', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/107.0.0.0 Safari/537.36', 1728720278, 1728720278, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('mkqi4ct69qgb8e9u7hrc3mnu3c', NULL, '208.70.244.23', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:79.0) Gecko/20100101 Firefox/79.0', 1726465158, 1726465158, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('mmhk264lci1s68ddrpub9gmei7', NULL, '66.220.149.11', 'facebookexternalhit/1.1 (+http://www.facebook.com/externalhit_uatext.php)', 1726162199, 1726162199, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1726162200;s:5:\"token\";s:32:\"5ddec9908c1343ee8f64997e611e582d\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('mpo6n11qsc104c3grishkkiq17', NULL, '205.169.39.50', 'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36', 1728723535, 1728723535, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('n7jat91ksb8flruaeqjb1sdobp', NULL, '93.174.93.114', 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/45.0.2454.85 Safari/537.36', 1725607259, 1725607259, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('n85mggfp0hi9700hma2icghhl8', NULL, '205.169.39.20', 'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36', 1724890665, 1724890665, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('n9pvkmf1mf9fq4k2a2lpgg3qml', NULL, '205.169.39.20', 'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36', 1724896802, 1724896802, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('ndarcfu505bt0ma2utg8vt4a0a', NULL, '205.169.39.8', 'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36', 1724896558, 1724896558, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1724896558;s:5:\"token\";s:32:\"e7fff7e2076fc5e115cc33256d241cc4\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('ne4u69jh76qeod82s5ncsbeh08', NULL, '103.57.36.228', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:130.0) Gecko/20100101 Firefox/130.0', 1726455757, 1726455757, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1726455757;s:5:\"token\";s:32:\"589f477644a21352b95ae522f3788f4e\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('nlofi8u8jcpt3amod3mif2idd5', NULL, '205.169.39.3', 'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36', 1726687056, 1726687056, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1726687056;s:5:\"token\";s:32:\"9da9dc6dfc196497330783ddb4c98a49\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('np57f5b6b4k1btcka4de71b5se', NULL, '103.178.218.145', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36', 1724733408, 1724734765, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1724734765;s:5:\"token\";s:32:\"8c246b6df161f66e2feeffbbb819ae6f\";}username|s:6:\"peacee\";', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('o0jdl371due0vseugb30hdl3bh', NULL, '205.169.39.2', 'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36', 1724896802, 1724896802, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('o3jv6n84cv150qfbv18kqnahvd', NULL, '205.169.39.38', 'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36', 1724827462, 1724827462, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('o3knod0kcutfli1d5muj1foktg', NULL, '205.169.39.44', 'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36', 1724662403, 1724662403, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('okitt0781dunilpsddncqm38r3', NULL, '205.169.39.25', 'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36', 1724662315, 1724662315, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('olkpg6nuf69t8rrg6jfqvtgm3u', NULL, '188.241.177.182', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/84.0.4147.89 Safari/537.36', 1725664641, 1725664641, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('on8klvdpbvl4j3f80bppjtfru3', NULL, '205.169.39.7', 'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36', 1724896672, 1724896672, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('orshhcsm5jsulpobnp76mfcmj6', NULL, '103.23.244.234', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36 Edg/128.0.0.0', 1724889934, 1724923102, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1724923102;s:5:\"token\";s:32:\"2144e5453e6a101f1bdd4cbd15ebefb4\";}username|s:6:\"peacee\";currentLocale|s:2:\"en\";', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('p5fe6td52va8su2l08t8sojueb', NULL, '173.252.83.3', 'facebookexternalhit/1.1 (+http://www.facebook.com/externalhit_uatext.php)', 1726161336, 1726161336, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('p6c24dl3lmdldc93ngu5c0545c', NULL, '205.169.39.25', 'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36', 1724896707, 1724896707, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('p9484av04o9lcprocm7dpaac0s', NULL, '188.120.226.195', 'Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US) AppleWebKit/525.19 (KHTML, like Gecko) Chrome/1.0.154.59 Safari/525.19', 1728519524, 1728519524, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('pap5f0s8ea10bl2q7a6ksrompm', NULL, '203.209.219.44', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/109.0.5414.46 Safari/537.36', 1725607985, 1725607985, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1725607985;s:5:\"token\";s:32:\"3887a84a5002ae5f1e0158fa337b3acb\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('pei9g2laf2tm092mclqlajam5u', NULL, '103.23.244.234', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:129.0) Gecko/20100101 Firefox/129.0', 1724832757, 1724832757, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1724832757;s:5:\"token\";s:32:\"d15d3b2cd9e89163586753a500806894\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('pg66dhreccuon6kmomepk8ske1', NULL, '44.212.57.230', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/107.0.0.0 Safari/537.36', 1729374750, 1729374750, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('pi612e4lpjvqsjmv5f5f712frj', NULL, '205.169.39.13', 'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36', 1724896802, 1724896802, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('plptp5g19scf80cle3uiso2ci9', NULL, '198.240.89.79', 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/99.0.4844.47 Mobile/15E148 Safari/604.1', 1728607554, 1728607554, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('pmub3u0rn85a3jdsqbc067f20d', NULL, '103.23.244.234', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36 Edg/128.0.0.0', 1726553358, 1726553360, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1726553360;s:5:\"token\";s:32:\"49d7b6088271ef783ddad3789b1ca4d8\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('prslgsi7lerimhfajjd5v3d6v2', NULL, '69.167.32.112', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36 Edg/126.0.0.0', 1725607227, 1725607227, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1725607227;s:5:\"token\";s:32:\"1319ca4091399d2214ef6c28f5362da3\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('psfl0nrqq4plc144cafn7l4foa', NULL, '45.139.66.50', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/107.0.0.0 Safari/537.36', 1728527972, 1728527972, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('puberv4epatptugfiqs61qks9j', NULL, '66.220.149.25', 'facebookexternalhit/1.1 (+http://www.facebook.com/externalhit_uatext.php)', 1726162624, 1726162624, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1726162624;s:5:\"token\";s:32:\"cdf7734f36880f7b5db805b523826433\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('pugsglkai7ie4shbv5vvhcha2r', NULL, '114.122.83.250', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Mobile Safari/537.36', 1727928619, 1727928619, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('pv2avder3a9lt0k1fvfpqjjg78', NULL, '57.141.3.29', 'meta-externalagent/1.1 (+https://developers.facebook.com/docs/sharing/webmasters/crawler)', 1726161754, 1726161754, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1726161754;s:5:\"token\";s:32:\"cd1abeb946e14f977e12b9c9fed31f3b\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('q1j7jjmga3psltq97n1s6mta3b', NULL, '103.23.244.234', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:129.0) Gecko/20100101 Firefox/129.0', 1724745879, 1724748430, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1724748430;s:5:\"token\";s:32:\"f750bd29b635c28586f483f96cbb4ff6\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('q4u78ipjthl5gfcn1tub8mkfmu', NULL, '142.11.219.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.135 Safari/537.36 Edge/12.246', 1725607854, 1725607854, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('q5mb6rv91stqdc4gbi1uaafodr', NULL, '69.171.230.114', 'meta-externalagent/1.1 (+https://developers.facebook.com/docs/sharing/webmasters/crawler)', 1726706931, 1726706931, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1726706932;s:5:\"token\";s:32:\"8d84e3f0491a20beef71a90d44ce24b9\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('q6p10j3g5jjt1rbml992kclj1q', NULL, '129.227.46.176', 'Mozila/5.0', 1728528264, 1728528264, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('q71c02dhar6b61dhfvnv2i6fkk', NULL, '205.169.39.2', 'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36', 1724896778, 1724896778, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('qaho4kjadd2ml4n1k28a43cua8', NULL, '106.161.65.206', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36', 1725608064, 1725608064, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('qbb8pth1inb7g62e8p5305039e', NULL, '114.122.76.193', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Mobile Safari/537.36', 1724880214, 1724880214, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1724880214;s:5:\"token\";s:32:\"ec8e8161d8302114f39e0b7682dc04cb\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('qe6c6j5t70rtb6vuudp0iv0edi', NULL, '159.89.201.220', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.69 Safari/537.36', 1725951632, 1725951633, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('qet65ki4ng4pjagou890s5lvhp', NULL, '45.138.16.42', 'Mozilla/5.0 (compatible; MSIE 10.0; Windows NT 6.1; Trident/6.0)', 1727751207, 1727751207, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1727751207;s:5:\"token\";s:32:\"933c23e6f770ef5d3663778052322aa0\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('qmfpq808p0t6eb0977p5evmh7e', NULL, '205.169.39.13', 'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36', 1726699664, 1726699664, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1726699664;s:5:\"token\";s:32:\"e4cc4b7baeac7f5c802ca28b7282b840\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('qrld2697jv59g2snn47qdqb50g', NULL, '152.42.252.250', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', 1725680125, 1725680127, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1725680125;s:5:\"token\";s:32:\"c9697a5bd869d274249974a5f556a556\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('quvp6n7f7r4ajno9palmnloiqr', NULL, '205.169.39.45', 'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36', 1724662411, 1724662411, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1724662411;s:5:\"token\";s:32:\"1288ba921b5adcf50720ef777c71f1ac\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('r3uvg71d5l83iru6us0snupj97', NULL, '209.38.202.206', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_5) AppleWebKit/601.6.17 (KHTML, like Gecko) Version/9.1.1 Safari/601.6.17', 1727755280, 1727755280, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('r4lhecd86vu00q1sqa499jct4j', NULL, '45.149.148.238', 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/99.0.4844.47 Mobile/15E148 Safari/604.1', 1728780149, 1728780149, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('r616vcivsvba0u7l8a8futv5nc', NULL, '205.169.39.13', 'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36', 1724662329, 1724662329, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('r6l1719vpqf29dg87g3usue3cf', NULL, '180.244.139.53', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.6.1 Safari/605.1.15', 1724684785, 1724684800, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1724664481;s:5:\"token\";s:32:\"0748e1d7c51e61dda0e37bf2bc01257e\";}userId|i:1;username|s:6:\"peacee\";', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('rd60l262o1o3ou2ar78ib1fkdm', NULL, '196.240.60.205', 'Mozilla/5.0 (iPhone; CPU iPhone OS 17_4_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4.1 Mobile/15E148 Safari/604.1', 1725607334, 1725607334, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('rei4ipvf9dja82lj3dp7holels', NULL, '20.27.20.27', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/117.0.0.0 Safari/537.36 Edg/117.0.2045.36', 1724827224, 1724827224, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('rgckb3rk6ohjctt6fhoadofck5', NULL, '103.23.244.234', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36', 1724898402, 1724898403, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1724898403;s:5:\"token\";s:32:\"11a2f715b7fd5ef63baf612be6ad140a\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('rgn14tmr8lujoo8ohfvfkdqth7', NULL, '165.22.58.169', 'Mozilla/5.0 (X11; Ubuntu; Linux i686; rv:28.0) Gecko/20100101 Firefox/28.0', 1729487180, 1729487180, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('rit6rgps5fndk0uhfisbt7qcrb', NULL, '209.127.107.163', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/107.0.0.0 Safari/537.36', 1728607571, 1728607571, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('rmg5bvuv86hvis3qe6k377ts18', NULL, '57.141.3.13', 'meta-externalagent/1.1 (+https://developers.facebook.com/docs/sharing/webmasters/crawler)', 1726342823, 1726342823, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1726342823;s:5:\"token\";s:32:\"b169bd7f5e71865f44ea68e621298315\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('rml673ffrek527lbg0t7v192r7', NULL, '34.22.195.184', 'python-requests/2.32.3', 1727758046, 1727758046, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('rpqkr37bfnia7n6vgsrqq8c25p', NULL, '205.169.39.1', 'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36', 1724827375, 1724827375, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('s61kd5j9ef4div8291mlj5bs87', NULL, '205.169.39.17', 'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36', 1724896354, 1724896354, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1724896354;s:5:\"token\";s:32:\"2a5984cfcfd1b08aafd3320761f86ec7\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('s7pp9m1igdscvl2njutfhqbca4', NULL, '205.169.39.7', 'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36', 1724896415, 1724896415, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('s90r20q4e08aad27k48658grvr', NULL, '205.169.39.7', 'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36', 1724662339, 1724662339, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1724662339;s:5:\"token\";s:32:\"811bd56631b8d60d08740a39c247fdcf\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('s93qncgvv40dsruaevol8d42g8', NULL, '114.122.83.14', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Mobile Safari/537.36', 1727931186, 1727931286, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1727931286;s:5:\"token\";s:32:\"d1744d1d86f787f69251c4fd289d1e88\";}currentLocale|s:2:\"en\";', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('sa9fktkkrd272nbpcc38a93q0h', NULL, '103.108.92.87', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36 Edg/119.0.0.0', 1725608063, 1725608063, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1725608063;s:5:\"token\";s:32:\"48b9b6097414d7dae9fcdc5b69d3ff43\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('sc152jpckfs8cvqj0k5uqgg3f3', NULL, '208.70.244.23', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:79.0) Gecko/20100101 Firefox/79.0', 1724817619, 1724817619, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('scfp1b7bs7a0dsaka560tuscqv', NULL, '209.38.202.206', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_5) AppleWebKit/601.6.17 (KHTML, like Gecko) Version/9.1.1 Safari/601.6.17', 1727755280, 1727755280, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1727755280;s:5:\"token\";s:32:\"a1d2a52211eeb216c93f75af80821931\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('sdr69e0cj9uknc5i0gb72pv92j', NULL, '205.169.39.44', 'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36', 1724896592, 1724896592, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1724896592;s:5:\"token\";s:32:\"2b814e0be45b75f8d99dc1c2555285e7\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('si1jpa6hkbpaiek01270ahes1o', NULL, '205.169.39.7', 'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36', 1724662339, 1724662339, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('siqna1lka1i6inipqomn3b1o89', NULL, '205.169.39.11', 'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36', 1724896802, 1724896802, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('sirjt6idhcav1v1l9gt9o3hfrc', NULL, '206.189.132.117', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', 1728498013, 1728498013, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('sm6avdg39p8dauqlplk2bk5k73', NULL, '103.87.68.59', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36 Edg/121.0.0.0', 1725607215, 1725607215, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('sm70hppsbke0go48n3hh0otmob', NULL, '209.146.61.150', 'Mozilla/5.0 (X11; Linux x86_64; rv:83.0) Gecko/20100101 Firefox/83.0', 1729663271, 1729663271, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('ss3j8fvesah17rj6lhllq2481i', NULL, '114.122.111.155', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36', 1724996499, 1724996499, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1724996499;s:5:\"token\";s:32:\"c3c1ace104051c48049d095dba18801f\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('sst3hglotvg41skcj640mm3qu3', NULL, '205.169.39.38', 'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36', 1724827166, 1724827166, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('stcfpdo3tf72h90nm6js0kcjso', NULL, '168.151.138.212', 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/99.0.4844.47 Mobile/15E148 Safari/604.1', 1729730544, 1729730544, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('sufjaljl25q42ou14km98gbug1', NULL, '57.141.3.23', 'facebookexternalhit/1.1 (+http://www.facebook.com/externalhit_uatext.php)', 1726343934, 1726343934, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1726343934;s:5:\"token\";s:32:\"89d0749ac094c7bc0110021e311b5e92\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('sv7qsifpeg7enom1ihagmq7egb', NULL, '91.217.81.231', 'Mozilla/5.0 (X11; U; Linux i686; ru; rv:1.9.2.23) Gecko/20110921 Ubuntu/10.10 (maverick) Firefox/3.6.23', 1728519524, 1728519524, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('t0sruajt8crhgfbk61njum9h6n', NULL, '35.243.23.35', 'Mozilla/5.0 (Android 13; Mobile; rv:109.0) Gecko/112.0 Firefox/112.0 AppEngine-Google; (+http://code.google.com/appengine; appid: s~virustotalcloud)', 1727751210, 1727751210, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1727751210;s:5:\"token\";s:32:\"ab2d3334547640d2ae8baf97ec2c54bb\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('t1028aj9f2mblgr96esct2oqm8', NULL, '34.234.11.9', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/107.0.0.0 Safari/537.36', 1728520511, 1728520511, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('t27nde2sim4qji4arjuq50kgrk', NULL, '165.22.58.169', 'Mozilla/5.0 (X11; Ubuntu; Linux i686; rv:28.0) Gecko/20100101 Firefox/28.0', 1729692260, 1729692260, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('t5tgkpn22ncf79ej2g8j5mmumf', NULL, '89.248.171.23', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', 1725607358, 1725607359, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1725607358;s:5:\"token\";s:32:\"8da2955e79c2deb655918aeb466200a3\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('t973dumj9v42jfb5qan6um6kuh', NULL, '205.169.39.7', 'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36', 1724662369, 1724662369, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('t9s09p5kif0m771vomdrckkv84', NULL, '103.87.68.59', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36 Edg/120.0.0.0', 1725607338, 1725607338, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('tbgicu7fb7jueqq8ssn0fv6c9h', NULL, '205.169.39.7', 'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36', 1724896636, 1724896636, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('tg8u1ekrlqafrtmb2bjtonb4a7', NULL, '3.82.26.6', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.6533.99 Safari/537.36', 1728519804, 1728519805, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('thv30cp8v4412esq7oh8jjvler', NULL, '103.30.15.239', 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/99.0.4844.47 Mobile/15E148 Safari/604.1', 1728780140, 1728780140, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('tj9llq1tl8hd1v1fgam17762iq', NULL, '205.169.39.44', 'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36', 1724728777, 1724728777, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1724728777;s:5:\"token\";s:32:\"83b7d242957c55aaa7d564c7f8ff5ba2\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('tk9n9qj1e5i0s4ovi2qunancbl', NULL, '159.65.79.118', 'Mozilla/5.0 (Windows NT 10.0; WOW64; rv:82.0) Gecko/20100101 Firefox/82.0', 1725694665, 1725694665, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('tkfukkjp7vfom1q2o6l604sir5', NULL, '173.252.107.20', 'meta-externalagent/1.1 (+https://developers.facebook.com/docs/sharing/webmasters/crawler)', 1726344108, 1726344108, 0, 'currentLocale|s:2:\"en\";', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('tkv37kvrqc2tjbkmgjb0kl27lq', NULL, '143.198.199.180', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4240.193 Safari/537.36', 1729343478, 1729343481, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('tlk3o28bbn40a900a8bkf2985f', NULL, '118.193.40.197', 'Mozilla/5.0 (Linux; Android 11; vivo 1906; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/87.0.4280.141 Mobile Safari/537.36 VivoBrowser/8.9.0.0 uni-app Html5Plus/1.0', 1728589900, 1728589900, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('tm064581p3s0g0c339lfc9v6ie', NULL, '95.164.100.189', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36', 1728540308, 1728540308, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('tp59jao9f73681avv76m3b4r80', NULL, '193.34.73.102', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36', 1729119407, 1729119407, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('tpm2tlu0ui4dvbk40bug44l2l2', NULL, '38.21.9.240', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.111 Safari/537.36', 1725607419, 1725607422, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1725607419;s:5:\"token\";s:32:\"fc9ba2bb400453b2be4b6c65196b1e86\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('tpunqehp1so12rjs73gsl7veu6', NULL, '171.25.193.20', 'Mozilla/5.0 (compatible; MSIE 10.0; Windows NT 6.1; Trident/6.0)', 1727751205, 1727751205, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('u0hh6h4ep3h529rjm313j5o0sv', NULL, '40.80.158.10', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.6422.142 Safari/537.36', 1725631140, 1725631141, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1725631140;s:5:\"token\";s:32:\"f3f76924e223890eec89f7abbc4bbe3c\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('ua3aij2o2of5jvqvk71s2kqq6v', NULL, '205.169.39.7', 'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36', 1724662369, 1724662369, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1724662370;s:5:\"token\";s:32:\"91064aa4abade43c9d48cbb96396907c\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('ue72j7kbk67vvn8hf3knf81l6q', NULL, '114.122.105.21', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Mobile Safari/537.36', 1724848881, 1724848960, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1724848960;s:5:\"token\";s:32:\"f93c3a999ed9ea0982633eaf5fc038a0\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('ue9eqe86k84ibnh3c0sa6i4afj', NULL, '52.90.90.133', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/107.0.0.0 Safari/537.36', 1728527976, 1728527976, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('ugb6a7g5su4f2ckp3drgrd7rr0', NULL, '49.239.65.231', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Mobile Safari/537.36', 1729124042, 1729124043, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('uj666om6gd8iqo1vjb8d47je6l', NULL, '205.169.39.3', 'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36', 1726687054, 1726687054, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('ujiv001atfhhotoedu72slnj2g', NULL, '93.127.186.191', 'Mozilla/5.0 (Linux; Android 9; SAMSUNG SM-G950U Build/PPR1.180610.011) AppleWebKit/537.36 (KHTML, like Gecko) SamsungBrowser/9.4 Chrome/67.0.3396.87 Mobile Safari/537.36', 1726437429, 1726437429, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('ujs6rfj9lgkjr4lrblrj6rnnvh', NULL, '205.169.39.24', 'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36', 1724721804, 1724721804, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1724721804;s:5:\"token\";s:32:\"9184671d5fdafa7452497b5fa7b81a53\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('umtvee16esve413r3q5vmvlsb9', NULL, '57.141.3.11', 'facebookexternalhit/1.1 (+http://www.facebook.com/externalhit_uatext.php)', 1726161831, 1726161831, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1726161831;s:5:\"token\";s:32:\"ac4f6cf51eb8c182fe73e446870f9549\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('un4qlqfr7jfgrii8185pkgd50p', NULL, '205.169.39.12', 'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36', 1724896636, 1724896636, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('uo5mo2ujfcosept0fvdob7qono', NULL, '205.169.39.20', 'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36', 1724896707, 1724896707, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('uup760unsoov34cr9hnbld4h85', NULL, '205.169.39.20', 'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36', 1724890667, 1724890667, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1724890667;s:5:\"token\";s:32:\"f5bcb148bc1016af51d4a443d0d522d5\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('uv2sme9s5uaecnp25d2r5oquvo', NULL, '103.77.234.214', 'Mozilla/5.0 (iPhone; CPU iPhone OS 17_3_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.3.1 Mobile/15E148 Safari/604.1', 1725608063, 1725608063, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('v202kopdfuim7qs9sudkrij8u7', NULL, '104.197.69.115', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/92.0.4515.159 Safari/537.36', 1727754802, 1727754802, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1727754801;s:5:\"token\";s:32:\"75cda023f79e179848d986eb9fa0fdd6\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('v2pmf5b8srav8lg4bkp1b367ta', NULL, '44.229.14.103', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36', 1725676055, 1725676056, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1725676055;s:5:\"token\";s:32:\"15af355cf8eaf7fef5e9973fc28c68dd\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('v41ogj98t0lcnentlgeffbqauj', NULL, '180.149.29.115', 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/99.0.4844.47 Mobile/15E148 Safari/604.1', 1729730546, 1729730546, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('v7daqca7iagt7n9shqmbuhousj', NULL, '103.57.36.228', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_8_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) FxiOS/115.1  Mobile/15E148 Safari/605.1.15', 1727959968, 1727959968, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1727959968;s:5:\"token\";s:32:\"d8e9c47c4fe0e7ed6daab373f2f7ad53\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('v9idr49aa92cut7i9tt04iugc4', NULL, '205.169.39.7', 'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36', 1724896673, 1724896673, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1724896673;s:5:\"token\";s:32:\"d9b35c226f0e431da1e6ea7730658ba2\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('vaibkqrti1qe98fe8tljju12v8', NULL, '205.169.39.26', 'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36', 1728244321, 1728244321, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1728244321;s:5:\"token\";s:32:\"80351767c02893d953862f57ce2ae40e\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('vcqin0bp4rdomev85ka3bbk7e6', NULL, '93.174.93.114', 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/45.0.2454.85 Safari/537.36', 1725607259, 1725607259, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1725607259;s:5:\"token\";s:32:\"58412ae631814ba403ac9c2a3ac7e5ef\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('vcrgvt1mhl10uu8e0da502jkpi', NULL, '103.57.36.228', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.0 Safari/605.1.15', 1727959966, 1727959970, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1727959970;s:5:\"token\";s:32:\"f1dc8d16083518f96f1eeeaa133fc813\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('vh0n6f0rtubtd7umad5vev99qd', NULL, '204.217.135.171', 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/99.0.4844.47 Mobile/15E148 Safari/604.1', 1728607554, 1728607554, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('vi6mpn0cru80tqnc76ouarq7v9', NULL, '173.252.107.113', 'facebookexternalhit/1.1 (+http://www.facebook.com/externalhit_uatext.php)', 1726708991, 1726708991, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('vpldhcklciiifu2pss2ct9he1t', NULL, '54.74.142.1', 'Pandalytics/2.0 (https://domainsbot.com/pandalytics/)', 1727800054, 1727800054, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('vrcvq5r5lc432rsajqchdknhrl', NULL, '205.169.39.37', 'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36', 1724896896, 1724896896, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('vstptis5ivpn5icehoqkl59cil', NULL, '185.204.0.106', 'Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0; MRSPUTNIK 2, 4, 0, 386; MRA 5.6 (build 03399); .NET CLR 1.1.4322; .NET CLR 2.0.50727; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729; msn OptimizedIE8;RURU)', 1728890252, 1728890252, 0, '', 'peacee.id');
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
INSERT INTO `site` (`site_id`, `redirect`, `primary_locale`, `min_password_length`, `installed_locales`, `supported_locales`, `original_style_file_name`) VALUES (1, 0, 'en', 6, '[\"en\"]', '[\"en\"]', NULL);
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
INSERT INTO `site_settings` (`site_setting_id`, `setting_name`, `locale`, `setting_value`) VALUES (2, 'contactName', 'en', 'Open Journal Systems');
INSERT INTO `site_settings` (`site_setting_id`, `setting_name`, `locale`, `setting_value`) VALUES (3, 'compressStatsLogs', '', '0');
INSERT INTO `site_settings` (`site_setting_id`, `setting_name`, `locale`, `setting_value`) VALUES (4, 'enableGeoUsageStats', '', 'disabled');
INSERT INTO `site_settings` (`site_setting_id`, `setting_name`, `locale`, `setting_value`) VALUES (5, 'enableInstitutionUsageStats', '', '0');
INSERT INTO `site_settings` (`site_setting_id`, `setting_name`, `locale`, `setting_value`) VALUES (6, 'keepDailyUsageStats', '', '0');
INSERT INTO `site_settings` (`site_setting_id`, `setting_name`, `locale`, `setting_value`) VALUES (7, 'isSiteSushiPlatform', '', '0');
INSERT INTO `site_settings` (`site_setting_id`, `setting_name`, `locale`, `setting_value`) VALUES (8, 'isSushiApiPublic', '', '1');
INSERT INTO `site_settings` (`site_setting_id`, `setting_name`, `locale`, `setting_value`) VALUES (9, 'themePluginPath', '', 'default');
INSERT INTO `site_settings` (`site_setting_id`, `setting_name`, `locale`, `setting_value`) VALUES (10, 'enableBulkEmails', '', '[1]');
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Who can access a submission while it is in the editorial workflow. Includes all editorial and author assignments. For reviewers, see review_assignments.';

-- ----------------------------
-- Records of stage_assignments
-- ----------------------------
BEGIN;
INSERT INTO `stage_assignments` (`stage_assignment_id`, `submission_id`, `user_group_id`, `user_id`, `date_assigned`, `recommend_only`, `can_change_metadata`) VALUES (1, 1, 14, 4, '2024-10-09 08:23:35', 0, 0);
INSERT INTO `stage_assignments` (`stage_assignment_id`, `submission_id`, `user_group_id`, `user_id`, `date_assigned`, `recommend_only`, `can_change_metadata`) VALUES (2, 2, 14, 4, '2024-10-09 08:26:10', 0, 0);
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Revisions map submission_file entries to files on the data store.';

-- ----------------------------
-- Records of submission_file_revisions
-- ----------------------------
BEGIN;
INSERT INTO `submission_file_revisions` (`revision_id`, `submission_file_id`, `file_id`) VALUES (1, 1, 1);
INSERT INTO `submission_file_revisions` (`revision_id`, `submission_file_id`, `file_id`) VALUES (2, 2, 2);
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Localized data about submission files like published metadata.';

-- ----------------------------
-- Records of submission_file_settings
-- ----------------------------
BEGIN;
INSERT INTO `submission_file_settings` (`submission_file_setting_id`, `submission_file_id`, `locale`, `setting_name`, `setting_value`) VALUES (1, 1, 'en', 'name', 'contoh.pdf');
INSERT INTO `submission_file_settings` (`submission_file_setting_id`, `submission_file_id`, `locale`, `setting_name`, `setting_value`) VALUES (2, 2, 'en', 'name', 'contoh.pdf');
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='All files associated with a submission, such as those uploaded during submission, as revisions, or by copyeditors or layout editors for production.';

-- ----------------------------
-- Records of submission_files
-- ----------------------------
BEGIN;
INSERT INTO `submission_files` (`submission_file_id`, `submission_id`, `file_id`, `source_submission_file_id`, `genre_id`, `file_stage`, `direct_sales_price`, `sales_type`, `viewable`, `created_at`, `updated_at`, `uploader_user_id`, `assoc_type`, `assoc_id`) VALUES (1, 1, 1, NULL, 1, 2, NULL, NULL, NULL, '2024-10-09 08:21:53', '2024-10-09 08:21:57', 4, NULL, NULL);
INSERT INTO `submission_files` (`submission_file_id`, `submission_id`, `file_id`, `source_submission_file_id`, `genre_id`, `file_stage`, `direct_sales_price`, `sales_type`, `viewable`, `created_at`, `updated_at`, `uploader_user_id`, `assoc_type`, `assoc_id`) VALUES (2, 2, 2, NULL, 1, 2, NULL, NULL, NULL, '2024-10-09 08:25:44', '2024-10-09 08:25:46', 4, NULL, NULL);
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='All submissions submitted to the context, including incomplete, declined and unpublished submissions.';

-- ----------------------------
-- Records of submissions
-- ----------------------------
BEGIN;
INSERT INTO `submissions` (`submission_id`, `context_id`, `current_publication_id`, `date_last_activity`, `date_submitted`, `last_modified`, `stage_id`, `locale`, `status`, `submission_progress`, `work_type`) VALUES (1, 1, 1, '2024-10-09 08:23:35', '2024-10-09 08:23:34', '2024-10-09 08:23:34', 1, 'en', 1, '', 0);
INSERT INTO `submissions` (`submission_id`, `context_id`, `current_publication_id`, `date_last_activity`, `date_submitted`, `last_modified`, `stage_id`, `locale`, `status`, `submission_progress`, `work_type`) VALUES (2, 1, 2, '2024-10-09 08:26:10', '2024-10-09 08:26:09', '2024-10-09 08:26:09', 1, 'en', 1, '', 0);
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
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Temporary files, e.g. where files are kept during an upload process before they are moved somewhere more appropriate.';

-- ----------------------------
-- Records of temporary_files
-- ----------------------------
BEGIN;
INSERT INTO `temporary_files` (`file_id`, `user_id`, `file_name`, `file_type`, `file_size`, `original_file_name`, `date_uploaded`) VALUES (8, 1, 'jpegsLDuia', 'image/jpeg', 48225, 'WhatsApp Image 2024-08-28 at 15.08.35.jpeg', '2024-08-28 08:11:17');
INSERT INTO `temporary_files` (`file_id`, `user_id`, `file_name`, `file_type`, `file_size`, `original_file_name`, `date_uploaded`) VALUES (12, 1, 'pngEoXIkc', 'image/png', 242872, 'header_new.png', '2024-08-28 09:17:36');
INSERT INTO `temporary_files` (`file_id`, `user_id`, `file_name`, `file_type`, `file_size`, `original_file_name`, `date_uploaded`) VALUES (22, 1, 'pngvwY9Q6', 'image/png', 382257, 'MyHeader.png', '2024-08-29 02:03:22');
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
) ENGINE=InnoDB AUTO_INCREMENT=268 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Temporary stats totals based on visitor log records. Data in this table is provisional. See the metrics_* tables for compiled stats.';

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
) ENGINE=InnoDB AUTO_INCREMENT=70 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='More data about user groups, including localized properties such as the name.';

-- ----------------------------
-- Records of user_group_settings
-- ----------------------------
BEGIN;
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (1, 1, 'en', 'name', 'Site Admin');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (2, 2, '', 'nameLocaleKey', 'default.groups.name.manager');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (3, 2, '', 'abbrevLocaleKey', 'default.groups.abbrev.manager');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (4, 2, 'en', 'abbrev', 'JM');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (5, 2, 'en', 'name', 'Journal manager');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (6, 3, '', 'nameLocaleKey', 'default.groups.name.editor');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (7, 3, '', 'abbrevLocaleKey', 'default.groups.abbrev.editor');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (8, 3, 'en', 'abbrev', 'JE');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (9, 3, 'en', 'name', 'Journal editor');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (10, 4, '', 'nameLocaleKey', 'default.groups.name.productionEditor');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (11, 4, '', 'abbrevLocaleKey', 'default.groups.abbrev.productionEditor');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (12, 4, 'en', 'abbrev', 'ProdE');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (13, 4, 'en', 'name', 'Production editor');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (14, 5, '', 'nameLocaleKey', 'default.groups.name.sectionEditor');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (15, 5, '', 'abbrevLocaleKey', 'default.groups.abbrev.sectionEditor');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (16, 5, 'en', 'abbrev', 'SecE');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (17, 5, 'en', 'name', 'Section editor');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (18, 6, '', 'nameLocaleKey', 'default.groups.name.guestEditor');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (19, 6, '', 'abbrevLocaleKey', 'default.groups.abbrev.guestEditor');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (20, 6, 'en', 'abbrev', 'GE');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (21, 6, 'en', 'name', 'Guest editor');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (22, 7, '', 'nameLocaleKey', 'default.groups.name.copyeditor');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (23, 7, '', 'abbrevLocaleKey', 'default.groups.abbrev.copyeditor');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (24, 7, 'en', 'abbrev', 'CE');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (25, 7, 'en', 'name', 'Copyeditor');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (26, 8, '', 'nameLocaleKey', 'default.groups.name.designer');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (27, 8, '', 'abbrevLocaleKey', 'default.groups.abbrev.designer');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (28, 8, 'en', 'abbrev', 'Design');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (29, 8, 'en', 'name', 'Designer');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (30, 9, '', 'nameLocaleKey', 'default.groups.name.funding');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (31, 9, '', 'abbrevLocaleKey', 'default.groups.abbrev.funding');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (32, 9, 'en', 'abbrev', 'FC');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (33, 9, 'en', 'name', 'Funding coordinator');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (34, 10, '', 'nameLocaleKey', 'default.groups.name.indexer');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (35, 10, '', 'abbrevLocaleKey', 'default.groups.abbrev.indexer');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (36, 10, 'en', 'abbrev', 'IND');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (37, 10, 'en', 'name', 'Indexer');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (38, 11, '', 'nameLocaleKey', 'default.groups.name.layoutEditor');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (39, 11, '', 'abbrevLocaleKey', 'default.groups.abbrev.layoutEditor');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (40, 11, 'en', 'abbrev', 'LE');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (41, 11, 'en', 'name', 'Layout Editor');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (42, 12, '', 'nameLocaleKey', 'default.groups.name.marketing');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (43, 12, '', 'abbrevLocaleKey', 'default.groups.abbrev.marketing');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (44, 12, 'en', 'abbrev', 'MS');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (45, 12, 'en', 'name', 'Marketing and sales coordinator');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (46, 13, '', 'nameLocaleKey', 'default.groups.name.proofreader');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (47, 13, '', 'abbrevLocaleKey', 'default.groups.abbrev.proofreader');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (48, 13, 'en', 'abbrev', 'PR');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (49, 13, 'en', 'name', 'Proofreader');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (50, 14, '', 'nameLocaleKey', 'default.groups.name.author');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (51, 14, '', 'abbrevLocaleKey', 'default.groups.abbrev.author');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (52, 14, 'en', 'abbrev', 'AU');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (53, 14, 'en', 'name', 'Author');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (54, 15, '', 'nameLocaleKey', 'default.groups.name.translator');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (55, 15, '', 'abbrevLocaleKey', 'default.groups.abbrev.translator');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (56, 15, 'en', 'abbrev', 'Trans');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (57, 15, 'en', 'name', 'Translator');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (58, 16, '', 'nameLocaleKey', 'default.groups.name.externalReviewer');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (59, 16, '', 'abbrevLocaleKey', 'default.groups.abbrev.externalReviewer');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (60, 16, 'en', 'abbrev', 'R');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (61, 16, 'en', 'name', 'Reviewer');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (62, 17, '', 'nameLocaleKey', 'default.groups.name.reader');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (63, 17, '', 'abbrevLocaleKey', 'default.groups.abbrev.reader');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (64, 17, 'en', 'abbrev', 'Read');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (65, 17, 'en', 'name', 'Reader');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (66, 18, '', 'nameLocaleKey', 'default.groups.name.subscriptionManager');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (67, 18, '', 'abbrevLocaleKey', 'default.groups.abbrev.subscriptionManager');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (68, 18, 'en', 'abbrev', 'SubM');
INSERT INTO `user_group_settings` (`user_group_setting_id`, `user_group_id`, `locale`, `setting_name`, `setting_value`) VALUES (69, 18, 'en', 'name', 'Subscription Manager');
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
INSERT INTO `user_group_stage` (`user_group_stage_id`, `context_id`, `user_group_id`, `stage_id`) VALUES (27, 1, 15, 1);
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
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='More data about users, including localized properties like their name and affiliation.';

-- ----------------------------
-- Records of user_settings
-- ----------------------------
BEGIN;
INSERT INTO `user_settings` (`user_setting_id`, `user_id`, `locale`, `setting_name`, `setting_value`) VALUES (1, 1, 'en', 'familyName', 'peacee');
INSERT INTO `user_settings` (`user_setting_id`, `user_id`, `locale`, `setting_name`, `setting_value`) VALUES (2, 1, 'en', 'givenName', 'peacee');
INSERT INTO `user_settings` (`user_setting_id`, `user_id`, `locale`, `setting_name`, `setting_value`) VALUES (3, 1, 'en', 'affiliation', '');
INSERT INTO `user_settings` (`user_setting_id`, `user_id`, `locale`, `setting_name`, `setting_value`) VALUES (4, 1, 'en', 'biography', '');
INSERT INTO `user_settings` (`user_setting_id`, `user_id`, `locale`, `setting_name`, `setting_value`) VALUES (5, 1, '', 'orcid', '');
INSERT INTO `user_settings` (`user_setting_id`, `user_id`, `locale`, `setting_name`, `setting_value`) VALUES (6, 1, 'en', 'preferredPublicName', '');
INSERT INTO `user_settings` (`user_setting_id`, `user_id`, `locale`, `setting_name`, `setting_value`) VALUES (7, 1, 'en', 'signature', '');
INSERT INTO `user_settings` (`user_setting_id`, `user_id`, `locale`, `setting_name`, `setting_value`) VALUES (8, 2, 'en', 'affiliation', '');
INSERT INTO `user_settings` (`user_setting_id`, `user_id`, `locale`, `setting_name`, `setting_value`) VALUES (9, 2, 'en', 'biography', '');
INSERT INTO `user_settings` (`user_setting_id`, `user_id`, `locale`, `setting_name`, `setting_value`) VALUES (10, 2, 'en', 'familyName', 'Wahyudin');
INSERT INTO `user_settings` (`user_setting_id`, `user_id`, `locale`, `setting_name`, `setting_value`) VALUES (11, 2, 'en', 'givenName', 'Didin');
INSERT INTO `user_settings` (`user_setting_id`, `user_id`, `locale`, `setting_name`, `setting_value`) VALUES (12, 2, '', 'orcid', '');
INSERT INTO `user_settings` (`user_setting_id`, `user_id`, `locale`, `setting_name`, `setting_value`) VALUES (13, 2, 'en', 'preferredPublicName', 'deewahyu');
INSERT INTO `user_settings` (`user_setting_id`, `user_id`, `locale`, `setting_name`, `setting_value`) VALUES (14, 2, 'en', 'signature', '');
INSERT INTO `user_settings` (`user_setting_id`, `user_id`, `locale`, `setting_name`, `setting_value`) VALUES (15, 3, 'en', 'affiliation', 'Universitas Pendidikan Indonesia');
INSERT INTO `user_settings` (`user_setting_id`, `user_id`, `locale`, `setting_name`, `setting_value`) VALUES (16, 3, 'en', 'familyName', '');
INSERT INTO `user_settings` (`user_setting_id`, `user_id`, `locale`, `setting_name`, `setting_value`) VALUES (17, 3, 'en', 'givenName', 'R Deasy Mandasari');
INSERT INTO `user_settings` (`user_setting_id`, `user_id`, `locale`, `setting_name`, `setting_value`) VALUES (18, 4, 'en', 'affiliation', '');
INSERT INTO `user_settings` (`user_setting_id`, `user_id`, `locale`, `setting_name`, `setting_value`) VALUES (19, 4, 'en', 'biography', '');
INSERT INTO `user_settings` (`user_setting_id`, `user_id`, `locale`, `setting_name`, `setting_value`) VALUES (20, 4, 'en', 'familyName', 'Adrian');
INSERT INTO `user_settings` (`user_setting_id`, `user_id`, `locale`, `setting_name`, `setting_value`) VALUES (21, 4, 'en', 'givenName', 'Ronald');
INSERT INTO `user_settings` (`user_setting_id`, `user_id`, `locale`, `setting_name`, `setting_value`) VALUES (22, 4, '', 'orcid', '');
INSERT INTO `user_settings` (`user_setting_id`, `user_id`, `locale`, `setting_name`, `setting_value`) VALUES (23, 4, 'en', 'preferredPublicName', 'Ronald Adrian');
INSERT INTO `user_settings` (`user_setting_id`, `user_id`, `locale`, `setting_name`, `setting_value`) VALUES (24, 4, 'en', 'signature', '');
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
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Maps users to their assigned user_groups.';

-- ----------------------------
-- Records of user_user_groups
-- ----------------------------
BEGIN;
INSERT INTO `user_user_groups` (`user_user_group_id`, `user_group_id`, `user_id`) VALUES (1, 1, 1);
INSERT INTO `user_user_groups` (`user_user_group_id`, `user_group_id`, `user_id`) VALUES (3, 2, 1);
INSERT INTO `user_user_groups` (`user_user_group_id`, `user_group_id`, `user_id`) VALUES (4, 14, 2);
INSERT INTO `user_user_groups` (`user_user_group_id`, `user_group_id`, `user_id`) VALUES (7, 14, 4);
INSERT INTO `user_user_groups` (`user_user_group_id`, `user_group_id`, `user_id`) VALUES (5, 16, 2);
INSERT INTO `user_user_groups` (`user_user_group_id`, `user_group_id`, `user_id`) VALUES (6, 17, 3);
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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='All registered users, including authentication data and profile data.';

-- ----------------------------
-- Records of users
-- ----------------------------
BEGIN;
INSERT INTO `users` (`user_id`, `username`, `password`, `email`, `url`, `phone`, `mailing_address`, `billing_address`, `country`, `locales`, `gossip`, `date_last_email`, `date_registered`, `date_validated`, `date_last_login`, `must_change_password`, `auth_id`, `auth_str`, `disabled`, `disabled_reason`, `inline_help`) VALUES (1, 'peacee', '$2y$10$5lRIAx8obndWSkAp9VEqQOlGf0Qq76hLx2MMFqI9U3Hqz/2EBmSyK', 'fpteupi@gmail.com', '', '', '', NULL, '', '[]', NULL, NULL, '2024-08-26 08:35:40', NULL, '2024-10-20 04:42:10', 0, NULL, NULL, 0, NULL, 1);
INSERT INTO `users` (`user_id`, `username`, `password`, `email`, `url`, `phone`, `mailing_address`, `billing_address`, `country`, `locales`, `gossip`, `date_last_email`, `date_registered`, `date_validated`, `date_last_login`, `must_change_password`, `auth_id`, `auth_str`, `disabled`, `disabled_reason`, `inline_help`) VALUES (2, 'deewahyu', '$2y$10$zQpOlQzb1nIAuRb9EFDDBOHo6z7Tn/cjj9lP7nIGUGjKF.6eV7quy', 'deewahyu@upi.edu', '', '', '', NULL, 'ID', '[]', NULL, NULL, '2024-08-26 09:22:34', NULL, NULL, 0, NULL, NULL, 0, NULL, 1);
INSERT INTO `users` (`user_id`, `username`, `password`, `email`, `url`, `phone`, `mailing_address`, `billing_address`, `country`, `locales`, `gossip`, `date_last_email`, `date_registered`, `date_validated`, `date_last_login`, `must_change_password`, `auth_id`, `auth_str`, `disabled`, `disabled_reason`, `inline_help`) VALUES (3, 'deasy', '$2y$10$olsug3FLWhjaR5X8.v0kpeYxSMfKvvl1wdeY7LByWEn/DWL1wLqUG', 'deasy@upi.edu', NULL, NULL, NULL, NULL, 'ID', '[]', NULL, NULL, '2024-08-26 11:48:05', NULL, '2024-08-26 11:48:05', NULL, NULL, NULL, 0, NULL, 1);
INSERT INTO `users` (`user_id`, `username`, `password`, `email`, `url`, `phone`, `mailing_address`, `billing_address`, `country`, `locales`, `gossip`, `date_last_email`, `date_registered`, `date_validated`, `date_last_login`, `must_change_password`, `auth_id`, `auth_str`, `disabled`, `disabled_reason`, `inline_help`) VALUES (4, 'ra12345', '$2y$10$7uHH5VrQ3T1CQzai.elVvelT2pMrjlVy4dWFXmWoHDi4mPxD1fdMm', 'ronald.adr@gmail.com', '', '', '', NULL, 'ID', '[]', NULL, NULL, '2024-10-09 08:14:22', NULL, '2024-10-09 08:18:18', 0, NULL, NULL, 0, NULL, 1);
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
) ENGINE=InnoDB AUTO_INCREMENT=48 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Describes the installation and upgrade version history for the application and all installed plugins.';

-- ----------------------------
-- Records of versions
-- ----------------------------
BEGIN;
INSERT INTO `versions` (`version_id`, `major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES (1, 1, 0, 0, 0, '2024-08-26 08:35:42', 1, 'plugins.metadata', 'dc11', '', 0, 0);
INSERT INTO `versions` (`version_id`, `major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES (2, 1, 0, 0, 0, '2024-08-26 08:35:42', 1, 'plugins.blocks', 'developedBy', 'DevelopedByBlockPlugin', 1, 0);
INSERT INTO `versions` (`version_id`, `major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES (3, 1, 0, 0, 0, '2024-08-26 08:35:42', 1, 'plugins.blocks', 'information', 'InformationBlockPlugin', 1, 0);
INSERT INTO `versions` (`version_id`, `major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES (4, 1, 1, 0, 0, '2024-08-26 08:35:42', 1, 'plugins.blocks', 'subscription', 'SubscriptionBlockPlugin', 1, 0);
INSERT INTO `versions` (`version_id`, `major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES (5, 1, 0, 1, 0, '2024-08-26 08:35:42', 1, 'plugins.blocks', 'browse', 'BrowseBlockPlugin', 1, 0);
INSERT INTO `versions` (`version_id`, `major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES (6, 1, 0, 0, 0, '2024-08-26 08:35:42', 1, 'plugins.blocks', 'makeSubmission', 'MakeSubmissionBlockPlugin', 1, 0);
INSERT INTO `versions` (`version_id`, `major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES (7, 1, 0, 0, 0, '2024-08-26 08:35:42', 1, 'plugins.blocks', 'languageToggle', 'LanguageToggleBlockPlugin', 1, 0);
INSERT INTO `versions` (`version_id`, `major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES (8, 1, 0, 0, 0, '2024-08-26 08:35:42', 1, 'plugins.gateways', 'resolver', '', 0, 0);
INSERT INTO `versions` (`version_id`, `major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES (9, 1, 0, 1, 0, '2024-08-26 08:35:42', 1, 'plugins.generic', 'pdfJsViewer', 'PdfJsViewerPlugin', 1, 0);
INSERT INTO `versions` (`version_id`, `major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES (10, 1, 0, 0, 0, '2024-08-26 08:35:42', 1, 'plugins.generic', 'webFeed', 'WebFeedPlugin', 1, 0);
INSERT INTO `versions` (`version_id`, `major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES (11, 1, 2, 0, 0, '2024-08-26 08:35:42', 1, 'plugins.generic', 'staticPages', 'StaticPagesPlugin', 1, 0);
INSERT INTO `versions` (`version_id`, `major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES (12, 1, 2, 0, 0, '2024-08-26 08:35:42', 1, 'plugins.generic', 'customBlockManager', 'CustomBlockManagerPlugin', 1, 0);
INSERT INTO `versions` (`version_id`, `major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES (13, 1, 3, 0, 0, '2024-08-26 08:35:42', 1, 'plugins.generic', 'acron', 'AcronPlugin', 1, 1);
INSERT INTO `versions` (`version_id`, `major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES (14, 1, 0, 0, 0, '2024-08-26 08:35:42', 1, 'plugins.generic', 'driver', 'DRIVERPlugin', 1, 0);
INSERT INTO `versions` (`version_id`, `major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES (15, 2, 0, 0, 0, '2024-08-26 08:35:42', 1, 'plugins.generic', 'datacite', '', 0, 0);
INSERT INTO `versions` (`version_id`, `major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES (16, 1, 0, 0, 0, '2024-08-26 08:35:42', 1, 'plugins.generic', 'recommendBySimilarity', 'RecommendBySimilarityPlugin', 1, 1);
INSERT INTO `versions` (`version_id`, `major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES (17, 1, 1, 0, 0, '2024-08-26 08:35:42', 1, 'plugins.generic', 'googleScholar', 'GoogleScholarPlugin', 1, 0);
INSERT INTO `versions` (`version_id`, `major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES (18, 1, 0, 0, 0, '2024-08-26 08:35:42', 1, 'plugins.generic', 'usageEvent', '', 0, 0);
INSERT INTO `versions` (`version_id`, `major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES (19, 1, 0, 1, 0, '2024-08-26 08:35:42', 1, 'plugins.generic', 'lensGalley', 'LensGalleyPlugin', 1, 0);
INSERT INTO `versions` (`version_id`, `major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES (20, 1, 0, 0, 0, '2024-08-26 08:35:42', 1, 'plugins.generic', 'announcementFeed', 'AnnouncementFeedPlugin', 1, 0);
INSERT INTO `versions` (`version_id`, `major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES (21, 3, 0, 0, 0, '2024-08-26 08:35:42', 1, 'plugins.generic', 'crossref', '', 0, 0);
INSERT INTO `versions` (`version_id`, `major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES (22, 1, 0, 0, 0, '2024-08-26 08:35:42', 1, 'plugins.generic', 'tinymce', 'TinyMCEPlugin', 1, 0);
INSERT INTO `versions` (`version_id`, `major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES (23, 1, 0, 0, 1, '2024-08-26 08:35:42', 1, 'plugins.generic', 'recommendByAuthor', 'RecommendByAuthorPlugin', 1, 1);
INSERT INTO `versions` (`version_id`, `major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES (24, 1, 3, 4, 3, '2024-08-26 08:35:42', 1, 'plugins.generic', 'orcidProfile', 'OrcidProfilePlugin', 1, 0);
INSERT INTO `versions` (`version_id`, `major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES (25, 1, 0, 0, 0, '2024-08-26 08:35:42', 1, 'plugins.generic', 'googleAnalytics', 'GoogleAnalyticsPlugin', 1, 0);
INSERT INTO `versions` (`version_id`, `major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES (26, 1, 0, 0, 0, '2024-08-26 08:35:42', 1, 'plugins.generic', 'htmlArticleGalley', 'HtmlArticleGalleyPlugin', 1, 0);
INSERT INTO `versions` (`version_id`, `major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES (27, 0, 1, 0, 0, '2024-08-26 08:35:42', 1, 'plugins.generic', 'citationStyleLanguage', 'CitationStyleLanguagePlugin', 1, 0);
INSERT INTO `versions` (`version_id`, `major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES (28, 1, 0, 0, 0, '2024-08-26 08:35:42', 1, 'plugins.generic', 'dublinCoreMeta', 'DublinCoreMetaPlugin', 1, 0);
INSERT INTO `versions` (`version_id`, `major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES (29, 1, 0, 0, 0, '2024-08-26 08:35:42', 1, 'plugins.importexport', 'native', '', 0, 0);
INSERT INTO `versions` (`version_id`, `major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES (30, 1, 0, 0, 0, '2024-08-26 08:35:42', 1, 'plugins.importexport', 'users', '', 0, 0);
INSERT INTO `versions` (`version_id`, `major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES (31, 1, 0, 0, 0, '2024-08-26 08:35:42', 1, 'plugins.importexport', 'pubmed', '', 0, 0);
INSERT INTO `versions` (`version_id`, `major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES (32, 1, 0, 0, 0, '2024-08-26 08:35:42', 1, 'plugins.oaiMetadataFormats', 'rfc1807', '', 0, 0);
INSERT INTO `versions` (`version_id`, `major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES (33, 1, 0, 0, 0, '2024-08-26 08:35:42', 1, 'plugins.oaiMetadataFormats', 'dc', '', 0, 0);
INSERT INTO `versions` (`version_id`, `major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES (34, 1, 0, 0, 0, '2024-08-26 08:35:42', 1, 'plugins.oaiMetadataFormats', 'marcxml', '', 0, 0);
INSERT INTO `versions` (`version_id`, `major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES (35, 1, 0, 0, 0, '2024-08-26 08:35:42', 1, 'plugins.oaiMetadataFormats', 'marc', '', 0, 0);
INSERT INTO `versions` (`version_id`, `major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES (36, 1, 0, 0, 0, '2024-08-26 08:35:42', 1, 'plugins.paymethod', 'paypal', '', 0, 0);
INSERT INTO `versions` (`version_id`, `major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES (37, 1, 0, 0, 0, '2024-08-26 08:35:42', 1, 'plugins.paymethod', 'manual', '', 0, 0);
INSERT INTO `versions` (`version_id`, `major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES (38, 1, 0, 0, 0, '2024-08-26 08:35:42', 1, 'plugins.pubIds', 'urn', 'URNPubIdPlugin', 1, 0);
INSERT INTO `versions` (`version_id`, `major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES (39, 1, 0, 0, 0, '2024-08-26 08:35:42', 1, 'plugins.reports', 'articles', '', 0, 0);
INSERT INTO `versions` (`version_id`, `major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES (40, 1, 0, 0, 0, '2024-08-26 08:35:42', 1, 'plugins.reports', 'subscriptions', '', 0, 0);
INSERT INTO `versions` (`version_id`, `major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES (41, 2, 0, 1, 0, '2024-08-26 08:35:42', 1, 'plugins.reports', 'reviewReport', '', 0, 0);
INSERT INTO `versions` (`version_id`, `major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES (42, 1, 1, 0, 0, '2024-08-26 08:35:42', 1, 'plugins.reports', 'counterReport', '', 0, 0);
INSERT INTO `versions` (`version_id`, `major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES (43, 1, 0, 0, 0, '2024-08-26 08:35:42', 1, 'plugins.themes', 'default', 'DefaultThemePlugin', 1, 0);
INSERT INTO `versions` (`version_id`, `major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES (44, 3, 4, 0, 0, '2024-08-26 08:35:10', 1, 'core', 'ojs2', '', 0, 1);
INSERT INTO `versions` (`version_id`, `major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES (45, 1, 1, 0, 0, '2024-08-26 08:38:46', 1, 'plugins.importexport', 'doaj', '', 0, 0);
INSERT INTO `versions` (`version_id`, `major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES (46, 1, 1, 2, 3, '2024-08-27 00:53:21', 1, 'plugins.themes', 'immersion', 'ImmersionThemePlugin', 1, 0);
INSERT INTO `versions` (`version_id`, `major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES (47, 1, 2, 1, 0, '2024-10-09 09:23:58', 1, 'plugins.generic', 'browseBySection', 'BrowseBySectionPlugin', 1, 0);
COMMIT;

SET FOREIGN_KEY_CHECKS = 1;
