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

 Date: 11/11/2024 20:44:34
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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='More data about announcements, including localized properties like names and contents.';

-- ----------------------------
-- Records of announcement_settings
-- ----------------------------
BEGIN;
INSERT INTO `announcement_settings` (`announcement_setting_id`, `announcement_id`, `locale`, `setting_name`, `setting_value`) VALUES (1, 1, 'en', 'description', '<p><strong>Submission and Review Process:</strong></p>\n<p>All submissions will undergo a rigorous peer-review process to ensure high standards of quality and academic integrity. The initial editorial review will assess submissions for relevance to the journal\'s scope, originality, and adherence to submission guidelines. Submissions passing this stage will then be evaluated by independent reviewers in a double-blind peer review to maintain impartiality and ensure constructive feedback.</p>\n<p>Submissions must follow the journal’s Author Guidelines, including obtaining necessary permissions for included materials and ensuring ethical compliance. Authors are encouraged to ensure clarity in their research questions, methodology, and analysis to improve the likelihood of acceptance.</p>\n<p>We look forward to your contributions and to shaping this exciting inaugural issue together. Submit your manuscript and be a part of the PEACEE Journal’s debut edition!</p>');
INSERT INTO `announcement_settings` (`announcement_setting_id`, `announcement_id`, `locale`, `setting_name`, `setting_value`) VALUES (2, 1, 'en', 'descriptionShort', '<p>The PEACEE Journal is excited to announce its call for papers for the inaugural edition, scheduled for publication in January 2025. We invite researchers, practitioners, and academics to submit high-quality research articles that contribute to the fields of Electrical Engineering, Electronics Engineering, Mechatronics, Informatics, Industrial Automation, and Engineering Education.</p>\n<p><strong>Important Dates:</strong></p>\n<ul>\n<li><strong>Submission Deadline</strong>: October 31, 2024</li>\n<li><strong>Peer Review Process</strong>: November 2024</li>\n<li><strong>Final Decision</strong>: December 2024</li>\n<li><strong>Publication Date</strong>: January 2025</li>\n</ul>');
INSERT INTO `announcement_settings` (`announcement_setting_id`, `announcement_id`, `locale`, `setting_name`, `setting_value`) VALUES (3, 1, 'en', 'title', 'Call for Papers – Inaugural Edition, January 2025');
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Announcements are messages that can be presented to users e.g. on the homepage.';

-- ----------------------------
-- Records of announcements
-- ----------------------------
BEGIN;
INSERT INTO `announcements` (`announcement_id`, `assoc_type`, `assoc_id`, `type_id`, `date_expire`, `date_posted`) VALUES (1, 256, 1, NULL, '2024-12-31', '2024-11-01 12:20:52');
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
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='More data about authors, including localized properties such as their name and affiliation.';

-- ----------------------------
-- Records of author_settings
-- ----------------------------
BEGIN;
INSERT INTO `author_settings` (`author_setting_id`, `author_id`, `locale`, `setting_name`, `setting_value`) VALUES (5, 2, 'en', 'affiliation', 'BRIN');
INSERT INTO `author_settings` (`author_setting_id`, `author_id`, `locale`, `setting_name`, `setting_value`) VALUES (6, 2, 'en', 'biography', '');
INSERT INTO `author_settings` (`author_setting_id`, `author_id`, `locale`, `setting_name`, `setting_value`) VALUES (7, 2, '', 'country', 'ID');
INSERT INTO `author_settings` (`author_setting_id`, `author_id`, `locale`, `setting_name`, `setting_value`) VALUES (8, 2, 'en', 'familyName', '');
INSERT INTO `author_settings` (`author_setting_id`, `author_id`, `locale`, `setting_name`, `setting_value`) VALUES (9, 2, 'en', 'givenName', 'Aris');
INSERT INTO `author_settings` (`author_setting_id`, `author_id`, `locale`, `setting_name`, `setting_value`) VALUES (10, 2, '', 'orcid', '');
INSERT INTO `author_settings` (`author_setting_id`, `author_id`, `locale`, `setting_name`, `setting_value`) VALUES (11, 2, '', 'url', '');
INSERT INTO `author_settings` (`author_setting_id`, `author_id`, `locale`, `setting_name`, `setting_value`) VALUES (12, 3, 'en', 'affiliation', 'BRIN');
INSERT INTO `author_settings` (`author_setting_id`, `author_id`, `locale`, `setting_name`, `setting_value`) VALUES (13, 3, 'en', 'biography', '');
INSERT INTO `author_settings` (`author_setting_id`, `author_id`, `locale`, `setting_name`, `setting_value`) VALUES (14, 3, '', 'country', 'ID');
INSERT INTO `author_settings` (`author_setting_id`, `author_id`, `locale`, `setting_name`, `setting_value`) VALUES (15, 3, 'en', 'familyName', '');
INSERT INTO `author_settings` (`author_setting_id`, `author_id`, `locale`, `setting_name`, `setting_value`) VALUES (16, 3, 'en', 'givenName', 'Aris');
INSERT INTO `author_settings` (`author_setting_id`, `author_id`, `locale`, `setting_name`, `setting_value`) VALUES (17, 3, '', 'orcid', '');
INSERT INTO `author_settings` (`author_setting_id`, `author_id`, `locale`, `setting_name`, `setting_value`) VALUES (18, 3, '', 'url', '');
INSERT INTO `author_settings` (`author_setting_id`, `author_id`, `locale`, `setting_name`, `setting_value`) VALUES (19, 4, 'en', 'affiliation', 'UPI');
INSERT INTO `author_settings` (`author_setting_id`, `author_id`, `locale`, `setting_name`, `setting_value`) VALUES (20, 4, '', 'country', 'ID');
INSERT INTO `author_settings` (`author_setting_id`, `author_id`, `locale`, `setting_name`, `setting_value`) VALUES (21, 4, 'en', 'familyName', 'Raykarashy');
INSERT INTO `author_settings` (`author_setting_id`, `author_id`, `locale`, `setting_name`, `setting_value`) VALUES (22, 4, 'en', 'givenName', 'Athariz');
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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='The authors of a publication.';

-- ----------------------------
-- Records of authors
-- ----------------------------
BEGIN;
INSERT INTO `authors` (`author_id`, `email`, `include_in_browse`, `publication_id`, `seq`, `user_group_id`) VALUES (2, 'darisman08@gmail.com', 1, 2, 0.00, 14);
INSERT INTO `authors` (`author_id`, `email`, `include_in_browse`, `publication_id`, `seq`, `user_group_id`) VALUES (3, 'darisman08@gmail.com', 1, 3, 0.00, 14);
INSERT INTO `authors` (`author_id`, `email`, `include_in_browse`, `publication_id`, `seq`, `user_group_id`) VALUES (4, 'deasy.rde@bsi.ac.id', 1, 4, 0.00, 14);
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
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Every word or phrase used in a controlled vocabulary. Controlled vocabularies are used for submission metadata like keywords and subjects, reviewer interests, and wherever a similar dictionary of words or phrases is required. Each entry corresponds to a word or phrase like "cellular reproduction" and a type like "submissionKeyword".';

-- ----------------------------
-- Records of controlled_vocabs
-- ----------------------------
BEGIN;
INSERT INTO `controlled_vocabs` (`controlled_vocab_id`, `symbolic`, `assoc_type`, `assoc_id`) VALUES (1, 'interest', 0, 0);
INSERT INTO `controlled_vocabs` (`controlled_vocab_id`, `symbolic`, `assoc_type`, `assoc_id`) VALUES (6, 'submissionAgency', 1048588, 1);
INSERT INTO `controlled_vocabs` (`controlled_vocab_id`, `symbolic`, `assoc_type`, `assoc_id`) VALUES (11, 'submissionAgency', 1048588, 2);
INSERT INTO `controlled_vocabs` (`controlled_vocab_id`, `symbolic`, `assoc_type`, `assoc_id`) VALUES (16, 'submissionAgency', 1048588, 3);
INSERT INTO `controlled_vocabs` (`controlled_vocab_id`, `symbolic`, `assoc_type`, `assoc_id`) VALUES (21, 'submissionAgency', 1048588, 4);
INSERT INTO `controlled_vocabs` (`controlled_vocab_id`, `symbolic`, `assoc_type`, `assoc_id`) VALUES (4, 'submissionDiscipline', 1048588, 1);
INSERT INTO `controlled_vocabs` (`controlled_vocab_id`, `symbolic`, `assoc_type`, `assoc_id`) VALUES (9, 'submissionDiscipline', 1048588, 2);
INSERT INTO `controlled_vocabs` (`controlled_vocab_id`, `symbolic`, `assoc_type`, `assoc_id`) VALUES (14, 'submissionDiscipline', 1048588, 3);
INSERT INTO `controlled_vocabs` (`controlled_vocab_id`, `symbolic`, `assoc_type`, `assoc_id`) VALUES (19, 'submissionDiscipline', 1048588, 4);
INSERT INTO `controlled_vocabs` (`controlled_vocab_id`, `symbolic`, `assoc_type`, `assoc_id`) VALUES (2, 'submissionKeyword', 1048588, 1);
INSERT INTO `controlled_vocabs` (`controlled_vocab_id`, `symbolic`, `assoc_type`, `assoc_id`) VALUES (7, 'submissionKeyword', 1048588, 2);
INSERT INTO `controlled_vocabs` (`controlled_vocab_id`, `symbolic`, `assoc_type`, `assoc_id`) VALUES (12, 'submissionKeyword', 1048588, 3);
INSERT INTO `controlled_vocabs` (`controlled_vocab_id`, `symbolic`, `assoc_type`, `assoc_id`) VALUES (17, 'submissionKeyword', 1048588, 4);
INSERT INTO `controlled_vocabs` (`controlled_vocab_id`, `symbolic`, `assoc_type`, `assoc_id`) VALUES (5, 'submissionLanguage', 1048588, 1);
INSERT INTO `controlled_vocabs` (`controlled_vocab_id`, `symbolic`, `assoc_type`, `assoc_id`) VALUES (10, 'submissionLanguage', 1048588, 2);
INSERT INTO `controlled_vocabs` (`controlled_vocab_id`, `symbolic`, `assoc_type`, `assoc_id`) VALUES (15, 'submissionLanguage', 1048588, 3);
INSERT INTO `controlled_vocabs` (`controlled_vocab_id`, `symbolic`, `assoc_type`, `assoc_id`) VALUES (20, 'submissionLanguage', 1048588, 4);
INSERT INTO `controlled_vocabs` (`controlled_vocab_id`, `symbolic`, `assoc_type`, `assoc_id`) VALUES (3, 'submissionSubject', 1048588, 1);
INSERT INTO `controlled_vocabs` (`controlled_vocab_id`, `symbolic`, `assoc_type`, `assoc_id`) VALUES (8, 'submissionSubject', 1048588, 2);
INSERT INTO `controlled_vocabs` (`controlled_vocab_id`, `symbolic`, `assoc_type`, `assoc_id`) VALUES (13, 'submissionSubject', 1048588, 3);
INSERT INTO `controlled_vocabs` (`controlled_vocab_id`, `symbolic`, `assoc_type`, `assoc_id`) VALUES (18, 'submissionSubject', 1048588, 4);
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Editorial decisions recorded on a submission, such as decisions to accept or decline the submission, as well as decisions to send for review, send to copyediting, request revisions, and more.';

-- ----------------------------
-- Records of edit_decisions
-- ----------------------------
BEGIN;
INSERT INTO `edit_decisions` (`edit_decision_id`, `submission_id`, `review_round_id`, `stage_id`, `round`, `editor_id`, `decision`, `date_decided`) VALUES (2, 3, NULL, 1, NULL, 1, 8, '2024-11-02 14:30:03');
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
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='A record of email messages that are sent in relation to an associated entity, such as a submission.';

-- ----------------------------
-- Records of email_log
-- ----------------------------
BEGIN;
INSERT INTO `email_log` (`log_id`, `assoc_type`, `assoc_id`, `sender_id`, `date_sent`, `event_type`, `from_address`, `recipients`, `cc_recipients`, `bcc_recipients`, `subject`, `body`) VALUES (5, 1048585, 2, 0, '2024-11-02 12:00:09', 805306373, '\"R. Deasy Mandasari\" <deasy@upi.edu>', '\"Editorial Team PEACEE\" <deewahyu@upi.edu>', '', '', 'A new submission needs an editor to be assigned: Capasitors', '<p>Dear Editorial Team PEACEE,</p><p>The following submission has been submitted and there is no editor assigned.</p><p><a href=\"https://peacee.id/index.php/journal/workflow/access/2\">Capasitors</a><br />Aris</p><p><b>Abstract</b></p><p>Abstract</p><p>Please assign an editor who will be responsible for the submission by clicking the title above and assigning an editor under the Participants section.</p><hr><p>This is an automated email from <a href=\"https://peacee.id/index.php/journal\">Progress in Electrical and Computer Engineering Education</a>.</p>');
INSERT INTO `email_log` (`log_id`, `assoc_type`, `assoc_id`, `sender_id`, `date_sent`, `event_type`, `from_address`, `recipients`, `cc_recipients`, `bcc_recipients`, `subject`, `body`) VALUES (6, 1048585, 2, 0, '2024-11-02 12:00:11', 805306373, '\"R. Deasy Mandasari\" <deasy@upi.edu>', '\"R Deasy Mandasari\" <deasy@upi.edu>', '', '', 'A new submission needs an editor to be assigned: Capasitors', '<p>Dear R Deasy Mandasari,</p><p>The following submission has been submitted and there is no editor assigned.</p><p><a href=\"https://peacee.id/index.php/journal/workflow/access/2\">Capasitors</a><br />Aris</p><p><b>Abstract</b></p><p>Abstract</p><p>Please assign an editor who will be responsible for the submission by clicking the title above and assigning an editor under the Participants section.</p><hr><p>This is an automated email from <a href=\"https://peacee.id/index.php/journal\">Progress in Electrical and Computer Engineering Education</a>.</p>');
INSERT INTO `email_log` (`log_id`, `assoc_type`, `assoc_id`, `sender_id`, `date_sent`, `event_type`, `from_address`, `recipients`, `cc_recipients`, `bcc_recipients`, `subject`, `body`) VALUES (7, 1048585, 2, 0, '2024-11-02 12:00:12', 536870914, '\"R. Deasy Mandasari\" <deasy@upi.edu>', '\"Aris\" <darisman08@gmail.com>', '', '', 'Thank you for your submission to Progress in Electrical and Computer Engineering Education', '<p>Dear Aris,</p><p>Thank you for your submission to Progress in Electrical and Computer Engineering Education. We have received your submission, Capasitors, and a member of our editorial team will see it soon. You will be sent an email when an initial decision is made, and we may contact you for further information.</p><p>You can view your submission and track its progress through the editorial process at the following location:</p><p>Submission URL: https://peacee.id/index.php/journal/authorDashboard/submission/2</p><p>If you have been logged out, you can login again with the username darisman.</p><p>If you have any questions, please contact me from your <a href=\"https://peacee.id/index.php/journal/authorDashboard/submission/2\">submission dashboard</a>.</p><p>Thank you for considering Progress in Electrical and Computer Engineering Education as a venue for your work.</p><p><strong>Best regards,</strong><br>The Editorial Team of PEACEE Journal<br><strong>PEACEE Journal</strong> – Progress in Electrical and Computer Engineering Education<br>Universitas Pendidikan Indonesia<br>Jl. Setiabudi 229, Isola, Bandung, INDONESIA<br>Email: <a>peacee@upi.edu</a><br>Website: <a href=\"http://peacee.id/index.php/journal/index\">http://peacee.id/index.php/journal/index</a></p>\n<p><em>This message was sent automatically by the PEACEE Journal system. Please do not reply directly to this email. For further inquiries, contact us at <a>peacee@upi.edu</a>.</em></p>');
INSERT INTO `email_log` (`log_id`, `assoc_type`, `assoc_id`, `sender_id`, `date_sent`, `event_type`, `from_address`, `recipients`, `cc_recipients`, `bcc_recipients`, `subject`, `body`) VALUES (8, 1048585, 3, 0, '2024-11-02 13:16:51', 805306373, '\"Editorial Team\" <deasy@upi.edu>', '\"Editorial Team PEACEE\" <deewahyu@upi.edu>', '', '', 'A new submission needs an editor to be assigned: Resistors', '<p>Dear Editorial Team PEACEE,</p><p>The following submission has been submitted and there is no editor assigned.</p><p><a href=\"https://peacee.id/index.php/journal/workflow/access/3\">Resistors</a><br />Aris</p><p><b>Abstract</b></p><p>Abstract</p><p>Please assign an editor who will be responsible for the submission by clicking the title above and assigning an editor under the Participants section.</p><hr><p>This is an automated email from <a href=\"https://peacee.id/index.php/journal\">Progress in Electrical and Computer Engineering Education</a>.</p>');
INSERT INTO `email_log` (`log_id`, `assoc_type`, `assoc_id`, `sender_id`, `date_sent`, `event_type`, `from_address`, `recipients`, `cc_recipients`, `bcc_recipients`, `subject`, `body`) VALUES (9, 1048585, 3, 0, '2024-11-02 13:16:52', 805306373, '\"Editorial Team\" <deasy@upi.edu>', '\"R Deasy Mandasari\" <deasy@upi.edu>', '', '', 'A new submission needs an editor to be assigned: Resistors', '<p>Dear R Deasy Mandasari,</p><p>The following submission has been submitted and there is no editor assigned.</p><p><a href=\"https://peacee.id/index.php/journal/workflow/access/3\">Resistors</a><br />Aris</p><p><b>Abstract</b></p><p>Abstract</p><p>Please assign an editor who will be responsible for the submission by clicking the title above and assigning an editor under the Participants section.</p><hr><p>This is an automated email from <a href=\"https://peacee.id/index.php/journal\">Progress in Electrical and Computer Engineering Education</a>.</p>');
INSERT INTO `email_log` (`log_id`, `assoc_type`, `assoc_id`, `sender_id`, `date_sent`, `event_type`, `from_address`, `recipients`, `cc_recipients`, `bcc_recipients`, `subject`, `body`) VALUES (10, 1048585, 3, 0, '2024-11-02 13:16:54', 536870914, '\"Editorial Team\" <deasy@upi.edu>', '\"Aris\" <darisman08@gmail.com>', '', '', 'Thank you for your submission to Progress in Electrical and Computer Engineering Education', '<p>Dear Aris,</p><p>Thank you for your submission to Progress in Electrical and Computer Engineering Education. We have received your submission, Resistors, and a member of our editorial team will see it soon. You will be sent an email when an initial decision is made, and we may contact you for further information.</p><p>You can view your submission and track its progress through the editorial process at the following location:</p><p>Submission URL: https://peacee.id/index.php/journal/authorDashboard/submission/3</p><p>If you have been logged out, you can login again with the username darisman.</p><p>If you have any questions, please contact me from your <a href=\"https://peacee.id/index.php/journal/authorDashboard/submission/3\">submission dashboard</a>.</p><p>Thank you for considering Progress in Electrical and Computer Engineering Education as a venue for your work.</p><p><strong>Best regards,</strong><br>The Editorial Team of PEACEE Journal<br><strong>PEACEE Journal</strong> – Progress in Electrical and Computer Engineering Education<br>Universitas Pendidikan Indonesia<br>Jl. Setiabudi 229, Isola, Bandung, INDONESIA<br>Email: <a>peacee@upi.edu</a><br>Website: <a href=\"http://peacee.id/index.php/journal/index\">http://peacee.id/index.php/journal/index</a></p>\n<p><em>This message was sent automatically by the PEACEE Journal system. Please do not reply directly to this email. For further inquiries, contact us at <a>peacee@upi.edu</a>.</em></p>');
INSERT INTO `email_log` (`log_id`, `assoc_type`, `assoc_id`, `sender_id`, `date_sent`, `event_type`, `from_address`, `recipients`, `cc_recipients`, `bcc_recipients`, `subject`, `body`) VALUES (11, 1048585, 3, 1, '2024-11-02 14:30:07', 805306369, '\"Editorial Team PEACEE\" <deewahyu@upi.edu>', '\"Aris\" <darisman08@gmail.com>', '', '', 'Your submission has been declined', '<p>Dear Aris,</p><p>I’m sorry to inform you that, after reviewing your submission, Resistors, the editor has found that it does not meet our requirements for publication in Progress in Electrical and Computer Engineering Education.</p><p>I wish you success if you consider submitting your work elsewhere.</p><p>Kind regards,</p><p>Editorial Team PEACEE</p>');
INSERT INTO `email_log` (`log_id`, `assoc_type`, `assoc_id`, `sender_id`, `date_sent`, `event_type`, `from_address`, `recipients`, `cc_recipients`, `bcc_recipients`, `subject`, `body`) VALUES (12, 1048585, 4, 0, '2024-11-07 01:45:19', 805306373, '\"Editorial Team PEACEE\" <deasy@upi.edu>', '\"Editorial Team PEACEE\" <deewahyu@upi.edu>', '', '', 'A new submission needs an editor to be assigned: Artificial Intelligence', '<p>Dear Editorial Team PEACEE,</p><p>The following submission has been submitted and there is no editor assigned.</p><p><a href=\"https://peacee.id/index.php/journal/workflow/access/4\">Artificial Intelligence</a><br />Athariz Raykarashy</p><p><b>Abstract</b></p><p>Testing</p><p>Please assign an editor who will be responsible for the submission by clicking the title above and assigning an editor under the Participants section.</p><hr><p>This is an automated email from <a href=\"https://peacee.id/index.php/journal\">Progress in Electrical and Computer Engineering Education</a>.</p>');
INSERT INTO `email_log` (`log_id`, `assoc_type`, `assoc_id`, `sender_id`, `date_sent`, `event_type`, `from_address`, `recipients`, `cc_recipients`, `bcc_recipients`, `subject`, `body`) VALUES (13, 1048585, 4, 0, '2024-11-07 01:45:20', 805306373, '\"Editorial Team PEACEE\" <deasy@upi.edu>', '\"R Deasy Mandasari\" <deasy@upi.edu>', '', '', 'A new submission needs an editor to be assigned: Artificial Intelligence', '<p>Dear R Deasy Mandasari,</p><p>The following submission has been submitted and there is no editor assigned.</p><p><a href=\"https://peacee.id/index.php/journal/workflow/access/4\">Artificial Intelligence</a><br />Athariz Raykarashy</p><p><b>Abstract</b></p><p>Testing</p><p>Please assign an editor who will be responsible for the submission by clicking the title above and assigning an editor under the Participants section.</p><hr><p>This is an automated email from <a href=\"https://peacee.id/index.php/journal\">Progress in Electrical and Computer Engineering Education</a>.</p>');
INSERT INTO `email_log` (`log_id`, `assoc_type`, `assoc_id`, `sender_id`, `date_sent`, `event_type`, `from_address`, `recipients`, `cc_recipients`, `bcc_recipients`, `subject`, `body`) VALUES (14, 1048585, 4, 0, '2024-11-07 01:45:21', 536870914, '\"Editorial Team PEACEE\" <deasy@upi.edu>', '\"Athariz Raykarashy\" <deasy.rde@bsi.ac.id>', '', '', 'Thank you for your submission to Progress in Electrical and Computer Engineering Education', '<p>Dear Athariz Raykarashy,</p><p>Thank you for your submission to Progress in Electrical and Computer Engineering Education. We have received your submission, Artificial Intelligence, and a member of our editorial team will see it soon. You will be sent an email when an initial decision is made, and we may contact you for further information.</p><p>You can view your submission and track its progress through the editorial process at the following location:</p><p>Submission URL: https://peacee.id/index.php/journal/authorDashboard/submission/4</p><p>If you have been logged out, you can login again with the username deasy-rde.</p><p>If you have any questions, please contact me from your <a href=\"https://peacee.id/index.php/journal/authorDashboard/submission/4\">submission dashboard</a>.</p><p>Thank you for considering Progress in Electrical and Computer Engineering Education as a venue for your work.</p><p><strong>Best regards,</strong><br>The Editorial Team of PEACEE Journal<br><strong>PEACEE Journal</strong> – Progress in Electrical and Computer Engineering Education<br>Universitas Pendidikan Indonesia<br>Jl. Setiabudi 229, Isola, Bandung, INDONESIA<br>Email: <a>peacee@upi.edu</a><br>Website: <a href=\"http://peacee.id/index.php/journal/index\">http://peacee.id/index.php/journal/index</a></p>\n<p><em>This message was sent automatically by the PEACEE Journal system. Please do not reply directly to this email. For further inquiries, contact us at <a>peacee@upi.edu</a>.</em></p>');
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
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='A record of users associated with an email log entry.';

-- ----------------------------
-- Records of email_log_users
-- ----------------------------
BEGIN;
INSERT INTO `email_log_users` (`email_log_user_id`, `email_log_id`, `user_id`) VALUES (5, 5, 1);
INSERT INTO `email_log_users` (`email_log_user_id`, `email_log_id`, `user_id`) VALUES (6, 6, 4);
INSERT INTO `email_log_users` (`email_log_user_id`, `email_log_id`, `user_id`) VALUES (7, 7, 5);
INSERT INTO `email_log_users` (`email_log_user_id`, `email_log_id`, `user_id`) VALUES (8, 8, 1);
INSERT INTO `email_log_users` (`email_log_user_id`, `email_log_id`, `user_id`) VALUES (9, 9, 4);
INSERT INTO `email_log_users` (`email_log_user_id`, `email_log_id`, `user_id`) VALUES (10, 10, 5);
INSERT INTO `email_log_users` (`email_log_user_id`, `email_log_id`, `user_id`) VALUES (11, 11, 5);
INSERT INTO `email_log_users` (`email_log_user_id`, `email_log_id`, `user_id`) VALUES (12, 12, 1);
INSERT INTO `email_log_users` (`email_log_user_id`, `email_log_id`, `user_id`) VALUES (13, 13, 4);
INSERT INTO `email_log_users` (`email_log_user_id`, `email_log_id`, `user_id`) VALUES (14, 14, 7);
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
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Custom email templates created by each context, and overrides of the default templates.';

-- ----------------------------
-- Records of email_templates
-- ----------------------------
BEGIN;
INSERT INTO `email_templates` (`email_id`, `email_key`, `context_id`, `alternate_to`) VALUES (8, 'COPYEDIT_REQUEST', 1, 'DISCUSSION_NOTIFICATION_COPYEDITING');
INSERT INTO `email_templates` (`email_id`, `email_key`, `context_id`, `alternate_to`) VALUES (9, 'EDITOR_ASSIGN_SUBMISSION', 1, 'DISCUSSION_NOTIFICATION_SUBMISSION');
INSERT INTO `email_templates` (`email_id`, `email_key`, `context_id`, `alternate_to`) VALUES (10, 'EDITOR_ASSIGN_REVIEW', 1, 'DISCUSSION_NOTIFICATION_REVIEW');
INSERT INTO `email_templates` (`email_id`, `email_key`, `context_id`, `alternate_to`) VALUES (11, 'EDITOR_ASSIGN_PRODUCTION', 1, 'DISCUSSION_NOTIFICATION_PRODUCTION');
INSERT INTO `email_templates` (`email_id`, `email_key`, `context_id`, `alternate_to`) VALUES (12, 'LAYOUT_REQUEST', 1, 'DISCUSSION_NOTIFICATION_PRODUCTION');
INSERT INTO `email_templates` (`email_id`, `email_key`, `context_id`, `alternate_to`) VALUES (13, 'LAYOUT_COMPLETE', 1, 'DISCUSSION_NOTIFICATION_PRODUCTION');
INSERT INTO `email_templates` (`email_id`, `email_key`, `context_id`, `alternate_to`) VALUES (14, 'USER_REGISTER', 1, NULL);
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
) ENGINE=InnoDB AUTO_INCREMENT=346 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Default email templates created for every installed locale.';

-- ----------------------------
-- Records of email_templates_default_data
-- ----------------------------
BEGIN;
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (139, 'PASSWORD_RESET_CONFIRM', 'en', 'Password Reset Confirm', 'Password Reset Confirmation', 'We have received a request to reset your password for the {$siteTitle} web site.<br />\n<br />\nIf you did not make this request, please ignore this email and your password will not be changed. If you wish to reset your password, click on the below URL.<br />\n<br />\nReset my password: {$passwordResetUrl}<br />\n<br />\n{$siteContactName}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (140, 'USER_REGISTER', 'en', 'User Created', 'Journal Registration', '{$recipientName}<br />\n<br />\nYou have now been registered as a user with {$journalName}. We have included your username and password in this email, which are needed for all work with this journal through its website. At any point, you can ask to be removed from the journal\'s list of users by contacting me.<br />\n<br />\nUsername: {$recipientUsername}<br />\nPassword: {$password}<br />\n<br />\nThank you,<br />\n{$signature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (141, 'USER_VALIDATE_CONTEXT', 'en', 'Validate Email (Journal Registration)', 'Validate Your Account', '{$recipientName}<br />\n<br />\nYou have created an account with {$journalName}, but before you can start using it, you need to validate your email account. To do this, simply follow the link below:<br />\n<br />\n{$activateUrl}<br />\n<br />\nThank you,<br />\n{$journalSignature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (142, 'USER_VALIDATE_SITE', 'en', 'Validate Email (Site)', 'Validate Your Account', '{$recipientName}<br />\n<br />\nYou have created an account with {$siteTitle}, but before you can start using it, you need to validate your email account. To do this, simply follow the link below:<br />\n<br />\n{$activateUrl}<br />\n<br />\nThank you,<br />\n{$siteSignature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (143, 'REVIEWER_REGISTER', 'en', 'Reviewer Register', 'Registration as Reviewer with {$journalName}', '<p>Dear {$recipientName},</p><p>In light of your expertise, we have registered your name in the reviewer database for {$journalName}. This does not entail any form of commitment on your part, but simply enables us to approach you with a submission to possibly review. On being invited to review, you will have an opportunity to see the title and abstract of the paper in question, and you\'ll always be in a position to accept or decline the invitation. You can also ask at any point to have your name removed from this reviewer list.</p><p>We are providing you with a username and password, which is used in all interactions with the journal through its website. You may wish, for example, to update your profile, including your reviewing interests.</p><p>Username: {$recipientUsername}<br />Password: {$password}</p><p>Thank you,</p>{$signature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (144, 'ISSUE_PUBLISH_NOTIFY', 'en', 'Issue Published Notify', 'Just published: {$issueIdentification} of {$journalName}', '<p>Dear {$recipientName},</p><p>We are pleased to announce the publication of <a href=\"{$issueUrl}\">{$issueIdentification}</a> of {$journalName}.  We invite you to read and share this work with your scholarly community.</p><p>Many thanks to our authors, reviewers, and editors for their valuable contributions, and to our readers for your continued interest.</p><p>Thank you,</p>{$signature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (145, 'SUBMISSION_ACK', 'en', 'Submission Confirmation', 'Thank you for your submission to {$journalName}', '<p>Dear {$recipientName},</p><p>Thank you for your submission to {$journalName}. We have received your submission, {$submissionTitle}, and a member of our editorial team will see it soon. You will be sent an email when an initial decision is made, and we may contact you for further information.</p><p>You can view your submission and track its progress through the editorial process at the following location:</p><p>Submission URL: {$authorSubmissionUrl}</p><p>If you have been logged out, you can login again with the username {$recipientUsername}.</p><p>If you have any questions, please contact me from your <a href=\"{$authorSubmissionUrl}\">submission dashboard</a>.</p><p>Thank you for considering {$journalName} as a venue for your work.</p>{$journalSignature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (146, 'SUBMISSION_ACK_NOT_USER', 'en', 'Submission Confirmation (Other Authors)', 'Submission confirmation', '<p>Dear {$recipientName},</p><p>You have been named as a co-author on a submission to {$journalName}. The submitter, {$submitterName}, provided the following details:</p><p>{$submissionTitle}<br>{$authorsWithAffiliation}</p><p>If any of these details are incorrect, or you do not wish to be named on this submission, please contact me.</p><p>Thank you for considering {$journalName} as a venue for your work.</p><p>Kind regards,</p>{$journalSignature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (147, 'EDITOR_ASSIGN', 'en', 'Editor Assigned', 'You have been assigned as an editor on a submission to {$journalName}', '<p>Dear {$recipientName},</p><p>The following submission has been assigned to you to see through the editorial process.</p><p><a href=\"{$submissionUrl}\">{$submissionTitle}</a><br />{$authors}</p><p><b>Abstract</b></p>{$submissionAbstract}<p>If you find the submission to be relevant for {$journalName}, please forward the submission to the review stage by selecting \"Send to Review\" and then assign reviewers by clicking \"Add Reviewer\".</p><p>If the submission is not appropriate for this journal, please decline the submission.</p><p>Thank you in advance.</p><p>Kind regards,</p>{$journalSignature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (148, 'REVIEW_CANCEL', 'en', 'Reviewer Unassign', 'Request for Review Cancelled', '<p>Dear {$recipientName},</p><p>Recently, we asked you to review a submission to {$journalName}. We have decided to cancel the request for you to reivew the submission, {$submissionTitle}.</p><p>We apologize any inconvenience this may cause you and hope that we will be able to call on you to assist with this journal\'s review process in the future.</p><p>If you have any questions, please contact me.</p>{$signature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (149, 'REVIEW_REINSTATE', 'en', 'Reviewer Reinstate', 'Can you still review something for {$journalName}?', '<p>Dear {$recipientName},</p><p>We recently cancelled our request for you to review a submission, {$submissionTitle}, for {$journalName}. We\'ve reversed that decision and we hope that you are still able to conduct the review.</p><p>If you are able to assist with this submission\'s review, you can <a href=\"{$reviewAssignmentUrl}\">login to the journal</a> to view the submission, upload review files, and submit your review request.</p><p>If you have any questions, please contact me.</p><p>Kind regards,</p>{$signature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (150, 'REVIEW_RESEND_REQUEST', 'en', 'Resend Review Request to Reviewer', 'Requesting your review again for {$journalName}', '<p>Dear {$recipientName},</p><p>Recently, you declined our request to review a submission, {$submissionTitle}, for {$journalName}. I\'m writing to see if you are able to conduct the review after all.</p><p>We would be grateful if you\'re able to perform this review, but we understand if that is not possible at this time. Either way, please <a href=\"{$reviewAssignmentUrl}\">accept or decline the request</a> by {$responseDueDate}, so that we can find an alternate reviewer.</p><p>If you have any questions, please contact me.</p><p>Kind regards,</p>{$signature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (151, 'REVIEW_REQUEST', 'en', 'Review Request', 'Invitation to review', '<p>Dear {$recipientName},</p><p>I believe that you would serve as an excellent reviewer for a submission  to {$journalName}. The submission\'s title and abstract are below, and I hope that you will consider undertaking this important task for us.</p><p>If you are able to review this submission, your review is due by {$reviewDueDate}. You can view the submission, upload review files, and submit your review by logging into the journal site and following the steps at the link below.</p><p><a href=\"{$reviewAssignmentUrl}\">{$submissionTitle}</a></p><p><b>Abstract</b></p>{$submissionAbstract}<p>Please <a href=\"{$reviewAssignmentUrl}\">accept or decline</a> the review by <b>{$responseDueDate}</b>.</p><p>You may contact me with any questions about the submission or the review process.</p><p>Thank you for considering this request. Your help is much appreciated.</p><p>Kind regards,</p>{$signature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (152, 'REVIEW_REQUEST_SUBSEQUENT', 'en', 'Review Request Subsequent', 'Request to review a revised submission', '<p>Dear {$recipientName},</p><p>Thank you for your review of <a href=\"{$reviewAssignmentUrl}\">{$submissionTitle}</a>. The authors have considered the reviewers\' feedback and have now submitted a revised version of their work. I\'m writing to ask if you would conduct a second round of peer review for this submission.</p><p>If you are able to review this submission, your review is due by {$reviewDueDate}. You can <a href=\"{$reviewAssignmentUrl}\">follow the review steps</a> to view the submission, upload review files, and submit your review comments.<p><p><a href=\"{$reviewAssignmentUrl}\">{$submissionTitle}</a></p><p><b>Abstract</b></p>{$submissionAbstract}<p>Please <a href=\"{$reviewAssignmentUrl}\">accept or decline</a> the review by <b>{$responseDueDate}</b>.</p><p>Please feel free to contact me with any questions about the submission or the review process.</p><p>Thank you for considering this request. Your help is much appreciated.</p><p>Kind regards,</p>{$signature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (153, 'REVIEW_RESPONSE_OVERDUE_AUTO', 'en', 'Review Response Overdue (Automated)', 'Will you be able to review this for us?', '<p>Dear {$recipientName},</p><p>This email is an automated reminder from {$journalName} in regards to our request for your review of the submission, \"{$submissionTitle}.\"</p><p>You are receiving this email because we have not yet received a confirmation from you indicating whether or not you are able to undertake the review of this submission.</p><p>Please let us know whether or not you are able to undertake this review by using our submission management software to accept or decline this request.</p><p>If you are able to review this submission, your review is due by {$reviewDueDate}. You can follow the review steps to view the submission, upload review files, and submit your review comments.</p><p><a href=\"{$reviewAssignmentUrl}\">{$submissionTitle}</a></p><p><b>Abstract</b></p>{$submissionAbstract}<p>Please feel free to contact me with any questions about the submission or the review process.</p><p>Thank you for considering this request. Your help is much appreciated.</p><p>Kind regards,</p>{$journalSignature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (154, 'REVIEW_CONFIRM', 'en', 'Review Confirm', 'Review accepted: {$reviewerName} accepted review assignment for #{$submissionId} {$authorsShort} — {$submissionTitle}', '<p>Dear {$recipientName},</p><p>{$reviewerName} has accepted the following review:</p><p><a href=\"{$submissionUrl}\">#{$submissionId} {$authorsShort} — {$submissionTitle}</a><br /><b>Type:</b> {$reviewMethod}</p><p><b>Review Due:</b> {$reviewDueDate}</p><p>Login to <a href=\"{$submissionUrl}\">view all reviewer assignments</a> for this submission.</p><br><br>—<br>This is an automated message from <a href=\"{$journalUrl}\">{$journalName}</a>.');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (155, 'REVIEW_DECLINE', 'en', 'Review Decline', 'Unable to Review', 'Editors:<br />\n<br />\nI am afraid that at this time I am unable to review the submission, &quot;{$submissionTitle},&quot; for {$journalName}. Thank you for thinking of me, and another time feel free to call on me.<br />\n<br />\n{$senderName}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (156, 'REVIEW_ACK', 'en', 'Review Acknowledgement', 'Thank you for your review', '<p>Dear {$recipientName},</p>\n<p>Thank you for completing your review of the submission, {$submissionTitle}, for {$journalName}. We appreciate your time and expertise in contributing to the quality of the work that we publish.</p>\n<p>It has been a pleasure to work with you as a reviewer for {$journalName}, and we hope to have the opportunity to work with you again in the future.</p>\n<p>Kind regards,</p>\n<p>{$signature}</p>');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (157, 'REVIEW_REMIND', 'en', 'Review Reminder', 'A reminder to please complete your review', '<p>Dear {$recipientName},</p><p>Just a gentle reminder of our request for your review of the submission, \"{$submissionTitle},\" for {$journalName}. We were expecting to have this review by {$reviewDueDate} and we would be pleased to receive it as soon as you are able to prepare it.</p><p>You can <a href=\"{$reviewAssignmentUrl}\">login to the journal</a> and follow the review steps to view the submission, upload review files, and submit your review comments.</p><p>If you need an extension of the deadline, please contact me. I look forward to hearing from you.</p><p>Thank you in advance and kind regards,</p>{$signature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (158, 'REVIEW_REMIND_AUTO', 'en', 'Review Reminder (Automated)', 'A reminder to please complete your review', '<p>Dear {$recipientName}:</p><p>This email is an automated reminder from {$journalName} in regards to our request for your review of the submission, \"{$submissionTitle}.\"</p><p>We were expecting to have this review by {$reviewDueDate} and we would be pleased to receive it as soon as you are able to prepare it.</p><p>Please <a href=\"{$reviewAssignmentUrl}\">login to the journal</a> and follow the review steps to view the submission, upload review files, and submit your review comments.</p><p>If you need an extension of the deadline, please contact me. I look forward to hearing from you.</p><p>Thank you in advance and kind regards,</p>{$journalSignature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (159, 'REVIEW_COMPLETE', 'en', 'Review Completed', 'Review complete: {$reviewerName} recommends {$reviewRecommendation} for #{$submissionId} {$authorsShort} — {$submissionTitle}', '<p>Dear {$recipientName},</p><p>{$reviewerName} completed the following review:</p><p><a href=\"{$submissionUrl}\">#{$submissionId} {$authorsShort} — {$submissionTitle}</a><br /><b>Recommendation:</b> {$reviewRecommendation}<br /><b>Type:</b> {$reviewMethod}</p><p>Login to <a href=\"{$submissionUrl}\">view all files and comments</a> provided by this reviewer.</p>');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (160, 'REVIEW_EDIT', 'en', 'Review Edited', 'Your review assignment has been changed for {$journalName}', '<p>Dear {$recipientName},</p><p>An editor has made changes to your review assignment for {$journalName}. Please review the details below and let us know if you have any questions.</p><p><a href=\"{$reviewAssignmentUrl}\">{$submissionTitle}</a><br /><b>Type:</b> {$reviewMethod}<br /><b>Accept or Decline By:</b> {$responseDueDate}<br /><b>Submit Review By:</b> {$reviewDueDate}</p><p>You can login to <a href=\"{$reviewAssignmentUrl}\">complete this review</a> at any time.</p>');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (161, 'EDITOR_DECISION_ACCEPT', 'en', 'Submission Accepted', 'Your submission has been accepted to {$journalName}', '<p>Dear {$recipientName},</p><p>I am pleased to inform you that we have decided to accept your submission without further revision. After careful review, we found your submission, {$submissionTitle}, to meet or exceed our expectations. We are excited to publish your piece in {$journalName} and we thank you for choosing our journal as a venue for your work.</p><p>Your submission is now forthcoming in a future issue of {$journalName} and you are welcome to include it in your list of publications. We recognize the hard work that goes into every successful submission and we want to congratulate you on reaching this stage.</p><p>Your submission will now undergo copy editing and formatting to prepare it for publication.</p><p>You will shortly receive further instructions.</p><p>If you have any questions, please contact me from your <a href=\"{$authorSubmissionUrl}\">submission dashboard</a>.</p><p>Kind regards,</p>{$signature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (162, 'EDITOR_DECISION_SEND_TO_EXTERNAL', 'en', 'Sent to Review', 'Your submission has been sent for review', '<p>Dear {$recipientName},</p><p>I am pleased to inform you that an editor has reviewed your submission, {$submissionTitle}, and has decided to send it for peer review. An editor will identify qualified reviewers who will provide feedback on your submission.</p><p>{$reviewTypeDescription} You will hear from us with feedback from the reviewers and information about the next steps.</p><p>Please note that sending the submission to peer review does not guarantee that it will be published. We will consider the reviewers\' recommendations before deciding to accept the submission for publication. You may be asked to make revisions and respond to the reviewers\' comments before a final decision is made.</p><p>If you have any questions, please contact me from your submission dashboard.</p><p>{$signature}</p>');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (163, 'EDITOR_DECISION_SEND_TO_PRODUCTION', 'en', 'Sent to Production', 'Next steps for publishing your submission', '<p>Dear {$recipientName},</p><p>I am writing from {$journalName} to let you know that the editing of your submission, {$submissionTitle}, is complete. Your submission will now advance to the production stage, where the final galleys will be prepared for publication. We will contact you if we need any further assistance.</p><p>If you have any questions, please contact me from your <a href=\"{$authorSubmissionUrl}\">submission dashboard</a>.</p><p>Kind regards,</p>{$signature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (164, 'EDITOR_DECISION_REVISIONS', 'en', 'Revisions Requested', 'Your submission has been reviewed and we encourage you to submit revisions', '<p>Dear {$recipientName},</p><p>Your submission {$submissionTitle} has been reviewed and we would like to encourage you to submit revisions that address the reviewers\' comments. An editor will review these revisions and if they address the concerns adequately, your submission may be accepted for publication.</p><p>The reviewers\' comments are included at the bottom of this email. Please respond to each point in the reviewers\' comments and identify what changes you have made. If you find any of the reviewer\'s comments to be unjustified or inappropriate, please explain your perspective.</p><p>When you have completed your revisions, you can upload revised documents along with your response to the reviewers\' comments at your <a href=\"{$authorSubmissionUrl}\">submission dashboard</a>. If you have been logged out, you can login again with the username {$recipientUsername}.</p><p>If you have any questions, please contact me from your <a href=\"{$authorSubmissionUrl}\">submission dashboard</a>.</p><p>We look forward to receiving your revised submission.</p><p>Kind regards,</p>{$signature}<hr><p>The following comments were received from reviewers.</p>{$allReviewerComments}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (165, 'EDITOR_DECISION_RESUBMIT', 'en', 'Resubmit for Review', 'Your submission has been reviewed - please revise and resubmit', '<p>Dear {$recipientName},</p><p>After reviewing your submission, {$submissionTitle}, the reviewers have recommended that your submission cannot be accepted for publication in its current form. However, we would like to encourage you to submit a revised version that addresses the reviewers\' comments. Your revisions will be reviewed by an editor and may be sent out for another round of peer review.</p><p>Please note that resubmitting your work does not guarantee that it will be accepted.</p><p>The reviewers\' comments are included at the bottom of this email. Please respond to each point and identify what changes you have made. If you find any of the reviewer\'s comments inappropriate, please explain your perspective. If you have questions about the recommendations in your review, please include these in your response.</p><p>When you have completed your revisions, you can upload revised documents along with your response to the reviewers\' comments <a href=\"{$authorSubmissionUrl}\">at your submission dashboard</a>. If you have been logged out, you can login again with the username {$recipientUsername}.</p><p>If you have any questions, please contact me from your <a href=\"{$authorSubmissionUrl}\">submission dashboard</a>.</p><p>We look forward to receiving your revised submission.</p><p>Kind regards,</p>{$signature}<hr><p>The following comments were received from reviewers.</p>{$allReviewerComments}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (166, 'EDITOR_DECISION_DECLINE', 'en', 'Submission Declined', 'Your submission has been declined', '<p>Dear {$recipientName},</p><p>While we appreciate receiving your submission, we are unable to accept {$submissionTitle} for publication on the basis of the comments from reviewers.</p><p>The reviewers\' comments are included at the bottom of this email.</p><p>Thank you for submitting to {$journalName}. Although it is disappointing to have a submission declined, I hope you find the reviewers\' comments to be constructive and helpful.</p><p>You are now free to submit the work elsewhere if you choose to do so.</p><p>Kind regards,</p>{$signature}<hr><p>The following comments were received from reviewers.</p>{$allReviewerComments}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (167, 'EDITOR_DECISION_INITIAL_DECLINE', 'en', 'Submission Declined (Pre-Review)', 'Your submission has been declined', '<p>Dear {$recipientName},</p><p>I’m sorry to inform you that, after reviewing your submission, {$submissionTitle}, the editor has found that it does not meet our requirements for publication in {$journalName}.</p><p>I wish you success if you consider submitting your work elsewhere.</p><p>Kind regards,</p>{$signature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (168, 'EDITOR_RECOMMENDATION', 'en', 'Recommendation Made', 'Editor Recommendation', '<p>Dear {$recipientName},</p><p>After considering the reviewers\' feedback, I would like to make the following recommendation regarding the submission {$submissionTitle}.</p><p>My recommendation is: {$recommendation}.</p><p>Please visit the submission\'s <a href=\"{$submissionUrl}\">editorial workflow</a> to act on this recommendation.</p><p>Please feel free to contact me with any questions.</p><p>Kind regards,</p><p>{$senderName}</p>');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (169, 'EDITOR_DECISION_NOTIFY_OTHER_AUTHORS', 'en', 'Notify Other Authors', 'An update regarding your submission', '<p>The following email was sent to {$submittingAuthorName} from {$journalName} regarding {$submissionTitle}.</p>\n<p>You are receiving a copy of this notification because you are identified as an author of the submission. Any instructions in the message below are intended for the submitting author, {$submittingAuthorName}, and no action is required of you at this time.</p>\n\n{$messageToSubmittingAuthor}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (170, 'EDITOR_DECISION_NOTIFY_REVIEWERS', 'en', 'Notify Reviewers of Decision', 'Thank you for your review', '<p>Dear {$recipientName},</p>\n<p>Thank you for completing your review of the submission, {$submissionTitle}, for {$journalName}. We appreciate your time and expertise in contributing to the quality of the work that we publish. We have shared your comments with the authors, along with our other reviewers\' comments and the editor\'s decision.</p>\n<p>Based on the feedback we received, we have notified the authors of the following:</p>\n<p>{$decisionDescription}</p>\n<p>Your recommendation was considered alongside the recommendations of other reviewers before coming to a decision. Occasionally the editor\'s decision may differ from the recommendation made by one or more reviewers. The editor considers many factors, and does not take these decisions lightly. We are grateful for our reviewers\' expertise and suggestions.</p>\n<p>It has been a pleasure to work with you as a reviewer for {$journalName}, and we hope to have the opportunity to work with you again in the future.</p>\n<p>Kind regards,</p>\n<p>{$signature}</p>');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (171, 'EDITOR_DECISION_NEW_ROUND', 'en', 'New Review Round Initiated', 'Your submission has been sent for another round of review', '<p>Dear {$recipientName},</p>\n<p>Your revised submission, {$submissionTitle}, has been sent for a new round of peer review. \nYou will hear from us with feedback from the reviewers and information about the next steps.</p>\n<p>If you have any questions, please contact me from your <a href=\"{$authorSubmissionUrl}\">submission dashboard</a>.</p>\n<p>Kind regards,</p>\n<p>{$signature}</p>\n');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (172, 'EDITOR_DECISION_REVERT_DECLINE', 'en', 'Reinstate Declined Submission', 'We have reversed the decision to decline your submission', '<p>Dear {$recipientName},</p>\n<p>The decision to decline your submission, {$submissionTitle}, has been reversed. \nAn editor will complete the round of review and you will be notified when a \ndecision is made.</p>\n<p>Occasionally, a decision to decline a submission will be recorded accidentally in \nour system and must be reverted. I apologize for any confusion this may have caused.</p>\n<p>We will contact you if we need any further assistance.</p>\n<p>If you have any questions, please contact me from your <a href=\"{$authorSubmissionUrl}\">submission dashboard</a>.</p>\n<p>Kind regards,</p>\n<p>{$signature}</p>\n');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (173, 'EDITOR_DECISION_REVERT_INITIAL_DECLINE', 'en', 'Reinstate Submission Declined Without Review', 'We have reversed the decision to decline your submission', '<p>Dear {$recipientName},</p>\n<p>The decision to decline your submission, {$submissionTitle}, has been reversed. \nAn editor will look further at your submission before deciding whether to decline \nthe submission or send it for review.</p>\n<p>Occasionally, a decision to decline a submission will be recorded accidentally in \nour system and must be reverted. I apologize for any confusion this may have caused.</p>\n<p>We will contact you if we need any further assistance.</p>\n<p>If you have any questions, please contact me from your <a href=\"{$authorSubmissionUrl}\">submission dashboard</a>.</p>\n<p>Kind regards,</p>\n<p>{$signature}</p>\n');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (174, 'EDITOR_DECISION_SKIP_REVIEW', 'en', 'Submission Accepted (Without Review)', 'Your submission has been sent for copyediting', '<p>Dear {$recipientName},</p>\n<p>I am pleased to inform you that we have decided to accept your submission without peer review. We found your submission, {$submissionTitle}, to meet our expectations, and we do not require that work of this type undergo peer review. We are excited to publish your piece in {$journalName} and we thank you for choosing our journal as a venue for your work.</p>\nYour submission is now forthcoming in a future issue of {$journalName} and you are welcome to include it in your list of publications. We recognize the hard work that goes into every successful submission and we want to congratulate you on your efforts.</p>\n<p>Your submission will now undergo copy editing and formatting to prepare it for publication. </p>\n<p>You will shortly receive further instructions.</p>\n<p>If you have any questions, please contact me from your <a href=\"{$authorSubmissionUrl}\">submission dashboard</a>.</p>\n<p>Kind regards,</p>\n<p>{$signature}</p>\n');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (175, 'EDITOR_DECISION_BACK_FROM_PRODUCTION', 'en', 'Submission Sent Back to Copyediting', 'Your submission has been sent back to copyediting', '<p>Dear {$recipientName},</p><p>Your submission, {$submissionTitle}, has been sent back to the copyediting stage, where it will undergo further copyediting and formatting to prepare it for publication.</p><p>Occasionally, a submission is sent to the production stage before it is ready for the final galleys to be prepared for publication. Your submission is still forthcoming. I apologize for any confusion.</p><p>If you have any questions, please contact me from your <a href=\"{$authorSubmissionUrl}\">submission dashboard</a>.</p><p>We will contact you if we need any further assistance.</p><p>Kind regards,</p><p>{$signature}</p>');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (176, 'EDITOR_DECISION_BACK_FROM_COPYEDITING', 'en', 'Submission Sent Back from Copyediting', 'Your submission has been sent back to review', '<p>Dear {$recipientName},</p><p>Your submission, {$submissionTitle}, has been sent back to the review stage. It will undergo further review before it can be accepted for publication.</p><p>Occasionally, a decision to accept a submission will be recorded accidentally in our system and we must send it back to review. I apologize for any confusion this has caused. We will work to complete any further review quickly so that you have a final decision as soon as possible.</p><p>We will contact you if we need any further assistance.</p><p>If you have any questions, please contact me from your <a href=\"{$authorSubmissionUrl}\">submission dashboard</a>.</p><p>Kind regards,</p><p>{$signature}</p>');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (177, 'EDITOR_DECISION_CANCEL_REVIEW_ROUND', 'en', 'Review Round Cancelled', 'A review round for your submission has been cancelled', '<p>Dear {$recipientName},</p><p>We recently opened a new review round for your submission, {$submissionTitle}. We are closing this review round now.</p><p>Occasionally, a decision to open a round of review will be recorded accidentally in our system and we must cancel this review round. I apologize for any confusion this may have caused.</p><p>We will contact you if we need any further assistance.</p><p>If you have any questions, please contact me from your <a href=\"{$authorSubmissionUrl}\">submission dashboard</a>.</p><p>Kind regards,</p><p>{$signature}</p>');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (178, 'SUBSCRIPTION_NOTIFY', 'en', 'Subscription Notify', 'Subscription Notification', '{$recipientName}:<br />\n<br />\nYou have now been registered as a subscriber in our online journal management system for {$journalName}, with the following subscription:<br />\n<br />\n{$subscriptionType}<br />\n<br />\nTo access content that is available only to subscribers, simply log in to the system with your username, &quot;{$recipientUsername}&quot;.<br />\n<br />\nOnce you have logged in to the system you can change your profile details and password at any point.<br />\n<br />\nPlease note that if you have an institutional subscription, there is no need for users at your institution to log in, since requests for subscription content will be automatically authenticated by the system.<br />\n<br />\nIf you have any questions, please feel free to contact me.<br />\n<br />\n{$subscriptionSignature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (179, 'OPEN_ACCESS_NOTIFY', 'en', 'Open Access Notify', 'Free to read: {$issueIdentification} of {$journalName} is now open access', '<p>Dear {$recipientName},</p><p>We are pleased to inform you that <a href=\"{$issueUrl}\">{$issueIdentification}</a> of {$journalName} is now available under open access.  A subscription is no longer required to read this issue.</p><p>Thank you for your continuing interest in our work.</p>{$journalSignature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (180, 'SUBSCRIPTION_BEFORE_EXPIRY', 'en', 'Subscription Expires Soon', 'Notice of Subscription Expiry', '{$recipientName}:<br />\n<br />\nYour {$journalName} subscription is about to expire.<br />\n<br />\n{$subscriptionType}<br />\nExpiry date: {$expiryDate}<br />\n<br />\nTo ensure the continuity of your access to this journal, please go to the journal website and renew your subscription. You are able to log in to the system with your username, &quot;{$recipientUsername}&quot;.<br />\n<br />\nIf you have any questions, please feel free to contact me.<br />\n<br />\n{$subscriptionSignature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (181, 'SUBSCRIPTION_AFTER_EXPIRY', 'en', 'Subscription Expired', 'Subscription Expired', '{$recipientName}:<br />\n<br />\nYour {$journalName} subscription has expired.<br />\n<br />\n{$subscriptionType}<br />\nExpiry date: {$expiryDate}<br />\n<br />\nTo renew your subscription, please go to the journal website. You are able to log in to the system with your username, &quot;{$recipientUsername}&quot;.<br />\n<br />\nIf you have any questions, please feel free to contact me.<br />\n<br />\n{$subscriptionSignature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (182, 'SUBSCRIPTION_AFTER_EXPIRY_LAST', 'en', 'Subscription Expired Last', 'Subscription Expired - Final Reminder', '{$recipientName}:<br />\n<br />\nYour {$journalName} subscription has expired.<br />\nPlease note that this is the final reminder that will be emailed to you.<br />\n<br />\n{$subscriptionType}<br />\nExpiry date: {$expiryDate}<br />\n<br />\nTo renew your subscription, please go to the journal website. You are able to log in to the system with your username, &quot;{$recipientUsername}&quot;.<br />\n<br />\nIf you have any questions, please feel free to contact me.<br />\n<br />\n{$subscriptionSignature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (183, 'SUBSCRIPTION_PURCHASE_INDL', 'en', 'Purchase Individual Subscription', 'Subscription Purchase: Individual', 'An individual subscription has been purchased online for {$journalName} with the following details.<br />\n<br />\nSubscription Type:<br />\n{$subscriptionType}<br />\n<br />\nUser:<br />\n{$subscriberDetails}<br />\n<br />\nMembership Information (if provided):<br />\n{$membership}<br />\n<br />\nTo view or edit this subscription, please use the following URL.<br />\n<br />\nSubscription URL: {$subscriptionUrl}<br />\n');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (184, 'SUBSCRIPTION_PURCHASE_INSTL', 'en', 'Purchase Institutional Subscription', 'Subscription Purchase: Institutional', 'An institutional subscription has been purchased online for {$journalName} with the following details. To activate this subscription, please use the provided Subscription URL and set the subscription status to \'Active\'.<br />\n<br />\nSubscription Type:<br />\n{$subscriptionType}<br />\n<br />\nInstitution:<br />\n{$institutionName}<br />\n{$institutionMailingAddress}<br />\n<br />\nDomain (if provided):<br />\n{$domain}<br />\n<br />\nIP Ranges (if provided):<br />\n{$ipRanges}<br />\n<br />\nContact Person:<br />\n{$subscriberDetails}<br />\n<br />\nMembership Information (if provided):<br />\n{$membership}<br />\n<br />\nTo view or edit this subscription, please use the following URL.<br />\n<br />\nSubscription URL: {$subscriptionUrl}<br />\n');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (185, 'SUBSCRIPTION_RENEW_INDL', 'en', 'Renew Individual Subscription', 'Subscription Renewal: Individual', 'An individual subscription has been renewed online for {$journalName} with the following details.<br />\n<br />\nSubscription Type:<br />\n{$subscriptionType}<br />\n<br />\nUser:<br />\n{$subscriberDetails}<br />\n<br />\nMembership Information (if provided):<br />\n{$membership}<br />\n<br />\nTo view or edit this subscription, please use the following URL.<br />\n<br />\nSubscription URL: {$subscriptionUrl}<br />\n');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (186, 'SUBSCRIPTION_RENEW_INSTL', 'en', 'Renew Institutional Subscription', 'Subscription Renewal: Institutional', 'An institutional subscription has been renewed online for {$journalName} with the following details.<br />\n<br />\nSubscription Type:<br />\n{$subscriptionType}<br />\n<br />\nInstitution:<br />\n{$institutionName}<br />\n{$institutionMailingAddress}<br />\n<br />\nDomain (if provided):<br />\n{$domain}<br />\n<br />\nIP Ranges (if provided):<br />\n{$ipRanges}<br />\n<br />\nContact Person:<br />\n{$subscriberDetails}<br />\n<br />\nMembership Information (if provided):<br />\n{$membership}<br />\n<br />\nTo view or edit this subscription, please use the following URL.<br />\n<br />\nSubscription URL: {$subscriptionUrl}<br />\n');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (187, 'REVISED_VERSION_NOTIFY', 'en', 'Revised Version Notification', 'Revised Version Uploaded', '<p>Dear {$recipientName},</p><p>The author has uploaded revisions for the submission, <b>{$authorsShort} — {$submissionTitle}</b>. <p>As an assigned editor, we ask that you login and <a href=\"{$submissionUrl}\">view the revisions</a> and make a decision to accept, decline or send the submission for further review.</p><br><br>—<br>This is an automated message from <a href=\"{$journalUrl}\">{$journalName}</a>.');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (188, 'STATISTICS_REPORT_NOTIFICATION', 'en', 'Statistics Report Notification', 'Editorial activity for {$month}, {$year}', '\n{$recipientName}, <br />\n<br />\nYour journal health report for {$month}, {$year} is now available. Your key stats for this month are below.<br />\n<ul>\n	<li>New submissions this month: {$newSubmissions}</li>\n	<li>Declined submissions this month: {$declinedSubmissions}</li>\n	<li>Accepted submissions this month: {$acceptedSubmissions}</li>\n	<li>Total submissions in the system: {$totalSubmissions}</li>\n</ul>\nLogin to the journal to view more detailed <a href=\"{$editorialStatsLink}\">editorial trends</a> and <a href=\"{$publicationStatsLink}\">published article stats</a>. A full copy of this month\'s editorial trends is attached.<br />\n<br />\nSincerely,<br />\n{$journalSignature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (189, 'ANNOUNCEMENT', 'en', 'New Announcement', '{$announcementTitle}', '<b>{$announcementTitle}</b><br />\n<br />\n{$announcementSummary}<br />\n<br />\nVisit our website to read the <a href=\"{$announcementUrl}\">full announcement</a>.');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (190, 'DISCUSSION_NOTIFICATION_SUBMISSION', 'en', 'Discussion (Submission)', 'A message regarding {$journalName}', 'Please enter your message.');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (191, 'DISCUSSION_NOTIFICATION_REVIEW', 'en', 'Discussion (Review)', 'A message regarding {$journalName}', 'Please enter your message.');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (192, 'DISCUSSION_NOTIFICATION_COPYEDITING', 'en', 'Discussion (Copyediting)', 'A message regarding {$journalName}', 'Please enter your message.');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (193, 'DISCUSSION_NOTIFICATION_PRODUCTION', 'en', 'Discussion (Production)', 'A message regarding {$journalName}', 'Please enter your message.');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (194, 'COPYEDIT_REQUEST', 'en', 'Request Copyedit', 'Submission {$submissionId} is ready to be copyedited for {$contextAcronym}', '<p>Dear {$recipientName},</p><p>A new submission is ready to be copyedited:</p><p><a href\"{$submissionUrl}\">{$submissionId} — {$submissionTitle}</a><br />{$journalName}</p><p>Please follow these steps to complete this task:</p><ol><li>Click on the Submission URL below.</li><li>Open any files available under Draft Files and edit the files. Use the Copyediting Discussions area if you need to contact the editor(s) or author(s).</li><li>Save the copyedited file(s) and upload them to the Copyedited panel.</li><li>Use the Copyediting Discussions to notify the editor(s) that all files have been prepared, and that the Production process may begin.</li></ol><p>If you are unable to undertake this work at this time or have any questions, please contact me. Thank you for your contribution to {$journalName}.</p><p>Kind regards,</p>{$signature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (195, 'EDITOR_ASSIGN_SUBMISSION', 'en', 'Assign Editor', 'You have been assigned as an editor on a submission to {$journalName}', '<p>Dear {$recipientName},</p><p>The following submission has been assigned to you to see through the editorial process.</p><p><a href=\"{$submissionUrl}\">{$submissionTitle}</a><br />{$authors}</p><p><b>Abstract</b></p>{$submissionAbstract}<p>If you find the submission to be relevant for {$journalName}, please forward the submission to the review stage by selecting \"Send to Review\" and then assign reviewers by clicking \"Add Reviewer\".</p><p>If the submission is not appropriate for this journal, please decline the submission.</p><p>Thank you in advance.</p><p>Kind regards,</p>{$journalSignature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (196, 'EDITOR_ASSIGN_REVIEW', 'en', 'Assign Editor', 'You have been assigned as an editor on a submission to {$journalName}', '<p>Dear {$recipientName},</p><p>The following submission has been assigned to you to see through the peer review process.</p><p><a href=\"{$submissionUrl}\">{$submissionTitle}</a><br />{$authors}</p><p><b>Abstract</b></p>{$submissionAbstract}<p>Please login to <a href=\"{$submissionUrl}\">view the submission</a> and assign qualified reviewers. You can assign a reviewer by clicking \"Add Reviewer\".</p><p>Thank you in advance.</p><p>Kind regards,</p>{$signature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (197, 'EDITOR_ASSIGN_PRODUCTION', 'en', 'Assign Editor', 'You have been assigned as an editor on a submission to {$journalName}', '<p>Dear {$recipientName},</p><p>The following submission has been assigned to you to see through the production stage.</p><p><a href=\"{$submissionUrl}\">{$submissionTitle}</a><br />{$authors}</p><p><b>Abstract</b></p>{$submissionAbstract}<p>Please login to <a href=\"{$submissionUrl}\">view the submission</a>. Once production-ready files are available, upload them under the <strong>Publication > Galleys</strong> section. Then schedule the work for publication by clicking the <strong>Schedule for Publication</strong> button.</p><p>Thank you in advance.</p><p>Kind regards,</p>{$signature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (198, 'LAYOUT_REQUEST', 'en', 'Ready for Production', 'Submission {$submissionId} is ready for production at {$contextAcronym}', '<p>Dear {$recipientName},</p><p>A new submission is ready for layout editing:</p><p><a href=\"{$submissionUrl}\">{$submissionId} — {$submissionTitle}</a><br />{$journalName}</p><ol><li>Click on the Submission URL above.</li><li>Download the Production Ready files and use them to create the galleys according to the journal\'s standards.</li><li>Upload the galleys to the Publication section of the submission.</li><li>Use the  Production Discussions to notify the editor that the galleys are ready.</li></ol><p>If you are unable to undertake this work at this time or have any questions, please contact me. Thank you for your contribution to this journal.</p><p>Kind regards,</p>{$signature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (199, 'LAYOUT_COMPLETE', 'en', 'Galleys Complete', 'Galleys Complete', '<p>Dear {$recipientName},</p><p>Galleys have now been prepared for the following submission and are ready for final review.</p><p><a href=\"{$submissionUrl}\">{$submissionTitle}</a><br />{$journalName}</p><p>If you have any questions, please contact me.</p><p>Kind regards,</p><p>{$signature}</p>');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (200, 'VERSION_CREATED', 'en', 'Version Created', 'A new version was created for {$submissionTitle}', '<p>Dear {$recipientName}, </p><p>This is an automated message to inform you that a new version of your submission, {$submissionTitle}, was created. You can view this version from your submission dashboard at the following link:</p><p><a href=\"{$submissionUrl}\">{$submissionTitle}</a></p><hr><p>This is an automatic email sent from <a href=\"{$journalUrl}\">{$journalName}</a>.</p>');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (201, 'EDITORIAL_REMINDER', 'en', 'Editorial Reminder', 'Outstanding editorial tasks for {$journalName}', '<p>Dear {$recipientName},</p><p>You are currently assigned to {$numberOfSubmissions} submissions in <a href=\"{$journalUrl}\">{$journalName}</a>. The following submissions are <b>waiting for your response</b>.</p>{$outstandingTasks}<p>View all of your assignments in your <a href=\"{$submissionsUrl}\">submission dashboard</a>.</p><p>If you have any questions about your assignments, please contact {$contactName} at {$contactEmail}.</p>');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (202, 'SUBMISSION_SAVED_FOR_LATER', 'en', 'Submission Saved for Later', 'Resume your submission to {$journalName}', '<p>Dear {$recipientName},</p><p>Your submission details have been saved in our system, but it has not yet been submitted for consideration. You can return to complete your submission at any time by following the link below.</p><p><a href=\"{$submissionWizardUrl}\">{$authorsShort} — {$submissionTitle}</a></p><hr><p>This is an automated email from <a href=\"{$journalUrl}\">{$journalName}</a>.</p>');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (203, 'SUBMISSION_NEEDS_EDITOR', 'en', 'Submission Needs Editor', 'A new submission needs an editor to be assigned: {$submissionTitle}', '<p>Dear {$recipientName},</p><p>The following submission has been submitted and there is no editor assigned.</p><p><a href=\"{$submissionUrl}\">{$submissionTitle}</a><br />{$authors}</p><p><b>Abstract</b></p>{$submissionAbstract}<p>Please assign an editor who will be responsible for the submission by clicking the title above and assigning an editor under the Participants section.</p><hr><p>This is an automated email from <a href=\"{$journalUrl}\">{$journalName}</a>.</p>');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (204, 'PAYMENT_REQUEST_NOTIFICATION', 'en', 'Payment Request', 'Payment Request Notification', '<p>Dear {$recipientName},</p><p>Congratulations on the acceptance of your submission, {$submissionTitle}, to {$journalName}. Now that your submission has been accepted, we would like to request payment of the publication fee.</p><p>This fee covers the production costs of bringing your submission to publication. To make the payment, please visit <a href=\"{$queuedPaymentUrl}\">{$queuedPaymentUrl}</a>.</p><p>If you have any questions, please see our <a href=\"{$submissionGuidelinesUrl}\">Submission Guidelines</a></p>');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (205, 'ORCID_COLLECT_AUTHOR_ID', 'en', 'orcidCollectAuthorId', 'Submission ORCID', 'Dear {$recipientName},<br/>\n<br/>\nYou have been listed as an author on a manuscript submission to {$journalName}.<br/>\nTo confirm your authorship, please add your ORCID id to this submission by visiting the link provided below.<br/>\n<br/>\n<a href=\"{$authorOrcidUrl}\"><img id=\"orcid-id-logo\" src=\"https://info.orcid.org/wp-content/uploads/2020/12/ORCIDiD_icon16x16.png\" width=\'16\' height=\'16\' alt=\"ORCID iD icon\" style=\"display: block; margin: 0 .5em 0 0; padding: 0; float: left;\"/>Register or connect your ORCID iD</a><br/>\n<br/>\n<br>\n<a href=\"{$orcidAboutUrl}\">More information about ORCID at {$journalName}</a><br/>\n<br/>\nIf you have any questions, please contact me.<br/>\n<br/>\n{$principalContactSignature}<br/>\n');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (206, 'ORCID_REQUEST_AUTHOR_AUTHORIZATION', 'en', 'orcidRequestAuthorAuthorization', 'Requesting ORCID record access', 'Dear {$recipientName},<br>\n<br>\nYou have been listed as an author on the manuscript submission \"{$submissionTitle}\" to {$journalName}.\n<br>\n<br>\nPlease allow us to add your ORCID id to this submission and also to add the submission to your ORCID profile on publication.<br>\nVisit the link to the official ORCID website, login with your profile and authorize the access by following the instructions.<br>\n<a href=\"{$authorOrcidUrl}\"><img id=\"orcid-id-logo\" src=\"https://info.orcid.org/wp-content/uploads/2020/12/ORCIDiD_icon16x16.png\" width=\'16\' height=\'16\' alt=\"ORCID iD icon\" style=\"display: block; margin: 0 .5em 0 0; padding: 0; float: left;\"/>Register or Connect your ORCID iD</a><br/>\n<br>\n<br>\n<a href=\"{$orcidAboutUrl}\">More about ORCID at {$journalName}</a><br/>\n<br>\nIf you have any questions, please contact me.<br>\n<br>\n{$principalContactSignature}<br>\n');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (207, 'MANUAL_PAYMENT_NOTIFICATION', 'en', 'Manual Payment Notify', 'Manual Payment Notification', 'A manual payment needs to be processed for the journal {$journalName} and the user {senderName} (username &quot;{$senderUsername}&quot;).<br />\n<br />\nThe item being paid for is &quot;{$paymentName}&quot;.<br />\nThe cost is {$paymentAmount} ({$paymentCurrencyCode}).<br />\n<br />\nThis email was generated by Open Journal Systems\' Manual Payment plugin.');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (277, 'PASSWORD_RESET_CONFIRM', 'id', '', 'Konfirmasi Reset Sandi', 'Kami menerima permintaan reset sandi untuk akun Anda di website {$siteTitle}.<br />\n<br />\nJika Anda tidak merasa mengajukan permintaan ini, abaikan pesan ini dan sandi Anda tidak akan diubah. Jika Anda memang ingin melakukan reset sandi, klik tautan berikut ini.<br />\n<br />\nReset sandi saya: {$lostPasswordUrl}<br />\n<br />\n{$siteContactName}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (278, 'USER_REGISTER', 'id', '', 'Registrasi Jurnal', '{$recipientName}<br />\n<br />\nAnda sekarang telah terdaftar sebagai pengguna di {$journalName}. Kami sertakan nama pengguna dan sandi Anda di email ini, keduanya diperlukan untuk semua kegiatan melalui website jurnal ini. Anda dapat keluar dari daftar pengguna jurnal kapan saja dengan menghubungi kami.<br />\n<br />\nNama pengguna: {$recipientUsername}<br />\nSandi: {$password}<br />\n<br />\nTerimakasih,<br />\n{$signature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (279, 'USER_VALIDATE_CONTEXT', 'id', 'validasi Email (Registrasi Jurnal)', 'Validasi Akun Anda', '{$recipientName}<br />\n<br />\nAnda telah membuat akun di {$journalName}. Sebelum dapat menggunakannya, Anda perlu melakukan validasi akun email. Untuk melakukannya, klik tautan berikut ini:<br />\n<br />\n{$activateUrl}<br />\n<br />\nTerimakasih,<br />\n{$journalSignature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (280, 'USER_VALIDATE_SITE', 'id', '', 'Validasi Akun Kamu', '{$recipientName}<br />\n<br />\nKamu berhasi membuat akun paaa {$siteTitle}, tapi sebelum bisa menggunakannya, validasi akun email kamu terlebih dahulu dengan mengikuti petunjuk pada tautan berikut:<br />\n<br />\n{$activateUrl}<br />\n<br />\nTerima kasih,<br />\n{$siteSignature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (281, 'REVIEWER_REGISTER', 'id', '', 'Registrasi sebagai Reviewer di {$journalName}', '<p>Yth {$recipientName},</p><p>Dengan mempertimbangkan keahlian Anda, kami memasukkan nama Anda dalam database reviewer di {$journalName}. THal ini tidak bersifat mengikat, hanya sekedar memudahkan kami untuk mengundang Anda untuk melakukan review terhadap suatu naskah. Ketika memperoleh undangan untuk melakukan review suatu naskah, Anda dapat melihat judul dan abstrak naskah tersebut, dan Anda berhak menentukan apakah akan menerima atau menolak undangan tersebut. Anda juga dapat meminta nama Anda dihapus dari daftar reviewer.</p><p>Kami menyertakan nama pengguna dan sandi Anda, yang digunakan dalam semua interaksi dengan jurnal melalui website. Anda dapat melakukan update profil, termasuk minat review Anda.</p><p>Username: {$recipientUsername}<br />Password: {$password}</p><p>Terima kasih,</p>{$signature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (282, 'ISSUE_PUBLISH_NOTIFY', 'id', 'Notifikasi Terbitan', 'Terbitan baru telah tersedia: {$issueIdentification} dari {$journalName}', '<p>Pembaca yang Budiman,</p><p>Kami dengan senang hati mengumumkan terbitan <a href=\"{$issueUrl}\">{$issueIdentification}</a> dari {$journalName}. Kami mengundang Anda untuk membaca dan membagikan terbitan ini kepada komunitas akademik Anda.</p><p>Terima kasih banyak kepada para penulis, mitra bestari, dan atas kontribusinya yang tak ternilai, dan kepada pembaca kami atas minatnya.</p><p>Salam hormat,</p>{$signature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (283, 'SUBMISSION_ACK', 'id', '', 'Terima kasih atas naskah yang Anda kirimkan ke {$journalName}', '{$recipientName}:<br />\n<br />\nTerimakasih telah menyerahkan naskah, &quot;{$submissionTitle}&quot; ke {$journalName}. Dengan sistem manajemenn jurnal online yang kami gunakan, Anda dapat memantau kemajuan proses editorial naskah Anda melalui:<br />\n<br />\nURL Naskah: {$submissionUrl}<br />\nNama pengguna: {$recipientUsername}<br />\n<br />\nJika ada pertanyaan, silakan hubungi kami. Terimakasih telah mempercayakan publikasi karya Anda di jurnal kami.<br />\n<br />\n{$journalSignature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (284, 'SUBMISSION_ACK_NOT_USER', 'id', '', 'Konfirmasi pengiriman naskah', '<p>Yth {$recipientName},</p><p>Nama Anda ditulis sebagai co-author pada nasakah {$journalName}. Pengirim, {$submitterName}, memberikan rincian berikut:</p><p>{$submissionTitle}<br>{$authorsWithAffiliation}</p><p>Jika ada kekeliruan, atau tidak ingin nama Anda tercantum dalam naskah, silakan hubungi saya.</p><p>Terima kasih atas pertimbangannya memilih jurnal ini untuk menerbitkan karya Anda.</p><p>Salam Hormat,</p>{$journalSignature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (285, 'EDITOR_ASSIGN', 'id', '', 'Anda telah ditugaskan sebagai editor untuk naskah pada {$journalName}', '<p>Yth. {$recipientName},</p><p>Naskah berikut telah ditugaskan kepada Anda untuk diperiksa melalui proses editorial.</p><p><a href=\"{$submissionUrl}\">{$submissionTitle}</a><br />{$authors}</p><p><b>Abstract</b></p>{$submissionAbstract}<p>Jika telah sesuai dengan {$journalName}, lanjutkan naskah tersebut ke tahap dengan memilih \"Kirim ke Taha Review\" lalu tugaskan seorang mitra bestari dengan mengklik \"Tambahkan Mitra Bestari\".</p><p>Jika tidak sesuai dengan ketentuan jurnal, silakan naskah ditolak.</p><p>Terima kasih.</p><p>Salam hormat,</p>{$journalSignature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (286, 'REVIEW_CANCEL', 'id', '', 'Permohonan Review Dibatalkan', '<p>Yth {$recipientName},</p><p>Kami memutuskan untuk membatalkan permohonan review kami kepada Anda untuk naskah {$submissionTitle} pada {$journalName}.</p><p> Kami mohon maaf sebesar-besarnya untuk ketidaknyamanan ini dan kami harap di masa mendatang Anda dapat membantu proses review di jurnal ini.</p><p>Jika ada pertanyaan, silakan hubungi kami.</p>{$signature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (287, 'REVIEW_REINSTATE', 'id', '', 'Bersediakah Anda mereview lagi pada {$journalName}?', '<p>Yang terhotmat {$recipientName}:</p><p>Kami membatalkan permintaan review kepada Anda untuk menelaah naskah, {$submissionTitle}, untuk {$journalName}. Kami mengubah keputusan dan kami berharap Anda tetap dapat membantu proses review jurnal kami.</p><p>Jika Anda bisa membantu review naskah ini, Anda bisa <a href=\"{$reviewAssignmentUrl}\">login ke jurnal</a> untuk mereview naskah, unggah hasil review, dan mengirim permintaan review Anda.</p><p>Jika ada pertanyaan, silakan hubungi saya.</p><p>Salam Hormat,</p>{$signature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (288, 'REVIEW_RESEND_REQUEST', 'id', '', '', '');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (289, 'REVIEW_REQUEST', 'id', '', 'Undangan mereview', '<p>Yth. {$recipientName},</p><p>Kami memandang bahwa Anda merupakan reviewer yang tepat untuk naskah {$journalName}. Abstrak dan judul naskah tersebut disertakan di bawah ini, dan kami berharap Anda berkenan melakukannya.</p><p>Jika Anda berkenan mereview naskah ini, batas waktu yang ditentapkan adalah {$reviewDueDate}. Silakan login ke web jurnal untuk melihat, mengunggah file review, dan mengirimkan hasil telaah Anda dan ikuti langkah pada tautan berikut.</p><p><a href=\"{$reviewAssignmentUrl}\">{$submissionTitle}</a></p><p><b>Abstrak</b></p>{$submissionAbstract}<p>Silakan merespon dengan memilih <a href=\"{$reviewAssignmentUrl}\">menerima atau menolak</a> permintaan review sebelum <b>{$responseDueDate}</b></p><p>Silakan hubungi saya bila ada pertanyaan terkait naskah atau proses review.</p><p>Terima kasih telah mempertimbangkan permintaan kami. Bantuan Anda sangat berharga bagi Kami.</p><p>Salam hormat,</p>{$signature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (290, 'REVIEW_REQUEST_SUBSEQUENT', 'id', '', 'Permintaan untuk mereview naskah hasil revisi', '<p>Yang terhormat {$recipientName},</p><p>Terima kasih telah mereview <a href=\"{$reviewAssignmentUrl}\">{$submissionTitle}</a>. Penulis telah mempertimbangkan saran mitra bestari dan saat ini telah mengirimkan versi revisi naskahnya. Kami menghubungi untuk menanyakan apakah Anda bersedia mereview pada putaran kedua untuk naskah ini.</p><p>Jika bersedia, batas waktu review berakhir sebelum {$reviewDueDate}. Anda dapat <a href=\"{$reviewAssignmentUrl}\">mengikuti tahapan review</a> untuk melihat naskah, mengunggah file review, dan mengirimkan komentar Anda.<p><p><a href=\"{$reviewAssignmentUrl }\"{$submissionTitle}</a></p><p>Abstrak</p>{$submissionAbstract}<p>Harap terima atau tolak permintaan review sebelum {$responseDueDate}.</p><p>Jangan sungkan menghubungi saya jika ada pertanyaan terkait naskah atau proses review.</p><p>Terima kasih telah mempertimbangkan permintaan kami. Bantuan Anda sangat berharga bagi kami.</p><p>Hormat kami,</p>{$signature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (291, 'REVIEW_RESPONSE_OVERDUE_AUTO', 'id', '', 'Apakah Anda bersedia mereview naskah ini?', '<p>Yth {$recipientName},</p><p>Email pengingat otomatis ini dari {$journalName} merujuk pada permintaan review naskah, \"{$submissionTitle}.\"</p><p>Anda menerima email ini karena kami belum menerima konfirmasi yang menunjukkan apakah Anda bersedia mereview naskah tersebut.</p><p>Kami menunggu jawaban apakah Anda dapat mereview atau tidak menggunakan software pengelolaan naskah dengan menerima atau menolak permintaan review ini.</p><p>Jika bersedia, tenggat waktu reviewnya adalah {$reviewDueDate}. Silakan ikuti tahap review untuk melihat naskah, unggah file review, dan kirim komentar review Anda.</p><p>{$submissionTitle}</p><p><b>Abstrak</b></p>{$submissionAbstract}<p>Jangan sungkan menghubungi saya bial ada pertanyaan tentant naskah atau proses review.</p><p>Terima kasih telah mempertimbangkan permintaan kami. Terima kasih banyak atas bantuan Anda.</p><p>Salam hormat,</p>{$journalSignature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (292, 'REVIEW_CONFIRM', 'id', '', 'Dapat Melakukan Review', 'Editor:<br />\n<br />\nSaya dapat dan bersedia melakukan review terhadap naskah, &quot;{$submissionTitle},&quot; untuk {$journalName}. Terimakasih telah mempercayakan kepada saya, dan saya berencana untuk menyelesaikan review ini sesuai tenggat, {$reviewDueDate}, atau sebelumnya.<br />\n<br />\n{$senderName}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (293, 'REVIEW_DECLINE', 'id', '', 'Tidak Dapat Melakukan Review', 'Editor:<br />\n<br />\nMohon maaf saat ini saya tidak dapat melakukan review terhadap naskah, &quot;{$submissionTitle},&quot; untuk {$journalName}. Terimakasih telah mempercayakann kepada saya, dan lain waktu silakan menghubungi saya lagi.<br />\n<br />\n{$senderName}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (294, 'REVIEW_ACK', 'id', '', 'Ucapan Terimakasih atas Review Artikel', '{$recipientName}:<br />\n<br />\nTerimakasih telah menyelesaikan review terhadap naskah, &quot;{$submissionTitle},&quot; untuk {$journalName}. Kami sangat menghargai kontribusi Anda terhadap kualitas karya yang kami publikasikan.');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (295, 'REVIEW_REMIND', 'id', '', 'Pengingat untuk menyelesaikan tugas review Anda', '<p> Yth {$recipientName},</p><p>Sekedar mengingatkan tentang permohonan kami untuk melakukan review terhadap naskah, \"{$submissionTitle},\" untuk {$journalName}. Kami mengharapkan telah menerima review ini pada {$reviewDueDate}, dan akan sangat berbahagia bila Anda dapat menyelesaikannya.</p><p>Silakan <a href=\"{$reviewAssignmentUrl}\">login ke jurnal</a> dan ikuti petunjuk review untuk melihat naskah, mengunggah file review, serta mengirim komentar review.</p><p>Jika butuh tambahan waktu, silakan hubungi saya. Kami menunggu tanggapan Anda.</p><p>Terima kasih atas perhatian Anda dan salam hormat,</p>{$signature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (296, 'REVIEW_REMIND_AUTO', 'id', '', 'Pengingat untuk menyelesaikan review Anda', '<p>Yth {$recipientName}:</p><p>Sekedar mengingatkan tentang permohonan kami untuk melakukan review terhadap naskah, \"{$submissionTitle}\" untuk {$journalName}. </p><p>Kami mengharapkan telah menerima review ini pada {$reviewDueDate} dan kami berterima kasih bila dapat menyelesaikannya lebih awal.</p><p>Silakan <a href=\"{$reviewAssignmentUrl}\">login ke jurnal</a> dan ikuti tahapan untuk melihat naskah, mengunggah file review, dan mwnambahkana komentar review.</p><p>Jika Anda membutuhkan tambahan waktu, silakan hubungi saya. Kami menunggu kabar dari Anda.</p><p>Terima kasih dan salam hormat,</p>{$journalSignature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (297, 'REVIEW_COMPLETE', 'id', '', '', '');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (298, 'REVIEW_EDIT', 'id', '', '', '');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (299, 'EDITOR_DECISION_ACCEPT', 'id', '', 'Naskah Anda telah diterima pada {$journalName}', '<p>Yang terhormat {$recipientName},</p><p>Dengan senang hati saya informasikan bahwa kami telah memutuskan untuk menerima naskha Anda tanpa revisi lebih lanjut. Setelah review matang, kami memutuskan bahwa naskah Anda, {$submissionTitle}, memenuhi atau melebihi harapan kami. Kami sangat senang untuk menerbitkan artikel Anda di {$journalName} dan kami berterima kasih telah memilih jurnal kami sebagai tempat untuk karya Anda.</p><p>Naskah Anda sedang masuk edisi forthcoming dalam edisi {$journalName} dan Anda dipersilakan untuk memasukkannya ke dalam daftar publikasi Anda. Kami menghargai kerja keras untuk setiap karya dan mengucapkan selamat kepada Anda karena telah mencapai tahap ini.</p><p>Artikel Anda sedang dalam tahap pengeditan dan pemformatan salinan agas siap diterbitkan.</p><p >Anda akan segera menerima petunjuk lebih lanjut.</p><p>Jika memiliki pertanyaan, silakan hubungi saya melalui <a href=\"{$authorSubmissionUrl}\">dashbord naskah</a> Anda.</p><p >Hormat kami,</p>{$signature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (300, 'EDITOR_DECISION_SEND_TO_EXTERNAL', 'id', '', 'Keputusan Editor', '{$authors}:<br />\n<br />\nKami telah membuat keputusan terkait naskah yang Anda kirimkan ke {$journalName}, &quot;{$submissionTitle}&quot;.<br />\n<br />\nKeputusan kami adalah: Dikirimkan ke Reviewer Eksternal<br />\n<br />\nURL Naskah: {$submissionUrl}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (301, 'EDITOR_DECISION_SEND_TO_PRODUCTION', 'id', '', 'Tahap berikutnya menerbitkan naskah Anda', '{$authors}:<br />\n<br />\nProses editing naskah Anda, &quot;{$submissionTitle},&quot; telah selesai.  Kami sekarang mengirimkannya ke produksi.<br />\n<br />\nURL Naskah: {$submissionUrl}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (302, 'EDITOR_DECISION_REVISIONS', 'id', '', 'Naskah Anda telah direview dan kami menyarankan untuk segera mengirimkan revisinya', '{$authors}:<br />\n<br />\nKami telah membuat keputusan terkait naskah yang Anda kirimkan ke {$journalName}, &quot;{$submissionTitle}&quot;.<br />\n<br />\nKeputusan kami adalah: Perlu Revisi');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (303, 'EDITOR_DECISION_RESUBMIT', 'id', '', 'Naskah Anda telah direview - silakan revisi dan kirim ulang', '{$authors}:<br />\n<br />\nKami telah membuat keputusan terkait naskah yang Anda kirimkan ke {$journalName}, &quot;{$submissionTitle}&quot;.<br />\n<br />\nKeputusan kami adalah: Kirim Ulang untuk Review');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (304, 'EDITOR_DECISION_DECLINE', 'id', '', 'Naskah Anda ditolak', '{$authors}:<br />\n<br />\nKami telah membuat keputusan terkait naskah yang Anda kirimkan ke {$journalName}, &quot;{$submissionTitle}&quot;.<br />\n<br />\nKeputusan kami adalah: Naskah Ditolak');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (305, 'EDITOR_DECISION_INITIAL_DECLINE', 'id', '', 'Naskah Anda ditolak', '\n			{$authors}:<br />\n<br />\nKami telah sampai pada keputusan mengenai naskah Anda {$journalName}, &quot;{$submissionTitle}&quot;.<br />\n<br />\nKeputusannya adalah: Menolak Naskah');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (306, 'EDITOR_RECOMMENDATION', 'id', '', 'Rekomendasi Penyunting', '{$editors}:<br />\n<br />\nRekomendasi berkaitan dengan  naskah {$journalName}, &quot;{$submissionTitle}&quot; adalah: {$recommendation}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (307, 'EDITOR_DECISION_NOTIFY_OTHER_AUTHORS', 'id', '', '', '');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (308, 'EDITOR_DECISION_NOTIFY_REVIEWERS', 'id', '', '', '');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (309, 'EDITOR_DECISION_NEW_ROUND', 'id', '', '', '');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (310, 'EDITOR_DECISION_REVERT_DECLINE', 'id', '', '', '');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (311, 'EDITOR_DECISION_REVERT_INITIAL_DECLINE', 'id', '', '', '');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (312, 'EDITOR_DECISION_SKIP_REVIEW', 'id', '', 'Naskah Anda telah dikirim untuk proses copyediting', '<p>Yth. {$recipientName},</p>\n<p>Dengan senang hati kami menginformasikan bahwa kami telah memutuskan menerima naskah Anda tanpa melalui proses review. Naskah Anda, {$submissionTitle}, telah memenuhi ketentuan jurnal, dan tidak perlu melewati proses tersebut. Kami senang menerbitkan karya Anda di {$journalName} dan terima kasih atas pilihan ANda memilih jurnal kami sebagai media publikasi karya Anda.</p>\nNaskah Anda sekarang berstatus Akan terbit papa nomor {$journalName} dan membolehkan anda menambahkannya ke dalam daftar publikasi Anda. Kami menghargai kerja keras yang telah berhasil diterima dan selamat atas pencapaian Anda.</p>\n<p>Naskah Anda selanjutnay akan melalui proses copy edit dan pengaturan format agar siap diterbitkan. </p>\n<p>Kami akan segera mengirimkan panduan lanjutan.</p>\n<p>Jika ada pertanyaan, silakan hubungi saya melalui <a href=\"{$authorSubmissionUrl}\">dashboar naskah</a> Anda.</p>\n<p>Hormat Kami,</p>\n<p>{$signature}</p>\n');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (313, 'EDITOR_DECISION_BACK_FROM_PRODUCTION', 'id', '', '', '');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (314, 'EDITOR_DECISION_BACK_FROM_COPYEDITING', 'id', '', '', '');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (315, 'EDITOR_DECISION_CANCEL_REVIEW_ROUND', 'id', '', '', '');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (316, 'SUBSCRIPTION_NOTIFY', 'id', 'Notifikasi berlangganan', 'Pemberitahuan Langganan', '{$recipientName}:<br />\n<br />\nAnda sekarang telah terdaftar sebagai pelanggan di sistem manajemen jurnal online kami, {$journalName}, dengan jenis langganan:<br />\n<br />\n{$subscriptionType}<br />\n<br />\nUntuk mengakses konten yang hanya tersedia bagi pelanggan, silakan login ke sistem dengan menggunakan nama pengguna Anda, &quot;{$recipientUsername}&quot;.<br />\n<br />\nSetelah login, Anda dapat mengubah detail profil Anda dan sandi Anda kapanpun Anda kehendaki.<br />\n<br />\nJika Anda memiliki langganan institusi, pengguna di institusi Anda tidak perlu login karena semua akses secara otomatis diotentikasi oleh sistem.<br />\n<br />\nJika ada pertanyaan, silakan hubungi kami.<br />\n<br />\n{$subscriptionSignature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (317, 'OPEN_ACCESS_NOTIFY', 'id', 'Notifikasi Akses Terbuka', 'Gratis dibaca: {$issueIdentification} of {$journalName} sudah akses terbuka sekarang', '<p>Yth {$recipientName},</p><p>Dengan senang hati kami informasikan bahwa <a href=\"{$issueUrl}\">{$issueIdentification}</a> dari {$journalName} telah menjadikan terbitan Open Access. Langganan tidak diperlukan lagi untuk membaca terbitan ini.</p><p>Terima kasih atas perhatiannya.</p>{$journalSignature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (318, 'SUBSCRIPTION_BEFORE_EXPIRY', 'id', 'Langganan Akan Segera Habis', 'Pemberitahuan Tanggal Berakhir Langganan', '{$recipientName}:<br />\n<br />\nLangganan {$journalName} Anda hampir berakhir.<br />\n<br />\n{$subscriptionType}<br />\nTanggal berakhir: {$expiryDate}<br />\n<br />\nUntuk terus memperoleh akses ke jurnal ini, silakan kunjungi website jurnal dan perbaharui langganan. Anda dapat login menggunakan nama pengguna Anda, &quot;{$recipientUsername}&quot;.<br />\n<br />\nJika ada pertanyaan, silakan hubungi kami.<br />\n<br />\n{$subscriptionSignature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (319, 'SUBSCRIPTION_AFTER_EXPIRY', 'id', 'Langganan habis', 'Langganan Berakhir', '{$recipientName}:<br />\n<br />\nLangganan {$journalName} Anda telah berakhir.<br />\n<br />\n{$subscriptionType}<br />\nTanggal berakhir: {$expiryDate}<br />\n<br />\nUntuk memperbaharui langganan Anda, silakan kunjungi website jurnal. Anda dapat login dengan menggunakan nama pengguna Anda, &quot;{$recipientUsername}&quot;.<br />\n<br />\nJika ada pertanyaan, silakan hubungi kami.<br />\n<br />\n{$subscriptionSignature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (320, 'SUBSCRIPTION_AFTER_EXPIRY_LAST', 'id', 'Langganan habis terakhir', 'Langganan Berakhir - Pengingat Terakhir', '{$recipientName}:<br />\n<br />\nLangganan {$journalName} Anda telah berakhir.<br />\nIni adalah pengingat terakhir yang diemailkan kepada Anda.<br />\n<br />\n{$subscriptionType}<br />\nTanggal berakhir: {$expiryDate}<br />\n<br />\nUntuk memperbaharui langganan Anda, silakan kunjungi website jurnal. Anda dapat login dengan menggunakan nama pengguna Anda, &quot;{$recipientUsername}&quot;.<br />\n<br />\nJika ada pertanyaan, silakan hubungi kami.<br />\n<br />\n{$subscriptionSignature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (321, 'SUBSCRIPTION_PURCHASE_INDL', 'id', 'Beli Langganan Individu', 'Pembelian Langganan: Individu', 'Sebuah langganan individu telah dibeli online untuk {$journalName} dengan rincian berikut.<br />\n<br />\nJenis Langganan:<br />\n{$subscriptionType}<br />\n<br />\nPengguna:<br />\n{$subscriberDetails}<br />\n<br />\nInformasi Keanggotaan (jika ada):<br />\n{$membership}<br />\n<br />\nUntuk melihat atau mengubah langganan ini, silakan gunakan URL berikut ini.<br />\n<br />\nURL Langganan: {$subscriptionUrl}<br />\n');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (322, 'SUBSCRIPTION_PURCHASE_INSTL', 'id', 'Berlangganan Institusi', 'Pembelian Langganan: Institusi', 'Sebuah langganan institusi telah dibeli online untuk {$journalName} dengan rincian berikut. Untuk mengaktifkan langganan ini, silakan gunakan URL Langganan dan jadikan status langganan ke \'Aktif\'.<br />\n<br />\nJenis Langganan:<br />\n{$subscriptionType}<br />\n<br />\nInstitusi:<br />\n{$institutionName}<br />\n{$institutionMailingAddress}<br />\n<br />\nDomain (jika ada):<br />\n{$domain}<br />\n<br />\nIP Ranges (jika ada):<br />\n{$ipRanges}<br />\n<br />\nContact Person:<br />\n{$subscriberDetails}<br />\n<br />\nInformasi Keanggotaan (jika ada):<br />\n{$membership}<br />\n<br />\nUntuk melihat atau mengubah langganan ini, silakan gunakan URL berikut ini.<br />\n<br />\nURL Langganan: {$subscriptionUrl}<br />\n');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (323, 'SUBSCRIPTION_RENEW_INDL', 'id', 'Perbaharui Langganan Individu', 'Pembaharuan Langganan: Individu', 'Sebuah langganan individu telah diperbaharui online untuk {$journalName} dengan rincian berikut.<br />\n<br />\nJenis Langganan:<br />\n{$subscriptionType}<br />\n<br />\nPengguna:<br />\n{$subscriberDetails}<br />\n<br />\nInformasi Keanggotaan (jika ada):<br />\n{$membership}<br />\n<br />\nUntuk melihat atau mengubah langganan ini, silakan gunakan URL berikut ini.<br />\n<br />\nURL Langganan: {$subscriptionUrl}<br />\n');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (324, 'SUBSCRIPTION_RENEW_INSTL', 'id', 'Perbaharui Langganann Institusi', 'Pembaharuan Langganan: Institusi', 'Sebuah langganan institusi telah diperbaharui online untuk {$journalName} dengan rincian berikut.<br />\n<br />\nJenis Langganan:<br />\n{$subscriptionType}<br />\n<br />\nInstitusi:<br />\n{$institutionName}<br />\n{$institutionMailingAddress}<br />\n<br />\nDomain (jika ada):<br />\n{$domain}<br />\n<br />\nIP Ranges (jika ada):<br />\n{$ipRanges}<br />\n<br />\nContact Person:<br />\n{$subscriberDetails}<br />\n<br />\nInformasi Keanggotaan (jika ada):<br />\n{$membership}<br />\n<br />\nUntuk melihat atau mengubah langganan ini, silakan gunakan URL berikut ini.<br />\n<br />\nURL Langganan: {$subscriptionUrl}<br />\n');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (325, 'REVISED_VERSION_NOTIFY', 'id', '', 'Versi Revisi telah Diunggah', '<p>Yth {$recipientName},</p><p>Penulis telah mengunggah revisi naskahnya, <b>{$authorsShort} — {$submissionTitle}</b>. <p>Sebagai.editorp, silakan login dan <a href=\"{$submissionUrl}\">periksa revisinya</a> dan ambil keputusan apakah menerima, menolak, atau kirim.naskah untuk direview lebih lanjut.</p><br><br>—<br>Ini pesan otomatis dari <a href=\"{$journalUrl}\">{$journalName}</a>.');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (326, 'STATISTICS_REPORT_NOTIFICATION', 'id', '', 'Kegiatan redaksi selama {$month}, {$year}', '\n{$recipientName}, <br />\n<br />\nLaporan kondisi jurnal Anda untuk {$month}, {$year} sudah tersedia. Statistik utama Anda bulan ini tersaji sebagai berikut.<br />\n<ul>\n	<li>Naskah baru yang masuk bulan ini: {$newSubmissions}</li>\n	<li>Naskah ditolak bulan ini: {$declinedSubmissions}</li>\n	<li>Naskah yang diterima bulan ini: {$acceptedSubmissions}</li>\n	<li>Total naskah dalam sistem: {$totalSubmissions}</li>\n</ul>\nSelengkapnya, login untuk melihat <a href=\"{$editorialStatsLink}\">kecenderungan editorial</a> dan <a href=\"{$publicationStatsLink}\">statistik artikel yang dipublikasikan</a>. Salinan lengkap trend bulan ini terlampir.<br />\n<br />\nSalam Hormat,<br />\n{$journalSignature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (327, 'ANNOUNCEMENT', 'id', '', '{$announcementTitle}', '<b>{$announcementTitle}</b><br />\n<br />\n{$announcementSummary}<br />\n<br />\nKunjungi website kami untuk melihat <a href=\"{$announcementUrl}\">pengumuman selengkapnya</a>.');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (328, 'DISCUSSION_NOTIFICATION_SUBMISSION', 'id', '', 'Pesan terkait {$journalName}', 'Silakan tuliskan pesan Anda.');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (329, 'DISCUSSION_NOTIFICATION_REVIEW', 'id', '', 'Pesan terkait {$journalName}', 'Silakan tuliskan pesan Anda.');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (330, 'DISCUSSION_NOTIFICATION_COPYEDITING', 'id', '', 'Pesan terkait {$journalName}', 'Silakan tuliskan pesan Anda.');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (331, 'DISCUSSION_NOTIFICATION_PRODUCTION', 'id', '', 'Pesan terkait {$journalName}', 'Silakan tuliskan pesan Anda.');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (332, 'COPYEDIT_REQUEST', 'id', '', 'Naskah {$submissionId} siap masuk ke tahap copyedit untuk {$contextAcronym}', '{$recipientName}:<br />\n<br />\nKami meminta Anda melakukan copyediting terhadap &quot;{$submissionTitle}&quot; untuk {$journalName} mengikuti langkah-langkah berikut.<br />\n1. Klik URL Naskah di bawah.<br />\n2. Buka semua file yang ada di file Draft dan lakukan copyediting, tambahkan Diskusi Copyediting sesuai kebutuhan.<br />\n3. Simpan file yang telah di-copyedit, dan unggah ke panel Sudah Copyedit.<br />\n4. Beritahu Editor bahwa semua file telah siap, dan bahwa proses Produksi dapat dimulai.<br />\n<br />\n{$journalName} URL: {$journalUrl}<br />\nURL Naskah: {$submissionUrl}<br />\nNama pengguna: {$recipientUsername}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (333, 'EDITOR_ASSIGN_SUBMISSION', 'id', '', 'Anda telah ditugaskan sebagai editor untuk naskah pada {$journalName}', '<p>Yth. {$recipientName},</p><p>Naskah berikut telah ditugaskan kepada Anda untuk diperiksa melalui proses editorial.</p><p><a href=\"{$submissionUrl}\">{$submissionTitle}</a><br />{$authors}</p><p><b>Abstract</b></p>{$submissionAbstract}<p>Jika telah sesuai dengan {$journalName}, lanjutkan naskah tersebut ke tahap dengan memilih \"Kirim ke Taha Review\" lalu tugaskan seorang mitra bestari dengan mengklik \"Tambahkan Mitra Bestari\".</p><p>Jika tidak sesuai dengan ketentuan jurnal, silakan naskah ditolak.</p><p>Terima kasih.</p><p>Salam hormat,</p>{$journalSignature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (334, 'EDITOR_ASSIGN_REVIEW', 'id', '', 'Anda telah ditugaskan sebagai editor untuk naskah pada {$journalName}', '<p>Yth {$recipientName},</p><p>Naskah berikut telah ditugaskan kepada Anda untuk ditangani selama proses review.</p><p><a href=\"{$submissionUrl}\">{$submissionTitle}</a><br />{$authors}</p><p><b>Abstrak</b></p>{$submissionAbstract}<p>Silakan login untuk <a href=\"{$submissionUrl}\">melihat naskah</a> dan tugaskan mitra bestari yang sesuai kualifikasi. Anda bisa menugaskan seorang mitra bestari dengan mengklik \"Tambah Mitra Bestari\".</p><p>Terima kasih.</p><p>Salam Hormat,</p>{$signature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (335, 'EDITOR_ASSIGN_PRODUCTION', 'id', '', 'Anda telah ditugaskan sebagai editor untuk naskah pada {$journalName}', '<p>Yth {$recipientName},</p><p>Naskah berikut telah ditugaskan kepada Anda untuk ditangani selama tahap produksi.</p><p><a href=\"{$submissionUrl}\">{$submissionTitle}</a><br />{$authors}</p><p><b>Abstrak</b></p>{$submissionAbstract}<p>Silakan login untuk <a href=\"{$submissionUrl}\">melihat naskah</a>. Bila file produksi telah siap, silakan unggah ke bagian <strong>Publikasi > Galei</strong>. Selanjutnya jadwalkan naskah untuk diterbitkan dengan mengklik tombol <strong>Jadwalkan untuk Diterbitkan</strong>.</p><p>Terima kasih.</p><p>Salam Hormat,</p>{$signature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (336, 'LAYOUT_REQUEST', 'id', '', 'Naskah {$submissionId} siap masuk ke tahap produksi pada {$contextAcronym}', '<p>Yth. {$recipientName},</p><p>Naskah baru telah siap proses layout editing:</p><p><a href=\"{$submissionUrl}\">{$submissionId} — {$submissionTitle}</a><br />{$journalName}</p><ol><li>Klik URL Naskah di atas.</li><li>Unduh file Siap Cetak dan gunakan untuk membuat galley sesuai aturan jurnal.</li><li>Unggah galley ke bagian Publikasi naskah.</li><li>Gunakan fitur Diskusi Produksi untuk memberitahu editor bahwa file galley sudah siap.</li></ol><p>Jika tidak bisa mengerjakan sekarang atau ada pertanyaan, silakan hubungi saya. Terima kasih atas kontribusinya kepada jurnal ini.</p><p>Salam hormat,</p>{$signature}');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (337, 'LAYOUT_COMPLETE', 'id', 'Galei Selesai', 'Galley Selesai', '<p>Yang terhormat {$recipientName},<p><p>Galai sedang dipersiapkan untuk artikel berikut dan siap untuk peninjauan akhir.</p><p><a href=\"{$submissionUrl}\">{ $submissionTitle}</a><br />{$journalName}</p><p>Jika Anda memiliki pertanyaan, silakan hubungi saya.</p><p>Hormat kami,</p><p>{ $senderName}</p>');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (338, 'VERSION_CREATED', 'id', '', '', '');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (339, 'EDITORIAL_REMINDER', 'id', '', '', '');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (340, 'SUBMISSION_SAVED_FOR_LATER', 'id', '', '', '');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (341, 'SUBMISSION_NEEDS_EDITOR', 'id', '', '', '');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (342, 'PAYMENT_REQUEST_NOTIFICATION', 'id', 'Permintaan Pembayaran', 'Notifikasi Permintaan Pembayaran', '<p>Yth {$recipientName},</p><p>Selamat atas diterimanya naskah Anda, {$submissionTitle}, pada {$journalName}. Saat ini, naskah terlah diterima, kami meminta Anda untuk melakukan pembayaran biaya publikasi.</p><p>Biaya ini mencakup biaya produksi hingga publikasi. Untuk melakukan pembayaran, buka halaman <a href=\"{$queuedPaymentUrl}\">{$queuedPaymentUrl}</a>.</p><p>Jika ada pertanyaan, silakan buka <a href=\"{$submissionGuidelinesUrl}\">Panduan Naskah</a></p>');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (343, 'ORCID_COLLECT_AUTHOR_ID', 'id', '', 'ORCID Naskah', 'Yang Kami Hormati {$recipientName},<br/>\n<br/>\nAnda telah terdaftar sebagai penulis naskah{$journalName}.<br/>\nUntuk mengonfirmasi kepenulisan tersebut, tambahkanlah id ORCID Anda pada naskah tersebut dengan membuka tautan berikut ini.<br/>\n<br/>\n<a href=\"{$authorOrcidUrl}\"><img id=\"orcid-id-logo\" src=\"https://info.orcid.org/wp-content/uploads/2020/12/ORCIDiD_icon16x16.png\" width=\'16\' height=\'16\' alt=\"ORCID iD icon\" style=\"display: block; margin: 0 .5em 0 0; padding: 0; float: left;\"/>Register atau hubungkan iD ORCID Anda</a><br/>\n<br/>\n<br>\n<a href=\"{$orcidAboutUrl}\">Informasi selengkapnya tentang ORCID pada {$journalName}</a><br/>\n<br/>\nBila ada pertanyaan, silakan hubungi kami.<br/>\n<br/>\n{$principalContactSignature}<br/>\n');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (344, 'ORCID_REQUEST_AUTHOR_AUTHORIZATION', 'id', '', 'Meminta akses rekaman ORCID', 'Yang Kami Hormati {$recipientName},<br/>\n<br/>\nAnda telah terdaftar sebagai penulis naskah{$journalName}.<br/>\nUntuk mengonfirmasi kepenulisan tersebut, tambahkanlah id ORCID Anda pada naskah tersebut dengan membuka tautan berikut ini.<br/>\n<br/>\n<a href=\"{$authorOrcidUrl}\"><img id=\"orcid-id-logo\" src=\"https://info.orcid.org/wp-content/uploads/2020/12/ORCIDiD_icon16x16.png\" width=\'16\' height=\'16\' alt=\"ORCID iD icon\" style=\"display: block; margin: 0 .5em 0 0; padding: 0; float: left;\"/>Register atau hubungkan iD ORCID Anda</a><br/>\n<br/>\n<br>\n<a href=\"{$orcidAboutUrl}\">Informasi selengkapnya tentang ORCID pada {$journalName}</a><br/>\n<br/>\nBila ada pertanyaan, silakan hubungi kami.<br/>\n<br/>\n{$principalContactSignature}<br/>\n');
INSERT INTO `email_templates_default_data` (`email_templates_default_data_id`, `email_key`, `locale`, `name`, `subject`, `body`) VALUES (345, 'MANUAL_PAYMENT_NOTIFICATION', 'id', 'Notifikasi Pembayaran Manual', 'Pemberitahuan Pembayaran Manual', 'Pembayaran manual harus diproses untuk jurnal {$journalName} dan pengguna {$senderName} (username &quot;{$senderUsername}&quot;).<br />\n<br />\nItem yang akan dibayar adalah &quot;{$paymentName}&quot;.<br />\nBiayanya {$paymentAmount} ({$paymentCurrencyCode}).<br />\n<br />\nSurat elektronik ini dibuat oleh plugin Pembayaran Manual OJS.');
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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='More data about custom email templates, including localized properties such as the subject and body.';

-- ----------------------------
-- Records of email_templates_settings
-- ----------------------------
BEGIN;
INSERT INTO `email_templates_settings` (`email_template_setting_id`, `email_id`, `locale`, `setting_name`, `setting_value`) VALUES (4, 14, 'en', 'body', '{$recipientName}<br />\n<br />\nYou have now been registered as a user with {$journalName}. We have included your username and password in this email, which are needed for all work with this journal through its website. At any point, you can ask to be removed from the journal\'s list of users by contacting me.<br />\n<br />\nUsername: {$recipientUsername}<br />\nPassword: {$password}<br />\n<br />\nThank you,<br />\n{$signature}');
INSERT INTO `email_templates_settings` (`email_template_setting_id`, `email_id`, `locale`, `setting_name`, `setting_value`) VALUES (5, 14, 'en', 'name', 'User Created');
INSERT INTO `email_templates_settings` (`email_template_setting_id`, `email_id`, `locale`, `setting_name`, `setting_value`) VALUES (6, 14, 'en', 'subject', 'Journal Registration');
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
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='A log of all events related to an object like a submission.';

-- ----------------------------
-- Records of event_log
-- ----------------------------
BEGIN;
INSERT INTO `event_log` (`log_id`, `assoc_type`, `assoc_id`, `user_id`, `date_logged`, `event_type`, `message`, `is_translated`) VALUES (10, 515, 1, 1, '2024-11-01 14:29:19', 1342177282, 'submission.event.fileDeleted', 0);
INSERT INTO `event_log` (`log_id`, `assoc_type`, `assoc_id`, `user_id`, `date_logged`, `event_type`, `message`, `is_translated`) VALUES (11, 1048585, 2, 5, '2024-11-02 11:58:15', 268435458, 'submission.event.general.metadataUpdated', 0);
INSERT INTO `event_log` (`log_id`, `assoc_type`, `assoc_id`, `user_id`, `date_logged`, `event_type`, `message`, `is_translated`) VALUES (12, 1048585, 2, 5, '2024-11-02 11:58:15', 268435458, 'submission.event.general.metadataUpdated', 0);
INSERT INTO `event_log` (`log_id`, `assoc_type`, `assoc_id`, `user_id`, `date_logged`, `event_type`, `message`, `is_translated`) VALUES (13, 1048585, 2, 5, '2024-11-02 11:58:27', 268435458, 'submission.event.general.metadataUpdated', 0);
INSERT INTO `event_log` (`log_id`, `assoc_type`, `assoc_id`, `user_id`, `date_logged`, `event_type`, `message`, `is_translated`) VALUES (14, 515, 2, 5, '2024-11-02 11:58:33', 1342177281, 'submission.event.fileUploaded', 0);
INSERT INTO `event_log` (`log_id`, `assoc_type`, `assoc_id`, `user_id`, `date_logged`, `event_type`, `message`, `is_translated`) VALUES (15, 1048585, 2, 5, '2024-11-02 11:58:33', 1342177288, 'submission.event.fileRevised', 0);
INSERT INTO `event_log` (`log_id`, `assoc_type`, `assoc_id`, `user_id`, `date_logged`, `event_type`, `message`, `is_translated`) VALUES (16, 515, 2, 5, '2024-11-02 11:59:20', 1342177282, 'submission.event.fileDeleted', 0);
INSERT INTO `event_log` (`log_id`, `assoc_type`, `assoc_id`, `user_id`, `date_logged`, `event_type`, `message`, `is_translated`) VALUES (17, 515, 3, 5, '2024-11-02 11:59:41', 1342177281, 'submission.event.fileUploaded', 0);
INSERT INTO `event_log` (`log_id`, `assoc_type`, `assoc_id`, `user_id`, `date_logged`, `event_type`, `message`, `is_translated`) VALUES (18, 1048585, 2, 5, '2024-11-02 11:59:42', 1342177288, 'submission.event.fileRevised', 0);
INSERT INTO `event_log` (`log_id`, `assoc_type`, `assoc_id`, `user_id`, `date_logged`, `event_type`, `message`, `is_translated`) VALUES (19, 515, 3, 5, '2024-11-02 11:59:46', 1342177296, 'submission.event.fileEdited', 0);
INSERT INTO `event_log` (`log_id`, `assoc_type`, `assoc_id`, `user_id`, `date_logged`, `event_type`, `message`, `is_translated`) VALUES (20, 1048585, 2, 5, '2024-11-02 12:00:11', 268435457, 'submission.event.submissionSubmitted', 0);
INSERT INTO `event_log` (`log_id`, `assoc_type`, `assoc_id`, `user_id`, `date_logged`, `event_type`, `message`, `is_translated`) VALUES (21, 1048585, 2, 5, '2024-11-02 12:00:12', 268435465, 'submission.event.copyrightAgreed', 0);
INSERT INTO `event_log` (`log_id`, `assoc_type`, `assoc_id`, `user_id`, `date_logged`, `event_type`, `message`, `is_translated`) VALUES (22, 1048585, 3, 5, '2024-11-02 13:15:27', 268435458, 'submission.event.general.metadataUpdated', 0);
INSERT INTO `event_log` (`log_id`, `assoc_type`, `assoc_id`, `user_id`, `date_logged`, `event_type`, `message`, `is_translated`) VALUES (23, 1048585, 3, 5, '2024-11-02 13:15:27', 268435458, 'submission.event.general.metadataUpdated', 0);
INSERT INTO `event_log` (`log_id`, `assoc_type`, `assoc_id`, `user_id`, `date_logged`, `event_type`, `message`, `is_translated`) VALUES (24, 1048585, 3, 5, '2024-11-02 13:15:46', 268435458, 'submission.event.general.metadataUpdated', 0);
INSERT INTO `event_log` (`log_id`, `assoc_type`, `assoc_id`, `user_id`, `date_logged`, `event_type`, `message`, `is_translated`) VALUES (25, 515, 4, 5, '2024-11-02 13:16:29', 1342177281, 'submission.event.fileUploaded', 0);
INSERT INTO `event_log` (`log_id`, `assoc_type`, `assoc_id`, `user_id`, `date_logged`, `event_type`, `message`, `is_translated`) VALUES (26, 1048585, 3, 5, '2024-11-02 13:16:29', 1342177288, 'submission.event.fileRevised', 0);
INSERT INTO `event_log` (`log_id`, `assoc_type`, `assoc_id`, `user_id`, `date_logged`, `event_type`, `message`, `is_translated`) VALUES (27, 515, 4, 5, '2024-11-02 13:16:32', 1342177296, 'submission.event.fileEdited', 0);
INSERT INTO `event_log` (`log_id`, `assoc_type`, `assoc_id`, `user_id`, `date_logged`, `event_type`, `message`, `is_translated`) VALUES (28, 1048585, 3, 5, '2024-11-02 13:16:52', 268435457, 'submission.event.submissionSubmitted', 0);
INSERT INTO `event_log` (`log_id`, `assoc_type`, `assoc_id`, `user_id`, `date_logged`, `event_type`, `message`, `is_translated`) VALUES (29, 1048585, 3, 5, '2024-11-02 13:16:54', 268435465, 'submission.event.copyrightAgreed', 0);
INSERT INTO `event_log` (`log_id`, `assoc_type`, `assoc_id`, `user_id`, `date_logged`, `event_type`, `message`, `is_translated`) VALUES (30, 1048585, 3, 1, '2024-11-02 14:30:03', 805306371, 'editor.submission.decision.decline.log', 0);
INSERT INTO `event_log` (`log_id`, `assoc_type`, `assoc_id`, `user_id`, `date_logged`, `event_type`, `message`, `is_translated`) VALUES (31, 1048585, 4, 7, '2024-11-07 01:44:17', 268435458, 'submission.event.general.metadataUpdated', 0);
INSERT INTO `event_log` (`log_id`, `assoc_type`, `assoc_id`, `user_id`, `date_logged`, `event_type`, `message`, `is_translated`) VALUES (32, 1048585, 4, 7, '2024-11-07 01:44:17', 268435458, 'submission.event.general.metadataUpdated', 0);
INSERT INTO `event_log` (`log_id`, `assoc_type`, `assoc_id`, `user_id`, `date_logged`, `event_type`, `message`, `is_translated`) VALUES (33, 1048585, 4, 7, '2024-11-07 01:44:29', 268435458, 'submission.event.general.metadataUpdated', 0);
INSERT INTO `event_log` (`log_id`, `assoc_type`, `assoc_id`, `user_id`, `date_logged`, `event_type`, `message`, `is_translated`) VALUES (34, 515, 5, 7, '2024-11-07 01:44:35', 1342177281, 'submission.event.fileUploaded', 0);
INSERT INTO `event_log` (`log_id`, `assoc_type`, `assoc_id`, `user_id`, `date_logged`, `event_type`, `message`, `is_translated`) VALUES (35, 1048585, 4, 7, '2024-11-07 01:44:35', 1342177288, 'submission.event.fileRevised', 0);
INSERT INTO `event_log` (`log_id`, `assoc_type`, `assoc_id`, `user_id`, `date_logged`, `event_type`, `message`, `is_translated`) VALUES (36, 515, 5, 7, '2024-11-07 01:45:04', 1342177296, 'submission.event.fileEdited', 0);
INSERT INTO `event_log` (`log_id`, `assoc_type`, `assoc_id`, `user_id`, `date_logged`, `event_type`, `message`, `is_translated`) VALUES (37, 1048585, 4, 7, '2024-11-07 01:45:20', 268435457, 'submission.event.submissionSubmitted', 0);
INSERT INTO `event_log` (`log_id`, `assoc_type`, `assoc_id`, `user_id`, `date_logged`, `event_type`, `message`, `is_translated`) VALUES (38, 1048585, 4, 7, '2024-11-07 01:45:21', 268435465, 'submission.event.copyrightAgreed', 0);
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
) ENGINE=InnoDB AUTO_INCREMENT=109 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Data about an event log entry. This data is commonly used to display information about an event to a user.';

-- ----------------------------
-- Records of event_log_settings
-- ----------------------------
BEGIN;
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (22, 10, '', 'fileId', '1');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (23, 10, 'en', 'filename', 'LAPORAN MINGGUAN AKTUALISASI (3).pdf');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (24, 10, '', 'fileStage', '2');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (25, 10, '', 'submissionFileId', '1');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (26, 10, '', 'submissionId', '1');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (27, 10, '', 'username', 'peacee');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (28, 14, '', 'fileId', '2');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (29, 14, 'en', 'filename', 'Laporan_Instalasi_SSL_OJS3.pdf');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (30, 14, '', 'fileStage', '2');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (31, 14, '', 'submissionFileId', '2');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (32, 14, '', 'submissionId', '2');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (33, 14, '', 'username', 'darisman');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (34, 15, '', 'fileId', '2');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (35, 15, 'en', 'filename', 'Laporan_Instalasi_SSL_OJS3.pdf');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (36, 15, '', 'fileStage', '2');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (37, 15, '', 'submissionFileId', '2');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (38, 15, '', 'submissionId', '2');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (39, 15, '', 'username', 'darisman');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (40, 16, '', 'fileId', '2');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (41, 16, 'en', 'filename', 'Laporan_Instalasi_SSL_OJS3.pdf');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (42, 16, '', 'fileStage', '2');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (43, 16, '', 'submissionFileId', '2');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (44, 16, '', 'submissionId', '2');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (45, 16, '', 'username', 'darisman');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (46, 17, '', 'fileId', '3');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (47, 17, 'en', 'filename', 'Bukti Absensi Panitia_NEW.docx');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (48, 17, '', 'fileStage', '2');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (49, 17, '', 'submissionFileId', '3');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (50, 17, '', 'submissionId', '2');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (51, 17, '', 'username', 'darisman');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (52, 18, '', 'fileId', '3');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (53, 18, 'en', 'filename', 'Bukti Absensi Panitia_NEW.docx');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (54, 18, '', 'fileStage', '2');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (55, 18, '', 'submissionFileId', '3');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (56, 18, '', 'submissionId', '2');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (57, 18, '', 'username', 'darisman');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (58, 19, '', 'fileId', '3');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (59, 19, 'en', 'filename', 'Bukti Absensi Panitia_NEW.docx');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (60, 19, '', 'fileStage', '2');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (61, 19, '', 'submissionFileId', '3');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (62, 19, '', 'submissionId', '2');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (63, 19, '', 'username', 'darisman');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (64, 21, 'en', 'copyrightNotice', '<p>By submitting their work to the PEACEE Journal, authors agree to the following copyright terms:</p>\n<ol>\n<li>\n<p><strong>Copyright Ownership</strong>: Authors retain the copyright of their work and grant the PEACEE Journal the right to be the first publisher. Authors agree to license the article under a Creative Commons Attribution License (CC BY 4.0), permitting others to share, copy, and redistribute the material in any format, and adapt, remix, transform, and build upon the content for any purpose, including commercially, as long as appropriate credit is given to the authors and the original source.</p>\n</li>\n<li>\n<p><strong>Author Warranties</strong>: Authors warrant that:</p>\n<ul>\n<li>The submitted work is original, has not been previously published, and is not under consideration elsewhere.</li>\n<li>The work does not violate any existing copyright or other proprietary rights.</li>\n<li>All authors have reviewed and approved the final version of the manuscript and consent to its submission.</li>\n<li>The work does not contain any unlawful, defamatory, or privacy-violating content.</li>\n</ul>\n</li>\n<li>\n<p><strong>Permission for Distribution</strong>: Authors grant the PEACEE Journal permission to distribute, archive, and index their work through databases and platforms to ensure broad accessibility and dissemination.</p>\n</li>\n<li>\n<p><strong>Post-Publication Distribution</strong>: Authors are encouraged to share their published work (such as posting it in institutional repositories, personal websites, or academic networks) with acknowledgment of its original publication in the PEACEE Journal.</p>\n</li>\n</ol>\n<p>By confirming their agreement to these terms, authors consent to the processing of their submission according to this copyright notice.</p>');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (65, 21, '', 'userFullName', 'Aris');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (66, 21, '', 'username', 'darisman');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (67, 25, '', 'fileId', '4');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (68, 25, 'en', 'filename', 'Bukti Absensi Panitia_NEW.docx');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (69, 25, '', 'fileStage', '2');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (70, 25, '', 'submissionFileId', '4');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (71, 25, '', 'submissionId', '3');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (72, 25, '', 'username', 'darisman');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (73, 26, '', 'fileId', '4');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (74, 26, 'en', 'filename', 'Bukti Absensi Panitia_NEW.docx');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (75, 26, '', 'fileStage', '2');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (76, 26, '', 'submissionFileId', '4');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (77, 26, '', 'submissionId', '3');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (78, 26, '', 'username', 'darisman');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (79, 27, '', 'fileId', '4');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (80, 27, 'en', 'filename', 'Bukti Absensi Panitia_NEW.docx');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (81, 27, '', 'fileStage', '2');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (82, 27, '', 'submissionFileId', '4');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (83, 27, '', 'submissionId', '3');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (84, 27, '', 'username', 'darisman');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (85, 29, 'en', 'copyrightNotice', '<p>By submitting their work to the PEACEE Journal, authors agree to the following copyright terms:</p>\n<ol>\n<li>\n<p><strong>Copyright Ownership</strong>: Authors retain the copyright of their work and grant the PEACEE Journal the right to be the first publisher. Authors agree to license the article under a Creative Commons Attribution License (CC BY 4.0), permitting others to share, copy, and redistribute the material in any format, and adapt, remix, transform, and build upon the content for any purpose, including commercially, as long as appropriate credit is given to the authors and the original source.</p>\n</li>\n<li>\n<p><strong>Author Warranties</strong>: Authors warrant that:</p>\n<ul>\n<li>The submitted work is original, has not been previously published, and is not under consideration elsewhere.</li>\n<li>The work does not violate any existing copyright or other proprietary rights.</li>\n<li>All authors have reviewed and approved the final version of the manuscript and consent to its submission.</li>\n<li>The work does not contain any unlawful, defamatory, or privacy-violating content.</li>\n</ul>\n</li>\n<li>\n<p><strong>Permission for Distribution</strong>: Authors grant the PEACEE Journal permission to distribute, archive, and index their work through databases and platforms to ensure broad accessibility and dissemination.</p>\n</li>\n<li>\n<p><strong>Post-Publication Distribution</strong>: Authors are encouraged to share their published work (such as posting it in institutional repositories, personal websites, or academic networks) with acknowledgment of its original publication in the PEACEE Journal.</p>\n</li>\n</ol>\n<p>By confirming their agreement to these terms, authors consent to the processing of their submission according to this copyright notice.</p>');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (86, 29, '', 'userFullName', 'Aris');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (87, 29, '', 'username', 'darisman');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (88, 34, '', 'fileId', '5');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (89, 34, 'en', 'filename', '2. Laporan Pembaruan Sistem OJS.pdf');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (90, 34, '', 'fileStage', '2');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (91, 34, '', 'submissionFileId', '5');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (92, 34, '', 'submissionId', '4');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (93, 34, '', 'username', 'deasy-rde');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (94, 35, '', 'fileId', '5');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (95, 35, 'en', 'filename', '2. Laporan Pembaruan Sistem OJS.pdf');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (96, 35, '', 'fileStage', '2');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (97, 35, '', 'submissionFileId', '5');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (98, 35, '', 'submissionId', '4');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (99, 35, '', 'username', 'deasy-rde');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (100, 36, '', 'fileId', '5');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (101, 36, 'en', 'filename', '2. Laporan Pembaruan Sistem OJS.pdf');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (102, 36, '', 'fileStage', '2');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (103, 36, '', 'submissionFileId', '5');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (104, 36, '', 'submissionId', '4');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (105, 36, '', 'username', 'deasy-rde');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (106, 38, 'en', 'copyrightNotice', '<p>By submitting their work to the PEACEE Journal, authors agree to the following copyright terms:</p>\n<ol>\n<li>\n<p><strong>Copyright Ownership</strong>: Authors retain the copyright of their work and grant the PEACEE Journal the right to be the first publisher. Authors agree to license the article under a Creative Commons Attribution License (CC BY 4.0), permitting others to share, copy, and redistribute the material in any format, and adapt, remix, transform, and build upon the content for any purpose, including commercially, as long as appropriate credit is given to the authors and the original source.</p>\n</li>\n<li>\n<p><strong>Author Warranties</strong>: Authors warrant that:</p>\n<ul>\n<li>The submitted work is original, has not been previously published, and is not under consideration elsewhere.</li>\n<li>The work does not violate any existing copyright or other proprietary rights.</li>\n<li>All authors have reviewed and approved the final version of the manuscript and consent to its submission.</li>\n<li>The work does not contain any unlawful, defamatory, or privacy-violating content.</li>\n</ul>\n</li>\n<li>\n<p><strong>Permission for Distribution</strong>: Authors grant the PEACEE Journal permission to distribute, archive, and index their work through databases and platforms to ensure broad accessibility and dissemination.</p>\n</li>\n<li>\n<p><strong>Post-Publication Distribution</strong>: Authors are encouraged to share their published work (such as posting it in institutional repositories, personal websites, or academic networks) with acknowledgment of its original publication in the PEACEE Journal.</p>\n</li>\n</ol>\n<p>By confirming their agreement to these terms, authors consent to the processing of their submission according to this copyright notice.</p>');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (107, 38, '', 'userFullName', 'Athariz Raykarashy');
INSERT INTO `event_log_settings` (`event_log_setting_id`, `log_id`, `locale`, `setting_name`, `setting_value`) VALUES (108, 38, '', 'username', 'deasy-rde');
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='A log of all failed jobs.';

-- ----------------------------
-- Records of failed_jobs
-- ----------------------------
BEGIN;
INSERT INTO `failed_jobs` (`id`, `connection`, `queue`, `payload`, `exception`, `failed_at`) VALUES (1, 'database', 'queue', '{\"uuid\":\"eb6ad16a-2374-406c-a8c5-d56f944efa0f\",\"displayName\":\"PKP\\\\jobs\\\\notifications\\\\StatisticsReportMail\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":null,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":null,\"retryUntil\":null,\"data\":{\"commandName\":\"PKP\\\\jobs\\\\notifications\\\\StatisticsReportMail\",\"command\":\"O:43:\\\"PKP\\\\jobs\\\\notifications\\\\StatisticsReportMail\\\":7:{s:10:\\\"\\u0000*\\u0000userIds\\\";O:29:\\\"Illuminate\\\\Support\\\\Collection\\\":2:{s:8:\\\"\\u0000*\\u0000items\\\";a:1:{i:0;i:1;}s:28:\\\"\\u0000*\\u0000escapeWhenCastingToString\\\";b:0;}s:12:\\\"\\u0000*\\u0000contextId\\\";i:1;s:12:\\\"\\u0000*\\u0000dateStart\\\";O:17:\\\"DateTimeImmutable\\\":3:{s:4:\\\"date\\\";s:26:\\\"2024-10-01 00:00:00.000000\\\";s:13:\\\"timezone_type\\\";i:3;s:8:\\\"timezone\\\";s:3:\\\"UTC\\\";}s:10:\\\"\\u0000*\\u0000dateEnd\\\";O:17:\\\"DateTimeImmutable\\\":3:{s:4:\\\"date\\\";s:26:\\\"2024-11-01 00:00:00.000000\\\";s:13:\\\"timezone_type\\\";i:3;s:8:\\\"timezone\\\";s:3:\\\"UTC\\\";}s:10:\\\"connection\\\";s:8:\\\"database\\\";s:5:\\\"queue\\\";s:5:\\\"queue\\\";s:7:\\\"batchId\\\";s:36:\\\"9d617652-df79-48d0-a18b-92952f922b90\\\";}\"}}', '{\"message\":\"Class \\\"IntlDateFormatter\\\" not found\",\"code\":0,\"file\":\"\\/var\\/www\\/peacee\\/ojs-app\\/lib\\/pkp\\/jobs\\/notifications\\/StatisticsReportMail.php\",\"line\":67,\"trace\":[{\"file\":\"\\/var\\/www\\/peacee\\/ojs-app\\/lib\\/pkp\\/lib\\/vendor\\/laravel\\/framework\\/src\\/Illuminate\\/Container\\/BoundMethod.php\",\"line\":36,\"function\":\"handle\",\"class\":\"PKP\\\\jobs\\\\notifications\\\\StatisticsReportMail\",\"type\":\"->\"},{\"file\":\"\\/var\\/www\\/peacee\\/ojs-app\\/lib\\/pkp\\/lib\\/vendor\\/laravel\\/framework\\/src\\/Illuminate\\/Container\\/Util.php\",\"line\":41,\"function\":\"Illuminate\\\\Container\\\\{closure}\",\"class\":\"Illuminate\\\\Container\\\\BoundMethod\",\"type\":\"::\"},{\"file\":\"\\/var\\/www\\/peacee\\/ojs-app\\/lib\\/pkp\\/lib\\/vendor\\/laravel\\/framework\\/src\\/Illuminate\\/Container\\/BoundMethod.php\",\"line\":93,\"function\":\"unwrapIfClosure\",\"class\":\"Illuminate\\\\Container\\\\Util\",\"type\":\"::\"},{\"file\":\"\\/var\\/www\\/peacee\\/ojs-app\\/lib\\/pkp\\/lib\\/vendor\\/laravel\\/framework\\/src\\/Illuminate\\/Container\\/BoundMethod.php\",\"line\":37,\"function\":\"callBoundMethod\",\"class\":\"Illuminate\\\\Container\\\\BoundMethod\",\"type\":\"::\"},{\"file\":\"\\/var\\/www\\/peacee\\/ojs-app\\/lib\\/pkp\\/lib\\/vendor\\/laravel\\/framework\\/src\\/Illuminate\\/Container\\/Container.php\",\"line\":661,\"function\":\"call\",\"class\":\"Illuminate\\\\Container\\\\BoundMethod\",\"type\":\"::\"},{\"file\":\"\\/var\\/www\\/peacee\\/ojs-app\\/lib\\/pkp\\/lib\\/vendor\\/laravel\\/framework\\/src\\/Illuminate\\/Bus\\/Dispatcher.php\",\"line\":128,\"function\":\"call\",\"class\":\"Illuminate\\\\Container\\\\Container\",\"type\":\"->\"},{\"file\":\"\\/var\\/www\\/peacee\\/ojs-app\\/lib\\/pkp\\/lib\\/vendor\\/laravel\\/framework\\/src\\/Illuminate\\/Pipeline\\/Pipeline.php\",\"line\":141,\"function\":\"Illuminate\\\\Bus\\\\{closure}\",\"class\":\"Illuminate\\\\Bus\\\\Dispatcher\",\"type\":\"->\"},{\"file\":\"\\/var\\/www\\/peacee\\/ojs-app\\/lib\\/pkp\\/lib\\/vendor\\/laravel\\/framework\\/src\\/Illuminate\\/Pipeline\\/Pipeline.php\",\"line\":116,\"function\":\"Illuminate\\\\Pipeline\\\\{closure}\",\"class\":\"Illuminate\\\\Pipeline\\\\Pipeline\",\"type\":\"->\"},{\"file\":\"\\/var\\/www\\/peacee\\/ojs-app\\/lib\\/pkp\\/lib\\/vendor\\/laravel\\/framework\\/src\\/Illuminate\\/Bus\\/Dispatcher.php\",\"line\":132,\"function\":\"then\",\"class\":\"Illuminate\\\\Pipeline\\\\Pipeline\",\"type\":\"->\"},{\"file\":\"\\/var\\/www\\/peacee\\/ojs-app\\/lib\\/pkp\\/lib\\/vendor\\/laravel\\/framework\\/src\\/Illuminate\\/Queue\\/CallQueuedHandler.php\",\"line\":124,\"function\":\"dispatchNow\",\"class\":\"Illuminate\\\\Bus\\\\Dispatcher\",\"type\":\"->\"},{\"file\":\"\\/var\\/www\\/peacee\\/ojs-app\\/lib\\/pkp\\/lib\\/vendor\\/laravel\\/framework\\/src\\/Illuminate\\/Pipeline\\/Pipeline.php\",\"line\":141,\"function\":\"Illuminate\\\\Queue\\\\{closure}\",\"class\":\"Illuminate\\\\Queue\\\\CallQueuedHandler\",\"type\":\"->\"},{\"file\":\"\\/var\\/www\\/peacee\\/ojs-app\\/lib\\/pkp\\/lib\\/vendor\\/laravel\\/framework\\/src\\/Illuminate\\/Pipeline\\/Pipeline.php\",\"line\":116,\"function\":\"Illuminate\\\\Pipeline\\\\{closure}\",\"class\":\"Illuminate\\\\Pipeline\\\\Pipeline\",\"type\":\"->\"},{\"file\":\"\\/var\\/www\\/peacee\\/ojs-app\\/lib\\/pkp\\/lib\\/vendor\\/laravel\\/framework\\/src\\/Illuminate\\/Queue\\/CallQueuedHandler.php\",\"line\":126,\"function\":\"then\",\"class\":\"Illuminate\\\\Pipeline\\\\Pipeline\",\"type\":\"->\"},{\"file\":\"\\/var\\/www\\/peacee\\/ojs-app\\/lib\\/pkp\\/lib\\/vendor\\/laravel\\/framework\\/src\\/Illuminate\\/Queue\\/CallQueuedHandler.php\",\"line\":70,\"function\":\"dispatchThroughMiddleware\",\"class\":\"Illuminate\\\\Queue\\\\CallQueuedHandler\",\"type\":\"->\"},{\"file\":\"\\/var\\/www\\/peacee\\/ojs-app\\/lib\\/pkp\\/lib\\/vendor\\/laravel\\/framework\\/src\\/Illuminate\\/Queue\\/Jobs\\/Job.php\",\"line\":98,\"function\":\"call\",\"class\":\"Illuminate\\\\Queue\\\\CallQueuedHandler\",\"type\":\"->\"},{\"file\":\"\\/var\\/www\\/peacee\\/ojs-app\\/lib\\/pkp\\/lib\\/vendor\\/laravel\\/framework\\/src\\/Illuminate\\/Queue\\/Worker.php\",\"line\":425,\"function\":\"fire\",\"class\":\"Illuminate\\\\Queue\\\\Jobs\\\\Job\",\"type\":\"->\"},{\"file\":\"\\/var\\/www\\/peacee\\/ojs-app\\/lib\\/pkp\\/lib\\/vendor\\/laravel\\/framework\\/src\\/Illuminate\\/Queue\\/Worker.php\",\"line\":375,\"function\":\"process\",\"class\":\"Illuminate\\\\Queue\\\\Worker\",\"type\":\"->\"},{\"file\":\"\\/var\\/www\\/peacee\\/ojs-app\\/lib\\/pkp\\/lib\\/vendor\\/laravel\\/framework\\/src\\/Illuminate\\/Queue\\/Worker.php\",\"line\":326,\"function\":\"runJob\",\"class\":\"Illuminate\\\\Queue\\\\Worker\",\"type\":\"->\"},{\"file\":\"\\/var\\/www\\/peacee\\/ojs-app\\/lib\\/pkp\\/classes\\/core\\/PKPQueueProvider.php\",\"line\":104,\"function\":\"runNextJob\",\"class\":\"Illuminate\\\\Queue\\\\Worker\",\"type\":\"->\"},{\"file\":\"\\/var\\/www\\/peacee\\/ojs-app\\/lib\\/pkp\\/classes\\/queue\\/JobRunner.php\",\"line\":220,\"function\":\"runJobInQueue\",\"class\":\"PKP\\\\core\\\\PKPQueueProvider\",\"type\":\"->\"},{\"file\":\"\\/var\\/www\\/peacee\\/ojs-app\\/lib\\/pkp\\/classes\\/core\\/PKPQueueProvider.php\",\"line\":128,\"function\":\"processJobs\",\"class\":\"PKP\\\\queue\\\\JobRunner\",\"type\":\"->\"},{\"function\":\"PKP\\\\core\\\\{closure}\",\"class\":\"PKP\\\\core\\\\PKPQueueProvider\",\"type\":\"->\"}]}', '2024-11-01 01:01:07');
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
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Records information in the database about files tracked by the system, linking them to the local filesystem.';

-- ----------------------------
-- Records of files
-- ----------------------------
BEGIN;
INSERT INTO `files` (`file_id`, `path`, `mimetype`) VALUES (3, 'journals/1/articles/2/6726142ddea1f.docx', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document');
INSERT INTO `files` (`file_id`, `path`, `mimetype`) VALUES (4, 'journals/1/articles/3/6726262d86565.docx', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document');
INSERT INTO `files` (`file_id`, `path`, `mimetype`) VALUES (5, 'journals/1/articles/4/672c1b8325c3e.pdf', 'application/pdf');
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
INSERT INTO `job_batches` (`id`, `name`, `total_jobs`, `pending_jobs`, `failed_jobs`, `failed_job_ids`, `options`, `cancelled_at`, `created_at`, `finished_at`) VALUES ('9d617652-df79-48d0-a18b-92952f922b90', '', 2, 1, 1, '[\"eb6ad16a-2374-406c-a8c5-d56f944efa0f\"]', 'a:0:{}', 1730419267, 1730419225, 1730419267);
INSERT INTO `job_batches` (`id`, `name`, `total_jobs`, `pending_jobs`, `failed_jobs`, `failed_job_ids`, `options`, `cancelled_at`, `created_at`, `finished_at`) VALUES ('9d627f21-f63e-4e70-b642-b6c749a28baf', '', 1, 0, 0, '[]', 'a:0:{}', NULL, 1730463652, 1730463653);
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
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='All pending or in-progress jobs.';

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
) ENGINE=InnoDB AUTO_INCREMENT=116 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='More data about journals, including localized properties like policies.';

-- ----------------------------
-- Records of journal_settings
-- ----------------------------
BEGIN;
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (1, 1, 'en', 'acronym', 'PEACEE');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (2, 1, 'id', 'acronym', NULL);
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (3, 1, 'en', 'authorGuidelines', '<p>Authors should obtain all necessary permissions for any included material, such as photographs, documents, or datasets, before submission. Consent must be obtained from all listed authors, confirming their acknowledgment as contributors. Where applicable, research should also be approved by an ethics committee that complies with the legal requirements of the study\'s country.</p>\n<p>An editor may issue a desk rejection for submissions not meeting the journal’s quality standards. Authors are encouraged to carefully structure their study design and research arguments, ensuring clarity and logical flow. Titles should be succinct, and abstracts must be self-explanatory to attract potential reviewers. Once satisfied with the quality of their work, authors should follow the submission checklist below.</p>');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (4, 1, 'id', 'authorGuidelines', '<p>Para penulis diundang untuk mengirimkan naskahnya ke jurnal ini. Semua naskah akan dinilai oleh seorang editor untuk menentukan apakah sudah sesuai dengan tujuan dan cakupan jurnal ini. Naskah yang sesuai akan dikirimkan untuk ditinjau oleh mitra bestari sebelum menentukan apakah naskah tersebut akan diterima atau ditolak.</p><p>Sebelum mengirim, penulis bertanggung jawab untuk memperoleh izin untuk menerbitkan semua materi yang disertakan dalam naskah, seperti foto, dokumen, dan kumpulan data. Semua penulis yang tertera dalam naskah harus memberikan persetujuan untuk diakui sebagai penulis. Bila diperlukan, penelitian harus disetujui oleh suatu komite etik yang tepat sesuai dengan persyaratan hukum negara tempat penelitian.</p><p>Editor dapat menolak sebuah naskah jika tidak memenuhi standar minimum kualitas. Sebelum mengirim, pastikan bahwa desain penelitian dan argumen penelitian terstruktur dan dirumuskan dengan baik. Judul harus singkat dan abstrak harus bisa berdiri sendiri. Hal ini akan meningkatkan kemungkinan reviewer bersedia mereview naskah tersebut. Setelah sudah yakin telah memenuhi ketentuan ini, silakan tandai daftar periksa di bawah ini untuk menyiapkan naskah Anda.</p>');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (5, 1, 'en', 'authorInformation', 'Interested in submitting to this journal? We recommend that you review the <a href=\"http://peacee.id/index.php/journal/about\">About the Journal</a> page for the journal\'s section policies, as well as the <a href=\"http://peacee.id/index.php/journal/about/submissions#authorGuidelines\">Author Guidelines</a>. Authors need to <a href=\"http://peacee.id/index.php/journal/user/register\">register</a> with the journal prior to submitting or, if already registered, can simply <a href=\"http://peacee.id/index.php/index/login\">log in</a> and begin the five-step process.');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (6, 1, 'id', 'authorInformation', 'Tertarik menerbitkan jurnal? Kami merekomendasikan Anda mereview halaman <a href=\"http://peacee.id/index.php/journal/about\">Tentang Kami </a>untuk kebijakan bagian jurnal serta <a href=\"http://peacee.id/index.php/journal/about/submissions#authorGuidelines\">Petunjuk Penulis </a>. Penulis perlu <a href=\"http://peacee.id/index.php/journal/user/register\">Mendaftar </a>dengan jurnal sebelum menyerahkan atau jika sudah terdaftar <a href=\"http://peacee.id/index.php/index/login\">login</a>dan mulai proses lima langkah.');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (7, 1, 'en', 'beginSubmissionHelp', '<p>Thank you for submitting to the PEACEE journal. You will be asked to upload files, identify co-authors, and provide information such as the title and abstract.</p>\n<p>Please read our <a href=\"http://peacee.id/index.php/journal/about/submissions\" target=\"_blank\" rel=\"noopener\">Submission Guidelines</a> if you have not done so already. When filling out the forms, provide as many details as possible to help our editors evaluate your work.</p>\n<p>Once you begin, you can save your submission and come back to it later. You will be able to review and correct any information before you submit it.</p>');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (8, 1, 'id', 'beginSubmissionHelp', '##default.submission.step.beforeYouBegin##');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (9, 1, '', 'contactEmail', 'peacee@upi.edu');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (10, 1, '', 'contactName', 'Editorial Team PEACEE');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (11, 1, 'en', 'contributorsHelp', '<p>Add details for all of the contributors to this submission. Contributors added here will be sent an email confirmation of the submission, as well as a copy of all editorial decisions recorded against this submission.</p><p>If a contributor can not be contacted by email, because they must remain anonymous or do not have an email account, please do not enter a fake email address. You can add information about this contributor in a message to the editor at a later step in the submission process.</p>');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (12, 1, 'id', 'contributorsHelp', '##default.submission.step.contributors##');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (13, 1, '', 'country', 'ID');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (14, 1, '', 'defaultReviewMode', '2');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (17, 1, 'en', 'detailsHelp', '<p>Please provide the following details to help us manage your submission in our system.</p>');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (18, 1, 'id', 'detailsHelp', '##default.submission.step.details##');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (19, 1, '', 'copySubmissionAckPrimaryContact', '1');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (21, 1, '', 'emailSignature', '<p><strong>Best regards,</strong><br />The Editorial Team of PEACEE Journal<br /><strong>PEACEE Journal</strong> – Progress in Electrical and Computer Engineering Education<br />Universitas Pendidikan Indonesia<br />Jl. Setiabudi 229, Isola, Bandung, INDONESIA<br />Email: <a rel=\"noopener\">peacee@upi.edu</a><br />Website: <a href=\"http://peacee.id/index.php/journal/index\" target=\"_new\" rel=\"noopener\">http://peacee.id/index.php/journal/index</a></p>\n<p><em>This message was sent automatically by the PEACEE Journal system. Please do not reply directly to this email. For further inquiries, contact us at <a rel=\"noopener\">peacee@upi.edu</a>.</em></p>');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (22, 1, '', 'enableDois', '1');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (23, 1, '', 'doiSuffixType', 'default');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (24, 1, '', 'registrationAgency', '');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (25, 1, '', 'disableSubmissions', '0');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (26, 1, '', 'editorialStatsEmail', '0');
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
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (51, 1, '', 'supportedFormLocales', '[\"en\"]');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (52, 1, '', 'supportedLocales', '[\"en\",\"id\"]');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (53, 1, '', 'supportedSubmissionLocales', '[\"en\"]');
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
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (75, 1, '', 'sidebar', '[\"WebFeedBlockPlugin\",\"languagetoggleblockplugin\"]');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (80, 1, 'en', 'editorialTeam', '<p><strong>Editor-in-Chief</strong><br />Prof. Ade Gafar Abdullah, M.Si. (<a href=\"https://www.scopus.com/authid/detail.uri?authorId=36808946900&amp;amp;eid=2-s2.0-85078967983\" target=\"_blank\" rel=\"noopener\">Scopus ID: 36808946900</a>), Universitas Pendidikan Indonesia.</p>\n<p><strong>Vice Editor-in-Chief</strong><br />Didin Wahyudin, Universitas Pendidikan Indonesia.</p>\n<p><strong>International Scientific Editorial Advisory Board</strong><br />Lala Septem Riza, (<a href=\"https://www.scopus.com/authid/detail.uri?authorId=55243551900\" target=\"_blank\" rel=\"noopener\">Scopus ID: 55243551900</a>), Universitas Pendidikan Indonesia.<br />Iwan Kustiawan, (<a href=\"https://www.scopus.com/authid/detail.uri?authorId=55846210200\" target=\"_blank\" rel=\"noopener\">Scopus ID: 55846210200</a>), Universitas Pendidikan Indonesia.<br />Aip Saripudin, (<a href=\"https://www.scopus.com/authid/detail.uri?authorId=57006754900\" target=\"_blank\" rel=\"noopener\">Scopus ID: 57006754900</a>), Institut Teknologi Bandung.<br />Shinobu Hasegawa, (<a href=\"https://www.scopus.com/authid/detail.uri?authorId=13403022500\" target=\"_blank\" rel=\"noopener\">Scopus ID: 13403022500</a>), Institut Teknologi Bandung.<br />Yuto Lim, (<a href=\"https://www.scopus.com/authid/detail.uri?authorId=50662259100\" target=\"_blank\" rel=\"noopener\">Scopus ID: 50662259100</a>), Sampoerna University.</p>\n<p><strong>Editorial Support Board</strong><br />R. Deasy Mandasari, (<a href=\"https://www.scopus.com/authid/detail.uri?authorId=58861199100\" target=\"_blank\" rel=\"noopener\">Scopus ID: <span class=\"Typography-module__lVnit Typography-module__Nfgvc\" data-testid=\"authorId\">58861199100</span></a>), Universitas Pendidikan Indonesia.<br />Abdu Yakan Rosyadi, Universitas Pendidikan Indonesia.<br />Ibnu Hartopo, Universitas Pendidikan Indonesia.</p>');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (81, 1, 'en', 'pageFooter', '<p><strong>Editorial Board of PEACEE</strong><br />Electrical Engineering, Universitas Pendidikan Indonesia<br />Jl. Setiabudi 229, Isola, Bandung, INDONESIA<br />Email: <a rel=\"noopener\">peacee@upi.edu</a><br />Website: <a href=\"http://peacee.id/index.php/journal/index\" target=\"_new\" rel=\"noopener\">http://peacee.id</a></p>');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (85, 1, 'en', 'about', '<p>The PEACEE Journal is dedicated to advancing and disseminating research in the fields of Electrical Engineering, Electronics Engineering, Mechatronics, Informatics, Industrial Automation, and the education disciplines related to Computer, Electrical, and Electronics Engineering. As an open-access journal, PEACEE provides unrestricted online access to research, allowing readers, authors, and reviewers to freely access and share published articles.</p>\n<p><strong>Focus and Scope</strong></p>\n<p>Our journal publishes peer-reviewed articles that encompass a wide range of technical and educational topics within the specified fields, including but not limited to innovations in engineering education and advancements in industry practices.</p>\n<p><strong>Publication Frequency</strong></p>\n<p>PEACEE Journal is published biannually in January and July, beginning January 2025. Each issue will contain a minimum of ten articles, with at least one invited article from an international contributor to encourage global perspectives in research.</p>\n<p><strong>Copyright and Open Access Policy</strong></p>\n<p>PEACEE Journal operates under a comprehensive open-access policy, where articles are licensed to allow readers and authors to distribute and utilize the published material with appropriate citation. Copyright remains with the authors, ensuring their intellectual property is preserved while promoting accessibility.</p>\n<p><strong>Archiving Policy</strong></p>\n<p>To secure long-term preservation of content, PEACEE Journal participates in archival systems such as LOCKSS and CLOCKSS. This ensures that all articles are stored in a secure digital archive and remain accessible even in the event of unforeseen technical challenges.</p>\n<p><strong>Sponsorship</strong></p>\n<p>The journal is supported by educational and industry partners who are committed to furthering knowledge in engineering and technology fields. This sponsorship enables us to maintain our commitment to open-access publication without compromising quality or accessibility.</p>\n<p><strong>Privacy Statement</strong></p>\n<p>PEACEE Journal values the privacy of all its contributors and readers. Personal data collected for journal management purposes is handled securely and will not be shared with third parties without explicit consent, in line with international data protection standards.</p>\n<p>We invite researchers, practitioners, and educators to contribute to and benefit from the high-quality content available through the PEACEE Journal, as we strive to foster an inclusive and innovative environment for academic and professional advancement.</p>');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (86, 1, '', 'publisherInstitution', 'Electrical Engineering, Universitas Pendidikan Indonesia');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (87, 1, 'en', 'description', '<p>The PEACEE Journal is a peer-reviewed, open-access publication that serves as a platform for high-quality research in the fields of Electrical Engineering, Electronics Engineering, Mechatronics, Informatics, Industrial Automation, and Engineering Education. By fostering the sharing of cutting-edge research and methodologies, the journal aims to contribute significantly to both academic scholarship and practical advancements in these specialized fields.</p>\n<p>The editorial team, led by experienced scholars and practitioners from prominent institutions, upholds the journal\'s rigorous academic standards, ensuring quality and relevance for its readership and contributors.</p>');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (88, 1, '', 'onlineIssn', '0000-0000');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (89, 1, 'en', 'contactAffiliation', 'Universitas Pendidikan Indonesia');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (90, 1, '', 'supportEmail', 'deasy@upi.edu');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (91, 1, '', 'supportName', 'R Deasy Mandasari');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (92, 1, '', 'supportPhone', '087808878698');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (94, 1, '', 'enableAnnouncements', '1');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (95, 1, 'en', 'dateFormatLong', '%B %e, %Y');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (96, 1, 'en', 'dateFormatShort', '%Y-%m-%d');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (97, 1, 'en', 'datetimeFormatLong', '%B %e, %Y - %I:%M %p');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (98, 1, 'en', 'datetimeFormatShort', '%Y-%m-%d %I:%M %p');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (99, 1, 'en', 'timeFormat', '%I:%M %p');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (100, 1, '', 'numAnnouncementsHomepage', '1');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (101, 1, 'en', 'copyrightNotice', '<p>By submitting their work to the PEACEE Journal, authors agree to the following copyright terms:</p>\n<ol>\n<li>\n<p><strong>Copyright Ownership</strong>: Authors retain the copyright of their work and grant the PEACEE Journal the right to be the first publisher. Authors agree to license the article under a Creative Commons Attribution License (CC BY 4.0), permitting others to share, copy, and redistribute the material in any format, and adapt, remix, transform, and build upon the content for any purpose, including commercially, as long as appropriate credit is given to the authors and the original source.</p>\n</li>\n<li>\n<p><strong>Author Warranties</strong>: Authors warrant that:</p>\n<ul>\n<li>The submitted work is original, has not been previously published, and is not under consideration elsewhere.</li>\n<li>The work does not violate any existing copyright or other proprietary rights.</li>\n<li>All authors have reviewed and approved the final version of the manuscript and consent to its submission.</li>\n<li>The work does not contain any unlawful, defamatory, or privacy-violating content.</li>\n</ul>\n</li>\n<li>\n<p><strong>Permission for Distribution</strong>: Authors grant the PEACEE Journal permission to distribute, archive, and index their work through databases and platforms to ensure broad accessibility and dissemination.</p>\n</li>\n<li>\n<p><strong>Post-Publication Distribution</strong>: Authors are encouraged to share their published work (such as posting it in institutional repositories, personal websites, or academic networks) with acknowledgment of its original publication in the PEACEE Journal.</p>\n</li>\n</ol>\n<p>By confirming their agreement to these terms, authors consent to the processing of their submission according to this copyright notice.</p>');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (102, 1, '', 'restrictReviewerFileAccess', '1');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (103, 1, '', 'reviewerAccessKeysEnabled', '1');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (104, 1, 'en', 'competingInterests', '<p>The PEACEE Journal requires authors and reviewers to disclose any competing interests that could influence, or be perceived to influence, their work or its evaluation.</p>\n<p><strong>For Authors</strong>:</p>\n<ul>\n<li>Authors must disclose any potential financial or non-financial conflicts of interest related to the work submitted, including funding sources, employment, consultancies, or personal relationships that may influence the research.</li>\n<li>Authors should declare if any sponsor had any role in the study design, data collection, analysis, publication decisions, or manuscript preparation.</li>\n</ul>\n<p><strong>For Reviewers</strong>:</p>\n<ul>\n<li>Reviewers are required to disclose any conflicts of interest that may bias their review. If any such competing interest exists, reviewers should notify the editor and may be excused from the review process.</li>\n<li>Competing interests include professional, financial, or personal relationships with any of the authors or affiliations that might interfere with the objectivity of the review.</li>\n</ul>\n<p>By adhering to these standards, authors and reviewers contribute to maintaining the credibility, transparency, and academic integrity of the PEACEE Journal.</p>');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (105, 1, 'en', 'reviewGuidelines', '<p>As a reviewer for the PEACEE Journal, you play a crucial role in ensuring the quality and integrity of published research. Please follow these guidelines to provide constructive and objective feedback:</p>\n<ol>\n<li>\n<p><strong>Confidentiality</strong>: Reviewers must treat manuscripts as confidential documents. Do not share or discuss the manuscript with others outside of the review process unless authorized by the editor.</p>\n</li>\n<li>\n<p><strong>Objectivity and Fairness</strong>: Provide objective feedback based on the manuscript’s content, quality, and scientific merit. Avoid personal comments, and assess the work fairly, without discrimination or bias based on the authors\' race, gender, nationality, or affiliation.</p>\n</li>\n<li>\n<p><strong>Structure and Clarity</strong>:</p>\n<ul>\n<li><strong>Title and Abstract</strong>: Evaluate whether the title accurately reflects the study’s content and whether the abstract provides a clear summary of the objectives, methods, results, and conclusions.</li>\n<li><strong>Introduction</strong>: Assess whether the background, objectives, and significance of the study are clearly stated.</li>\n<li><strong>Methodology</strong>: Examine whether the methods are appropriate, clearly described, and reproducible. Check for the adequacy of data collection, sample size, and statistical analysis.</li>\n<li><strong>Results</strong>: Ensure that the results are presented clearly, objectively, and logically, supported by figures, tables, or other illustrations where appropriate.</li>\n<li><strong>Discussion and Conclusion</strong>: Assess whether the discussion relates findings to existing literature, clearly explains their significance, and is supported by the data.</li>\n<li><strong>References</strong>: Check for relevant and recent references, ensuring they are correctly cited according to the journal’s format.</li>\n</ul>\n</li>\n<li>\n<p><strong>Originality and Contribution</strong>: Evaluate the novelty of the research and its contribution to the field of Electrical Engineering, Electronics Engineering, Mechatronics, Informatics, Automation Industry, and related disciplines. Highlight any areas that could enhance the manuscript’s originality or relevance.</p>\n</li>\n<li>\n<p><strong>Recommendations</strong>: Provide a clear recommendation to the editor (e.g., accept, minor revisions, major revisions, reject) along with a rationale for your decision.</p>\n</li>\n<li>\n<p><strong>Timeliness</strong>: Reviewers should complete reviews within the agreed-upon timeframe. If unable to meet the deadline, please inform the editor as soon as possible.</p>\n</li>\n</ol>');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (106, 1, '', 'copyrightHolderType', 'author');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (107, 1, '', 'licenseUrl', 'https://creativecommons.org/licenses/by/4.0');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (108, 1, 'en', 'announcementsIntroduction', '<p><strong>Call for Papers – Inaugural Edition, January 2025</strong></p>\n<p>The PEACEE Journal is excited to announce its call for papers for the inaugural edition, scheduled for publication in January 2025. We invite researchers, practitioners, and academics to submit high-quality research articles that contribute to the fields of Electrical Engineering, Electronics Engineering, Mechatronics, Informatics, Industrial Automation, and Engineering Education.</p>\n<p><strong>Important Dates:</strong></p>\n<ul>\n<li><strong>Submission Deadline</strong>: October 31, 2024</li>\n<li><strong>Peer Review Process</strong>: November 2024</li>\n<li><strong>Final Decision</strong>: December 2024</li>\n<li><strong>Publication Date</strong>: January 2025</li>\n</ul>\n<p><strong>Submission and Review Process:</strong></p>\n<p>All submissions will undergo a rigorous peer-review process to ensure high standards of quality and academic integrity. The initial editorial review will assess submissions for relevance to the journal\'s scope, originality, and adherence to submission guidelines. Submissions passing this stage will then be evaluated by independent reviewers in a double-blind peer review to maintain impartiality and ensure constructive feedback.</p>\n<p>Submissions must follow the journal’s Author Guidelines, including obtaining necessary permissions for included materials and ensuring ethical compliance. Authors are encouraged to ensure clarity in their research questions, methodology, and analysis to improve the likelihood of acceptance.</p>\n<p>We look forward to your contributions and to shaping this exciting inaugural issue together. Submit your manuscript and be a part of the PEACEE Journal’s debut edition!</p>');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (109, 1, 'en', 'additionalHomeContent', '<h3><strong>Welcome to the PEACEE Journal</strong></h3>\n<p>Welcome to the <strong>PEACEE Journal</strong> – an academic journal dedicated to research and innovation in Electrical Engineering, Electronics Engineering, Mechatronics, Informatics, Industrial Automation, and Computer/Electrical/Electronics Engineering Education. This journal provides a platform for researchers, academics, and practitioners to share their latest findings, ideas, and developments that contribute to scientific and technological advancements.</p>\n<h4><strong>Why Choose the PEACEE Journal?</strong></h4>\n<ul>\n<li><strong>High Academic Standards</strong>: The PEACEE Journal boasts an international editorial board and reviewers with strong academic backgrounds, ensuring the quality and integrity of every published article.</li>\n<li><strong>Open Access</strong>: We support open access so that published articles can be freely accessed by readers worldwide, broadening scientific impact and facilitating knowledge dissemination.</li>\n<li><strong>Multidisciplinary Focus</strong>: Covering various disciplines in engineering and engineering education, the journal offers opportunities for cross-disciplinary collaboration and new insights.</li>\n</ul>\n<h4><strong>Inaugural Issue Coming Soon</strong></h4>\n<p>We are excited to announce that the inaugural issue of the PEACEE Journal will be published in <strong>January 2025</strong>. This debut edition will feature cutting-edge research on a range of topics within our focus areas, setting the stage for impactful contributions to engineering and technology.</p>\n<h4><strong>Important Dates for the January 2025 Issue</strong></h4>\n<ul>\n<li><strong>Submission Deadline</strong>: October 31, 2024</li>\n<li><strong>Peer Review Process</strong>: November 2024</li>\n<li><strong>Final Decision</strong>: December 2024</li>\n<li><strong>Publication Date</strong>: January 2025</li>\n</ul>\n<p>The PEACEE Journal is published biannually in <strong>January and July</strong>, allowing for a regular platform to showcase new research and insights.</p>\n<h4><strong>Fast and Fair Publication Process</strong></h4>\n<p>With a transparent and efficient peer-review system, the PEACEE Journal ensures that every manuscript is evaluated objectively and processed quickly without compromising quality. We invite researchers to submit their best work and become part of our scientific community.</p>\n<h4><strong>Join Us as a Contributor!</strong></h4>\n<p>We welcome authors and reviewers to join the PEACEE Journal. If you have innovative research or expertise in one of our focus areas, submit your manuscript or apply as a reviewer.</p>');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (110, 1, '', 'disableUserReg', '0');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (111, 1, '', 'restrictSiteAccess', '0');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (112, 1, '', 'restrictArticleAccess', '0');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (113, 1, 'en', 'favicon', '{\"name\":\"favicon.ico\",\"uploadName\":\"favicon_en.ico\",\"width\":48,\"height\":48,\"dateUploaded\":\"2024-11-03 03:18:19\",\"altText\":\"peacee\"}');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (114, 1, 'en', 'homepageImage', '{\"name\":\"2. Softcopy Pengumuman Call for Papers.png\",\"uploadName\":\"homepageImage_en.png\",\"width\":1587,\"height\":2245,\"dateUploaded\":\"2024-11-06 02:29:53\",\"altText\":\"PEACEE 2024 Call for Papers by UPI with the theme \\\"Advancing Innovation in Engineering and Education.\\\" Free submission, deadline October 31, 2024, publication in January 2025. Topics include Renewable Energy, Robotics, AI, Automation, Engineering Education, and Embedded Systems. More info: peacee.id.\"}');
INSERT INTO `journal_settings` (`journal_setting_id`, `journal_id`, `locale`, `setting_name`, `setting_value`) VALUES (115, 1, '', 'envelopeSender', 'peacee@upi.edu');
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
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Daily statistics for views of the homepage.';

-- ----------------------------
-- Records of metrics_context
-- ----------------------------
BEGIN;
INSERT INTO `metrics_context` (`metrics_context_id`, `load_id`, `context_id`, `date`, `metric`) VALUES (1, 'usage_events_20241026.log', 1, '2024-10-26', 33);
INSERT INTO `metrics_context` (`metrics_context_id`, `load_id`, `context_id`, `date`, `metric`) VALUES (2, 'usage_events_20241027.log', 1, '2024-10-27', 5);
INSERT INTO `metrics_context` (`metrics_context_id`, `load_id`, `context_id`, `date`, `metric`) VALUES (3, 'usage_events_20241028.log', 1, '2024-10-28', 4);
INSERT INTO `metrics_context` (`metrics_context_id`, `load_id`, `context_id`, `date`, `metric`) VALUES (4, 'usage_events_20241030.log', 1, '2024-10-30', 2);
INSERT INTO `metrics_context` (`metrics_context_id`, `load_id`, `context_id`, `date`, `metric`) VALUES (5, 'usage_events_20241031.log', 1, '2024-10-31', 8);
INSERT INTO `metrics_context` (`metrics_context_id`, `load_id`, `context_id`, `date`, `metric`) VALUES (6, 'usage_events_20241101.log', 1, '2024-11-01', 41);
INSERT INTO `metrics_context` (`metrics_context_id`, `load_id`, `context_id`, `date`, `metric`) VALUES (7, 'usage_events_20241102.log', 1, '2024-11-02', 28);
INSERT INTO `metrics_context` (`metrics_context_id`, `load_id`, `context_id`, `date`, `metric`) VALUES (8, 'usage_events_20241103.log', 1, '2024-11-03', 5);
INSERT INTO `metrics_context` (`metrics_context_id`, `load_id`, `context_id`, `date`, `metric`) VALUES (9, 'usage_events_20241104.log', 1, '2024-11-04', 18);
INSERT INTO `metrics_context` (`metrics_context_id`, `load_id`, `context_id`, `date`, `metric`) VALUES (10, 'usage_events_20241105.log', 1, '2024-11-05', 17);
INSERT INTO `metrics_context` (`metrics_context_id`, `load_id`, `context_id`, `date`, `metric`) VALUES (11, 'usage_events_20241106.log', 1, '2024-11-06', 11);
INSERT INTO `metrics_context` (`metrics_context_id`, `load_id`, `context_id`, `date`, `metric`) VALUES (12, 'usage_events_20241107.log', 1, '2024-11-07', 22);
INSERT INTO `metrics_context` (`metrics_context_id`, `load_id`, `context_id`, `date`, `metric`) VALUES (13, 'usage_events_20241108.log', 1, '2024-11-08', 5);
INSERT INTO `metrics_context` (`metrics_context_id`, `load_id`, `context_id`, `date`, `metric`) VALUES (14, 'usage_events_20241109.log', 1, '2024-11-09', 5);
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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='More data about navigation menu item assignments to navigation menus, including localized content.';

-- ----------------------------
-- Records of navigation_menu_item_assignment_settings
-- ----------------------------
BEGIN;
INSERT INTO `navigation_menu_item_assignment_settings` (`navigation_menu_item_assignment_setting_id`, `navigation_menu_item_assignment_id`, `locale`, `setting_name`, `setting_value`, `setting_type`) VALUES (6, 57, 'en', 'title', 'Editorial Board', 'string');
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
) ENGINE=InnoDB AUTO_INCREMENT=60 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Links navigation menu items to navigation menus.';

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
INSERT INTO `navigation_menu_item_assignments` (`navigation_menu_item_assignment_id`, `navigation_menu_id`, `navigation_menu_item_id`, `parent_id`, `seq`) VALUES (11, 2, 11, 10, 0);
INSERT INTO `navigation_menu_item_assignments` (`navigation_menu_item_assignment_id`, `navigation_menu_id`, `navigation_menu_item_id`, `parent_id`, `seq`) VALUES (12, 2, 12, 10, 1);
INSERT INTO `navigation_menu_item_assignments` (`navigation_menu_item_assignment_id`, `navigation_menu_id`, `navigation_menu_item_id`, `parent_id`, `seq`) VALUES (13, 2, 13, 10, 2);
INSERT INTO `navigation_menu_item_assignments` (`navigation_menu_item_assignment_id`, `navigation_menu_id`, `navigation_menu_item_id`, `parent_id`, `seq`) VALUES (14, 2, 14, 10, 3);
INSERT INTO `navigation_menu_item_assignments` (`navigation_menu_item_assignment_id`, `navigation_menu_id`, `navigation_menu_item_id`, `parent_id`, `seq`) VALUES (55, 3, 19, 0, 0);
INSERT INTO `navigation_menu_item_assignments` (`navigation_menu_item_assignment_id`, `navigation_menu_id`, `navigation_menu_item_id`, `parent_id`, `seq`) VALUES (56, 3, 20, 0, 1);
INSERT INTO `navigation_menu_item_assignments` (`navigation_menu_item_assignment_id`, `navigation_menu_id`, `navigation_menu_item_id`, `parent_id`, `seq`) VALUES (57, 3, 21, 0, 2);
INSERT INTO `navigation_menu_item_assignments` (`navigation_menu_item_assignment_id`, `navigation_menu_id`, `navigation_menu_item_id`, `parent_id`, `seq`) VALUES (58, 3, 17, 0, 3);
INSERT INTO `navigation_menu_item_assignments` (`navigation_menu_item_assignment_id`, `navigation_menu_id`, `navigation_menu_item_id`, `parent_id`, `seq`) VALUES (59, 3, 12, 0, 4);
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
INSERT INTO `navigation_menu_item_settings` (`navigation_menu_item_setting_id`, `navigation_menu_item_id`, `locale`, `setting_name`, `setting_value`, `setting_type`) VALUES (25, 21, 'en', 'title', 'Editorial Board', 'string');
INSERT INTO `navigation_menu_item_settings` (`navigation_menu_item_setting_id`, `navigation_menu_item_id`, `locale`, `setting_name`, `setting_value`, `setting_type`) VALUES (26, 21, 'en', 'content', '', 'string');
INSERT INTO `navigation_menu_item_settings` (`navigation_menu_item_setting_id`, `navigation_menu_item_id`, `locale`, `setting_name`, `setting_value`, `setting_type`) VALUES (27, 21, 'en', 'remoteUrl', '', 'string');
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
INSERT INTO `navigation_menu_items` (`navigation_menu_item_id`, `context_id`, `path`, `type`) VALUES (21, 1, '', 'NMI_TYPE_EDITORIAL_TEAM');
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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Navigation menus on the website are installed with the software as a default set, and can be customized.';

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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Notes allow users to annotate associated entities, such as submissions.';

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
) ENGINE=InnoDB AUTO_INCREMENT=76 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='More data about notifications, including localized properties.';

-- ----------------------------
-- Records of notification_settings
-- ----------------------------
BEGIN;
INSERT INTO `notification_settings` (`notification_setting_id`, `notification_id`, `locale`, `setting_name`, `setting_value`, `setting_type`) VALUES (45, 45, '', 'contents', 'Call for Papers – Inaugural Edition, January 2025', 'string');
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
) ENGINE=InnoDB AUTO_INCREMENT=104 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='User notifications created during certain operations.';

-- ----------------------------
-- Records of notifications
-- ----------------------------
BEGIN;
INSERT INTO `notifications` (`notification_id`, `context_id`, `user_id`, `level`, `type`, `date_created`, `date_read`, `assoc_type`, `assoc_id`) VALUES (45, 1, 1, 2, 8, '2024-11-01 12:20:53', NULL, 0, 0);
INSERT INTO `notifications` (`notification_id`, `context_id`, `user_id`, `level`, `type`, `date_created`, `date_read`, `assoc_type`, `assoc_id`) VALUES (77, 1, NULL, 3, 16777220, '2024-11-02 12:00:04', NULL, 1048585, 2);
INSERT INTO `notifications` (`notification_id`, `context_id`, `user_id`, `level`, `type`, `date_created`, `date_read`, `assoc_type`, `assoc_id`) VALUES (78, 1, NULL, 3, 16777222, '2024-11-02 12:00:04', NULL, 1048585, 2);
INSERT INTO `notifications` (`notification_id`, `context_id`, `user_id`, `level`, `type`, `date_created`, `date_read`, `assoc_type`, `assoc_id`) VALUES (79, 1, NULL, 3, 16777223, '2024-11-02 12:00:04', NULL, 1048585, 2);
INSERT INTO `notifications` (`notification_id`, `context_id`, `user_id`, `level`, `type`, `date_created`, `date_read`, `assoc_type`, `assoc_id`) VALUES (80, 1, NULL, 3, 16777224, '2024-11-02 12:00:04', NULL, 1048585, 2);
INSERT INTO `notifications` (`notification_id`, `context_id`, `user_id`, `level`, `type`, `date_created`, `date_read`, `assoc_type`, `assoc_id`) VALUES (81, 1, 1, 3, 16777247, '2024-11-02 12:00:06', NULL, 1048585, 2);
INSERT INTO `notifications` (`notification_id`, `context_id`, `user_id`, `level`, `type`, `date_created`, `date_read`, `assoc_type`, `assoc_id`) VALUES (82, 1, 4, 3, 16777247, '2024-11-02 12:00:06', NULL, 1048585, 2);
INSERT INTO `notifications` (`notification_id`, `context_id`, `user_id`, `level`, `type`, `date_created`, `date_read`, `assoc_type`, `assoc_id`) VALUES (85, 1, NULL, 3, 16777220, '2024-11-02 13:16:47', NULL, 1048585, 3);
INSERT INTO `notifications` (`notification_id`, `context_id`, `user_id`, `level`, `type`, `date_created`, `date_read`, `assoc_type`, `assoc_id`) VALUES (86, 1, NULL, 3, 16777222, '2024-11-02 13:16:47', NULL, 1048585, 3);
INSERT INTO `notifications` (`notification_id`, `context_id`, `user_id`, `level`, `type`, `date_created`, `date_read`, `assoc_type`, `assoc_id`) VALUES (87, 1, NULL, 3, 16777223, '2024-11-02 13:16:47', NULL, 1048585, 3);
INSERT INTO `notifications` (`notification_id`, `context_id`, `user_id`, `level`, `type`, `date_created`, `date_read`, `assoc_type`, `assoc_id`) VALUES (88, 1, NULL, 3, 16777224, '2024-11-02 13:16:47', NULL, 1048585, 3);
INSERT INTO `notifications` (`notification_id`, `context_id`, `user_id`, `level`, `type`, `date_created`, `date_read`, `assoc_type`, `assoc_id`) VALUES (89, 1, 1, 3, 16777247, '2024-11-02 13:16:47', NULL, 1048585, 3);
INSERT INTO `notifications` (`notification_id`, `context_id`, `user_id`, `level`, `type`, `date_created`, `date_read`, `assoc_type`, `assoc_id`) VALUES (90, 1, 4, 3, 16777247, '2024-11-02 13:16:47', NULL, 1048585, 3);
INSERT INTO `notifications` (`notification_id`, `context_id`, `user_id`, `level`, `type`, `date_created`, `date_read`, `assoc_type`, `assoc_id`) VALUES (91, 1, 5, 2, 16777234, '2024-11-02 14:30:07', NULL, 1048585, 3);
INSERT INTO `notifications` (`notification_id`, `context_id`, `user_id`, `level`, `type`, `date_created`, `date_read`, `assoc_type`, `assoc_id`) VALUES (95, 1, NULL, 3, 16777220, '2024-11-07 01:45:16', NULL, 1048585, 4);
INSERT INTO `notifications` (`notification_id`, `context_id`, `user_id`, `level`, `type`, `date_created`, `date_read`, `assoc_type`, `assoc_id`) VALUES (96, 1, NULL, 3, 16777222, '2024-11-07 01:45:16', NULL, 1048585, 4);
INSERT INTO `notifications` (`notification_id`, `context_id`, `user_id`, `level`, `type`, `date_created`, `date_read`, `assoc_type`, `assoc_id`) VALUES (97, 1, NULL, 3, 16777223, '2024-11-07 01:45:16', NULL, 1048585, 4);
INSERT INTO `notifications` (`notification_id`, `context_id`, `user_id`, `level`, `type`, `date_created`, `date_read`, `assoc_type`, `assoc_id`) VALUES (98, 1, NULL, 3, 16777224, '2024-11-07 01:45:16', NULL, 1048585, 4);
INSERT INTO `notifications` (`notification_id`, `context_id`, `user_id`, `level`, `type`, `date_created`, `date_read`, `assoc_type`, `assoc_id`) VALUES (99, 1, 1, 3, 16777247, '2024-11-07 01:45:16', NULL, 1048585, 4);
INSERT INTO `notifications` (`notification_id`, `context_id`, `user_id`, `level`, `type`, `date_created`, `date_read`, `assoc_type`, `assoc_id`) VALUES (100, 1, 4, 3, 16777247, '2024-11-07 01:45:16', NULL, 1048585, 4);
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
-- Table structure for pln_deposit_objects
-- ----------------------------
DROP TABLE IF EXISTS `pln_deposit_objects`;
CREATE TABLE `pln_deposit_objects` (
  `deposit_object_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `journal_id` bigint(20) NOT NULL,
  `object_id` bigint(20) NOT NULL,
  `object_type` varchar(36) NOT NULL,
  `deposit_id` bigint(20) DEFAULT NULL,
  `date_created` datetime NOT NULL,
  `date_modified` datetime DEFAULT NULL,
  PRIMARY KEY (`deposit_object_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- ----------------------------
-- Records of pln_deposit_objects
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for pln_deposits
-- ----------------------------
DROP TABLE IF EXISTS `pln_deposits`;
CREATE TABLE `pln_deposits` (
  `deposit_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `journal_id` bigint(20) NOT NULL,
  `uuid` varchar(36) DEFAULT NULL,
  `status` bigint(20) DEFAULT 0,
  `staging_state` varchar(255) DEFAULT NULL,
  `lockss_state` varchar(255) DEFAULT NULL,
  `date_status` datetime DEFAULT NULL,
  `date_created` datetime NOT NULL,
  `date_modified` datetime DEFAULT NULL,
  `export_deposit_error` varchar(1000) DEFAULT NULL,
  `date_preserved` datetime DEFAULT NULL,
  PRIMARY KEY (`deposit_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- ----------------------------
-- Records of pln_deposits
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
) ENGINE=InnoDB AUTO_INCREMENT=66 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='More data about plugins, including localized properties. This table is frequently used to store plugin-specific configuration.';

-- ----------------------------
-- Records of plugin_settings
-- ----------------------------
BEGIN;
INSERT INTO `plugin_settings` (`plugin_setting_id`, `plugin_name`, `context_id`, `setting_name`, `setting_value`, `setting_type`) VALUES (1, 'defaultthemeplugin', 0, 'enabled', '1', 'bool');
INSERT INTO `plugin_settings` (`plugin_setting_id`, `plugin_name`, `context_id`, `setting_name`, `setting_value`, `setting_type`) VALUES (2, 'acronplugin', 0, 'enabled', '1', 'bool');
INSERT INTO `plugin_settings` (`plugin_setting_id`, `plugin_name`, `context_id`, `setting_name`, `setting_value`, `setting_type`) VALUES (3, 'acronplugin', 0, 'crontab', '[{\"className\":\"APP\\\\plugins\\\\generic\\\\pln\\\\classes\\\\tasks\\\\Depositor\",\"frequency\":{\"hour\":24},\"args\":[\"autoStage\"]},{\"className\":\"APP\\\\plugins\\\\importexport\\\\doaj\\\\DOAJInfoSender\",\"frequency\":{\"hour\":24},\"args\":[]},{\"className\":\"PKP\\\\task\\\\ReviewReminder\",\"frequency\":{\"hour\":24},\"args\":[]},{\"className\":\"PKP\\\\task\\\\StatisticsReport\",\"frequency\":{\"day\":\"1\"},\"args\":[]},{\"className\":\"APP\\\\tasks\\\\SubscriptionExpiryReminder\",\"frequency\":{\"day\":\"1\"},\"args\":[]},{\"className\":\"PKP\\\\task\\\\DepositDois\",\"frequency\":{\"hour\":24},\"args\":[]},{\"className\":\"PKP\\\\task\\\\RemoveUnvalidatedExpiredUsers\",\"frequency\":{\"day\":\"1\"},\"args\":[]},{\"className\":\"PKP\\\\task\\\\EditorialReminders\",\"frequency\":{\"day\":\"1\"},\"args\":[]},{\"className\":\"PKP\\\\task\\\\UpdateIPGeoDB\",\"frequency\":{\"day\":\"10\"},\"args\":[]},{\"className\":\"APP\\\\tasks\\\\UsageStatsLoader\",\"frequency\":{\"hour\":24},\"args\":[]},{\"className\":\"PKP\\\\task\\\\ProcessQueueJobs\",\"frequency\":{\"hour\":24},\"args\":[]},{\"className\":\"PKP\\\\task\\\\RemoveFailedJobs\",\"frequency\":{\"day\":\"1\"},\"args\":[]},{\"className\":\"APP\\\\tasks\\\\OpenAccessNotification\",\"frequency\":{\"hour\":24},\"args\":[]}]', 'object');
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
INSERT INTO `plugin_settings` (`plugin_setting_id`, `plugin_name`, `context_id`, `setting_name`, `setting_value`, `setting_type`) VALUES (15, 'informationblockplugin', 1, 'enabled', '0', 'bool');
INSERT INTO `plugin_settings` (`plugin_setting_id`, `plugin_name`, `context_id`, `setting_name`, `setting_value`, `setting_type`) VALUES (16, 'informationblockplugin', 1, 'seq', '7', 'int');
INSERT INTO `plugin_settings` (`plugin_setting_id`, `plugin_name`, `context_id`, `setting_name`, `setting_value`, `setting_type`) VALUES (17, 'subscriptionblockplugin', 1, 'enabled', '0', 'bool');
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
INSERT INTO `plugin_settings` (`plugin_setting_id`, `plugin_name`, `context_id`, `setting_name`, `setting_value`, `setting_type`) VALUES (32, 'defaultmanuscriptchildthemeplugin', 1, 'enabled', '1', 'bool');
INSERT INTO `plugin_settings` (`plugin_setting_id`, `plugin_name`, `context_id`, `setting_name`, `setting_value`, `setting_type`) VALUES (33, 'defaultthemeplugin', 1, 'baseColour', '#4508FF', 'string');
INSERT INTO `plugin_settings` (`plugin_setting_id`, `plugin_name`, `context_id`, `setting_name`, `setting_value`, `setting_type`) VALUES (34, 'defaultthemeplugin', 1, 'showDescriptionInJournalIndex', 'false', 'string');
INSERT INTO `plugin_settings` (`plugin_setting_id`, `plugin_name`, `context_id`, `setting_name`, `setting_value`, `setting_type`) VALUES (35, 'defaultthemeplugin', 1, 'displayStats', 'bar', 'string');
INSERT INTO `plugin_settings` (`plugin_setting_id`, `plugin_name`, `context_id`, `setting_name`, `setting_value`, `setting_type`) VALUES (36, 'defaultmanuscriptchildthemeplugin', 1, 'accentColour', '#4508FF', 'string');
INSERT INTO `plugin_settings` (`plugin_setting_id`, `plugin_name`, `context_id`, `setting_name`, `setting_value`, `setting_type`) VALUES (37, 'defaultthemeplugin', 1, 'typography', 'lora', 'string');
INSERT INTO `plugin_settings` (`plugin_setting_id`, `plugin_name`, `context_id`, `setting_name`, `setting_value`, `setting_type`) VALUES (38, 'defaultthemeplugin', 1, 'useHomepageImageAsHeader', 'false', 'string');
INSERT INTO `plugin_settings` (`plugin_setting_id`, `plugin_name`, `context_id`, `setting_name`, `setting_value`, `setting_type`) VALUES (39, 'customblockmanagerplugin', 1, 'enabled', '1', 'bool');
INSERT INTO `plugin_settings` (`plugin_setting_id`, `plugin_name`, `context_id`, `setting_name`, `setting_value`, `setting_type`) VALUES (40, 'customblockmanagerplugin', 1, 'blocks', '[\"login\",\"journal-metrics\"]', 'object');
INSERT INTO `plugin_settings` (`plugin_setting_id`, `plugin_name`, `context_id`, `setting_name`, `setting_value`, `setting_type`) VALUES (41, 'login', 1, 'enabled', '1', 'bool');
INSERT INTO `plugin_settings` (`plugin_setting_id`, `plugin_name`, `context_id`, `setting_name`, `setting_value`, `setting_type`) VALUES (42, 'login', 1, 'blockTitle', '{\"en\":\"Login\"}', 'object');
INSERT INTO `plugin_settings` (`plugin_setting_id`, `plugin_name`, `context_id`, `setting_name`, `setting_value`, `setting_type`) VALUES (43, 'login', 1, 'blockContent', '{\"en\":\"\"}', 'object');
INSERT INTO `plugin_settings` (`plugin_setting_id`, `plugin_name`, `context_id`, `setting_name`, `setting_value`, `setting_type`) VALUES (44, 'login', 1, 'showName', '1', 'string');
INSERT INTO `plugin_settings` (`plugin_setting_id`, `plugin_name`, `context_id`, `setting_name`, `setting_value`, `setting_type`) VALUES (45, 'journal-metrics', 1, 'enabled', '1', 'bool');
INSERT INTO `plugin_settings` (`plugin_setting_id`, `plugin_name`, `context_id`, `setting_name`, `setting_value`, `setting_type`) VALUES (46, 'journal-metrics', 1, 'blockTitle', '{\"en\":\"Journal Metrics\"}', 'object');
INSERT INTO `plugin_settings` (`plugin_setting_id`, `plugin_name`, `context_id`, `setting_name`, `setting_value`, `setting_type`) VALUES (47, 'journal-metrics', 1, 'blockContent', '{\"en\":\"\"}', 'object');
INSERT INTO `plugin_settings` (`plugin_setting_id`, `plugin_name`, `context_id`, `setting_name`, `setting_value`, `setting_type`) VALUES (48, 'journal-metrics', 1, 'showName', '1', 'string');
INSERT INTO `plugin_settings` (`plugin_setting_id`, `plugin_name`, `context_id`, `setting_name`, `setting_value`, `setting_type`) VALUES (49, 'announcementfeedplugin', 1, 'enabled', '0', 'bool');
INSERT INTO `plugin_settings` (`plugin_setting_id`, `plugin_name`, `context_id`, `setting_name`, `setting_value`, `setting_type`) VALUES (50, 'citationstylelanguageplugin', 1, 'enabled', '1', 'bool');
INSERT INTO `plugin_settings` (`plugin_setting_id`, `plugin_name`, `context_id`, `setting_name`, `setting_value`, `setting_type`) VALUES (51, 'crossrefplugin', 1, 'enabled', '1', 'bool');
INSERT INTO `plugin_settings` (`plugin_setting_id`, `plugin_name`, `context_id`, `setting_name`, `setting_value`, `setting_type`) VALUES (52, 'recommendbysimilarityplugin', 1, 'enabled', '1', 'bool');
INSERT INTO `plugin_settings` (`plugin_setting_id`, `plugin_name`, `context_id`, `setting_name`, `setting_value`, `setting_type`) VALUES (53, 'plnplugin', 1, 'journal_uuid', 'F5DD8875-FC56-4AD3-A1EB-2AF47C53C57A', 'string');
INSERT INTO `plugin_settings` (`plugin_setting_id`, `plugin_name`, `context_id`, `setting_name`, `setting_value`, `setting_type`) VALUES (54, 'plnplugin', 1, 'max_upload_size', '1000000', 'string');
INSERT INTO `plugin_settings` (`plugin_setting_id`, `plugin_name`, `context_id`, `setting_name`, `setting_value`, `setting_type`) VALUES (55, 'plnplugin', 1, 'checksum_type', 'SHA-1', 'string');
INSERT INTO `plugin_settings` (`plugin_setting_id`, `plugin_name`, `context_id`, `setting_name`, `setting_value`, `setting_type`) VALUES (56, 'plnplugin', 1, 'pln_accepting', '0', 'bool');
INSERT INTO `plugin_settings` (`plugin_setting_id`, `plugin_name`, `context_id`, `setting_name`, `setting_value`, `setting_type`) VALUES (57, 'plnplugin', 1, 'pln_accepting_message', 'The PKP PLN does not know about this journal yet.', 'string');
INSERT INTO `plugin_settings` (`plugin_setting_id`, `plugin_name`, `context_id`, `setting_name`, `setting_value`, `setting_type`) VALUES (58, 'plnplugin', 1, 'terms_of_use', '{\"pkp:plugins.generic.pln.terms_of_use.jm_has_authority\":{\"updated\":\"2015-11-30 18:34:43+00:00\",\"term\":\"\\n            I have the authority to include this journal\'s content in a secure preservation network and, if and when necessary, to make the content accessible in the PKP-PLN and its successors.\\n        \"},\"pkp:plugins.generic.pln.terms_of_use.pkp_can_use_address\":{\"updated\":\"2015-11-30 18:34:43+00:00\",\"term\":\"\\n            I agree to allow the PKP-PLN to include this journal\'s title and ISSN, and the email address of the Primary Contact, with the preserved journal content.\\n        \"},\"pkp:plugins.generic.pln.terms_of_use.licensing_is_current\":{\"updated\":\"2015-11-30 18:34:43+00:00\",\"term\":\"\\n            I confirm that licensing information pertaining to articles in this journal is accurate at the time of publication.\\n        \"},\"pkp:plugins.generic.pln.terms_of_use.terms_may_be_revised\":{\"updated\":\"2015-11-30 18:34:43+00:00\",\"term\":\"\\n            I acknowledge these terms may be revised from time to time and will supersede all previous versions. I will be asked to review them and to agree to them in order to continue to include this journal’s content in the PKP-PLN.\\n        \"},\"pkp:plugins.generic.pln.terms_of_use.jm_will_not_violate\":{\"updated\":\"2015-11-30 18:34:43+00:00\",\"term\":\"\\n            I agree not to intentionally violate any laws and regulations that may be applicable to the content.\\n        \"},\"pkp:plugins.generic.pln.terms_of_use.trigger_events\":{\"updated\":\"2015-11-30 18:34:43+00:00\",\"term\":\"\\n            I agree to make every reasonable effort to inform the PKP-PLN in the event this journal ceases publication. I acknowledge that PKP-PLN will also employ automated techniques to detect a potential trigger event and contact the journal to confirm their publication status.\\n        \"},\"pkp:plugins.generic.pln.terms_of_use.pkp_may_not_preserve\":{\"updated\":\"2015-11-30 18:34:43+00:00\",\"term\":\"\\n            I agree that the PKP-PLN reserves the right not to preserve or make content accessible.\\n        \"},\"pkp:plugins.generic.pln.terms_of_use.use_aggregated_content\":{\"updated\":\"2015-12-04 16:53:43+00:00\",\"term\":\"\\n            PKP reserves the right to use the aggregated content in the PKP-PLN for research and reporting purposes and will adhere to the norms of standard research procedures.\\n        \"}}', 'object');
INSERT INTO `plugin_settings` (`plugin_setting_id`, `plugin_name`, `context_id`, `setting_name`, `setting_value`, `setting_type`) VALUES (59, 'plnplugin', 1, 'terms_of_use_agreement', '{\"pkp:plugins.generic.pln.terms_of_use.jm_has_authority\":\"2024-11-02T11:54:22+00:00\",\"pkp:plugins.generic.pln.terms_of_use.pkp_can_use_address\":\"2024-11-02T11:54:22+00:00\",\"pkp:plugins.generic.pln.terms_of_use.licensing_is_current\":\"2024-11-02T11:54:22+00:00\",\"pkp:plugins.generic.pln.terms_of_use.terms_may_be_revised\":\"2024-11-02T11:54:22+00:00\",\"pkp:plugins.generic.pln.terms_of_use.jm_will_not_violate\":\"2024-11-02T11:54:22+00:00\",\"pkp:plugins.generic.pln.terms_of_use.trigger_events\":\"2024-11-02T11:54:22+00:00\",\"pkp:plugins.generic.pln.terms_of_use.pkp_may_not_preserve\":\"2024-11-02T11:54:22+00:00\",\"pkp:plugins.generic.pln.terms_of_use.use_aggregated_content\":\"2024-11-02T11:54:22+00:00\"}', 'object');
INSERT INTO `plugin_settings` (`plugin_setting_id`, `plugin_name`, `context_id`, `setting_name`, `setting_value`, `setting_type`) VALUES (60, 'plnplugin', 1, 'enabled', '0', 'bool');
INSERT INTO `plugin_settings` (`plugin_setting_id`, `plugin_name`, `context_id`, `setting_name`, `setting_value`, `setting_type`) VALUES (61, 'plnplugin', 1, 'object_type', 'Issue', 'string');
INSERT INTO `plugin_settings` (`plugin_setting_id`, `plugin_name`, `context_id`, `setting_name`, `setting_value`, `setting_type`) VALUES (62, 'plnplugin', 1, 'object_threshold', '20', 'int');
INSERT INTO `plugin_settings` (`plugin_setting_id`, `plugin_name`, `context_id`, `setting_name`, `setting_value`, `setting_type`) VALUES (63, 'bootstrapthreethemeplugin', 1, 'enabled', '1', 'bool');
INSERT INTO `plugin_settings` (`plugin_setting_id`, `plugin_name`, `context_id`, `setting_name`, `setting_value`, `setting_type`) VALUES (64, 'bootstrapthreethemeplugin', 1, 'bootstrapTheme', 'sandstone', 'string');
INSERT INTO `plugin_settings` (`plugin_setting_id`, `plugin_name`, `context_id`, `setting_name`, `setting_value`, `setting_type`) VALUES (65, 'bootstrapthreethemeplugin', 1, 'displayStats', 'bar', 'string');
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
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='More data about publications, including localized properties such as the title and abstract.';

-- ----------------------------
-- Records of publication_settings
-- ----------------------------
BEGIN;
INSERT INTO `publication_settings` (`publication_setting_id`, `publication_id`, `locale`, `setting_name`, `setting_value`) VALUES (4, 2, '', 'categoryIds', '[]');
INSERT INTO `publication_settings` (`publication_setting_id`, `publication_id`, `locale`, `setting_name`, `setting_value`) VALUES (5, 2, 'en', 'title', 'Capasitors');
INSERT INTO `publication_settings` (`publication_setting_id`, `publication_id`, `locale`, `setting_name`, `setting_value`) VALUES (6, 2, 'en', 'abstract', '<p>Abstract</p>');
INSERT INTO `publication_settings` (`publication_setting_id`, `publication_id`, `locale`, `setting_name`, `setting_value`) VALUES (7, 3, '', 'categoryIds', '[]');
INSERT INTO `publication_settings` (`publication_setting_id`, `publication_id`, `locale`, `setting_name`, `setting_value`) VALUES (8, 3, 'en', 'title', 'Resistors');
INSERT INTO `publication_settings` (`publication_setting_id`, `publication_id`, `locale`, `setting_name`, `setting_value`) VALUES (9, 3, 'en', 'abstract', '<p>Abstract</p>');
INSERT INTO `publication_settings` (`publication_setting_id`, `publication_id`, `locale`, `setting_name`, `setting_value`) VALUES (10, 4, '', 'categoryIds', '[]');
INSERT INTO `publication_settings` (`publication_setting_id`, `publication_id`, `locale`, `setting_name`, `setting_value`) VALUES (11, 4, 'en', 'title', 'Artificial Intelligence');
INSERT INTO `publication_settings` (`publication_setting_id`, `publication_id`, `locale`, `setting_name`, `setting_value`) VALUES (12, 4, 'en', 'abstract', '<p>Testing</p>');
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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Each publication is one version of a submission.';

-- ----------------------------
-- Records of publications
-- ----------------------------
BEGIN;
INSERT INTO `publications` (`publication_id`, `access_status`, `date_published`, `last_modified`, `primary_contact_id`, `section_id`, `seq`, `submission_id`, `status`, `url_path`, `version`, `doi_id`) VALUES (2, 0, NULL, '2024-11-02 11:58:27', 2, 1, 0.00, 2, 1, NULL, 1, NULL);
INSERT INTO `publications` (`publication_id`, `access_status`, `date_published`, `last_modified`, `primary_contact_id`, `section_id`, `seq`, `submission_id`, `status`, `url_path`, `version`, `doi_id`) VALUES (3, 0, NULL, '2024-11-02 13:15:46', 3, 1, 0.00, 3, 1, NULL, 1, NULL);
INSERT INTO `publications` (`publication_id`, `access_status`, `date_published`, `last_modified`, `primary_contact_id`, `section_id`, `seq`, `submission_id`, `status`, `url_path`, `version`, `doi_id`) VALUES (4, 0, NULL, '2024-11-07 01:44:28', 4, 1, 0.00, 4, 1, NULL, 1, NULL);
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Discussions, usually related to a submission, created by editors, authors and other editorial staff.';

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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='The users assigned to a discussion.';

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
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='The last time each scheduled task was run.';

-- ----------------------------
-- Records of scheduled_tasks
-- ----------------------------
BEGIN;
INSERT INTO `scheduled_tasks` (`scheduled_task_id`, `class_name`, `last_run`) VALUES (1, 'PKP\\task\\ReviewReminder', '2024-11-10 13:47:25');
INSERT INTO `scheduled_tasks` (`scheduled_task_id`, `class_name`, `last_run`) VALUES (2, 'PKP\\task\\StatisticsReport', '2024-11-01 00:00:24');
INSERT INTO `scheduled_tasks` (`scheduled_task_id`, `class_name`, `last_run`) VALUES (3, 'APP\\tasks\\SubscriptionExpiryReminder', '2024-11-01 00:00:26');
INSERT INTO `scheduled_tasks` (`scheduled_task_id`, `class_name`, `last_run`) VALUES (4, 'PKP\\task\\DepositDois', '2024-11-10 13:47:25');
INSERT INTO `scheduled_tasks` (`scheduled_task_id`, `class_name`, `last_run`) VALUES (5, 'PKP\\task\\RemoveUnvalidatedExpiredUsers', '2024-11-01 00:00:26');
INSERT INTO `scheduled_tasks` (`scheduled_task_id`, `class_name`, `last_run`) VALUES (6, 'PKP\\task\\EditorialReminders', '2024-11-01 00:00:26');
INSERT INTO `scheduled_tasks` (`scheduled_task_id`, `class_name`, `last_run`) VALUES (7, 'PKP\\task\\UpdateIPGeoDB', '2024-11-10 00:21:57');
INSERT INTO `scheduled_tasks` (`scheduled_task_id`, `class_name`, `last_run`) VALUES (8, 'APP\\tasks\\UsageStatsLoader', '2024-11-10 13:47:25');
INSERT INTO `scheduled_tasks` (`scheduled_task_id`, `class_name`, `last_run`) VALUES (9, 'PKP\\task\\ProcessQueueJobs', '2024-11-10 13:47:25');
INSERT INTO `scheduled_tasks` (`scheduled_task_id`, `class_name`, `last_run`) VALUES (10, 'PKP\\task\\RemoveFailedJobs', '2024-11-01 00:00:26');
INSERT INTO `scheduled_tasks` (`scheduled_task_id`, `class_name`, `last_run`) VALUES (11, 'APP\\tasks\\OpenAccessNotification', '2024-11-10 13:47:26');
INSERT INTO `scheduled_tasks` (`scheduled_task_id`, `class_name`, `last_run`) VALUES (12, 'APP\\plugins\\importexport\\doaj\\DOAJInfoSender', '2024-11-10 13:47:25');
INSERT INTO `scheduled_tasks` (`scheduled_task_id`, `class_name`, `last_run`) VALUES (13, 'APP\\plugins\\generic\\pln\\classes\\tasks\\Depositor', '2024-11-11 13:39:13');
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
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('00rcmjk899cc1glr6cci382r0h', NULL, '142.58.232.187', 'PkpPlnBot 1.0; http://pkp.sfu.ca', 1730907336, 1730907336, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('00vpg817enm1nahc7ii1d280st', NULL, '66.249.72.71', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1731020494, 1731020495, 0, 'currentLocale|s:2:\"en\";', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('01q61sj6mkf45n4pvi4j5tivsn', 1, '180.244.128.69', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.6.1 Safari/605.1.15', 1729942847, 1729979797, 1, 'csrf|a:2:{s:9:\"timestamp\";i:1729979797;s:5:\"token\";s:32:\"14d4aa059545659e06604e0be8c506c2\";}userId|i:1;username|s:6:\"peacee\";', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('044353af5u0m6jmkcou8f0a32q', NULL, '115.231.78.3', 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.2623.112 Safari/537.36', 1730883149, 1730883149, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('058ro2kqumm2vasuq7la2p3g22', NULL, '45.58.159.191', 'Mozilla/4.0 (compatible; MSIE 9.0; Windows NT 10.0; .NET4.0C; .NET4.0E; .NET CLR 2.0.50727; .NET CLR 3.0.30729; .NET CLR 3.5.30729)', 1730945680, 1730945680, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('072acognvss19ef5ej6gtrj9i1', NULL, '114.10.145.105', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Mobile Safari/537.36', 1731135787, 1731135787, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('075vti0dhrfjo31djedkiq0121', NULL, '36.69.111.88', 'Mozilla/5.0 (Linux; U; Android 13; in-id; CPH2235 Build/TP1A.220905.001) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.88 Mobile Safari/537.36 HeyTapBrowser/45.11.4.1', 1730904411, 1730904411, 0, '', 'arsys.my.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('07hj2uaqt87epgq9k14bgckt7c', NULL, '66.249.79.128', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1730986042, 1730986042, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('09mqjdntvq20tmtpufpjpehe0i', NULL, '92.255.57.58', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', 1730975216, 1730975216, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('0cqjn5b8r0o265v9fn6gh2n5jn', NULL, '165.154.40.42', 'curl/7.29.0', 1731043092, 1731043092, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('0l14c2aginlknmuha1pdarev9d', NULL, '8.219.144.149', 'Custom-AsyncHttpClient', 1730991788, 1730991788, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('0ljmnm0l81hadm1rckj5bet51m', NULL, '180.244.164.38', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_0_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.0.1 Mobile/15E148 Safari/604.1', 1730898159, 1730898210, 0, '', 'arsys.my.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('0nlnbnca162vj260vq2kgcm68j', NULL, '66.249.79.129', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; GoogleOther)', 1730901430, 1730901430, 0, 'currentLocale|s:2:\"id\";', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('0q19j6sgsjhg5fptoaqt8uvk1m', NULL, '185.213.25.237', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.129 Safari/537.36', 1731189127, 1731189127, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('0r58eng1g1ij3o0035scc8fbub', 1, '180.244.128.69', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', 1729943881, 1729944048, 1, 'csrf|a:2:{s:9:\"timestamp\";i:1729944047;s:5:\"token\";s:32:\"eedc510027d4ddc40d384f29d737d627\";}userId|i:1;username|s:6:\"peacee\";', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('0rnoen2rsd6ra6qsgs2q6rf7lb', NULL, '8.209.96.179', 'Go-http-client/1.1', 1730870200, 1730870200, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('0vdmg009t3tshvl1u8lia85a0q', NULL, '107.172.148.125', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.120 Safari/537.36', 1731119622, 1731119622, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('11nfn80e918ja5q9a7dht1m48a', NULL, '47.89.173.26', 'Custom-AsyncHttpClient', 1731255178, 1731255178, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('12a424ub179o7uhbgck7ld943t', NULL, '205.210.31.154', '', 1731257689, 1731257689, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('15m3f5sbid9f2v1m0nvo13k96e', NULL, '66.249.66.68', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1730892345, 1730892345, 0, 'currentLocale|s:2:\"id\";', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('16pap0dogdiie4l4t5vl1co7lb', NULL, '130.162.47.187', 'Custom-AsyncHttpClient', 1731175060, 1731175060, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('17iv26daee3sodm4ct0s0vdod6', NULL, '35.203.210.199', 'Expanse, a Palo Alto Networks company, searches across the global IPv4 space multiple times per day to identify customers&#39; presences on the Internet. If you would like to be excluded from our scans, please send IP addresses/domains to: scaninfo@paloal', 1731119619, 1731119619, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('19sjj9fj0ffphlq3vut2go4a8l', NULL, '140.213.31.35', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 Edg/130.0.0.0', 1730879578, 1730879578, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('19vdci8d4pldm8tpp4edprqph0', 1, '103.23.244.234', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.6.1 Safari/605.1.15', 1730348893, 1730355534, 1, 'csrf|a:2:{s:9:\"timestamp\";i:1730355534;s:5:\"token\";s:32:\"0e76d03b68eea284e48176b436f81d08\";}userId|i:1;username|s:6:\"peacee\";', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('1a6gj5d8ebv3rp8ul2jsucsvip', NULL, '8.219.54.201', 'Custom-AsyncHttpClient', 1731072661, 1731072661, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('1bb2unimcn7t5poms5q09sp38h', NULL, '159.89.39.63', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.36', 1731092584, 1731092584, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('1ekoj7j7labksm7l0qp0l6h8jq', NULL, '66.249.73.225', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1731103550, 1731103550, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('1flhf4hovioml284trj8f8o75c', NULL, '8.219.188.212', 'Custom-AsyncHttpClient', 1731074010, 1731074010, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('1hqgi23fsnnd3hk57cen6bfrei', NULL, '66.249.72.65', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1731028350, 1731028350, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('1k3boq1cnii3s4qaoh2e52l1e3', NULL, '66.249.66.68', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; GoogleOther)', 1730887027, 1730887027, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('1k7fp2o359u068029u9g8vc091', NULL, '87.236.176.198', 'Mozilla/5.0 (compatible; InternetMeasurement/1.0; +https://internet-measurement.com/)', 1731090318, 1731090318, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('1ligud8sgrrjkd87d8rn5ishnb', NULL, '66.249.79.137', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1730924136, 1730924136, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('1m36ldbs6mrtm210562daej44p', NULL, '45.33.80.243', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 13_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36', 1730854943, 1730854943, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('1mqdui2je84per4720p18hjqk7', NULL, '64.62.197.162', 'Mozilla/5.0 (X11; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/110.0', 1731070869, 1731070869, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('1oadoohboninnhfvb3593va50d', NULL, '185.242.226.117', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.190 Safari/537.36', 1730948652, 1730948652, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('1rfqsvi3g4d5mkq406c95h38ik', NULL, '198.235.24.43', 'Expanse, a Palo Alto Networks company, searches across the global IPv4 space multiple times per day to identify customers&#39; presences on the Internet. If you would like to be excluded from our scans, please send IP addresses/domains to: scaninfo@paloal', 1731015596, 1731015596, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('1t5qldahk2c8betb209ir216fb', NULL, '142.58.232.187', 'PkpPlnBot 1.0; http://pkp.sfu.ca', 1730993645, 1730993645, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('1t8tjmuuqnpb8sit1prg8i5bli', NULL, '188.165.125.250', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.45 Safari/537.36', 1730997320, 1730997320, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('215b5fm31fi7ki86bifve5dclo', NULL, '20.225.3.171', 'Mozilla/5.0 zgrab/0.x', 1731155521, 1731155521, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('24a030p1ogsp4e74m08a8u2hem', NULL, '66.249.73.224', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1731095695, 1731095695, 0, 'currentLocale|s:2:\"en\";', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('24fsp4aut0vjv4aujphfmoh6pn', NULL, '64.62.156.99', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:126.0) Gecko/20100101 Firefox/126.0', 1730891739, 1730891739, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('25hsvv8cdqeu1v74ul8n9aek9o', NULL, '185.213.25.237', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.129 Safari/537.36', 1731189128, 1731189128, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('25vb0dkcnfj87jdtqsrvjno7sa', NULL, '167.94.145.107', 'Mozilla/5.0 (compatible; CensysInspect/1.1; +https://about.censys.io/)', 1731056420, 1731056420, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('27hdd5b7pa7u9d9r0o184sc16g', NULL, '182.2.142.33', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_0_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.0.1 Mobile/15E148 Safari/604.1', 1730956691, 1730956691, 0, '', 'arsys.my.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('2dinq7v4cbh9od54bjgs4bbuaj', NULL, '130.162.47.187', 'Custom-AsyncHttpClient', 1731175059, 1731175059, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('2dtldobpo7vgc9qcf7fhfjij3s', 1, '180.244.138.103', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.6.1 Safari/605.1.15', 1730944811, 1730957569, 1, 'csrf|a:2:{s:9:\"timestamp\";i:1730957566;s:5:\"token\";s:32:\"d2fcee4e55f9443bb63297dd50fa09b0\";}userId|i:1;username|s:6:\"peacee\";', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('2i9cnqv0u3ept6rs4mvnl80qe4', NULL, '159.65.237.184', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.36', 1731264660, 1731264660, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('2js8r5fdg1b2ih5eq018v3ott6', NULL, '64.62.156.58', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36', 1731246445, 1731246445, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('2lbpuehjf8u49p2e91p7fvm352', NULL, '8.216.88.38', 'Custom-AsyncHttpClient', 1731240701, 1731240701, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('2ljr6b1m6t5fen2srmdq9rgefm', NULL, '66.249.73.237', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1731086688, 1731086688, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('2qa19bgthmpdmod6e5io4144am', NULL, '159.223.27.54', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.36', 1731095350, 1731095350, 0, '', 'www.peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('2qsavfecbtbjrd8ucetdl2u7ip', NULL, '170.83.49.7', 'Mozilla/5.0 (Linux; Android 7.0; SM-G892A Build/NRD90M; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/60.0.3112.107 Mobile Safari/537.36', 1731109985, 1731109985, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('2r1nlfg2o6kar9tvijek94la21', NULL, '157.230.237.180', 'Mozilla/5.0 (Fedora; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36', 1731092091, 1731092091, 0, '', 'arsys.my.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('2s3sjn7m592n4lcgk89nsnocir', NULL, '93.158.91.250', 'Mozilla/5.0 (Android 14; Mobile; rv:123.0) Gecko/123.0 Firefox/123', 1731159951, 1731159951, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('2sanl6mrf62nivlojnaqbelebl', NULL, '36.69.111.88', 'Mozilla/5.0 (Linux; U; Android 13; in-id; CPH2235 Build/TP1A.220905.001) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.88 Mobile Safari/537.36 HeyTapBrowser/45.11.4.1', 1730904410, 1730904410, 0, '', 'arsys.my.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('2t2vat69dvkiha3iavobr23g5d', NULL, '66.249.66.67', 'Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1730877453, 1730877454, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('2u1vu1atgp1dm2vaen3ellgehg', NULL, '142.58.232.187', 'PkpPlnBot 1.0; http://pkp.sfu.ca', 1731080176, 1731080176, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('31drk4p5m0fdcbmq52djm0r9mi', NULL, '66.249.66.67', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1730890532, 1730890532, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('34ichre3ajlkgu86eg4hhjojvi', NULL, '156.227.0.251', 'Mozilla/5.0 (Linux; U; Android 4.4.2; en-US; HM NOTE 1W Build/KOT49H) AppleWebKit/534.30 (KHTML, like Gecko) Version/4.0 UCBrowser/11.0.5.850 U3/0.8.0 Mobile Safari/534.30', 1731274605, 1731274605, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('35b6nncjh1gs3v447fmns4a42t', NULL, '66.249.72.64', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1731031899, 1731031899, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('36u8r3qadgkop6i9380o3f7j69', NULL, '118.98.214.4', 'WhatsApp/2.23.20.0', 1730951600, 1730951600, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('37kl5ggddtg3943d5m72jg3q11', NULL, '111.21.192.215', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.84 Safari/537.36', 1731095859, 1731095859, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('3ce10f0fj3chd9h550ls0b3hl4', NULL, '34.227.77.33', '', 1730938615, 1730938615, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('3fkiouvgqnf87p67viumhc22d5', NULL, '66.249.66.69', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; GoogleOther)', 1730890627, 1730890627, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('3g23483hghha1118l2acvjr2ds', NULL, '8.219.54.201', 'Custom-AsyncHttpClient', 1731072661, 1731072661, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('3iacqisb3c1p7u0mjn13n3ps6m', NULL, '66.249.72.71', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1731024735, 1731024735, 0, 'currentLocale|s:2:\"en\";', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('3icogucs64mis9u50e0htdcbt3', NULL, '43.206.208.110', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/124.0.6367.29 Safari/537.36', 1730880440, 1730880440, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('3mn5g48d427g0isukt0tu97gnp', NULL, '142.58.232.187', 'PkpPlnBot 1.0; http://pkp.sfu.ca', 1731080176, 1731080176, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('3o9pnqt3rh6pjmpolv8v3vgmok', NULL, '66.249.72.65', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1731064953, 1731064953, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('3q1eriit97ha9ldqh6lpnbdfgo', NULL, '199.45.154.133', 'Mozilla/5.0 (compatible; CensysInspect/1.1; +https://about.censys.io/)', 1730923129, 1730923129, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('3rlhlk9svaf1ps617gpfq10cgl', NULL, '43.249.36.117', 'Mozilla/5.0 (compatible; ModatScanner/1.0; +https://modat.io/)', 1731148863, 1731148863, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('3rsn3dt8otk81vdeb1scjkdvtl', NULL, '103.153.183.247', 'Mozilla/5.0 (Linux; U; Android 4.4.2; en-US; HM NOTE 1W Build/KOT49H) AppleWebKit/534.30 (KHTML, like Gecko) Version/4.0 UCBrowser/11.0.5.850 U3/0.8.0 Mobile Safari/534.30', 1730955478, 1730955478, 0, '', 'arsys.my.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('3u6i0ve8v9jessal855ittbvlg', NULL, '140.213.31.35', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', 1730877901, 1730877955, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('3u88hjmkanjhjaubatem29tfts', NULL, '167.172.101.189', 'Go-http-client/1.1', 1731332358, 1731332358, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('3uop49duc514hg2n73dqsc8k75', NULL, '66.249.66.68', 'Googlebot/2.1 (+http://www.google.com/bot.html)', 1731205119, 1731205119, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('4205c6aqs488d56269qkam37tc', NULL, '115.231.78.3', 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.132 Safari/537.36 QIHU 360SE', 1730962037, 1730962037, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('4550mjk0c7b63et5vdsghicavt', NULL, '66.249.72.65', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1731054101, 1731054101, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('4agb90o4vribl1cn97785j5u1q', NULL, '92.255.57.58', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', 1731328742, 1731328742, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('4c96eg660070dvabgmp1ncr4d9', NULL, '104.166.80.156', 'Mozilla/5.0 (X11; Linux i686; rv:109.0) Gecko/20100101 Firefox/120.0', 1730986833, 1730986833, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('4hklf9suuus97bvb84rkgju0bh', NULL, '66.249.72.71', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1731000582, 1731000583, 0, 'currentLocale|s:2:\"id\";csrf|a:2:{s:9:\"timestamp\";i:1731000583;s:5:\"token\";s:32:\"6403d08aef1e43b445133feca40ced18\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('4lmq8b1icpkj1q3u67vvqvnjcc', NULL, '104.234.115.39', '\'Mozilla/5.0 (compatible; GenomeCrawlerd/1.0; +https://www.nokia.com/networks/ip-networks/deepfield/genome/)\'', 1731051881, 1731051881, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('4m80jc4g1a0ta6bfai927acibl', NULL, '162.216.150.103', 'Expanse, a Palo Alto Networks company, searches across the global IPv4 space multiple times per day to identify customers&#39; presences on the Internet. If you would like to be excluded from our scans, please send IP addresses/domains to: scaninfo@paloal', 1731220354, 1731220354, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('4q6la4cp97u15a0qpl64b1srk1', NULL, '8.219.54.201', 'Custom-AsyncHttpClient', 1731072661, 1731072661, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('4u3kakb3gh90b5i28ri9slciea', NULL, '199.45.155.75', 'Mozilla/5.0 (compatible; CensysInspect/1.1; +https://about.censys.io/)', 1730944135, 1730944135, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('4upag4dc59jhgalgd6kr91qnbp', NULL, '27.51.96.180', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.1 Mobile/15E148 Safari/604.1', 1731123702, 1731123703, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('52qn9opthb7jc9jdjcp4p4hb4l', NULL, '115.231.78.3', 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.2623.112 Safari/537.36', 1731312041, 1731312041, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('53c7h5i55n5bur9p5p5c96n6nl', NULL, '103.36.11.147', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Mobile Safari/537.36', 1731284921, 1731284921, 0, '', 'arsys.my.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('564glgo6tp9fmo0nm0me722ukt', NULL, '167.99.13.145', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36', 1731213050, 1731213050, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('56iid0bvo1jvdg89njljhluvbv', NULL, '34.227.77.33', '', 1730938618, 1730938618, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('586vtccrgor9qql3il6j1dvi66', NULL, '103.173.227.187', 'Custom-AsyncHttpClient', 1731122905, 1731122905, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('5bb4jo8o9h39t1v429ca0e6adu', NULL, '180.244.138.43', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/117.0.0.0 Mobile Safari/537.36', 1731128919, 1731128959, 0, '', 'arsys.my.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('5clq9jrgkd570j9q7cq7ofmuae', NULL, '185.100.87.136', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:104.71.6212.24) Gecko/25.2.4212.671 Firefox/2.0', 1731289706, 1731289706, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('5ctceh54gtmun158o86cd003ge', NULL, '139.59.44.30', 'Mozilla/4.0 (compatible; MSIE 9.0; Windows NT 10.0; .NET4.0C; .NET4.0E; .NET CLR 2.0.50727; .NET CLR 3.0.30729; .NET CLR 3.5.30729)', 1731108592, 1731108592, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('5cu4lk2lt5jvqdm1903eeke274', NULL, '185.242.226.117', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.190 Safari/537.36', 1731212635, 1731212635, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('5ddvhtt8q8aqrcgml5pg7r3c7t', NULL, '142.58.232.187', 'PkpPlnBot 1.0; http://pkp.sfu.ca', 1731166180, 1731166180, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('5f3ltlmd1u79v32tg7mtnhnrok', NULL, '43.206.208.110', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/112.0.0.0 Safari/537.36', 1730880435, 1730880435, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('5klu1dkpl7lqll3af8o567o52c', NULL, '140.213.21.237', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Mobile Safari/537.36', 1731300537, 1731300537, 0, '', 'juteki.web.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('5l8t1559rje2evceogr3gt40p9', NULL, '66.249.72.71', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1730999354, 1730999354, 0, 'currentLocale|s:2:\"id\";', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('5n7j9mja54o4slm9cqhqsttpkv', NULL, '185.208.156.160', 'Uzbl (Webkit 1.3) (Linux i686 [i686])', 1730954132, 1730954132, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('5njo21pd0fo368th23ffphtjv3', NULL, '66.249.66.69', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1731172211, 1731172211, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('5ps49j1gj6jpgvs3o1210colkm', NULL, '66.249.72.65', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1731026734, 1731026734, 0, 'currentLocale|s:2:\"id\";', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('5rib52cd5ushe88tapv201vq9a', NULL, '34.227.77.33', '', 1730938618, 1730938618, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('5sf33tajhggjtodonbsqsc8pjq', NULL, '66.249.73.237', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1731095696, 1731095696, 0, 'currentLocale|s:2:\"en\";csrf|a:2:{s:9:\"timestamp\";i:1731095696;s:5:\"token\";s:32:\"ca2ac94fe57257bcfb637af80b094df7\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('5sfnv7tcmmheeuaudfo2qo1fba', NULL, '66.249.72.71', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1731004168, 1731004168, 0, 'currentLocale|s:2:\"en\";', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('5t13vc7598fcg2b06vdmkvv120', NULL, '3.80.120.215', 'Konqueror/3.0-rc4; (Konqueror/3.0-rc4; i686 Linux;;datecode)', 1731273058, 1731273058, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('5u6ub5dg6jj9uf613bjaqjihgu', NULL, '66.249.66.67', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1730887259, 1730887271, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('5uosptk3lqmnudo08045had9jg', NULL, '45.83.66.117', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:65.0) Gecko/20100101 Firefox/65.0', 1730889273, 1730889273, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('5v8me2qjkp3tsp4jaiph2m9vc7', NULL, '51.254.49.110', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:130.0) Gecko/20100101 Firefox/130.0', 1731322387, 1731322387, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('62ei8hjg43ndovvuk6d763fi78', NULL, '125.164.18.124', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', 1730994857, 1730994863, 0, '', 'arsys.my.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('64luqs5conpo7rtmmtlujbarlh', NULL, '18.217.238.48', 'Mozilla/4.0 (PSP (PlayStation Portable); 2.00)', 1731065300, 1731065300, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('66l49d2e4ul02rq9d7ct4uo7ph', NULL, '52.189.76.10', 'Mozilla/5.0 zgrab/0.x', 1731038531, 1731038531, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('66tstk40a9ngnn30786r005hr5', NULL, '66.249.72.71', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1731001897, 1731001897, 0, 'currentLocale|s:2:\"id\";', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('6c1lkrt1phkr7oj85mnmf2g2le', NULL, '198.244.249.177', 'Mozilla/5.0 (Linux; Android 6.0; Le X620 Build/MRA58K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/56.0.2924.87 Mobile Safari/537.36', 1731058808, 1731058808, 0, '', 'www.peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('6c58ol5kjt0785tospmcpr6mu6', NULL, '147.185.133.174', 'Expanse, a Palo Alto Networks company, searches across the global IPv4 space multiple times per day to identify customers&#39; presences on the Internet. If you would like to be excluded from our scans, please send IP addresses/domains to: scaninfo@paloal', 1731308426, 1731308426, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('6cuc107f5l9p2fq1o6v12srv5u', NULL, '66.249.79.128', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; GoogleOther)', 1730989598, 1730989598, 0, 'currentLocale|s:2:\"id\";', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('6g2anoppf80r96opgkpq8t0fsu', NULL, '66.249.72.65', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1731018881, 1731018881, 0, 'currentLocale|s:2:\"id\";', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('6g4sqqm0nbhsp3q7n8nchabisc', NULL, '66.249.72.71', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1730992542, 1730992542, 0, 'currentLocale|s:2:\"en\";', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('6hq8hjrsts1n2vsmc9kl9rp2p6', NULL, '66.249.72.64', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1731023971, 1731023971, 0, 'currentLocale|s:2:\"en\";', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('6ko08u3gi8v5lri1tk9u92cgle', NULL, '115.231.78.3', 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.2623.112 Safari/537.36', 1731273136, 1731273136, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('6kob4bg61imrqj88ldgoc5bfq1', NULL, '162.142.125.218', '', 1731140175, 1731140175, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('6lkrgoj7dk0jdv70ecgk1edsgi', NULL, '8.216.80.166', 'Custom-AsyncHttpClient', 1731160269, 1731160269, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('6nndp2ciidio27iro2b09h38qj', NULL, '66.249.66.69', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1731214192, 1731214192, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('6pmans9e0ql00vf47vl20h37s8', NULL, '156.227.0.251', 'Mozilla/5.0 (Linux; U; Android 4.4.2; en-US; HM NOTE 1W Build/KOT49H) AppleWebKit/534.30 (KHTML, like Gecko) Version/4.0 UCBrowser/11.0.5.850 U3/0.8.0 Mobile Safari/534.30', 1731277338, 1731277338, 0, '', 'arsys.my.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('707daig4thflqgc9j59lhlaf1p', NULL, '3.136.106.31', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_2_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.2 Mobile/15E148 Safari/604.1', 1731328097, 1731328097, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('71l384ql9ma2env101ga0tj284', NULL, '66.249.72.65', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1731025756, 1731025757, 0, 'currentLocale|s:2:\"en\";csrf|a:2:{s:9:\"timestamp\";i:1731025757;s:5:\"token\";s:32:\"1146a0dbedb170d53b855a63fbaa4d16\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('742m6vaa747j9pqgaa0j6t1oe7', NULL, '66.249.79.129', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; GoogleOther)', 1730905148, 1730905148, 0, 'currentLocale|s:2:\"id\";', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('764u9j4tcs1hinijlve2sqfkbi', NULL, '64.62.156.95', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:126.0) Gecko/20100101 Firefox/126.0', 1730892272, 1730892272, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('78rfn6cjmsqpg7107ets939s9e', NULL, '66.249.72.64', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1731018882, 1731018882, 0, 'currentLocale|s:2:\"id\";csrf|a:2:{s:9:\"timestamp\";i:1731018882;s:5:\"token\";s:32:\"d432cf06a57c5bb757f346afce612a25\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('78v35qoje6g4lmglbrgcg3uqkl', NULL, '154.212.141.195', '', 1731207234, 1731207234, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('7arda8mtuoaf9pcqk5gos9p6iv', NULL, '66.249.72.64', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1731024734, 1731024734, 0, 'currentLocale|s:2:\"en\";', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('7b8uoni7gr67538gbil7n9u0m7', NULL, '114.67.171.28', 'Custom-AsyncHttpClient', 1731114202, 1731114202, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('7cb4sbfpkipfnk1b3hp3mjuksr', NULL, '64.62.156.94', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:108.0) Gecko/20100101 Firefox/108.0', 1731302629, 1731302629, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('7e8oru0u4eed2ufc0ri8squ974', NULL, '62.141.44.236', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.114 Safari/537.36 Edg/91.0.864.54', 1731004151, 1731004151, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('7fe3v0fvj2gfucr3grr5tgo220', NULL, '65.49.20.69', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0) Gecko/20100101 Firefox/102.0', 1731149748, 1731149748, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('7frumbaoo5vlsaucp379bjc9t5', NULL, '34.34.173.16', 'python-requests/2.32.3', 1730969116, 1730969116, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('7liav2gq6pir2plmc1dd5p9vm1', NULL, '64.23.146.242', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.36', 1731265023, 1731265023, 0, '', 'www.peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('7ni91ebtocc49i0vi86dklk2bc', NULL, '36.69.111.88', 'Mozilla/5.0 (Linux; U; Android 13; in-id; CPH2235 Build/TP1A.220905.001) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.88 Mobile Safari/537.36 HeyTapBrowser/45.11.4.1', 1730904410, 1730904410, 0, '', 'arsys.my.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('7nol9mf56g978nofltl5e0mvde', NULL, '167.94.145.105', 'Mozilla/5.0 (compatible; CensysInspect/1.1; +https://about.censys.io/)', 1731211726, 1731211726, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('7p4hm770pl7fdi2el4m5dak9it', NULL, '66.249.65.104', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1731162247, 1731162247, 0, '', 'arsys.my.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('7qvd7mcf1027bid6r3eie81rtm', NULL, '54.38.100.157', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:130.0) Gecko/20100101 Firefox/130.0', 1730898812, 1730898812, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('7s6skagm610r1nijca9f3s8dtc', NULL, '66.249.72.106', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1731034159, 1731034159, 0, '', 'arsys.my.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('7vgb1ghejtmdvn4e7btsktb3hb', NULL, '45.84.89.2', 'Mozilla/6.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36 Inspici (www.inspici.com)', 1731193348, 1731193348, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('853p9rleisgj8rujfgipbfrb8l', NULL, '114.10.72.167', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Mobile Safari/537.36', 1730951776, 1730951927, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('899u7stn8mkj4jrp98bmsahq0v', NULL, '180.149.126.15', 'Mozilla/5.0 (Windows NT 5.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3112.90 Safari/537.36', 1731128581, 1731128581, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('8akfhko2e7aieo9oq545rroeue', NULL, '66.249.79.128', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; GoogleOther)', 1730901427, 1730901427, 0, 'currentLocale|s:2:\"id\";', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('8aohic25hvio5hfe5b48fd06rt', NULL, '66.249.66.67', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1731176886, 1731176886, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('8ikkvlkqfjt582cs9h7oulm3f9', NULL, '58.96.208.191', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', 1731313065, 1731313126, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('8incmg1hc3j603fo1s9s4vfbun', NULL, '40.118.212.119', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.98 Safari/537.36', 1731070753, 1731070753, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('8juj96mas4pcn3h6gji44ep1hq', NULL, '35.216.253.131', 'abuse.xmco.fr', 1731100777, 1731100777, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('8ko2i670kibh6caf88hp7rrlrq', NULL, '66.249.79.129', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1730930115, 1730930115, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('8ltml1ir63rnupjphumrgp1jm8', NULL, '115.231.78.3', 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.132 Safari/537.36 QIHU 360SE', 1731234339, 1731234339, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('8o9bbhuckhbvv2hanbg7vrgpkt', NULL, '66.249.79.129', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1730989495, 1730989496, 0, 'currentLocale|s:2:\"en\";csrf|a:2:{s:9:\"timestamp\";i:1730989496;s:5:\"token\";s:32:\"5ffba51a046a96670b26e7034d95f47a\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('8odbkbntvsnb8m6ie5eerutrk0', NULL, '115.231.78.3', 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.132 Safari/537.36 QIHU 360SE', 1731117252, 1731117252, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('8olsncj8nk8desa1hu63bk9kec', NULL, '35.195.29.134', 'python-requests/2.32.3', 1731168681, 1731168681, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('8rm70n195r8bh3446rn17ifdkc', NULL, '8.218.184.149', 'Custom-AsyncHttpClient', 1730928380, 1730928380, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('90igo0qprl5jthpq1o23huhm38', NULL, '138.197.137.98', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.36', 1731051511, 1731051511, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('937m9lnou5icasiu86vclvqeo4', NULL, '195.42.234.218', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.129 Safari/537.36', 1731027592, 1731027592, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('96vdads63uqg60prfqr9kkfuru', NULL, '95.108.213.206', 'Mozilla/5.0 (compatible; YandexBot/3.0; +http://yandex.com/bots)', 1731132732, 1731132732, 0, '', 'arsys.my.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('98i6oh86r6vq8jt3eh5lhejujl', NULL, '66.249.66.67', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1730877434, 1730877444, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('9bq6um9s21p81t18ju3elmd2b7', NULL, '66.249.72.64', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1731052529, 1731052529, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1731052529;s:5:\"token\";s:32:\"e40d0795a4457f2c52b7f528c50de4dc\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('9hdc0f9ehq3n4tqinj414up60p', NULL, '167.94.145.107', '', 1731056416, 1731056416, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('9iv6bq298q4seluepb63t4r5ck', NULL, '71.6.134.231', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/102.0.0.0 Safari/537.36', 1730959249, 1730959249, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('9lkb7lra3rog5stfm2m52d4hj7', NULL, '36.69.111.88', 'Mozilla/5.0 (Linux; U; Android 13; in-id; CPH2235 Build/TP1A.220905.001) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.88 Mobile Safari/537.36 HeyTapBrowser/45.11.4.1', 1730904410, 1730904410, 0, '', 'arsys.my.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('9mlg6tma4ca7balv609a4hu20k', NULL, '66.249.72.71', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1731038611, 1731038611, 0, 'currentLocale|s:2:\"id\";csrf|a:2:{s:9:\"timestamp\";i:1731038611;s:5:\"token\";s:32:\"64ead6f4e6da264de1301d0510593204\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('9n7eig533ipci363t8revb0noq', NULL, '142.58.232.187', 'PkpPlnBot 1.0; http://pkp.sfu.ca', 1731166180, 1731166180, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('9r2nhfah976f572efru2ebe0qq', NULL, '206.168.34.120', '', 1731030632, 1731030632, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('a234aoegosgpereu9o2shserqe', NULL, '66.249.72.64', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; GoogleOther)', 1731002128, 1731002128, 0, 'currentLocale|s:2:\"en\";csrf|a:2:{s:9:\"timestamp\";i:1731002128;s:5:\"token\";s:32:\"148a72279eab978905e46c012eb5fb73\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('a28djll2ce6uv7is43gp811ou7', NULL, '111.231.10.88', 'Mozilla/5.0 (Linux; Android 10; LIO-AN00 Build/HUAWEILIO-AN00; wv) MicroMessenger Weixin QQ AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/78.0.3904.62 XWEB/2692 MMWEBSDK/200901 Mobile Safari/537.36', 1731255825, 1731255825, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('a2a805pen68782rt54tm1mlk0p', NULL, '104.166.80.5', 'Mozilla/5.0 (X11; Linux i686; rv:109.0) Gecko/20100101 Firefox/120.0', 1731163422, 1731163423, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('a2mngrgrhu8nje6fikq44gonku', NULL, '66.249.72.64', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1730996477, 1730996477, 0, 'currentLocale|s:2:\"en\";', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('a2ohqnbiu0idvk5vcfv7v51lsf', NULL, '66.249.66.40', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1731210993, 1731210993, 0, '', 'arsys.my.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('a3rm7bofvhn607m78daonekr32', NULL, '115.231.78.3', 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.132 Safari/537.36 QIHU 360SE', 1731312043, 1731312043, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('a49lm8as5s3ifo6prkbqv9r84h', NULL, '66.249.72.64', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1731001896, 1731001896, 0, 'currentLocale|s:2:\"id\";', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('a5gn847rv6158qcdsifekro001', NULL, '54.245.195.111', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3', 1731185460, 1731185460, 0, '', 'www.peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('a860cqropc0h1s3hos1p9317r8', NULL, '114.67.171.28', 'Custom-AsyncHttpClient', 1731114199, 1731114199, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('a8k0kuvqq5rv2j1mm9vpobrfvm', NULL, '206.168.34.222', 'Mozilla/5.0 (compatible; CensysInspect/1.1; +https://about.censys.io/)', 1731289327, 1731289327, 0, '', '103-146-203-51.cprapid.com');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('a8snms9v9s5svskig182tnhopp', NULL, '180.149.126.12', 'Mozilla/5.0 (Windows NT 5.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3112.90 Safari/537.36', 1730852383, 1730852383, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('aak85mcc74626m6cnnpcectbma', NULL, '66.249.73.237', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1731140550, 1731140550, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1731140550;s:5:\"token\";s:32:\"592e598bcd9875951239b898cb696c26\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('abv33na1itgvhnmoemqnf20092', NULL, '34.227.77.33', '', 1730938616, 1730938616, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('acq0hngicuu9v6ecbjh2aj1eoc', NULL, '66.249.66.68', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1730877441, 1730877441, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('ap546m5elcfq56d4ukuqv8k72i', NULL, '107.172.148.125', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.120 Safari/537.36', 1731119621, 1731119621, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('ap5hg585sd72r94ddm1cih8mqj', NULL, '66.249.72.64', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; GoogleOther)', 1730992295, 1730992295, 0, 'currentLocale|s:2:\"id\";', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('avuivc8okgqco2ir8u5q9efa5a', NULL, '115.231.78.3', 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.2623.112 Safari/537.36', 1730922291, 1730922291, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('b0tkg6abkgg8ac22nd4urq7eb9', NULL, '185.213.25.237', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.129 Safari/537.36', 1730976368, 1730976368, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('b1vkusa568cq9o17of4enc9ob5', NULL, '66.249.79.137', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1730984120, 1730984121, 0, 'currentLocale|s:2:\"en\";', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('b2d8el74bg6t9i9b63s9dbteit', NULL, '66.249.72.64', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1731037412, 1731037412, 0, 'currentLocale|s:2:\"en\";csrf|a:2:{s:9:\"timestamp\";i:1731037412;s:5:\"token\";s:32:\"7d683adf3f4b0d86aaf0fbc93c171cc2\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('b35m2d989nj3ebvl34o96qi228', NULL, '140.213.31.246', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 Edg/130.0.0.0', 1731299409, 1731299455, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('b58slhl5ghld8hrfs7psmi1ih4', NULL, '174.138.61.44', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:61.0) Gecko/20100101 Firefox/72.0', 1731311066, 1731311066, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('b6dbks7q230rn9oovtnuvu54ki', NULL, '36.69.111.88', 'Mozilla/5.0 (Linux; U; Android 13; in-id; CPH2235 Build/TP1A.220905.001) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.88 Mobile Safari/537.36 HeyTapBrowser/45.11.4.1', 1730904411, 1730904411, 0, '', 'arsys.my.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('b7dnmu8j0hepaigg96cd0r58ni', NULL, '185.213.25.237', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.129 Safari/537.36', 1730976369, 1730976369, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('b9qcu4r9bmjtd6vjpjm5quah8h', NULL, '206.168.34.222', '', 1731289322, 1731289322, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('ba8sfvb6kq68bf9ibhkk7d0g8h', NULL, '66.249.72.71', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1731021802, 1731021802, 0, 'currentLocale|s:2:\"id\";', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('bc5bfdeokbt7c52j7fbkfcqu5u', NULL, '8.216.88.38', 'Custom-AsyncHttpClient', 1731240701, 1731240701, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('bfvl9l5sh319m3hbppeevj5qbj', NULL, '66.249.72.71', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1731023788, 1731023789, 0, 'currentLocale|s:2:\"en\";', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('bguteladchq1seibcb8lv1i2um', NULL, '66.249.72.64', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1730999355, 1730999355, 0, 'currentLocale|s:2:\"id\";csrf|a:2:{s:9:\"timestamp\";i:1730999355;s:5:\"token\";s:32:\"0a6255a5b8782d095429b787c327fb88\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('bib669gr2e8d3groo95nupf5a4', NULL, '156.227.0.251', 'Mozilla/5.0 (Linux; U; Android 4.4.2; en-US; HM NOTE 1W Build/KOT49H) AppleWebKit/534.30 (KHTML, like Gecko) Version/4.0 UCBrowser/11.0.5.850 U3/0.8.0 Mobile Safari/534.30', 1731276085, 1731276085, 0, '', 'arsys.my.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('bkiun28jga2tlfcu9ngsm2v2pc', NULL, '118.98.214.4', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:132.0) Gecko/20100101 Firefox/132.0', 1730967644, 1730967644, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('bldqrn6qto02obsl8nh8jpmhpr', NULL, '180.244.138.103', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', 1730957448, 1730957654, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1730957649;s:5:\"token\";s:32:\"bf9ab9720d88fe08eb0d224ab87723ac\";}userId|i:1;username|s:6:\"peacee\";', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('bohru4ca6l2e96ggfoke7tmk7f', NULL, '149.62.45.9', 'Go-http-client/1.1', 1731184142, 1731184142, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('bpjlvog58kh8grnm4hbacl86fp', NULL, '180.244.139.85', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.36', 1731198118, 1731198133, 0, '', 'arsys.my.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('br5abmnb5pj6ll6f6umu1tgqpv', NULL, '66.249.72.64', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1731018238, 1731018238, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1731018238;s:5:\"token\";s:32:\"31380b105ce889b73e82f725c6411d9e\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('brml4c7tqpui9gjajjan02ukp4', NULL, '8.209.96.179', 'Go-http-client/1.1', 1730870200, 1730870200, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('btfu5ru9ejnjavpnulif75u1a1', NULL, '162.142.125.218', 'Mozilla/5.0 (compatible; CensysInspect/1.1; +https://about.censys.io/)', 1731140179, 1731140179, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('c0ut97b3qu719iql0j95odjeg3', NULL, '66.249.69.7', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1731041185, 1731041185, 0, '', 'www.peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('c63uh2ibp1rhch99mrdlan7lrq', NULL, '66.249.72.65', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; GoogleOther)', 1731020124, 1731020124, 0, 'currentLocale|s:2:\"id\";', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('cb1isdjdm0qisugo1699uko6g2', NULL, '66.249.73.225', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1731131570, 1731131570, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('ccna2mdq86a4ba4o5mu9bgtee2', NULL, '103.203.59.1', 'HTTP Banner Detection (https://security.ipip.net)', 1731219442, 1731219442, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('chntv4s78i5gall764vv2pnoir', NULL, '115.231.78.3', 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.132 Safari/537.36 QIHU 360SE', 1731195510, 1731195510, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('cih2so9i8bjlpj3aqcpc4crcet', NULL, '66.249.72.71', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1730998002, 1730998002, 0, 'currentLocale|s:2:\"id\";csrf|a:2:{s:9:\"timestamp\";i:1730998003;s:5:\"token\";s:32:\"669ed0c0b3f52d95ae11597d86c59485\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('cikh86qjs40j4h61q8l9d4c85v', NULL, '142.58.232.187', 'PkpPlnBot 1.0; http://pkp.sfu.ca', 1730907337, 1730907337, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('cikrhff9k7vcprhjspd44j682a', NULL, '165.154.206.204', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/534.45 (KHTML, like Gecko) Chrome/98.0.1750 Safari/537.36', 1731044594, 1731044594, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('cjrl6m7h3cvcs6qatiqacqi8ih', NULL, '46.101.155.147', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.36', 1730917428, 1730917428, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('clvd9j5h465pommejidkdhbagu', NULL, '138.197.137.98', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.36', 1731051504, 1731051504, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('cpmndju95qrd7kh4mmffif1pov', NULL, '66.249.66.68', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1731205597, 1731205597, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('ct0b6napflblihvp36fgg5gtio', NULL, '93.158.91.252', 'Mozilla/5.0 (Android 14; Mobile; rv:123.0) Gecko/123.0 Firefox/123', 1731159950, 1731159950, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('cuu5pcjc3vsh3p2reslnsuneah', NULL, '172.206.141.63', 'Mozilla/5.0 zgrab/0.x', 1730919498, 1730919498, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('cv38vmnkd1ldfjnsc7vkjoduu0', NULL, '182.3.42.176', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Mobile Safari/537.36', 1731290824, 1731290824, 0, '', 'arsys.my.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('d01ql2pcvf2ad0sttb6kfgk4v3', NULL, '66.249.66.68', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1730877433, 1730877433, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('d0kckmuug0k2ptvsmobd4iv300', NULL, '66.249.72.65', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1731022894, 1731022894, 0, 'currentLocale|s:2:\"en\";', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('d466lhhgjr592bb5reba39p1fm', NULL, '66.249.66.68', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1731194611, 1731194611, 0, 'currentLocale|s:2:\"id\";', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('d4cssenv1dnlfn2i7k5fka4vjo', NULL, '66.249.79.129', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1730987415, 1730987415, 0, 'currentLocale|s:2:\"id\";csrf|a:2:{s:9:\"timestamp\";i:1730987415;s:5:\"token\";s:32:\"b7ad2c06a5098e6c5f5798624238dabb\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('d9vdo86fi71131cov13kovq5q1', NULL, '66.249.72.65', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1731055726, 1731055726, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('dd1a7ie41mot3lak0vo1eufjio', NULL, '150.241.77.167', 'Custom-AsyncHttpClient', 1730965772, 1730965772, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('dl8n4ghbrf2gisb7p3jd6egej7', NULL, '66.249.72.65', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1730996479, 1730996479, 0, 'currentLocale|s:2:\"en\";csrf|a:2:{s:9:\"timestamp\";i:1730996479;s:5:\"token\";s:32:\"aa486ebfce74e68035484f977e2a84d7\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('dq73ordn1e2otq9sdm4bmf7iah', NULL, '206.168.34.35', 'Mozilla/5.0 (compatible; CensysInspect/1.1; +https://about.censys.io/)', 1730944581, 1730944581, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('drpedkfgmdmjs4gealohcvmsmt', NULL, '180.244.138.43', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/117.0.0.0 Mobile Safari/537.36', 1731129070, 1731129070, 0, '', 'arsys.my.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('e17ui1oiiek8jvom5jh5o8325c', NULL, '41.251.136.127', 'Mozilla/5.0 (Linux; U; Android 4.4.2; en-US; HM NOTE 1W Build/KOT49H) AppleWebKit/534.30 (KHTML, like Gecko) Version/4.0 UCBrowser/11.0.5.850 U3/0.8.0 Mobile Safari/534.30', 1731069215, 1731069215, 0, '', 'arsys.my.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('e6rllofgeaqep32a6i1p6v577o', NULL, '71.6.232.25', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.131 Safari/537.36', 1731319660, 1731319660, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('ece25c29e40j0oebffnlkhkfv8', NULL, '8.213.128.36', 'Custom-AsyncHttpClient', 1730921741, 1730921741, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('ef527hecntroqr4nphlvjjbipl', NULL, '206.168.34.120', 'Mozilla/5.0 (compatible; CensysInspect/1.1; +https://about.censys.io/)', 1731030639, 1731030639, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('eidhlr0vr319mn58si4rm8f9cd', NULL, '130.162.47.187', 'Custom-AsyncHttpClient', 1731175056, 1731175056, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('elcg32q9ttt5f1b9d1i318muhn', NULL, '66.249.73.237', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1731126050, 1731126050, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1731126050;s:5:\"token\";s:32:\"fbb398a6ff2f5535813cac54566231eb\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('eluc9fbs5aiiq1gcpgstf9d3tf', NULL, '115.231.78.3', 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.132 Safari/537.36 QIHU 360SE', 1730922293, 1730922293, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('eqa9d04l1e2nkfnq1fldesr9qs', NULL, '66.249.79.128', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1730984661, 1730984661, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1730984661;s:5:\"token\";s:32:\"43496f0e262da8e17489668275f68127\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('eu1k47veare2c5ijp198mtlml3', NULL, '182.2.137.236', 'Mozilla/5.0 (iPhone; CPU iPhone OS 12_5_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/12.1.2 Mobile/15E148 Safari/604.1', 1731050948, 1731050949, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('f32pq7s39jb7tln22v0hp5thp7', NULL, '121.5.231.252', 'Mozilla/5.0 (Linux; Android 10; LIO-AN00 Build/HUAWEILIO-AN00; wv) MicroMessenger Weixin QQ AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/78.0.3904.62 XWEB/2692 MMWEBSDK/200901 Mobile Safari/537.36', 1731305420, 1731305420, 0, '', 'www.arsys.my.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('f68ci7850tkml3jb76bdjanvrp', NULL, '66.249.66.67', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1731194612, 1731194612, 0, 'currentLocale|s:2:\"id\";', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('f7omjpj7uo52tabe5u7j8839im', NULL, '45.156.128.49', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3112.113 Safari/537.36', 1731128241, 1731128241, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('f8briv13gli8mbdc1b02nkuqq5', NULL, '66.249.73.225', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1731120159, 1731120159, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('fd052ool82adqdeoaagj8mhq74', NULL, '3.80.120.215', 'Mozilla/5.0 (compatible; Yahoo! Slurp China; http://misc.yahoo.com.cn/help.html)', 1731273059, 1731273059, 0, '', 'arsys.my.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('felm7jntqk64b59r6qgftu66cr', NULL, '142.58.232.187', 'PkpPlnBot 1.0; http://pkp.sfu.ca', 1730993644, 1730993644, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('fgr12qgvhdkjbbnu4p3k5ibfgi', NULL, '66.249.72.65', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1730993816, 1730993816, 0, 'currentLocale|s:2:\"id\";', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('fhkpuhnbkdmv5gi8bnhd18d2ho', NULL, '180.244.164.38', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_0_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.0.1 Mobile/15E148 Safari/604.1', 1730882547, 1730883127, 0, '', 'arsys.my.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('fkp3291cv72pe8t6j7iuk5sudf', NULL, '167.94.145.105', '', 1731211722, 1731211722, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('fp1js0uquq5mpq6u8vrcjt2q2q', NULL, '167.99.13.145', 'Mozilla/4.0 (compatible; MSIE 9.0; Windows NT 10.0; .NET4.0C; .NET4.0E; .NET CLR 2.0.50727; .NET CLR 3.0.30729; .NET CLR 3.5.30729)', 1731213055, 1731213055, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('fsqiboc225esb6v4cngk0jtefa', NULL, '205.210.31.172', '', 1731291513, 1731291513, 0, '', 'www.peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('ft3e0tkrld2h3ts6bq6ubn6v8t', NULL, '213.32.39.46', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:130.0) Gecko/20100101 Firefox/130.0', 1731318276, 1731318276, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('ftsgf3enk64anegqbfupn2mtqi', NULL, '66.249.72.65', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1731004168, 1731004168, 0, 'currentLocale|s:2:\"en\";', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('g49edamq6shg4pn8r50j5u07cn', NULL, '205.169.39.7', 'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36', 1730959736, 1730959736, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('g5ogieudjiqq21reaoqfc1hf4l', NULL, '35.177.209.183', '\'Mozilla/5.0 (compatible; GenomeCrawlerd/1.0; +https://www.nokia.com/networks/ip-networks/deepfield/genome/)\'', 1731071686, 1731071686, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('g8hmf4c9nm42vus7atahdov4a4', NULL, '167.94.146.54', 'Mozilla/5.0 (compatible; CensysInspect/1.1; +https://about.censys.io/)', 1731108245, 1731108245, 0, '', 'www.peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('gg3sgokh3oroiv0etpoitkf0re', NULL, '206.168.34.35', '', 1730944574, 1730944574, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('gju4t2u1phq5le5l1lu20hiqp0', NULL, '103.173.227.187', 'Custom-AsyncHttpClient', 1731122904, 1731122904, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('gm2ufjllkos11k7oscufhbbh03', NULL, '66.249.72.64', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; GoogleOther)', 1730997695, 1730997699, 0, 'currentLocale|s:2:\"en\";', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('gnp8oqh741307idfsak83s9b82', NULL, '45.58.159.191', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36', 1730945677, 1730945677, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('guf5snp0ducmvioasf63dotie9', NULL, '111.231.10.88', 'Mozilla/5.0 (Linux; Android 10; LIO-AN00 Build/HUAWEILIO-AN00; wv) MicroMessenger Weixin QQ AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/78.0.3904.62 XWEB/2692 MMWEBSDK/200901 Mobile Safari/537.36', 1731255825, 1731255825, 0, '', 'www.peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('gupcm62buna86miffbg2kr9s0v', NULL, '45.84.89.2', 'Mozilla/6.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36 Inspici (www.inspici.com)', 1731104963, 1731104963, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('h0aoq0lgb4bb717j0m9tle5ul8', NULL, '146.70.40.237', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.129 Safari/537.36', 1731169939, 1731169939, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('h19pdgrdupcdnalnp594a0htm6', NULL, '103.57.38.205', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:132.0) Gecko/20100101 Firefox/132.0', 1731299531, 1731299584, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('h2elrhimdl2olq3n2cklqt4qfu', NULL, '8.219.144.149', 'Custom-AsyncHttpClient', 1730991788, 1730991788, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('h3agpa80363oq1lmn0u510sh7i', NULL, '205.210.31.33', '', 1731239347, 1731239347, 0, '', 'www.peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('hcrbrobo0n4fn56tnopq8cj4su', NULL, '34.227.77.33', '', 1730914330, 1730914330, 0, '', 'www.peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('heaq5sald0u4cboh12b7sdn3vq', NULL, '66.249.66.68', 'Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1730859876, 1730859876, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('hhv3kfnou72iuc3ndac9tahacd', NULL, '216.218.206.66', 'Mozilla/5.0 (Windows NT 10.0.0; Win64; x64; ) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.6367.63 Chrome/124.0.6367.63 Not-A.Brand/99  Safari/537.36', 1730946981, 1730946981, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('hjlvcn5f3jhdtb9018nhc0r21h', NULL, '8.218.184.149', 'Custom-AsyncHttpClient', 1730928381, 1730928381, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('hliifnqe3dvni6m7dlh644dpm4', NULL, '142.58.232.187', 'PkpPlnBot 1.0; http://pkp.sfu.ca', 1731252489, 1731252489, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('hoaqjukhuua032lb94i1tl81r1', NULL, '35.216.148.67', 'Mozilla/5.0', 1731027191, 1731027191, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('hp6lr81s7ocrn4sa63l5abkqlj', NULL, '199.45.155.75', 'Mozilla/5.0 (compatible; CensysInspect/1.1; +https://about.censys.io/)', 1730944171, 1730944171, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('hphpq6novrh7nc812p8nhktrbf', NULL, '179.43.191.19', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) SamsungBrowser/26.0 Chrome/122.0.0.0 Mobile Safari/537.36', 1731124859, 1731124859, 0, '', 'topuxschool.com');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('hto4bfa9uv74cukrkf2267uhsv', NULL, '150.241.77.167', 'Custom-AsyncHttpClient', 1730965774, 1730965774, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('huij9tc8c6mg7koi7g1n33mkce', NULL, '179.43.168.146', 'l9tcpid/v1.1.0', 1730873771, 1730873771, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('i1s1hcc0vk2v4jki5vep8quvda', NULL, '8.219.198.141', 'Custom-AsyncHttpClient', 1730964253, 1730964253, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('i2kq2ra4ksp8mnlml9puuot69a', NULL, '149.62.45.27', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/112.0.0.0 Safari/537.36', 1731184660, 1731184660, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('i2skgerk3ko9i0n7dg18at2rvg', NULL, '66.249.79.128', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1730972064, 1730972064, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('i4cs0fhnnme4t20r0vubbe6u2f', NULL, '179.43.168.146', 'l9tcpid/v1.1.0', 1730877592, 1730877592, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('i5ce11fo3abkd1gs4r13puigg4', NULL, '130.211.102.244', 'python-requests/2.32.3', 1731113564, 1731113564, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('i5th575j9nqdsjm1j14v9hbre8', NULL, '8.209.96.179', 'Go-http-client/1.1', 1730870199, 1730870199, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('i6tjqacsd6l9aegi3avvqunb8o', NULL, '66.249.72.65', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1731037411, 1731037411, 0, 'currentLocale|s:2:\"en\";', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('i7mk66rfja2t5hb76u4qp0deh0', NULL, '167.172.104.203', '', 1731332355, 1731332355, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('i9l1m68444usj80doumcbu9lrg', NULL, '66.249.72.64', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; GoogleOther)', 1730994995, 1730994999, 0, 'currentLocale|s:2:\"id\";', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('iach7rkvh0h3asdv3gfo21pk88', NULL, '118.98.214.4', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', 1730943486, 1730950091, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1730950091;s:5:\"token\";s:32:\"4c7c39682b601f9614be656e71e79451\";}username|s:6:\"peacee\";', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('ica34a82d564bq3vsc2l2e3kqo', NULL, '66.249.79.128', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1730987414, 1730987414, 0, 'currentLocale|s:2:\"id\";', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('ig5es1gfnonj6p3d3acer4ta64', NULL, '167.71.237.199', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.36', 1730854218, 1730854218, 0, '', 'juteki.web.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('ih11f5pi1cg3dl1gt1o2a2dbg7', NULL, '66.249.66.69', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1730888896, 1730888896, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('iism9t0smekta97j3remsjd64s', NULL, '110.50.80.196', 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36', 1731299247, 1731299248, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('ikatauf21pk88ibsj6f6imq38i', NULL, '66.249.66.69', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1731207370, 1731207370, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('ipe4bfrkn49imbr659hrdobisv', NULL, '140.213.24.84', 'Mozilla/5.0 (Linux; U; Android 14; in-id; CPH2305 Build/UKQ1.230924.001) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.88 Mobile Safari/537.36 HeyTapBrowser/45.11.4.1', 1730951621, 1730951653, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('irlnkhfj8o94956eqgjkin9ca9', NULL, '8.219.198.141', 'Custom-AsyncHttpClient', 1730964254, 1730964254, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('irm5q5e3r7k827bj9jvmb2lr1p', NULL, '103.153.183.247', 'Mozilla/5.0 (Linux; U; Android 4.4.2; en-US; HM NOTE 1W Build/KOT49H) AppleWebKit/534.30 (KHTML, like Gecko) Version/4.0 UCBrowser/11.0.5.850 U3/0.8.0 Mobile Safari/534.30', 1730885536, 1730885536, 0, '', 'arsys.my.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('iu264n4unardmaj7ontv71m8vr', NULL, '66.249.72.65', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1730991867, 1730991868, 0, 'currentLocale|s:2:\"en\";csrf|a:2:{s:9:\"timestamp\";i:1730991868;s:5:\"token\";s:32:\"9e2bf9dfab6f25f2aa004e43435a3d07\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('j0opba4j6r35icm0e9lf3rh02j', NULL, '36.69.111.88', 'Mozilla/5.0 (Linux; U; Android 13; in-id; CPH2235 Build/TP1A.220905.001) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.88 Mobile Safari/537.36 HeyTapBrowser/45.11.4.1', 1730904411, 1730904411, 0, '', 'arsys.my.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('j18h1ro68ppn3ailg4hs4msqg9', NULL, '159.89.39.63', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.36', 1731092578, 1731092578, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('j4l5027odirct70dk1276m9laq', NULL, '188.165.125.250', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.45 Safari/537.36', 1730997320, 1730997320, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('j6kbbac3sldspqmce2ah9ho88e', NULL, '205.210.31.154', '', 1731257690, 1731257690, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('j7ilh2647j1ncqh0cg4buv7gqi', NULL, '167.94.146.54', 'Mozilla/5.0 (compatible; CensysInspect/1.1; +https://about.censys.io/)', 1731255939, 1731255939, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('jc4pbaauvql7mod6gak9gmpukm', NULL, '8.218.184.149', 'Custom-AsyncHttpClient', 1730928380, 1730928380, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('jehv86shr3u5pfbnkf988qnp1q', NULL, '129.227.46.147', 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/44.0.2403.155 Safari/537.36 OPR/31.0.1889.174', 1730870286, 1730870287, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('jfrtfpp45hdokm4b0jglrl739b', NULL, '199.45.154.112', 'Mozilla/5.0 (compatible; CensysInspect/1.1; +https://about.censys.io/)', 1731107749, 1731107749, 0, '', 'www.peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('jgnvcl737iis3r2q1ollj7i803', NULL, '103.149.13.186', 'Mozilla/5.0 (Linux; U; Android 4.4.2; en-US; HM NOTE 1W Build/KOT49H) AppleWebKit/534.30 (KHTML, like Gecko) Version/4.0 UCBrowser/11.0.5.850 U3/0.8.0 Mobile Safari/534.30', 1731029521, 1731029521, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('jia1r5n4usdn9ul0k9l570kqhd', NULL, '66.249.72.65', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1731014580, 1731014580, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('joi9gr1tq8bc8jlbn0vo03kg6i', NULL, '130.211.102.244', 'python-requests/2.32.3', 1731253067, 1731253067, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('jqrkr46f01edsg7uid46h39kpb', NULL, '111.231.10.88', 'Mozilla/5.0 (Linux; Android 10; LIO-AN00 Build/HUAWEILIO-AN00; wv) MicroMessenger Weixin QQ AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/78.0.3904.62 XWEB/2692 MMWEBSDK/200901 Mobile Safari/537.36', 1731255826, 1731255826, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('jr3bjo7o9t9iq80egm3jmt4itu', NULL, '45.156.128.45', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3112.113 Safari/537.36', 1730862929, 1730862929, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('juhjc39krvljnunqapv112psd1', NULL, '45.148.10.69', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_2) AppleWebKit/535.1 (KHTML, like Gecko) Chrome/14.0.835.186 Safari/535.1', 1731212374, 1731212374, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('k0rkcjs0m8f3f23d74f4u27k72', NULL, '66.249.73.225', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1731086687, 1731086687, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('k1vlqejerg3aso74dv5pjgbm0j', NULL, '35.203.210.221', 'Expanse, a Palo Alto Networks company, searches across the global IPv4 space multiple times per day to identify customers&#39; presences on the Internet. If you would like to be excluded from our scans, please send IP addresses/domains to: scaninfo@paloal', 1730974236, 1730974236, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('k5s254drsilcavljsntp4e76h0', NULL, '66.249.66.68', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1730893978, 1730893978, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('k6mjl9e1ona5smhh4fnf95adpk', NULL, '167.94.138.48', '', 1731276161, 1731276161, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('k7bjiouvr52m2oq8od06can7g6', NULL, '66.249.72.71', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1731035144, 1731035144, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('k7f2rqlh6ik6ipkuvccicimdpn', NULL, '142.93.91.93', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36', 1731002040, 1731002040, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('k7qnl0n7t7dnh9i07me8ndkb95', NULL, '66.249.66.68', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1731221549, 1731221549, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('k9b9nt6qlvtsi78hto34946eni', NULL, '125.164.17.240', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Mobile Safari/537.36', 1731287467, 1731287471, 0, '', 'arsys.my.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('kc3i8m2iplp7flnc3ib7voh922', NULL, '66.249.72.65', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1731002244, 1731002244, 0, 'currentLocale|s:2:\"id\";', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('ke6td4ck8cqedn29nnefh49mkk', NULL, '66.249.79.129', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1730921377, 1730921377, 0, 'currentLocale|s:2:\"id\";', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('kflumn0oii2tcmnpt8kbe8v15i', NULL, '66.249.72.64', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1731019494, 1731019495, 0, 'currentLocale|s:2:\"id\";', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('kh9a090j7slj9oqegom23kk1kc', NULL, '185.213.25.237', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.129 Safari/537.36', 1731202106, 1731202106, 0, '', 'www.peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('ki3junnv491stt151r0tvnigs9', NULL, '167.94.138.59', 'Mozilla/5.0 (compatible; CensysInspect/1.1; +https://about.censys.io/)', 1731091890, 1731091890, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('km13b1geglenl9gj08p4d4epvo', NULL, '66.249.66.21', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1730866634, 1730866634, 0, '', 'www.peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('knsbs6frip73vpkdlg38ggfbbm', NULL, '98.80.4.66', 'Mozilla/5.0 (Windows NT 6.2;en-US) AppleWebKit/537.32.36 (KHTML, live Gecko) Chrome/53.0.3019.104 Safari/537.32', 1731282101, 1731282101, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('kpcstbbnqdlkfusghtu2b029u5', NULL, '66.249.72.71', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; GoogleOther)', 1731002123, 1731002123, 0, 'currentLocale|s:2:\"en\";', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('kv32rn0p1prs67cjbnh9ik2feg', NULL, '142.58.232.187', 'PkpPlnBot 1.0; http://pkp.sfu.ca', 1731252489, 1731252489, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('l347qg4lmnvngv2j0mghtharrh', NULL, '66.249.79.129', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1730981421, 1730981421, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1730981421;s:5:\"token\";s:32:\"e23c7cb6cae047c275559021bcadaab1\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('l3tm9ee48m933jak0nstgsbftg', NULL, '165.232.183.71', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.36', 1730917255, 1730917255, 0, '', 'www.peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('l7ls6cg8sinrlffq48j1dba0tb', NULL, '8.219.144.149', 'Custom-AsyncHttpClient', 1730991788, 1730991788, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('l7ndkm3s543ou0oollmv6hvks8', NULL, '150.241.77.167', 'Custom-AsyncHttpClient', 1730965768, 1730965768, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('l7tnqqqri8f38i2u2m2pghr4u3', NULL, '66.249.72.71', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1731026733, 1731026733, 0, 'currentLocale|s:2:\"id\";', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('l8eqajscnsgimlum0o4pgq34p5', NULL, '66.249.72.64', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1730993817, 1730993817, 0, 'currentLocale|s:2:\"id\";csrf|a:2:{s:9:\"timestamp\";i:1730993817;s:5:\"token\";s:32:\"19c327ac9395c64c6e3eede0e8570321\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('l8t0d2qjok28nvs5ebvb3bfvh6', NULL, '115.231.78.3', 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.132 Safari/537.36 QIHU 360SE', 1731078603, 1731078603, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('ldkp22iovimemoahg99fd56a46', NULL, '103.23.244.234', 'Mozilla/5.0 (Linux; Android 6.0.1; CPH1701) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Mobile Safari/537.36', 1730952371, 1730952372, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('le0ngpge6tp2q1n0p68p54od1l', NULL, '45.84.89.2', 'Mozilla/6.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36 Inspici (www.inspici.com)', 1731016759, 1731016759, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('ledfl286pi23g5m0tjelbgbums', NULL, '139.99.9.160', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:130.0) Gecko/20100101 Firefox/130.0', 1731318007, 1731318007, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('letqgbdsb37av5huqpdbtgkl9i', NULL, '92.255.57.58', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', 1730886858, 1730886858, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('lf40o7fe0l1hc9a8he91orfceu', NULL, '66.249.72.71', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1731057102, 1731057102, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('lftnt96jrmnh4t6csg89uqs573', NULL, '8.209.96.179', 'Go-http-client/1.1', 1730870200, 1730870200, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('lhtga850cofo8ceurgo6psjei6', NULL, '66.249.66.43', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1730861254, 1730861254, 0, '', 'arsys.my.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('lif39uenvha1oafcvl3p1u0sv3', NULL, '185.213.25.237', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.129 Safari/537.36', 1731202105, 1731202105, 0, '', 'www.peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('lk1i7sc8kgta344ttcvuop0dnh', NULL, '66.249.79.137', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; GoogleOther)', 1730989595, 1730989595, 0, 'currentLocale|s:2:\"id\";', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('lkumqg9iru5e7elcq63blng9g6', NULL, '66.249.72.64', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1731002243, 1731002243, 0, 'currentLocale|s:2:\"id\";', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('ll9hshuu09579b1q8354k0kbg9', NULL, '66.249.66.67', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1730892344, 1730892344, 0, 'currentLocale|s:2:\"id\";', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('lm0c7fr8e8oo0hhr0kpiv1v7ul', NULL, '146.70.40.237', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.129 Safari/537.36', 1731170232, 1731170232, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('lobi3mjq1ggvdlrddftfe50ovj', NULL, '157.230.237.180', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36', 1730938917, 1730938917, 0, '', 'arsys.my.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('lok3h2hf7oldfqurcvr5ebmeh7', NULL, '47.89.173.26', 'Custom-AsyncHttpClient', 1731255180, 1731255180, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('lr4lh2j71mfa8sn4jac2mu3sa4', NULL, '66.249.72.64', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1731030987, 1731030987, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('lrp6vijim3eh4rolr10lqfnrqf', NULL, '64.62.156.57', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36', 1731247147, 1731247147, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('lrsr94m41n844g9kj052igvv5i', NULL, '8.219.198.141', 'Custom-AsyncHttpClient', 1730964254, 1730964254, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('ls7kdn4tnobfsnn2albsumpujm', NULL, '87.236.176.102', 'Mozilla/5.0 (compatible; InternetMeasurement/1.0; +https://internet-measurement.com/)', 1731324580, 1731324580, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('lta4shmslp95avleqc3rlbltom', NULL, '157.230.237.180', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17 Safari/605.1.15', 1731196506, 1731196506, 0, '', 'arsys.my.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('m2c1qophtlsukji8dava9nl6sv', NULL, '66.249.66.67', 'Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1730859877, 1730859877, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('m45dnj9ug91sifd9f4fgr30le6', NULL, '104.166.80.132', 'Mozilla/5.0 (X11; Linux i686; rv:109.0) Gecko/20100101 Firefox/120.0', 1731264558, 1731264558, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('m4lteq0rlvqglcm4akkc1rl5li', NULL, '35.177.209.183', '\'Mozilla/5.0 (compatible; GenomeCrawlerd/1.0; +https://www.nokia.com/networks/ip-networks/deepfield/genome/)\'', 1731071537, 1731071537, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('m540tu27n4vovfeba8tprjk0io', NULL, '114.67.171.28', 'Custom-AsyncHttpClient', 1731114201, 1731114201, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('m71ge7bngs2u7vjcl9mik0tm8v', NULL, '66.249.72.71', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1731034422, 1731034422, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('m7cmg38i97gml60t2q28si7mj2', NULL, '66.249.79.128', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; GoogleOther)', 1730981438, 1730981438, 0, 'currentLocale|s:2:\"id\";csrf|a:2:{s:9:\"timestamp\";i:1730981438;s:5:\"token\";s:32:\"09b6426b02a52a0a5132f9adc906627d\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('m7jqlfogv1p7ud65b406b7to51', NULL, '198.244.249.177', 'Mozilla/5.0 (Linux; Android 9; SM-G960U) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/76.0.3809.111 Mobile Safari/537.36', 1731058807, 1731058807, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('m8656nmn0jsf24m8b42bd8mhk9', NULL, '108.165.237.183', '', 1731266110, 1731266110, 0, '', 'arsys.my.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('mansbda5rrs4qjucug65mrei0t', NULL, '66.249.66.68', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; GoogleOther)', 1730888646, 1730888646, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('mbd8ap3iml6hpvqjg5s207e9q2', NULL, '213.32.39.36', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:130.0) Gecko/20100101 Firefox/130.0', 1731279872, 1731279872, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('mdo2omlfda8psui822nboa9drm', NULL, '115.231.78.3', 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.2623.112 Safari/537.36', 1731234338, 1731234338, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('mg2c103khue4d1csgvmgf0jlop', NULL, '185.242.226.117', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.190 Safari/537.36', 1731309077, 1731309077, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('mh27upih73pup05r2np27mclh1', NULL, '66.249.79.137', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; GoogleOther)', 1730896030, 1730896030, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('mivq5f3gj9q5d2ll0gbn67g5nn', NULL, '128.199.59.178', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.36', 1731050237, 1731050237, 0, '', 'www.peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('mjktem8bj1i7nt9cd6704cedrp', NULL, '182.3.42.176', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Mobile Safari/537.36', 1731285485, 1731285521, 0, '', 'arsys.my.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('mk9dl49vekfs9tvtkfrr43p6mo', NULL, '66.249.66.68', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1731168080, 1731168080, 0, 'currentLocale|s:2:\"en\";', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('mp1pk91rniq453qgpmqv1b0d9p', NULL, '135.148.25.115', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:130.0) Gecko/20100101 Firefox/130.0', 1730898643, 1730898643, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('mq6s7i7dcqvgacna7e21q7847c', NULL, '103.23.244.234', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:132.0) Gecko/20100101 Firefox/132.0', 1730875746, 1730875778, 0, '', 'arsys.my.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('mqfo65d874o8i1pubv0c8bd4lk', NULL, '46.101.155.147', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.36', 1730917437, 1730917437, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('mqkn9laqc2rgoaefudro5fi29p', NULL, '139.59.44.30', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36', 1731108591, 1731108591, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('mr8e482kdmde7im2khqrk3s66m', NULL, '209.38.206.136', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101 Firefox/118.0', 1731245683, 1731245683, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('mt0qcoq4rj6ui774j872i58b4n', NULL, '180.244.164.38', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_0_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.0.1 Mobile/15E148 Safari/604.1', 1730892860, 1730892860, 0, '', 'arsys.my.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('mtlp0mkdvub69h8r8neetquhb1', NULL, '103.121.39.54', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/56.0.2924.87 Safari/537.36', 1730906005, 1730906565, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('n03fc7894tcaaqu658o3oeobuh', NULL, '103.173.227.187', 'Custom-AsyncHttpClient', 1731122903, 1731122903, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('n06qijai2o4p5hkebiu11vf36k', NULL, '180.244.139.85', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.36', 1731198117, 1731198117, 0, '', 'arsys.my.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('n0mp1k1ea9uk4l2evuqjci92ra', NULL, '106.75.33.113', '', 1730973109, 1730973109, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('n1q3v2l2o3us4kr9418m5pkh1s', NULL, '66.249.79.128', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1730921376, 1730921376, 0, 'currentLocale|s:2:\"id\";', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('n6ks4dm180k3kqmn7hdh2oki95', NULL, '103.57.38.205', 'WhatsApp/2.23.20.0', 1731299251, 1731299251, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('n7aekcbkcmkvgc1qk8linqkbsb', NULL, '66.249.72.65', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1731029292, 1731029292, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('n8ffnd02d6k2i6li6kiebgknro', NULL, '66.249.72.65', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1730992543, 1730992543, 0, 'currentLocale|s:2:\"en\";csrf|a:2:{s:9:\"timestamp\";i:1730992544;s:5:\"token\";s:32:\"99d66275a163171035297580ce57c15e\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('n93l3nimvja0cikaq3hsjqos2b', NULL, '64.62.156.106', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:108.0) Gecko/20100101 Firefox/108.0', 1731303073, 1731303073, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('nb69uiobf7dhjj72e6lr698inp', NULL, '115.231.78.3', 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.132 Safari/537.36 QIHU 360SE', 1731273138, 1731273138, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('ncvgqm3rdlljpo6tro84lbv2ld', NULL, '104.166.80.143', 'Mozilla/5.0 (X11; Linux i686; rv:109.0) Gecko/20100101 Firefox/120.0', 1730876844, 1730876844, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('nh3ncbuk4343a812v2ssqatjrh', NULL, '66.249.72.64', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; GoogleOther)', 1731020129, 1731020129, 0, 'currentLocale|s:2:\"id\";csrf|a:2:{s:9:\"timestamp\";i:1731020129;s:5:\"token\";s:32:\"143565064769258f77afd199edca58ba\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('nhduh6mavevsd89bk4d6f255f1', NULL, '8.216.88.38', 'Custom-AsyncHttpClient', 1731240701, 1731240701, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('nimtg0aed2ue7fq9rt8mb096bj', NULL, '198.235.24.56', '', 1731314919, 1731314919, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('nj6p1571k6e9ilqp1i2ocq3bej', NULL, '167.172.104.203', '', 1731332356, 1731332356, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('nkohajocje51elnueiqdbgbu4f', NULL, '104.166.80.81', 'Mozilla/5.0 (X11; Linux i686; rv:109.0) Gecko/20100101 Firefox/120.0', 1731075218, 1731075219, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('nprjcd6o7lilgu4b14t3h8649f', NULL, '66.249.79.128', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1730974227, 1730974227, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1730974227;s:5:\"token\";s:32:\"f3a6804d927734496fc639117411ec1b\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('nq1e4gt81ohg86doqe1krpf66d', NULL, '52.228.154.87', 'Mozilla/5.0 zgrab/0.x', 1731264299, 1731264299, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('nq7p73g89sndbplcpsti1erqi7', NULL, '34.140.231.8', 'python-requests/2.32.3', 1730915844, 1730915844, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('nr5co52mkefq6l4rbadlfhe9ic', NULL, '66.249.66.67', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.4844.84 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1730877452, 1730877453, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('nvm13ps3ckm28gpua358ttuphl', NULL, '65.49.20.69', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0) Gecko/20100101 Firefox/102.0', 1731150463, 1731150463, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('o03ff5dj7kovsc2u6v3kg0pqej', NULL, '194.169.175.107', 'Mozilla/5.0 (Windows NT 10.0; rv:102.0) Gecko/20100101 Firefox/102.0', 1731215591, 1731215591, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('o6bm0rne8f98soqhjhgjpa5sob', NULL, '167.172.103.155', 'Mozilla/5.0 (compatible; Odin; https://docs.getodin.com/)', 1731332359, 1731332359, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('oave4og83ma1364upnmuv7mda0', NULL, '198.235.24.56', '', 1731314918, 1731314918, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('obfj8enr8h1tcn25ik3d562vmm', NULL, '35.88.172.34', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.102 Safari/537.36', 1731298270, 1731298270, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('ocblhovvmoovtivc62vih6tpad', NULL, '66.249.72.65', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1731043780, 1731043780, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1731043781;s:5:\"token\";s:32:\"d9a66586e99837da0dedf7b9e33681af\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('of9ibac2f1uedj6pqscrfkddj6', NULL, '198.244.213.98', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.99 Safari/537.36', 1731275141, 1731275141, 0, '', '103-146-203-51.cprapid.com');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('oh8ope2ia13u8oflc12cb517us', 1, '103.57.38.205', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:131.0) Gecko/20100101 Firefox/131.0', 1730539493, 1730557982, 1, 'csrf|a:2:{s:9:\"timestamp\";i:1730557982;s:5:\"token\";s:32:\"58d64efb5dab3dad3d1515129b39829e\";}username|s:6:\"peacee\";userId|i:1;', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('ojqjve2vpp6u3cl22n46hvi1vj', NULL, '167.94.146.54', '', 1731255935, 1731255935, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('oki64go3na03b4sog726mk131s', NULL, '66.249.79.128', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; GoogleOther)', 1730908863, 1730908866, 0, 'currentLocale|s:2:\"id\";', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('ons7jrkljpr452mcp5i0isqnng', NULL, '62.210.90.209', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.3', 1731226894, 1731226895, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('oqad9909ngo2io1ipfur8cm52k', NULL, '115.231.78.3', 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.132 Safari/537.36 QIHU 360SE', 1731156229, 1731156229, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('oqn8jpt6alsfsld9tuarvgenq4', NULL, '66.249.72.71', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1731060325, 1731060325, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('oqvvfire60tb1nm04u3m23qsiq', NULL, '180.244.138.43', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 Edg/130.0.0.0', 1731129162, 1731129162, 0, '', 'arsys.my.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('osdc8n8uho8dkc97gfjlsuu719', NULL, '35.203.211.183', 'Expanse, a Palo Alto Networks company, searches across the global IPv4 space multiple times per day to identify customers&#39; presences on the Internet. If you would like to be excluded from our scans, please send IP addresses/domains to: scaninfo@paloal', 1731041117, 1731041117, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('otmen5okjhf2ud2cp11edgrkbn', NULL, '8.213.128.36', 'Custom-AsyncHttpClient', 1730921742, 1730921742, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('otr9a8pcubflooca0jalm5nqps', NULL, '66.249.79.129', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1730979810, 1730979810, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1730979810;s:5:\"token\";s:32:\"b160ea3becdbc31541a19225a82b2554\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('oubvlerk1g9mf8d0ahqfptmqo9', NULL, '66.249.73.224', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1731075750, 1731075750, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('ouhobe7sds3r0o4qh3q9kg2uqu', NULL, '8.209.96.179', 'Go-http-client/1.1', 1730870200, 1730870200, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('p2ph72cgur1e1a28gpbjofdl0p', NULL, '45.84.89.2', 'Mozilla/6.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36 Inspici (www.inspici.com)', 1731284050, 1731284050, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('p36rvpqrvb1n1nqmufk0f4s2pp', NULL, '34.227.77.33', '', 1730914329, 1730914329, 0, '', 'www.peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('p5o4b97f4flaa703mjrh6qafqg', NULL, '66.249.79.129', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1730988777, 1730988777, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1730988777;s:5:\"token\";s:32:\"d257c9aba0e508c409aee1f44007b5a4\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('p6pld133r3opsdtfarktis8rak', NULL, '66.249.79.128', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1730988656, 1730988656, 0, 'currentLocale|s:2:\"id\";', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('pabn6j98l094ibnlc7dep0a019', NULL, '66.249.79.137', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; GoogleOther)', 1730905145, 1730905145, 0, 'currentLocale|s:2:\"id\";', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('paf3o0bvechgltv65cicuihh9c', NULL, '159.203.8.218', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.36', 1731040747, 1731040747, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('pd97nuvna1514s9rk0bo1hvbr9', NULL, '66.249.79.128', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; GoogleOther)', 1730981720, 1730981720, 0, 'currentLocale|s:2:\"id\";', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('pj203fk9gp032klt0f4qglp4vq', NULL, '8.216.80.166', 'Custom-AsyncHttpClient', 1731160269, 1731160269, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('pj3uhenk6kkjcro1jfl126uv2k', NULL, '115.231.78.3', 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.2623.112 Safari/537.36', 1731156227, 1731156227, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('pkvi26kfoii7sdhpb60ovv1ue5', NULL, '115.231.78.3', 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.2623.112 Safari/537.36', 1731117250, 1731117250, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('pom63asqe1noicc637jt4t990s', 1, '::1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.6.1 Safari/605.1.15', 1729941830, 1729941924, 1, 'csrf|a:2:{s:9:\"timestamp\";i:1729941924;s:5:\"token\";s:32:\"bf6528b34fab7714a4864e4542c7e78c\";}userId|i:1;username|s:6:\"peacee\";', 'peacee');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('ptsnb91ncdl6g3md0u1mbkaafu', NULL, '103.36.11.147', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 Viewer/99.9.8599.85', 1731285391, 1731285391, 0, '', 'arsys.my.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('pukh50dt51v18fco47kkafh7is', NULL, '185.242.226.117', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.190 Safari/537.36', 1731134298, 1731134298, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('q10fdfhipg7jd44aq5sel0vkon', NULL, '206.168.34.35', 'Mozilla/5.0 (compatible; CensysInspect/1.1; +https://about.censys.io/)', 1730944622, 1730944622, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('q8mutp2ov22le15gp1lsljmtmm', NULL, '62.210.114.63', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.4844.82 Safari/537.36', 1731159180, 1731159180, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('q8qr63plo9ahnleshf7kmsmssg', NULL, '92.255.57.58', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', 1731151172, 1731151172, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('qedlarisqun0t79uh9h743bkrm', NULL, '66.249.72.71', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1731007398, 1731007398, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('qh0cmltjf63q1fk06knhv10on5', 1, '103.57.38.205', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:132.0) Gecko/20100101 Firefox/132.0', 1730602681, 1730814112, 1, 'csrf|a:2:{s:9:\"timestamp\";i:1730814112;s:5:\"token\";s:32:\"25e40fd27b1a7dc2df6a89209af4f4da\";}username|s:6:\"peacee\";userId|i:1;', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('qhmkmuf7dmqucap3jo4ai2sqf9', NULL, '140.213.31.11', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', 1730856355, 1730856914, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1730856914;s:5:\"token\";s:32:\"a722f9e3dc520973922eb7ed4f92ef12\";}username|s:6:\"peacee\";', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('qq65i2hqmeqphi32vnqi7b38ce', NULL, '66.249.79.137', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1730930114, 1730930114, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('qro0ppgehq907duea0k9s3nsj9', NULL, '66.249.72.65', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1731033700, 1731033700, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('qsnnoqc8070vhget8ug2hvq6m9', NULL, '93.159.230.84', 'Mozilla/5.0 (Linux; arm_64; Android 12; CPH2205) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 YaBrowser/23.3.3.86.00 SA/3 Mobile Safari/537.36', 1731292197, 1731292197, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('r6cd0n5uaes2q2snog10prdpjs', NULL, '66.249.72.64', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1731021803, 1731021803, 0, 'currentLocale|s:2:\"id\";', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('r6k63ropbp605h2crmbk9h3vkk', NULL, '62.141.44.236', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.114 Safari/537.36 Edg/91.0.864.54', 1731004153, 1731004153, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('r73adf1dnal79mtndhqc83cupi', NULL, '159.65.237.184', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.36', 1731264654, 1731264654, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('r75bedeikp81orkmc9dulcq7a3', NULL, '108.165.237.183', '', 1731266108, 1731266108, 0, '', 'arsys.my.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('r8mtp06tmv8t1pmjgrdbt7nbf0', NULL, '118.98.214.4', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:132.0) Gecko/20100101 Firefox/132.0', 1730951590, 1730951591, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('r91g47ul0eej6ompl5dtjb5i01', 1, '103.178.218.145', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', 1730690576, 1730772784, 1, 'csrf|a:2:{s:9:\"timestamp\";i:1730772784;s:5:\"token\";s:32:\"163410a3439bed50ce9c421b975d9e52\";}userId|i:1;username|s:6:\"peacee\";', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('rb586ena7lhmp1k1apnngqbebp', NULL, '66.249.72.64', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1731058483, 1731058483, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1731058483;s:5:\"token\";s:32:\"434a88fd55daff7f851aa8fef3139310\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('rcg7athojduddno0s6mqcaa2cj', NULL, '8.213.128.36', 'Custom-AsyncHttpClient', 1730921742, 1730921742, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('rd1c2ea1rfjqsrflh92l277mih', NULL, '8.209.96.179', 'Go-http-client/1.1', 1730870200, 1730870200, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('rfigof6t3hfur8ath0u7vsudif', NULL, '185.242.226.117', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.190 Safari/537.36', 1731041724, 1731041724, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('rhjcn20hkefi41napsgutk7n1u', NULL, '92.255.57.58', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', 1731240701, 1731240701, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('rht2l74lpeifnvmelc4l7ccclh', 1, '103.233.100.230', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.6.1 Safari/605.1.15', 1730262430, 1730262679, 1, 'csrf|a:2:{s:9:\"timestamp\";i:1730262679;s:5:\"token\";s:32:\"77502b8c20159d902ce7bee5bde42fb4\";}userId|i:1;username|s:6:\"peacee\";', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('ri7dcejbrsv9mcbrsg296lkeja', NULL, '66.249.79.129', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; GoogleOther)', 1730981723, 1730981723, 0, 'currentLocale|s:2:\"id\";csrf|a:2:{s:9:\"timestamp\";i:1730981723;s:5:\"token\";s:32:\"bb91eb26e413fbb054e5d0c8ebfc479a\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('rj1p19k0jgnmq5oahcua5dikce', NULL, '45.84.89.2', 'Mozilla/6.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36 Inspici (www.inspici.com)', 1730927015, 1730927015, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('rkubu7ggos8fkbn7c2vjd0jjfr', NULL, '66.249.73.237', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1731151596, 1731151596, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('rlqb0jsk2jidfnn0bsmnm4rvur', NULL, '66.249.72.65', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1731023970, 1731023970, 0, 'currentLocale|s:2:\"en\";', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('rpj7084e0n0sgbntc87kjir488', NULL, '34.227.77.33', '', 1730938616, 1730938616, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('rub8dumr53ucuutni9bdsfa10n', NULL, '8.219.188.212', 'Custom-AsyncHttpClient', 1731074009, 1731074009, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('s6d3vh73us9drvd3ku3mqam716', NULL, '114.122.83.164', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Mobile Safari/537.36', 1731293137, 1731293137, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('s7uk58emsmti9jvmft8ik9sual', 1, '::1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', 1729942014, 1729942282, 1, 'csrf|a:2:{s:9:\"timestamp\";i:1729942283;s:5:\"token\";s:32:\"0a249128d833c9435f6b0dba180e9260\";}userId|i:1;username|s:6:\"peacee\";', 'peacee');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('schc37m4kbu9720vlf2vnth9vb', NULL, '47.89.173.26', 'Custom-AsyncHttpClient', 1731255179, 1731255179, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('sea61r57ioivfv2112kmd9o1gn', NULL, '64.62.197.159', 'Mozilla/5.0 (X11; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/110.0', 1731071416, 1731071416, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('sjtbpl8925av3u338ia55ijl3e', NULL, '118.98.214.4', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:132.0) Gecko/20100101 Firefox/132.0', 1730967376, 1730967452, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('sroj87l1ck2bqba3cpg0u15g28', NULL, '35.203.211.28', 'Expanse, a Palo Alto Networks company, searches across the global IPv4 space multiple times per day to identify customers&#39; presences on the Internet. If you would like to be excluded from our scans, please send IP addresses/domains to: scaninfo@paloal', 1730866275, 1730866275, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('t117hkb21v0qdgasqirc1g4qup', NULL, '8.219.188.212', 'Custom-AsyncHttpClient', 1731074010, 1731074010, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('t2pvitiard7crqanqb7cngj4oh', NULL, '66.249.66.68', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1731200376, 1731200376, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('t425c8n9kg44u9o2jnfkqljbtu', NULL, '115.231.78.3', 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.2623.112 Safari/537.36', 1731039950, 1731039950, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('t6lmd840clvn1qjr95kvqbm40b', NULL, '27.52.2.233', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.1 Mobile/15E148 Safari/604.1', 1731241492, 1731241492, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('t83cjj70499usrjetq5tr5kh57', NULL, '125.164.17.240', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', 1731287459, 1731287465, 0, '', 'arsys.my.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('t865tqc65j431hq4p4cnj2lngn', NULL, '66.249.66.69', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1731232350, 1731232350, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1731232350;s:5:\"token\";s:32:\"935a2c2a324724f03ce0ab5627710c35\";}', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('t8qqua7o8167f0pcp3l5hinqmj', NULL, '66.249.79.137', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; GoogleOther)', 1730981434, 1730981434, 0, 'currentLocale|s:2:\"id\";', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('tak88rmuh6labaqrhkgv253brm', NULL, '115.231.78.3', 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.132 Safari/537.36 QIHU 360SE', 1730883150, 1730883150, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('tcj66blnkkfdfp3i4glrlnuu1i', NULL, '34.227.77.33', '', 1730914332, 1730914332, 0, '', 'www.peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('tf3rlrb8e7d0c1vasi4ut48gls', NULL, '66.249.72.71', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1731027446, 1731027446, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('titoflsnq0bmm4jquo8gj5lecr', NULL, '51.254.49.110', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:130.0) Gecko/20100101 Firefox/130.0', 1731282143, 1731282143, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('tl6tboq6ciii6q5spkv6fnodr4', NULL, '114.122.71.169', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Mobile Safari/537.36', 1731124074, 1731124074, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('tnnbqo1loj5pjifsch9mj15hh1', NULL, '66.249.72.64', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1731017097, 1731017097, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('tq7hdfqeegf8osugaqjpu2gvaa', NULL, '66.249.66.22', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1731166026, 1731166026, 0, '', 'www.peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('tsvirrlbcut1djtpts1uv1rghv', NULL, '167.172.104.203', '', 1731332353, 1731332353, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('ttcjdebsqrlftlvtj9g9ipdfk1', NULL, '66.249.66.67', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1730888900, 1730888900, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('tueb74cjd2jn8k09dn06pv16j0', NULL, '139.162.210.87', 'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:8.0) Gecko/20100101 Firefox/8.0', 1731058891, 1731058891, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('u1nnol5ot0j908ec54rvieao6v', NULL, '182.0.226.127', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Mobile Safari/537.36', 1730959968, 1730960083, 0, '', 'arsys.my.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('u4g148i2i5k1k2npagkbqadhe1', NULL, '199.45.154.133', '', 1730923125, 1730923125, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('u5vcf2d7id473vhakcaskt5fia', NULL, '140.213.137.8', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', 1730859925, 1730860206, 0, 'csrf|a:2:{s:9:\"timestamp\";i:1730860198;s:5:\"token\";s:32:\"a722f9e3dc520973922eb7ed4f92ef12\";}username|s:6:\"peacee\";', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('ucqc1c2srpe6p20cccl1kvq7dr', NULL, '216.218.206.66', 'Mozilla/5.0 (Windows NT 10.0.0; Win64; x64; ) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.6367.63 Chrome/124.0.6367.63 Not-A.Brand/99  Safari/537.36', 1730947501, 1730947501, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('ud84q27ckchfknc3pu455soak8', NULL, '36.72.90.194', 'Mozilla/5.0 (Macintosh;                 Intel Mac OS X 10_10_1) AppleWebKit/537.36 (KHTML,                 like Gecko) Chrome/39.0.2171.95 Safari/537.36', 1731088518, 1731088518, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('umch79f4vaog6qisrcffgfcace', NULL, '66.249.72.65', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1731036388, 1731036389, 0, 'currentLocale|s:2:\"id\";', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('uo3r803e5dlf9v1elm7j1hu2es', NULL, '66.249.66.69', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1731173129, 1731173129, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('uo5urue9klho51o23gijidpq91', NULL, '167.94.146.54', '', 1731108240, 1731108240, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('uoifsuvi0u1p9n3e2jehao8ia0', NULL, '34.227.77.33', '', 1730938614, 1730938614, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('ur8kcq3p8mdnbpp9bim2ug50l5', NULL, '36.69.111.88', 'Mozilla/5.0 (Linux; U; Android 13; in-id; CPH2235 Build/TP1A.220905.001) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.88 Mobile Safari/537.36 HeyTapBrowser/45.11.4.1', 1730904411, 1730904425, 0, '', 'arsys.my.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('userq74e3uef6g7kivqn3crn4v', NULL, '66.249.79.137', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1730985920, 1730985920, 0, 'currentLocale|s:2:\"en\";', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('uukjd9p5uv5rtqmgv2sg6lt74l', NULL, '167.94.138.48', 'Mozilla/5.0 (compatible; CensysInspect/1.1; +https://about.censys.io/)', 1731276166, 1731276166, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('uvpvbo2ph6a4j1ee6ul0ghjero', NULL, '115.231.78.3', 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.2623.112 Safari/537.36', 1731195508, 1731195508, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('uvu2f2upm5to40r97s72vk1ms4', NULL, '66.249.66.67', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1731168079, 1731168079, 0, 'currentLocale|s:2:\"en\";', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('v0fqs7de7uca9fj2ts451qrro9', NULL, '66.249.72.71', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; GoogleOther)', 1730992299, 1730992299, 0, 'currentLocale|s:2:\"id\";', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('v0tpk47d6qro6t65kla9ueen6p', NULL, '35.176.171.86', '\'Mozilla/5.0 (compatible; GenomeCrawlerd/1.0; +https://www.nokia.com/networks/ip-networks/deepfield/genome/)\'', 1731065882, 1731065882, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('v238sjbagkap42dlesvhq3mh71', NULL, '104.166.80.177', 'Mozilla/5.0 (X11; Linux i686; rv:109.0) Gecko/20100101 Firefox/120.0', 1730989364, 1730989364, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('v42cmtapfa41llckklri0q6o2d', NULL, '45.43.33.218', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:130.0) Gecko/20100101 Firefox/130.0', 1731277311, 1731277311, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('v5vtjvtnigpe6tanj0ta8v8pv5', NULL, '13.58.97.162', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', 1730873525, 1730873525, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('v6ili0kl6ihiejtlnj7rf62h3t', NULL, '115.231.78.3', 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.132 Safari/537.36 QIHU 360SE', 1731039952, 1731039952, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('v6pudf34m3p9oejnk6qqtvb8l4', NULL, '87.120.114.254', 'Mozilla/5.0 (X11; Linux i686) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36', 1731059609, 1731059609, 0, '', '103-146-203-51.cprapid.com');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('v77j218uje2j3ekfidnb3pm1ri', NULL, '66.249.72.64', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1730995122, 1730995122, 0, 'currentLocale|s:2:\"en\";', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('vbb8l2j9ke0n6na5ku0svu92na', NULL, '178.62.216.118', 'Mozilla/5.0 zgrab/0.x', 1731128752, 1731128752, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('vbjq9uu35li95pok04uu0f8sdo', NULL, '115.231.78.3', 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.2623.112 Safari/537.36', 1730962036, 1730962036, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('vbp90jbsrvng1e9iqje5d0vngj', NULL, '66.249.79.129', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1730982891, 1730982891, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('vgu2hp9ca0hq15550a2v4c0hd4', NULL, '206.168.34.35', 'Mozilla/5.0 (compatible; CensysInspect/1.1; +https://about.censys.io/)', 1730944606, 1730944606, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('vh5narqimpkkiht8eo5kdd3pfi', NULL, '103.57.38.205', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', 1731299243, 1731299422, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('vjdirmnsc0p8ebm2r96j6p8cgv', NULL, '115.231.78.3', 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.2623.112 Safari/537.36', 1731078602, 1731078602, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('vk2064pa2s71jv3mqjskd5a0rs', NULL, '142.93.91.93', 'Mozilla/4.0 (compatible; MSIE 9.0; Windows NT 10.0; .NET4.0C; .NET4.0E; .NET CLR 2.0.50727; .NET CLR 3.0.30729; .NET CLR 3.5.30729)', 1731002044, 1731002044, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('vosogmu0chcev1p8u3odujtj75', NULL, '8.216.80.166', 'Custom-AsyncHttpClient', 1731160268, 1731160268, 0, '', '103.146.203.51');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('vq02s8cjqc2govs6hprgo8gmh9', NULL, '199.45.155.75', 'Mozilla/5.0 (compatible; CensysInspect/1.1; +https://about.censys.io/)', 1730944159, 1730944159, 0, '', 'peacee.id');
INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `domain`) VALUES ('vrstcnag6fncc8ffh16rlt0puu', NULL, '66.249.79.129', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.69 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 1730985921, 1730985921, 0, 'currentLocale|s:2:\"en\";csrf|a:2:{s:9:\"timestamp\";i:1730985921;s:5:\"token\";s:32:\"ac9ed49b93cc60936037eef46ff5fdb2\";}', 'peacee.id');
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
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='More data about the site, including localized properties such as its name.';

-- ----------------------------
-- Records of site_settings
-- ----------------------------
BEGIN;
INSERT INTO `site_settings` (`site_setting_id`, `setting_name`, `locale`, `setting_value`) VALUES (1, 'contactEmail', 'en', 'deewahyu@upi.edu');
INSERT INTO `site_settings` (`site_setting_id`, `setting_name`, `locale`, `setting_value`) VALUES (2, 'contactName', 'id', 'Open Journal Systems');
INSERT INTO `site_settings` (`site_setting_id`, `setting_name`, `locale`, `setting_value`) VALUES (3, 'contactName', 'en', 'Open Journal Systems');
INSERT INTO `site_settings` (`site_setting_id`, `setting_name`, `locale`, `setting_value`) VALUES (4, 'compressStatsLogs', '', '0');
INSERT INTO `site_settings` (`site_setting_id`, `setting_name`, `locale`, `setting_value`) VALUES (5, 'enableGeoUsageStats', '', 'country+region+city');
INSERT INTO `site_settings` (`site_setting_id`, `setting_name`, `locale`, `setting_value`) VALUES (6, 'enableInstitutionUsageStats', '', '1');
INSERT INTO `site_settings` (`site_setting_id`, `setting_name`, `locale`, `setting_value`) VALUES (7, 'keepDailyUsageStats', '', '0');
INSERT INTO `site_settings` (`site_setting_id`, `setting_name`, `locale`, `setting_value`) VALUES (8, 'isSiteSushiPlatform', '', '0');
INSERT INTO `site_settings` (`site_setting_id`, `setting_name`, `locale`, `setting_value`) VALUES (9, 'isSushiApiPublic', '', '1');
INSERT INTO `site_settings` (`site_setting_id`, `setting_name`, `locale`, `setting_value`) VALUES (10, 'themePluginPath', '', 'default');
INSERT INTO `site_settings` (`site_setting_id`, `setting_name`, `locale`, `setting_value`) VALUES (11, 'uniqueSiteId', '', '10348200-E808-487E-B1F2-B168B5B4DED4');
INSERT INTO `site_settings` (`site_setting_id`, `setting_name`, `locale`, `setting_value`) VALUES (12, 'enableBulkEmails', '', '[]');
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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Who can access a submission while it is in the editorial workflow. Includes all editorial and author assignments. For reviewers, see review_assignments.';

-- ----------------------------
-- Records of stage_assignments
-- ----------------------------
BEGIN;
INSERT INTO `stage_assignments` (`stage_assignment_id`, `submission_id`, `user_group_id`, `user_id`, `date_assigned`, `recommend_only`, `can_change_metadata`) VALUES (2, 2, 14, 5, '2024-11-02 12:00:11', 0, 0);
INSERT INTO `stage_assignments` (`stage_assignment_id`, `submission_id`, `user_group_id`, `user_id`, `date_assigned`, `recommend_only`, `can_change_metadata`) VALUES (3, 3, 14, 5, '2024-11-02 13:16:52', 0, 0);
INSERT INTO `stage_assignments` (`stage_assignment_id`, `submission_id`, `user_group_id`, `user_id`, `date_assigned`, `recommend_only`, `can_change_metadata`) VALUES (4, 4, 14, 7, '2024-11-07 01:45:20', 0, 0);
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
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Revisions map submission_file entries to files on the data store.';

-- ----------------------------
-- Records of submission_file_revisions
-- ----------------------------
BEGIN;
INSERT INTO `submission_file_revisions` (`revision_id`, `submission_file_id`, `file_id`) VALUES (3, 3, 3);
INSERT INTO `submission_file_revisions` (`revision_id`, `submission_file_id`, `file_id`) VALUES (4, 4, 4);
INSERT INTO `submission_file_revisions` (`revision_id`, `submission_file_id`, `file_id`) VALUES (5, 5, 5);
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
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Localized data about submission files like published metadata.';

-- ----------------------------
-- Records of submission_file_settings
-- ----------------------------
BEGIN;
INSERT INTO `submission_file_settings` (`submission_file_setting_id`, `submission_file_id`, `locale`, `setting_name`, `setting_value`) VALUES (3, 3, 'en', 'name', 'Bukti Absensi Panitia_NEW.docx');
INSERT INTO `submission_file_settings` (`submission_file_setting_id`, `submission_file_id`, `locale`, `setting_name`, `setting_value`) VALUES (4, 4, 'en', 'name', 'Bukti Absensi Panitia_NEW.docx');
INSERT INTO `submission_file_settings` (`submission_file_setting_id`, `submission_file_id`, `locale`, `setting_name`, `setting_value`) VALUES (5, 5, 'en', 'name', '2. Laporan Pembaruan Sistem OJS.pdf');
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
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='All files associated with a submission, such as those uploaded during submission, as revisions, or by copyeditors or layout editors for production.';

-- ----------------------------
-- Records of submission_files
-- ----------------------------
BEGIN;
INSERT INTO `submission_files` (`submission_file_id`, `submission_id`, `file_id`, `source_submission_file_id`, `genre_id`, `file_stage`, `direct_sales_price`, `sales_type`, `viewable`, `created_at`, `updated_at`, `uploader_user_id`, `assoc_type`, `assoc_id`) VALUES (3, 2, 3, NULL, 1, 2, NULL, NULL, NULL, '2024-11-02 11:59:41', '2024-11-02 11:59:46', 5, NULL, NULL);
INSERT INTO `submission_files` (`submission_file_id`, `submission_id`, `file_id`, `source_submission_file_id`, `genre_id`, `file_stage`, `direct_sales_price`, `sales_type`, `viewable`, `created_at`, `updated_at`, `uploader_user_id`, `assoc_type`, `assoc_id`) VALUES (4, 3, 4, NULL, 1, 2, NULL, NULL, NULL, '2024-11-02 13:16:29', '2024-11-02 13:16:32', 5, NULL, NULL);
INSERT INTO `submission_files` (`submission_file_id`, `submission_id`, `file_id`, `source_submission_file_id`, `genre_id`, `file_stage`, `direct_sales_price`, `sales_type`, `viewable`, `created_at`, `updated_at`, `uploader_user_id`, `assoc_type`, `assoc_id`) VALUES (5, 4, 5, NULL, 1, 2, NULL, NULL, NULL, '2024-11-07 01:44:35', '2024-11-07 01:45:04', 7, NULL, NULL);
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Localized data about submissions';

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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='All submissions submitted to the context, including incomplete, declined and unpublished submissions.';

-- ----------------------------
-- Records of submissions
-- ----------------------------
BEGIN;
INSERT INTO `submissions` (`submission_id`, `context_id`, `current_publication_id`, `date_last_activity`, `date_submitted`, `last_modified`, `stage_id`, `locale`, `status`, `submission_progress`, `work_type`) VALUES (2, 1, 2, '2024-11-02 12:00:12', '2024-11-02 12:00:04', '2024-11-02 12:00:04', 1, 'en', 1, '', 0);
INSERT INTO `submissions` (`submission_id`, `context_id`, `current_publication_id`, `date_last_activity`, `date_submitted`, `last_modified`, `stage_id`, `locale`, `status`, `submission_progress`, `work_type`) VALUES (3, 1, 3, '2024-11-02 13:16:54', '2024-11-02 13:16:47', '2024-11-02 13:16:47', 1, 'en', 4, '', 0);
INSERT INTO `submissions` (`submission_id`, `context_id`, `current_publication_id`, `date_last_activity`, `date_submitted`, `last_modified`, `stage_id`, `locale`, `status`, `submission_progress`, `work_type`) VALUES (4, 1, 4, '2024-11-07 01:45:21', '2024-11-07 01:45:16', '2024-11-07 01:45:16', 1, 'en', 1, '', 0);
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
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Temporary files, e.g. where files are kept during an upload process before they are moved somewhere more appropriate.';

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
) ENGINE=InnoDB AUTO_INCREMENT=238 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Temporary stats totals based on visitor log records. Data in this table is provisional. See the metrics_* tables for compiled stats.';

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
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Which stages of the editorial workflow the user_groups can access.';

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
INSERT INTO `user_group_stage` (`user_group_stage_id`, `context_id`, `user_group_id`, `stage_id`) VALUES (32, 1, 13, 5);
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
) ENGINE=InnoDB AUTO_INCREMENT=52 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='More data about users, including localized properties like their name and affiliation.';

-- ----------------------------
-- Records of user_settings
-- ----------------------------
BEGIN;
INSERT INTO `user_settings` (`user_setting_id`, `user_id`, `locale`, `setting_name`, `setting_value`) VALUES (1, 1, 'en', 'familyName', 'PEACEE');
INSERT INTO `user_settings` (`user_setting_id`, `user_id`, `locale`, `setting_name`, `setting_value`) VALUES (2, 1, 'en', 'givenName', 'Editorial Team');
INSERT INTO `user_settings` (`user_setting_id`, `user_id`, `locale`, `setting_name`, `setting_value`) VALUES (13, 1, 'en', 'affiliation', '');
INSERT INTO `user_settings` (`user_setting_id`, `user_id`, `locale`, `setting_name`, `setting_value`) VALUES (14, 1, 'en', 'biography', '');
INSERT INTO `user_settings` (`user_setting_id`, `user_id`, `locale`, `setting_name`, `setting_value`) VALUES (15, 1, '', 'orcid', '');
INSERT INTO `user_settings` (`user_setting_id`, `user_id`, `locale`, `setting_name`, `setting_value`) VALUES (16, 1, 'en', 'preferredPublicName', '');
INSERT INTO `user_settings` (`user_setting_id`, `user_id`, `locale`, `setting_name`, `setting_value`) VALUES (17, 1, 'en', 'signature', '');
INSERT INTO `user_settings` (`user_setting_id`, `user_id`, `locale`, `setting_name`, `setting_value`) VALUES (18, 4, 'en', 'affiliation', '');
INSERT INTO `user_settings` (`user_setting_id`, `user_id`, `locale`, `setting_name`, `setting_value`) VALUES (19, 4, 'en', 'biography', '');
INSERT INTO `user_settings` (`user_setting_id`, `user_id`, `locale`, `setting_name`, `setting_value`) VALUES (20, 4, 'en', 'familyName', 'Mandasari');
INSERT INTO `user_settings` (`user_setting_id`, `user_id`, `locale`, `setting_name`, `setting_value`) VALUES (21, 4, 'en', 'givenName', 'R Deasy');
INSERT INTO `user_settings` (`user_setting_id`, `user_id`, `locale`, `setting_name`, `setting_value`) VALUES (22, 4, '', 'orcid', '');
INSERT INTO `user_settings` (`user_setting_id`, `user_id`, `locale`, `setting_name`, `setting_value`) VALUES (23, 4, 'en', 'preferredPublicName', 'R Deasy Mandasari');
INSERT INTO `user_settings` (`user_setting_id`, `user_id`, `locale`, `setting_name`, `setting_value`) VALUES (24, 4, 'en', 'signature', '');
INSERT INTO `user_settings` (`user_setting_id`, `user_id`, `locale`, `setting_name`, `setting_value`) VALUES (25, 5, 'en', 'affiliation', 'BRIN');
INSERT INTO `user_settings` (`user_setting_id`, `user_id`, `locale`, `setting_name`, `setting_value`) VALUES (26, 5, 'en', 'familyName', '');
INSERT INTO `user_settings` (`user_setting_id`, `user_id`, `locale`, `setting_name`, `setting_value`) VALUES (27, 5, 'en', 'givenName', 'Aris');
INSERT INTO `user_settings` (`user_setting_id`, `user_id`, `locale`, `setting_name`, `setting_value`) VALUES (28, 5, 'en', 'biography', '');
INSERT INTO `user_settings` (`user_setting_id`, `user_id`, `locale`, `setting_name`, `setting_value`) VALUES (29, 5, '', 'orcid', '');
INSERT INTO `user_settings` (`user_setting_id`, `user_id`, `locale`, `setting_name`, `setting_value`) VALUES (30, 5, 'en', 'preferredPublicName', '');
INSERT INTO `user_settings` (`user_setting_id`, `user_id`, `locale`, `setting_name`, `setting_value`) VALUES (31, 5, 'en', 'signature', '');
INSERT INTO `user_settings` (`user_setting_id`, `user_id`, `locale`, `setting_name`, `setting_value`) VALUES (32, 6, 'en', 'affiliation', 'SMM');
INSERT INTO `user_settings` (`user_setting_id`, `user_id`, `locale`, `setting_name`, `setting_value`) VALUES (33, 6, 'en', 'familyName', '');
INSERT INTO `user_settings` (`user_setting_id`, `user_id`, `locale`, `setting_name`, `setting_value`) VALUES (34, 6, 'en', 'givenName', 'Athariz');
INSERT INTO `user_settings` (`user_setting_id`, `user_id`, `locale`, `setting_name`, `setting_value`) VALUES (35, 7, 'en', 'affiliation', 'UPI');
INSERT INTO `user_settings` (`user_setting_id`, `user_id`, `locale`, `setting_name`, `setting_value`) VALUES (36, 7, 'en', 'familyName', 'Raykarashy');
INSERT INTO `user_settings` (`user_setting_id`, `user_id`, `locale`, `setting_name`, `setting_value`) VALUES (37, 7, 'en', 'givenName', 'Athariz');
INSERT INTO `user_settings` (`user_setting_id`, `user_id`, `locale`, `setting_name`, `setting_value`) VALUES (38, 8, 'en', 'affiliation', '');
INSERT INTO `user_settings` (`user_setting_id`, `user_id`, `locale`, `setting_name`, `setting_value`) VALUES (39, 8, 'en', 'biography', '');
INSERT INTO `user_settings` (`user_setting_id`, `user_id`, `locale`, `setting_name`, `setting_value`) VALUES (40, 8, 'en', 'familyName', 'Wahyudin');
INSERT INTO `user_settings` (`user_setting_id`, `user_id`, `locale`, `setting_name`, `setting_value`) VALUES (41, 8, 'en', 'givenName', 'Didin');
INSERT INTO `user_settings` (`user_setting_id`, `user_id`, `locale`, `setting_name`, `setting_value`) VALUES (42, 8, '', 'orcid', '');
INSERT INTO `user_settings` (`user_setting_id`, `user_id`, `locale`, `setting_name`, `setting_value`) VALUES (43, 8, 'en', 'preferredPublicName', 'Didin Wahyudin');
INSERT INTO `user_settings` (`user_setting_id`, `user_id`, `locale`, `setting_name`, `setting_value`) VALUES (44, 8, 'en', 'signature', '');
INSERT INTO `user_settings` (`user_setting_id`, `user_id`, `locale`, `setting_name`, `setting_value`) VALUES (45, 9, 'en', 'affiliation', '');
INSERT INTO `user_settings` (`user_setting_id`, `user_id`, `locale`, `setting_name`, `setting_value`) VALUES (46, 9, 'en', 'biography', '');
INSERT INTO `user_settings` (`user_setting_id`, `user_id`, `locale`, `setting_name`, `setting_value`) VALUES (47, 9, 'en', 'familyName', 'Wahyudin');
INSERT INTO `user_settings` (`user_setting_id`, `user_id`, `locale`, `setting_name`, `setting_value`) VALUES (48, 9, 'en', 'givenName', 'Didin ');
INSERT INTO `user_settings` (`user_setting_id`, `user_id`, `locale`, `setting_name`, `setting_value`) VALUES (49, 9, '', 'orcid', '');
INSERT INTO `user_settings` (`user_setting_id`, `user_id`, `locale`, `setting_name`, `setting_value`) VALUES (50, 9, 'en', 'preferredPublicName', 'dwahyudin');
INSERT INTO `user_settings` (`user_setting_id`, `user_id`, `locale`, `setting_name`, `setting_value`) VALUES (51, 9, 'en', 'signature', '');
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
) ENGINE=InnoDB AUTO_INCREMENT=80 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Maps users to their assigned user_groups.';

-- ----------------------------
-- Records of user_user_groups
-- ----------------------------
BEGIN;
INSERT INTO `user_user_groups` (`user_user_group_id`, `user_group_id`, `user_id`) VALUES (1, 1, 1);
INSERT INTO `user_user_groups` (`user_user_group_id`, `user_group_id`, `user_id`) VALUES (64, 2, 1);
INSERT INTO `user_user_groups` (`user_user_group_id`, `user_group_id`, `user_id`) VALUES (41, 2, 4);
INSERT INTO `user_user_groups` (`user_user_group_id`, `user_group_id`, `user_id`) VALUES (65, 3, 1);
INSERT INTO `user_user_groups` (`user_user_group_id`, `user_group_id`, `user_id`) VALUES (42, 3, 4);
INSERT INTO `user_user_groups` (`user_user_group_id`, `user_group_id`, `user_id`) VALUES (66, 4, 1);
INSERT INTO `user_user_groups` (`user_user_group_id`, `user_group_id`, `user_id`) VALUES (43, 4, 4);
INSERT INTO `user_user_groups` (`user_user_group_id`, `user_group_id`, `user_id`) VALUES (67, 5, 1);
INSERT INTO `user_user_groups` (`user_user_group_id`, `user_group_id`, `user_id`) VALUES (44, 5, 4);
INSERT INTO `user_user_groups` (`user_user_group_id`, `user_group_id`, `user_id`) VALUES (68, 6, 1);
INSERT INTO `user_user_groups` (`user_user_group_id`, `user_group_id`, `user_id`) VALUES (45, 6, 4);
INSERT INTO `user_user_groups` (`user_user_group_id`, `user_group_id`, `user_id`) VALUES (69, 7, 1);
INSERT INTO `user_user_groups` (`user_user_group_id`, `user_group_id`, `user_id`) VALUES (46, 7, 4);
INSERT INTO `user_user_groups` (`user_user_group_id`, `user_group_id`, `user_id`) VALUES (70, 8, 1);
INSERT INTO `user_user_groups` (`user_user_group_id`, `user_group_id`, `user_id`) VALUES (47, 8, 4);
INSERT INTO `user_user_groups` (`user_user_group_id`, `user_group_id`, `user_id`) VALUES (71, 9, 1);
INSERT INTO `user_user_groups` (`user_user_group_id`, `user_group_id`, `user_id`) VALUES (48, 9, 4);
INSERT INTO `user_user_groups` (`user_user_group_id`, `user_group_id`, `user_id`) VALUES (72, 10, 1);
INSERT INTO `user_user_groups` (`user_user_group_id`, `user_group_id`, `user_id`) VALUES (49, 10, 4);
INSERT INTO `user_user_groups` (`user_user_group_id`, `user_group_id`, `user_id`) VALUES (73, 11, 1);
INSERT INTO `user_user_groups` (`user_user_group_id`, `user_group_id`, `user_id`) VALUES (50, 11, 4);
INSERT INTO `user_user_groups` (`user_user_group_id`, `user_group_id`, `user_id`) VALUES (74, 12, 1);
INSERT INTO `user_user_groups` (`user_user_group_id`, `user_group_id`, `user_id`) VALUES (51, 12, 4);
INSERT INTO `user_user_groups` (`user_user_group_id`, `user_group_id`, `user_id`) VALUES (75, 13, 1);
INSERT INTO `user_user_groups` (`user_user_group_id`, `user_group_id`, `user_id`) VALUES (52, 13, 4);
INSERT INTO `user_user_groups` (`user_user_group_id`, `user_group_id`, `user_id`) VALUES (58, 14, 5);
INSERT INTO `user_user_groups` (`user_user_group_id`, `user_group_id`, `user_id`) VALUES (63, 14, 7);
INSERT INTO `user_user_groups` (`user_user_group_id`, `user_group_id`, `user_id`) VALUES (78, 14, 9);
INSERT INTO `user_user_groups` (`user_user_group_id`, `user_group_id`, `user_id`) VALUES (76, 15, 1);
INSERT INTO `user_user_groups` (`user_user_group_id`, `user_group_id`, `user_id`) VALUES (53, 15, 4);
INSERT INTO `user_user_groups` (`user_user_group_id`, `user_group_id`, `user_id`) VALUES (54, 16, 4);
INSERT INTO `user_user_groups` (`user_user_group_id`, `user_group_id`, `user_id`) VALUES (61, 16, 5);
INSERT INTO `user_user_groups` (`user_user_group_id`, `user_group_id`, `user_id`) VALUES (79, 16, 9);
INSERT INTO `user_user_groups` (`user_user_group_id`, `user_group_id`, `user_id`) VALUES (55, 17, 4);
INSERT INTO `user_user_groups` (`user_user_group_id`, `user_group_id`, `user_id`) VALUES (59, 17, 5);
INSERT INTO `user_user_groups` (`user_user_group_id`, `user_group_id`, `user_id`) VALUES (60, 17, 6);
INSERT INTO `user_user_groups` (`user_user_group_id`, `user_group_id`, `user_id`) VALUES (62, 17, 7);
INSERT INTO `user_user_groups` (`user_user_group_id`, `user_group_id`, `user_id`) VALUES (77, 18, 1);
INSERT INTO `user_user_groups` (`user_user_group_id`, `user_group_id`, `user_id`) VALUES (56, 18, 4);
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
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='All registered users, including authentication data and profile data.';

-- ----------------------------
-- Records of users
-- ----------------------------
BEGIN;
INSERT INTO `users` (`user_id`, `username`, `password`, `email`, `url`, `phone`, `mailing_address`, `billing_address`, `country`, `locales`, `gossip`, `date_last_email`, `date_registered`, `date_validated`, `date_last_login`, `must_change_password`, `auth_id`, `auth_str`, `disabled`, `disabled_reason`, `inline_help`) VALUES (1, 'peacee', '$2y$10$xcq45yAS59tQXmSSQCaS8uLt3C9Y.FlKEkYNLtpKSoOGD6deqOE6K', 'peacee@upi.edu', '', '', '', NULL, '', '[]', NULL, NULL, '2024-10-24 22:17:29', NULL, '2024-11-07 02:00:14', 0, NULL, NULL, 0, NULL, 1);
INSERT INTO `users` (`user_id`, `username`, `password`, `email`, `url`, `phone`, `mailing_address`, `billing_address`, `country`, `locales`, `gossip`, `date_last_email`, `date_registered`, `date_validated`, `date_last_login`, `must_change_password`, `auth_id`, `auth_str`, `disabled`, `disabled_reason`, `inline_help`) VALUES (4, 'deasy', '$2y$10$OWXmDEXozwaTITUXbkbkXOQoTKkLNvcxBiO4fSVMobOGZ1uD1BH1K', 'deasy@upi.edu', '', '087808878698', '', NULL, 'ID', '[]', '', NULL, '2024-11-01 14:25:11', NULL, NULL, 0, NULL, NULL, 0, NULL, 1);
INSERT INTO `users` (`user_id`, `username`, `password`, `email`, `url`, `phone`, `mailing_address`, `billing_address`, `country`, `locales`, `gossip`, `date_last_email`, `date_registered`, `date_validated`, `date_last_login`, `must_change_password`, `auth_id`, `auth_str`, `disabled`, `disabled_reason`, `inline_help`) VALUES (5, 'darisman', '$2y$10$H0Nye8FtE7gJwVtGaFvhWO5Zl5tliR1yXLhnLtd0UHzuTMQ7Azp/i', 'darisman08@gmail.com', '', '', '', NULL, 'ID', '[]', NULL, NULL, '2024-11-01 15:13:03', NULL, '2024-11-02 13:47:33', 0, NULL, NULL, 0, NULL, 1);
INSERT INTO `users` (`user_id`, `username`, `password`, `email`, `url`, `phone`, `mailing_address`, `billing_address`, `country`, `locales`, `gossip`, `date_last_email`, `date_registered`, `date_validated`, `date_last_login`, `must_change_password`, `auth_id`, `auth_str`, `disabled`, `disabled_reason`, `inline_help`) VALUES (6, 'arash', '$2y$10$vZA08itUNE386oNR8Bd9he4HVZ6a0kreaK1SOuaXobLQ6T11.DkRm', 'araykarashy@gmail.com', NULL, NULL, NULL, NULL, 'ID', '[]', NULL, NULL, '2024-11-02 09:27:42', NULL, '2024-11-02 09:27:42', NULL, NULL, NULL, 0, NULL, 1);
INSERT INTO `users` (`user_id`, `username`, `password`, `email`, `url`, `phone`, `mailing_address`, `billing_address`, `country`, `locales`, `gossip`, `date_last_email`, `date_registered`, `date_validated`, `date_last_login`, `must_change_password`, `auth_id`, `auth_str`, `disabled`, `disabled_reason`, `inline_help`) VALUES (7, 'deasy-rde', '$2y$10$YOS3y8ty9ldkSn859zBhGuegXYuB1b1nOJ8BSEdOJPy5lrq9hhqYG', 'deasy.rde@bsi.ac.id', NULL, NULL, NULL, NULL, 'ID', '[]', NULL, NULL, '2024-11-07 01:40:38', NULL, '2024-11-07 01:43:53', NULL, NULL, NULL, 0, NULL, 1);
INSERT INTO `users` (`user_id`, `username`, `password`, `email`, `url`, `phone`, `mailing_address`, `billing_address`, `country`, `locales`, `gossip`, `date_last_email`, `date_registered`, `date_validated`, `date_last_login`, `must_change_password`, `auth_id`, `auth_str`, `disabled`, `disabled_reason`, `inline_help`) VALUES (8, 'deewahyu', '$2y$10$CX24wOKFwQxlJDN2K8GS8etw1SfLIgxp5Y1QWJGt/xDhegbyqNNaW', 'deewahyu@upi.edu', '', '', '', NULL, 'ID', '[\"en\"]', NULL, NULL, '2024-11-07 05:05:01', NULL, NULL, 1, NULL, NULL, 0, NULL, 1);
INSERT INTO `users` (`user_id`, `username`, `password`, `email`, `url`, `phone`, `mailing_address`, `billing_address`, `country`, `locales`, `gossip`, `date_last_email`, `date_registered`, `date_validated`, `date_last_login`, `must_change_password`, `auth_id`, `auth_str`, `disabled`, `disabled_reason`, `inline_help`) VALUES (9, 'dwahyudin', '$2y$10$PK/PGUs5U0j1qZmBB.WEyONhcmRNwQKFI3x8qqubv31JhwYwLPQ4m', 'deewahyu@gmail.com', '', '', '', NULL, 'ID', '[]', NULL, NULL, '2024-11-07 05:07:08', NULL, NULL, 0, NULL, NULL, 0, NULL, 1);
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
) ENGINE=InnoDB AUTO_INCREMENT=52 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Describes the installation and upgrade version history for the application and all installed plugins.';

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
INSERT INTO `versions` (`version_id`, `major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES (46, 2, 0, 4, 0, '2024-10-26 11:25:31', 1, 'plugins.generic', 'backup', 'BackupPlugin', 1, 0);
INSERT INTO `versions` (`version_id`, `major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES (47, 1, 0, 4, 1, '2024-10-26 11:25:31', 1, 'plugins.generic', 'customHeader', 'CustomHeaderPlugin', 1, 0);
INSERT INTO `versions` (`version_id`, `major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES (48, 1, 0, 4, 0, '2024-10-26 11:30:42', 1, 'plugins.themes', 'defaultManuscript', 'DefaultManuscriptChildThemePlugin', 1, 0);
INSERT INTO `versions` (`version_id`, `major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES (49, 0, 0, 0, 6, '2024-10-26 13:45:18', 1, 'plugins.generic', 'reviewReminder', '', 0, 0);
INSERT INTO `versions` (`version_id`, `major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES (50, 3, 0, 0, 0, '2024-11-02 11:53:11', 0, 'plugins.generic', 'pln', 'PlnPlugin', 1, 0);
INSERT INTO `versions` (`version_id`, `major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES (51, 3, 4, 0, 0, '2024-11-05 13:13:40', 1, 'plugins.themes', 'bootstrap3', 'BootstrapThreeThemePlugin', 1, 0);
COMMIT;

SET FOREIGN_KEY_CHECKS = 1;
