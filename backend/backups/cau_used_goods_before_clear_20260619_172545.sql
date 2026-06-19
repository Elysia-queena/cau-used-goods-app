-- MySQL dump 10.13  Distrib 8.4.8, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: cau_used_goods
-- ------------------------------------------------------
-- Server version	8.4.8

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `admin_logs`
--

DROP TABLE IF EXISTS `admin_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admin_logs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '日志ID',
  `admin_id` bigint unsigned NOT NULL COMMENT '管理员用户ID',
  `operation_type` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '操作类型',
  `target_type` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'USER / PRODUCT / ORDER / NOTICE / WORD / CATEGORY / REPORT / APPEAL',
  `target_id` bigint unsigned NOT NULL COMMENT '操作对象ID',
  `description` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '操作说明',
  `ip_address` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '操作IP',
  `related_type` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '操作依据类型：REPORT / APPEAL',
  `related_id` bigint unsigned DEFAULT NULL COMMENT '操作依据ID',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '操作时间',
  PRIMARY KEY (`id`),
  KEY `idx_admin_logs_admin_time` (`admin_id`,`create_time`),
  KEY `idx_admin_logs_target` (`target_type`,`target_id`),
  KEY `idx_admin_logs_operation` (`operation_type`),
  KEY `idx_admin_logs_related` (`related_type`,`related_id`),
  CONSTRAINT `fk_admin_logs_admin` FOREIGN KEY (`admin_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='管理员操作日志表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin_logs`
--

LOCK TABLES `admin_logs` WRITE;
/*!40000 ALTER TABLE `admin_logs` DISABLE KEYS */;
INSERT INTO `admin_logs` VALUES (1,5,'STUDENT_VERIFY_APPROVE','USER',1,'学生认证审核通过',NULL,NULL,NULL,'2026-06-16 22:09:40'),(2,5,'CREATE_WORD','WORD',1,'create sensitive word: 毒品','127.0.0.1',NULL,NULL,'2026-06-16 22:10:11'),(3,5,'MARK_REPORT_PROCESSING','REPORT',1,'mark report as PROCESSING','127.0.0.1',NULL,NULL,'2026-06-19 17:02:13'),(4,5,'UPDATE_PRODUCT_STATUS','PRODUCT',2,'update product status to OFF_SHELF: 管理员下架商品','127.0.0.1','REPORT',1,'2026-06-19 17:02:30'),(5,5,'UPDATE_PRODUCT_STATUS','PRODUCT',2,'update product status to OFF_SHELF: 管理员下架商品','127.0.0.1','REPORT',1,'2026-06-19 17:02:36');
/*!40000 ALTER TABLE `admin_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ai_generation_logs`
--

DROP TABLE IF EXISTS `ai_generation_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ai_generation_logs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT 'AI生成记录ID',
  `user_id` bigint unsigned NOT NULL COMMENT '调用AI功能的用户ID',
  `product_id` bigint unsigned DEFAULT NULL COMMENT '关联商品ID',
  `generation_type` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'TITLE_OPTIMIZE / DESCRIPTION_GENERATE',
  `input_text` text COLLATE utf8mb4_unicode_ci COMMENT '用户输入内容',
  `output_text` text COLLATE utf8mb4_unicode_ci COMMENT 'AI生成内容',
  `status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'SUCCESS' COMMENT 'SUCCESS / FAILED',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '生成时间',
  PRIMARY KEY (`id`),
  KEY `idx_ai_generation_logs_user_time` (`user_id`,`create_time`),
  KEY `idx_ai_generation_logs_product` (`product_id`),
  KEY `idx_ai_generation_logs_type_status` (`generation_type`,`status`),
  CONSTRAINT `fk_ai_generation_logs_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`),
  CONSTRAINT `fk_ai_generation_logs_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='AI生成记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ai_generation_logs`
--

LOCK TABLES `ai_generation_logs` WRITE;
/*!40000 ALTER TABLE `ai_generation_logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `ai_generation_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `announcements`
--

DROP TABLE IF EXISTS `announcements`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `announcements` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '公告ID',
  `title` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '公告标题',
  `content` text COLLATE utf8mb4_unicode_ci COMMENT '公告内容',
  `cover_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '封面图或轮播图地址',
  `status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'DRAFT' COMMENT 'DRAFT / PUBLISHED / OFFLINE',
  `publish_time` datetime DEFAULT NULL COMMENT '发布时间',
  `create_by` bigint unsigned NOT NULL COMMENT '创建管理员ID',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_announcements_status_publish` (`status`,`publish_time`),
  KEY `idx_announcements_create_by` (`create_by`),
  CONSTRAINT `fk_announcements_create_by` FOREIGN KEY (`create_by`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='公告表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `announcements`
--

LOCK TABLES `announcements` WRITE;
/*!40000 ALTER TABLE `announcements` DISABLE KEYS */;
/*!40000 ALTER TABLE `announcements` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `appeal_images`
--

DROP TABLE IF EXISTS `appeal_images`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `appeal_images` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '申诉凭证图片ID',
  `appeal_id` bigint unsigned NOT NULL COMMENT '申诉ID',
  `image_url` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '凭证图片访问路径',
  `sort_order` int NOT NULL DEFAULT '0' COMMENT '图片排序',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '上传时间',
  PRIMARY KEY (`id`),
  KEY `idx_appeal_images_appeal_sort` (`appeal_id`,`sort_order`),
  CONSTRAINT `fk_appeal_images_appeal` FOREIGN KEY (`appeal_id`) REFERENCES `appeals` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='申诉凭证图片表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `appeal_images`
--

LOCK TABLES `appeal_images` WRITE;
/*!40000 ALTER TABLE `appeal_images` DISABLE KEYS */;
/*!40000 ALTER TABLE `appeal_images` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `appeals`
--

DROP TABLE IF EXISTS `appeals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `appeals` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '申诉ID',
  `appellant_id` bigint unsigned NOT NULL COMMENT '申诉人用户ID',
  `target_type` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '申诉对象类型：PRODUCT / USER / ORDER / REPORT',
  `target_id` bigint unsigned NOT NULL COMMENT '申诉对象ID',
  `reason` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '申诉理由',
  `status` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PENDING' COMMENT 'PENDING / PROCESSING / APPROVED / REJECTED / CLOSED',
  `handle_result` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '管理员处理结果',
  `handler_id` bigint unsigned DEFAULT NULL COMMENT '处理管理员ID',
  `handle_time` datetime DEFAULT NULL COMMENT '处理时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_appeals_appellant_status_time` (`appellant_id`,`status`,`create_time`),
  KEY `idx_appeals_target` (`target_type`,`target_id`),
  KEY `idx_appeals_status_time` (`status`,`create_time`),
  KEY `idx_appeals_handler` (`handler_id`),
  CONSTRAINT `fk_appeals_appellant` FOREIGN KEY (`appellant_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_appeals_handler` FOREIGN KEY (`handler_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='申诉表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `appeals`
--

LOCK TABLES `appeals` WRITE;
/*!40000 ALTER TABLE `appeals` DISABLE KEYS */;
/*!40000 ALTER TABLE `appeals` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `browse_history`
--

DROP TABLE IF EXISTS `browse_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `browse_history` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '浏览记录ID',
  `user_id` bigint unsigned NOT NULL COMMENT '浏览用户ID',
  `product_id` bigint unsigned NOT NULL COMMENT '被浏览商品ID',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '浏览时间',
  PRIMARY KEY (`id`),
  KEY `idx_browse_history_user_time` (`user_id`,`create_time`),
  KEY `idx_browse_history_product` (`product_id`),
  CONSTRAINT `fk_browse_history_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`),
  CONSTRAINT `fk_browse_history_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='浏览历史表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `browse_history`
--

LOCK TABLES `browse_history` WRITE;
/*!40000 ALTER TABLE `browse_history` DISABLE KEYS */;
/*!40000 ALTER TABLE `browse_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categories` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '分类ID',
  `name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '分类名称',
  `parent_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT '父分类ID',
  `sort_order` int NOT NULL DEFAULT '0' COMMENT '排序值',
  `status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'ENABLED' COMMENT 'ENABLED / DISABLED',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_categories_parent_name` (`parent_id`,`name`),
  KEY `idx_categories_status_sort` (`status`,`sort_order`)
) ENGINE=InnoDB AUTO_INCREMENT=73 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商品分类表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categories`
--

LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
INSERT INTO `categories` VALUES (1,'教材资料',0,10,'ENABLED','2026-06-16 17:15:11','2026-06-19 14:35:44'),(2,'电子产品',0,20,'ENABLED','2026-06-16 17:15:11','2026-06-19 14:35:44'),(3,'生活用品',0,30,'ENABLED','2026-06-16 17:15:11','2026-06-19 14:35:44'),(4,'服饰鞋包',0,40,'ENABLED','2026-06-16 17:15:11','2026-06-19 14:35:44'),(5,'运动户外',0,50,'ENABLED','2026-06-16 17:15:11','2026-06-19 14:35:44'),(6,'其他',0,999,'ENABLED','2026-06-16 17:15:11','2026-06-19 14:35:44'),(13,'公共课教材',1,101,'ENABLED','2026-06-19 14:35:44','2026-06-19 14:35:44'),(14,'专业课教材',1,102,'ENABLED','2026-06-19 14:35:44','2026-06-19 14:35:44'),(15,'考研资料',1,103,'ENABLED','2026-06-19 14:35:44','2026-06-19 14:35:44'),(16,'考证资料',1,104,'ENABLED','2026-06-19 14:35:44','2026-06-19 14:35:44'),(17,'外语学习',1,105,'ENABLED','2026-06-19 14:35:44','2026-06-19 14:35:44'),(18,'课程笔记',1,106,'ENABLED','2026-06-19 14:35:44','2026-06-19 14:35:44'),(19,'实验报告资料',1,107,'ENABLED','2026-06-19 14:35:44','2026-06-19 14:35:44'),(20,'课外读物',1,108,'ENABLED','2026-06-19 14:35:44','2026-06-19 14:35:44'),(21,'教辅习题',1,109,'ENABLED','2026-06-19 14:35:44','2026-06-19 14:35:44'),(22,'打印复印资料',1,110,'ENABLED','2026-06-19 14:35:44','2026-06-19 14:35:44'),(23,'手机通讯',2,201,'ENABLED','2026-06-19 14:35:44','2026-06-19 14:35:44'),(24,'电脑笔记本',2,202,'ENABLED','2026-06-19 14:35:44','2026-06-19 14:35:44'),(25,'平板设备',2,203,'ENABLED','2026-06-19 14:35:44','2026-06-19 14:35:44'),(26,'耳机音响',2,204,'ENABLED','2026-06-19 14:35:44','2026-06-19 14:35:44'),(27,'相机摄影',2,205,'ENABLED','2026-06-19 14:35:44','2026-06-19 14:35:44'),(28,'键盘鼠标',2,206,'ENABLED','2026-06-19 14:35:44','2026-06-19 14:35:44'),(29,'充电器线材',2,207,'ENABLED','2026-06-19 14:35:44','2026-06-19 14:35:44'),(30,'存储设备',2,208,'ENABLED','2026-06-19 14:35:44','2026-06-19 14:35:44'),(31,'智能穿戴',2,209,'ENABLED','2026-06-19 14:35:44','2026-06-19 14:35:44'),(32,'数码配件',2,210,'ENABLED','2026-06-19 14:35:44','2026-06-19 14:35:44'),(33,'宿舍用品',3,301,'ENABLED','2026-06-19 14:35:45','2026-06-19 14:35:45'),(34,'学习文具',3,302,'ENABLED','2026-06-19 14:35:45','2026-06-19 14:35:45'),(35,'收纳整理',3,303,'ENABLED','2026-06-19 14:35:45','2026-06-19 14:35:45'),(36,'台灯照明',3,304,'ENABLED','2026-06-19 14:35:45','2026-06-19 14:35:45'),(37,'小家电',3,305,'ENABLED','2026-06-19 14:35:45','2026-06-19 14:35:45'),(38,'厨具餐具',3,306,'ENABLED','2026-06-19 14:35:45','2026-06-19 14:35:45'),(39,'清洁用品',3,307,'ENABLED','2026-06-19 14:35:45','2026-06-19 14:35:45'),(40,'床上用品',3,308,'ENABLED','2026-06-19 14:35:45','2026-06-19 14:35:45'),(41,'美妆个护',3,309,'ENABLED','2026-06-19 14:35:45','2026-06-19 14:35:45'),(42,'日用杂物',3,310,'ENABLED','2026-06-19 14:35:45','2026-06-19 14:35:45'),(43,'男装',4,401,'ENABLED','2026-06-19 14:35:45','2026-06-19 14:35:45'),(44,'女装',4,402,'ENABLED','2026-06-19 14:35:45','2026-06-19 14:35:45'),(45,'鞋靴',4,403,'ENABLED','2026-06-19 14:35:45','2026-06-19 14:35:45'),(46,'箱包',4,404,'ENABLED','2026-06-19 14:35:45','2026-06-19 14:35:45'),(47,'帽子围巾',4,405,'ENABLED','2026-06-19 14:35:45','2026-06-19 14:35:45'),(48,'手表饰品',4,406,'ENABLED','2026-06-19 14:35:45','2026-06-19 14:35:45'),(49,'正装礼服',4,407,'ENABLED','2026-06-19 14:35:45','2026-06-19 14:35:45'),(50,'运动服饰',4,408,'ENABLED','2026-06-19 14:35:45','2026-06-19 14:35:45'),(51,'校服院服',4,409,'ENABLED','2026-06-19 14:35:45','2026-06-19 14:35:45'),(52,'其他配饰',4,410,'ENABLED','2026-06-19 14:35:45','2026-06-19 14:35:45'),(53,'球类用品',5,501,'ENABLED','2026-06-19 14:35:45','2026-06-19 14:35:45'),(54,'健身器材',5,502,'ENABLED','2026-06-19 14:35:45','2026-06-19 14:35:45'),(55,'户外装备',5,503,'ENABLED','2026-06-19 14:35:45','2026-06-19 14:35:45'),(56,'骑行装备',5,504,'ENABLED','2026-06-19 14:35:45','2026-06-19 14:35:45'),(57,'运动护具',5,505,'ENABLED','2026-06-19 14:35:45','2026-06-19 14:35:45'),(58,'瑜伽舞蹈',5,506,'ENABLED','2026-06-19 14:35:45','2026-06-19 14:35:45'),(59,'游泳用品',5,507,'ENABLED','2026-06-19 14:35:45','2026-06-19 14:35:45'),(60,'校园代步',5,508,'ENABLED','2026-06-19 14:35:45','2026-06-19 14:35:45'),(61,'运动鞋服',5,509,'ENABLED','2026-06-19 14:35:45','2026-06-19 14:35:45'),(62,'露营旅行',5,510,'ENABLED','2026-06-19 14:35:45','2026-06-19 14:35:45'),(63,'票券卡券',6,901,'ENABLED','2026-06-19 14:35:46','2026-06-19 14:35:46'),(64,'虚拟资料',6,902,'ENABLED','2026-06-19 14:35:46','2026-06-19 14:35:46'),(65,'乐器器材',6,903,'ENABLED','2026-06-19 14:35:46','2026-06-19 14:35:46'),(66,'宠物用品',6,904,'ENABLED','2026-06-19 14:35:46','2026-06-19 14:35:46'),(67,'手工艺品',6,905,'ENABLED','2026-06-19 14:35:46','2026-06-19 14:35:46'),(68,'模型玩具',6,906,'ENABLED','2026-06-19 14:35:46','2026-06-19 14:35:46'),(69,'活动周边',6,907,'ENABLED','2026-06-19 14:35:46','2026-06-19 14:35:46'),(70,'租借服务',6,908,'ENABLED','2026-06-19 14:35:46','2026-06-19 14:35:46'),(71,'闲置赠送',6,909,'ENABLED','2026-06-19 14:35:46','2026-06-19 14:35:46'),(72,'其他闲置',6,999,'ENABLED','2026-06-19 14:35:46','2026-06-19 14:35:46');
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `chat_conversations`
--

DROP TABLE IF EXISTS `chat_conversations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chat_conversations` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '聊天会话ID',
  `product_id` bigint unsigned NOT NULL COMMENT '关联商品ID',
  `buyer_id` bigint unsigned NOT NULL COMMENT '买家用户ID',
  `seller_id` bigint unsigned NOT NULL COMMENT '卖家用户ID',
  `last_message_id` bigint unsigned DEFAULT NULL COMMENT '最后一条消息ID',
  `last_message_content` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '最后一条消息内容',
  `last_message_time` datetime DEFAULT NULL COMMENT '最后一条消息时间',
  `buyer_unread_count` int NOT NULL DEFAULT '0' COMMENT '买家未读数',
  `seller_unread_count` int NOT NULL DEFAULT '0' COMMENT '卖家未读数',
  `buyer_hidden_at` datetime DEFAULT NULL COMMENT '买家隐藏会话时间，NULL表示买家聊天列表可见',
  `seller_hidden_at` datetime DEFAULT NULL COMMENT '卖家隐藏会话时间，NULL表示卖家聊天列表可见',
  `status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'ACTIVE' COMMENT 'ACTIVE / CLOSED',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_chat_product_buyer_seller` (`product_id`,`buyer_id`,`seller_id`),
  KEY `idx_chat_buyer_time` (`buyer_id`,`last_message_time`),
  KEY `idx_chat_seller_time` (`seller_id`,`last_message_time`),
  CONSTRAINT `fk_chat_conversations_buyer` FOREIGN KEY (`buyer_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_chat_conversations_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`),
  CONSTRAINT `fk_chat_conversations_seller` FOREIGN KEY (`seller_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='聊天会话表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chat_conversations`
--

LOCK TABLES `chat_conversations` WRITE;
/*!40000 ALTER TABLE `chat_conversations` DISABLE KEYS */;
INSERT INTO `chat_conversations` VALUES (1,1,4,3,6,'你好','2026-06-16 21:43:17',0,2,NULL,NULL,'ACTIVE','2026-06-16 21:28:11','2026-06-16 22:15:11');
/*!40000 ALTER TABLE `chat_conversations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `chat_messages`
--

DROP TABLE IF EXISTS `chat_messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chat_messages` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '聊天消息ID',
  `conversation_id` bigint unsigned NOT NULL COMMENT '聊天会话ID',
  `sender_id` bigint unsigned NOT NULL COMMENT '发送人ID',
  `receiver_id` bigint unsigned NOT NULL COMMENT '接收人ID',
  `content` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '消息内容',
  `message_type` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'TEXT' COMMENT 'TEXT',
  `read_status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'UNREAD' COMMENT 'UNREAD / READ',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '发送时间',
  PRIMARY KEY (`id`),
  KEY `idx_chat_messages_conversation_time` (`conversation_id`,`create_time`),
  KEY `idx_chat_messages_receiver_read` (`receiver_id`,`read_status`),
  KEY `fk_chat_messages_sender` (`sender_id`),
  CONSTRAINT `fk_chat_messages_conversation` FOREIGN KEY (`conversation_id`) REFERENCES `chat_conversations` (`id`),
  CONSTRAINT `fk_chat_messages_receiver` FOREIGN KEY (`receiver_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_chat_messages_sender` FOREIGN KEY (`sender_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='聊天消息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chat_messages`
--

LOCK TABLES `chat_messages` WRITE;
/*!40000 ALTER TABLE `chat_messages` DISABLE KEYS */;
INSERT INTO `chat_messages` VALUES (1,1,4,3,'你好','TEXT','READ','2026-06-16 21:29:08'),(2,1,3,4,'干什么','TEXT','READ','2026-06-16 21:31:26'),(3,1,4,3,'可以便宜一点嘛','TEXT','READ','2026-06-16 21:32:00'),(4,1,3,4,'不可以','TEXT','READ','2026-06-16 21:32:08'),(5,1,4,3,'还在吗？','TEXT','UNREAD','2026-06-16 21:34:51'),(6,1,4,3,'你好','TEXT','UNREAD','2026-06-16 21:43:17');
/*!40000 ALTER TABLE `chat_messages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `favorites`
--

DROP TABLE IF EXISTS `favorites`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `favorites` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '收藏ID',
  `user_id` bigint unsigned NOT NULL COMMENT '收藏用户ID',
  `product_id` bigint unsigned NOT NULL COMMENT '被收藏商品ID',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '收藏时间',
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否取消收藏',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_favorites_user_product` (`user_id`,`product_id`),
  KEY `idx_favorites_product` (`product_id`),
  CONSTRAINT `fk_favorites_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`),
  CONSTRAINT `fk_favorites_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='收藏表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `favorites`
--

LOCK TABLES `favorites` WRITE;
/*!40000 ALTER TABLE `favorites` DISABLE KEYS */;
INSERT INTO `favorites` VALUES (1,3,1,'2026-06-16 21:21:50',1);
/*!40000 ALTER TABLE `favorites` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `messages`
--

DROP TABLE IF EXISTS `messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `messages` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '消息ID',
  `receiver_id` bigint unsigned NOT NULL COMMENT '接收用户ID',
  `sender_id` bigint unsigned DEFAULT NULL COMMENT '发送者ID，系统消息可为空',
  `message_type` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'ORDER_CREATED / ORDER_CONFIRMED / ORDER_CANCELED / ORDER_TIMEOUT / REPORT_HANDLED / SYSTEM_NOTICE',
  `title` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '消息标题',
  `content` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '消息内容',
  `related_type` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'ORDER / PRODUCT / REPORT / NOTICE',
  `related_id` bigint unsigned DEFAULT NULL COMMENT '关联对象ID',
  `read_status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'UNREAD' COMMENT 'UNREAD / READ',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `read_time` datetime DEFAULT NULL COMMENT '读取时间',
  PRIMARY KEY (`id`),
  KEY `idx_messages_receiver_read_time` (`receiver_id`,`read_status`,`create_time`),
  KEY `idx_messages_sender` (`sender_id`),
  KEY `idx_messages_related` (`related_type`,`related_id`),
  CONSTRAINT `fk_messages_receiver` FOREIGN KEY (`receiver_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_messages_sender` FOREIGN KEY (`sender_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='站内消息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `messages`
--

LOCK TABLES `messages` WRITE;
/*!40000 ALTER TABLE `messages` DISABLE KEYS */;
INSERT INTO `messages` VALUES (1,3,NULL,'ORDER_CREATED','新订单提醒','您的商品「毒品」有新的订单，买家已预约，请尽快确认。','ORDER',1,'READ','2026-06-16 21:47:13','2026-06-16 21:47:26'),(2,4,NULL,'ORDER_CONFIRMED','订单已确认','卖家已确认您的订单「毒品」，请按约定时间地点交易。','ORDER',1,'READ','2026-06-16 21:47:38','2026-06-16 21:47:59'),(3,4,NULL,'ORDER_CONFIRMED','交易完成','订单「毒品」已完成交易，欢迎评价。','ORDER',1,'READ','2026-06-16 21:48:31','2026-06-16 21:48:44'),(4,3,NULL,'SYSTEM_NOTICE','收到新评价','您的订单收到3星评价','ORDER',1,'READ','2026-06-16 21:49:12','2026-06-16 21:50:10');
/*!40000 ALTER TABLE `messages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '订单ID',
  `order_no` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '订单编号',
  `product_id` bigint unsigned NOT NULL COMMENT '商品ID',
  `buyer_id` bigint unsigned NOT NULL COMMENT '买家用户ID',
  `seller_id` bigint unsigned NOT NULL COMMENT '卖家用户ID',
  `product_title_snapshot` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '下单时商品标题快照',
  `product_price_snapshot` decimal(10,2) NOT NULL COMMENT '下单时商品价格快照',
  `status` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PENDING_CONFIRM' COMMENT 'PENDING_CONFIRM / WAIT_MEET / COMPLETED / CANCELED / EXCEPTION_CLOSED',
  `remark` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '买家备注',
  `meet_time` datetime DEFAULT NULL COMMENT '约定面交时间',
  `meet_location` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '约定面交地点',
  `cancel_reason` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '取消原因',
  `cancel_by` bigint unsigned DEFAULT NULL COMMENT '取消操作人ID',
  `expire_time` datetime NOT NULL COMMENT '卖家确认截止时间',
  `confirm_time` datetime DEFAULT NULL COMMENT '卖家确认时间',
  `finish_time` datetime DEFAULT NULL COMMENT '交易完成时间',
  `close_time` datetime DEFAULT NULL COMMENT '取消或异常关闭时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '下单时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_orders_order_no` (`order_no`),
  KEY `idx_orders_product_status` (`product_id`,`status`),
  KEY `idx_orders_buyer_status_time` (`buyer_id`,`status`,`create_time`),
  KEY `idx_orders_seller_status_time` (`seller_id`,`status`,`create_time`),
  KEY `idx_orders_expire` (`status`,`expire_time`),
  KEY `idx_orders_cancel_by` (`cancel_by`),
  CONSTRAINT `fk_orders_buyer` FOREIGN KEY (`buyer_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_orders_cancel_by` FOREIGN KEY (`cancel_by`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_orders_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`),
  CONSTRAINT `fk_orders_seller` FOREIGN KEY (`seller_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='订单表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (1,'O20260616214713916900',1,4,3,'毒品',300.00,'COMPLETED','','2026-06-16 22:47:00','东区门口',NULL,NULL,'2026-06-17 21:47:13','2026-06-16 21:47:38','2026-06-16 21:48:31',NULL,'2026-06-16 21:47:13','2026-06-16 21:48:31');
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_images`
--

DROP TABLE IF EXISTS `product_images`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_images` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '图片ID',
  `product_id` bigint unsigned NOT NULL COMMENT '商品ID',
  `image_url` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '图片访问地址',
  `sort_order` int NOT NULL DEFAULT '0' COMMENT '图片排序',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '上传时间',
  PRIMARY KEY (`id`),
  KEY `idx_product_images_product_sort` (`product_id`,`sort_order`),
  CONSTRAINT `fk_product_images_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商品图片表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_images`
--

LOCK TABLES `product_images` WRITE;
/*!40000 ALTER TABLE `product_images` DISABLE KEYS */;
INSERT INTO `product_images` VALUES (1,1,'/uploads/products/1781615709224389900.jpg',0,'2026-06-16 21:17:49'),(2,1,'/uploads/products/1781615715387741400.jpg',1,'2026-06-16 21:17:49'),(3,1,'/uploads/products/1781615720633351900.jpg',2,'2026-06-16 21:17:49'),(4,1,'/uploads/products/1781615729449729800.jpg',3,'2026-06-16 21:17:49'),(5,1,'/uploads/products/1781615734117575100.jpg',4,'2026-06-16 21:17:49'),(6,1,'/uploads/products/1781615739431181600.jpg',5,'2026-06-16 21:17:49'),(7,1,'/uploads/products/1781615743924977000.jpg',6,'2026-06-16 21:17:49'),(8,1,'/uploads/products/1781615749831722300.jpg',7,'2026-06-16 21:17:49'),(9,1,'/uploads/products/1781615755315347800.jpg',8,'2026-06-16 21:17:49'),(10,2,'/uploads/products/1781859554747223500.jpg',0,'2026-06-19 16:59:56');
/*!40000 ALTER TABLE `product_images` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `products` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '商品ID',
  `seller_id` bigint unsigned NOT NULL COMMENT '卖家用户ID',
  `category_id` bigint unsigned NOT NULL COMMENT '商品分类ID',
  `title` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '商品标题',
  `description` text COLLATE utf8mb4_unicode_ci COMMENT '商品描述',
  `original_price` decimal(10,2) DEFAULT NULL COMMENT '商品原价',
  `price` decimal(10,2) NOT NULL COMMENT '商品售价',
  `condition_level` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '商品成色',
  `meet_location` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '建议面交地点',
  `status` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'ON_SALE' COMMENT 'ON_SALE / LOCKED / SOLD / OFF_SHELF / DELETED',
  `view_count` int NOT NULL DEFAULT '0' COMMENT '浏览量',
  `favorite_count` int NOT NULL DEFAULT '0' COMMENT '收藏数',
  `off_shelf_reason` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '下架原因',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '发布时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除标记',
  PRIMARY KEY (`id`),
  KEY `idx_products_seller` (`seller_id`),
  KEY `idx_products_category_status` (`category_id`,`status`),
  KEY `idx_products_status_time` (`status`,`create_time`),
  KEY `idx_products_price` (`price`),
  KEY `idx_products_title` (`title`),
  CONSTRAINT `fk_products_category` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`),
  CONSTRAINT `fk_products_seller` FOREIGN KEY (`seller_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商品表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
INSERT INTO `products` VALUES (1,3,1,'毒品','不错',200.00,300.00,'全新','东区门口','SOLD',14,0,'','2026-06-16 21:17:49','2026-06-16 21:48:31',0),(2,4,1,'数学书','不错的',20.00,10.00,'全新','','OFF_SHELF',0,0,'管理员下架商品','2026-06-19 16:59:56','2026-06-19 17:02:36',0);
/*!40000 ALTER TABLE `products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `report_images`
--

DROP TABLE IF EXISTS `report_images`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `report_images` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '凭证图片ID',
  `report_id` bigint unsigned NOT NULL COMMENT '举报ID',
  `image_url` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '凭证图片访问地址',
  `sort_order` int NOT NULL DEFAULT '0' COMMENT '图片排序',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '上传时间',
  PRIMARY KEY (`id`),
  KEY `idx_report_images_report_sort` (`report_id`,`sort_order`),
  CONSTRAINT `fk_report_images_report` FOREIGN KEY (`report_id`) REFERENCES `reports` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='举报凭证图片表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `report_images`
--

LOCK TABLES `report_images` WRITE;
/*!40000 ALTER TABLE `report_images` DISABLE KEYS */;
/*!40000 ALTER TABLE `report_images` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reports`
--

DROP TABLE IF EXISTS `reports`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reports` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '举报ID',
  `reporter_id` bigint unsigned NOT NULL COMMENT '举报人ID',
  `target_type` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'PRODUCT / USER / ORDER',
  `target_id` bigint unsigned NOT NULL COMMENT '被举报对象ID',
  `reason_type` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '举报原因类型',
  `description` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '举报说明',
  `status` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PENDING' COMMENT 'PENDING / PROCESSING / APPROVED / REJECTED / CLOSED',
  `handle_result` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '处理结果说明',
  `handler_id` bigint unsigned DEFAULT NULL COMMENT '处理管理员ID',
  `handle_time` datetime DEFAULT NULL COMMENT '处理时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '举报提交时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_reports_reporter` (`reporter_id`),
  KEY `idx_reports_target` (`target_type`,`target_id`),
  KEY `idx_reports_status_time` (`status`,`create_time`),
  KEY `idx_reports_handler` (`handler_id`),
  CONSTRAINT `fk_reports_handler` FOREIGN KEY (`handler_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_reports_reporter` FOREIGN KEY (`reporter_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='举报表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reports`
--

LOCK TABLES `reports` WRITE;
/*!40000 ALTER TABLE `reports` DISABLE KEYS */;
INSERT INTO `reports` VALUES (1,3,'PRODUCT',2,'FAKE_PRODUCT','盗版','PROCESSING',NULL,5,NULL,'2026-06-19 17:01:05','2026-06-19 17:02:13');
/*!40000 ALTER TABLE `reports` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reviews`
--

DROP TABLE IF EXISTS `reviews`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reviews` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '评价ID',
  `order_id` bigint unsigned NOT NULL COMMENT '订单ID',
  `product_id` bigint unsigned NOT NULL COMMENT '商品ID',
  `reviewer_id` bigint unsigned NOT NULL COMMENT '评价人ID',
  `seller_id` bigint unsigned NOT NULL COMMENT '被评价卖家ID',
  `rating` int NOT NULL COMMENT '星级评分，取值1-5',
  `content` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '文字评价',
  `status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'NORMAL' COMMENT 'NORMAL / HIDDEN / DELETED',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '评价时间',
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除标记',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_reviews_order_reviewer` (`order_id`,`reviewer_id`),
  KEY `idx_reviews_product` (`product_id`),
  KEY `idx_reviews_seller_status` (`seller_id`,`status`),
  KEY `idx_reviews_reviewer` (`reviewer_id`),
  CONSTRAINT `fk_reviews_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`),
  CONSTRAINT `fk_reviews_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`),
  CONSTRAINT `fk_reviews_reviewer` FOREIGN KEY (`reviewer_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_reviews_seller` FOREIGN KEY (`seller_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='评价表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reviews`
--

LOCK TABLES `reviews` WRITE;
/*!40000 ALTER TABLE `reviews` DISABLE KEYS */;
INSERT INTO `reviews` VALUES (1,1,1,4,3,3,'不错的','NORMAL','2026-06-16 21:49:12',0);
/*!40000 ALTER TABLE `reviews` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sensitive_words`
--

DROP TABLE IF EXISTS `sensitive_words`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sensitive_words` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '敏感词ID',
  `word` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '敏感词内容',
  `word_type` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'FORBIDDEN / RISK',
  `status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'ENABLED' COMMENT 'ENABLED / DISABLED',
  `create_by` bigint unsigned DEFAULT NULL COMMENT '创建管理员ID',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_sensitive_words_word` (`word`),
  KEY `idx_sensitive_words_status` (`status`),
  KEY `idx_sensitive_words_create_by` (`create_by`),
  CONSTRAINT `fk_sensitive_words_create_by` FOREIGN KEY (`create_by`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=92 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='敏感词表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sensitive_words`
--

LOCK TABLES `sensitive_words` WRITE;
/*!40000 ALTER TABLE `sensitive_words` DISABLE KEYS */;
INSERT INTO `sensitive_words` VALUES (1,'毒品','FORBIDDEN','ENABLED',5,'2026-06-16 22:10:11','2026-06-16 22:10:11'),(2,'私下交易','RISK','ENABLED',NULL,'2026-06-19 14:35:46','2026-06-19 14:35:46'),(3,'线下转账','RISK','ENABLED',NULL,'2026-06-19 14:35:46','2026-06-19 14:35:46'),(4,'先款后货','RISK','ENABLED',NULL,'2026-06-19 14:35:46','2026-06-19 14:35:46'),(5,'先付定金','RISK','ENABLED',NULL,'2026-06-19 14:35:46','2026-06-19 14:35:46'),(6,'提前打款','RISK','ENABLED',NULL,'2026-06-19 14:35:46','2026-06-19 14:35:46'),(7,'加微信交易','RISK','ENABLED',NULL,'2026-06-19 14:35:46','2026-06-19 14:35:46'),(8,'加QQ交易','RISK','ENABLED',NULL,'2026-06-19 14:35:46','2026-06-19 14:35:46'),(9,'绕过平台','RISK','ENABLED',NULL,'2026-06-19 14:35:46','2026-06-19 14:35:46'),(10,'不走平台','RISK','ENABLED',NULL,'2026-06-19 14:35:46','2026-06-19 14:35:46'),(11,'保证赚钱','RISK','ENABLED',NULL,'2026-06-19 14:35:46','2026-06-19 14:35:46'),(12,'稳赚不赔','RISK','ENABLED',NULL,'2026-06-19 14:35:46','2026-06-19 14:35:46'),(13,'内部渠道','RISK','ENABLED',NULL,'2026-06-19 14:35:46','2026-06-19 14:35:46'),(14,'低价代购','RISK','ENABLED',NULL,'2026-06-19 14:35:46','2026-06-19 14:35:46'),(15,'刷单','FORBIDDEN','ENABLED',NULL,'2026-06-19 14:35:46','2026-06-19 14:35:46'),(16,'刷信誉','FORBIDDEN','ENABLED',NULL,'2026-06-19 14:35:46','2026-06-19 14:35:46'),(17,'套现','FORBIDDEN','ENABLED',NULL,'2026-06-19 14:35:46','2026-06-19 14:35:46'),(18,'洗钱','FORBIDDEN','ENABLED',NULL,'2026-06-19 14:35:46','2026-06-19 14:35:46'),(19,'跑分','FORBIDDEN','ENABLED',NULL,'2026-06-19 14:35:46','2026-06-19 14:35:46'),(20,'薅羊毛项目','RISK','ENABLED',NULL,'2026-06-19 14:35:46','2026-06-19 14:35:46'),(21,'身份证出售','FORBIDDEN','ENABLED',NULL,'2026-06-19 14:35:46','2026-06-19 14:35:46'),(22,'学生证出售','FORBIDDEN','ENABLED',NULL,'2026-06-19 14:35:46','2026-06-19 14:35:46'),(23,'校园卡出售','FORBIDDEN','ENABLED',NULL,'2026-06-19 14:35:46','2026-06-19 14:35:46'),(24,'银行卡出售','FORBIDDEN','ENABLED',NULL,'2026-06-19 14:35:46','2026-06-19 14:35:46'),(25,'电话卡出售','FORBIDDEN','ENABLED',NULL,'2026-06-19 14:35:46','2026-06-19 14:35:46'),(26,'手机号出售','FORBIDDEN','ENABLED',NULL,'2026-06-19 14:35:46','2026-06-19 14:35:46'),(27,'账号买卖','FORBIDDEN','ENABLED',NULL,'2026-06-19 14:35:46','2026-06-19 14:35:46'),(28,'游戏账号买卖','RISK','ENABLED',NULL,'2026-06-19 14:35:46','2026-06-19 14:35:46'),(29,'代实名','FORBIDDEN','ENABLED',NULL,'2026-06-19 14:35:46','2026-06-19 14:35:46'),(30,'代认证','FORBIDDEN','ENABLED',NULL,'2026-06-19 14:35:46','2026-06-19 14:35:46'),(31,'个人信息出售','FORBIDDEN','ENABLED',NULL,'2026-06-19 14:35:46','2026-06-19 14:35:46'),(32,'隐私照片','FORBIDDEN','ENABLED',NULL,'2026-06-19 14:35:46','2026-06-19 14:35:46'),(33,'代写论文','FORBIDDEN','ENABLED',NULL,'2026-06-19 14:35:46','2026-06-19 14:35:46'),(34,'代写作业','FORBIDDEN','ENABLED',NULL,'2026-06-19 14:35:46','2026-06-19 14:35:46'),(35,'代做作业','FORBIDDEN','ENABLED',NULL,'2026-06-19 14:35:46','2026-06-19 14:35:46'),(36,'代考试','FORBIDDEN','ENABLED',NULL,'2026-06-19 14:35:46','2026-06-19 14:35:46'),(37,'替考','FORBIDDEN','ENABLED',NULL,'2026-06-19 14:35:46','2026-06-19 14:35:46'),(38,'论文代发','FORBIDDEN','ENABLED',NULL,'2026-06-19 14:35:46','2026-06-19 14:35:46'),(39,'毕业设计代做','FORBIDDEN','ENABLED',NULL,'2026-06-19 14:35:46','2026-06-19 14:35:46'),(40,'实验报告代写','FORBIDDEN','ENABLED',NULL,'2026-06-19 14:35:46','2026-06-19 14:35:46'),(41,'课程设计代做','FORBIDDEN','ENABLED',NULL,'2026-06-19 14:35:46','2026-06-19 14:35:46'),(42,'包过考试','FORBIDDEN','ENABLED',NULL,'2026-06-19 14:35:46','2026-06-19 14:35:46'),(43,'答案出售','FORBIDDEN','ENABLED',NULL,'2026-06-19 14:35:46','2026-06-19 14:35:46'),(44,'考试答案','FORBIDDEN','ENABLED',NULL,'2026-06-19 14:35:46','2026-06-19 14:35:46'),(45,'处方药','FORBIDDEN','ENABLED',NULL,'2026-06-19 14:35:46','2026-06-19 14:35:46'),(46,'违禁药品','FORBIDDEN','ENABLED',NULL,'2026-06-19 14:35:46','2026-06-19 14:35:46'),(47,'管制刀具','FORBIDDEN','ENABLED',NULL,'2026-06-19 14:35:46','2026-06-19 14:35:46'),(48,'仿真枪','FORBIDDEN','ENABLED',NULL,'2026-06-19 14:35:46','2026-06-19 14:35:46'),(49,'烟草','FORBIDDEN','ENABLED',NULL,'2026-06-19 14:35:46','2026-06-19 14:35:46'),(50,'香烟','FORBIDDEN','ENABLED',NULL,'2026-06-19 14:35:46','2026-06-19 14:35:46'),(51,'电子烟','FORBIDDEN','ENABLED',NULL,'2026-06-19 14:35:46','2026-06-19 14:35:46'),(52,'酒水转让','FORBIDDEN','ENABLED',NULL,'2026-06-19 14:35:46','2026-06-19 14:35:46'),(53,'白酒转让','FORBIDDEN','ENABLED',NULL,'2026-06-19 14:35:46','2026-06-19 14:35:46'),(54,'彩票','FORBIDDEN','ENABLED',NULL,'2026-06-19 14:35:46','2026-06-19 14:35:46'),(55,'博彩','FORBIDDEN','ENABLED',NULL,'2026-06-19 14:35:46','2026-06-19 14:35:46'),(56,'赌博','FORBIDDEN','ENABLED',NULL,'2026-06-19 14:35:46','2026-06-19 14:35:46'),(57,'成人用品','FORBIDDEN','ENABLED',NULL,'2026-06-19 14:35:46','2026-06-19 14:35:46'),(58,'危险化学品','FORBIDDEN','ENABLED',NULL,'2026-06-19 14:35:46','2026-06-19 14:35:46'),(59,'宠物活体','RISK','ENABLED',NULL,'2026-06-19 14:35:46','2026-06-19 14:35:46'),(60,'盗版软件','FORBIDDEN','ENABLED',NULL,'2026-06-19 14:35:46','2026-06-19 14:35:46'),(61,'破解软件','FORBIDDEN','ENABLED',NULL,'2026-06-19 14:35:46','2026-06-19 14:35:46'),(62,'破解版','FORBIDDEN','ENABLED',NULL,'2026-06-19 14:35:46','2026-06-19 14:35:46'),(63,'盗版课程','FORBIDDEN','ENABLED',NULL,'2026-06-19 14:35:46','2026-06-19 14:35:46'),(64,'破解网课','FORBIDDEN','ENABLED',NULL,'2026-06-19 14:35:46','2026-06-19 14:35:46'),(65,'盗版电子书','FORBIDDEN','ENABLED',NULL,'2026-06-19 14:35:46','2026-06-19 14:35:46'),(66,'盗版教材','FORBIDDEN','ENABLED',NULL,'2026-06-19 14:35:46','2026-06-19 14:35:46'),(67,'外挂','FORBIDDEN','ENABLED',NULL,'2026-06-19 14:35:46','2026-06-19 14:35:46'),(68,'游戏外挂','FORBIDDEN','ENABLED',NULL,'2026-06-19 14:35:46','2026-06-19 14:35:46'),(69,'盗号工具','FORBIDDEN','ENABLED',NULL,'2026-06-19 14:35:46','2026-06-19 14:35:46'),(70,'校园贷','FORBIDDEN','ENABLED',NULL,'2026-06-19 14:35:46','2026-06-19 14:35:46'),(71,'高利贷','FORBIDDEN','ENABLED',NULL,'2026-06-19 14:35:46','2026-06-19 14:35:46'),(72,'裸贷','FORBIDDEN','ENABLED',NULL,'2026-06-19 14:35:46','2026-06-19 14:35:46'),(73,'借贷中介','FORBIDDEN','ENABLED',NULL,'2026-06-19 14:35:46','2026-06-19 14:35:46'),(74,'贷款套现','FORBIDDEN','ENABLED',NULL,'2026-06-19 14:35:46','2026-06-19 14:35:46'),(75,'信用卡套现','FORBIDDEN','ENABLED',NULL,'2026-06-19 14:35:46','2026-06-19 14:35:46'),(76,'包过','RISK','ENABLED',NULL,'2026-06-19 14:35:46','2026-06-19 14:35:46'),(77,'全网最低','RISK','ENABLED',NULL,'2026-06-19 14:35:46','2026-06-19 14:35:46'),(78,'假一赔十','RISK','ENABLED',NULL,'2026-06-19 14:35:46','2026-06-19 14:35:46'),(79,'无理由退款保证','RISK','ENABLED',NULL,'2026-06-19 14:35:46','2026-06-19 14:35:46'),(80,'绝对正品','RISK','ENABLED',NULL,'2026-06-19 14:35:46','2026-06-19 14:35:46'),(81,'官方内部价','RISK','ENABLED',NULL,'2026-06-19 14:35:46','2026-06-19 14:35:46'),(82,'低价秒杀','RISK','ENABLED',NULL,'2026-06-19 14:35:46','2026-06-19 14:35:46'),(83,'限时返利','RISK','ENABLED',NULL,'2026-06-19 14:35:46','2026-06-19 14:35:46'),(84,'傻逼','FORBIDDEN','ENABLED',NULL,'2026-06-19 14:35:46','2026-06-19 14:35:46'),(85,'垃圾人','RISK','ENABLED',NULL,'2026-06-19 14:35:46','2026-06-19 14:35:46'),(86,'滚蛋','RISK','ENABLED',NULL,'2026-06-19 14:35:46','2026-06-19 14:35:46'),(87,'骗子死全家','FORBIDDEN','ENABLED',NULL,'2026-06-19 14:35:46','2026-06-19 14:35:46'),(88,'脑残','RISK','ENABLED',NULL,'2026-06-19 14:35:46','2026-06-19 14:35:46'),(89,'废物','RISK','ENABLED',NULL,'2026-06-19 14:35:46','2026-06-19 14:35:46'),(90,'去死','FORBIDDEN','ENABLED',NULL,'2026-06-19 14:35:46','2026-06-19 14:35:46'),(91,'辱骂','RISK','ENABLED',NULL,'2026-06-19 14:35:46','2026-06-19 14:35:46');
/*!40000 ALTER TABLE `sensitive_words` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '用户主键ID',
  `openid` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '微信用户唯一标识',
  `nickname` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '微信昵称或用户昵称',
  `avatar_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '微信头像地址',
  `student_id` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '学号',
  `real_name` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '学生真实姓名',
  `college` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '学院信息',
  `phone` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '联系方式',
  `role` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'USER' COMMENT 'USER / ADMIN / SUPER_ADMIN',
  `auth_status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'UNVERIFIED' COMMENT 'UNVERIFIED / PENDING / VERIFIED / REJECTED',
  `account_status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'NORMAL' COMMENT 'NORMAL / DISABLED / BANNED / CANCELED',
  `last_login_time` datetime DEFAULT NULL COMMENT '最近登录时间',
  `token_version` int NOT NULL DEFAULT '0' COMMENT '访问凭证版本，递增后旧JWT失效',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '注册时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除标记',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_users_openid` (`openid`),
  UNIQUE KEY `uk_users_student_id` (`student_id`),
  KEY `idx_users_role` (`role`),
  KEY `idx_users_auth_account` (`auth_status`,`account_status`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (3,'seller_test','卖家测试','/uploads/avatar/b036dfce32804342cdf11c62a988351d.png','TEST_SELLER_616','Test Seller','Info College','13800000001','USER','VERIFIED','NORMAL','2026-06-16 21:08:08',0,'2026-06-16 21:07:36','2026-06-16 21:13:34',0),(4,'buyer_test','Test Buyer',NULL,'TEST_BUYER_616','Test Buyer','Info College','13800000002','USER','VERIFIED','NORMAL','2026-06-16 21:08:08',0,'2026-06-16 21:07:36','2026-06-16 21:08:08',0),(5,'admin_test','Test Admin',NULL,'TEST_ADMIN_616','Test Admin','Info College','13800000003','ADMIN','VERIFIED','NORMAL','2026-06-16 21:08:08',0,'2026-06-16 21:07:36','2026-06-16 21:08:08',0),(6,'admin_dev_user',NULL,NULL,NULL,NULL,NULL,NULL,'USER','UNVERIFIED','NORMAL','2026-06-19 17:22:14',0,'2026-06-19 17:22:14','2026-06-19 17:22:14',0);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'cau_used_goods'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-19 17:25:46
