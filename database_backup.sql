/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19-11.4.10-MariaDB, for Linux (x86_64)
--
-- Host: localhost    Database: rehltwoz_rehltna
-- ------------------------------------------------------
-- Server version	11.4.10-MariaDB-cll-lve-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*M!100616 SET @OLD_NOTE_VERBOSITY=@@NOTE_VERBOSITY, NOTE_VERBOSITY=0 */;

--
-- Table structure for table `ais`
--

DROP TABLE IF EXISTS `ais`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ais` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(191) NOT NULL,
  `key` text NOT NULL,
  `status` varchar(191) NOT NULL DEFAULT 'inactive',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `type` varchar(191) NOT NULL DEFAULT 'Gemini',
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ais`
--

LOCK TABLES `ais` WRITE;
/*!40000 ALTER TABLE `ais` DISABLE KEYS */;
/*!40000 ALTER TABLE `ais` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `apply_jobs`
--

DROP TABLE IF EXISTS `apply_jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `apply_jobs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `career_id` bigint(20) unsigned NOT NULL,
  `name` varchar(191) NOT NULL,
  `email` varchar(191) NOT NULL,
  `phone` varchar(191) NOT NULL,
  `cv` varchar(191) NOT NULL,
  `status` enum('pending','accepted','rejected') NOT NULL DEFAULT 'pending',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `apply_jobs_career_id_foreign` (`career_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `apply_jobs`
--

LOCK TABLES `apply_jobs` WRITE;
/*!40000 ALTER TABLE `apply_jobs` DISABLE KEYS */;
/*!40000 ALTER TABLE `apply_jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `blogs`
--

DROP TABLE IF EXISTS `blogs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `blogs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `category_id` bigint(20) unsigned NOT NULL,
  `title_ar` varchar(191) DEFAULT NULL,
  `title_en` varchar(191) DEFAULT NULL,
  `title_de` varchar(191) DEFAULT NULL,
  `title_fr` varchar(191) DEFAULT NULL,
  `slug_en` varchar(191) DEFAULT NULL,
  `slug_de` varchar(191) DEFAULT NULL,
  `slug_fr` varchar(191) DEFAULT NULL,
  `slug_ar` varchar(191) DEFAULT NULL,
  `short_description_ar` text DEFAULT NULL,
  `short_description_en` text DEFAULT NULL,
  `short_description_de` text DEFAULT NULL,
  `short_description_fr` text DEFAULT NULL,
  `description_ar` longtext DEFAULT NULL,
  `description_en` longtext DEFAULT NULL,
  `description_de` longtext DEFAULT NULL,
  `description_fr` longtext DEFAULT NULL,
  `banner_en` text DEFAULT NULL,
  `banner_de` varchar(191) DEFAULT NULL,
  `banner_fr` varchar(191) DEFAULT NULL,
  `banner_ar` text DEFAULT NULL,
  `meta_title_ar` varchar(191) DEFAULT NULL,
  `meta_title_en` varchar(191) DEFAULT NULL,
  `meta_title_de` varchar(191) DEFAULT NULL,
  `meta_title_fr` varchar(191) DEFAULT NULL,
  `meta_img` text DEFAULT NULL,
  `meta_description_ar` text DEFAULT NULL,
  `meta_description_en` text DEFAULT NULL,
  `meta_description_de` text DEFAULT NULL,
  `meta_description_fr` text DEFAULT NULL,
  `meta_keywords_ar` text DEFAULT NULL,
  `meta_keywords_en` text DEFAULT NULL,
  `meta_keywords_de` text DEFAULT NULL,
  `meta_keywords_fr` text DEFAULT NULL,
  `status` tinyint(4) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `is_feature` tinyint(4) NOT NULL DEFAULT 0,
  `order` varchar(191) DEFAULT '0',
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `blogs_category_id_foreign` (`category_id`)
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `blogs`
--

LOCK TABLES `blogs` WRITE;
/*!40000 ALTER TABLE `blogs` DISABLE KEYS */;
INSERT INTO `blogs` VALUES
(1,1,'مغامرتك القادمة','Uncover Your Next Adventure Trip',NULL,NULL,'uncover-your-next-adventure-trip',NULL,NULL,'مغامرتك-القادمة','استعد لمغامرات لا تُنسى في رحلات مليئة بالإثارة والاستكشاف.','Get ready for unforgettable adventures on trips full of excitement and discovery.',NULL,NULL,'<p>انطلق في رحلات مليئة بالمغامرة والاكتشاف، حيث ستجرب أشياء جديدة وتكوّن ذكريات تدوم مدى الحياة. سواء كنت تبحث عن الطبيعة الخلابة أو النشاطات المثيرة، رحلتك القادمة ستأخذك إلى عالم من المتعة والتجارب الفريدة.</p>','<p>Embark on journeys full of adventure and discovery, where you\'ll experience new things and create lifelong memories. Whether you\'re seeking breathtaking nature or thrilling activities, your next trip will take you into a world of fun and unique experiences.</p>',NULL,NULL,'/uploads/tenant_1/general/69b08d389b93a_1773178168_general.webp',NULL,NULL,'/uploads/tenant_1/general/69b08d389b93a_1773178168_general.webp','استعد لمغامرات لا تُنسى في رحلات مليئة بالإثارة والاستكشاف.','Get ready for unforgettable adventures on trips full of excitement and discovery.',NULL,NULL,'/uploads/tenant_1/general/69b08d389b93a_1773178168_general.webp','انطلق في رحلات مليئة بالمغامرة والاكتشاف، حيث ستجرب أشياء جديدة وتكوّن ذكريات تدوم مدى الحياة. سواء كنت تبحث عن الطبيعة الخلابة أو النشاطات المثيرة، رحلتك القادمة ستأخذك إلى عالم من المتعة والتجارب الفريدة.','Embark on journeys full of adventure and discovery, where you\'ll experience new things and create lifelong memories. Whether you\'re seeking breathtaking nature or thrilling activities, your next trip will take you into a world of fun and unique experiences.',NULL,NULL,'استعد لمغامرات لا تُنسى في رحلات مليئة بالإثارة والاستكشاف.','Embark on journeys full of adventure and discovery, where you\'ll experience new things and create lifelong memories. Whether you\'re seeking breathtaking nature or thrilling activities, your next trip will take you into a world of fun and unique experiences.',NULL,NULL,1,'2026-03-11 03:30:21','2026-03-11 03:30:21',1,'1',NULL),
(2,2,'الرحلات الجماعية','Group Tours',NULL,NULL,'group-tours',NULL,NULL,'الرحلات-الجماعية','استمتع بالسفر مع الأصدقاء أو العائلة في رحلات جماعية منظمة وممتعة.','Enjoy traveling with friends or family on organized and fun group tours.',NULL,NULL,'<p>تقدم الرحلات الجماعية فرصة رائعة لاستكشاف أماكن جديدة مع مجموعة من المسافرين. سواء كنت تبحث عن تجربة ثقافية، ترفيهية، أو تعليمية، ستجد في هذه الرحلات التنظيم المثالي والرفقة الممتعة التي تضيف للرحلة متعة إضافية.</p>','<p>&nbsp;Group tours offer a fantastic opportunity to explore new places with fellow travelers. Whether you’re looking for a cultural, recreational, or educational experience, these trips provide perfect organization and enjoyable companionship that adds extra fun to your journey.</p>',NULL,NULL,'/uploads/tenant_1/general/69b08d38aad4e_1773178168_general.webp',NULL,NULL,'/uploads/tenant_1/general/69b08d38aad4e_1773178168_general.webp','الرحلات الجماعية','Group Tours',NULL,NULL,'/uploads/tenant_1/general/69b08d38aad4e_1773178168_general.webp','تقدم الرحلات الجماعية فرصة رائعة لاستكشاف أماكن جديدة مع مجموعة من المسافرين. سواء كنت تبحث عن تجربة ثقافية، ترفيهية، أو تعليمية، ستجد في هذه الرحلات التنظيم المثالي والرفقة الممتعة التي تضيف للرحلة متعة إضافية.','Group tours offer a fantastic opportunity to explore new places with fellow travelers. Whether you’re looking for a cultural, recreational, or educational experience, these trips provide perfect organization and enjoyable companionship that adds extra fun to your journey.',NULL,NULL,'تقدم الرحلات الجماعية فرصة رائعة لاستكشاف أماكن جديدة مع مجموعة من المسافرين. سواء كنت تبحث عن تجربة ثقافية، ترفيهية، أو تعليمية، ستجد في هذه الرحلات التنظيم المثالي والرفقة الممتعة التي تضيف للرحلة متعة إضافية.','Group tours offer a fantastic opportunity to explore new places with fellow travelers. Whether you’re looking for a cultural, recreational, or educational experience, these trips provide perfect organization and enjoyable companionship that adds extra fun to your journey.',NULL,NULL,1,'2026-03-11 03:32:36','2026-03-11 03:32:36',1,'2',NULL),
(3,3,'الكروزات البحرية','Cruises',NULL,NULL,'cruises',NULL,NULL,'الكروزات-البحرية','استرخِ واستمتع بالمناظر الخلابة على متن كروزاتنا الفاخرة.','Relax and enjoy breathtaking views on our luxury cruises.',NULL,NULL,'<p>الكروزات البحرية تقدم تجربة فريدة من نوعها تجمع بين الاسترخاء والمغامرة. يمكنك الاستمتاع بالخدمات الفاخرة، زيارة جزر ساحرة، وممارسة نشاطات ترفيهية متنوعة بينما تستمتع بنسمات البحر ومناظره الخلابة</p>','<p>Sea cruises provide a unique experience combining relaxation and adventure. Enjoy luxurious services, visit enchanting islands, and engage in various recreational activities while soaking in the sea breeze and stunning views.</p>',NULL,NULL,'/uploads/tenant_1/general/69b08d38a9c59_1773178168_general.webp',NULL,NULL,'/uploads/tenant_1/general/69b08d38a9c59_1773178168_general.webp','الكروزات البحرية','Cruises',NULL,NULL,'/uploads/tenant_1/general/69b08d38a9c59_1773178168_general.webp','استرخِ واستمتع بالمناظر الخلابة على متن كروزاتنا الفاخرة.','Sea cruises provide a unique experience combining relaxation and adventure. Enjoy luxurious services, visit enchanting islands, and engage in various recreational activities while soaking in the sea breeze and stunning views.',NULL,NULL,'استرخِ واستمتع بالمناظر الخلابة على متن كروزاتنا الفاخرة.','Sea cruises provide a unique experience combining relaxation and adventure. Enjoy luxurious services, visit enchanting islands, and engage in various recreational activities while soaking in the sea breeze and stunning views.',NULL,NULL,1,'2026-03-11 03:35:17','2026-03-11 03:35:17',1,'3',NULL),
(4,4,'الرحلات التعليمية','Educational Tours',NULL,NULL,'educational-tours',NULL,NULL,'الرحلات-التعليمية','تعلّم واكتشف ثقافات جديدة من خلال رحلات تعليمية مميزة.','Learn and discover new cultures through unique educational tours.',NULL,NULL,'<p>الرحلات التعليمية تمنحك فرصة لتوسيع آفاقك الثقافية والمعرفية، حيث تجمع بين المتعة والتعلم. ستزور أماكن تاريخية وثقافية، وتتعرف على عادات الشعوب، مع نشاطات تفاعلية تعزز الفهم والتجربة العملية.</p>','<li data-section-id=\"y0z53r\" data-start=\"2855\" data-end=\"3056\">: Educational tours give you the chance to expand your cultural and intellectual horizons, blending fun and learning. You’ll visit historical and cultural sites, learn about local traditions, and participate in interactive activities that enhance understanding and hands-on experience.<p data-start=\"2857\" data-end=\"3056\"></p></li>',NULL,NULL,'/uploads/tenant_1/general/69b08d38a9338_1773178168_general.webp',NULL,NULL,'/uploads/tenant_1/general/69b08d38a9338_1773178168_general.webp','الرحلات التعليمية','Educational Tours',NULL,NULL,'/uploads/tenant_1/general/69b08d38a9338_1773178168_general.webp','الرحلات التعليمية تمنحك فرصة لتوسيع آفاقك الثقافية والمعرفية، حيث تجمع بين المتعة والتعلم. ستزور أماكن تاريخية وثقافية، وتتعرف على عادات الشعوب، مع نشاطات تفاعلية تعزز الفهم والتجربة العملية.','Educational tours give you the chance to expand your cultural and intellectual horizons, blending fun and learning. You’ll visit historical and cultural sites, learn about local traditions, and participate in interactive activities that enhance understanding and hands-on experience.',NULL,NULL,'الرحلات التعليمية تمنحك فرصة لتوسيع آفاقك الثقافية والمعرفية، حيث تجمع بين المتعة والتعلم. ستزور أماكن تاريخية وثقافية، وتتعرف على عادات الشعوب، مع نشاطات تفاعلية تعزز الفهم والتجربة العملية.',':Educational tours give you the chance to expand your cultural and intellectual horizons, blending fun and learning. You’ll visit historical and cultural sites, learn about local traditions, and participate in interactive activities that enhance understanding and hands-on experience.',NULL,NULL,1,'2026-03-11 03:37:23','2026-03-11 03:37:23',0,'4',NULL),
(5,5,'التاشيرات','Visas',NULL,NULL,'visas',NULL,NULL,'التاشيرات','سهّل رحلاتك معنا من خلال خدمات استخراج التأشيرات بسرعة وسهولة.','Simplify your travels with our fast and easy visa services.',NULL,NULL,'<p>خدمات التأشيرات لدينا مصممة لتسهيل رحلتك من البداية وحتى النهاية. سواء كنت مسافرًا للعمل أو للترفيه، سنساعدك في استخراج التأشيرة بسرعة وبأقل جهد، مع تقديم النصائح والإرشادات اللازمة لضمان رحلة سلسة وآمنة.</p>','<ul data-start=\"3611\" data-end=\"4092\"><li data-section-id=\"1osud9h\" data-start=\"3826\" data-end=\"4092\"><p data-start=\"3828\" data-end=\"4092\">Our visa services are designed to simplify your journey from start to finish. Whether you’re traveling for work or leisure, we assist you in obtaining your visa quickly and effortlessly, providing the guidance and tips needed for a smooth and safe trip.</p>\r\n</li>\r\n</ul>',NULL,NULL,'/uploads/tenant_1/general/69b08d38aad4e_1773178168_general.webp',NULL,NULL,'/uploads/tenant_1/general/69b08d38aad4e_1773178168_general.webp','التاشيرات','Visas',NULL,NULL,'/uploads/tenant_1/general/69b08d38aad4e_1773178168_general.webp','خدمات التأشيرات لدينا مصممة لتسهيل رحلتك من البداية وحتى النهاية. سواء كنت مسافرًا للعمل أو للترفيه، سنساعدك في استخراج التأشيرة بسرعة وبأقل جهد، مع تقديم النصائح والإرشادات اللازمة لضمان رحلة سلسة وآمنة.','Our visa services are designed to simplify your journey from start to finish. Whether you’re traveling for work or leisure, we assist you in obtaining your visa quickly and effortlessly, providing the guidance and tips needed for a smooth and safe trip.',NULL,NULL,'خدمات التأشيرات لدينا مصممة لتسهيل رحلتك من البداية وحتى النهاية. سواء كنت مسافرًا للعمل أو للترفيه، سنساعدك في استخراج التأشيرة بسرعة وبأقل جهد، مع تقديم النصائح والإرشادات اللازمة لضمان رحلة سلسة وآمنة.','Our visa services are designed to simplify your journey from start to finish. Whether you’re traveling for work or leisure, we assist you in obtaining your visa quickly and effortlessly, providing the guidance and tips needed for a smooth and safe trip.',NULL,NULL,1,'2026-03-11 03:39:17','2026-03-11 03:39:40',1,'5',NULL);
/*!40000 ALTER TABLE `blogs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cache`
--

DROP TABLE IF EXISTS `cache`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `cache` (
  `key` varchar(191) NOT NULL,
  `value` mediumtext NOT NULL,
  `expiration` int(11) NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cache`
--

LOCK TABLES `cache` WRITE;
/*!40000 ALTER TABLE `cache` DISABLE KEYS */;
/*!40000 ALTER TABLE `cache` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cache_locks`
--

DROP TABLE IF EXISTS `cache_locks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `cache_locks` (
  `key` varchar(191) NOT NULL,
  `owner` varchar(191) NOT NULL,
  `expiration` int(11) NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cache_locks`
--

LOCK TABLES `cache_locks` WRITE;
/*!40000 ALTER TABLE `cache_locks` DISABLE KEYS */;
/*!40000 ALTER TABLE `cache_locks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `career_types`
--

DROP TABLE IF EXISTS `career_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `career_types` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `title_en` varchar(191) DEFAULT NULL,
  `title_de` varchar(191) DEFAULT NULL,
  `title_fr` varchar(191) DEFAULT NULL,
  `title_ar` varchar(191) DEFAULT NULL,
  `banner_en` varchar(191) DEFAULT NULL,
  `banner_de` varchar(191) DEFAULT NULL,
  `banner_fr` varchar(191) DEFAULT NULL,
  `banner_ar` varchar(191) DEFAULT NULL,
  `meta_title_en` varchar(191) DEFAULT NULL,
  `meta_title_de` varchar(191) DEFAULT NULL,
  `meta_title_fr` varchar(191) DEFAULT NULL,
  `meta_title_ar` varchar(191) DEFAULT NULL,
  `meta_keywords_en` varchar(191) DEFAULT NULL,
  `meta_keywords_de` text DEFAULT NULL,
  `meta_keywords_fr` text DEFAULT NULL,
  `meta_keywords_ar` varchar(191) DEFAULT NULL,
  `meta_description_en` text DEFAULT NULL,
  `meta_description_de` text DEFAULT NULL,
  `meta_description_fr` text DEFAULT NULL,
  `meta_description_ar` text DEFAULT NULL,
  `meta_img` varchar(191) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `career_types`
--

LOCK TABLES `career_types` WRITE;
/*!40000 ALTER TABLE `career_types` DISABLE KEYS */;
/*!40000 ALTER TABLE `career_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `careers`
--

DROP TABLE IF EXISTS `careers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `careers` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `career_type_id` bigint(20) unsigned NOT NULL,
  `title_en` text DEFAULT NULL,
  `title_de` varchar(191) DEFAULT NULL,
  `title_fr` varchar(191) DEFAULT NULL,
  `title_ar` text DEFAULT NULL,
  `status` tinyint(4) NOT NULL DEFAULT 0,
  `type` enum('full_time','part_time','freelance') NOT NULL DEFAULT 'full_time',
  `meta_title_ar` varchar(191) DEFAULT NULL,
  `meta_title_en` varchar(191) DEFAULT NULL,
  `meta_title_de` varchar(191) DEFAULT NULL,
  `meta_title_fr` varchar(191) DEFAULT NULL,
  `meta_img` text DEFAULT NULL,
  `meta_description_ar` text DEFAULT NULL,
  `meta_description_en` text DEFAULT NULL,
  `meta_description_de` text DEFAULT NULL,
  `meta_description_fr` text DEFAULT NULL,
  `meta_keywords_ar` text DEFAULT NULL,
  `meta_keywords_en` text DEFAULT NULL,
  `meta_keywords_de` text DEFAULT NULL,
  `meta_keywords_fr` text DEFAULT NULL,
  `short_description_ar` text DEFAULT NULL,
  `short_description_en` text DEFAULT NULL,
  `short_description_de` text DEFAULT NULL,
  `short_description_fr` text DEFAULT NULL,
  `description_ar` longtext DEFAULT NULL,
  `description_en` longtext DEFAULT NULL,
  `description_de` longtext DEFAULT NULL,
  `description_fr` longtext DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `slug_en` varchar(191) DEFAULT NULL,
  `slug_de` varchar(191) DEFAULT NULL,
  `slug_fr` varchar(191) DEFAULT NULL,
  `slug_ar` varchar(191) DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `careers_career_type_id_foreign` (`career_type_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `careers`
--

LOCK TABLES `careers` WRITE;
/*!40000 ALTER TABLE `careers` DISABLE KEYS */;
/*!40000 ALTER TABLE `careers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `categories` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name_en` varchar(191) DEFAULT NULL,
  `name_de` varchar(191) DEFAULT NULL,
  `name_fr` varchar(191) DEFAULT NULL,
  `name_ar` varchar(191) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categories`
--

LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
INSERT INTO `categories` VALUES
(1,'Adventure',NULL,NULL,'مغامرات','2026-03-11 03:20:09','2026-03-11 03:20:09',NULL),
(2,'Group Trips',NULL,NULL,'قروبات جماعيه','2026-03-11 03:22:11','2026-03-11 03:22:11',NULL),
(3,'Luxury Cruises',NULL,NULL,'كروزات بحريه','2026-03-11 03:22:46','2026-03-11 03:22:46',NULL),
(4,'Educational Tours',NULL,NULL,'رحلات تعليميه','2026-03-11 03:23:18','2026-03-11 03:23:18',NULL),
(5,'Travel Visas',NULL,NULL,'تأشيرات','2026-03-11 03:23:50','2026-03-11 03:23:50',NULL);
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cities`
--

DROP TABLE IF EXISTS `cities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `cities` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `country_id` bigint(20) unsigned DEFAULT NULL,
  `state_id` bigint(20) unsigned DEFAULT NULL,
  `title_en` varchar(191) NOT NULL,
  `title_ar` varchar(191) NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `cities_country_id_foreign` (`country_id`),
  KEY `cities_state_id_foreign` (`state_id`)
) ENGINE=MyISAM AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cities`
--

LOCK TABLES `cities` WRITE;
/*!40000 ALTER TABLE `cities` DISABLE KEYS */;
INSERT INTO `cities` VALUES
(12,5,NULL,'بيهاتش','بيهاتش',1,'2026-04-25 20:20:24','2026-04-25 20:20:24'),
(11,5,NULL,'سراييفو','سراييفو',1,'2026-04-25 20:20:10','2026-04-25 20:20:10'),
(4,1,1,'Asswan','اسوان',1,'2026-03-12 19:03:12','2026-04-22 18:46:27'),
(10,5,NULL,'موستار','موستار',1,'2026-04-25 20:19:40','2026-04-25 20:19:40'),
(6,3,NULL,'Trabzon','طرابزون',1,'2026-04-20 01:20:33','2026-04-20 01:20:33'),
(7,3,NULL,'Istanbul','اسطنبول',1,'2026-04-20 01:21:20','2026-04-20 01:21:20'),
(8,3,NULL,'Uzungöl','أوزونجول',1,'2026-04-20 01:21:51','2026-04-20 01:21:51'),
(9,2,NULL,'Moscow','موسكو',1,'2026-04-21 02:40:34','2026-04-21 02:40:34');
/*!40000 ALTER TABLE `cities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `clinical_publications`
--

DROP TABLE IF EXISTS `clinical_publications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `clinical_publications` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `title_ar` varchar(191) DEFAULT NULL,
  `title_en` varchar(191) DEFAULT NULL,
  `title_de` varchar(191) DEFAULT NULL,
  `title_fr` varchar(191) DEFAULT NULL,
  `slug_en` varchar(191) DEFAULT NULL,
  `slug_de` varchar(191) DEFAULT NULL,
  `slug_fr` varchar(191) DEFAULT NULL,
  `slug_ar` varchar(191) DEFAULT NULL,
  `link` varchar(191) DEFAULT NULL,
  `is_feature` tinyint(4) NOT NULL DEFAULT 0,
  `short_description_ar` text DEFAULT NULL,
  `short_description_en` text DEFAULT NULL,
  `short_description_de` text DEFAULT NULL,
  `short_description_fr` text DEFAULT NULL,
  `description_ar` longtext DEFAULT NULL,
  `description_en` longtext DEFAULT NULL,
  `description_de` longtext DEFAULT NULL,
  `description_fr` longtext DEFAULT NULL,
  `banner_en` text DEFAULT NULL,
  `banner_de` varchar(191) DEFAULT NULL,
  `banner_fr` varchar(191) DEFAULT NULL,
  `banner_ar` text DEFAULT NULL,
  `meta_title_ar` varchar(191) DEFAULT NULL,
  `meta_title_en` varchar(191) DEFAULT NULL,
  `meta_title_de` varchar(191) DEFAULT NULL,
  `meta_title_fr` varchar(191) DEFAULT NULL,
  `meta_img` text DEFAULT NULL,
  `meta_description_ar` text DEFAULT NULL,
  `meta_description_en` text DEFAULT NULL,
  `meta_description_de` text DEFAULT NULL,
  `meta_description_fr` text DEFAULT NULL,
  `meta_keywords_ar` text DEFAULT NULL,
  `meta_keywords_en` text DEFAULT NULL,
  `meta_keywords_de` text DEFAULT NULL,
  `meta_keywords_fr` text DEFAULT NULL,
  `status` tinyint(4) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `order` varchar(191) DEFAULT '0',
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clinical_publications`
--

LOCK TABLES `clinical_publications` WRITE;
/*!40000 ALTER TABLE `clinical_publications` DISABLE KEYS */;
/*!40000 ALTER TABLE `clinical_publications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contact_us`
--

DROP TABLE IF EXISTS `contact_us`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `contact_us` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(191) NOT NULL,
  `phone` varchar(191) NOT NULL,
  `email` varchar(191) NOT NULL,
  `message` text NOT NULL,
  `reply` varchar(191) DEFAULT NULL,
  `status` enum('unread','read') NOT NULL DEFAULT 'unread',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contact_us`
--

LOCK TABLES `contact_us` WRITE;
/*!40000 ALTER TABLE `contact_us` DISABLE KEYS */;
INSERT INTO `contact_us` VALUES
(1,'Mohamed Abdel azeem','01028768312','123medoabdo@gmail.com','تحيا مصر وكل عام وانتم بخير',NULL,'unread','2026-03-14 18:47:12','2026-03-14 18:47:12',NULL),
(2,'Mohamed','01092338086','mohamedsaeed00451@gmail.com','test message',NULL,'unread','2026-03-15 16:19:36','2026-03-15 16:19:36',NULL);
/*!40000 ALTER TABLE `contact_us` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `countries`
--

DROP TABLE IF EXISTS `countries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `countries` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `title_en` varchar(191) NOT NULL,
  `title_ar` varchar(191) NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `countries`
--

LOCK TABLES `countries` WRITE;
/*!40000 ALTER TABLE `countries` DISABLE KEYS */;
INSERT INTO `countries` VALUES
(1,'Egypt','مصر',1,'2026-03-12 18:49:57','2026-03-12 18:49:57'),
(2,'Russia','روسيا',1,'2026-03-19 16:31:24','2026-03-19 16:31:24'),
(3,'Turkey','تركيا',1,'2026-03-19 16:31:35','2026-03-19 16:31:35'),
(4,'Georgia','جورجيا',1,'2026-03-19 16:31:56','2026-03-19 16:31:56'),
(5,'Bosnia','البوسنة',1,'2026-04-25 20:19:09','2026-04-25 20:19:09');
/*!40000 ALTER TABLE `countries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `coupon_items`
--

DROP TABLE IF EXISTS `coupon_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `coupon_items` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `coupon_id` bigint(20) unsigned NOT NULL,
  `item_id` bigint(20) unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `coupon_items_coupon_id_foreign` (`coupon_id`),
  KEY `coupon_items_item_id_foreign` (`item_id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `coupon_items`
--

LOCK TABLES `coupon_items` WRITE;
/*!40000 ALTER TABLE `coupon_items` DISABLE KEYS */;
INSERT INTO `coupon_items` VALUES
(1,1,1,NULL,NULL);
/*!40000 ALTER TABLE `coupon_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `coupons`
--

DROP TABLE IF EXISTS `coupons`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `coupons` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(191) NOT NULL,
  `type` enum('fixed','percent') NOT NULL,
  `value` decimal(10,2) NOT NULL,
  `item_id` bigint(20) unsigned DEFAULT NULL,
  `expires_at` date DEFAULT NULL,
  `usage_limit` int(11) DEFAULT NULL,
  `status` tinyint(4) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `coupons_code_unique` (`code`),
  KEY `coupons_item_id_foreign` (`item_id`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `coupons`
--

LOCK TABLES `coupons` WRITE;
/*!40000 ALTER TABLE `coupons` DISABLE KEYS */;
INSERT INTO `coupons` VALUES
(1,'KM0126','fixed',300.00,NULL,'2026-05-10',NULL,1,'2026-04-26 16:33:37','2026-04-26 16:38:23','2026-04-26 16:38:23'),
(2,'Tk0126','fixed',200.00,NULL,'2026-05-10',NULL,1,'2026-04-26 16:35:53','2026-04-26 18:15:39','2026-04-26 18:15:39'),
(3,'TK200','percent',2.00,NULL,'2026-05-10',NULL,1,'2026-04-26 18:18:18','2026-04-26 18:19:27',NULL);
/*!40000 ALTER TABLE `coupons` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `custom_pages`
--

DROP TABLE IF EXISTS `custom_pages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `custom_pages` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `title_en` text DEFAULT NULL,
  `title_de` varchar(191) DEFAULT NULL,
  `title_fr` varchar(191) DEFAULT NULL,
  `title_ar` text DEFAULT NULL,
  `slug` varchar(191) NOT NULL,
  `content_ar` longtext DEFAULT NULL,
  `content_en` longtext DEFAULT NULL,
  `content_de` longtext DEFAULT NULL,
  `content_fr` longtext DEFAULT NULL,
  `status` tinyint(4) NOT NULL DEFAULT 0,
  `meta_title_ar` varchar(191) DEFAULT NULL,
  `meta_title_en` varchar(191) DEFAULT NULL,
  `meta_title_de` varchar(191) DEFAULT NULL,
  `meta_title_fr` varchar(191) DEFAULT NULL,
  `meta_img` text DEFAULT NULL,
  `meta_description_ar` text DEFAULT NULL,
  `meta_description_en` text DEFAULT NULL,
  `meta_description_de` text DEFAULT NULL,
  `meta_description_fr` text DEFAULT NULL,
  `meta_keywords_ar` text DEFAULT NULL,
  `meta_keywords_en` text DEFAULT NULL,
  `meta_keywords_de` text DEFAULT NULL,
  `meta_keywords_fr` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `custom_pages`
--

LOCK TABLES `custom_pages` WRITE;
/*!40000 ALTER TABLE `custom_pages` DISABLE KEYS */;
INSERT INTO `custom_pages` VALUES
(1,'Privacy',NULL,NULL,'سياسه الخصوصيه','Privacy','<h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\">&lt;!DOCTYPE html&gt;</h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\">&lt;html lang=\"en\" dir=\"ltr\"&gt;</h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\">&lt;head&gt;</h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\">&nbsp; &nbsp; &lt;meta charset=\"UTF-8\"&gt;</h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\">&nbsp; &nbsp; &lt;style&gt;</h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\">&nbsp; &nbsp; &nbsp; &nbsp; .privacy-container {</h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; font-family: \'Segoe UI\', Arial, sans-serif;</h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; line-height: 1.6;</h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; color: #333;</h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; max-width: 800px;</h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; margin: 20px auto;</h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; padding: 40px;</h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; background-color: #fff;</h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; border: 1px solid #e1e1e1;</h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; border-radius: 12px;</h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; box-shadow: 0 4px 6px rgba(0,0,0,0.05);</h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\">&nbsp; &nbsp; &nbsp; &nbsp; }</h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\">&nbsp; &nbsp; &nbsp; &nbsp; .privacy-header {</h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; text-align: center;</h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; border-bottom: 2px solid #28a745;</h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; padding-bottom: 20px;</h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; margin-bottom: 30px;</h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\">&nbsp; &nbsp; &nbsp; &nbsp; }</h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\">&nbsp; &nbsp; &nbsp; &nbsp; .privacy-header h1 {</h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; color: #28a745;</h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; margin: 0;</h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; font-size: 28px;</h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\">&nbsp; &nbsp; &nbsp; &nbsp; }</h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\">&nbsp; &nbsp; &nbsp; &nbsp; .privacy-section {</h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; margin-bottom: 25px;</h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\">&nbsp; &nbsp; &nbsp; &nbsp; }</h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\">&nbsp; &nbsp; &nbsp; &nbsp; .privacy-section h2 {</h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; color: #2c3e50;</h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; font-size: 20px;</h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; border-left: 4px solid #28a745;</h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; padding-left: 15px;</h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; margin-bottom: 15px;</h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\">&nbsp; &nbsp; &nbsp; &nbsp; }</h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\">&nbsp; &nbsp; &nbsp; &nbsp; .privacy-section ul {</h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; padding-left: 25px;</h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\">&nbsp; &nbsp; &nbsp; &nbsp; }</h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\">&nbsp; &nbsp; &nbsp; &nbsp; .privacy-section ul li {</h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; margin-bottom: 8px;</h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\">&nbsp; &nbsp; &nbsp; &nbsp; }</h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\">&nbsp; &nbsp; &nbsp; &nbsp; .contact-info {</h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; background-color: #f8f9fa;</h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; padding: 20px;</h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; border-radius: 8px;</h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; border: 1px dashed #28a745;</h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\">&nbsp; &nbsp; &nbsp; &nbsp; }</h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\">&nbsp; &nbsp; &lt;/style&gt;</h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\">&lt;/head&gt;</h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\">&lt;body&gt;</h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\"><br></h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\">&lt;div class=\"privacy-container\"&gt;</h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\">&nbsp; &nbsp; &lt;div class=\"privacy-header\"&gt;</h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\">&nbsp; &nbsp; &nbsp; &nbsp; &lt;h1&gt;Privacy Policy&lt;/h1&gt;</h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\">&nbsp; &nbsp; &nbsp; &nbsp; &lt;p&gt;Rehltna for Travel &amp; Tourism&lt;/p&gt;</h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\">&nbsp; &nbsp; &lt;/div&gt;</h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\"><br></h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\">&nbsp; &nbsp; &lt;div class=\"privacy-section\"&gt;</h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\">&nbsp; &nbsp; &nbsp; &nbsp; &lt;h2&gt;1. Introduction&lt;/h2&gt;</h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\">&nbsp; &nbsp; &nbsp; &nbsp; &lt;p&gt;At &lt;strong&gt;Rehltna for Travel &amp; Tourism&lt;/strong&gt;, we respect our customers\' privacy and are committed to protecting all personal information collected through our website or during the use of our services.&lt;/p&gt;</h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\">&nbsp; &nbsp; &lt;/div&gt;</h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\"><br></h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\">&nbsp; &nbsp; &lt;div class=\"privacy-section\"&gt;</h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\">&nbsp; &nbsp; &nbsp; &nbsp; &lt;h2&gt;2. Information We Collect&lt;/h2&gt;</h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\">&nbsp; &nbsp; &nbsp; &nbsp; &lt;ul&gt;</h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &lt;li&gt;Full Name&lt;/li&gt;</h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &lt;li&gt;Phone Number &amp; Email Address&lt;/li&gt;</h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &lt;li&gt;Passport Details (for travel and visa services)&lt;/li&gt;</h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &lt;li&gt;Payment Information upon booking&lt;/li&gt;</h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\">&nbsp; &nbsp; &nbsp; &nbsp; &lt;/ul&gt;</h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\">&nbsp; &nbsp; &lt;/div&gt;</h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\"><br></h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\">&nbsp; &nbsp; &lt;div class=\"privacy-section\"&gt;</h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\">&nbsp; &nbsp; &nbsp; &nbsp; &lt;h2&gt;3. How We Use Information&lt;/h2&gt;</h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\">&nbsp; &nbsp; &nbsp; &nbsp; &lt;ul&gt;</h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &lt;li&gt;To complete flight and hotel bookings.&lt;/li&gt;</h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &lt;li&gt;To process visa applications.&lt;/li&gt;</h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &lt;li&gt;To communicate regarding requests and send updates or offers.&lt;/li&gt;</h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\">&nbsp; &nbsp; &nbsp; &nbsp; &lt;/ul&gt;</h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\">&nbsp; &nbsp; &lt;/div&gt;</h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\"><br></h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\">&nbsp; &nbsp; &lt;div class=\"privacy-section\"&gt;</h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\">&nbsp; &nbsp; &nbsp; &nbsp; &lt;h2&gt;4. Data Protection &amp; Sharing&lt;/h2&gt;</h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\">&nbsp; &nbsp; &nbsp; &nbsp; &lt;p&gt;We do not sell or rent your data. Information is only shared with essential third parties (Airlines, Hotels, Government Entities) necessary to complete your service.&lt;/p&gt;</h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\">&nbsp; &nbsp; &lt;/div&gt;</h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\"><br></h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\">&nbsp; &nbsp; &lt;div class=\"privacy-section\"&gt;</h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\">&nbsp; &nbsp; &nbsp; &nbsp; &lt;h2&gt;5. Your Rights&lt;/h2&gt;</h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\">&nbsp; &nbsp; &nbsp; &nbsp; &lt;p&gt;Users have the right to access, update, or request the deletion of their personal data at any time.&lt;/p&gt;</h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\">&nbsp; &nbsp; &lt;/div&gt;</h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\"><br></h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\">&nbsp; &nbsp; &lt;div class=\"privacy-section contact-info\"&gt;</h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\">&nbsp; &nbsp; &nbsp; &nbsp; &lt;h2&gt;6. Contact Us&lt;/h2&gt;</h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\">&nbsp; &nbsp; &nbsp; &nbsp; &lt;p&gt;&lt;strong&gt;Email:&lt;/strong&gt; info@rehltna.com&lt;/p&gt;</h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\">&nbsp; &nbsp; &nbsp; &nbsp; &lt;p&gt;&lt;strong&gt;Phone:&lt;/strong&gt; +966XXXXXXXXX&lt;/p&gt;</h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\">&nbsp; &nbsp; &lt;/div&gt;</h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\">&lt;/div&gt;</h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\"><br></h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\">&lt;/body&gt;</h1><h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\">&lt;/html&gt;</h1>','<h1 data-section-id=\"bs94m8\" data-start=\"2407\" data-end=\"2425\">Privacy Policy</h1><p data-start=\"2426\" data-end=\"2454\" style=\"font-size: medium;\"><strong data-start=\"2426\" data-end=\"2454\">Rehltna Travel &amp; Tourism</strong></p><h2 data-section-id=\"xgfogq\" data-start=\"2456\" data-end=\"2474\">1. Introduction</h2><p data-start=\"2475\" data-end=\"2725\" style=\"font-size: medium;\">At <strong data-start=\"2478\" data-end=\"2506\">Rehltna Travel &amp; Tourism</strong>, we respect the privacy of our customers and are committed to protecting the personal information collected through our website or when using our services such as travel bookings, visa processing, and tourism programs.</p><p data-start=\"2727\" data-end=\"2843\" style=\"font-size: medium;\">This Privacy Policy explains how we collect, use, and protect your information when you use our website or services.</p><hr data-start=\"2845\" data-end=\"2848\" style=\"font-size: medium;\"><h2 data-section-id=\"5ejyvt\" data-start=\"2850\" data-end=\"2878\">2. Information We Collect</h2><p data-start=\"2879\" data-end=\"2983\" style=\"font-size: medium;\">We may collect certain personal information when you use our website or request our services, including:</p><ul data-start=\"2985\" data-end=\"3190\" style=\"font-size: medium;\"><li data-section-id=\"apwdks\" data-start=\"2985\" data-end=\"2998\"><p data-start=\"2987\" data-end=\"2998\">Full name</p></li><li data-section-id=\"1tzdck7\" data-start=\"2999\" data-end=\"3015\"><p data-start=\"3001\" data-end=\"3015\">Phone number</p></li><li data-section-id=\"wk4jiq\" data-start=\"3016\" data-end=\"3033\"><p data-start=\"3018\" data-end=\"3033\">Email address</p></li><li data-section-id=\"r7c2gu\" data-start=\"3034\" data-end=\"3084\"><p data-start=\"3036\" data-end=\"3084\">Passport details (for travel or visa services)</p></li><li data-section-id=\"qibh0c\" data-start=\"3085\" data-end=\"3133\"><p data-start=\"3087\" data-end=\"3133\">Payment information when completing bookings</p></li><li data-section-id=\"26m99q\" data-start=\"3134\" data-end=\"3190\"><p data-start=\"3136\" data-end=\"3190\">Any additional information provided when contacting us</p></li></ul><hr data-start=\"3192\" data-end=\"3195\" style=\"font-size: medium;\"><h2 data-section-id=\"10c0s1w\" data-start=\"3197\" data-end=\"3230\">3. How We Use Your Information</h2><p data-start=\"3231\" data-end=\"3297\" style=\"font-size: medium;\">Rehltna uses the collected information for the following purposes:</p><ul data-start=\"3299\" data-end=\"3580\" style=\"font-size: medium;\"><li data-section-id=\"160m1v3\" data-start=\"3299\" data-end=\"3350\"><p data-start=\"3301\" data-end=\"3350\">Processing travel bookings and tourism services</p></li><li data-section-id=\"mec4s9\" data-start=\"3351\" data-end=\"3404\"><p data-start=\"3353\" data-end=\"3404\">Handling visa applications and related procedures</p></li><li data-section-id=\"1wa8nfu\" data-start=\"3405\" data-end=\"3469\"><p data-start=\"3407\" data-end=\"3469\">Communicating with customers regarding requests or inquiries</p></li><li data-section-id=\"17k5upt\" data-start=\"3470\" data-end=\"3508\"><p data-start=\"3472\" data-end=\"3508\">Improving our website and services</p></li><li data-section-id=\"r2u3g3\" data-start=\"3509\" data-end=\"3580\"><p data-start=\"3511\" data-end=\"3580\">Sending promotional offers or service updates with the user\'s consent</p></li></ul><hr data-start=\"3582\" data-end=\"3585\" style=\"font-size: medium;\"><h2 data-section-id=\"1owb0\" data-start=\"3587\" data-end=\"3608\">4. Data Protection</h2><p data-start=\"3609\" data-end=\"3756\" style=\"font-size: medium;\">Rehltna is committed to implementing appropriate security measures to protect personal information from unauthorized access, misuse, or disclosure.</p><hr data-start=\"3758\" data-end=\"3761\" style=\"font-size: medium;\"><h2 data-section-id=\"17pmosa\" data-start=\"3763\" data-end=\"3788\">5. Information Sharing</h2><p data-start=\"3789\" data-end=\"3891\" style=\"font-size: medium;\">Rehltna does not sell, rent, or trade personal information with third parties for commercial purposes.</p><p data-start=\"3893\" data-end=\"3990\" style=\"font-size: medium;\">Information may only be shared with necessary parties to complete the requested service, such as:</p><ul data-start=\"3992\" data-end=\"4063\" style=\"font-size: medium;\"><li data-section-id=\"8niab3\" data-start=\"3992\" data-end=\"4004\"><p data-start=\"3994\" data-end=\"4004\">Airlines</p></li><li data-section-id=\"1o3zkht\" data-start=\"4005\" data-end=\"4015\"><p data-start=\"4007\" data-end=\"4015\">Hotels</p></li><li data-section-id=\"1qsndv6\" data-start=\"4016\" data-end=\"4036\"><p data-start=\"4018\" data-end=\"4036\">Visa authorities</p></li><li data-section-id=\"9w65xf\" data-start=\"4037\" data-end=\"4063\"><p data-start=\"4039\" data-end=\"4063\">Tourism service partners</p></li></ul><hr data-start=\"4065\" data-end=\"4068\" style=\"font-size: medium;\"><h2 data-section-id=\"tydf3e\" data-start=\"4070\" data-end=\"4083\">6. Cookies</h2><p data-start=\"4084\" data-end=\"4175\" style=\"font-size: medium;\">Our website may use cookies to enhance the user experience and analyze website performance.</p><hr data-start=\"4177\" data-end=\"4180\" style=\"font-size: medium;\"><h2 data-section-id=\"hqhw2m\" data-start=\"4182\" data-end=\"4199\">7. User Rights</h2><p data-start=\"4200\" data-end=\"4224\" style=\"font-size: medium;\">Users have the right to:</p><ul data-start=\"4226\" data-end=\"4416\" style=\"font-size: medium;\"><li data-section-id=\"1wg5scs\" data-start=\"4226\" data-end=\"4267\"><p data-start=\"4228\" data-end=\"4267\">Request access to their personal data</p></li><li data-section-id=\"1mufi55\" data-start=\"4268\" data-end=\"4315\"><p data-start=\"4270\" data-end=\"4315\">Request correction or updates to their data</p></li><li data-section-id=\"sury2a\" data-start=\"4316\" data-end=\"4366\"><p data-start=\"4318\" data-end=\"4366\">Request deletion of their personal information</p></li><li data-section-id=\"1aaj3c5\" data-start=\"4367\" data-end=\"4416\"><p data-start=\"4369\" data-end=\"4416\">Opt out of marketing communications at any time</p></li></ul><hr data-start=\"4418\" data-end=\"4421\" style=\"font-size: medium;\"><h2 data-section-id=\"r87tch\" data-start=\"4423\" data-end=\"4443\">8. Policy Updates</h2><p data-start=\"4444\" data-end=\"4567\" style=\"font-size: medium;\">Rehltna reserves the right to update or modify this Privacy Policy at any time. Any updates will be published on this page.</p><hr data-start=\"4569\" data-end=\"4572\" style=\"font-size: medium;\"><h2 data-section-id=\"oosh78\" data-start=\"4574\" data-end=\"4590\">9. Contact Us</h2><p data-start=\"4591\" data-end=\"4666\" style=\"font-size: medium;\">If you have any questions regarding this Privacy Policy, please contact us:</p><p data-start=\"4668\" data-end=\"4714\" style=\"font-size: medium;\">Email: <a data-start=\"4675\" data-end=\"4691\" class=\"decorated-link cursor-pointer\" rel=\"noopener\">info@rehltna.com<span aria-hidden=\"true\" class=\"ms-0.5 inline-block align-middle leading-none\"><svg xmlns=\"http://www.w3.org/2000/svg\" width=\"20\" height=\"20\" aria-hidden=\"true\" data-rtl-flip=\"\" class=\"block h-[0.75em] w-[0.75em] stroke-current stroke-[0.75]\"><use href=\"/cdn/assets/sprites-core-il7yfj1b.svg#304883\" fill=\"currentColor\"></use></svg></span></a><br data-start=\"4691\" data-end=\"4694\">Phone: +966XXXXXXXXX</p>',NULL,NULL,1,'سياسه الخصوصيه','Privacy Policy',NULL,NULL,'/uploads/tenant_1/general/69b03956cbdab_1773156694_general.png','سياسه الخصوصيه','Privacy Policy',NULL,NULL,'سياسه الخصوصيه','Privacy Policy',NULL,NULL,'2026-03-16 19:08:24','2026-04-03 02:38:41',NULL),
(2,'Privacy',NULL,NULL,'سياسه الخصوصيه','سياسه-الخصوصيه','<h1 data-section-id=\"1dr6uuc\" data-start=\"176\" data-end=\"194\"><span style=\"font-family: Tahoma;\">﻿</span>سياسة الخصوصية</h1><p data-start=\"195\" data-end=\"225\" style=\"font-size: medium;\"><strong data-start=\"195\" data-end=\"225\">شركة رحلتنا للسياحة والسفر</strong></p><h2 data-section-id=\"d3ai4d\" data-start=\"227\" data-end=\"240\">1. المقدمة</h2><p data-start=\"241\" data-end=\"468\" style=\"font-size: medium;\">نحن في شركة <strong data-start=\"253\" data-end=\"278\">رحلتنا للسياحة والسفر</strong> نحترم خصوصية عملائنا ونلتزم بحماية جميع المعلومات الشخصية التي يتم جمعها من خلال موقعنا الإلكتروني أو أثناء استخدام خدماتنا المختلفة مثل حجز الرحلات، استخراج التأشيرات، أو البرامج السياحية.</p><p data-start=\"470\" data-end=\"574\" style=\"font-size: medium;\">تهدف سياسة الخصوصية هذه إلى توضيح كيفية جمع المعلومات واستخدامها وحمايتها عند استخدام موقعنا أو خدماتنا.</p><hr data-start=\"576\" data-end=\"579\" style=\"font-size: medium;\"><h2 data-section-id=\"59svn4\" data-start=\"581\" data-end=\"613\">2. المعلومات التي نقوم بجمعها</h2><p data-start=\"614\" data-end=\"714\" style=\"font-size: medium;\">قد نقوم بجمع بعض المعلومات الشخصية عند استخدامك لموقعنا أو عند طلب أي من خدماتنا، ومن هذه المعلومات:</p><ul data-start=\"716\" data-end=\"911\" style=\"font-size: medium;\"><li data-section-id=\"1g54iik\" data-start=\"716\" data-end=\"732\"><p data-start=\"718\" data-end=\"732\">الاسم الكامل</p></li><li data-section-id=\"mipt7a\" data-start=\"733\" data-end=\"747\"><p data-start=\"735\" data-end=\"747\">رقم الهاتف</p></li><li data-section-id=\"16wzpzd\" data-start=\"748\" data-end=\"769\"><p data-start=\"750\" data-end=\"769\">البريد الإلكتروني</p></li><li data-section-id=\"1l02l1s\" data-start=\"770\" data-end=\"826\"><p data-start=\"772\" data-end=\"826\">بيانات جواز السفر (في حالة خدمات السفر أو التأشيرات)</p></li><li data-section-id=\"1pnoxl8\" data-start=\"827\" data-end=\"860\"><p data-start=\"829\" data-end=\"860\">معلومات الدفع عند إتمام الحجز</p></li><li data-section-id=\"1qqo99r\" data-start=\"861\" data-end=\"911\"><p data-start=\"863\" data-end=\"911\">أي معلومات أخرى يقدمها المستخدم عند التواصل معنا</p></li></ul><hr data-start=\"913\" data-end=\"916\" style=\"font-size: medium;\"><h2 data-section-id=\"1direhh\" data-start=\"918\" data-end=\"947\">3. كيفية استخدام المعلومات</h2><p data-start=\"948\" data-end=\"1008\" style=\"font-size: medium;\">تستخدم شركة رحلتنا المعلومات التي يتم جمعها للأغراض التالية:</p><ul data-start=\"1010\" data-end=\"1266\" style=\"font-size: medium;\"><li data-section-id=\"1smdaob\" data-start=\"1010\" data-end=\"1056\"><p data-start=\"1012\" data-end=\"1056\">إتمام عمليات حجز الرحلات والخدمات السياحية</p></li><li data-section-id=\"kpkux\" data-start=\"1057\" data-end=\"1108\"><p data-start=\"1059\" data-end=\"1108\">إصدار التأشيرات أو إتمام الإجراءات المرتبطة بها</p></li><li data-section-id=\"10txt6i\" data-start=\"1109\" data-end=\"1160\"><p data-start=\"1111\" data-end=\"1160\">التواصل مع العملاء بخصوص الطلبات أو الاستفسارات</p></li><li data-section-id=\"ucb17u\" data-start=\"1161\" data-end=\"1202\"><p data-start=\"1163\" data-end=\"1202\">تحسين جودة الخدمات المقدمة عبر الموقع</p></li><li data-section-id=\"14trw5k\" data-start=\"1203\" data-end=\"1266\"><p data-start=\"1205\" data-end=\"1266\">إرسال العروض أو التحديثات الخاصة بخدماتنا عند موافقة المستخدم</p></li></ul><hr data-start=\"1268\" data-end=\"1271\" style=\"font-size: medium;\"><h2 data-section-id=\"1vqbj54\" data-start=\"1273\" data-end=\"1294\">4. حماية المعلومات</h2><p data-start=\"1295\" data-end=\"1431\" style=\"font-size: medium;\">تلتزم شركة رحلتنا باتخاذ الإجراءات الأمنية المناسبة لحماية المعلومات الشخصية من الوصول غير المصرح به أو الاستخدام أو التعديل أو الإفصاح.</p><hr data-start=\"1433\" data-end=\"1436\" style=\"font-size: medium;\"><h2 data-section-id=\"1p46888\" data-start=\"1438\" data-end=\"1460\">5. مشاركة المعلومات</h2><p data-start=\"1461\" data-end=\"1552\" style=\"font-size: medium;\">لا تقوم شركة رحلتنا ببيع أو تأجير أو مشاركة المعلومات الشخصية مع أي طرف ثالث لأغراض تجارية.</p><p data-start=\"1554\" data-end=\"1618\" style=\"font-size: medium;\">قد يتم مشاركة المعلومات فقط مع الجهات اللازمة لتنفيذ الخدمة مثل:</p><ul data-start=\"1620\" data-end=\"1718\" style=\"font-size: medium;\"><li data-section-id=\"1tpjjfx\" data-start=\"1620\" data-end=\"1637\"><p data-start=\"1622\" data-end=\"1637\">شركات الطيران</p></li><li data-section-id=\"1nqgso6\" data-start=\"1638\" data-end=\"1649\"><p data-start=\"1640\" data-end=\"1649\">الفنادق</p></li><li data-section-id=\"qkvbzx\" data-start=\"1650\" data-end=\"1693\"><p data-start=\"1652\" data-end=\"1693\">الجهات الرسمية المختصة بإصدار التأشيرات</p></li><li data-section-id=\"10mv175\" data-start=\"1694\" data-end=\"1718\"><p data-start=\"1696\" data-end=\"1718\">شركاء الخدمات السياحية</p></li></ul><p data-start=\"1720\" data-end=\"1770\" style=\"font-size: medium;\">وذلك فقط في الحدود اللازمة لإتمام الخدمة المطلوبة.</p><hr data-start=\"1772\" data-end=\"1775\" style=\"font-size: medium;\"><h2 data-section-id=\"1i2zdpk\" data-start=\"1777\" data-end=\"1813\">6. ملفات تعريف الارتباط (Cookies)</h2><p data-start=\"1814\" data-end=\"1911\" style=\"font-size: medium;\">قد يستخدم موقعنا ملفات تعريف الارتباط لتحسين تجربة المستخدم وتحليل أداء الموقع وتقديم خدمات أفضل.</p><hr data-start=\"1913\" data-end=\"1916\" style=\"font-size: medium;\"><h2 data-section-id=\"3u4lwi\" data-start=\"1918\" data-end=\"1937\">7. حقوق المستخدم</h2><p data-start=\"1938\" data-end=\"1951\" style=\"font-size: medium;\">يحق للمستخدم:</p><ul data-start=\"1953\" data-end=\"2107\" style=\"font-size: medium;\"><li data-section-id=\"1kj2bx1\" data-start=\"1953\" data-end=\"1999\"><p data-start=\"1955\" data-end=\"1999\">طلب الاطلاع على البيانات الشخصية الخاصة به</p></li><li data-section-id=\"z03mha\" data-start=\"2000\" data-end=\"2031\"><p data-start=\"2002\" data-end=\"2031\">طلب تعديل أو تحديث البيانات</p></li><li data-section-id=\"1x6i70y\" data-start=\"2032\" data-end=\"2063\"><p data-start=\"2034\" data-end=\"2063\">طلب حذف البيانات من أنظمتنا</p></li><li data-section-id=\"ke9dm3\" data-start=\"2064\" data-end=\"2107\"><p data-start=\"2066\" data-end=\"2107\">إيقاف استقبال الرسائل التسويقية في أي وقت</p></li></ul><hr data-start=\"2109\" data-end=\"2112\" style=\"font-size: medium;\"><h2 data-section-id=\"1ol0l20\" data-start=\"2114\" data-end=\"2140\">8. تحديث سياسة الخصوصية</h2><p data-start=\"2141\" data-end=\"2245\" style=\"font-size: medium;\">تحتفظ شركة رحلتنا بالحق في تعديل أو تحديث سياسة الخصوصية في أي وقت، وسيتم نشر أي تغييرات على هذه الصفحة.</p><hr data-start=\"2247\" data-end=\"2250\" style=\"font-size: medium;\"><h2 data-section-id=\"1j6l2pk\" data-start=\"2252\" data-end=\"2270\">9. التواصل معنا</h2><p data-start=\"2271\" data-end=\"2339\" style=\"font-size: medium;\">في حال وجود أي استفسار بخصوص سياسة الخصوصية يمكنكم التواصل معنا عبر:</p><p data-start=\"2341\" data-end=\"2400\" style=\"font-size: medium;\">البريد الإلكتروني: <a data-start=\"2360\" data-end=\"2376\" class=\"decorated-link cursor-pointer\" rel=\"noopener\">info@rehltna.com<span aria-hidden=\"true\" class=\"ms-0.5 inline-block align-middle leading-none\"><svg xmlns=\"http://www.w3.org/2000/svg\" width=\"20\" height=\"20\" aria-hidden=\"true\" data-rtl-flip=\"\" class=\"block h-[0.75em] w-[0.75em] stroke-current stroke-[0.75]\"><use href=\"/cdn/assets/sprites-core-il7yfj1b.svg#304883\" fill=\"currentColor\"></use></svg></span></a><br data-start=\"2376\" data-end=\"2379\">الهاتف: +966XXXXXXXXX<span style=\"font-family: &quot;Comic Sans MS&quot;;\">﻿</span></p>','<h1 data-section-id=\"bs94m8\" data-start=\"2407\" data-end=\"2425\">Privacy Policy</h1><p data-start=\"2426\" data-end=\"2454\" style=\"font-size: medium;\"><strong data-start=\"2426\" data-end=\"2454\">Rehltna Travel &amp; Tourism</strong></p><h2 data-section-id=\"xgfogq\" data-start=\"2456\" data-end=\"2474\">1. Introduction</h2><p data-start=\"2475\" data-end=\"2725\" style=\"font-size: medium;\">At <strong data-start=\"2478\" data-end=\"2506\">Rehltna Travel &amp; Tourism</strong>, we respect the privacy of our customers and are committed to protecting the personal information collected through our website or when using our services such as travel bookings, visa processing, and tourism programs.</p><p data-start=\"2727\" data-end=\"2843\" style=\"font-size: medium;\">This Privacy Policy explains how we collect, use, and protect your information when you use our website or services.</p><hr data-start=\"2845\" data-end=\"2848\" style=\"font-size: medium;\"><h2 data-section-id=\"5ejyvt\" data-start=\"2850\" data-end=\"2878\">2. Information We Collect</h2><p data-start=\"2879\" data-end=\"2983\" style=\"font-size: medium;\">We may collect certain personal information when you use our website or request our services, including:</p><ul data-start=\"2985\" data-end=\"3190\" style=\"font-size: medium;\"><li data-section-id=\"apwdks\" data-start=\"2985\" data-end=\"2998\"><p data-start=\"2987\" data-end=\"2998\">Full name</p></li><li data-section-id=\"1tzdck7\" data-start=\"2999\" data-end=\"3015\"><p data-start=\"3001\" data-end=\"3015\">Phone number</p></li><li data-section-id=\"wk4jiq\" data-start=\"3016\" data-end=\"3033\"><p data-start=\"3018\" data-end=\"3033\">Email address</p></li><li data-section-id=\"r7c2gu\" data-start=\"3034\" data-end=\"3084\"><p data-start=\"3036\" data-end=\"3084\">Passport details (for travel or visa services)</p></li><li data-section-id=\"qibh0c\" data-start=\"3085\" data-end=\"3133\"><p data-start=\"3087\" data-end=\"3133\">Payment information when completing bookings</p></li><li data-section-id=\"26m99q\" data-start=\"3134\" data-end=\"3190\"><p data-start=\"3136\" data-end=\"3190\">Any additional information provided when contacting us</p></li></ul><hr data-start=\"3192\" data-end=\"3195\" style=\"font-size: medium;\"><h2 data-section-id=\"10c0s1w\" data-start=\"3197\" data-end=\"3230\">3. How We Use Your Information</h2><p data-start=\"3231\" data-end=\"3297\" style=\"font-size: medium;\">Rehltna uses the collected information for the following purposes:</p><ul data-start=\"3299\" data-end=\"3580\" style=\"font-size: medium;\"><li data-section-id=\"160m1v3\" data-start=\"3299\" data-end=\"3350\"><p data-start=\"3301\" data-end=\"3350\">Processing travel bookings and tourism services</p></li><li data-section-id=\"mec4s9\" data-start=\"3351\" data-end=\"3404\"><p data-start=\"3353\" data-end=\"3404\">Handling visa applications and related procedures</p></li><li data-section-id=\"1wa8nfu\" data-start=\"3405\" data-end=\"3469\"><p data-start=\"3407\" data-end=\"3469\">Communicating with customers regarding requests or inquiries</p></li><li data-section-id=\"17k5upt\" data-start=\"3470\" data-end=\"3508\"><p data-start=\"3472\" data-end=\"3508\">Improving our website and services</p></li><li data-section-id=\"r2u3g3\" data-start=\"3509\" data-end=\"3580\"><p data-start=\"3511\" data-end=\"3580\">Sending promotional offers or service updates with the user\'s consent</p></li></ul><hr data-start=\"3582\" data-end=\"3585\" style=\"font-size: medium;\"><h2 data-section-id=\"1owb0\" data-start=\"3587\" data-end=\"3608\">4. Data Protection</h2><p data-start=\"3609\" data-end=\"3756\" style=\"font-size: medium;\">Rehltna is committed to implementing appropriate security measures to protect personal information from unauthorized access, misuse, or disclosure.</p><hr data-start=\"3758\" data-end=\"3761\" style=\"font-size: medium;\"><h2 data-section-id=\"17pmosa\" data-start=\"3763\" data-end=\"3788\">5. Information Sharing</h2><p data-start=\"3789\" data-end=\"3891\" style=\"font-size: medium;\">Rehltna does not sell, rent, or trade personal information with third parties for commercial purposes.</p><p data-start=\"3893\" data-end=\"3990\" style=\"font-size: medium;\">Information may only be shared with necessary parties to complete the requested service, such as:</p><ul data-start=\"3992\" data-end=\"4063\" style=\"font-size: medium;\"><li data-section-id=\"8niab3\" data-start=\"3992\" data-end=\"4004\"><p data-start=\"3994\" data-end=\"4004\">Airlines</p></li><li data-section-id=\"1o3zkht\" data-start=\"4005\" data-end=\"4015\"><p data-start=\"4007\" data-end=\"4015\">Hotels</p></li><li data-section-id=\"1qsndv6\" data-start=\"4016\" data-end=\"4036\"><p data-start=\"4018\" data-end=\"4036\">Visa authorities</p></li><li data-section-id=\"9w65xf\" data-start=\"4037\" data-end=\"4063\"><p data-start=\"4039\" data-end=\"4063\">Tourism service partners</p></li></ul><hr data-start=\"4065\" data-end=\"4068\" style=\"font-size: medium;\"><h2 data-section-id=\"tydf3e\" data-start=\"4070\" data-end=\"4083\">6. Cookies</h2><p data-start=\"4084\" data-end=\"4175\" style=\"font-size: medium;\">Our website may use cookies to enhance the user experience and analyze website performance.</p><hr data-start=\"4177\" data-end=\"4180\" style=\"font-size: medium;\"><h2 data-section-id=\"hqhw2m\" data-start=\"4182\" data-end=\"4199\">7. User Rights</h2><p data-start=\"4200\" data-end=\"4224\" style=\"font-size: medium;\">Users have the right to:</p><ul data-start=\"4226\" data-end=\"4416\" style=\"font-size: medium;\"><li data-section-id=\"1wg5scs\" data-start=\"4226\" data-end=\"4267\"><p data-start=\"4228\" data-end=\"4267\">Request access to their personal data</p></li><li data-section-id=\"1mufi55\" data-start=\"4268\" data-end=\"4315\"><p data-start=\"4270\" data-end=\"4315\">Request correction or updates to their data</p></li><li data-section-id=\"sury2a\" data-start=\"4316\" data-end=\"4366\"><p data-start=\"4318\" data-end=\"4366\">Request deletion of their personal information</p></li><li data-section-id=\"1aaj3c5\" data-start=\"4367\" data-end=\"4416\"><p data-start=\"4369\" data-end=\"4416\">Opt out of marketing communications at any time</p></li></ul><hr data-start=\"4418\" data-end=\"4421\" style=\"font-size: medium;\"><h2 data-section-id=\"r87tch\" data-start=\"4423\" data-end=\"4443\">8. Policy Updates</h2><p data-start=\"4444\" data-end=\"4567\" style=\"font-size: medium;\">Rehltna reserves the right to update or modify this Privacy Policy at any time. Any updates will be published on this page.</p><hr data-start=\"4569\" data-end=\"4572\" style=\"font-size: medium;\"><h2 data-section-id=\"oosh78\" data-start=\"4574\" data-end=\"4590\">9. Contact Us</h2><p data-start=\"4591\" data-end=\"4666\" style=\"font-size: medium;\">If you have any questions regarding this Privacy Policy, please contact us:</p><p data-start=\"4668\" data-end=\"4714\" style=\"font-size: medium;\">Email: <a data-start=\"4675\" data-end=\"4691\" class=\"decorated-link cursor-pointer\" rel=\"noopener\">info@rehltna.com<span aria-hidden=\"true\" class=\"ms-0.5 inline-block align-middle leading-none\"><svg xmlns=\"http://www.w3.org/2000/svg\" width=\"20\" height=\"20\" aria-hidden=\"true\" data-rtl-flip=\"\" class=\"block h-[0.75em] w-[0.75em] stroke-current stroke-[0.75]\"><use href=\"/cdn/assets/sprites-core-il7yfj1b.svg#304883\" fill=\"currentColor\"></use></svg></span></a><br data-start=\"4691\" data-end=\"4694\">Phone: +966XXXXXXXXX</p>',NULL,NULL,1,'سياسه الخصوصيه','Privacy Policy',NULL,NULL,'/uploads/tenant_1/general/69b03956cbdab_1773156694_general.png','سياسه الخصوصيه','Privacy Policy',NULL,NULL,'سياسه الخصوصيه','Privacy Policy',NULL,NULL,'2026-03-16 19:08:58','2026-03-16 19:09:16','2026-03-16 19:09:16'),
(3,'Terms & Conditions',NULL,NULL,'الشروط والأحكام','terms-conditions','<h1 data-section-id=\"8xr74r\" data-start=\"222\" data-end=\"241\">الشروط والأحكام</h1><p data-start=\"242\" data-end=\"272\" style=\"font-size: medium;\"><strong data-start=\"242\" data-end=\"272\">شركة رحلتنا للسياحة والسفر</strong></p><h2 data-section-id=\"4lae8u\" data-start=\"274\" data-end=\"285\">1. مقدمة</h2><p data-start=\"286\" data-end=\"484\" style=\"font-size: medium;\">مرحبًا بكم في موقع <strong data-start=\"305\" data-end=\"335\">شركة رحلتنا للسياحة والسفر</strong>. باستخدام هذا الموقع أو أي من خدماتنا، فإنك توافق على الالتزام بهذه الشروط والأحكام. يرجى قراءة هذه الشروط بعناية قبل استخدام الموقع أو حجز أي خدمة.</p><hr data-start=\"486\" data-end=\"489\" style=\"font-size: medium;\"><h2 data-section-id=\"97i4xd\" data-start=\"491\" data-end=\"511\">2. استخدام الموقع</h2><p data-start=\"512\" data-end=\"665\" style=\"font-size: medium;\">يوافق المستخدم على استخدام الموقع لأغراض قانونية فقط، وعدم استخدامه بطريقة قد تؤدي إلى الإضرار بالموقع أو تعطيله أو التأثير على تجربة المستخدمين الآخرين.</p><p data-start=\"667\" data-end=\"743\" style=\"font-size: medium;\">كما يلتزم المستخدم بتقديم معلومات صحيحة ودقيقة عند إجراء أي حجز أو طلب خدمة.</p><hr data-start=\"745\" data-end=\"748\" style=\"font-size: medium;\"><h2 data-section-id=\"stur4c\" data-start=\"750\" data-end=\"777\">3. خدمات السفر والحجوزات</h2><p data-start=\"778\" data-end=\"838\" style=\"font-size: medium;\">تقدم شركة رحلتنا خدمات متعددة تشمل على سبيل المثال لا الحصر:</p><ul data-start=\"840\" data-end=\"939\" style=\"font-size: medium;\"><li data-section-id=\"12shxqy\" data-start=\"840\" data-end=\"861\"><p data-start=\"842\" data-end=\"861\">حجز تذاكر الطيران</p></li><li data-section-id=\"1cnrvud\" data-start=\"862\" data-end=\"877\"><p data-start=\"864\" data-end=\"877\">حجز الفنادق</p></li><li data-section-id=\"acnd7z\" data-start=\"878\" data-end=\"898\"><p data-start=\"880\" data-end=\"898\">البرامج السياحية</p></li><li data-section-id=\"19ba7hl\" data-start=\"899\" data-end=\"918\"><p data-start=\"901\" data-end=\"918\">خدمات التأشيرات</p></li><li data-section-id=\"1fpeqa4\" data-start=\"919\" data-end=\"939\"><p data-start=\"921\" data-end=\"939\">خدمات الحج والعمرة</p></li></ul><p data-start=\"941\" data-end=\"1031\" style=\"font-size: medium;\">جميع الخدمات تخضع لتوفرها ولشروط مقدمي الخدمات مثل شركات الطيران والفنادق والجهات الرسمية.</p><hr data-start=\"1033\" data-end=\"1036\" style=\"font-size: medium;\"><h2 data-section-id=\"4sw7of\" data-start=\"1038\" data-end=\"1058\">4. الأسعار والدفع</h2><p data-start=\"1059\" data-end=\"1131\" style=\"font-size: medium;\">جميع الأسعار المعروضة على الموقع قابلة للتغيير في أي وقت دون إشعار مسبق.</p><p data-start=\"1133\" data-end=\"1231\" style=\"font-size: medium;\">يجب إتمام عملية الدفع وفق الطرق المتاحة في الموقع، ولا يتم تأكيد الحجز إلا بعد استلام الدفع بنجاح.</p><hr data-start=\"1233\" data-end=\"1236\" style=\"font-size: medium;\"><h2 data-section-id=\"1r23u8k\" data-start=\"1238\" data-end=\"1262\">5. الإلغاء والتعديلات</h2><p data-start=\"1263\" data-end=\"1354\" style=\"font-size: medium;\">قد تخضع عمليات الإلغاء أو تعديل الحجوزات لسياسات مقدمي الخدمة مثل شركات الطيران أو الفنادق.</p><p data-start=\"1356\" data-end=\"1438\" style=\"font-size: medium;\">قد يتم تطبيق رسوم إضافية في حالة الإلغاء أو التعديل حسب شروط الجهة المقدمة للخدمة.</p><hr data-start=\"1440\" data-end=\"1443\" style=\"font-size: medium;\"><h2 data-section-id=\"1wmf1h7\" data-start=\"1445\" data-end=\"1467\">6. مسؤولية المستخدم</h2><p data-start=\"1468\" data-end=\"1540\" style=\"font-size: medium;\">يتحمل المستخدم مسؤولية التأكد من صحة المعلومات المقدمة أثناء الحجز، مثل:</p><ul data-start=\"1542\" data-end=\"1606\" style=\"font-size: medium;\"><li data-section-id=\"dsrc5q\" data-start=\"1542\" data-end=\"1572\"><p data-start=\"1544\" data-end=\"1572\">الاسم كما هو في جواز السفر</p></li><li data-section-id=\"19zacgf\" data-start=\"1573\" data-end=\"1591\"><p data-start=\"1575\" data-end=\"1591\">رقم جواز السفر</p></li><li data-section-id=\"ln7fso\" data-start=\"1592\" data-end=\"1606\"><p data-start=\"1594\" data-end=\"1606\">تواريخ السفر</p></li></ul><p data-start=\"1608\" data-end=\"1679\" style=\"font-size: medium;\">شركة رحلتنا غير مسؤولة عن أي أخطاء في البيانات المدخلة من قبل المستخدم.</p><hr data-start=\"1681\" data-end=\"1684\" style=\"font-size: medium;\"><h2 data-section-id=\"1394jnz\" data-start=\"1686\" data-end=\"1707\">7. تحديد المسؤولية</h2><p data-start=\"1708\" data-end=\"1824\" style=\"font-size: medium;\">لا تتحمل شركة رحلتنا أي مسؤولية عن أي تأخير أو تغيير أو إلغاء يحدث بسبب شركات الطيران أو الفنادق أو الجهات الحكومية.</p><p data-start=\"1826\" data-end=\"1921\" style=\"font-size: medium;\">كما لا تتحمل الشركة مسؤولية أي ظروف خارجة عن السيطرة مثل الكوارث الطبيعية أو القرارات الحكومية.</p><hr data-start=\"1923\" data-end=\"1926\" style=\"font-size: medium;\"><h2 data-section-id=\"yakq02\" data-start=\"1928\" data-end=\"1949\">8. الملكية الفكرية</h2><p data-start=\"1950\" data-end=\"2092\" style=\"font-size: medium;\">جميع المحتويات الموجودة على الموقع بما في ذلك النصوص والصور والشعارات والتصميمات هي ملك لشركة رحلتنا ولا يجوز استخدامها أو نسخها دون إذن مسبق.</p><hr data-start=\"2094\" data-end=\"2097\" style=\"font-size: medium;\"><h2 data-section-id=\"10ig0gz\" data-start=\"2099\" data-end=\"2125\">9. التعديلات على الشروط</h2><p data-start=\"2126\" data-end=\"2234\" style=\"font-size: medium;\">تحتفظ شركة رحلتنا بالحق في تعديل أو تحديث هذه الشروط والأحكام في أي وقت، وسيتم نشر التعديلات على هذه الصفحة.</p><hr data-start=\"2236\" data-end=\"2239\" style=\"font-size: medium;\"><h2 data-section-id=\"1so5mdc\" data-start=\"2241\" data-end=\"2260\">10. التواصل معنا</h2><p data-start=\"2261\" data-end=\"2332\" style=\"font-size: medium;\">في حال وجود أي استفسارات بخصوص الشروط والأحكام يمكنكم التواصل معنا عبر:</p><p data-start=\"2334\" data-end=\"2393\" style=\"font-size: medium;\">البريد الإلكتروني: <a data-start=\"2353\" data-end=\"2369\" class=\"decorated-link cursor-pointer\" rel=\"noopener\">info@rehltna.com<span aria-hidden=\"true\" class=\"ms-0.5 inline-block align-middle leading-none\"><svg xmlns=\"http://www.w3.org/2000/svg\" width=\"20\" height=\"20\" aria-hidden=\"true\" data-rtl-flip=\"\" class=\"block h-[0.75em] w-[0.75em] stroke-current stroke-[0.75]\"><use href=\"/cdn/assets/sprites-core-il7yfj1b.svg#304883\" fill=\"currentColor\"></use></svg></span></a><br data-start=\"2369\" data-end=\"2372\">الهاتف: +966XXXXXXXXX</p>','<h1 data-section-id=\"1betcn1\" data-start=\"2400\" data-end=\"2422\">Terms &amp; Conditions</h1><p data-start=\"2423\" data-end=\"2451\" style=\"font-size: medium;\"><strong data-start=\"2423\" data-end=\"2451\">Rehltna Travel &amp; Tourism</strong></p><h2 data-section-id=\"xgfogq\" data-start=\"2453\" data-end=\"2471\">1. Introduction</h2><p data-start=\"2472\" data-end=\"2697\" style=\"font-size: medium;\">Welcome to the <strong data-start=\"2487\" data-end=\"2515\">Rehltna Travel &amp; Tourism</strong> website. By using this website or any of our services, you agree to comply with these Terms &amp; Conditions. Please read them carefully before using the website or booking any service.</p><hr data-start=\"2699\" data-end=\"2702\" style=\"font-size: medium;\"><h2 data-section-id=\"1v5dd35\" data-start=\"2704\" data-end=\"2721\">2. Website Use</h2><p data-start=\"2722\" data-end=\"2879\" style=\"font-size: medium;\">Users agree to use the website only for lawful purposes and in a way that does not damage, disable, or interfere with the website or other users\' experience.</p><p data-start=\"2881\" data-end=\"2983\" style=\"font-size: medium;\">Users must also provide accurate and complete information when making bookings or requesting services.</p><hr data-start=\"2985\" data-end=\"2988\" style=\"font-size: medium;\"><h2 data-section-id=\"al7v0f\" data-start=\"2990\" data-end=\"3024\">3. Travel Services and Bookings</h2><p data-start=\"3025\" data-end=\"3100\" style=\"font-size: medium;\">Rehltna provides a variety of travel services including but not limited to:</p><ul data-start=\"3102\" data-end=\"3213\" style=\"font-size: medium;\"><li data-section-id=\"j3pwum\" data-start=\"3102\" data-end=\"3128\"><p data-start=\"3104\" data-end=\"3128\">Flight ticket bookings</p></li><li data-section-id=\"1eyzh15\" data-start=\"3129\" data-end=\"3151\"><p data-start=\"3131\" data-end=\"3151\">Hotel reservations</p></li><li data-section-id=\"1niqm5\" data-start=\"3152\" data-end=\"3169\"><p data-start=\"3154\" data-end=\"3169\">Tour packages</p></li><li data-section-id=\"16afvwr\" data-start=\"3170\" data-end=\"3187\"><p data-start=\"3172\" data-end=\"3187\">Visa services</p></li><li data-section-id=\"1hcsxmv\" data-start=\"3188\" data-end=\"3213\"><p data-start=\"3190\" data-end=\"3213\">Hajj and Umrah services</p></li></ul><p data-start=\"3215\" data-end=\"3372\" style=\"font-size: medium;\">All services are subject to availability and the terms and conditions of the respective service providers such as airlines, hotels, and official authorities.</p><hr data-start=\"3374\" data-end=\"3377\" style=\"font-size: medium;\"><h2 data-section-id=\"29ea2u\" data-start=\"3379\" data-end=\"3404\">4. Pricing and Payment</h2><p data-start=\"3405\" data-end=\"3482\" style=\"font-size: medium;\">All prices listed on the website may change at any time without prior notice.</p><p data-start=\"3484\" data-end=\"3575\" style=\"font-size: medium;\">Bookings are confirmed only after successful payment through the available payment methods.</p><hr data-start=\"3577\" data-end=\"3580\" style=\"font-size: medium;\"><h2 data-section-id=\"1chi24c\" data-start=\"3582\" data-end=\"3619\">5. Cancellations and Modifications</h2><p data-start=\"3620\" data-end=\"3734\" style=\"font-size: medium;\">Cancellations or modifications may be subject to the policies of the service providers such as airlines or hotels.</p><p data-start=\"3736\" data-end=\"3809\" style=\"font-size: medium;\">Additional fees may apply depending on the terms of the service provider.</p><hr data-start=\"3811\" data-end=\"3814\" style=\"font-size: medium;\"><h2 data-section-id=\"1ktgrc0\" data-start=\"3816\" data-end=\"3841\">6. User Responsibility</h2><p data-start=\"3842\" data-end=\"3944\" style=\"font-size: medium;\">Users are responsible for ensuring the accuracy of the information provided during booking, including:</p><ul data-start=\"3946\" data-end=\"4016\" style=\"font-size: medium;\"><li data-section-id=\"wjl018\" data-start=\"3946\" data-end=\"3981\"><p data-start=\"3948\" data-end=\"3981\">Name as written in the passport</p></li><li data-section-id=\"m06fr7\" data-start=\"3982\" data-end=\"4001\"><p data-start=\"3984\" data-end=\"4001\">Passport number</p></li><li data-section-id=\"1vi0ztj\" data-start=\"4002\" data-end=\"4016\"><p data-start=\"4004\" data-end=\"4016\">Travel dates</p></li></ul><p data-start=\"4018\" data-end=\"4112\" style=\"font-size: medium;\">Rehltna is not responsible for any errors made by the user when entering personal information.</p><hr data-start=\"4114\" data-end=\"4117\" style=\"font-size: medium;\"><h2 data-section-id=\"1b0l8d6\" data-start=\"4119\" data-end=\"4148\">7. Limitation of Liability</h2><p data-start=\"4149\" data-end=\"4272\" style=\"font-size: medium;\">Rehltna is not responsible for any delays, changes, or cancellations caused by airlines, hotels, or government authorities.</p><p data-start=\"4274\" data-end=\"4399\" style=\"font-size: medium;\">The company is also not responsible for circumstances beyond its control such as natural disasters or governmental decisions.</p><hr data-start=\"4401\" data-end=\"4404\" style=\"font-size: medium;\"><h2 data-section-id=\"ar4ers\" data-start=\"4406\" data-end=\"4433\">8. Intellectual Property</h2><p data-start=\"4434\" data-end=\"4588\" style=\"font-size: medium;\">All content on this website including text, images, logos, and designs are the property of Rehltna and may not be copied or used without prior permission.</p><hr data-start=\"4590\" data-end=\"4593\" style=\"font-size: medium;\"><h2 data-section-id=\"e8wfj5\" data-start=\"4595\" data-end=\"4617\">9. Changes to Terms</h2><p data-start=\"4618\" data-end=\"4743\" style=\"font-size: medium;\">Rehltna reserves the right to modify or update these Terms &amp; Conditions at any time. Any updates will be posted on this page.</p><hr data-start=\"4745\" data-end=\"4748\" style=\"font-size: medium;\"><h2 data-section-id=\"lmqd8m\" data-start=\"4750\" data-end=\"4776\">10. Contact Information</h2><p data-start=\"4777\" data-end=\"4857\" style=\"font-size: medium;\">If you have any questions regarding these Terms &amp; Conditions, please contact us:</p><p data-start=\"4859\" data-end=\"4905\" style=\"font-size: medium;\">Email: <a data-start=\"4866\" data-end=\"4882\" class=\"decorated-link cursor-pointer\" rel=\"noopener\">info@rehltna.com<span aria-hidden=\"true\" class=\"ms-0.5 inline-block align-middle leading-none\"><svg xmlns=\"http://www.w3.org/2000/svg\" width=\"20\" height=\"20\" aria-hidden=\"true\" data-rtl-flip=\"\" class=\"block h-[0.75em] w-[0.75em] stroke-current stroke-[0.75]\"><use href=\"/cdn/assets/sprites-core-il7yfj1b.svg#304883\" fill=\"currentColor\"></use></svg></span></a><br data-start=\"4882\" data-end=\"4885\">Phone: +966XXXXXXXXX</p>',NULL,NULL,1,'الشروط والأحكام','Terms -Conditions',NULL,NULL,'/uploads/tenant_1/general/69b03956cbdab_1773156694_general.png','الشروط والأحكام','Terms -Conditions',NULL,NULL,'الشروط والأحكام','Terms -Conditions',NULL,NULL,'2026-03-16 19:13:05','2026-03-16 19:13:05',NULL);
/*!40000 ALTER TABLE `custom_pages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `disease_types`
--

DROP TABLE IF EXISTS `disease_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `disease_types` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name_en` varchar(191) DEFAULT NULL,
  `name_de` varchar(191) DEFAULT NULL,
  `name_fr` varchar(191) DEFAULT NULL,
  `name_ar` varchar(191) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `disease_types`
--

LOCK TABLES `disease_types` WRITE;
/*!40000 ALTER TABLE `disease_types` DISABLE KEYS */;
/*!40000 ALTER TABLE `disease_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `error_uploadeds`
--

DROP TABLE IF EXISTS `error_uploadeds`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `error_uploadeds` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `title_en` varchar(191) DEFAULT NULL,
  `title_de` varchar(191) DEFAULT NULL,
  `title_fr` varchar(191) DEFAULT NULL,
  `title_ar` varchar(191) DEFAULT NULL,
  `short_description_en` text DEFAULT NULL,
  `short_description_de` text DEFAULT NULL,
  `short_description_fr` text DEFAULT NULL,
  `short_description_ar` text DEFAULT NULL,
  `meta_title_ar` varchar(191) DEFAULT NULL,
  `meta_title_en` varchar(191) DEFAULT NULL,
  `meta_title_de` varchar(191) DEFAULT NULL,
  `meta_title_fr` varchar(191) DEFAULT NULL,
  `meta_img` text DEFAULT NULL,
  `meta_description_ar` text DEFAULT NULL,
  `meta_description_en` text DEFAULT NULL,
  `meta_description_de` text DEFAULT NULL,
  `meta_description_fr` text DEFAULT NULL,
  `meta_keywords_ar` text DEFAULT NULL,
  `meta_keywords_en` text DEFAULT NULL,
  `meta_keywords_de` text DEFAULT NULL,
  `meta_keywords_fr` text DEFAULT NULL,
  `banner_en` varchar(191) DEFAULT NULL,
  `banner_de` varchar(191) DEFAULT NULL,
  `banner_fr` varchar(191) DEFAULT NULL,
  `banner_ar` varchar(191) DEFAULT NULL,
  `image` varchar(191) DEFAULT NULL,
  `type` varchar(191) DEFAULT NULL,
  `price` decimal(8,2) DEFAULT NULL,
  `item_type_id` bigint(20) DEFAULT NULL,
  `is_feature` tinyint(4) DEFAULT NULL,
  `status` tinyint(4) DEFAULT NULL,
  `description_ar` longtext DEFAULT NULL,
  `description_en` longtext DEFAULT NULL,
  `description_de` longtext DEFAULT NULL,
  `description_fr` longtext DEFAULT NULL,
  `errors` longtext DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `error_uploadeds`
--

LOCK TABLES `error_uploadeds` WRITE;
/*!40000 ALTER TABLE `error_uploadeds` DISABLE KEYS */;
/*!40000 ALTER TABLE `error_uploadeds` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `event_galleries`
--

DROP TABLE IF EXISTS `event_galleries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `event_galleries` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `country_id` bigint(20) unsigned DEFAULT NULL,
  `title_ar` varchar(191) DEFAULT NULL,
  `title_en` varchar(191) DEFAULT NULL,
  `title_de` varchar(191) DEFAULT NULL,
  `title_fr` varchar(191) DEFAULT NULL,
  `meta_title_ar` varchar(191) DEFAULT NULL,
  `meta_title_en` varchar(191) DEFAULT NULL,
  `meta_title_de` varchar(191) DEFAULT NULL,
  `meta_title_fr` varchar(191) DEFAULT NULL,
  `meta_img` text DEFAULT NULL,
  `meta_description_ar` text DEFAULT NULL,
  `meta_description_en` text DEFAULT NULL,
  `meta_description_de` text DEFAULT NULL,
  `meta_description_fr` text DEFAULT NULL,
  `meta_keywords_ar` text DEFAULT NULL,
  `meta_keywords_en` text DEFAULT NULL,
  `meta_keywords_de` text DEFAULT NULL,
  `meta_keywords_fr` text DEFAULT NULL,
  `status` tinyint(4) NOT NULL DEFAULT 0,
  `is_feature` tinyint(4) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `order` varchar(191) DEFAULT '0',
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `event_galleries_country_id_foreign` (`country_id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `event_galleries`
--

LOCK TABLES `event_galleries` WRITE;
/*!40000 ALTER TABLE `event_galleries` DISABLE KEYS */;
INSERT INTO `event_galleries` VALUES
(1,3,'فعاليات رحلة فرنسا وبلجيكا وهولندا – أبريل 2026','فعاليات رحلة فرنسا وبلجيكا وهولندا – أبريل 2026',NULL,NULL,'فعاليات رحلة فرنسا وبلجيكا وهولندا – أبريل 2026','France, Belgium & Netherlands Trip Activities – April 2026',NULL,NULL,'/uploads/tenant_1/تغطية فرنسا بلجيكا هولندا أبريل 2026/69e9d15910752_1776931161_general.jpeg','اكتشف أجمل فعاليات ومعالم رحلة فرنسا وبلجيكا وهولندا في أبريل 2026، بما يشمل باريس، بروكسل، وأمستردام مع تجربة سياحية مميزة.','Explore the highlights and activities of the France, Belgium, and Netherlands trip in April 2026, featuring Paris, Brussels, and Amsterdam.',NULL,NULL,'رحلة فرنسا، بلجيكا، هولندا، أبريل 2026، سياحة أوروبا، باريس، بروكسل، أمستردام، برامج سياحية، رحلات أوروبية','France trip, Belgium travel, Netherlands tour, Europe travel April 2026, Paris, Brussels, Amsterdam, travel itinerary, Europe tours',NULL,NULL,1,1,'2026-04-22 03:39:55','2026-04-23 14:19:33','1',NULL);
/*!40000 ALTER TABLE `event_galleries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `events`
--

DROP TABLE IF EXISTS `events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `events` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `title_ar` varchar(191) DEFAULT NULL,
  `title_en` varchar(191) DEFAULT NULL,
  `title_de` varchar(191) DEFAULT NULL,
  `title_fr` varchar(191) DEFAULT NULL,
  `slug_en` varchar(191) DEFAULT NULL,
  `slug_de` varchar(191) DEFAULT NULL,
  `slug_fr` varchar(191) DEFAULT NULL,
  `slug_ar` varchar(191) DEFAULT NULL,
  `link` varchar(191) DEFAULT NULL,
  `is_feature` tinyint(4) NOT NULL DEFAULT 0,
  `short_description_ar` text DEFAULT NULL,
  `short_description_en` text DEFAULT NULL,
  `short_description_de` text DEFAULT NULL,
  `short_description_fr` text DEFAULT NULL,
  `description_ar` longtext DEFAULT NULL,
  `description_en` longtext DEFAULT NULL,
  `description_de` longtext DEFAULT NULL,
  `description_fr` longtext DEFAULT NULL,
  `banner_en` text DEFAULT NULL,
  `banner_de` varchar(191) DEFAULT NULL,
  `banner_fr` varchar(191) DEFAULT NULL,
  `banner_ar` text DEFAULT NULL,
  `meta_title_ar` varchar(191) DEFAULT NULL,
  `meta_title_en` varchar(191) DEFAULT NULL,
  `meta_title_de` varchar(191) DEFAULT NULL,
  `meta_title_fr` varchar(191) DEFAULT NULL,
  `meta_img` text DEFAULT NULL,
  `meta_description_ar` text DEFAULT NULL,
  `meta_description_en` text DEFAULT NULL,
  `meta_description_de` text DEFAULT NULL,
  `meta_description_fr` text DEFAULT NULL,
  `meta_keywords_ar` text DEFAULT NULL,
  `meta_keywords_en` text DEFAULT NULL,
  `meta_keywords_de` text DEFAULT NULL,
  `meta_keywords_fr` text DEFAULT NULL,
  `status` tinyint(4) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `order` varchar(191) DEFAULT '0',
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `events`
--

LOCK TABLES `events` WRITE;
/*!40000 ALTER TABLE `events` DISABLE KEYS */;
/*!40000 ALTER TABLE `events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `failed_jobs`
--

DROP TABLE IF EXISTS `failed_jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `failed_jobs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `uuid` varchar(191) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `failed_jobs`
--

LOCK TABLES `failed_jobs` WRITE;
/*!40000 ALTER TABLE `failed_jobs` DISABLE KEYS */;
/*!40000 ALTER TABLE `failed_jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `folders`
--

DROP TABLE IF EXISTS `folders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `folders` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(191) NOT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `folders`
--

LOCK TABLES `folders` WRITE;
/*!40000 ALTER TABLE `folders` DISABLE KEYS */;
INSERT INTO `folders` VALUES
(1,'icons',NULL,'2026-04-20 02:38:38','2026-04-20 02:38:38'),
(2,'تركيا','2026-04-21 02:30:57','2026-04-21 02:30:42','2026-04-21 02:30:57'),
(3,'تركيا',NULL,'2026-04-21 02:30:43','2026-04-21 02:30:43'),
(4,'موسكو','2026-04-21 02:31:33','2026-04-21 02:31:24','2026-04-21 02:31:33'),
(5,'موسكو','2026-04-21 02:31:36','2026-04-21 02:31:26','2026-04-21 02:31:36'),
(6,'روسيا',NULL,'2026-04-21 02:31:44','2026-04-21 02:31:44'),
(7,'تغطياتنا',NULL,'2026-04-23 13:43:16','2026-04-23 13:43:16'),
(8,'تغطية فرنسا بلجيكا هولندا أبريل 2026',NULL,'2026-04-23 13:44:00','2026-04-23 13:44:00'),
(9,'البوسنة',NULL,'2026-04-25 20:03:46','2026-04-25 20:03:46');
/*!40000 ALTER TABLE `folders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `galleries`
--

DROP TABLE IF EXISTS `galleries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `galleries` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `image` varchar(191) NOT NULL,
  `galleryable_type` varchar(191) DEFAULT NULL,
  `galleryable_id` bigint(20) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `type` varchar(191) NOT NULL DEFAULT 'general',
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `galleries_galleryable_type_galleryable_id_index` (`galleryable_type`,`galleryable_id`),
  KEY `galleries_type_index` (`type`)
) ENGINE=MyISAM AUTO_INCREMENT=392 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `galleries`
--

LOCK TABLES `galleries` WRITE;
/*!40000 ALTER TABLE `galleries` DISABLE KEYS */;
INSERT INTO `galleries` VALUES
(8,'uploads/tenant_1/general/69b03d821860b_1773157762_general.webp',NULL,NULL,'2026-03-10 21:49:22','2026-03-10 21:49:22','general',NULL),
(5,'uploads/tenant_1/general/69b03956cbdab_1773156694_general.png',NULL,NULL,'2026-03-10 21:31:34','2026-03-10 21:31:34','general',NULL),
(6,'uploads/tenant_1/general/69b03d8201c59_1773157762_general.webp',NULL,NULL,'2026-03-10 21:49:22','2026-03-10 21:49:22','general',NULL),
(7,'uploads/tenant_1/general/69b03d8217b09_1773157762_general.webp',NULL,NULL,'2026-03-10 21:49:22','2026-03-10 21:49:22','general',NULL),
(9,'uploads/tenant_1/general/69b03d8218eda_1773157762_general.webp',NULL,NULL,'2026-03-10 21:49:22','2026-03-10 21:49:22','general',NULL),
(10,'uploads/tenant_1/general/69b03d8219765_1773157762_general.webp',NULL,NULL,'2026-03-10 21:49:22','2026-03-10 21:49:22','general',NULL),
(11,'uploads/tenant_1/general/69b08d389b93a_1773178168_general.webp',NULL,NULL,'2026-03-11 03:29:28','2026-03-11 03:29:28','general',NULL),
(12,'uploads/tenant_1/general/69b08d38a9338_1773178168_general.webp',NULL,NULL,'2026-03-11 03:29:28','2026-03-11 03:29:28','general',NULL),
(13,'uploads/tenant_1/general/69b08d38a9c59_1773178168_general.webp',NULL,NULL,'2026-03-11 03:29:28','2026-03-11 03:29:28','general',NULL),
(14,'uploads/tenant_1/general/69b08d38aa507_1773178168_general.webp',NULL,NULL,'2026-03-11 03:29:28','2026-03-11 03:29:28','general',NULL),
(198,'uploads/tenant_1/تغطية فرنسا بلجيكا هولندا أبريل 2026/69e9cf236d3a3_1776930595_video.mp4','App\\Models\\Folder',8,'2026-04-23 13:49:55','2026-04-23 13:49:55','video',NULL),
(16,'uploads/tenant_1/general/69b08d38ab52f_1773178168_general.webp',NULL,NULL,'2026-03-11 03:29:28','2026-03-11 03:29:28','general',NULL),
(17,'uploads/tenant_1/general/69b2bd080a257_1773321480_general.jpeg',NULL,NULL,'2026-03-12 19:18:00','2026-03-12 19:18:00','general',NULL),
(18,'uploads/tenant_1/general/69b2bd080cd94_1773321480_general.jpeg',NULL,NULL,'2026-03-12 19:18:00','2026-03-12 19:18:00','general',NULL),
(19,'uploads/tenant_1/general/69b2bd080d6d9_1773321480_general.jpeg',NULL,NULL,'2026-03-12 19:18:00','2026-03-12 19:18:00','general',NULL),
(20,'uploads/tenant_1/general/69b2bd080de77_1773321480_general.jpeg',NULL,NULL,'2026-03-12 19:18:00','2026-03-12 19:18:00','general',NULL),
(377,'/uploads/tenant_1/general/69c405d0f32f8_1774454224_general.pdf','App\\Models\\Item',6,'2026-04-26 15:51:28','2026-04-26 15:51:28','private',NULL),
(114,'uploads/tenant_1/icons/69e53d89a3d29_1776631177_general.png','App\\Models\\Folder',1,'2026-04-20 02:39:37','2026-04-20 02:39:37','general',NULL),
(193,'uploads/tenant_1/روسيا/69e939c808171_1776892360_general.jpg','App\\Models\\Folder',6,'2026-04-23 03:12:40','2026-04-23 03:12:40','general',NULL),
(192,'uploads/tenant_1/روسيا/69e939c807bac_1776892360_general.jpg','App\\Models\\Folder',6,'2026-04-23 03:12:40','2026-04-23 03:12:40','general',NULL),
(191,'uploads/tenant_1/روسيا/69e939c8075f4_1776892360_general.jpg','App\\Models\\Folder',6,'2026-04-23 03:12:40','2026-04-23 03:12:40','general',NULL),
(391,'/uploads/tenant_1/general/69ee021d26a33_1777205789_general.png','App\\Models\\Item',1,'2026-04-26 22:43:18','2026-04-26 22:43:18','general',NULL),
(222,'/uploads/tenant_1/تغطية فرنسا بلجيكا هولندا أبريل 2026/69e9d15914f22_1776931161_general.jpeg','App\\Models\\EventGallery',1,'2026-04-23 14:19:33','2026-04-23 14:19:33','general',NULL),
(221,'/uploads/tenant_1/تغطية فرنسا بلجيكا هولندا أبريل 2026/69e9d159146cc_1776931161_general.jpeg','App\\Models\\EventGallery',1,'2026-04-23 14:19:33','2026-04-23 14:19:33','general',NULL),
(220,'/uploads/tenant_1/تغطية فرنسا بلجيكا هولندا أبريل 2026/69e9d15913c9c_1776931161_general.jpeg','App\\Models\\EventGallery',1,'2026-04-23 14:19:33','2026-04-23 14:19:33','general',NULL),
(219,'/uploads/tenant_1/تغطية فرنسا بلجيكا هولندا أبريل 2026/69e9d15910752_1776931161_general.jpeg','App\\Models\\EventGallery',1,'2026-04-23 14:19:32','2026-04-23 14:19:32','general',NULL),
(188,'uploads/tenant_1/روسيا/69e939c805b49_1776892360_general.jpg','App\\Models\\Folder',6,'2026-04-23 03:12:40','2026-04-23 03:12:40','general',NULL),
(189,'uploads/tenant_1/روسيا/69e939c806b45_1776892360_general.jpg','App\\Models\\Folder',6,'2026-04-23 03:12:40','2026-04-23 03:12:40','general',NULL),
(190,'uploads/tenant_1/روسيا/69e939c8070b3_1776892360_general.jpg','App\\Models\\Folder',6,'2026-04-23 03:12:40','2026-04-23 03:12:40','general',NULL),
(206,'uploads/tenant_1/تغطية فرنسا بلجيكا هولندا أبريل 2026/69e9d07261d1c_1776930930_video.mp4','App\\Models\\Folder',8,'2026-04-23 13:55:30','2026-04-23 13:55:30','video',NULL),
(197,'uploads/tenant_1/تغطية فرنسا بلجيكا هولندا أبريل 2026/69e9cf23640e7_1776930595_video.mp4','App\\Models\\Folder',8,'2026-04-23 13:49:55','2026-04-23 13:49:55','video',NULL),
(48,'uploads/tenant_1/general/69b9c1ef540fc_1773781487_general.jpeg','App\\Models\\Folder',3,'2026-03-18 03:04:47','2026-04-21 02:31:12','general',NULL),
(49,'uploads/tenant_1/general/69b9c1ef54bac_1773781487_general.jpeg','App\\Models\\Folder',3,'2026-03-18 03:04:47','2026-04-21 02:31:07','general',NULL),
(50,'uploads/tenant_1/general/69b9c1ef54f42_1773781487_general.jpeg','App\\Models\\Folder',3,'2026-03-18 03:04:47','2026-04-21 02:31:02','general',NULL),
(194,'uploads/tenant_1/روسيا/69e939c80994e_1776892360_general.jpg','App\\Models\\Folder',6,'2026-04-23 03:12:40','2026-04-23 03:12:40','general',NULL),
(195,'uploads/tenant_1/روسيا/69e939c809fb8_1776892360_general.jpg','App\\Models\\Folder',6,'2026-04-23 03:12:40','2026-04-23 03:12:40','general',NULL),
(199,'uploads/tenant_1/تغطية فرنسا بلجيكا هولندا أبريل 2026/69e9cf2375eeb_1776930595_video.mp4','App\\Models\\Folder',8,'2026-04-23 13:49:55','2026-04-23 13:49:55','video',NULL),
(200,'uploads/tenant_1/تغطية فرنسا بلجيكا هولندا أبريل 2026/69e9cf237dc79_1776930595_video.mp4','App\\Models\\Folder',8,'2026-04-23 13:49:55','2026-04-23 13:49:55','video',NULL),
(205,'uploads/tenant_1/تغطية فرنسا بلجيكا هولندا أبريل 2026/69e9d0725ce8a_1776930930_video.mp4','App\\Models\\Folder',8,'2026-04-23 13:55:30','2026-04-23 13:55:30','video',NULL),
(204,'uploads/tenant_1/تغطية فرنسا بلجيكا هولندا أبريل 2026/69e9d07258588_1776930930_video.mp4','App\\Models\\Folder',8,'2026-04-23 13:55:30','2026-04-23 13:55:30','video',NULL),
(203,'uploads/tenant_1/تغطية فرنسا بلجيكا هولندا أبريل 2026/69e9d07251c5b_1776930930_video.mp4','App\\Models\\Folder',8,'2026-04-23 13:55:30','2026-04-23 13:55:30','video',NULL),
(202,'uploads/tenant_1/تغطية فرنسا بلجيكا هولندا أبريل 2026/69e9d0724cdfc_1776930930_video.mp4','App\\Models\\Folder',8,'2026-04-23 13:55:30','2026-04-23 13:55:30','video',NULL),
(201,'uploads/tenant_1/تغطية فرنسا بلجيكا هولندا أبريل 2026/69e9d07247c69_1776930930_general.jpeg','App\\Models\\Folder',8,'2026-04-23 13:55:30','2026-04-23 13:55:30','general',NULL),
(115,'uploads/tenant_1/icons/69e53d89a882b_1776631177_general.png','App\\Models\\Folder',1,'2026-04-20 02:39:37','2026-04-20 02:39:37','general',NULL),
(116,'uploads/tenant_1/icons/69e53d89a949d_1776631177_general.png','App\\Models\\Folder',1,'2026-04-20 02:39:37','2026-04-20 02:39:37','general',NULL),
(117,'uploads/tenant_1/icons/69e53d89a9f2e_1776631177_general.png','App\\Models\\Folder',1,'2026-04-20 02:39:37','2026-04-20 02:39:37','general',NULL),
(118,'uploads/tenant_1/icons/69e53d89aa9dd_1776631177_general.png','App\\Models\\Folder',1,'2026-04-20 02:39:37','2026-04-20 02:39:37','general',NULL),
(119,'uploads/tenant_1/icons/69e53d89ab569_1776631177_general.png','App\\Models\\Folder',1,'2026-04-20 02:39:37','2026-04-20 02:39:37','general',NULL),
(120,'uploads/tenant_1/icons/69e53d89abdf7_1776631177_general.png','App\\Models\\Folder',1,'2026-04-20 02:39:37','2026-04-20 02:39:37','general',NULL),
(121,'uploads/tenant_1/icons/69e53d89ac55a_1776631177_general.png','App\\Models\\Folder',1,'2026-04-20 02:39:37','2026-04-20 02:39:37','general',NULL),
(122,'uploads/tenant_1/icons/69e53d89acbbc_1776631177_general.png','App\\Models\\Folder',1,'2026-04-20 02:39:37','2026-04-20 02:39:37','general',NULL),
(123,'uploads/tenant_1/icons/69e53d89ad234_1776631177_general.png','App\\Models\\Folder',1,'2026-04-20 02:39:37','2026-04-20 02:39:37','general',NULL),
(124,'uploads/tenant_1/icons/69e53d89ad70a_1776631177_general.png','App\\Models\\Folder',1,'2026-04-20 02:39:37','2026-04-20 02:39:37','general',NULL),
(125,'uploads/tenant_1/icons/69e53d89adcde_1776631177_general.png','App\\Models\\Folder',1,'2026-04-20 02:39:37','2026-04-20 02:39:37','general',NULL),
(126,'uploads/tenant_1/icons/69e53d89ae9b1_1776631177_general.png','App\\Models\\Folder',1,'2026-04-20 02:39:37','2026-04-20 02:39:37','general',NULL),
(127,'uploads/tenant_1/icons/69e53d89af127_1776631177_general.png','App\\Models\\Folder',1,'2026-04-20 02:39:37','2026-04-20 02:39:37','general',NULL),
(128,'uploads/tenant_1/icons/69e53d89afb04_1776631177_general.png','App\\Models\\Folder',1,'2026-04-20 02:39:37','2026-04-20 02:39:37','general',NULL),
(129,'uploads/tenant_1/icons/69e53d89b2468_1776631177_general.png','App\\Models\\Folder',1,'2026-04-20 02:39:37','2026-04-20 02:39:37','general',NULL),
(130,'uploads/tenant_1/icons/69e53d89b3216_1776631177_general.png','App\\Models\\Folder',1,'2026-04-20 02:39:37','2026-04-20 02:39:37','general',NULL),
(131,'uploads/tenant_1/icons/69e53d89b37ae_1776631177_general.png','App\\Models\\Folder',1,'2026-04-20 02:39:37','2026-04-20 02:39:37','general',NULL),
(132,'uploads/tenant_1/icons/69e53d89b3d7a_1776631177_general.png','App\\Models\\Folder',1,'2026-04-20 02:39:37','2026-04-20 02:39:37','general',NULL),
(133,'uploads/tenant_1/icons/69e53d89b43ce_1776631177_general.png','App\\Models\\Folder',1,'2026-04-20 02:39:37','2026-04-20 02:39:37','general',NULL),
(146,'uploads/tenant_1/روسيا/69e68d44aca98_1776717124_general.jpeg','App\\Models\\Folder',6,'2026-04-21 02:32:04','2026-04-21 02:32:04','general',NULL),
(147,'uploads/tenant_1/روسيا/69e68d44addb8_1776717124_general.jpeg','App\\Models\\Folder',6,'2026-04-21 02:32:04','2026-04-21 02:32:04','general',NULL),
(148,'uploads/tenant_1/روسيا/69e68d44ae311_1776717124_general.jpeg','App\\Models\\Folder',6,'2026-04-21 02:32:04','2026-04-21 02:32:04','general',NULL),
(149,'uploads/tenant_1/روسيا/69e68d44ae800_1776717124_general.jpeg','App\\Models\\Folder',6,'2026-04-21 02:32:04','2026-04-21 02:32:04','general',NULL),
(286,'uploads/tenant_1/روسيا/69e9f6f51be5c_1776940789_general.jpeg','App\\Models\\Folder',6,'2026-04-23 16:39:49','2026-04-23 16:39:49','general',NULL),
(375,'/uploads/tenant_1/روسيا/69e68d44ae311_1776717124_general.jpeg','App\\Models\\Item',6,'2026-04-26 15:51:28','2026-04-26 15:51:28','general',NULL),
(374,'/uploads/tenant_1/روسيا/69e939c807bac_1776892360_general.jpg','App\\Models\\Item',6,'2026-04-26 15:51:28','2026-04-26 15:51:28','general',NULL),
(196,'uploads/tenant_1/روسيا/69e939c80a4e3_1776892360_general.jpg','App\\Models\\Folder',6,'2026-04-23 03:12:40','2026-04-23 03:12:40','general',NULL),
(207,'uploads/tenant_1/تغطية فرنسا بلجيكا هولندا أبريل 2026/69e9d0726c451_1776930930_video.mp4','App\\Models\\Folder',8,'2026-04-23 13:55:30','2026-04-23 13:55:30','video',NULL),
(208,'uploads/tenant_1/تغطية فرنسا بلجيكا هولندا أبريل 2026/69e9d15910752_1776931161_general.jpeg','App\\Models\\Folder',8,'2026-04-23 13:59:21','2026-04-23 13:59:21','general',NULL),
(209,'uploads/tenant_1/تغطية فرنسا بلجيكا هولندا أبريل 2026/69e9d15913c9c_1776931161_general.jpeg','App\\Models\\Folder',8,'2026-04-23 13:59:21','2026-04-23 13:59:21','general',NULL),
(210,'uploads/tenant_1/تغطية فرنسا بلجيكا هولندا أبريل 2026/69e9d159146cc_1776931161_general.jpeg','App\\Models\\Folder',8,'2026-04-23 13:59:21','2026-04-23 13:59:21','general',NULL),
(211,'uploads/tenant_1/تغطية فرنسا بلجيكا هولندا أبريل 2026/69e9d15914f22_1776931161_general.jpeg','App\\Models\\Folder',8,'2026-04-23 13:59:21','2026-04-23 13:59:21','general',NULL),
(212,'uploads/tenant_1/تغطية فرنسا بلجيكا هولندا أبريل 2026/69e9d159156a2_1776931161_general.jpeg','App\\Models\\Folder',8,'2026-04-23 13:59:21','2026-04-23 13:59:21','general',NULL),
(213,'uploads/tenant_1/تغطية فرنسا بلجيكا هولندا أبريل 2026/69e9d15915dac_1776931161_general.jpeg','App\\Models\\Folder',8,'2026-04-23 13:59:21','2026-04-23 13:59:21','general',NULL),
(214,'uploads/tenant_1/تغطية فرنسا بلجيكا هولندا أبريل 2026/69e9d1591695e_1776931161_general.jpeg','App\\Models\\Folder',8,'2026-04-23 13:59:21','2026-04-23 13:59:21','general',NULL),
(215,'uploads/tenant_1/تغطية فرنسا بلجيكا هولندا أبريل 2026/69e9d1591967d_1776931161_video.mp4','App\\Models\\Folder',8,'2026-04-23 13:59:21','2026-04-23 13:59:21','video',NULL),
(216,'uploads/tenant_1/تغطية فرنسا بلجيكا هولندا أبريل 2026/69e9d1591fbb3_1776931161_video.mp4','App\\Models\\Folder',8,'2026-04-23 13:59:21','2026-04-23 13:59:21','video',NULL),
(217,'uploads/tenant_1/تغطية فرنسا بلجيكا هولندا أبريل 2026/69e9d15928049_1776931161_video.mp4','App\\Models\\Folder',8,'2026-04-23 13:59:21','2026-04-23 13:59:21','video',NULL),
(218,'uploads/tenant_1/تغطية فرنسا بلجيكا هولندا أبريل 2026/69e9d15930591_1776931161_video.mp4','App\\Models\\Folder',8,'2026-04-23 13:59:21','2026-04-23 13:59:21','video',NULL),
(223,'/uploads/tenant_1/تغطية فرنسا بلجيكا هولندا أبريل 2026/69e9d159156a2_1776931161_general.jpeg','App\\Models\\EventGallery',1,'2026-04-23 14:19:33','2026-04-23 14:19:33','general',NULL),
(224,'/uploads/tenant_1/تغطية فرنسا بلجيكا هولندا أبريل 2026/69e9d15915dac_1776931161_general.jpeg','App\\Models\\EventGallery',1,'2026-04-23 14:19:33','2026-04-23 14:19:33','general',NULL),
(225,'/uploads/tenant_1/تغطية فرنسا بلجيكا هولندا أبريل 2026/69e9d1591967d_1776931161_video.mp4','App\\Models\\EventGallery',1,'2026-04-23 14:19:33','2026-04-23 14:19:33','general',NULL),
(226,'/uploads/tenant_1/تغطية فرنسا بلجيكا هولندا أبريل 2026/69e9d1591695e_1776931161_general.jpeg','App\\Models\\EventGallery',1,'2026-04-23 14:19:33','2026-04-23 14:19:33','general',NULL),
(227,'/uploads/tenant_1/تغطية فرنسا بلجيكا هولندا أبريل 2026/69e9d1591fbb3_1776931161_video.mp4','App\\Models\\EventGallery',1,'2026-04-23 14:19:33','2026-04-23 14:19:33','general',NULL),
(228,'/uploads/tenant_1/تغطية فرنسا بلجيكا هولندا أبريل 2026/69e9d0726c451_1776930930_video.mp4','App\\Models\\EventGallery',1,'2026-04-23 14:19:33','2026-04-23 14:19:33','general',NULL),
(229,'/uploads/tenant_1/تغطية فرنسا بلجيكا هولندا أبريل 2026/69e9d07247c69_1776930930_general.jpeg','App\\Models\\EventGallery',1,'2026-04-23 14:19:33','2026-04-23 14:19:33','general',NULL),
(230,'/uploads/tenant_1/تغطية فرنسا بلجيكا هولندا أبريل 2026/69e9d0724cdfc_1776930930_video.mp4','App\\Models\\EventGallery',1,'2026-04-23 14:19:33','2026-04-23 14:19:33','general',NULL),
(231,'/uploads/tenant_1/تغطية فرنسا بلجيكا هولندا أبريل 2026/69e9d07251c5b_1776930930_video.mp4','App\\Models\\EventGallery',1,'2026-04-23 14:19:33','2026-04-23 14:19:33','general',NULL),
(232,'/uploads/tenant_1/تغطية فرنسا بلجيكا هولندا أبريل 2026/69e9d07258588_1776930930_video.mp4','App\\Models\\EventGallery',1,'2026-04-23 14:19:33','2026-04-23 14:19:33','general',NULL),
(233,'/uploads/tenant_1/تغطية فرنسا بلجيكا هولندا أبريل 2026/69e9d0725ce8a_1776930930_video.mp4','App\\Models\\EventGallery',1,'2026-04-23 14:19:33','2026-04-23 14:19:33','general',NULL),
(234,'/uploads/tenant_1/تغطية فرنسا بلجيكا هولندا أبريل 2026/69e9d07261d1c_1776930930_video.mp4','App\\Models\\EventGallery',1,'2026-04-23 14:19:33','2026-04-23 14:19:33','general',NULL),
(235,'/uploads/tenant_1/تغطية فرنسا بلجيكا هولندا أبريل 2026/69e9d15930591_1776931161_video.mp4','App\\Models\\EventGallery',1,'2026-04-23 14:19:33','2026-04-23 14:19:33','general',NULL),
(236,'/uploads/tenant_1/تغطية فرنسا بلجيكا هولندا أبريل 2026/69e9d15928049_1776931161_video.mp4','App\\Models\\EventGallery',1,'2026-04-23 14:19:33','2026-04-23 14:19:33','general',NULL),
(237,'/uploads/tenant_1/تغطية فرنسا بلجيكا هولندا أبريل 2026/69e9cf236d3a3_1776930595_video.mp4','App\\Models\\EventGallery',1,'2026-04-23 14:19:33','2026-04-23 14:19:33','general',NULL),
(238,'/uploads/tenant_1/تغطية فرنسا بلجيكا هولندا أبريل 2026/69e9cf23640e7_1776930595_video.mp4','App\\Models\\EventGallery',1,'2026-04-23 14:19:33','2026-04-23 14:19:33','general',NULL),
(239,'/uploads/tenant_1/تغطية فرنسا بلجيكا هولندا أبريل 2026/69e9cf2375eeb_1776930595_video.mp4','App\\Models\\EventGallery',1,'2026-04-23 14:19:33','2026-04-23 14:19:33','general',NULL),
(240,'/uploads/tenant_1/تغطية فرنسا بلجيكا هولندا أبريل 2026/69e9cf237dc79_1776930595_video.mp4','App\\Models\\EventGallery',1,'2026-04-23 14:19:33','2026-04-23 14:19:33','general',NULL),
(268,'uploads/tenant_1/icons/69e9f34ea251f_1776939854_general.jpeg','App\\Models\\Folder',1,'2026-04-23 16:24:14','2026-04-23 16:24:14','general',NULL),
(269,'uploads/tenant_1/icons/69e9f34ea7fab_1776939854_general.jpeg','App\\Models\\Folder',1,'2026-04-23 16:24:14','2026-04-23 16:24:14','general',NULL),
(270,'uploads/tenant_1/icons/69e9f34ea8f86_1776939854_general.jpeg','App\\Models\\Folder',1,'2026-04-23 16:24:14','2026-04-23 16:24:14','general',NULL),
(271,'uploads/tenant_1/icons/69e9f34eaa3ea_1776939854_general.jpeg','App\\Models\\Folder',1,'2026-04-23 16:24:14','2026-04-23 16:24:14','general',NULL),
(272,'uploads/tenant_1/icons/69e9f34eab13f_1776939854_general.jpeg','App\\Models\\Folder',1,'2026-04-23 16:24:14','2026-04-23 16:24:14','general',NULL),
(273,'uploads/tenant_1/icons/69e9f34eaca2b_1776939854_general.jpeg','App\\Models\\Folder',1,'2026-04-23 16:24:14','2026-04-23 16:24:14','general',NULL),
(376,'/uploads/tenant_1/روسيا/69e9f6f51be5c_1776940789_general.jpeg','App\\Models\\Item',6,'2026-04-26 15:51:28','2026-04-26 15:51:28','general',NULL),
(359,'/uploads/tenant_1/general/69ecbbaa2d931_1777122218_general.jpeg','App\\Models\\Item',9,'2026-04-26 00:46:01','2026-04-26 00:46:01','general',NULL),
(360,'/uploads/tenant_1/general/69ecbbaa2d931_1777122218_general.jpeg','App\\Models\\Item',7,'2026-04-26 00:46:47','2026-04-26 00:46:47','general',NULL),
(331,'uploads/tenant_1/general/69ecbbaa2d931_1777122218_general.jpeg','App\\Models\\Folder',9,'2026-04-25 20:03:38','2026-04-26 15:01:38','general',NULL),
(332,'uploads/tenant_1/general/69ecbbaa355e0_1777122218_general.jpeg','App\\Models\\Folder',9,'2026-04-25 20:03:38','2026-04-26 15:01:41','general',NULL),
(343,'uploads/tenant_1/general/69ecbe4d30008_1777122893_general.png','App\\Models\\Folder',9,'2026-04-25 20:14:53','2026-04-26 15:01:34','general',NULL),
(346,'uploads/tenant_1/general/69ecc208e2408_1777123848_general.jpeg',NULL,NULL,'2026-04-25 20:30:48','2026-04-25 20:30:48','general',NULL),
(361,'uploads/tenant_1/تركيا/69edc6f1cc975_1777190641_general.png','App\\Models\\Folder',3,'2026-04-26 15:04:01','2026-04-26 15:04:01','general',NULL),
(362,'uploads/tenant_1/general/69edc85f6c835_1777191007_general.png',NULL,NULL,'2026-04-26 15:10:07','2026-04-26 15:10:07','general',NULL),
(387,'uploads/tenant_1/general/69ee021d233eb_1777205789_general.png',NULL,NULL,'2026-04-26 19:16:29','2026-04-26 19:16:29','general',NULL),
(388,'uploads/tenant_1/general/69ee021d26a33_1777205789_general.png',NULL,NULL,'2026-04-26 19:16:29','2026-04-26 19:16:29','general',NULL);
/*!40000 ALTER TABLE `galleries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `item_excludes`
--

DROP TABLE IF EXISTS `item_excludes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `item_excludes` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `item_id` bigint(20) unsigned NOT NULL,
  `title_en` varchar(191) DEFAULT NULL,
  `title_ar` varchar(191) DEFAULT NULL,
  `icon` varchar(191) DEFAULT NULL,
  `order` int(11) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `item_excludes_item_id_foreign` (`item_id`)
) ENGINE=MyISAM AUTO_INCREMENT=59 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `item_excludes`
--

LOCK TABLES `item_excludes` WRITE;
/*!40000 ALTER TABLE `item_excludes` DISABLE KEYS */;
INSERT INTO `item_excludes` VALUES
(55,7,'additional Fees will be applied','رسوم دخول المناطق العامة','/uploads/tenant_1/icons/69e53d89a949d_1776631177_general.png',1,'2026-04-26 00:46:47','2026-04-26 00:46:47'),
(38,8,'additional Fees will be applied','رسوم دخول المناطق العامة','/uploads/tenant_1/icons/69e53d89a949d_1776631177_general.png',1,'2026-04-25 20:10:03','2026-04-25 20:10:03'),
(54,9,'additional Fees will be applied','رسوم دخول المناطق العامة','/uploads/tenant_1/icons/69e53d89a949d_1776631177_general.png',1,'2026-04-26 00:46:01','2026-04-26 00:46:01'),
(48,10,'additional Fees will be applied','رسوم دخول المناطق العامة','/uploads/tenant_1/icons/69e53d89a949d_1776631177_general.png',1,'2026-04-26 00:19:14','2026-04-26 00:19:14');
/*!40000 ALTER TABLE `item_excludes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `item_itineraries`
--

DROP TABLE IF EXISTS `item_itineraries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `item_itineraries` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `item_id` bigint(20) unsigned NOT NULL,
  `city_id` bigint(20) unsigned NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `nights` int(11) NOT NULL DEFAULT 0,
  `map` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `item_itineraries_item_id_foreign` (`item_id`),
  KEY `item_itineraries_city_id_foreign` (`city_id`)
) ENGINE=MyISAM AUTO_INCREMENT=217 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `item_itineraries`
--

LOCK TABLES `item_itineraries` WRITE;
/*!40000 ALTER TABLE `item_itineraries` DISABLE KEYS */;
INSERT INTO `item_itineraries` VALUES
(198,6,9,'2026-05-23','2026-05-30',7,NULL,'2026-04-26 15:51:28','2026-04-26 15:51:28'),
(4,2,2,'2026-03-12','2026-03-28',15,NULL,'2026-03-12 19:39:07','2026-03-12 19:39:07'),
(5,2,5,'2026-03-24','2026-03-28',3,NULL,'2026-03-12 19:39:07','2026-03-12 19:39:07'),
(6,2,3,'2026-03-24','2026-03-26',1,NULL,'2026-03-12 19:39:07','2026-03-12 19:39:07'),
(41,3,1,'2026-03-12','2026-03-21',8,'https://maps.app.goo.gl/co6r7L9yv7nz7WPF6','2026-04-19 16:46:11','2026-04-19 16:46:11'),
(10,4,2,'2026-03-12','2026-03-14',1,NULL,'2026-03-12 19:50:21','2026-03-12 19:50:21'),
(11,4,3,'2026-03-20','2026-03-29',8,NULL,'2026-03-12 19:50:21','2026-03-12 19:50:21'),
(12,4,4,'2026-03-18','2026-03-21',2,NULL,'2026-03-12 19:50:21','2026-03-12 19:50:21'),
(17,5,2,'2026-03-16','2026-03-31',14,NULL,'2026-03-16 05:20:26','2026-03-16 05:20:26'),
(40,3,2,'2026-03-13','2026-03-16',2,'https://maps.app.goo.gl/co6r7L9yv7nz7WPF6','2026-04-19 16:46:11','2026-04-19 16:46:11'),
(39,3,3,'2026-03-24','2026-03-28',3,'https://maps.app.goo.gl/co6r7L9yv7nz7WPF6','2026-04-19 16:46:11','2026-04-19 16:46:11'),
(214,1,7,'2026-05-15','2026-05-17',2,'https://www.google.com/maps/place/Istanbul,+%C4%B0stanbul,+T%C3%BCrkiye/@41.0034427,28.3527872,9z/data=!3m1!4b1!4m6!3m5!1s0x14caa7040068086b:0xe1ccfe98bc01b0d0!8m2!3d41.0082376!4d28.9783589!16zL20vMDk5NDlt?entry=ttu&g_ep=EgoyMDI2MDQxNS4wIKXMDSoASAFQAw%3D%3D','2026-04-26 22:43:18','2026-04-26 22:43:18'),
(215,1,8,'2026-05-20','2026-05-22',2,'google.com/maps?client=ubuntu-chr&hs=L9H&sca_esv=b180661c5c6cf4ef&output=search&q=trabzon&source=lnms&fbs=ADc_l-aN0CWEZBOHjofHoaMMDiKpaEWjvZ2Py1XXV8d8KvlI3ppPEReeCOS7s1VbbZz2TLtLg-3tySDopuaXFPmErWGpboKyiz_e1bd0adx6LxTCpbblBoN3TRWlz3sYSS-KZgg7ZupeGwdiEr9o0sPujYQuRDhhG1ykPKEfimRoU03wlzmlTC-MijlvsK7ZjhdkDvIwoCuIvqxOkwTJUJRGmvYT4ogQPg&entry=mc&ved=1t:200715&ictx=111','2026-04-26 22:43:18','2026-04-26 22:43:18'),
(216,1,6,'2026-05-17','2026-05-20',3,'https://www.google.com/maps?client=ubuntu-chr&hs=2Nx&biw=1920&bih=895&sca_esv=b180661c5c6cf4ef&output=search&q=%D8%A7%D9%88%D8%B2%D9%86%D8%AC%D9%88%D9%84&source=lnms&fbs=ADc_l-aN0CWEZBOHjofHoaMMDiKpaEWjvZ2Py1XXV8d8KvlI3jljrY5CkLlk8Dq3IvwBz-SWBLBIpU6WqoosusF5QLbxy2lcH1LNJgLGMd-zxozfvjDG1FdyOzQWDgTpraYwAEIeSHZa1zKIpNrtpt54ATcRsmqC-r0A45loVA6INmsSXp6PnIPVrj8pDMvulcyRTLVKymtcI_tAUPfc3opULgC4_ENRqg&entry=mc&ved=1t:200715&ictx=111','2026-04-26 22:43:18','2026-04-26 22:43:18'),
(173,10,10,'2026-07-04','2026-07-07',3,NULL,'2026-04-26 00:19:14','2026-04-26 00:19:14'),
(194,7,12,'2026-07-07','2026-07-09',2,NULL,'2026-04-26 00:46:47','2026-04-26 00:46:47'),
(193,7,10,'2026-07-04','2026-07-07',3,NULL,'2026-04-26 00:46:47','2026-04-26 00:46:47'),
(192,7,11,'2026-07-02','2026-07-04',2,NULL,'2026-04-26 00:46:47','2026-04-26 00:46:47'),
(191,9,11,'2026-08-13','2026-08-15',2,NULL,'2026-04-26 00:46:01','2026-04-26 00:46:01'),
(190,9,10,'2026-08-15','2026-08-18',3,NULL,'2026-04-26 00:46:01','2026-04-26 00:46:01'),
(189,9,12,'2026-08-18','2026-08-20',2,NULL,'2026-04-26 00:46:01','2026-04-26 00:46:01'),
(172,10,11,'2026-07-02','2026-07-04',2,NULL,'2026-04-26 00:19:14','2026-04-26 00:19:14'),
(171,10,12,'2026-07-07','2026-07-09',2,NULL,'2026-04-26 00:19:14','2026-04-26 00:19:14'),
(141,8,6,'2026-05-17','2026-05-20',3,'https://www.google.com/maps?client=ubuntu-chr&hs=2Nx&biw=1920&bih=895&sca_esv=b180661c5c6cf4ef&output=search&q=%D8%A7%D9%88%D8%B2%D9%86%D8%AC%D9%88%D9%84&source=lnms&fbs=ADc_l-aN0CWEZBOHjofHoaMMDiKpaEWjvZ2Py1XXV8d8KvlI3jljrY5CkLlk8Dq3IvwBz-SWBLBIpU6WqoosusF5QLbxy2lcH1LNJgLGMd-zxozfvjDG1FdyOzQWDgTpraYwAEIeSHZa1zKIpNrtpt54ATcRsmqC-r0A45loVA6INmsSXp6PnIPVrj8pDMvulcyRTLVKymtcI_tAUPfc3opULgC4_ENRqg&entry=mc&ved=1t:200715&ictx=111','2026-04-25 20:10:03','2026-04-25 20:10:03'),
(143,8,8,'2026-05-20','2026-05-22',2,'google.com/maps?client=ubuntu-chr&hs=L9H&sca_esv=b180661c5c6cf4ef&output=search&q=trabzon&source=lnms&fbs=ADc_l-aN0CWEZBOHjofHoaMMDiKpaEWjvZ2Py1XXV8d8KvlI3ppPEReeCOS7s1VbbZz2TLtLg-3tySDopuaXFPmErWGpboKyiz_e1bd0adx6LxTCpbblBoN3TRWlz3sYSS-KZgg7ZupeGwdiEr9o0sPujYQuRDhhG1ykPKEfimRoU03wlzmlTC-MijlvsK7ZjhdkDvIwoCuIvqxOkwTJUJRGmvYT4ogQPg&entry=mc&ved=1t:200715&ictx=111','2026-04-25 20:10:03','2026-04-25 20:10:03'),
(142,8,7,'2026-05-15','2026-05-17',2,'https://www.google.com/maps/place/Istanbul,+%C4%B0stanbul,+T%C3%BCrkiye/@41.0034427,28.3527872,9z/data=!3m1!4b1!4m6!3m5!1s0x14caa7040068086b:0xe1ccfe98bc01b0d0!8m2!3d41.0082376!4d28.9783589!16zL20vMDk5NDlt?entry=ttu&g_ep=EgoyMDI2MDQxNS4wIKXMDSoASAFQAw%3D%3D','2026-04-25 20:10:03','2026-04-25 20:10:03');
/*!40000 ALTER TABLE `item_itineraries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `item_itinerary_places`
--

DROP TABLE IF EXISTS `item_itinerary_places`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `item_itinerary_places` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `itinerary_id` bigint(20) unsigned NOT NULL,
  `title_en` varchar(191) DEFAULT NULL,
  `title_ar` varchar(191) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `item_itinerary_places_itinerary_id_foreign` (`itinerary_id`)
) ENGINE=MyISAM AUTO_INCREMENT=757 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `item_itinerary_places`
--

LOCK TABLES `item_itinerary_places` WRITE;
/*!40000 ALTER TABLE `item_itinerary_places` DISABLE KEYS */;
INSERT INTO `item_itinerary_places` VALUES
(1,78,'pyramids','الاهرامات','2026-04-23 01:39:40','2026-04-23 01:39:40'),
(2,78,'Abo Elhoal','ابو الهول','2026-04-23 01:39:40','2026-04-23 01:39:40'),
(3,78,'car','سياره','2026-04-23 01:39:40','2026-04-23 01:39:40'),
(4,78,'sky','السماء','2026-04-23 01:39:40','2026-04-23 01:39:40'),
(5,80,'قصر بيلر بيه','قصر بيلر بيه','2026-04-23 15:49:24','2026-04-23 15:49:24'),
(6,80,'كورنيش الاورتاكوي','كورنيش الاورتاكوي','2026-04-23 15:49:24','2026-04-23 15:49:24'),
(7,80,'السوق المصري','السوق المصري','2026-04-23 15:49:24','2026-04-23 15:49:24'),
(8,80,'جولة بالبوسفور','جولة بالبوسفور','2026-04-23 15:49:24','2026-04-23 15:49:24'),
(9,80,'قلعة بورت','قلعة بورت','2026-04-23 15:49:24','2026-04-23 15:49:24'),
(10,80,'شارع الاستقلال','شارع الاستقلال','2026-04-23 15:49:24','2026-04-23 15:49:24'),
(11,81,'مطعم أكشبات','مطعم أكشبات','2026-04-23 15:49:24','2026-04-23 15:49:24'),
(12,81,'تلفريك طرابزون','تلفريك طرابزون','2026-04-23 15:49:24','2026-04-23 15:49:24'),
(13,81,'مدينة ريزا','مدينة ريزا','2026-04-23 15:49:24','2026-04-23 15:49:24'),
(14,81,'أيدر ( رافتنج - دبابات )','أيدر ( رافتنج - دبابات )','2026-04-23 15:49:24','2026-04-23 15:49:24'),
(15,81,'حديقة الشاي','حديقة الشاي','2026-04-23 15:49:24','2026-04-23 15:49:24'),
(16,81,'بحيرة سيراجول','بحيرة سيراجول','2026-04-23 15:49:24','2026-04-23 15:49:24'),
(17,81,'قرية همسي كوي','قرية همسي كوي','2026-04-23 15:49:24','2026-04-23 15:49:24'),
(18,81,'مطعم زيناش','مطعم زيناش','2026-04-23 15:49:24','2026-04-23 15:49:24'),
(19,81,'مول فورم طرابزون','مول فورم طرابزون','2026-04-23 15:49:24','2026-04-23 15:49:24'),
(20,82,'بحيرة اوزنجول ( مطاعم ، كافيهات )','بحيرة اوزنجول ( مطاعم ، كافيهات )','2026-04-23 15:49:24','2026-04-23 15:49:24'),
(21,82,'شلالات اوزنجول','شلالات اوزنجول','2026-04-23 15:49:24','2026-04-23 15:49:24'),
(22,82,'قرية ديمر كبي','قرية ديمر كبي','2026-04-23 15:49:24','2026-04-23 15:49:24'),
(23,82,'كوم كافيه','كوم كافيه','2026-04-23 15:49:24','2026-04-23 15:49:24'),
(24,82,'المطل الزجاجي','المطل الزجاجي','2026-04-23 15:49:24','2026-04-23 15:49:24'),
(25,82,'مطل بوزتبا','مطل بوزتبا','2026-04-23 15:49:24','2026-04-23 15:49:24'),
(26,82,'مول فورم طرابزون','مول فورم طرابزون','2026-04-23 15:49:24','2026-04-23 15:49:24'),
(27,83,'مطعم أكشبات','مطعم أكشبات','2026-04-23 15:50:18','2026-04-23 15:50:18'),
(28,83,'تلفريك طرابزون','تلفريك طرابزون','2026-04-23 15:50:18','2026-04-23 15:50:18'),
(29,83,'مدينة ريزا','مدينة ريزا','2026-04-23 15:50:18','2026-04-23 15:50:18'),
(30,83,'أيدر ( رافتنج - دبابات )','أيدر ( رافتنج - دبابات )','2026-04-23 15:50:18','2026-04-23 15:50:18'),
(31,83,'حديقة الشاي','حديقة الشاي','2026-04-23 15:50:18','2026-04-23 15:50:18'),
(32,83,'بحيرة سيراجول','بحيرة سيراجول','2026-04-23 15:50:18','2026-04-23 15:50:18'),
(33,83,'قرية همسي كوي','قرية همسي كوي','2026-04-23 15:50:18','2026-04-23 15:50:18'),
(34,83,'مطعم زيناش','مطعم زيناش','2026-04-23 15:50:18','2026-04-23 15:50:18'),
(35,83,'مول فورم طرابزون','مول فورم طرابزون','2026-04-23 15:50:18','2026-04-23 15:50:18'),
(36,84,'قصر بيلر بيه','قصر بيلر بيه','2026-04-23 15:50:18','2026-04-23 15:50:18'),
(37,84,'كورنيش الاورتاكوي','كورنيش الاورتاكوي','2026-04-23 15:50:18','2026-04-23 15:50:18'),
(38,84,'السوق المصري','السوق المصري','2026-04-23 15:50:18','2026-04-23 15:50:18'),
(39,84,'جولة بالبوسفور','جولة بالبوسفور','2026-04-23 15:50:18','2026-04-23 15:50:18'),
(40,84,'قلعة بورت','قلعة بورت','2026-04-23 15:50:18','2026-04-23 15:50:18'),
(41,84,'شارع الاستقلال','شارع الاستقلال','2026-04-23 15:50:18','2026-04-23 15:50:18'),
(42,85,'بحيرة اوزنجول ( مطاعم ، كافيهات )','بحيرة اوزنجول ( مطاعم ، كافيهات )','2026-04-23 15:50:18','2026-04-23 15:50:18'),
(43,85,'شلالات اوزنجول','شلالات اوزنجول','2026-04-23 15:50:18','2026-04-23 15:50:18'),
(44,85,'قرية ديمر كبي','قرية ديمر كبي','2026-04-23 15:50:18','2026-04-23 15:50:18'),
(45,85,'كوم كافيه','كوم كافيه','2026-04-23 15:50:18','2026-04-23 15:50:18'),
(46,85,'المطل الزجاجي','المطل الزجاجي','2026-04-23 15:50:18','2026-04-23 15:50:18'),
(47,85,'مطل بوزتبا','مطل بوزتبا','2026-04-23 15:50:18','2026-04-23 15:50:18'),
(48,85,'مول فورم طرابزون','مول فورم طرابزون','2026-04-23 15:50:18','2026-04-23 15:50:18'),
(49,86,'مطعم أكشبات','مطعم أكشبات','2026-04-23 15:53:42','2026-04-23 15:53:42'),
(50,86,'تلفريك طرابزون','تلفريك طرابزون','2026-04-23 15:53:42','2026-04-23 15:53:42'),
(51,86,'مدينة ريزا','مدينة ريزا','2026-04-23 15:53:42','2026-04-23 15:53:42'),
(52,86,'أيدر ( رافتنج - دبابات )','أيدر ( رافتنج - دبابات )','2026-04-23 15:53:42','2026-04-23 15:53:42'),
(53,86,'حديقة الشاي','حديقة الشاي','2026-04-23 15:53:42','2026-04-23 15:53:42'),
(54,86,'بحيرة سيراجول','بحيرة سيراجول','2026-04-23 15:53:42','2026-04-23 15:53:42'),
(55,86,'قرية همسي كوي','قرية همسي كوي','2026-04-23 15:53:42','2026-04-23 15:53:42'),
(56,86,'مطعم زيناش','مطعم زيناش','2026-04-23 15:53:42','2026-04-23 15:53:42'),
(57,86,'مول فورم طرابزون','مول فورم طرابزون','2026-04-23 15:53:42','2026-04-23 15:53:42'),
(58,87,'قصر بيلر بيه','قصر بيلر بيه','2026-04-23 15:53:42','2026-04-23 15:53:42'),
(59,87,'كورنيش الاورتاكوي','كورنيش الاورتاكوي','2026-04-23 15:53:42','2026-04-23 15:53:42'),
(60,87,'السوق المصري','السوق المصري','2026-04-23 15:53:42','2026-04-23 15:53:42'),
(61,87,'جولة بالبوسفور','جولة بالبوسفور','2026-04-23 15:53:42','2026-04-23 15:53:42'),
(62,87,'قلعة بورت','قلعة بورت','2026-04-23 15:53:42','2026-04-23 15:53:42'),
(63,87,'شارع الاستقلال','شارع الاستقلال','2026-04-23 15:53:42','2026-04-23 15:53:42'),
(64,88,'بحيرة اوزنجول ( مطاعم ، كافيهات )','بحيرة اوزنجول ( مطاعم ، كافيهات )','2026-04-23 15:53:42','2026-04-23 15:53:42'),
(65,88,'شلالات اوزنجول','شلالات اوزنجول','2026-04-23 15:53:42','2026-04-23 15:53:42'),
(66,88,'قرية ديمر كبي','قرية ديمر كبي','2026-04-23 15:53:42','2026-04-23 15:53:42'),
(67,88,'كوم كافيه','كوم كافيه','2026-04-23 15:53:42','2026-04-23 15:53:42'),
(68,88,'المطل الزجاجي','المطل الزجاجي','2026-04-23 15:53:42','2026-04-23 15:53:42'),
(69,88,'مطل بوزتبا','مطل بوزتبا','2026-04-23 15:53:42','2026-04-23 15:53:42'),
(70,88,'مول فورم طرابزون','مول فورم طرابزون','2026-04-23 15:53:42','2026-04-23 15:53:42'),
(71,89,'مطعم أكشبات','مطعم أكشبات','2026-04-23 15:55:54','2026-04-23 15:55:54'),
(72,89,'تلفريك طرابزون','تلفريك طرابزون','2026-04-23 15:55:54','2026-04-23 15:55:54'),
(73,89,'مدينة ريزا','مدينة ريزا','2026-04-23 15:55:54','2026-04-23 15:55:54'),
(74,89,'أيدر ( رافتنج - دبابات )','أيدر ( رافتنج - دبابات )','2026-04-23 15:55:54','2026-04-23 15:55:54'),
(75,89,'حديقة الشاي','حديقة الشاي','2026-04-23 15:55:54','2026-04-23 15:55:54'),
(76,89,'بحيرة سيراجول','بحيرة سيراجول','2026-04-23 15:55:54','2026-04-23 15:55:54'),
(77,89,'قرية همسي كوي','قرية همسي كوي','2026-04-23 15:55:54','2026-04-23 15:55:54'),
(78,89,'مطعم زيناش','مطعم زيناش','2026-04-23 15:55:54','2026-04-23 15:55:54'),
(79,89,'مول فورم طرابزون','مول فورم طرابزون','2026-04-23 15:55:54','2026-04-23 15:55:54'),
(80,90,'قصر بيلر بيه','قصر بيلر بيه','2026-04-23 15:55:54','2026-04-23 15:55:54'),
(81,90,'كورنيش الاورتاكوي','كورنيش الاورتاكوي','2026-04-23 15:55:54','2026-04-23 15:55:54'),
(82,90,'السوق المصري','السوق المصري','2026-04-23 15:55:54','2026-04-23 15:55:54'),
(83,90,'جولة بالبوسفور','جولة بالبوسفور','2026-04-23 15:55:54','2026-04-23 15:55:54'),
(84,90,'قلعة بورت','قلعة بورت','2026-04-23 15:55:54','2026-04-23 15:55:54'),
(85,90,'شارع الاستقلال','شارع الاستقلال','2026-04-23 15:55:54','2026-04-23 15:55:54'),
(86,91,'بحيرة اوزنجول ( مطاعم ، كافيهات )','بحيرة اوزنجول ( مطاعم ، كافيهات )','2026-04-23 15:55:54','2026-04-23 15:55:54'),
(87,91,'شلالات اوزنجول','شلالات اوزنجول','2026-04-23 15:55:54','2026-04-23 15:55:54'),
(88,91,'قرية ديمر كبي','قرية ديمر كبي','2026-04-23 15:55:54','2026-04-23 15:55:54'),
(89,91,'كوم كافيه','كوم كافيه','2026-04-23 15:55:54','2026-04-23 15:55:54'),
(90,91,'المطل الزجاجي','المطل الزجاجي','2026-04-23 15:55:54','2026-04-23 15:55:54'),
(91,91,'مطل بوزتبا','مطل بوزتبا','2026-04-23 15:55:54','2026-04-23 15:55:54'),
(92,91,'مول فورم طرابزون','مول فورم طرابزون','2026-04-23 15:55:54','2026-04-23 15:55:54'),
(93,92,'مطعم أكشبات','مطعم أكشبات','2026-04-23 15:58:56','2026-04-23 15:58:56'),
(94,92,'تلفريك طرابزون','تلفريك طرابزون','2026-04-23 15:58:56','2026-04-23 15:58:56'),
(95,92,'مدينة ريزا','مدينة ريزا','2026-04-23 15:58:56','2026-04-23 15:58:56'),
(96,92,'أيدر ( رافتنج - دبابات )','أيدر ( رافتنج - دبابات )','2026-04-23 15:58:56','2026-04-23 15:58:56'),
(97,92,'حديقة الشاي','حديقة الشاي','2026-04-23 15:58:56','2026-04-23 15:58:56'),
(98,92,'بحيرة سيراجول','بحيرة سيراجول','2026-04-23 15:58:56','2026-04-23 15:58:56'),
(99,92,'قرية همسي كوي','قرية همسي كوي','2026-04-23 15:58:56','2026-04-23 15:58:56'),
(100,92,'مطعم زيناش','مطعم زيناش','2026-04-23 15:58:56','2026-04-23 15:58:56'),
(101,92,'مول فورم طرابزون','مول فورم طرابزون','2026-04-23 15:58:56','2026-04-23 15:58:56'),
(102,93,'بحيرة اوزنجول ( مطاعم ، كافيهات )','بحيرة اوزنجول ( مطاعم ، كافيهات )','2026-04-23 15:58:56','2026-04-23 15:58:56'),
(103,93,'شلالات اوزنجول','شلالات اوزنجول','2026-04-23 15:58:56','2026-04-23 15:58:56'),
(104,93,'قرية ديمر كبي','قرية ديمر كبي','2026-04-23 15:58:56','2026-04-23 15:58:56'),
(105,93,'كوم كافيه','كوم كافيه','2026-04-23 15:58:56','2026-04-23 15:58:56'),
(106,93,'المطل الزجاجي','المطل الزجاجي','2026-04-23 15:58:56','2026-04-23 15:58:56'),
(107,93,'مطل بوزتبا','مطل بوزتبا','2026-04-23 15:58:56','2026-04-23 15:58:56'),
(108,93,'مول فورم طرابزون','مول فورم طرابزون','2026-04-23 15:58:56','2026-04-23 15:58:56'),
(109,94,'قصر بيلر بيه','قصر بيلر بيه','2026-04-23 15:58:56','2026-04-23 15:58:56'),
(110,94,'كورنيش الاورتاكوي','كورنيش الاورتاكوي','2026-04-23 15:58:56','2026-04-23 15:58:56'),
(111,94,'السوق المصري','السوق المصري','2026-04-23 15:58:56','2026-04-23 15:58:56'),
(112,94,'جولة بالبوسفور','جولة بالبوسفور','2026-04-23 15:58:56','2026-04-23 15:58:56'),
(113,94,'قلعة بورت','قلعة بورت','2026-04-23 15:58:56','2026-04-23 15:58:56'),
(114,94,'شارع الاستقلال','شارع الاستقلال','2026-04-23 15:58:56','2026-04-23 15:58:56'),
(115,95,'مطعم أكشبات','مطعم أكشبات','2026-04-23 16:01:55','2026-04-23 16:01:55'),
(116,95,'تلفريك طرابزون','تلفريك طرابزون','2026-04-23 16:01:55','2026-04-23 16:01:55'),
(117,95,'مدينة ريزا','مدينة ريزا','2026-04-23 16:01:55','2026-04-23 16:01:55'),
(118,95,'أيدر ( رافتنج - دبابات )','أيدر ( رافتنج - دبابات )','2026-04-23 16:01:55','2026-04-23 16:01:55'),
(119,95,'حديقة الشاي','حديقة الشاي','2026-04-23 16:01:55','2026-04-23 16:01:55'),
(120,95,'بحيرة سيراجول','بحيرة سيراجول','2026-04-23 16:01:55','2026-04-23 16:01:55'),
(121,95,'قرية همسي كوي','قرية همسي كوي','2026-04-23 16:01:55','2026-04-23 16:01:55'),
(122,95,'مطعم زيناش','مطعم زيناش','2026-04-23 16:01:55','2026-04-23 16:01:55'),
(123,95,'مول فورم طرابزون','مول فورم طرابزون','2026-04-23 16:01:55','2026-04-23 16:01:55'),
(124,96,'بحيرة اوزنجول ( مطاعم ، كافيهات )','بحيرة اوزنجول ( مطاعم ، كافيهات )','2026-04-23 16:01:55','2026-04-23 16:01:55'),
(125,96,'شلالات اوزنجول','شلالات اوزنجول','2026-04-23 16:01:55','2026-04-23 16:01:55'),
(126,96,'قرية ديمر كبي','قرية ديمر كبي','2026-04-23 16:01:55','2026-04-23 16:01:55'),
(127,96,'كوم كافيه','كوم كافيه','2026-04-23 16:01:55','2026-04-23 16:01:55'),
(128,96,'المطل الزجاجي','المطل الزجاجي','2026-04-23 16:01:55','2026-04-23 16:01:55'),
(129,96,'مطل بوزتبا','مطل بوزتبا','2026-04-23 16:01:55','2026-04-23 16:01:55'),
(130,96,'مول فورم طرابزون','مول فورم طرابزون','2026-04-23 16:01:55','2026-04-23 16:01:55'),
(131,97,'قصر بيلر بيه','قصر بيلر بيه','2026-04-23 16:01:55','2026-04-23 16:01:55'),
(132,97,'كورنيش الاورتاكوي','كورنيش الاورتاكوي','2026-04-23 16:01:55','2026-04-23 16:01:55'),
(133,97,'السوق المصري','السوق المصري','2026-04-23 16:01:55','2026-04-23 16:01:55'),
(134,97,'جولة بالبوسفور','جولة بالبوسفور','2026-04-23 16:01:55','2026-04-23 16:01:55'),
(135,97,'قلعة بورت','قلعة بورت','2026-04-23 16:01:55','2026-04-23 16:01:55'),
(136,97,'شارع الاستقلال','شارع الاستقلال','2026-04-23 16:01:55','2026-04-23 16:01:55'),
(137,98,'الساحة الحمراء','الساحة الحمراء','2026-04-23 16:18:23','2026-04-23 16:18:23'),
(138,98,'الرحلة النهرية','الرحلة النهرية','2026-04-23 16:18:23','2026-04-23 16:18:23'),
(139,98,'مركز جوم التجاري (سوق Gum)','مركز جوم التجاري (سوق Gum)','2026-04-23 16:18:23','2026-04-23 16:18:23'),
(140,98,'منطقة كيتاي غورود','منطقة كيتاي غورود','2026-04-23 16:18:23','2026-04-23 16:18:23'),
(141,98,'الجسر المعلق','الجسر المعلق','2026-04-23 16:18:23','2026-04-23 16:18:23'),
(142,98,'صندوق الألماس الروسي داخل الكرملين','صندوق الألماس الروسي داخل الكرملين','2026-04-23 16:18:23','2026-04-23 16:18:23'),
(143,98,'منطقة الأخوات السبع','منطقة الأخوات السبع','2026-04-23 16:18:23','2026-04-23 16:18:23'),
(144,98,'مصنع الشيكولاتة','مصنع الشيكولاتة','2026-04-23 16:18:23','2026-04-23 16:18:23'),
(145,98,'حديقة الباتريارك','حديقة الباتريارك','2026-04-23 16:18:23','2026-04-23 16:18:23'),
(146,98,'برج أوستانكينو','برج أوستانكينو','2026-04-23 16:18:23','2026-04-23 16:18:23'),
(147,98,'دريم لاند موسكو','دريم لاند موسكو','2026-04-23 16:18:23','2026-04-23 16:18:23'),
(148,98,'شارع أربات','شارع أربات','2026-04-23 16:18:23','2026-04-23 16:18:23'),
(149,98,'رحلة نهرية راديسون','رحلة نهرية راديسون','2026-04-23 16:18:23','2026-04-23 16:18:23'),
(150,98,'حديقة الهاسكي','حديقة الهاسكي','2026-04-23 16:18:23','2026-04-23 16:18:23'),
(151,98,'حديقة النصر','حديقة النصر','2026-04-23 16:18:23','2026-04-23 16:18:23'),
(152,98,'تلفريك موسكو','تلفريك موسكو','2026-04-23 16:18:23','2026-04-23 16:18:23'),
(153,99,'الساحة الحمراء','الساحة الحمراء','2026-04-23 16:25:01','2026-04-23 16:25:01'),
(154,99,'الرحلة النهرية','الرحلة النهرية','2026-04-23 16:25:01','2026-04-23 16:25:01'),
(155,99,'مركز جوم التجاري (سوق Gum)','مركز جوم التجاري (سوق Gum)','2026-04-23 16:25:01','2026-04-23 16:25:01'),
(156,99,'منطقة كيتاي غورود','منطقة كيتاي غورود','2026-04-23 16:25:01','2026-04-23 16:25:01'),
(157,99,'الجسر المعلق','الجسر المعلق','2026-04-23 16:25:01','2026-04-23 16:25:01'),
(158,99,'صندوق الألماس الروسي داخل الكرملين','صندوق الألماس الروسي داخل الكرملين','2026-04-23 16:25:01','2026-04-23 16:25:01'),
(159,99,'منطقة الأخوات السبع','منطقة الأخوات السبع','2026-04-23 16:25:01','2026-04-23 16:25:01'),
(160,99,'مصنع الشيكولاتة','مصنع الشيكولاتة','2026-04-23 16:25:01','2026-04-23 16:25:01'),
(161,99,'حديقة الباتريارك','حديقة الباتريارك','2026-04-23 16:25:01','2026-04-23 16:25:01'),
(162,99,'برج أوستانكينو','برج أوستانكينو','2026-04-23 16:25:01','2026-04-23 16:25:01'),
(163,99,'دريم لاند موسكو','دريم لاند موسكو','2026-04-23 16:25:01','2026-04-23 16:25:01'),
(164,99,'شارع أربات','شارع أربات','2026-04-23 16:25:01','2026-04-23 16:25:01'),
(165,99,'رحلة نهرية راديسون','رحلة نهرية راديسون','2026-04-23 16:25:01','2026-04-23 16:25:01'),
(166,99,'حديقة الهاسكي','حديقة الهاسكي','2026-04-23 16:25:01','2026-04-23 16:25:01'),
(167,99,'حديقة النصر','حديقة النصر','2026-04-23 16:25:01','2026-04-23 16:25:01'),
(168,99,'تلفريك موسكو','تلفريك موسكو','2026-04-23 16:25:01','2026-04-23 16:25:01'),
(169,100,'الساحة الحمراء','الساحة الحمراء','2026-04-23 16:27:14','2026-04-23 16:27:14'),
(170,100,'الرحلة النهرية','الرحلة النهرية','2026-04-23 16:27:14','2026-04-23 16:27:14'),
(171,100,'مركز جوم التجاري (سوق Gum)','مركز جوم التجاري (سوق Gum)','2026-04-23 16:27:14','2026-04-23 16:27:14'),
(172,100,'منطقة كيتاي غورود','منطقة كيتاي غورود','2026-04-23 16:27:14','2026-04-23 16:27:14'),
(173,100,'الجسر المعلق','الجسر المعلق','2026-04-23 16:27:14','2026-04-23 16:27:14'),
(174,100,'صندوق الألماس الروسي داخل الكرملين','صندوق الألماس الروسي داخل الكرملين','2026-04-23 16:27:14','2026-04-23 16:27:14'),
(175,100,'منطقة الأخوات السبع','منطقة الأخوات السبع','2026-04-23 16:27:14','2026-04-23 16:27:14'),
(176,100,'مصنع الشيكولاتة','مصنع الشيكولاتة','2026-04-23 16:27:14','2026-04-23 16:27:14'),
(177,100,'حديقة الباتريارك','حديقة الباتريارك','2026-04-23 16:27:14','2026-04-23 16:27:14'),
(178,100,'برج أوستانكينو','برج أوستانكينو','2026-04-23 16:27:14','2026-04-23 16:27:14'),
(179,100,'دريم لاند موسكو','دريم لاند موسكو','2026-04-23 16:27:14','2026-04-23 16:27:14'),
(180,100,'شارع أربات','شارع أربات','2026-04-23 16:27:14','2026-04-23 16:27:14'),
(181,100,'رحلة نهرية راديسون','رحلة نهرية راديسون','2026-04-23 16:27:14','2026-04-23 16:27:14'),
(182,100,'حديقة الهاسكي','حديقة الهاسكي','2026-04-23 16:27:14','2026-04-23 16:27:14'),
(183,100,'حديقة النصر','حديقة النصر','2026-04-23 16:27:14','2026-04-23 16:27:14'),
(184,100,'تلفريك موسكو','تلفريك موسكو','2026-04-23 16:27:14','2026-04-23 16:27:14'),
(185,101,'الساحة الحمراء','الساحة الحمراء','2026-04-23 16:30:00','2026-04-23 16:30:00'),
(186,101,'الرحلة النهرية','الرحلة النهرية','2026-04-23 16:30:00','2026-04-23 16:30:00'),
(187,101,'مركز جوم التجاري (سوق Gum)','مركز جوم التجاري (سوق Gum)','2026-04-23 16:30:00','2026-04-23 16:30:00'),
(188,101,'منطقة كيتاي غورود','منطقة كيتاي غورود','2026-04-23 16:30:00','2026-04-23 16:30:00'),
(189,101,'الجسر المعلق','الجسر المعلق','2026-04-23 16:30:00','2026-04-23 16:30:00'),
(190,101,'صندوق الألماس الروسي داخل الكرملين','صندوق الألماس الروسي داخل الكرملين','2026-04-23 16:30:00','2026-04-23 16:30:00'),
(191,101,'منطقة الأخوات السبع','منطقة الأخوات السبع','2026-04-23 16:30:00','2026-04-23 16:30:00'),
(192,101,'مصنع الشيكولاتة','مصنع الشيكولاتة','2026-04-23 16:30:00','2026-04-23 16:30:00'),
(193,101,'حديقة الباتريارك','حديقة الباتريارك','2026-04-23 16:30:00','2026-04-23 16:30:00'),
(194,101,'برج أوستانكينو','برج أوستانكينو','2026-04-23 16:30:00','2026-04-23 16:30:00'),
(195,101,'دريم لاند موسكو','دريم لاند موسكو','2026-04-23 16:30:00','2026-04-23 16:30:00'),
(196,101,'شارع أربات','شارع أربات','2026-04-23 16:30:00','2026-04-23 16:30:00'),
(197,101,'رحلة نهرية راديسون','رحلة نهرية راديسون','2026-04-23 16:30:00','2026-04-23 16:30:00'),
(198,101,'حديقة الهاسكي','حديقة الهاسكي','2026-04-23 16:30:00','2026-04-23 16:30:00'),
(199,101,'حديقة النصر','حديقة النصر','2026-04-23 16:30:00','2026-04-23 16:30:00'),
(200,101,'تلفريك موسكو','تلفريك موسكو','2026-04-23 16:30:00','2026-04-23 16:30:00'),
(201,102,'الساحة الحمراء','الساحة الحمراء','2026-04-23 16:40:18','2026-04-23 16:40:18'),
(202,102,'الرحلة النهرية','الرحلة النهرية','2026-04-23 16:40:18','2026-04-23 16:40:18'),
(203,102,'مركز جوم التجاري (سوق Gum)','مركز جوم التجاري (سوق Gum)','2026-04-23 16:40:18','2026-04-23 16:40:18'),
(204,102,'منطقة كيتاي غورود','منطقة كيتاي غورود','2026-04-23 16:40:18','2026-04-23 16:40:18'),
(205,102,'الجسر المعلق','الجسر المعلق','2026-04-23 16:40:18','2026-04-23 16:40:18'),
(206,102,'صندوق الألماس الروسي داخل الكرملين','صندوق الألماس الروسي داخل الكرملين','2026-04-23 16:40:18','2026-04-23 16:40:18'),
(207,102,'منطقة الأخوات السبع','منطقة الأخوات السبع','2026-04-23 16:40:18','2026-04-23 16:40:18'),
(208,102,'مصنع الشيكولاتة','مصنع الشيكولاتة','2026-04-23 16:40:18','2026-04-23 16:40:18'),
(209,102,'حديقة الباتريارك','حديقة الباتريارك','2026-04-23 16:40:18','2026-04-23 16:40:18'),
(210,102,'برج أوستانكينو','برج أوستانكينو','2026-04-23 16:40:18','2026-04-23 16:40:18'),
(211,102,'دريم لاند موسكو','دريم لاند موسكو','2026-04-23 16:40:18','2026-04-23 16:40:18'),
(212,102,'شارع أربات','شارع أربات','2026-04-23 16:40:18','2026-04-23 16:40:18'),
(213,102,'رحلة نهرية راديسون','رحلة نهرية راديسون','2026-04-23 16:40:18','2026-04-23 16:40:18'),
(214,102,'حديقة الهاسكي','حديقة الهاسكي','2026-04-23 16:40:18','2026-04-23 16:40:18'),
(215,102,'حديقة النصر','حديقة النصر','2026-04-23 16:40:18','2026-04-23 16:40:18'),
(216,102,'تلفريك موسكو','تلفريك موسكو','2026-04-23 16:40:18','2026-04-23 16:40:18'),
(217,103,'الساحة الحمراء','الساحة الحمراء','2026-04-23 16:45:28','2026-04-23 16:45:28'),
(218,103,'الرحلة النهرية','الرحلة النهرية','2026-04-23 16:45:28','2026-04-23 16:45:28'),
(219,103,'مركز جوم التجاري (سوق Gum)','مركز جوم التجاري (سوق Gum)','2026-04-23 16:45:28','2026-04-23 16:45:28'),
(220,103,'منطقة كيتاي غورود','منطقة كيتاي غورود','2026-04-23 16:45:28','2026-04-23 16:45:28'),
(221,103,'الجسر المعلق','الجسر المعلق','2026-04-23 16:45:28','2026-04-23 16:45:28'),
(222,103,'صندوق الألماس الروسي داخل الكرملين','صندوق الألماس الروسي داخل الكرملين','2026-04-23 16:45:28','2026-04-23 16:45:28'),
(223,103,'منطقة الأخوات السبع','منطقة الأخوات السبع','2026-04-23 16:45:28','2026-04-23 16:45:28'),
(224,103,'مصنع الشيكولاتة','مصنع الشيكولاتة','2026-04-23 16:45:28','2026-04-23 16:45:28'),
(225,103,'حديقة الباتريارك','حديقة الباتريارك','2026-04-23 16:45:28','2026-04-23 16:45:28'),
(226,103,'برج أوستانكينو','برج أوستانكينو','2026-04-23 16:45:28','2026-04-23 16:45:28'),
(227,103,'دريم لاند موسكو','دريم لاند موسكو','2026-04-23 16:45:28','2026-04-23 16:45:28'),
(228,103,'شارع أربات','شارع أربات','2026-04-23 16:45:28','2026-04-23 16:45:28'),
(229,103,'رحلة نهرية راديسون','رحلة نهرية راديسون','2026-04-23 16:45:28','2026-04-23 16:45:28'),
(230,103,'حديقة الهاسكي','حديقة الهاسكي','2026-04-23 16:45:28','2026-04-23 16:45:28'),
(231,103,'حديقة النصر','حديقة النصر','2026-04-23 16:45:28','2026-04-23 16:45:28'),
(232,103,'تلفريك موسكو','تلفريك موسكو','2026-04-23 16:45:28','2026-04-23 16:45:28'),
(233,104,'الساحة الحمراء','الساحة الحمراء','2026-04-23 17:00:09','2026-04-23 17:00:09'),
(234,104,'الرحلة النهرية','الرحلة النهرية','2026-04-23 17:00:09','2026-04-23 17:00:09'),
(235,104,'مركز جوم التجاري (سوق Gum)','مركز جوم التجاري (سوق Gum)','2026-04-23 17:00:09','2026-04-23 17:00:09'),
(236,104,'منطقة كيتاي غورود','منطقة كيتاي غورود','2026-04-23 17:00:09','2026-04-23 17:00:09'),
(237,104,'الجسر المعلق','الجسر المعلق','2026-04-23 17:00:09','2026-04-23 17:00:09'),
(238,104,'صندوق الألماس الروسي داخل الكرملين','صندوق الألماس الروسي داخل الكرملين','2026-04-23 17:00:09','2026-04-23 17:00:09'),
(239,104,'منطقة الأخوات السبع','منطقة الأخوات السبع','2026-04-23 17:00:09','2026-04-23 17:00:09'),
(240,104,'مصنع الشيكولاتة','مصنع الشيكولاتة','2026-04-23 17:00:09','2026-04-23 17:00:09'),
(241,104,'حديقة الباتريارك','حديقة الباتريارك','2026-04-23 17:00:09','2026-04-23 17:00:09'),
(242,104,'برج أوستانكينو','برج أوستانكينو','2026-04-23 17:00:09','2026-04-23 17:00:09'),
(243,104,'دريم لاند موسكو','دريم لاند موسكو','2026-04-23 17:00:09','2026-04-23 17:00:09'),
(244,104,'شارع أربات','شارع أربات','2026-04-23 17:00:09','2026-04-23 17:00:09'),
(245,104,'رحلة نهرية راديسون','رحلة نهرية راديسون','2026-04-23 17:00:09','2026-04-23 17:00:09'),
(246,104,'حديقة الهاسكي','حديقة الهاسكي','2026-04-23 17:00:09','2026-04-23 17:00:09'),
(247,104,'حديقة النصر','حديقة النصر','2026-04-23 17:00:09','2026-04-23 17:00:09'),
(248,104,'تلفريك موسكو','تلفريك موسكو','2026-04-23 17:00:09','2026-04-23 17:00:09'),
(249,105,'الساحة الحمراء','الساحة الحمراء','2026-04-23 17:03:45','2026-04-23 17:03:45'),
(250,105,'الرحلة النهرية','الرحلة النهرية','2026-04-23 17:03:45','2026-04-23 17:03:45'),
(251,105,'مركز جوم التجاري (سوق Gum)','مركز جوم التجاري (سوق Gum)','2026-04-23 17:03:45','2026-04-23 17:03:45'),
(252,105,'منطقة كيتاي غورود','منطقة كيتاي غورود','2026-04-23 17:03:45','2026-04-23 17:03:45'),
(253,105,'الجسر المعلق','الجسر المعلق','2026-04-23 17:03:45','2026-04-23 17:03:45'),
(254,105,'صندوق الألماس الروسي داخل الكرملين','صندوق الألماس الروسي داخل الكرملين','2026-04-23 17:03:45','2026-04-23 17:03:45'),
(255,105,'منطقة الأخوات السبع','منطقة الأخوات السبع','2026-04-23 17:03:45','2026-04-23 17:03:45'),
(256,105,'مصنع الشيكولاتة','مصنع الشيكولاتة','2026-04-23 17:03:45','2026-04-23 17:03:45'),
(257,105,'حديقة الباتريارك','حديقة الباتريارك','2026-04-23 17:03:45','2026-04-23 17:03:45'),
(258,105,'برج أوستانكينو','برج أوستانكينو','2026-04-23 17:03:45','2026-04-23 17:03:45'),
(259,105,'دريم لاند موسكو','دريم لاند موسكو','2026-04-23 17:03:45','2026-04-23 17:03:45'),
(260,105,'شارع أربات','شارع أربات','2026-04-23 17:03:45','2026-04-23 17:03:45'),
(261,105,'رحلة نهرية راديسون','رحلة نهرية راديسون','2026-04-23 17:03:45','2026-04-23 17:03:45'),
(262,105,'حديقة الهاسكي','حديقة الهاسكي','2026-04-23 17:03:45','2026-04-23 17:03:45'),
(263,105,'حديقة النصر','حديقة النصر','2026-04-23 17:03:45','2026-04-23 17:03:45'),
(264,105,'تلفريك موسكو','تلفريك موسكو','2026-04-23 17:03:45','2026-04-23 17:03:45'),
(265,106,'الساحة الحمراء','الساحة الحمراء','2026-04-24 00:24:50','2026-04-24 00:24:50'),
(266,106,'الرحلة النهرية','الرحلة النهرية','2026-04-24 00:24:50','2026-04-24 00:24:50'),
(267,106,'مركز جوم التجاري (سوق Gum)','مركز جوم التجاري (سوق Gum)','2026-04-24 00:24:50','2026-04-24 00:24:50'),
(268,106,'منطقة كيتاي غورود','منطقة كيتاي غورود','2026-04-24 00:24:50','2026-04-24 00:24:50'),
(269,106,'الجسر المعلق','الجسر المعلق','2026-04-24 00:24:50','2026-04-24 00:24:50'),
(270,106,'صندوق الألماس الروسي داخل الكرملين','صندوق الألماس الروسي داخل الكرملين','2026-04-24 00:24:50','2026-04-24 00:24:50'),
(271,106,'منطقة الأخوات السبع','منطقة الأخوات السبع','2026-04-24 00:24:50','2026-04-24 00:24:50'),
(272,106,'مصنع الشيكولاتة','مصنع الشيكولاتة','2026-04-24 00:24:50','2026-04-24 00:24:50'),
(273,106,'حديقة الباتريارك','حديقة الباتريارك','2026-04-24 00:24:50','2026-04-24 00:24:50'),
(274,106,'برج أوستانكينو','برج أوستانكينو','2026-04-24 00:24:50','2026-04-24 00:24:50'),
(275,106,'دريم لاند موسكو','دريم لاند موسكو','2026-04-24 00:24:50','2026-04-24 00:24:50'),
(276,106,'شارع أربات','شارع أربات','2026-04-24 00:24:50','2026-04-24 00:24:50'),
(277,106,'رحلة نهرية راديسون','رحلة نهرية راديسون','2026-04-24 00:24:50','2026-04-24 00:24:50'),
(278,106,'حديقة الهاسكي','حديقة الهاسكي','2026-04-24 00:24:50','2026-04-24 00:24:50'),
(279,106,'حديقة النصر','حديقة النصر','2026-04-24 00:24:50','2026-04-24 00:24:50'),
(280,106,'تلفريك موسكو','تلفريك موسكو','2026-04-24 00:24:50','2026-04-24 00:24:50'),
(281,107,'مطعم أكشبات','مطعم أكشبات','2026-04-24 00:27:06','2026-04-24 00:27:06'),
(282,107,'تلفريك طرابزون','تلفريك طرابزون','2026-04-24 00:27:06','2026-04-24 00:27:06'),
(283,107,'مدينة ريزا','مدينة ريزا','2026-04-24 00:27:06','2026-04-24 00:27:06'),
(284,107,'أيدر ( رافتنج - دبابات )','أيدر ( رافتنج - دبابات )','2026-04-24 00:27:06','2026-04-24 00:27:06'),
(285,107,'حديقة الشاي','حديقة الشاي','2026-04-24 00:27:06','2026-04-24 00:27:06'),
(286,107,'بحيرة سيراجول','بحيرة سيراجول','2026-04-24 00:27:06','2026-04-24 00:27:06'),
(287,107,'قرية همسي كوي','قرية همسي كوي','2026-04-24 00:27:06','2026-04-24 00:27:06'),
(288,107,'مطعم زيناش','مطعم زيناش','2026-04-24 00:27:06','2026-04-24 00:27:06'),
(289,107,'مول فورم طرابزون','مول فورم طرابزون','2026-04-24 00:27:06','2026-04-24 00:27:06'),
(290,108,'قصر بيلر بيه','قصر بيلر بيه','2026-04-24 00:27:06','2026-04-24 00:27:06'),
(291,108,'كورنيش الاورتاكوي','كورنيش الاورتاكوي','2026-04-24 00:27:06','2026-04-24 00:27:06'),
(292,108,'السوق المصري','السوق المصري','2026-04-24 00:27:06','2026-04-24 00:27:06'),
(293,108,'جولة بالبوسفور','جولة بالبوسفور','2026-04-24 00:27:06','2026-04-24 00:27:06'),
(294,108,'قلعة بورت','قلعة بورت','2026-04-24 00:27:06','2026-04-24 00:27:06'),
(295,108,'شارع الاستقلال','شارع الاستقلال','2026-04-24 00:27:06','2026-04-24 00:27:06'),
(296,109,'بحيرة اوزنجول ( مطاعم ، كافيهات )','بحيرة اوزنجول ( مطاعم ، كافيهات )','2026-04-24 00:27:06','2026-04-24 00:27:06'),
(297,109,'شلالات اوزنجول','شلالات اوزنجول','2026-04-24 00:27:06','2026-04-24 00:27:06'),
(298,109,'قرية ديمر كبي','قرية ديمر كبي','2026-04-24 00:27:06','2026-04-24 00:27:06'),
(299,109,'كوم كافيه','كوم كافيه','2026-04-24 00:27:06','2026-04-24 00:27:06'),
(300,109,'المطل الزجاجي','المطل الزجاجي','2026-04-24 00:27:06','2026-04-24 00:27:06'),
(301,109,'مطل بوزتبا','مطل بوزتبا','2026-04-24 00:27:06','2026-04-24 00:27:06'),
(302,109,'مول فورم طرابزون','مول فورم طرابزون','2026-04-24 00:27:06','2026-04-24 00:27:06'),
(303,110,'مطعم أكشبات','مطعم أكشبات','2026-04-24 00:27:08','2026-04-24 00:27:08'),
(304,110,'تلفريك طرابزون','تلفريك طرابزون','2026-04-24 00:27:08','2026-04-24 00:27:08'),
(305,110,'مدينة ريزا','مدينة ريزا','2026-04-24 00:27:08','2026-04-24 00:27:08'),
(306,110,'أيدر ( رافتنج - دبابات )','أيدر ( رافتنج - دبابات )','2026-04-24 00:27:08','2026-04-24 00:27:08'),
(307,110,'حديقة الشاي','حديقة الشاي','2026-04-24 00:27:08','2026-04-24 00:27:08'),
(308,110,'بحيرة سيراجول','بحيرة سيراجول','2026-04-24 00:27:08','2026-04-24 00:27:08'),
(309,110,'قرية همسي كوي','قرية همسي كوي','2026-04-24 00:27:08','2026-04-24 00:27:08'),
(310,110,'مطعم زيناش','مطعم زيناش','2026-04-24 00:27:08','2026-04-24 00:27:08'),
(311,110,'مول فورم طرابزون','مول فورم طرابزون','2026-04-24 00:27:08','2026-04-24 00:27:08'),
(312,111,'قصر بيلر بيه','قصر بيلر بيه','2026-04-24 00:27:08','2026-04-24 00:27:08'),
(313,111,'كورنيش الاورتاكوي','كورنيش الاورتاكوي','2026-04-24 00:27:08','2026-04-24 00:27:08'),
(314,111,'السوق المصري','السوق المصري','2026-04-24 00:27:08','2026-04-24 00:27:08'),
(315,111,'جولة بالبوسفور','جولة بالبوسفور','2026-04-24 00:27:08','2026-04-24 00:27:08'),
(316,111,'قلعة بورت','قلعة بورت','2026-04-24 00:27:08','2026-04-24 00:27:08'),
(317,111,'شارع الاستقلال','شارع الاستقلال','2026-04-24 00:27:08','2026-04-24 00:27:08'),
(318,112,'بحيرة اوزنجول ( مطاعم ، كافيهات )','بحيرة اوزنجول ( مطاعم ، كافيهات )','2026-04-24 00:27:08','2026-04-24 00:27:08'),
(319,112,'شلالات اوزنجول','شلالات اوزنجول','2026-04-24 00:27:08','2026-04-24 00:27:08'),
(320,112,'قرية ديمر كبي','قرية ديمر كبي','2026-04-24 00:27:08','2026-04-24 00:27:08'),
(321,112,'كوم كافيه','كوم كافيه','2026-04-24 00:27:08','2026-04-24 00:27:08'),
(322,112,'المطل الزجاجي','المطل الزجاجي','2026-04-24 00:27:08','2026-04-24 00:27:08'),
(323,112,'مطل بوزتبا','مطل بوزتبا','2026-04-24 00:27:08','2026-04-24 00:27:08'),
(324,112,'مول فورم طرابزون','مول فورم طرابزون','2026-04-24 00:27:08','2026-04-24 00:27:08'),
(325,113,'مطعم أكشبات','مطعم أكشبات','2026-04-24 00:27:37','2026-04-24 00:27:37'),
(326,113,'تلفريك طرابزون','تلفريك طرابزون','2026-04-24 00:27:37','2026-04-24 00:27:37'),
(327,113,'مدينة ريزا','مدينة ريزا','2026-04-24 00:27:37','2026-04-24 00:27:37'),
(328,113,'أيدر ( رافتنج - دبابات )','أيدر ( رافتنج - دبابات )','2026-04-24 00:27:37','2026-04-24 00:27:37'),
(329,113,'حديقة الشاي','حديقة الشاي','2026-04-24 00:27:37','2026-04-24 00:27:37'),
(330,113,'بحيرة سيراجول','بحيرة سيراجول','2026-04-24 00:27:37','2026-04-24 00:27:37'),
(331,113,'قرية همسي كوي','قرية همسي كوي','2026-04-24 00:27:37','2026-04-24 00:27:37'),
(332,113,'مطعم زيناش','مطعم زيناش','2026-04-24 00:27:37','2026-04-24 00:27:37'),
(333,113,'مول فورم طرابزون','مول فورم طرابزون','2026-04-24 00:27:37','2026-04-24 00:27:37'),
(334,114,'بحيرة اوزنجول ( مطاعم ، كافيهات )','بحيرة اوزنجول ( مطاعم ، كافيهات )','2026-04-24 00:27:37','2026-04-24 00:27:37'),
(335,114,'شلالات اوزنجول','شلالات اوزنجول','2026-04-24 00:27:37','2026-04-24 00:27:37'),
(336,114,'قرية ديمر كبي','قرية ديمر كبي','2026-04-24 00:27:37','2026-04-24 00:27:37'),
(337,114,'كوم كافيه','كوم كافيه','2026-04-24 00:27:37','2026-04-24 00:27:37'),
(338,114,'المطل الزجاجي','المطل الزجاجي','2026-04-24 00:27:37','2026-04-24 00:27:37'),
(339,114,'مطل بوزتبا','مطل بوزتبا','2026-04-24 00:27:37','2026-04-24 00:27:37'),
(340,114,'مول فورم طرابزون','مول فورم طرابزون','2026-04-24 00:27:37','2026-04-24 00:27:37'),
(341,115,'قصر بيلر بيه','قصر بيلر بيه','2026-04-24 00:27:37','2026-04-24 00:27:37'),
(342,115,'كورنيش الاورتاكوي','كورنيش الاورتاكوي','2026-04-24 00:27:37','2026-04-24 00:27:37'),
(343,115,'السوق المصري','السوق المصري','2026-04-24 00:27:37','2026-04-24 00:27:37'),
(344,115,'جولة بالبوسفور','جولة بالبوسفور','2026-04-24 00:27:37','2026-04-24 00:27:37'),
(345,115,'قلعة بورت','قلعة بورت','2026-04-24 00:27:37','2026-04-24 00:27:37'),
(346,115,'شارع الاستقلال','شارع الاستقلال','2026-04-24 00:27:37','2026-04-24 00:27:37'),
(347,116,'مطعم أكشبات','مطعم أكشبات','2026-04-24 00:35:00','2026-04-24 00:35:00'),
(348,116,'تلفريك طرابزون','تلفريك طرابزون','2026-04-24 00:35:00','2026-04-24 00:35:00'),
(349,116,'مدينة ريزا','مدينة ريزا','2026-04-24 00:35:00','2026-04-24 00:35:00'),
(350,116,'أيدر ( رافتنج - دبابات )','أيدر ( رافتنج - دبابات )','2026-04-24 00:35:00','2026-04-24 00:35:00'),
(351,116,'حديقة الشاي','حديقة الشاي','2026-04-24 00:35:00','2026-04-24 00:35:00'),
(352,116,'بحيرة سيراجول','بحيرة سيراجول','2026-04-24 00:35:00','2026-04-24 00:35:00'),
(353,116,'قرية همسي كوي','قرية همسي كوي','2026-04-24 00:35:00','2026-04-24 00:35:00'),
(354,116,'مطعم زيناش','مطعم زيناش','2026-04-24 00:35:00','2026-04-24 00:35:00'),
(355,116,'مول فورم طرابزون','مول فورم طرابزون','2026-04-24 00:35:00','2026-04-24 00:35:00'),
(356,117,'بحيرة اوزنجول ( مطاعم ، كافيهات )','بحيرة اوزنجول ( مطاعم ، كافيهات )','2026-04-24 00:35:00','2026-04-24 00:35:00'),
(357,117,'شلالات اوزنجول','شلالات اوزنجول','2026-04-24 00:35:00','2026-04-24 00:35:00'),
(358,117,'قرية ديمر كبي','قرية ديمر كبي','2026-04-24 00:35:00','2026-04-24 00:35:00'),
(359,117,'كوم كافيه','كوم كافيه','2026-04-24 00:35:00','2026-04-24 00:35:00'),
(360,117,'المطل الزجاجي','المطل الزجاجي','2026-04-24 00:35:00','2026-04-24 00:35:00'),
(361,117,'مطل بوزتبا','مطل بوزتبا','2026-04-24 00:35:00','2026-04-24 00:35:00'),
(362,117,'مول فورم طرابزون','مول فورم طرابزون','2026-04-24 00:35:00','2026-04-24 00:35:00'),
(363,118,'قصر بيلر بيه','قصر بيلر بيه','2026-04-24 00:35:00','2026-04-24 00:35:00'),
(364,118,'كورنيش الاورتاكوي','كورنيش الاورتاكوي','2026-04-24 00:35:00','2026-04-24 00:35:00'),
(365,118,'السوق المصري','السوق المصري','2026-04-24 00:35:00','2026-04-24 00:35:00'),
(366,118,'جولة بالبوسفور','جولة بالبوسفور','2026-04-24 00:35:00','2026-04-24 00:35:00'),
(367,118,'قلعة بورت','قلعة بورت','2026-04-24 00:35:00','2026-04-24 00:35:00'),
(368,118,'شارع الاستقلال','شارع الاستقلال','2026-04-24 00:35:00','2026-04-24 00:35:00'),
(369,119,'مطعم أكشبات','مطعم أكشبات','2026-04-24 02:09:53','2026-04-24 02:09:53'),
(370,119,'تلفريك طرابزون','تلفريك طرابزون','2026-04-24 02:09:53','2026-04-24 02:09:53'),
(371,119,'مدينة ريزا','مدينة ريزا','2026-04-24 02:09:53','2026-04-24 02:09:53'),
(372,119,'أيدر ( رافتنج - دبابات )','أيدر ( رافتنج - دبابات )','2026-04-24 02:09:53','2026-04-24 02:09:53'),
(373,119,'حديقة الشاي','حديقة الشاي','2026-04-24 02:09:53','2026-04-24 02:09:53'),
(374,119,'بحيرة سيراجول','بحيرة سيراجول','2026-04-24 02:09:53','2026-04-24 02:09:53'),
(375,119,'قرية همسي كوي','قرية همسي كوي','2026-04-24 02:09:53','2026-04-24 02:09:53'),
(376,119,'مطعم زيناش','مطعم زيناش','2026-04-24 02:09:53','2026-04-24 02:09:53'),
(377,119,'مول فورم طرابزون','مول فورم طرابزون','2026-04-24 02:09:53','2026-04-24 02:09:53'),
(378,120,'قصر بيلر بيه','قصر بيلر بيه','2026-04-24 02:09:53','2026-04-24 02:09:53'),
(379,120,'كورنيش الاورتاكوي','كورنيش الاورتاكوي','2026-04-24 02:09:53','2026-04-24 02:09:53'),
(380,120,'السوق المصري','السوق المصري','2026-04-24 02:09:53','2026-04-24 02:09:53'),
(381,120,'جولة بالبوسفور','جولة بالبوسفور','2026-04-24 02:09:53','2026-04-24 02:09:53'),
(382,120,'قلعة بورت','قلعة بورت','2026-04-24 02:09:53','2026-04-24 02:09:53'),
(383,120,'شارع الاستقلال','شارع الاستقلال','2026-04-24 02:09:53','2026-04-24 02:09:53'),
(384,121,'بحيرة اوزنجول ( مطاعم ، كافيهات )','بحيرة اوزنجول ( مطاعم ، كافيهات )','2026-04-24 02:09:53','2026-04-24 02:09:53'),
(385,121,'شلالات اوزنجول','شلالات اوزنجول','2026-04-24 02:09:53','2026-04-24 02:09:53'),
(386,121,'قرية ديمر كبي','قرية ديمر كبي','2026-04-24 02:09:53','2026-04-24 02:09:53'),
(387,121,'كوم كافيه','كوم كافيه','2026-04-24 02:09:53','2026-04-24 02:09:53'),
(388,121,'المطل الزجاجي','المطل الزجاجي','2026-04-24 02:09:53','2026-04-24 02:09:53'),
(389,121,'مطل بوزتبا','مطل بوزتبا','2026-04-24 02:09:53','2026-04-24 02:09:53'),
(390,121,'مول فورم طرابزون','مول فورم طرابزون','2026-04-24 02:09:53','2026-04-24 02:09:53'),
(391,122,'مطعم أكشبات','مطعم أكشبات','2026-04-24 02:11:22','2026-04-24 02:11:22'),
(392,122,'تلفريك طرابزون','تلفريك طرابزون','2026-04-24 02:11:22','2026-04-24 02:11:22'),
(393,122,'مدينة ريزا','مدينة ريزا','2026-04-24 02:11:22','2026-04-24 02:11:22'),
(394,122,'أيدر ( رافتنج - دبابات )','أيدر ( رافتنج - دبابات )','2026-04-24 02:11:22','2026-04-24 02:11:22'),
(395,122,'حديقة الشاي','حديقة الشاي','2026-04-24 02:11:22','2026-04-24 02:11:22'),
(396,122,'بحيرة سيراجول','بحيرة سيراجول','2026-04-24 02:11:22','2026-04-24 02:11:22'),
(397,122,'قرية همسي كوي','قرية همسي كوي','2026-04-24 02:11:22','2026-04-24 02:11:22'),
(398,122,'مطعم زيناش','مطعم زيناش','2026-04-24 02:11:22','2026-04-24 02:11:22'),
(399,122,'مول فورم طرابزون','مول فورم طرابزون','2026-04-24 02:11:22','2026-04-24 02:11:22'),
(400,123,'قصر بيلر بيه','قصر بيلر بيه','2026-04-24 02:11:22','2026-04-24 02:11:22'),
(401,123,'كورنيش الاورتاكوي','كورنيش الاورتاكوي','2026-04-24 02:11:22','2026-04-24 02:11:22'),
(402,123,'السوق المصري','السوق المصري','2026-04-24 02:11:22','2026-04-24 02:11:22'),
(403,123,'جولة بالبوسفور','جولة بالبوسفور','2026-04-24 02:11:22','2026-04-24 02:11:22'),
(404,123,'قلعة بورت','قلعة بورت','2026-04-24 02:11:22','2026-04-24 02:11:22'),
(405,123,'شارع الاستقلال','شارع الاستقلال','2026-04-24 02:11:22','2026-04-24 02:11:22'),
(406,124,'بحيرة اوزنجول ( مطاعم ، كافيهات )','بحيرة اوزنجول ( مطاعم ، كافيهات )','2026-04-24 02:11:22','2026-04-24 02:11:22'),
(407,124,'شلالات اوزنجول','شلالات اوزنجول','2026-04-24 02:11:22','2026-04-24 02:11:22'),
(408,124,'قرية ديمر كبي','قرية ديمر كبي','2026-04-24 02:11:22','2026-04-24 02:11:22'),
(409,124,'كوم كافيه','كوم كافيه','2026-04-24 02:11:22','2026-04-24 02:11:22'),
(410,124,'المطل الزجاجي','المطل الزجاجي','2026-04-24 02:11:22','2026-04-24 02:11:22'),
(411,124,'مطل بوزتبا','مطل بوزتبا','2026-04-24 02:11:22','2026-04-24 02:11:22'),
(412,124,'مول فورم طرابزون','مول فورم طرابزون','2026-04-24 02:11:22','2026-04-24 02:11:22'),
(413,125,'الساحة الحمراء','الساحة الحمراء','2026-04-25 04:18:57','2026-04-25 04:18:57'),
(414,125,'الرحلة النهرية','الرحلة النهرية','2026-04-25 04:18:57','2026-04-25 04:18:57'),
(415,125,'مركز جوم التجاري (سوق Gum)','مركز جوم التجاري (سوق Gum)','2026-04-25 04:18:57','2026-04-25 04:18:57'),
(416,125,'منطقة كيتاي غورود','منطقة كيتاي غورود','2026-04-25 04:18:57','2026-04-25 04:18:57'),
(417,125,'الجسر المعلق','الجسر المعلق','2026-04-25 04:18:57','2026-04-25 04:18:57'),
(418,125,'صندوق الألماس الروسي داخل الكرملين','صندوق الألماس الروسي داخل الكرملين','2026-04-25 04:18:57','2026-04-25 04:18:57'),
(419,125,'منطقة الأخوات السبع','منطقة الأخوات السبع','2026-04-25 04:18:57','2026-04-25 04:18:57'),
(420,125,'مصنع الشيكولاتة','مصنع الشيكولاتة','2026-04-25 04:18:57','2026-04-25 04:18:57'),
(421,125,'حديقة الباتريارك','حديقة الباتريارك','2026-04-25 04:18:57','2026-04-25 04:18:57'),
(422,125,'برج أوستانكينو','برج أوستانكينو','2026-04-25 04:18:57','2026-04-25 04:18:57'),
(423,125,'دريم لاند موسكو','دريم لاند موسكو','2026-04-25 04:18:57','2026-04-25 04:18:57'),
(424,125,'شارع أربات','شارع أربات','2026-04-25 04:18:57','2026-04-25 04:18:57'),
(425,125,'رحلة نهرية راديسون','رحلة نهرية راديسون','2026-04-25 04:18:57','2026-04-25 04:18:57'),
(426,125,'حديقة الهاسكي','حديقة الهاسكي','2026-04-25 04:18:57','2026-04-25 04:18:57'),
(427,125,'حديقة النصر','حديقة النصر','2026-04-25 04:18:57','2026-04-25 04:18:57'),
(428,125,'تلفريك موسكو','تلفريك موسكو','2026-04-25 04:18:57','2026-04-25 04:18:57'),
(429,126,'مطعم أكشبات','مطعم أكشبات','2026-04-25 04:19:16','2026-04-25 04:19:16'),
(430,126,'تلفريك طرابزون','تلفريك طرابزون','2026-04-25 04:19:16','2026-04-25 04:19:16'),
(431,126,'مدينة ريزا','مدينة ريزا','2026-04-25 04:19:16','2026-04-25 04:19:16'),
(432,126,'أيدر ( رافتنج - دبابات )','أيدر ( رافتنج - دبابات )','2026-04-25 04:19:16','2026-04-25 04:19:16'),
(433,126,'حديقة الشاي','حديقة الشاي','2026-04-25 04:19:16','2026-04-25 04:19:16'),
(434,126,'بحيرة سيراجول','بحيرة سيراجول','2026-04-25 04:19:16','2026-04-25 04:19:16'),
(435,126,'قرية همسي كوي','قرية همسي كوي','2026-04-25 04:19:16','2026-04-25 04:19:16'),
(436,126,'مطعم زيناش','مطعم زيناش','2026-04-25 04:19:16','2026-04-25 04:19:16'),
(437,126,'مول فورم طرابزون','مول فورم طرابزون','2026-04-25 04:19:16','2026-04-25 04:19:16'),
(438,127,'بحيرة اوزنجول ( مطاعم ، كافيهات )','بحيرة اوزنجول ( مطاعم ، كافيهات )','2026-04-25 04:19:16','2026-04-25 04:19:16'),
(439,127,'شلالات اوزنجول','شلالات اوزنجول','2026-04-25 04:19:16','2026-04-25 04:19:16'),
(440,127,'قرية ديمر كبي','قرية ديمر كبي','2026-04-25 04:19:16','2026-04-25 04:19:16'),
(441,127,'كوم كافيه','كوم كافيه','2026-04-25 04:19:16','2026-04-25 04:19:16'),
(442,127,'المطل الزجاجي','المطل الزجاجي','2026-04-25 04:19:16','2026-04-25 04:19:16'),
(443,127,'مطل بوزتبا','مطل بوزتبا','2026-04-25 04:19:16','2026-04-25 04:19:16'),
(444,127,'مول فورم طرابزون','مول فورم طرابزون','2026-04-25 04:19:16','2026-04-25 04:19:16'),
(445,128,'قصر بيلر بيه','قصر بيلر بيه','2026-04-25 04:19:16','2026-04-25 04:19:16'),
(446,128,'كورنيش الاورتاكوي','كورنيش الاورتاكوي','2026-04-25 04:19:16','2026-04-25 04:19:16'),
(447,128,'السوق المصري','السوق المصري','2026-04-25 04:19:16','2026-04-25 04:19:16'),
(448,128,'جولة بالبوسفور','جولة بالبوسفور','2026-04-25 04:19:16','2026-04-25 04:19:16'),
(449,128,'قلعة بورت','قلعة بورت','2026-04-25 04:19:16','2026-04-25 04:19:16'),
(450,128,'شارع الاستقلال','شارع الاستقلال','2026-04-25 04:19:16','2026-04-25 04:19:16'),
(451,129,'مطعم أكشبات','مطعم أكشبات','2026-04-25 20:08:20','2026-04-25 20:08:20'),
(452,129,'تلفريك طرابزون','تلفريك طرابزون','2026-04-25 20:08:20','2026-04-25 20:08:20'),
(453,129,'مدينة ريزا','مدينة ريزا','2026-04-25 20:08:20','2026-04-25 20:08:20'),
(454,129,'أيدر ( رافتنج - دبابات )','أيدر ( رافتنج - دبابات )','2026-04-25 20:08:20','2026-04-25 20:08:20'),
(455,129,'حديقة الشاي','حديقة الشاي','2026-04-25 20:08:20','2026-04-25 20:08:20'),
(456,129,'بحيرة سيراجول','بحيرة سيراجول','2026-04-25 20:08:20','2026-04-25 20:08:20'),
(457,129,'قرية همسي كوي','قرية همسي كوي','2026-04-25 20:08:20','2026-04-25 20:08:20'),
(458,129,'مطعم زيناش','مطعم زيناش','2026-04-25 20:08:20','2026-04-25 20:08:20'),
(459,129,'مول فورم طرابزون','مول فورم طرابزون','2026-04-25 20:08:20','2026-04-25 20:08:20'),
(460,130,'بحيرة اوزنجول ( مطاعم ، كافيهات )','بحيرة اوزنجول ( مطاعم ، كافيهات )','2026-04-25 20:08:20','2026-04-25 20:08:20'),
(461,130,'شلالات اوزنجول','شلالات اوزنجول','2026-04-25 20:08:20','2026-04-25 20:08:20'),
(462,130,'قرية ديمر كبي','قرية ديمر كبي','2026-04-25 20:08:20','2026-04-25 20:08:20'),
(463,130,'كوم كافيه','كوم كافيه','2026-04-25 20:08:20','2026-04-25 20:08:20'),
(464,130,'المطل الزجاجي','المطل الزجاجي','2026-04-25 20:08:20','2026-04-25 20:08:20'),
(465,130,'مطل بوزتبا','مطل بوزتبا','2026-04-25 20:08:20','2026-04-25 20:08:20'),
(466,130,'مول فورم طرابزون','مول فورم طرابزون','2026-04-25 20:08:20','2026-04-25 20:08:20'),
(467,131,'قصر بيلر بيه','قصر بيلر بيه','2026-04-25 20:08:20','2026-04-25 20:08:20'),
(468,131,'كورنيش الاورتاكوي','كورنيش الاورتاكوي','2026-04-25 20:08:20','2026-04-25 20:08:20'),
(469,131,'السوق المصري','السوق المصري','2026-04-25 20:08:20','2026-04-25 20:08:20'),
(470,131,'جولة بالبوسفور','جولة بالبوسفور','2026-04-25 20:08:20','2026-04-25 20:08:20'),
(471,131,'قلعة بورت','قلعة بورت','2026-04-25 20:08:20','2026-04-25 20:08:20'),
(472,131,'شارع الاستقلال','شارع الاستقلال','2026-04-25 20:08:20','2026-04-25 20:08:20'),
(473,132,'قصر بيلر بيه','قصر بيلر بيه','2026-04-25 20:08:50','2026-04-25 20:08:50'),
(474,132,'كورنيش الاورتاكوي','كورنيش الاورتاكوي','2026-04-25 20:08:50','2026-04-25 20:08:50'),
(475,132,'السوق المصري','السوق المصري','2026-04-25 20:08:50','2026-04-25 20:08:50'),
(476,132,'جولة بالبوسفور','جولة بالبوسفور','2026-04-25 20:08:50','2026-04-25 20:08:50'),
(477,132,'قلعة بورت','قلعة بورت','2026-04-25 20:08:50','2026-04-25 20:08:50'),
(478,132,'شارع الاستقلال','شارع الاستقلال','2026-04-25 20:08:50','2026-04-25 20:08:50'),
(479,133,'بحيرة اوزنجول ( مطاعم ، كافيهات )','بحيرة اوزنجول ( مطاعم ، كافيهات )','2026-04-25 20:08:50','2026-04-25 20:08:50'),
(480,133,'شلالات اوزنجول','شلالات اوزنجول','2026-04-25 20:08:50','2026-04-25 20:08:50'),
(481,133,'قرية ديمر كبي','قرية ديمر كبي','2026-04-25 20:08:50','2026-04-25 20:08:50'),
(482,133,'كوم كافيه','كوم كافيه','2026-04-25 20:08:50','2026-04-25 20:08:50'),
(483,133,'المطل الزجاجي','المطل الزجاجي','2026-04-25 20:08:50','2026-04-25 20:08:50'),
(484,133,'مطل بوزتبا','مطل بوزتبا','2026-04-25 20:08:50','2026-04-25 20:08:50'),
(485,133,'مول فورم طرابزون','مول فورم طرابزون','2026-04-25 20:08:50','2026-04-25 20:08:50'),
(486,134,'مطعم أكشبات','مطعم أكشبات','2026-04-25 20:08:50','2026-04-25 20:08:50'),
(487,134,'تلفريك طرابزون','تلفريك طرابزون','2026-04-25 20:08:50','2026-04-25 20:08:50'),
(488,134,'مدينة ريزا','مدينة ريزا','2026-04-25 20:08:50','2026-04-25 20:08:50'),
(489,134,'أيدر ( رافتنج - دبابات )','أيدر ( رافتنج - دبابات )','2026-04-25 20:08:50','2026-04-25 20:08:50'),
(490,134,'حديقة الشاي','حديقة الشاي','2026-04-25 20:08:50','2026-04-25 20:08:50'),
(491,134,'بحيرة سيراجول','بحيرة سيراجول','2026-04-25 20:08:50','2026-04-25 20:08:50'),
(492,134,'قرية همسي كوي','قرية همسي كوي','2026-04-25 20:08:50','2026-04-25 20:08:50'),
(493,134,'مطعم زيناش','مطعم زيناش','2026-04-25 20:08:50','2026-04-25 20:08:50'),
(494,134,'مول فورم طرابزون','مول فورم طرابزون','2026-04-25 20:08:50','2026-04-25 20:08:50'),
(495,135,'قصر بيلر بيه','قصر بيلر بيه','2026-04-25 20:09:24','2026-04-25 20:09:24'),
(496,135,'كورنيش الاورتاكوي','كورنيش الاورتاكوي','2026-04-25 20:09:24','2026-04-25 20:09:24'),
(497,135,'السوق المصري','السوق المصري','2026-04-25 20:09:24','2026-04-25 20:09:24'),
(498,135,'جولة بالبوسفور','جولة بالبوسفور','2026-04-25 20:09:24','2026-04-25 20:09:24'),
(499,135,'قلعة بورت','قلعة بورت','2026-04-25 20:09:24','2026-04-25 20:09:24'),
(500,135,'شارع الاستقلال','شارع الاستقلال','2026-04-25 20:09:24','2026-04-25 20:09:24'),
(501,136,'بحيرة اوزنجول ( مطاعم ، كافيهات )','بحيرة اوزنجول ( مطاعم ، كافيهات )','2026-04-25 20:09:24','2026-04-25 20:09:24'),
(502,136,'شلالات اوزنجول','شلالات اوزنجول','2026-04-25 20:09:24','2026-04-25 20:09:24'),
(503,136,'قرية ديمر كبي','قرية ديمر كبي','2026-04-25 20:09:24','2026-04-25 20:09:24'),
(504,136,'كوم كافيه','كوم كافيه','2026-04-25 20:09:24','2026-04-25 20:09:24'),
(505,136,'المطل الزجاجي','المطل الزجاجي','2026-04-25 20:09:24','2026-04-25 20:09:24'),
(506,136,'مطل بوزتبا','مطل بوزتبا','2026-04-25 20:09:24','2026-04-25 20:09:24'),
(507,136,'مول فورم طرابزون','مول فورم طرابزون','2026-04-25 20:09:24','2026-04-25 20:09:24'),
(508,137,'مطعم أكشبات','مطعم أكشبات','2026-04-25 20:09:24','2026-04-25 20:09:24'),
(509,137,'تلفريك طرابزون','تلفريك طرابزون','2026-04-25 20:09:24','2026-04-25 20:09:24'),
(510,137,'مدينة ريزا','مدينة ريزا','2026-04-25 20:09:24','2026-04-25 20:09:24'),
(511,137,'أيدر ( رافتنج - دبابات )','أيدر ( رافتنج - دبابات )','2026-04-25 20:09:24','2026-04-25 20:09:24'),
(512,137,'حديقة الشاي','حديقة الشاي','2026-04-25 20:09:24','2026-04-25 20:09:24'),
(513,137,'بحيرة سيراجول','بحيرة سيراجول','2026-04-25 20:09:24','2026-04-25 20:09:24'),
(514,137,'قرية همسي كوي','قرية همسي كوي','2026-04-25 20:09:24','2026-04-25 20:09:24'),
(515,137,'مطعم زيناش','مطعم زيناش','2026-04-25 20:09:24','2026-04-25 20:09:24'),
(516,137,'مول فورم طرابزون','مول فورم طرابزون','2026-04-25 20:09:24','2026-04-25 20:09:24'),
(517,138,'قصر بيلر بيه','قصر بيلر بيه','2026-04-25 20:09:34','2026-04-25 20:09:34'),
(518,138,'كورنيش الاورتاكوي','كورنيش الاورتاكوي','2026-04-25 20:09:34','2026-04-25 20:09:34'),
(519,138,'السوق المصري','السوق المصري','2026-04-25 20:09:34','2026-04-25 20:09:34'),
(520,138,'جولة بالبوسفور','جولة بالبوسفور','2026-04-25 20:09:34','2026-04-25 20:09:34'),
(521,138,'قلعة بورت','قلعة بورت','2026-04-25 20:09:34','2026-04-25 20:09:34'),
(522,138,'شارع الاستقلال','شارع الاستقلال','2026-04-25 20:09:34','2026-04-25 20:09:34'),
(523,139,'بحيرة اوزنجول ( مطاعم ، كافيهات )','بحيرة اوزنجول ( مطاعم ، كافيهات )','2026-04-25 20:09:34','2026-04-25 20:09:34'),
(524,139,'شلالات اوزنجول','شلالات اوزنجول','2026-04-25 20:09:34','2026-04-25 20:09:34'),
(525,139,'قرية ديمر كبي','قرية ديمر كبي','2026-04-25 20:09:34','2026-04-25 20:09:34'),
(526,139,'كوم كافيه','كوم كافيه','2026-04-25 20:09:34','2026-04-25 20:09:34'),
(527,139,'المطل الزجاجي','المطل الزجاجي','2026-04-25 20:09:34','2026-04-25 20:09:34'),
(528,139,'مطل بوزتبا','مطل بوزتبا','2026-04-25 20:09:34','2026-04-25 20:09:34'),
(529,139,'مول فورم طرابزون','مول فورم طرابزون','2026-04-25 20:09:34','2026-04-25 20:09:34'),
(530,140,'مطعم أكشبات','مطعم أكشبات','2026-04-25 20:09:34','2026-04-25 20:09:34'),
(531,140,'تلفريك طرابزون','تلفريك طرابزون','2026-04-25 20:09:34','2026-04-25 20:09:34'),
(532,140,'مدينة ريزا','مدينة ريزا','2026-04-25 20:09:34','2026-04-25 20:09:34'),
(533,140,'أيدر ( رافتنج - دبابات )','أيدر ( رافتنج - دبابات )','2026-04-25 20:09:34','2026-04-25 20:09:34'),
(534,140,'حديقة الشاي','حديقة الشاي','2026-04-25 20:09:34','2026-04-25 20:09:34'),
(535,140,'بحيرة سيراجول','بحيرة سيراجول','2026-04-25 20:09:34','2026-04-25 20:09:34'),
(536,140,'قرية همسي كوي','قرية همسي كوي','2026-04-25 20:09:34','2026-04-25 20:09:34'),
(537,140,'مطعم زيناش','مطعم زيناش','2026-04-25 20:09:34','2026-04-25 20:09:34'),
(538,140,'مول فورم طرابزون','مول فورم طرابزون','2026-04-25 20:09:34','2026-04-25 20:09:34'),
(539,141,'مطعم أكشبات','مطعم أكشبات','2026-04-25 20:10:03','2026-04-25 20:10:03'),
(540,141,'تلفريك طرابزون','تلفريك طرابزون','2026-04-25 20:10:03','2026-04-25 20:10:03'),
(541,141,'مدينة ريزا','مدينة ريزا','2026-04-25 20:10:03','2026-04-25 20:10:03'),
(542,141,'أيدر ( رافتنج - دبابات )','أيدر ( رافتنج - دبابات )','2026-04-25 20:10:03','2026-04-25 20:10:03'),
(543,141,'حديقة الشاي','حديقة الشاي','2026-04-25 20:10:03','2026-04-25 20:10:03'),
(544,141,'بحيرة سيراجول','بحيرة سيراجول','2026-04-25 20:10:03','2026-04-25 20:10:03'),
(545,141,'قرية همسي كوي','قرية همسي كوي','2026-04-25 20:10:03','2026-04-25 20:10:03'),
(546,141,'مطعم زيناش','مطعم زيناش','2026-04-25 20:10:03','2026-04-25 20:10:03'),
(547,141,'مول فورم طرابزون','مول فورم طرابزون','2026-04-25 20:10:03','2026-04-25 20:10:03'),
(548,142,'قصر بيلر بيه','قصر بيلر بيه','2026-04-25 20:10:03','2026-04-25 20:10:03'),
(549,142,'كورنيش الاورتاكوي','كورنيش الاورتاكوي','2026-04-25 20:10:03','2026-04-25 20:10:03'),
(550,142,'السوق المصري','السوق المصري','2026-04-25 20:10:03','2026-04-25 20:10:03'),
(551,142,'جولة بالبوسفور','جولة بالبوسفور','2026-04-25 20:10:03','2026-04-25 20:10:03'),
(552,142,'قلعة بورت','قلعة بورت','2026-04-25 20:10:03','2026-04-25 20:10:03'),
(553,142,'شارع الاستقلال','شارع الاستقلال','2026-04-25 20:10:03','2026-04-25 20:10:03'),
(554,143,'بحيرة اوزنجول ( مطاعم ، كافيهات )','بحيرة اوزنجول ( مطاعم ، كافيهات )','2026-04-25 20:10:03','2026-04-25 20:10:03'),
(555,143,'شلالات اوزنجول','شلالات اوزنجول','2026-04-25 20:10:03','2026-04-25 20:10:03'),
(556,143,'قرية ديمر كبي','قرية ديمر كبي','2026-04-25 20:10:03','2026-04-25 20:10:03'),
(557,143,'كوم كافيه','كوم كافيه','2026-04-25 20:10:03','2026-04-25 20:10:03'),
(558,143,'المطل الزجاجي','المطل الزجاجي','2026-04-25 20:10:03','2026-04-25 20:10:03'),
(559,143,'مطل بوزتبا','مطل بوزتبا','2026-04-25 20:10:03','2026-04-25 20:10:03'),
(560,143,'مول فورم طرابزون','مول فورم طرابزون','2026-04-25 20:10:03','2026-04-25 20:10:03'),
(561,195,'الساحة الحمراء','الساحة الحمراء','2026-04-26 15:38:43','2026-04-26 15:38:43'),
(562,195,'الرحلة النهرية','الرحلة النهرية','2026-04-26 15:38:43','2026-04-26 15:38:43'),
(563,195,'مركز جوم التجاري (سوق Gum)','مركز جوم التجاري (سوق Gum)','2026-04-26 15:38:43','2026-04-26 15:38:43'),
(564,195,'منطقة كيتاي غورود','منطقة كيتاي غورود','2026-04-26 15:38:43','2026-04-26 15:38:43'),
(565,195,'الجسر المعلق','الجسر المعلق','2026-04-26 15:38:43','2026-04-26 15:38:43'),
(566,195,'صندوق الألماس الروسي داخل الكرملين','صندوق الألماس الروسي داخل الكرملين','2026-04-26 15:38:43','2026-04-26 15:38:43'),
(567,195,'منطقة الأخوات السبع','منطقة الأخوات السبع','2026-04-26 15:38:43','2026-04-26 15:38:43'),
(568,195,'مصنع الشيكولاتة','مصنع الشيكولاتة','2026-04-26 15:38:43','2026-04-26 15:38:43'),
(569,195,'حديقة الباتريارك','حديقة الباتريارك','2026-04-26 15:38:43','2026-04-26 15:38:43'),
(570,195,'برج أوستانكينو','برج أوستانكينو','2026-04-26 15:38:43','2026-04-26 15:38:43'),
(571,195,'دريم لاند موسكو','دريم لاند موسكو','2026-04-26 15:38:43','2026-04-26 15:38:43'),
(572,195,'شارع أربات','شارع أربات','2026-04-26 15:38:43','2026-04-26 15:38:43'),
(573,195,'رحلة نهرية راديسون','رحلة نهرية راديسون','2026-04-26 15:38:43','2026-04-26 15:38:43'),
(574,195,'حديقة الهاسكي','حديقة الهاسكي','2026-04-26 15:38:43','2026-04-26 15:38:43'),
(575,195,'حديقة النصر','حديقة النصر','2026-04-26 15:38:43','2026-04-26 15:38:43'),
(576,195,'تلفريك موسكو','تلفريك موسكو','2026-04-26 15:38:43','2026-04-26 15:38:43'),
(577,196,'الساحة الحمراء','الساحة الحمراء','2026-04-26 15:40:23','2026-04-26 15:40:23'),
(578,196,'الرحلة النهرية','الرحلة النهرية','2026-04-26 15:40:23','2026-04-26 15:40:23'),
(579,196,'مركز جوم التجاري (سوق Gum)','مركز جوم التجاري (سوق Gum)','2026-04-26 15:40:23','2026-04-26 15:40:23'),
(580,196,'منطقة كيتاي غورود','منطقة كيتاي غورود','2026-04-26 15:40:23','2026-04-26 15:40:23'),
(581,196,'الجسر المعلق','الجسر المعلق','2026-04-26 15:40:23','2026-04-26 15:40:23'),
(582,196,'صندوق الألماس الروسي داخل الكرملين','صندوق الألماس الروسي داخل الكرملين','2026-04-26 15:40:23','2026-04-26 15:40:23'),
(583,196,'منطقة الأخوات السبع','منطقة الأخوات السبع','2026-04-26 15:40:23','2026-04-26 15:40:23'),
(584,196,'مصنع الشيكولاتة','مصنع الشيكولاتة','2026-04-26 15:40:23','2026-04-26 15:40:23'),
(585,196,'حديقة الباتريارك','حديقة الباتريارك','2026-04-26 15:40:23','2026-04-26 15:40:23'),
(586,196,'برج أوستانكينو','برج أوستانكينو','2026-04-26 15:40:23','2026-04-26 15:40:23'),
(587,196,'دريم لاند موسكو','دريم لاند موسكو','2026-04-26 15:40:23','2026-04-26 15:40:23'),
(588,196,'شارع أربات','شارع أربات','2026-04-26 15:40:23','2026-04-26 15:40:23'),
(589,196,'رحلة نهرية راديسون','رحلة نهرية راديسون','2026-04-26 15:40:23','2026-04-26 15:40:23'),
(590,196,'حديقة الهاسكي','حديقة الهاسكي','2026-04-26 15:40:23','2026-04-26 15:40:23'),
(591,196,'حديقة النصر','حديقة النصر','2026-04-26 15:40:23','2026-04-26 15:40:23'),
(592,196,'تلفريك موسكو','تلفريك موسكو','2026-04-26 15:40:23','2026-04-26 15:40:23'),
(593,197,'الساحة الحمراء','الساحة الحمراء','2026-04-26 15:47:38','2026-04-26 15:47:38'),
(594,197,'الرحلة النهرية','الرحلة النهرية','2026-04-26 15:47:38','2026-04-26 15:47:38'),
(595,197,'مركز جوم التجاري (سوق Gum)','مركز جوم التجاري (سوق Gum)','2026-04-26 15:47:38','2026-04-26 15:47:38'),
(596,197,'منطقة كيتاي غورود','منطقة كيتاي غورود','2026-04-26 15:47:38','2026-04-26 15:47:38'),
(597,197,'الجسر المعلق','الجسر المعلق','2026-04-26 15:47:38','2026-04-26 15:47:38'),
(598,197,'صندوق الألماس الروسي داخل الكرملين','صندوق الألماس الروسي داخل الكرملين','2026-04-26 15:47:38','2026-04-26 15:47:38'),
(599,197,'منطقة الأخوات السبع','منطقة الأخوات السبع','2026-04-26 15:47:38','2026-04-26 15:47:38'),
(600,197,'مصنع الشيكولاتة','مصنع الشيكولاتة','2026-04-26 15:47:38','2026-04-26 15:47:38'),
(601,197,'حديقة الباتريارك','حديقة الباتريارك','2026-04-26 15:47:38','2026-04-26 15:47:38'),
(602,197,'برج أوستانكينو','برج أوستانكينو','2026-04-26 15:47:38','2026-04-26 15:47:38'),
(603,197,'دريم لاند موسكو','دريم لاند موسكو','2026-04-26 15:47:38','2026-04-26 15:47:38'),
(604,197,'شارع أربات','شارع أربات','2026-04-26 15:47:38','2026-04-26 15:47:38'),
(605,197,'رحلة نهرية راديسون','رحلة نهرية راديسون','2026-04-26 15:47:38','2026-04-26 15:47:38'),
(606,197,'حديقة الهاسكي','حديقة الهاسكي','2026-04-26 15:47:38','2026-04-26 15:47:38'),
(607,197,'حديقة النصر','حديقة النصر','2026-04-26 15:47:38','2026-04-26 15:47:38'),
(608,197,'تلفريك موسكو','تلفريك موسكو','2026-04-26 15:47:38','2026-04-26 15:47:38'),
(609,198,'الساحة الحمراء','الساحة الحمراء','2026-04-26 15:51:28','2026-04-26 15:51:28'),
(610,198,'الرحلة النهرية','الرحلة النهرية','2026-04-26 15:51:28','2026-04-26 15:51:28'),
(611,198,'مركز جوم التجاري (سوق Gum)','مركز جوم التجاري (سوق Gum)','2026-04-26 15:51:28','2026-04-26 15:51:28'),
(612,198,'منطقة كيتاي غورود','منطقة كيتاي غورود','2026-04-26 15:51:28','2026-04-26 15:51:28'),
(613,198,'الجسر المعلق','الجسر المعلق','2026-04-26 15:51:28','2026-04-26 15:51:28'),
(614,198,'صندوق الألماس الروسي داخل الكرملين','صندوق الألماس الروسي داخل الكرملين','2026-04-26 15:51:28','2026-04-26 15:51:28'),
(615,198,'منطقة الأخوات السبع','منطقة الأخوات السبع','2026-04-26 15:51:28','2026-04-26 15:51:28'),
(616,198,'مصنع الشيكولاتة','مصنع الشيكولاتة','2026-04-26 15:51:28','2026-04-26 15:51:28'),
(617,198,'حديقة الباتريارك','حديقة الباتريارك','2026-04-26 15:51:28','2026-04-26 15:51:28'),
(618,198,'برج أوستانكينو','برج أوستانكينو','2026-04-26 15:51:28','2026-04-26 15:51:28'),
(619,198,'دريم لاند موسكو','دريم لاند موسكو','2026-04-26 15:51:28','2026-04-26 15:51:28'),
(620,198,'شارع أربات','شارع أربات','2026-04-26 15:51:28','2026-04-26 15:51:28'),
(621,198,'رحلة نهرية راديسون','رحلة نهرية راديسون','2026-04-26 15:51:28','2026-04-26 15:51:28'),
(622,198,'حديقة الهاسكي','حديقة الهاسكي','2026-04-26 15:51:28','2026-04-26 15:51:28'),
(623,198,'حديقة النصر','حديقة النصر','2026-04-26 15:51:28','2026-04-26 15:51:28'),
(624,198,'تلفريك موسكو','تلفريك موسكو','2026-04-26 15:51:28','2026-04-26 15:51:28'),
(625,199,'مطعم أكشبات','مطعم أكشبات','2026-04-26 16:16:20','2026-04-26 16:16:20'),
(626,199,'تلفريك طرابزون','تلفريك طرابزون','2026-04-26 16:16:20','2026-04-26 16:16:20'),
(627,199,'مدينة ريزا','مدينة ريزا','2026-04-26 16:16:20','2026-04-26 16:16:20'),
(628,199,'أيدر ( رافتنج - دبابات )','أيدر ( رافتنج - دبابات )','2026-04-26 16:16:20','2026-04-26 16:16:20'),
(629,199,'حديقة الشاي','حديقة الشاي','2026-04-26 16:16:20','2026-04-26 16:16:20'),
(630,199,'بحيرة سيراجول','بحيرة سيراجول','2026-04-26 16:16:20','2026-04-26 16:16:20'),
(631,199,'قرية همسي كوي','قرية همسي كوي','2026-04-26 16:16:20','2026-04-26 16:16:20'),
(632,199,'مطعم زيناش','مطعم زيناش','2026-04-26 16:16:20','2026-04-26 16:16:20'),
(633,199,'مول فورم طرابزون','مول فورم طرابزون','2026-04-26 16:16:20','2026-04-26 16:16:20'),
(634,200,'بحيرة اوزنجول ( مطاعم ، كافيهات )','بحيرة اوزنجول ( مطاعم ، كافيهات )','2026-04-26 16:16:20','2026-04-26 16:16:20'),
(635,200,'شلالات اوزنجول','شلالات اوزنجول','2026-04-26 16:16:20','2026-04-26 16:16:20'),
(636,200,'قرية ديمر كبي','قرية ديمر كبي','2026-04-26 16:16:20','2026-04-26 16:16:20'),
(637,200,'كوم كافيه','كوم كافيه','2026-04-26 16:16:20','2026-04-26 16:16:20'),
(638,200,'المطل الزجاجي','المطل الزجاجي','2026-04-26 16:16:20','2026-04-26 16:16:20'),
(639,200,'مطل بوزتبا','مطل بوزتبا','2026-04-26 16:16:20','2026-04-26 16:16:20'),
(640,200,'مول فورم طرابزون','مول فورم طرابزون','2026-04-26 16:16:20','2026-04-26 16:16:20'),
(641,201,'قصر بيلر بيه','قصر بيلر بيه','2026-04-26 16:16:20','2026-04-26 16:16:20'),
(642,201,'كورنيش الاورتاكوي','كورنيش الاورتاكوي','2026-04-26 16:16:20','2026-04-26 16:16:20'),
(643,201,'السوق المصري','السوق المصري','2026-04-26 16:16:20','2026-04-26 16:16:20'),
(644,201,'جولة بالبوسفور','جولة بالبوسفور','2026-04-26 16:16:20','2026-04-26 16:16:20'),
(645,201,'قلعة بورت','قلعة بورت','2026-04-26 16:16:20','2026-04-26 16:16:20'),
(646,201,'شارع الاستقلال','شارع الاستقلال','2026-04-26 16:16:20','2026-04-26 16:16:20'),
(647,202,'مطعم أكشبات','مطعم أكشبات','2026-04-26 16:17:20','2026-04-26 16:17:20'),
(648,202,'تلفريك طرابزون','تلفريك طرابزون','2026-04-26 16:17:20','2026-04-26 16:17:20'),
(649,202,'مدينة ريزا','مدينة ريزا','2026-04-26 16:17:20','2026-04-26 16:17:20'),
(650,202,'أيدر ( رافتنج - دبابات )','أيدر ( رافتنج - دبابات )','2026-04-26 16:17:20','2026-04-26 16:17:20'),
(651,202,'حديقة الشاي','حديقة الشاي','2026-04-26 16:17:20','2026-04-26 16:17:20'),
(652,202,'بحيرة سيراجول','بحيرة سيراجول','2026-04-26 16:17:20','2026-04-26 16:17:20'),
(653,202,'قرية همسي كوي','قرية همسي كوي','2026-04-26 16:17:20','2026-04-26 16:17:20'),
(654,202,'مطعم زيناش','مطعم زيناش','2026-04-26 16:17:20','2026-04-26 16:17:20'),
(655,202,'مول فورم طرابزون','مول فورم طرابزون','2026-04-26 16:17:20','2026-04-26 16:17:20'),
(656,203,'بحيرة اوزنجول ( مطاعم ، كافيهات )','بحيرة اوزنجول ( مطاعم ، كافيهات )','2026-04-26 16:17:20','2026-04-26 16:17:20'),
(657,203,'شلالات اوزنجول','شلالات اوزنجول','2026-04-26 16:17:20','2026-04-26 16:17:20'),
(658,203,'قرية ديمر كبي','قرية ديمر كبي','2026-04-26 16:17:20','2026-04-26 16:17:20'),
(659,203,'كوم كافيه','كوم كافيه','2026-04-26 16:17:20','2026-04-26 16:17:20'),
(660,203,'المطل الزجاجي','المطل الزجاجي','2026-04-26 16:17:20','2026-04-26 16:17:20'),
(661,203,'مطل بوزتبا','مطل بوزتبا','2026-04-26 16:17:20','2026-04-26 16:17:20'),
(662,203,'مول فورم طرابزون','مول فورم طرابزون','2026-04-26 16:17:20','2026-04-26 16:17:20'),
(663,204,'قصر بيلر بيه','قصر بيلر بيه','2026-04-26 16:17:20','2026-04-26 16:17:20'),
(664,204,'كورنيش الاورتاكوي','كورنيش الاورتاكوي','2026-04-26 16:17:20','2026-04-26 16:17:20'),
(665,204,'السوق المصري','السوق المصري','2026-04-26 16:17:20','2026-04-26 16:17:20'),
(666,204,'جولة بالبوسفور','جولة بالبوسفور','2026-04-26 16:17:20','2026-04-26 16:17:20'),
(667,204,'قلعة بورت','قلعة بورت','2026-04-26 16:17:20','2026-04-26 16:17:20'),
(668,204,'شارع الاستقلال','شارع الاستقلال','2026-04-26 16:17:20','2026-04-26 16:17:20'),
(669,205,'قصر بيلر بيه','قصر بيلر بيه','2026-04-26 16:26:51','2026-04-26 16:26:51'),
(670,205,'كورنيش الاورتاكوي','كورنيش الاورتاكوي','2026-04-26 16:26:51','2026-04-26 16:26:51'),
(671,205,'السوق المصري','السوق المصري','2026-04-26 16:26:51','2026-04-26 16:26:51'),
(672,205,'جولة بالبوسفور','جولة بالبوسفور','2026-04-26 16:26:51','2026-04-26 16:26:51'),
(673,205,'قلعة بورت','قلعة بورت','2026-04-26 16:26:51','2026-04-26 16:26:51'),
(674,205,'شارع الاستقلال','شارع الاستقلال','2026-04-26 16:26:51','2026-04-26 16:26:51'),
(675,206,'بحيرة اوزنجول ( مطاعم ، كافيهات )','بحيرة اوزنجول ( مطاعم ، كافيهات )','2026-04-26 16:26:51','2026-04-26 16:26:51'),
(676,206,'شلالات اوزنجول','شلالات اوزنجول','2026-04-26 16:26:51','2026-04-26 16:26:51'),
(677,206,'قرية ديمر كبي','قرية ديمر كبي','2026-04-26 16:26:51','2026-04-26 16:26:51'),
(678,206,'كوم كافيه','كوم كافيه','2026-04-26 16:26:51','2026-04-26 16:26:51'),
(679,206,'المطل الزجاجي','المطل الزجاجي','2026-04-26 16:26:51','2026-04-26 16:26:51'),
(680,206,'مطل بوزتبا','مطل بوزتبا','2026-04-26 16:26:51','2026-04-26 16:26:51'),
(681,206,'مول فورم طرابزون','مول فورم طرابزون','2026-04-26 16:26:51','2026-04-26 16:26:51'),
(682,207,'مطعم أكشبات','مطعم أكشبات','2026-04-26 16:26:51','2026-04-26 16:26:51'),
(683,207,'تلفريك طرابزون','تلفريك طرابزون','2026-04-26 16:26:51','2026-04-26 16:26:51'),
(684,207,'مدينة ريزا','مدينة ريزا','2026-04-26 16:26:51','2026-04-26 16:26:51'),
(685,207,'أيدر ( رافتنج - دبابات )','أيدر ( رافتنج - دبابات )','2026-04-26 16:26:51','2026-04-26 16:26:51'),
(686,207,'حديقة الشاي','حديقة الشاي','2026-04-26 16:26:51','2026-04-26 16:26:51'),
(687,207,'بحيرة سيراجول','بحيرة سيراجول','2026-04-26 16:26:51','2026-04-26 16:26:51'),
(688,207,'قرية همسي كوي','قرية همسي كوي','2026-04-26 16:26:51','2026-04-26 16:26:51'),
(689,207,'مطعم زيناش','مطعم زيناش','2026-04-26 16:26:51','2026-04-26 16:26:51'),
(690,207,'مول فورم طرابزون','مول فورم طرابزون','2026-04-26 16:26:51','2026-04-26 16:26:51'),
(691,208,'قصر بيلر بيه','قصر بيلر بيه','2026-04-26 19:22:09','2026-04-26 19:22:09'),
(692,208,'كورنيش الاورتاكوي','كورنيش الاورتاكوي','2026-04-26 19:22:09','2026-04-26 19:22:09'),
(693,208,'السوق المصري','السوق المصري','2026-04-26 19:22:09','2026-04-26 19:22:09'),
(694,208,'جولة بالبوسفور','جولة بالبوسفور','2026-04-26 19:22:09','2026-04-26 19:22:09'),
(695,208,'قلعة بورت','قلعة بورت','2026-04-26 19:22:09','2026-04-26 19:22:09'),
(696,208,'شارع الاستقلال','شارع الاستقلال','2026-04-26 19:22:09','2026-04-26 19:22:09'),
(697,209,'بحيرة اوزنجول ( مطاعم ، كافيهات )','بحيرة اوزنجول ( مطاعم ، كافيهات )','2026-04-26 19:22:09','2026-04-26 19:22:09'),
(698,209,'شلالات اوزنجول','شلالات اوزنجول','2026-04-26 19:22:09','2026-04-26 19:22:09'),
(699,209,'قرية ديمر كبي','قرية ديمر كبي','2026-04-26 19:22:09','2026-04-26 19:22:09'),
(700,209,'كوم كافيه','كوم كافيه','2026-04-26 19:22:09','2026-04-26 19:22:09'),
(701,209,'المطل الزجاجي','المطل الزجاجي','2026-04-26 19:22:09','2026-04-26 19:22:09'),
(702,209,'مطل بوزتبا','مطل بوزتبا','2026-04-26 19:22:09','2026-04-26 19:22:09'),
(703,209,'مول فورم طرابزون','مول فورم طرابزون','2026-04-26 19:22:09','2026-04-26 19:22:09'),
(704,210,'مطعم أكشبات','مطعم أكشبات','2026-04-26 19:22:09','2026-04-26 19:22:09'),
(705,210,'تلفريك طرابزون','تلفريك طرابزون','2026-04-26 19:22:09','2026-04-26 19:22:09'),
(706,210,'مدينة ريزا','مدينة ريزا','2026-04-26 19:22:09','2026-04-26 19:22:09'),
(707,210,'أيدر ( رافتنج - دبابات )','أيدر ( رافتنج - دبابات )','2026-04-26 19:22:09','2026-04-26 19:22:09'),
(708,210,'حديقة الشاي','حديقة الشاي','2026-04-26 19:22:09','2026-04-26 19:22:09'),
(709,210,'بحيرة سيراجول','بحيرة سيراجول','2026-04-26 19:22:09','2026-04-26 19:22:09'),
(710,210,'قرية همسي كوي','قرية همسي كوي','2026-04-26 19:22:09','2026-04-26 19:22:09'),
(711,210,'مطعم زيناش','مطعم زيناش','2026-04-26 19:22:09','2026-04-26 19:22:09'),
(712,210,'مول فورم طرابزون','مول فورم طرابزون','2026-04-26 19:22:09','2026-04-26 19:22:09'),
(713,211,'قصر بيلر بيه','قصر بيلر بيه','2026-04-26 19:23:56','2026-04-26 19:23:56'),
(714,211,'كورنيش الاورتاكوي','كورنيش الاورتاكوي','2026-04-26 19:23:56','2026-04-26 19:23:56'),
(715,211,'السوق المصري','السوق المصري','2026-04-26 19:23:56','2026-04-26 19:23:56'),
(716,211,'جولة بالبوسفور','جولة بالبوسفور','2026-04-26 19:23:56','2026-04-26 19:23:56'),
(717,211,'قلعة بورت','قلعة بورت','2026-04-26 19:23:56','2026-04-26 19:23:56'),
(718,211,'شارع الاستقلال','شارع الاستقلال','2026-04-26 19:23:56','2026-04-26 19:23:56'),
(719,212,'بحيرة اوزنجول ( مطاعم ، كافيهات )','بحيرة اوزنجول ( مطاعم ، كافيهات )','2026-04-26 19:23:56','2026-04-26 19:23:56'),
(720,212,'شلالات اوزنجول','شلالات اوزنجول','2026-04-26 19:23:56','2026-04-26 19:23:56'),
(721,212,'قرية ديمر كبي','قرية ديمر كبي','2026-04-26 19:23:56','2026-04-26 19:23:56'),
(722,212,'كوم كافيه','كوم كافيه','2026-04-26 19:23:56','2026-04-26 19:23:56'),
(723,212,'المطل الزجاجي','المطل الزجاجي','2026-04-26 19:23:56','2026-04-26 19:23:56'),
(724,212,'مطل بوزتبا','مطل بوزتبا','2026-04-26 19:23:56','2026-04-26 19:23:56'),
(725,212,'مول فورم طرابزون','مول فورم طرابزون','2026-04-26 19:23:56','2026-04-26 19:23:56'),
(726,213,'مطعم أكشبات','مطعم أكشبات','2026-04-26 19:23:56','2026-04-26 19:23:56'),
(727,213,'تلفريك طرابزون','تلفريك طرابزون','2026-04-26 19:23:56','2026-04-26 19:23:56'),
(728,213,'مدينة ريزا','مدينة ريزا','2026-04-26 19:23:56','2026-04-26 19:23:56'),
(729,213,'أيدر ( رافتنج - دبابات )','أيدر ( رافتنج - دبابات )','2026-04-26 19:23:56','2026-04-26 19:23:56'),
(730,213,'حديقة الشاي','حديقة الشاي','2026-04-26 19:23:56','2026-04-26 19:23:56'),
(731,213,'بحيرة سيراجول','بحيرة سيراجول','2026-04-26 19:23:56','2026-04-26 19:23:56'),
(732,213,'قرية همسي كوي','قرية همسي كوي','2026-04-26 19:23:56','2026-04-26 19:23:56'),
(733,213,'مطعم زيناش','مطعم زيناش','2026-04-26 19:23:56','2026-04-26 19:23:56'),
(734,213,'مول فورم طرابزون','مول فورم طرابزون','2026-04-26 19:23:56','2026-04-26 19:23:56'),
(735,214,'قصر بيلر بيه','قصر بيلر بيه','2026-04-26 22:43:18','2026-04-26 22:43:18'),
(736,214,'كورنيش الاورتاكوي','كورنيش الاورتاكوي','2026-04-26 22:43:18','2026-04-26 22:43:18'),
(737,214,'السوق المصري','السوق المصري','2026-04-26 22:43:18','2026-04-26 22:43:18'),
(738,214,'جولة بالبوسفور','جولة بالبوسفور','2026-04-26 22:43:18','2026-04-26 22:43:18'),
(739,214,'قلعة بورت','قلعة بورت','2026-04-26 22:43:18','2026-04-26 22:43:18'),
(740,214,'شارع الاستقلال','شارع الاستقلال','2026-04-26 22:43:18','2026-04-26 22:43:18'),
(741,215,'بحيرة اوزنجول ( مطاعم ، كافيهات )','بحيرة اوزنجول ( مطاعم ، كافيهات )','2026-04-26 22:43:18','2026-04-26 22:43:18'),
(742,215,'شلالات اوزنجول','شلالات اوزنجول','2026-04-26 22:43:18','2026-04-26 22:43:18'),
(743,215,'قرية ديمر كبي','قرية ديمر كبي','2026-04-26 22:43:18','2026-04-26 22:43:18'),
(744,215,'كوم كافيه','كوم كافيه','2026-04-26 22:43:18','2026-04-26 22:43:18'),
(745,215,'المطل الزجاجي','المطل الزجاجي','2026-04-26 22:43:18','2026-04-26 22:43:18'),
(746,215,'مطل بوزتبا','مطل بوزتبا','2026-04-26 22:43:18','2026-04-26 22:43:18'),
(747,215,'مول فورم طرابزون','مول فورم طرابزون','2026-04-26 22:43:18','2026-04-26 22:43:18'),
(748,216,'مطعم أكشبات','مطعم أكشبات','2026-04-26 22:43:18','2026-04-26 22:43:18'),
(749,216,'تلفريك طرابزون','تلفريك طرابزون','2026-04-26 22:43:18','2026-04-26 22:43:18'),
(750,216,'مدينة ريزا','مدينة ريزا','2026-04-26 22:43:18','2026-04-26 22:43:18'),
(751,216,'أيدر ( رافتنج - دبابات )','أيدر ( رافتنج - دبابات )','2026-04-26 22:43:18','2026-04-26 22:43:18'),
(752,216,'حديقة الشاي','حديقة الشاي','2026-04-26 22:43:18','2026-04-26 22:43:18'),
(753,216,'بحيرة سيراجول','بحيرة سيراجول','2026-04-26 22:43:18','2026-04-26 22:43:18'),
(754,216,'قرية همسي كوي','قرية همسي كوي','2026-04-26 22:43:18','2026-04-26 22:43:18'),
(755,216,'مطعم زيناش','مطعم زيناش','2026-04-26 22:43:18','2026-04-26 22:43:18'),
(756,216,'مول فورم طرابزون','مول فورم طرابزون','2026-04-26 22:43:18','2026-04-26 22:43:18');
/*!40000 ALTER TABLE `item_itinerary_places` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `item_packages`
--

DROP TABLE IF EXISTS `item_packages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `item_packages` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `item_id` bigint(20) unsigned NOT NULL,
  `title_en` varchar(191) DEFAULT NULL,
  `title_ar` varchar(191) DEFAULT NULL,
  `title_fr` varchar(191) DEFAULT NULL,
  `title_de` varchar(191) DEFAULT NULL,
  `features_en` text DEFAULT NULL,
  `features_ar` text DEFAULT NULL,
  `features_fr` text DEFAULT NULL,
  `features_de` text DEFAULT NULL,
  `price` double NOT NULL DEFAULT 0,
  `status` tinyint(4) NOT NULL DEFAULT 0,
  `attachment` varchar(191) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `item_packages_item_id_foreign` (`item_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `item_packages`
--

LOCK TABLES `item_packages` WRITE;
/*!40000 ALTER TABLE `item_packages` DISABLE KEYS */;
/*!40000 ALTER TABLE `item_packages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `item_prices`
--

DROP TABLE IF EXISTS `item_prices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `item_prices` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `item_id` bigint(20) unsigned NOT NULL,
  `title_ar` varchar(191) DEFAULT NULL,
  `title_en` varchar(191) DEFAULT NULL,
  `price` decimal(10,2) NOT NULL DEFAULT 0.00,
  `discount` decimal(10,2) NOT NULL DEFAULT 0.00,
  `discount_type` enum('amount','percent') NOT NULL DEFAULT 'amount',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `item_prices_item_id_foreign` (`item_id`)
) ENGINE=MyISAM AUTO_INCREMENT=169 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `item_prices`
--

LOCK TABLES `item_prices` WRITE;
/*!40000 ALTER TABLE `item_prices` DISABLE KEYS */;
INSERT INTO `item_prices` VALUES
(1,3,'سعر الشخص بالغرفة المفردة','Single Room Person Price',1000.00,500.00,'amount','2026-04-19 16:46:11','2026-04-19 16:46:11'),
(2,3,'سعر الشخص بالغرفة المزدوجة','Double Room Person Price',2000.00,1000.00,'amount','2026-04-19 16:46:11','2026-04-19 16:46:11'),
(3,3,'سعر الشخص بالغرفة الثلاثية','Triple Room Person Price',3000.00,2000.00,'amount','2026-04-19 16:46:11','2026-04-19 16:46:11'),
(167,1,'رضيع أقل من سنتين','رضيع أقل من سنتين',400.00,0.00,'amount','2026-04-26 22:43:18','2026-04-26 22:43:18'),
(133,6,'سعر الشخص بالغرفة المفردة','Single Room Person Price',9200.00,1500.00,'amount','2026-04-26 15:51:28','2026-04-26 15:51:28'),
(132,6,'سعر الشخص بالغرفة المزدوجة','Double Room Person Price',8200.00,1500.00,'amount','2026-04-26 15:51:28','2026-04-26 15:51:28'),
(125,7,'سعر الشخص بالغرفة المزدوجة','Double Room Person Price',6500.00,1000.00,'amount','2026-04-26 00:46:47','2026-04-26 00:46:47'),
(124,7,'سعر الشخص بالغرفة المفردة','Single Room Person Price',7600.00,1000.00,'amount','2026-04-26 00:46:47','2026-04-26 00:46:47'),
(91,8,'سعر الشخص بالغرفة المزدوجة','Double Room Person Price',6500.00,1000.00,'amount','2026-04-25 20:10:03','2026-04-25 20:10:03'),
(90,8,'سعر الشخص بالغرفة المفردة','Single Room Person Price',7600.00,1000.00,'amount','2026-04-25 20:10:03','2026-04-25 20:10:03'),
(123,9,'سعر الشخص بالغرفة المفردة','Single Room Person Price',7600.00,1000.00,'amount','2026-04-26 00:46:01','2026-04-26 00:46:01'),
(122,9,'سعر الشخص بالغرفة المزدوجة','Double Room Person Price',6500.00,1000.00,'amount','2026-04-26 00:46:01','2026-04-26 00:46:01'),
(111,10,'سعر الشخص بالغرفة المزدوجة','Double Room Person Price',6500.00,1000.00,'amount','2026-04-26 00:19:14','2026-04-26 00:19:14'),
(110,10,'سعر الشخص بالغرفة المفردة','Single Room Person Price',7600.00,1000.00,'amount','2026-04-26 00:19:14','2026-04-26 00:19:14'),
(168,1,'سعر الشخص بالغرفة المزدوجة','سعر الشخص بالغرفة المزدوجة',5900.00,1000.00,'amount','2026-04-26 22:43:18','2026-04-26 22:43:18'),
(166,1,'طفل مرافق بدون سرير (أقل من 10 سنوات)','طفل مرافق بدون سرير (أقل من 10 سنوات)',4300.00,1000.00,'amount','2026-04-26 22:43:18','2026-04-26 22:43:18'),
(163,1,'سعر الشخص بالغرفة الثلاثية','سعر الشخص بالغرفة الثلاثية',5700.00,1000.00,'amount','2026-04-26 22:43:18','2026-04-26 22:43:18'),
(164,1,'سعر الشخص بالغرفة المفردة','سعر الشخص بالغرفة المفردة',6900.00,1000.00,'amount','2026-04-26 22:43:18','2026-04-26 22:43:18'),
(165,1,'طفل مرافق بسرير (أقل من 10 سنوات)','طفل مرافق بسرير (أقل من 10 سنوات)',5500.00,1000.00,'amount','2026-04-26 22:43:18','2026-04-26 22:43:18');
/*!40000 ALTER TABLE `item_prices` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `item_residency_users`
--

DROP TABLE IF EXISTS `item_residency_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `item_residency_users` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `residency_user_id` bigint(20) unsigned NOT NULL,
  `item_id` bigint(20) unsigned NOT NULL,
  `item_package_id` bigint(20) unsigned DEFAULT NULL,
  `attendees` varchar(191) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_course_pkg_unique` (`residency_user_id`,`item_id`,`item_package_id`),
  KEY `item_residency_users_item_package_id_foreign` (`item_package_id`),
  KEY `item_residency_users_item_id_foreign` (`item_id`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `item_residency_users`
--

LOCK TABLES `item_residency_users` WRITE;
/*!40000 ALTER TABLE `item_residency_users` DISABLE KEYS */;
INSERT INTO `item_residency_users` VALUES
(1,5,3,NULL,'1','2026-03-14 19:38:24','2026-03-14 19:38:24'),
(2,5,6,NULL,'1','2026-03-25 22:00:53','2026-03-25 22:00:53');
/*!40000 ALTER TABLE `item_residency_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `item_routes`
--

DROP TABLE IF EXISTS `item_routes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `item_routes` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `item_id` bigint(20) unsigned NOT NULL,
  `title_en` varchar(191) DEFAULT NULL,
  `title_ar` varchar(191) DEFAULT NULL,
  `icon` varchar(191) DEFAULT NULL,
  `order` int(11) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `item_routes_item_id_foreign` (`item_id`)
) ENGINE=MyISAM AUTO_INCREMENT=363 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `item_routes`
--

LOCK TABLES `item_routes` WRITE;
/*!40000 ALTER TABLE `item_routes` DISABLE KEYS */;
INSERT INTO `item_routes` VALUES
(4,3,'car','سياره','/uploads/tenant_1/general/69e399cbc4c64_1776523723_general.png',0,'2026-04-19 16:46:11','2026-04-19 16:46:11'),
(3,3,'plane','طياره','/uploads/tenant_1/general/69e399cbc13d9_1776523723_general.png',0,'2026-04-19 16:46:11','2026-04-19 16:46:11'),
(360,1,'supervisor','مشرف سياحي','/uploads/tenant_1/icons/69e9f34ea8f86_1776939854_general.jpeg',5,'2026-04-26 22:43:18','2026-04-26 22:43:18'),
(362,1,'Hotels 4 stars','فنادق  5 ,  4 نجوم','/uploads/tenant_1/icons/69e9f34eab13f_1776939854_general.jpeg',2,'2026-04-26 22:43:18','2026-04-26 22:43:18'),
(361,1,'tours','الجولات السياحية اليومية','/uploads/tenant_1/icons/69e9f34ea7fab_1776939854_general.jpeg',4,'2026-04-26 22:43:18','2026-04-26 22:43:18'),
(332,6,'tours','جولات سياحية يومية','/uploads/tenant_1/icons/69e53d89a949d_1776631177_general.png',4,'2026-04-26 15:51:28','2026-04-26 15:51:28'),
(331,6,'استقبال و توديع','استقبال و توديع','/uploads/tenant_1/icons/69e9f34eaa3ea_1776939854_general.jpeg',3,'2026-04-26 15:51:28','2026-04-26 15:51:28'),
(359,1,'buses','استقبال و توديع','/uploads/tenant_1/icons/69e9f34eaa3ea_1776939854_general.jpeg',3,'2026-04-26 22:43:18','2026-04-26 22:43:18'),
(330,6,'hotels 4 satrs','فنادق 4 نجوم','/uploads/tenant_1/icons/69e9f34eab13f_1776939854_general.jpeg',2,'2026-04-26 15:51:28','2026-04-26 15:51:28'),
(328,6,'supervisor','مشرف سياحي','/uploads/tenant_1/icons/69e9f34ea8f86_1776939854_general.jpeg',5,'2026-04-26 15:51:28','2026-04-26 15:51:28'),
(329,6,'International flight','طيران دولي','/uploads/tenant_1/icons/69e9f34eaca2b_1776939854_general.jpeg',1,'2026-04-26 15:51:28','2026-04-26 15:51:28'),
(358,1,'International flight','طيران دولي و طيران داخلي','/uploads/tenant_1/icons/69e9f34eaca2b_1776939854_general.jpeg',1,'2026-04-26 22:43:18','2026-04-26 22:43:18'),
(308,7,'tours','الجولات السياحية اليومية','/uploads/tenant_1/icons/69e9f34ea7fab_1776939854_general.jpeg',4,'2026-04-26 00:46:47','2026-04-26 00:46:47'),
(309,7,'supervisor','مشرف سياحي','/uploads/tenant_1/icons/69e9f34ea8f86_1776939854_general.jpeg',5,'2026-04-26 00:46:47','2026-04-26 00:46:47'),
(310,7,'شريحة انرنت','شريحة انترنت','/uploads/tenant_1/general/69ecc208e2408_1777123848_general.jpeg',6,'2026-04-26 00:46:47','2026-04-26 00:46:47'),
(311,7,'buses','المواصلات و التنقلات خلال الرحلة','/uploads/tenant_1/icons/69e9f34eaa3ea_1776939854_general.jpeg',3,'2026-04-26 00:46:47','2026-04-26 00:46:47'),
(312,7,'Hotels 4 stars','فنادق  5 ,  4 نجوم','/uploads/tenant_1/icons/69e9f34eab13f_1776939854_general.jpeg',2,'2026-04-26 00:46:47','2026-04-26 00:46:47'),
(307,7,'International flight','طيران دولي','/uploads/tenant_1/icons/69e9f34eaca2b_1776939854_general.jpeg',1,'2026-04-26 00:46:47','2026-04-26 00:46:47'),
(210,8,'Hotels 4 stars','فنادق  5 ,  4 نجوم','/uploads/tenant_1/icons/69e9f34eab13f_1776939854_general.jpeg',2,'2026-04-25 20:10:03','2026-04-25 20:10:03'),
(209,8,'شريحة انرنت','شريحة انترنت',NULL,6,'2026-04-25 20:10:03','2026-04-25 20:10:03'),
(208,8,'tours','الجولات السياحية اليومية','/uploads/tenant_1/icons/69e9f34ea7fab_1776939854_general.jpeg',4,'2026-04-25 20:10:03','2026-04-25 20:10:03'),
(205,8,'supervisor','مشرف سياحي','/uploads/tenant_1/icons/69e9f34ea8f86_1776939854_general.jpeg',5,'2026-04-25 20:10:03','2026-04-25 20:10:03'),
(206,8,'International flight','طيران دولي و طيران داخلي','/uploads/tenant_1/icons/69e9f34eaca2b_1776939854_general.jpeg',1,'2026-04-25 20:10:03','2026-04-25 20:10:03'),
(207,8,'buses','المواصلات و التنقلات خلال الرحلة','/uploads/tenant_1/icons/69e9f34eaa3ea_1776939854_general.jpeg',3,'2026-04-25 20:10:03','2026-04-25 20:10:03'),
(306,9,'International flight','طيران دولي','/uploads/tenant_1/icons/69e9f34eaca2b_1776939854_general.jpeg',1,'2026-04-26 00:46:01','2026-04-26 00:46:01'),
(305,9,'tours','الجولات السياحية اليومية','/uploads/tenant_1/icons/69e9f34ea7fab_1776939854_general.jpeg',4,'2026-04-26 00:46:01','2026-04-26 00:46:01'),
(304,9,'supervisor','مشرف سياحي','/uploads/tenant_1/icons/69e9f34ea8f86_1776939854_general.jpeg',5,'2026-04-26 00:46:01','2026-04-26 00:46:01'),
(303,9,'شريحة انرنت','شريحة انترنت','/uploads/tenant_1/general/69ecc208e2408_1777123848_general.jpeg',6,'2026-04-26 00:46:01','2026-04-26 00:46:01'),
(302,9,'buses','المواصلات و التنقلات خلال الرحلة','/uploads/tenant_1/icons/69e9f34eaa3ea_1776939854_general.jpeg',3,'2026-04-26 00:46:01','2026-04-26 00:46:01'),
(301,9,'Hotels 4 stars','فنادق  5 ,  4 نجوم','/uploads/tenant_1/icons/69e9f34eab13f_1776939854_general.jpeg',2,'2026-04-26 00:46:01','2026-04-26 00:46:01'),
(270,10,'Hotels 4 stars','فنادق  5 ,  4 نجوم','/uploads/tenant_1/icons/69e9f34eab13f_1776939854_general.jpeg',2,'2026-04-26 00:19:14','2026-04-26 00:19:14'),
(269,10,'buses','المواصلات و التنقلات خلال الرحلة','/uploads/tenant_1/icons/69e9f34eaa3ea_1776939854_general.jpeg',3,'2026-04-26 00:19:14','2026-04-26 00:19:14'),
(268,10,'شريحة انرنت','شريحة انترنت','/uploads/tenant_1/general/69ecc208e2408_1777123848_general.jpeg',6,'2026-04-26 00:19:14','2026-04-26 00:19:14'),
(267,10,'supervisor','مشرف سياحي','/uploads/tenant_1/icons/69e9f34ea8f86_1776939854_general.jpeg',5,'2026-04-26 00:19:14','2026-04-26 00:19:14'),
(266,10,'tours','الجولات السياحية اليومية','/uploads/tenant_1/icons/69e9f34ea7fab_1776939854_general.jpeg',4,'2026-04-26 00:19:14','2026-04-26 00:19:14'),
(265,10,'International flight','طيران دولي','/uploads/tenant_1/icons/69e9f34eaca2b_1776939854_general.jpeg',1,'2026-04-26 00:19:14','2026-04-26 00:19:14');
/*!40000 ALTER TABLE `item_routes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `item_types`
--

DROP TABLE IF EXISTS `item_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `item_types` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `title_en` varchar(191) DEFAULT NULL,
  `title_de` varchar(191) DEFAULT NULL,
  `title_fr` varchar(191) DEFAULT NULL,
  `title_ar` varchar(191) DEFAULT NULL,
  `short_description_en` text DEFAULT NULL,
  `short_description_de` text DEFAULT NULL,
  `short_description_fr` text DEFAULT NULL,
  `short_description_ar` text DEFAULT NULL,
  `meta_title_ar` varchar(191) DEFAULT NULL,
  `meta_title_en` varchar(191) DEFAULT NULL,
  `meta_title_de` varchar(191) DEFAULT NULL,
  `meta_title_fr` varchar(191) DEFAULT NULL,
  `meta_img` text DEFAULT NULL,
  `meta_description_ar` text DEFAULT NULL,
  `meta_description_en` text DEFAULT NULL,
  `meta_description_de` text DEFAULT NULL,
  `meta_description_fr` text DEFAULT NULL,
  `meta_keywords_ar` text DEFAULT NULL,
  `meta_keywords_en` text DEFAULT NULL,
  `meta_keywords_de` text DEFAULT NULL,
  `meta_keywords_fr` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `banner_en` varchar(191) DEFAULT NULL,
  `banner_de` varchar(191) DEFAULT NULL,
  `banner_fr` varchar(191) DEFAULT NULL,
  `banner_ar` varchar(191) DEFAULT NULL,
  `is_feature` tinyint(4) NOT NULL DEFAULT 0,
  `order` varchar(191) DEFAULT '0',
  `deleted_at` timestamp NULL DEFAULT NULL,
  `parent_id` bigint(20) unsigned DEFAULT NULL,
  `whatsapp` varchar(191) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `item_types_parent_id_foreign` (`parent_id`)
) ENGINE=MyISAM AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `item_types`
--

LOCK TABLES `item_types` WRITE;
/*!40000 ALTER TABLE `item_types` DISABLE KEYS */;
INSERT INTO `item_types` VALUES
(1,'ffffffffff',NULL,NULL,'ffffffffffff','ffffffffffffffffffffffffffff',NULL,NULL,'fffffffffff','d','dddddddddddddddd',NULL,NULL,'/uploads/tenant_1/general/69b08d38a9338_1773178168_general.webp','dddddddddddddddd','dd',NULL,NULL,'dddddddddddddddd','dddddddddddddddddd',NULL,NULL,'2026-03-11 22:52:02','2026-03-12 19:03:47','/uploads/tenant_1/general/69b08d38aad4e_1773178168_general.webp',NULL,NULL,'/uploads/tenant_1/general/69b08d38a9338_1773178168_general.webp',1,'1','2026-03-12 19:03:47',NULL,NULL),
(2,'Visas',NULL,NULL,'التاشيرات','Simplify your travels with our fast and easy visa services.',NULL,NULL,'سهّل رحلاتك معنا من خلال خدمات استخراج التأشيرات بسرعة وسهولة.','التاشيرات','Visas',NULL,NULL,'/uploads/tenant_1/general/69b2bd080d6d9_1773321480_general.jpeg','سهّل رحلاتك معنا من خلال خدمات استخراج التأشيرات بسرعة وسهولة.','Simplify your travels with our fast and easy visa services.',NULL,NULL,'سهّل رحلاتك معنا من خلال خدمات استخراج التأشيرات بسرعة وسهولة.','Simplify your travels with our fast and easy visa services.',NULL,NULL,'2026-03-12 19:19:07','2026-04-26 17:15:57','/uploads/tenant_1/general/69b2bd080d6d9_1773321480_general.jpeg',NULL,NULL,'/uploads/tenant_1/general/69b2bd080d6d9_1773321480_general.jpeg',1,'5',NULL,NULL,NULL),
(3,'Educational Tours',NULL,NULL,'الرحلات التعليمية','Learn and discover new cultures through unique educational tours.',NULL,NULL,'تعلّم واكتشف ثقافات جديدة من خلال رحلات تعليمية مميزة.','الرحلات التعليمية','Educational Tours',NULL,NULL,'/uploads/tenant_1/general/69b2bd080cd94_1773321480_general.jpeg','تعلّم واكتشف ثقافات جديدة من خلال رحلات تعليمية مميزة.','Learn and discover new cultures through unique educational tours.',NULL,NULL,'تعلّم واكتشف ثقافات جديدة من خلال رحلات تعليمية مميزة.','Learn and discover new cultures through unique educational tours.',NULL,NULL,'2026-03-12 19:21:15','2026-04-26 17:18:02','/uploads/tenant_1/general/69b2bd080cd94_1773321480_general.jpeg',NULL,NULL,'/uploads/tenant_1/general/69b2bd080cd94_1773321480_general.jpeg',1,'4',NULL,NULL,NULL),
(4,'Cruises',NULL,NULL,'الكروزات البحرية','Relax and enjoy breathtaking views on our luxury cruises.',NULL,NULL,'استرخِ واستمتع بالمناظر الخلابة على متن كروزاتنا الفاخرة.','الكروزات البحرية','Cruises',NULL,NULL,'/uploads/tenant_1/general/69b2bd080de77_1773321480_general.jpeg','استرخِ واستمتع بالمناظر الخلابة على متن كروزاتنا الفاخرة.','Relax and enjoy breathtaking views on our luxury cruises.',NULL,NULL,'استرخِ واستمتع بالمناظر الخلابة على متن كروزاتنا الفاخرة.','Relax and enjoy breathtaking views on our luxury cruises.',NULL,NULL,'2026-03-12 19:22:52','2026-03-12 19:22:52','/uploads/tenant_1/general/69b2bd080de77_1773321480_general.jpeg',NULL,NULL,'/uploads/tenant_1/general/69b2bd080de77_1773321480_general.jpeg',1,'3',NULL,NULL,NULL),
(5,'Group Tours',NULL,NULL,'القروبات الجماعية','Enjoy traveling with friends or family on organized and fun group tours.',NULL,NULL,'استمتع بالسفر مع الأصدقاء أو العائلة في رحلات جماعية منظمة وممتعة.','الرحلات الجماعية','Group Tours',NULL,NULL,'/uploads/tenant_1/general/69b2bd080a257_1773321480_general.jpeg','استمتع بالسفر مع الأصدقاء أو العائلة في رحلات جماعية منظمة وممتعة.','Enjoy traveling with friends or family on organized and fun group tours.',NULL,NULL,'استمتع بالسفر مع الأصدقاء أو العائلة في رحلات جماعية منظمة وممتعة.','Enjoy traveling with friends or family on organized and fun group tours.',NULL,NULL,'2026-03-12 19:25:17','2026-04-26 17:15:41','/uploads/tenant_1/general/69b2bd080a257_1773321480_general.jpeg',NULL,NULL,'/uploads/tenant_1/general/69b2bd080a257_1773321480_general.jpeg',1,'1',NULL,NULL,'01028768312'),
(6,'Turkey Group Tour',NULL,NULL,'رحلات تركيا','Turkey Group Tour',NULL,NULL,'رحلات تركيا','رحلة جماعية إلى تركيا','Turkey Group Tour',NULL,NULL,'/uploads/tenant_1/تركيا/69edc6f1cc975_1777190641_general.png','رحلة جماعية إلى تركيا','Turkey Group Tour',NULL,NULL,'رحلة جماعية إلى تركيا','Turkey Group Tour',NULL,NULL,'2026-03-16 03:29:27','2026-04-26 15:04:52','/uploads/tenant_1/تركيا/69edc6f1cc975_1777190641_general.png',NULL,NULL,'/uploads/tenant_1/تركيا/69edc6f1cc975_1777190641_general.png',1,'1',NULL,5,'0551933635'),
(7,'رحلات روسيا',NULL,NULL,'رحلات روسيا','رحلات روسيا',NULL,NULL,'رحلات روسيا','رحلة موسكو روسيا','Moscow, Russia Trip',NULL,NULL,'/uploads/tenant_1/general/69edc85f6c835_1777191007_general.png','استمتع برحلة مميزة إلى موسكو روسيا واكتشف أشهر المعالم السياحية والأنشطة الفريدة مع تجربة لا تُنسى في قلب العاصمة الروسية.','Discover the best activities and attractions in Moscow, Russia, and enjoy an unforgettable travel experience in one of the world’s most iconic cities.',NULL,NULL,'موسكو، روسيا، رحلة موسكو، سياحة روسيا، معالم موسكو، السفر إلى روسيا، برامج سياحية، رحلات روسيا','Moscow Russia, Russia travel, Moscow attractions, Moscow tour, travel to Russia, Europe trips, Moscow itinerary',NULL,NULL,'2026-04-23 14:22:35','2026-04-26 15:10:40','/uploads/tenant_1/general/69edc85f6c835_1777191007_general.png',NULL,NULL,'/uploads/tenant_1/general/69edc85f6c835_1777191007_general.png',1,'2',NULL,5,'0541670713'),
(8,'رحلات البوسنة',NULL,NULL,'رحلات البوسنة','رحلات البوسنة',NULL,NULL,'رحلات البوسنة','عروض سياحية إلى سراييفو وموستار وبيهاتش رحلة البوسنة','Bosnia Trip 2026 | Travel Deals to Sarajevo, Mostar & Bihac',NULL,NULL,'/uploads/tenant_1/general/69ecbe4d30008_1777122893_general.png','اكتشف جمال البوسنة مع أفضل العروض السياحية لعام 2026. رحلات مميزة إلى سراييفو وموستار وبيهاتش تشمل الإقامة، الجولات اليومية، والمواصلات بأفضل الأسعار.','Explore Bosnia in 2026 with exclusive travel packages to Sarajevo, Mostar, and Bihac. Enjoy guided tours, accommodation, and transportation at the best prices.',NULL,NULL,'رحلة البوسنة، سياحة البوسنة، سراييفو، موستار، بيهاتش، عروض سفر البوسنة، رحلات سياحية 2026، السفر إلى البوسنة، رحلات عائلية، برامج سياحية البوسنة','Bosnia trip, Bosnia travel, Sarajevo tour, Mostar travel, Bihac tourism, Bosnia packages 2026, travel deals Bosnia, family trips Bosnia, Bosnia itinerary',NULL,NULL,'2026-04-25 20:17:31','2026-04-25 20:17:31','/uploads/tenant_1/general/69ecbe4d30008_1777122893_general.png',NULL,NULL,'/uploads/tenant_1/general/69ecbe4d30008_1777122893_general.png',1,'3',NULL,5,'0551933635'),
(9,'البكجات الخاصة',NULL,NULL,'البكجات الخاصة','البكجات الخاصة',NULL,NULL,'البكجات الخاصة',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-04-26 17:17:42','2026-04-26 17:17:42','/uploads/tenant_1/general/69b2bd080a257_1773321480_general.jpeg',NULL,NULL,'/uploads/tenant_1/general/69b2bd080a257_1773321480_general.jpeg',1,'2',NULL,NULL,NULL);
/*!40000 ALTER TABLE `item_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `items`
--

DROP TABLE IF EXISTS `items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `items` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `item_type_id` bigint(20) unsigned NOT NULL,
  `user_id` bigint(20) unsigned DEFAULT NULL,
  `title_en` text DEFAULT NULL,
  `title_de` varchar(191) DEFAULT NULL,
  `title_fr` varchar(191) DEFAULT NULL,
  `title_ar` text DEFAULT NULL,
  `banner_en` varchar(191) DEFAULT NULL,
  `banner_de` varchar(191) DEFAULT NULL,
  `banner_fr` varchar(191) DEFAULT NULL,
  `banner_ar` varchar(191) DEFAULT NULL,
  `status` tinyint(4) NOT NULL DEFAULT 0,
  `out_of_stock` tinyint(1) NOT NULL DEFAULT 0,
  `meta_title_ar` varchar(191) DEFAULT NULL,
  `meta_title_en` varchar(191) DEFAULT NULL,
  `meta_title_de` varchar(191) DEFAULT NULL,
  `meta_title_fr` varchar(191) DEFAULT NULL,
  `meta_img` text DEFAULT NULL,
  `meta_description_ar` text DEFAULT NULL,
  `meta_description_en` text DEFAULT NULL,
  `meta_description_de` text DEFAULT NULL,
  `meta_description_fr` text DEFAULT NULL,
  `meta_keywords_ar` text DEFAULT NULL,
  `meta_keywords_en` text DEFAULT NULL,
  `meta_keywords_de` text DEFAULT NULL,
  `meta_keywords_fr` text DEFAULT NULL,
  `slug_en` varchar(191) DEFAULT NULL,
  `slug_de` varchar(191) DEFAULT NULL,
  `slug_fr` varchar(191) DEFAULT NULL,
  `slug_ar` varchar(191) DEFAULT NULL,
  `short_description_ar` text DEFAULT NULL,
  `short_description_en` text DEFAULT NULL,
  `short_description_de` text DEFAULT NULL,
  `short_description_fr` text DEFAULT NULL,
  `description_ar` longtext DEFAULT NULL,
  `description_en` longtext DEFAULT NULL,
  `description_de` longtext DEFAULT NULL,
  `description_fr` longtext DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `price` decimal(10,2) NOT NULL DEFAULT 0.00,
  `discount` decimal(10,2) NOT NULL DEFAULT 0.00,
  `discount_type` enum('amount','percent') NOT NULL DEFAULT 'amount',
  `is_feature` tinyint(4) NOT NULL DEFAULT 0,
  `featured_at` timestamp NULL DEFAULT NULL,
  `order` varchar(191) DEFAULT '0',
  `pdf` text DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `start_date_hijri` varchar(191) DEFAULT NULL,
  `end_date_hijri` varchar(191) DEFAULT NULL,
  `map` text DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `season` varchar(191) DEFAULT NULL,
  `whatsapp` varchar(191) DEFAULT NULL,
  `quick_contact` varchar(191) DEFAULT NULL,
  `contact_us` varchar(191) DEFAULT NULL,
  `earned_points` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `items_item_type_id_foreign` (`item_type_id`),
  KEY `items_user_id_foreign` (`user_id`)
) ENGINE=MyISAM AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `items`
--

LOCK TABLES `items` WRITE;
/*!40000 ALTER TABLE `items` DISABLE KEYS */;
INSERT INTO `items` VALUES
(1,6,4,'Turkey Group Tour',NULL,NULL,'رحلة الشمال التركي و اسطنبول','/uploads/tenant_1/general/69ee021d233eb_1777205789_general.png',NULL,NULL,'/uploads/tenant_1/general/69ee021d233eb_1777205789_general.png',1,0,'رحلة جماعية إلى تركيا','Turkey Group Tour',NULL,NULL,'/uploads/tenant_1/general/69b9c1ef54f42_1773781487_general.jpeg','استمتع برحلة جماعية مميزة إلى تركيا حيث يمكنك زيارة إسطنبول الساحرة واستكشاف معالمها التاريخية مثل آيا صوفيا والمسجد الأزرق والبازار الكبير. تشمل الرحلة أيضًا جولات في أجمل المناطق الطبيعية والتسوق في الأسواق التقليدية، مع برنامج سياحي منظم يضمن لك تجربة ممتعة ومريحة.','Enjoy an amazing group trip to Turkey where you will explore the charming city of Istanbul and visit famous landmarks such as Hagia Sophia, the Blue Mosque, and the Grand Bazaar. The tour also includes visits to beautiful natural attractions and traditional markets, all organized in a well-planned itinerary for a comfortable travel experience.',NULL,NULL,'استمتع برحلة جماعية مميزة إلى تركيا حيث يمكنك زيارة إسطنبول الساحرة واستكشاف معالمها التاريخية مثل آيا صوفيا والمسجد الأزرق والبازار الكبير. تشمل الرحلة أيضًا جولات في أجمل المناطق الطبيعية والتسوق في الأسواق التقليدية، مع برنامج سياحي منظم يضمن لك تجربة ممتعة ومريحة.','Enjoy an amazing group trip to Turkey where you will explore the charming city of Istanbul and visit famous landmarks such as Hagia Sophia, the Blue Mosque, and the Grand Bazaar. The tour also includes visits to beautiful natural attractions and traditional markets, all organized in a well-planned itinerary for a comfortable travel experience.',NULL,NULL,'turkey-group-tour',NULL,NULL,'رحلة-الشمال-التركي-و-اسطنبول','اكتشف سحر تركيا في رحلة جماعية ممتعة تشمل أشهر المعالم السياحية.','Discover the beauty of Turkey in an exciting group tour covering its most famous attractions.',NULL,NULL,'<p>تبدأ الرحلة في إسطنبول بزيارة آيا صوفيا، ثم قصر دولما بهجة مع جولة ساحرة في البوسفور. بعدها يوم هادئ في جزر الأميرات، واستكشاف كاديكوي، مع وقت ممتع للتسوق.</p><p><br></p><p>ثم تنتقل الرحلة إلى الشمال التركي، حيث الطبيعة الخلابة في أوزنجول وريزا، مرورًا بمرتفعات آيدر، وزيارة دير سوميلا، وختامها في همسي كوي.</p>','<p>تبدأ الرحلة في إسطنبول بزيارة آيا صوفيا، ثم قصر دولما بهجة مع جولة ساحرة في البوسفور. بعدها يوم هادئ في جزر الأميرات، واستكشاف كاديكوي، مع وقت ممتع للتسوق.</p><p><br></p><p>ثم تنتقل الرحلة إلى الشمال التركي، حيث الطبيعة الخلابة في أوزنجول وريزا، مرورًا بمرتفعات آيدر، وزيارة دير سوميلا، وختامها في همسي كوي.</p>',NULL,NULL,'2026-03-12 19:34:35','2026-04-26 22:43:18',5700.00,1000.00,'amount',0,NULL,'1',NULL,'2026-05-15','2026-05-22','1447-11-28','1447-12-05','https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d46470.06906547024!2d31.392329937098243!3d30.039481424807832!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x14583cd9d50c1bff%3A0xf341a9d902a3e150!2sMedical%20park%20premier!5e0!3m2!1sen!2seg!4v1768660231065!5m2!1sen!2seg',NULL,'أجازة الحج 1','0551933635','0551933635','0551933635',30),
(2,4,NULL,'Mediterranean Cruise',NULL,NULL,'كروز البحر المتوسط','/uploads/tenant_1/general/69b08d389b93a_1773178168_general.webp',NULL,NULL,'/uploads/tenant_1/general/69b08d389b93a_1773178168_general.webp',1,0,'كروز البحر المتوسط','Mediterranean Cruise',NULL,NULL,'/uploads/tenant_1/general/69b08d389b93a_1773178168_general.webp','رحلة بحرية فاخرة لاكتشاف أجمل مدن البحر المتوسط.','A luxury cruise to explore the most beautiful cities of the Mediterranean',NULL,NULL,'رحلة بحرية فاخرة لاكتشاف أجمل مدن البحر المتوسط.','A luxury cruise to explore the most beautiful cities of the Mediterranean',NULL,NULL,'mediterranean-cruise',NULL,NULL,'كروز-البحر-المتوسط','رحلة بحرية فاخرة لاكتشاف أجمل مدن البحر المتوسط.','A luxury cruise to explore the most beautiful cities of the Mediterranean',NULL,NULL,'<li data-section-id=\"1xb9p0q\" data-start=\"2347\" data-end=\"2617\"><p data-start=\"2349\" data-end=\"2617\">استمتع بتجربة فاخرة على متن كروز البحر المتوسط حيث تجمع الرحلة بين الراحة والمغامرة. ستزور عدة مدن ساحلية ساحرة، وتستمتع بالخدمات الراقية على متن السفينة مثل المطاعم العالمية والأنشطة الترفيهية. إنها فرصة مثالية للاسترخاء واكتشاف ثقافات مختلفة خلال رحلة واحدة.</p>\r\n</li><p>\r\n</p><li data-section-id=\"16mx0x\" data-start=\"2619\" data-end=\"2945\">\r\n<p data-start=\"2621\" data-end=\"2945\"></p></li>','<p>Experience a luxurious journey aboard a Mediterranean cruise where relaxation meets adventure. You will visit stunning coastal cities while enjoying world-class services on board, including fine dining and entertainment activities. It’s the perfect way to relax while exploring multiple cultures in a single trip.</p>',NULL,NULL,'2026-03-12 19:39:07','2026-04-21 02:58:18',6000.00,0.00,'amount',0,NULL,'2',NULL,'2026-03-12','2026-03-28',NULL,NULL,'https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d46470.06906547024!2d31.392329937098243!3d30.039481424807832!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x14583cd9d50c1bff%3A0xf341a9d902a3e150!2sMedical%20park%20premier!5e0!3m2!1sen!2seg!4v1768660231065!5m2!1sen!2seg','2026-04-21 02:58:18','summer 2025','01028768312','01028768312','01028768312',90),
(3,3,2,'Egyptian Civilization Educational Tour',NULL,NULL,'رحلة تعليمية لاكتشاف الحضارة المصرية','/uploads/tenant_1/general/69b2bd080cd94_1773321480_general.jpeg',NULL,NULL,'/uploads/tenant_1/general/69b2bd080cd94_1773321480_general.jpeg',1,0,'رحلة تعليمية لاكتشاف الحضارة المصرية','Egyptian Civilization Educational Tour',NULL,NULL,'/uploads/tenant_1/general/69b2bd080cd94_1773321480_general.jpeg','رحلة تعليمية لاكتشاف تاريخ وحضارة مصر القديمة.','An educational tour to explore the history of ancient Egyptian civilization.',NULL,NULL,'رحلة تعليمية لاكتشاف تاريخ وحضارة مصر القديمة.','An educational tour to explore the history of ancient Egyptian civilization.',NULL,NULL,'egyptian-civilization-educational-tour',NULL,NULL,'رحلة-تعليمية-لاكتشاف-الحضارة-المصرية','رحلة تعليمية لاكتشاف تاريخ وحضارة مصر القديمة.','An educational tour to explore the history of ancient Egyptian civilization.',NULL,NULL,'<p>تمنحك هذه الرحلة التعليمية فرصة رائعة للتعرف على الحضارة المصرية القديمة من خلال زيارة الأهرامات والمتحف المصري والمعالم التاريخية المهمة. سيحصل المشاركون على تجربة تعليمية ممتعة تجمع بين المعرفة والاستكشاف، مما يجعلها مناسبة للطلاب ومحبي التاريخ.</p>','<p>This educational tour offers a unique opportunity to learn about ancient Egyptian civilization by visiting the pyramids, the Egyptian Museum, and other historical landmarks. Participants will enjoy a rich learning experience that combines education with exploration, making it ideal for students and history enthusiasts.</p>',NULL,NULL,'2026-03-12 19:42:48','2026-04-21 02:59:13',1000.00,500.00,'amount',0,NULL,'3',NULL,'2026-03-12','2026-03-23','1447-11-11','1447-11-26','https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d46470.06906547024!2d31.392329937098243!3d30.039481424807832!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x14583cd9d50c1bff%3A0xf341a9d902a3e150!2sMedical%20park%20premier!5e0!3m2!1sen!2seg!4v1768660231065!5m2!1sen!2seg','2026-04-21 02:59:13','summer 2025','01028768312','01028768312','01028768312',99),
(4,2,NULL,'Schengen Visa Service',NULL,NULL,'خدمة تأشيرة شنغن','/uploads/tenant_1/general/69b2bd080d6d9_1773321480_general.jpeg',NULL,NULL,'/uploads/tenant_1/general/69b2bd080d6d9_1773321480_general.jpeg',1,0,'خدمة تأشيرة شنغن','Schengen Visa Service',NULL,NULL,'/uploads/tenant_1/general/69b2bd080d6d9_1773321480_general.jpeg','احصل على تأشيرة شنغن بسهولة للسفر إلى دول أوروبا.','Get your Schengen visa easily to travel across European countries',NULL,NULL,'احصل على تأشيرة شنغن بسهولة للسفر إلى دول أوروبا.','Get your Schengen visa easily to travel across European countries',NULL,NULL,'schengen-visa-service',NULL,NULL,'خدمة-تأشيرة-شنغن','احصل على تأشيرة شنغن بسهولة للسفر إلى دول أوروبا.','Get your Schengen visa easily to travel across European countries',NULL,NULL,'<p>نقدم خدمة متكاملة لمساعدتك في استخراج تأشيرة شنغن بسرعة وسهولة. يشمل ذلك تجهيز الأوراق المطلوبة، تقديم الاستشارات اللازمة، ومتابعة الطلب حتى صدور التأشيرة. هدفنا هو تسهيل إجراءات السفر حتى تتمكن من الاستمتاع برحلتك الأوروبية دون أي تعقيدات.</p>','<p>We provide a complete service to help you obtain your Schengen visa quickly and easily. Our team assists with document preparation, provides professional consultation, and follows up on your application until the visa is issued. Our goal is to make the process smooth so you can enjoy your European trip without complications.</p>',NULL,NULL,'2026-03-12 19:50:21','2026-04-21 02:59:18',2000.00,0.00,'amount',0,NULL,'4',NULL,'2026-03-13','2026-03-21',NULL,NULL,'https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d46470.06906547024!2d31.392329937098243!3d30.039481424807832!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x14583cd9d50c1bff%3A0xf341a9d902a3e150!2sMedical%20park%20premier!5e0!3m2!1sen!2seg!4v1768660231065!5m2!1sen!2seg','2026-04-21 02:59:18','summer 2025','01028768312','01028768312','01028768312',70),
(5,6,NULL,'ييييييييييييييييييي',NULL,NULL,'يييييييييييييييي','/uploads/tenant_1/general/69b03d8218eda_1773157762_general.webp',NULL,NULL,'/uploads/tenant_1/general/69b03d8218eda_1773157762_general.webp',1,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'ييييييييييييييييييي',NULL,NULL,'يييييييييييييييي','يييييييييييي','يييييييييييي',NULL,NULL,'<p>ييييييييييييييييييييي</p>','<p>يييييييييييي</p>',NULL,NULL,'2026-03-16 05:07:27','2026-03-16 19:54:10',6000.00,5000.00,'amount',1,'2026-03-16 05:07:27','1',NULL,'2026-03-16','2026-03-26',NULL,NULL,'https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d46470.06906547024!2d31.392329937098243!3d30.039481424807832!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x14583cd9d50c1bff%3A0xf341a9d902a3e150!2sMedical%20park%20premier!5e0!3m2!1sen!2seg!4v1768660231065!5m2!1sen!2seg','2026-03-16 19:54:10','summer 2025','01028768312','01028768312','01028768312',99),
(6,7,7,'Russia',NULL,NULL,'رحلة روسيا','/uploads/tenant_1/روسيا/69e939c806b45_1776892360_general.jpg',NULL,NULL,'/uploads/tenant_1/روسيا/69e939c806b45_1776892360_general.jpg',1,0,'رحلة موسكو روسيا | اجازة الحج 2026 | 7 ليالي 8 أيام | رحلتنا','Moscow Russia Trip | Hajj Vacation 2026 | 7 Nights 8 Days | Rehltna',NULL,NULL,'/uploads/tenant_1/روسيا/69e68d44aca98_1776717124_general.jpeg','احجز رحلتك إلى موسكو في اجازة الحج 2026 مع رحلتنا! 7 ليالي و8 أيام تشمل طيران دولي، فنادق 4 نجوم مع الإفطار، جولات يومية، ومشرف سياحي. أسعار تبدأ من 6,700 ريال. قروب عوائل وسيدات. احجز الآن!','Book your Moscow trip this Hajj vacation 2026 with Rehltna! 7 nights & 8 days including international flights, 4-star hotels with breakfast, daily tours & a professional guide. Prices from 6,700 SAR. Family & ladies group. Book now!',NULL,NULL,'رحلة موسكو، روسيا اجازة الحج، رحلات الحج 2026، رحلتنا سياحة، موسكو 2026، رحلة روسيا عوائل، جولات موسكو، رحلات منظمة روسيا، اجازة الحج روسيا، حجز رحلة موسكو','Moscow trip 2026, Russia Hajj vacation, Hajj holiday travel, Rehltna tours, Moscow tour package, Russia family trip, organized Russia trip, Moscow sightseeing, Hajj break travel, book Moscow trip Saudi Arabia',NULL,NULL,'russia',NULL,NULL,'رحلة-روسيا','هل تبحث عن وجهة مختلفة تجمع بين التاريخ العريق والجمال المعماري الأخّاذ؟ هذه الإجازة، اختر موسكو — عاصمة الروس وإحدى أعظم مدن العالم — وجهةً لك ولعائلتك في إجازة الحج!\r\n\r\nرحلتنا تأخذك في رحلة استثنائية إلى قلب روسيا، لتكتشف مدينةً تمزج بين عظمة الماضي وبريق الحاضر، حيث الساحات التاريخية والقصور الفارهة .','Looking for a destination that combines rich history, breathtaking architecture, and unforgettable experiences? This Hajj holiday, choose Moscow — the legendary capital of Russia and one of the world\'s most magnificent cities — as your getaway with family and loved ones!\r\n\r\nRehltna takes you on an extraordinary journey to the heart of Russia, where centuries of empire, art, and culture collide in one of the most visually stunning cities on the planet. From iconic red squares to golden-domed cathedrals, Moscow is a city you have to see to believe.',NULL,NULL,'<p class=\"font-claude-response-body break-words whitespace-normal leading-[1.7]\">تجربة أوروبية فاخرة في موسكو، تبدأ بزيارة الساحة الحمراء والكرملين، مع جولة تسوق راقية في مركز جوم(Gum) التجاري.</p><p class=\"font-claude-response-body break-words whitespace-normal leading-[1.7]\"><br></p><p class=\"font-claude-response-body break-words whitespace-normal leading-[1.7]\">مع أجواء ساحرة خلال الرحلة النهرية على نهر موسكفا، و سحر المدينة في شارع أربات ومنطقة كيتاي غورود.</p><p class=\"font-claude-response-body break-words whitespace-normal leading-[1.7]\"><br></p><p class=\"font-claude-response-body break-words whitespace-normal leading-[1.7]\">نهاية الرحلة&nbsp; مع تجارب ترفيهية مميزة في دريم لاند موسكو وسط أجواء تجمع بين الفخامة والمتعة.</p>','<p class=\"font-claude-response-body break-words whitespace-normal leading-[1.7]\">تجربة أوروبية فاخرة في موسكو، تبدأ بزيارة الساحة الحمراء والكرملين، مع جولة تسوق راقية في مركز جوم(Gum) التجاري.</p><p class=\"font-claude-response-body break-words whitespace-normal leading-[1.7]\"><br></p><p class=\"font-claude-response-body break-words whitespace-normal leading-[1.7]\">مع أجواء ساحرة خلال الرحلة النهرية على نهر موسكفا، و سحر المدينة في شارع أربات ومنطقة كيتاي غورود.</p><p class=\"font-claude-response-body break-words whitespace-normal leading-[1.7]\"><br></p><p class=\"font-claude-response-body break-words whitespace-normal leading-[1.7]\">نهاية الرحلة&nbsp; مع تجارب ترفيهية مميزة في دريم لاند موسكو وسط أجواء تجمع بين الفخامة والمتعة.</p>',NULL,NULL,'2026-03-19 02:14:01','2026-04-26 15:51:28',8200.00,1500.00,'amount',0,NULL,'1',NULL,'2026-05-23','2026-05-30','1447-12-06','1447-12-13','https://maps.app.goo.gl/epYpwFDWLQHaHpVq9',NULL,'أجازة الحج','0551897531','0541670713','0541670713',200),
(7,8,4,'رحلة البوسنة',NULL,NULL,'رحلة البوسنة','/uploads/tenant_1/general/69ecbe4d30008_1777122893_general.png',NULL,NULL,'/uploads/tenant_1/general/69ecbe4d30008_1777122893_general.png',1,0,'رحلة جماعية إلى البوسنة','Bosnia Group Tour',NULL,NULL,'/uploads/tenant_1/general/69ecbbaa2d931_1777122218_general.jpeg','استمتع برحلة جماعية مميزة إلى البوسنة حيث يمكنك زيارة سراييفو الساحرة واستكشاف معالمها التاريخية مثل السوق القديم وجسر اللاتين، بالإضافة إلى زيارة موستار الشهيرة وجسرها العريق، والاستمتاع بجمال الطبيعة في بيهاتش وشلالاتها الخلابة. تشمل الرحلة جولات سياحية منظمة وبرنامج متكامل يضمن لك تجربة ممتعة ومريحة.','Enjoy an amazing group trip to Bosnia where you will explore the charming city of Sarajevo and visit historic landmarks like the Old Bazaar and Latin Bridge. The tour also includes visits to Mostar and its iconic bridge, as well as the beautiful nature of Bihac and its stunning waterfalls, all organized in a well-planned itinerary for a comfortable travel experience.',NULL,NULL,'رحلة البوسنة، سياحة البوسنة، سراييفو، موستار، بيهاتش، جسر موستار، شلالات بيهاتش، عروض سفر البوسنة، رحلات جماعية، برامج سياحية البوسنة','Bosnia trip, Bosnia travel, Sarajevo tour, Mostar bridge, Bihac waterfalls, Bosnia packages, group travel Bosnia, Bosnia itinerary, travel deals Bosnia',NULL,NULL,'رحلة-البوسنة',NULL,NULL,'رحلة-البوسنة','اكتشف سحر البوسنةشهر يوليو صيف  2026 في رحلة جماعية ممتعة تشمل أشهر المعالم السياحية.','اكتشف سحر البوسنةشهر يوليو صيف  2026 في رحلة جماعية ممتعة تشمل أشهر المعالم السياحية.',NULL,NULL,'<p>اكتشف سحر البوسنة<span style=\"font-size: 0.875rem;\">شهر يوليو صيف</span><span style=\"font-size: 0.875rem;\">&nbsp; 2026</span><span style=\"font-size: 0.875rem;\">&nbsp;في رحلة جماعية ممتعة تشمل أشهر المعالم السياحية.</span></p>','<p>اكتشف سحر البوسنة<span style=\"font-size: 0.875rem;\">شهر يوليو صيف</span><span style=\"font-size: 0.875rem;\">&nbsp; 2026</span><span style=\"font-size: 0.875rem;\">&nbsp;في رحلة جماعية ممتعة تشمل أشهر المعالم السياحية.</span></p>',NULL,NULL,'2026-04-25 04:19:16','2026-04-26 00:46:47',7600.00,1000.00,'amount',0,NULL,'1',NULL,'2026-07-02','2026-07-09','1448-01-17','1448-01-24','https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d46470.06906547024!2d31.392329937098243!3d30.039481424807832!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x14583cd9d50c1bff%3A0xf341a9d902a3e150!2sMedical%20park%20premier!5e0!3m2!1sen!2seg!4v1768660231065!5m2!1sen!2seg',NULL,'يوليو 2026','0551933635','0551933635','0551933635',30),
(9,8,4,'رحلة البوسنة',NULL,NULL,'رحلة البوسنة','/uploads/tenant_1/general/69ecbe4d30008_1777122893_general.png',NULL,NULL,'/uploads/tenant_1/general/69ecbe4d30008_1777122893_general.png',1,0,'رحلة جماعية إلى البوسنة','Bosnia Group Tour',NULL,NULL,'/uploads/tenant_1/general/69ecbbaa2d931_1777122218_general.jpeg','استمتع برحلة جماعية مميزة إلى البوسنة حيث يمكنك زيارة سراييفو الساحرة واستكشاف معالمها التاريخية مثل السوق القديم وجسر اللاتين، بالإضافة إلى زيارة موستار الشهيرة وجسرها العريق، والاستمتاع بجمال الطبيعة في بيهاتش وشلالاتها الخلابة. تشمل الرحلة جولات سياحية منظمة وبرنامج متكامل يضمن لك تجربة ممتعة ومريحة.','Enjoy an amazing group trip to Bosnia where you will explore the charming city of Sarajevo and visit historic landmarks like the Old Bazaar and Latin Bridge. The tour also includes visits to Mostar and its iconic bridge, as well as the beautiful nature of Bihac and its stunning waterfalls, all organized in a well-planned itinerary for a comfortable travel experience.',NULL,NULL,'رحلة البوسنة، سياحة البوسنة، سراييفو، موستار، بيهاتش، جسر موستار، شلالات بيهاتش، عروض سفر البوسنة، رحلات جماعية، برامج سياحية البوسنة','Bosnia trip, Bosnia travel, Sarajevo tour, Mostar bridge, Bihac waterfalls, Bosnia packages, group travel Bosnia, Bosnia itinerary, travel deals Bosnia',NULL,NULL,'رحلة-البوسنة',NULL,NULL,'رحلة-البوسنة','اكتشف سحر البوسنةشهر أغسطس صيف  2026 في رحلة جماعية ممتعة تشمل أشهر المعالم السياحية.','اكتشف سحر البوسنةشهر أغسطس صيف  2026 في رحلة جماعية ممتعة تشمل أشهر المعالم السياحية.',NULL,NULL,'<p>اكتشف سحر البوسنة<span style=\"font-size: 0.875rem;\">شهر أغسطس صيف</span><span style=\"font-size: 0.875rem;\">&nbsp; 2026</span><span style=\"font-size: 0.875rem;\">&nbsp;في رحلة جماعية ممتعة تشمل أشهر المعالم السياحية.</span></p>','<p>اكتشف سحر البوسنة شهر أغسطس صيف 2026 في رحلة جماعية ممتعة تشمل أشهر المعالم السياحية.</p>',NULL,NULL,'2026-04-26 00:18:55','2026-04-26 00:46:01',6500.00,1000.00,'amount',0,NULL,'1',NULL,'2026-08-13','2026-08-20','1448-02-30','1448-03-07','https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d46470.06906547024!2d31.392329937098243!3d30.039481424807832!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x14583cd9d50c1bff%3A0xf341a9d902a3e150!2sMedical%20park%20premier!5e0!3m2!1sen!2seg!4v1768660231065!5m2!1sen!2seg',NULL,'أغسطس 2026','0551933635','0551933635','0551933635',30),
(8,4,4,'رحلة البوسنة (Copy)',NULL,NULL,'رحلة كروز','/uploads/tenant_1/general/69ecbbaa2d931_1777122218_general.jpeg',NULL,NULL,'/uploads/tenant_1/general/69ecbbaa2d931_1777122218_general.jpeg',1,0,'رحلة جماعية إلى البوسنة','Turkey Group Tour',NULL,NULL,'/uploads/tenant_1/general/69ecbbaa2d931_1777122218_general.jpeg','استمتع برحلة جماعية مميزة إلى تركيا حيث يمكنك زيارة إسطنبول الساحرة واستكشاف معالمها التاريخية مثل آيا صوفيا والمسجد الأزرق والبازار الكبير. تشمل الرحلة أيضًا جولات في أجمل المناطق الطبيعية والتسوق في الأسواق التقليدية، مع برنامج سياحي منظم يضمن لك تجربة ممتعة ومريحة.','Enjoy an amazing group trip to Turkey where you will explore the charming city of Istanbul and visit famous landmarks such as Hagia Sophia, the Blue Mosque, and the Grand Bazaar. The tour also includes visits to beautiful natural attractions and traditional markets, all organized in a well-planned itinerary for a comfortable travel experience.',NULL,NULL,'استمتع برحلة جماعية مميزة إلى تركيا حيث يمكنك زيارة إسطنبول الساحرة واستكشاف معالمها التاريخية مثل آيا صوفيا والمسجد الأزرق والبازار الكبير. تشمل الرحلة أيضًا جولات في أجمل المناطق الطبيعية والتسوق في الأسواق التقليدية، مع برنامج سياحي منظم يضمن لك تجربة ممتعة ومريحة.','Enjoy an amazing group trip to Turkey where you will explore the charming city of Istanbul and visit famous landmarks such as Hagia Sophia, the Blue Mosque, and the Grand Bazaar. The tour also includes visits to beautiful natural attractions and traditional markets, all organized in a well-planned itinerary for a comfortable travel experience.',NULL,NULL,'rhl-albosn-copy',NULL,NULL,'رحلة-كروز','اكتشف سحر البوسنة في رحلة جماعية ممتعة تشمل أشهر المعالم السياحية.','اكتشف سحر البوسنة في رحلة جماعية ممتعة تشمل أشهر المعالم السياحية.',NULL,NULL,'<p>اكتشف سحر البوسنة في رحلة جماعية ممتعة تشمل أشهر المعالم السياحية.</p>','<p>اكتشف سحر البوسنة في رحلة جماعية ممتعة تشمل أشهر المعالم السياحية.</p>',NULL,NULL,'2026-04-25 20:09:24','2026-04-25 20:13:27',7600.00,1000.00,'amount',1,'2026-04-25 20:11:55','1',NULL,'2026-07-02','2026-07-09','1448-01-17','1448-01-24','https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d46470.06906547024!2d31.392329937098243!3d30.039481424807832!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x14583cd9d50c1bff%3A0xf341a9d902a3e150!2sMedical%20park%20premier!5e0!3m2!1sen!2seg!4v1768660231065!5m2!1sen!2seg','2026-04-25 20:13:27','يوليو 2026','0551933635','0551933635','0551933635',30),
(10,8,4,'رحلة البوسنة (Copy)',NULL,NULL,'رحلة البوسنة (Copy)','/uploads/tenant_1/general/69ecbe4d30008_1777122893_general.png',NULL,NULL,'/uploads/tenant_1/general/69ecbe4d30008_1777122893_general.png',0,0,'رحلة جماعية إلى البوسنة','Bosnia Group Tour',NULL,NULL,'/uploads/tenant_1/general/69ecbbaa2d931_1777122218_general.jpeg','استمتع برحلة جماعية مميزة إلى البوسنة حيث يمكنك زيارة سراييفو الساحرة واستكشاف معالمها التاريخية مثل السوق القديم وجسر اللاتين، بالإضافة إلى زيارة موستار الشهيرة وجسرها العريق، والاستمتاع بجمال الطبيعة في بيهاتش وشلالاتها الخلابة. تشمل الرحلة جولات سياحية منظمة وبرنامج متكامل يضمن لك تجربة ممتعة ومريحة.','Enjoy an amazing group trip to Bosnia where you will explore the charming city of Sarajevo and visit historic landmarks like the Old Bazaar and Latin Bridge. The tour also includes visits to Mostar and its iconic bridge, as well as the beautiful nature of Bihac and its stunning waterfalls, all organized in a well-planned itinerary for a comfortable travel experience.',NULL,NULL,'رحلة البوسنة، سياحة البوسنة، سراييفو، موستار، بيهاتش، جسر موستار، شلالات بيهاتش، عروض سفر البوسنة، رحلات جماعية، برامج سياحية البوسنة','Bosnia trip, Bosnia travel, Sarajevo tour, Mostar bridge, Bihac waterfalls, Bosnia packages, group travel Bosnia, Bosnia itinerary, travel deals Bosnia',NULL,NULL,'rhl-albosn-copy-1',NULL,NULL,'rhl-albosn-copy-1','اكتشف سحر البوسنة في رحلة جماعية ممتعة تشمل أشهر المعالم السياحية.','اكتشف سحر البوسنة في رحلة جماعية ممتعة تشمل أشهر المعالم السياحية.',NULL,NULL,'<p>اكتشف سحر البوسنة في رحلة جماعية ممتعة تشمل أشهر المعالم السياحية.</p>','<p>اكتشف سحر البوسنة في رحلة جماعية ممتعة تشمل أشهر المعالم السياحية.</p>',NULL,NULL,'2026-04-26 00:19:03','2026-04-26 00:19:21',7600.00,1000.00,'amount',0,NULL,'1',NULL,'2026-07-02','2026-07-09','1448-01-17','1448-01-24','https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d46470.06906547024!2d31.392329937098243!3d30.039481424807832!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x14583cd9d50c1bff%3A0xf341a9d902a3e150!2sMedical%20park%20premier!5e0!3m2!1sen!2seg!4v1768660231065!5m2!1sen!2seg','2026-04-26 00:19:21','يوليو 2026','0551933635','0551933635','0551933635',30);
/*!40000 ALTER TABLE `items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `job_batches`
--

DROP TABLE IF EXISTS `job_batches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `job_batches` (
  `id` varchar(191) NOT NULL,
  `name` varchar(191) NOT NULL,
  `total_jobs` int(11) NOT NULL,
  `pending_jobs` int(11) NOT NULL,
  `failed_jobs` int(11) NOT NULL,
  `failed_job_ids` longtext NOT NULL,
  `options` mediumtext DEFAULT NULL,
  `cancelled_at` int(11) DEFAULT NULL,
  `created_at` int(11) NOT NULL,
  `finished_at` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `job_batches`
--

LOCK TABLES `job_batches` WRITE;
/*!40000 ALTER TABLE `job_batches` DISABLE KEYS */;
/*!40000 ALTER TABLE `job_batches` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `jobs`
--

DROP TABLE IF EXISTS `jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `jobs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `queue` varchar(191) NOT NULL,
  `payload` longtext NOT NULL,
  `attempts` tinyint(3) unsigned NOT NULL,
  `reserved_at` int(10) unsigned DEFAULT NULL,
  `available_at` int(10) unsigned NOT NULL,
  `created_at` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `jobs_queue_index` (`queue`)
) ENGINE=MyISAM AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `jobs`
--

LOCK TABLES `jobs` WRITE;
/*!40000 ALTER TABLE `jobs` DISABLE KEYS */;
INSERT INTO `jobs` VALUES
(14,'default','{\"uuid\":\"492ff233-240c-41a9-b822-0ba3e8e938a7\",\"displayName\":\"App\\\\Jobs\\\\SendPushNotificationJob\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":null,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":null,\"retryUntil\":null,\"data\":{\"commandName\":\"App\\\\Jobs\\\\SendPushNotificationJob\",\"command\":\"O:32:\\\"App\\\\Jobs\\\\SendPushNotificationJob\\\":4:{s:5:\\\"token\\\";s:142:\\\"e9RSQpbzRICS54ujLZ_RqQ:APA91bGcfJk_hamKoCAkvtqaYRy-OgloYcoJC0-rvHZ16BE1kkT8s2FRIz3nCE-Qg30ffGy68q_nG4s-avB2OdLypSTj28kD6S_tkBmVZQBoeXe2fruhu94\\\";s:5:\\\"title\\\";s:10:\\\"توحيد\\\";s:4:\\\"body\\\";s:8:\\\"اهلا\\\";s:4:\\\"data\\\";a:1:{s:4:\\\"type\\\";s:20:\\\"general_announcement\\\";}}\"},\"createdAt\":1777035030,\"illuminate:log:context\":{\"data\":{\"tenantId\":\"i:1;\"},\"hidden\":[]},\"delay\":null}',0,NULL,1777035030,1777035030),
(15,'default','{\"uuid\":\"c4af6c2e-be19-4375-a546-b0b5e31a77c3\",\"displayName\":\"App\\\\Jobs\\\\SendPushNotificationJob\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":null,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":null,\"retryUntil\":null,\"data\":{\"commandName\":\"App\\\\Jobs\\\\SendPushNotificationJob\",\"command\":\"O:32:\\\"App\\\\Jobs\\\\SendPushNotificationJob\\\":4:{s:5:\\\"token\\\";s:142:\\\"e9RSQpbzRICS54ujLZ_RqQ:APA91bGcfJk_hamKoCAkvtqaYRy-OgloYcoJC0-rvHZ16BE1kkT8s2FRIz3nCE-Qg30ffGy68q_nG4s-avB2OdLypSTj28kD6S_tkBmVZQBoeXe2fruhu94\\\";s:5:\\\"title\\\";s:99:\\\"🌟 رحلة جديدة في انتظارك: رحلة الشمال التركي و اسطنبول!\\\";s:4:\\\"body\\\";s:180:\\\"خبر سعيد! لقد أضفنا رحلة رحلة الشمال التركي و اسطنبول إلى قائمتنا. احجز مكانك الآن قبل نفاد التذاكر.\\\";s:4:\\\"data\\\";a:2:{s:4:\\\"type\\\";s:12:\\\"custom_alert\\\";s:7:\\\"trip_id\\\";s:1:\\\"1\\\";}}\"},\"createdAt\":1777065550,\"illuminate:log:context\":{\"data\":{\"tenantId\":\"i:1;\"},\"hidden\":[]},\"delay\":null}',0,NULL,1777065550,1777065550),
(16,'default','{\"uuid\":\"c7c47d2b-f277-4e43-bd0b-084a94557bb0\",\"displayName\":\"App\\\\Jobs\\\\SendPushNotificationJob\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":null,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":null,\"retryUntil\":null,\"data\":{\"commandName\":\"App\\\\Jobs\\\\SendPushNotificationJob\",\"command\":\"O:32:\\\"App\\\\Jobs\\\\SendPushNotificationJob\\\":4:{s:5:\\\"token\\\";s:142:\\\"e9RSQpbzRICS54ujLZ_RqQ:APA91bGcfJk_hamKoCAkvtqaYRy-OgloYcoJC0-rvHZ16BE1kkT8s2FRIz3nCE-Qg30ffGy68q_nG4s-avB2OdLypSTj28kD6S_tkBmVZQBoeXe2fruhu94\\\";s:5:\\\"title\\\";s:80:\\\"⏳ الفرصة الأخيرة للانضمام إلى رحلة البوسنة!\\\";s:4:\\\"body\\\";s:156:\\\"الأماكن تقترب من النفاد في رحلة رحلة البوسنة. احجز مقعدك اليوم واستعد لتجربة لا تُنسى.\\\";s:4:\\\"data\\\";a:2:{s:4:\\\"type\\\";s:12:\\\"custom_alert\\\";s:7:\\\"trip_id\\\";s:1:\\\"7\\\";}}\"},\"createdAt\":1777122543,\"illuminate:log:context\":{\"data\":{\"tenantId\":\"i:1;\"},\"hidden\":[]},\"delay\":null}',0,NULL,1777122543,1777122543),
(17,'default','{\"uuid\":\"fbe7ce23-e97f-4053-aa03-b804f23744c1\",\"displayName\":\"App\\\\Jobs\\\\SendPushNotificationJob\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":null,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":null,\"retryUntil\":null,\"data\":{\"commandName\":\"App\\\\Jobs\\\\SendPushNotificationJob\",\"command\":\"O:32:\\\"App\\\\Jobs\\\\SendPushNotificationJob\\\":4:{s:5:\\\"token\\\";s:142:\\\"e9RSQpbzRICS54ujLZ_RqQ:APA91bGcfJk_hamKoCAkvtqaYRy-OgloYcoJC0-rvHZ16BE1kkT8s2FRIz3nCE-Qg30ffGy68q_nG4s-avB2OdLypSTj28kD6S_tkBmVZQBoeXe2fruhu94\\\";s:5:\\\"title\\\";s:25:\\\"🌟 Special Offer Alert!\\\";s:4:\\\"body\\\";s:93:\\\"Don\'t miss out! رحلة البوسنة (Copy) is now on a special offer for the next 7 days.\\\";s:4:\\\"data\\\";a:2:{s:4:\\\"type\\\";s:13:\\\"special_offer\\\";s:7:\\\"trip_id\\\";s:1:\\\"8\\\";}}\"},\"createdAt\":1777122712,\"illuminate:log:context\":{\"data\":{\"tenantId\":\"i:1;\"},\"hidden\":[]},\"delay\":null}',0,NULL,1777122712,1777122712),
(18,'default','{\"uuid\":\"450dbfa7-07aa-4a5f-a854-02f9a5997c8a\",\"displayName\":\"App\\\\Jobs\\\\SendPushNotificationJob\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":null,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":null,\"retryUntil\":null,\"data\":{\"commandName\":\"App\\\\Jobs\\\\SendPushNotificationJob\",\"command\":\"O:32:\\\"App\\\\Jobs\\\\SendPushNotificationJob\\\":4:{s:5:\\\"token\\\";s:142:\\\"e9RSQpbzRICS54ujLZ_RqQ:APA91bGcfJk_hamKoCAkvtqaYRy-OgloYcoJC0-rvHZ16BE1kkT8s2FRIz3nCE-Qg30ffGy68q_nG4s-avB2OdLypSTj28kD6S_tkBmVZQBoeXe2fruhu94\\\";s:5:\\\"title\\\";s:25:\\\"🌟 Special Offer Alert!\\\";s:4:\\\"body\\\";s:93:\\\"Don\'t miss out! رحلة البوسنة (Copy) is now on a special offer for the next 7 days.\\\";s:4:\\\"data\\\";a:2:{s:4:\\\"type\\\";s:13:\\\"special_offer\\\";s:7:\\\"trip_id\\\";s:1:\\\"8\\\";}}\"},\"createdAt\":1777122715,\"illuminate:log:context\":{\"data\":{\"tenantId\":\"i:1;\"},\"hidden\":[]},\"delay\":null}',0,NULL,1777122715,1777122715),
(19,'default','{\"uuid\":\"a4c5fb92-40bf-49ca-8ac8-75cc56984094\",\"displayName\":\"App\\\\Jobs\\\\SendPushNotificationJob\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":null,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":null,\"retryUntil\":null,\"data\":{\"commandName\":\"App\\\\Jobs\\\\SendPushNotificationJob\",\"command\":\"O:32:\\\"App\\\\Jobs\\\\SendPushNotificationJob\\\":4:{s:5:\\\"token\\\";s:142:\\\"e9RSQpbzRICS54ujLZ_RqQ:APA91bGcfJk_hamKoCAkvtqaYRy-OgloYcoJC0-rvHZ16BE1kkT8s2FRIz3nCE-Qg30ffGy68q_nG4s-avB2OdLypSTj28kD6S_tkBmVZQBoeXe2fruhu94\\\";s:5:\\\"title\\\";s:25:\\\"🌟 Special Offer Alert!\\\";s:4:\\\"body\\\";s:93:\\\"Don\'t miss out! رحلة البوسنة (Copy) is now on a special offer for the next 7 days.\\\";s:4:\\\"data\\\";a:2:{s:4:\\\"type\\\";s:13:\\\"special_offer\\\";s:7:\\\"trip_id\\\";s:1:\\\"9\\\";}}\"},\"createdAt\":1777138652,\"illuminate:log:context\":{\"data\":{\"tenantId\":\"i:1;\"},\"hidden\":[]},\"delay\":null}',0,NULL,1777138652,1777138652),
(20,'default','{\"uuid\":\"9fce577e-0f72-4a36-89b1-01161fb1ae62\",\"displayName\":\"App\\\\Jobs\\\\SendPushNotificationJob\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":null,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":null,\"retryUntil\":null,\"data\":{\"commandName\":\"App\\\\Jobs\\\\SendPushNotificationJob\",\"command\":\"O:32:\\\"App\\\\Jobs\\\\SendPushNotificationJob\\\":4:{s:5:\\\"token\\\";s:142:\\\"e9RSQpbzRICS54ujLZ_RqQ:APA91bGcfJk_hamKoCAkvtqaYRy-OgloYcoJC0-rvHZ16BE1kkT8s2FRIz3nCE-Qg30ffGy68q_nG4s-avB2OdLypSTj28kD6S_tkBmVZQBoeXe2fruhu94\\\";s:5:\\\"title\\\";s:25:\\\"🌟 Special Offer Alert!\\\";s:4:\\\"body\\\";s:86:\\\"Don\'t miss out! رحلة البوسنة is now on a special offer for the next 7 days.\\\";s:4:\\\"data\\\";a:2:{s:4:\\\"type\\\";s:13:\\\"special_offer\\\";s:7:\\\"trip_id\\\";s:1:\\\"9\\\";}}\"},\"createdAt\":1777138745,\"illuminate:log:context\":{\"data\":{\"tenantId\":\"i:1;\"},\"hidden\":[]},\"delay\":null}',0,NULL,1777138745,1777138745);
/*!40000 ALTER TABLE `jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lead_magnet_types`
--

DROP TABLE IF EXISTS `lead_magnet_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `lead_magnet_types` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name_ar` varchar(191) DEFAULT NULL,
  `name_en` varchar(191) DEFAULT NULL,
  `name_de` varchar(191) DEFAULT NULL,
  `name_fr` varchar(191) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lead_magnet_types`
--

LOCK TABLES `lead_magnet_types` WRITE;
/*!40000 ALTER TABLE `lead_magnet_types` DISABLE KEYS */;
/*!40000 ALTER TABLE `lead_magnet_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lead_magnets`
--

DROP TABLE IF EXISTS `lead_magnets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `lead_magnets` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name_ar` varchar(191) DEFAULT NULL,
  `name_en` varchar(191) DEFAULT NULL,
  `name_de` varchar(191) DEFAULT NULL,
  `name_fr` varchar(191) DEFAULT NULL,
  `description_ar` text DEFAULT NULL,
  `description_en` text DEFAULT NULL,
  `description_de` longtext DEFAULT NULL,
  `description_fr` longtext DEFAULT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 1,
  `lead_magnet_type_id` bigint(20) unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `banner_en` varchar(191) DEFAULT NULL,
  `banner_de` varchar(191) DEFAULT NULL,
  `banner_fr` varchar(191) DEFAULT NULL,
  `banner_ar` varchar(191) DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `lead_magnets_lead_magnet_type_id_foreign` (`lead_magnet_type_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lead_magnets`
--

LOCK TABLES `lead_magnets` WRITE;
/*!40000 ALTER TABLE `lead_magnets` DISABLE KEYS */;
/*!40000 ALTER TABLE `lead_magnets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `leads`
--

DROP TABLE IF EXISTS `leads`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `leads` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `email` varchar(191) NOT NULL,
  `lead_magnet_id` bigint(20) unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `leads_lead_magnet_id_foreign` (`lead_magnet_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `leads`
--

LOCK TABLES `leads` WRITE;
/*!40000 ALTER TABLE `leads` DISABLE KEYS */;
/*!40000 ALTER TABLE `leads` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `members`
--

DROP TABLE IF EXISTS `members`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `members` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name_en` varchar(191) DEFAULT NULL,
  `name_de` varchar(191) DEFAULT NULL,
  `name_fr` varchar(191) DEFAULT NULL,
  `name_ar` varchar(191) DEFAULT NULL,
  `description_ar` longtext DEFAULT NULL,
  `description_en` longtext DEFAULT NULL,
  `description_de` longtext DEFAULT NULL,
  `description_fr` longtext DEFAULT NULL,
  `img` text DEFAULT NULL,
  `meta_title_ar` varchar(191) DEFAULT NULL,
  `meta_title_en` varchar(191) DEFAULT NULL,
  `meta_title_de` varchar(191) DEFAULT NULL,
  `meta_title_fr` varchar(191) DEFAULT NULL,
  `meta_img` text DEFAULT NULL,
  `meta_description_ar` text DEFAULT NULL,
  `meta_description_en` text DEFAULT NULL,
  `meta_description_de` text DEFAULT NULL,
  `meta_description_fr` text DEFAULT NULL,
  `meta_keywords_ar` text DEFAULT NULL,
  `meta_keywords_en` text DEFAULT NULL,
  `meta_keywords_de` text DEFAULT NULL,
  `meta_keywords_fr` text DEFAULT NULL,
  `status` tinyint(4) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `order` varchar(191) DEFAULT '0',
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `members`
--

LOCK TABLES `members` WRITE;
/*!40000 ALTER TABLE `members` DISABLE KEYS */;
/*!40000 ALTER TABLE `members` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `migrations`
--

DROP TABLE IF EXISTS `migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `migrations` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `migration` varchar(191) NOT NULL,
  `batch` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=119 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `migrations`
--

LOCK TABLES `migrations` WRITE;
/*!40000 ALTER TABLE `migrations` DISABLE KEYS */;
INSERT INTO `migrations` VALUES
(1,'0001_01_01_000000_create_users_table',1),
(2,'0001_01_01_000001_create_cache_table',1),
(3,'0001_01_01_000002_create_jobs_table',1),
(4,'2025_06_04_091948_create_settings_table',1),
(5,'2025_06_10_071351_create_ais_table',1),
(6,'2025_06_11_065057_create_categories_table',1),
(7,'2025_06_11_065128_create_blogs_table',1),
(8,'2025_06_14_073924_create_type_offers_table',1),
(9,'2025_06_14_073937_create_offers_table',1),
(10,'2025_06_15_075118_create_item_types_table',1),
(11,'2025_06_15_075125_create_items_table',1),
(12,'2025_06_15_075604_create_galleries_table',1),
(13,'2025_06_16_072304_create_personal_access_tokens_table',1),
(14,'2025_06_17_080528_create_contact_us_table',1),
(15,'2025_06_18_081141_create_sliders_table',1),
(16,'2025_06_18_101656_create_tenants_table',1),
(17,'2025_06_21_071516_create_career_types_table',1),
(18,'2025_06_21_071522_create_careers_table',1),
(19,'2025_06_21_071544_create_apply_jobs_table',1),
(20,'2025_07_16_083253_create_custom_pages_table',1),
(21,'2025_07_19_080744_create_subscribes_table',1),
(22,'2025_07_21_083616_add_price_to_items',1),
(23,'2025_07_21_132256_add_banners_to_item_types',1),
(24,'2025_07_26_080818_add_feature_to_item_types',1),
(25,'2025_07_26_080852_add_feature_to_items',1),
(26,'2025_07_26_080911_add_feature_to_blogs',1),
(27,'2025_07_26_135132_add_feature_to_offers',1),
(28,'2025_07_27_075753_create_events_table',1),
(29,'2025_07_27_080744_create_event_galleries_table',1),
(30,'2025_07_28_081002_create_members_table',1),
(31,'2025_07_28_081031_create_news_table',1),
(32,'2025_08_12_082242_add_role__and_tenant_id_to_users',1),
(33,'2025_08_12_092130_add_tour_step_to_users',1),
(34,'2025_08_16_105308_add_slug_to_careers',1),
(35,'2025_08_17_080826_create_portfolios_table',1),
(36,'2025_08_18_073454_create_error_uploadeds_table',1),
(37,'2025_08_19_080822_create_password_reset_codes_table',1),
(38,'2025_08_19_090415_create_residency_users_table',1),
(39,'2025_08_20_064932_create_protocols_table',1),
(40,'2025_08_20_065319_create_clinical_publications_table',1),
(41,'2025_08_20_094814_create_disease_types_table',1),
(42,'2025_08_20_102742_create_residency_programs_table',1),
(43,'2025_08_20_102818_create_patient_education_table',1),
(44,'2025_09_06_075711_create_portfolio_categories_table',1),
(45,'2025_09_06_075843_add_portfolio_category_id_to_portfolios',1),
(46,'2025_11_09_190213_create_lead_magnet_types_table',1),
(47,'2025_11_09_190238_create_lead_magnets_table',1),
(48,'2025_11_09_190250_create_leads_table',1),
(49,'2025_11_09_190544_create_testimonials_table',1),
(50,'2025_11_11_080337_add_order_to_blogs',1),
(51,'2025_11_11_080404_add_order_to_items',1),
(52,'2025_11_11_080414_add_order_to_offers',1),
(53,'2025_11_11_080519_add_order_to_portfolios',1),
(54,'2025_11_11_102048_add_order_to_events',1),
(55,'2025_11_11_102211_add_order_to_event_galleries',1),
(56,'2025_11_11_102234_add_order_to_news',1),
(57,'2025_11_11_102347_add_order_to_members',1),
(58,'2025_11_11_102429_add_order_to_patient_education',1),
(59,'2025_11_11_102601_add_order_to_residency_programs',1),
(60,'2025_11_11_102635_add_order_to_protocols',1),
(61,'2025_11_11_102721_add_order_to_clinical_publications',1),
(62,'2025_11_11_125455_add_banner_to_lead_magnets',1),
(63,'2025_11_12_134441_add_order_to_item_types',1),
(64,'2025_12_22_113824_update_add_options_to_tenants',1),
(65,'2025_12_24_134629_create_site_maps_table',1),
(66,'2025_12_24_135529_update_add_site_url_to_tenants',1),
(67,'2025_12_24_142018_update_options_in_tenants',1),
(68,'2025_12_24_144457_update_type_to_ais',1),
(69,'2026_01_11_102040_create_payment_methods_table',1),
(70,'2026_01_11_121716_create_coupons_table',1),
(71,'2026_01_11_121745_create_coupon_items_table',1),
(72,'2026_01_11_153123_create_orders_table',1),
(73,'2026_01_11_153133_create_order_items_table',1),
(74,'2026_01_12_162525_update_options_in_tenants',1),
(75,'2026_01_14_133639_update_options_in_tenants',1),
(76,'2026_01_23_162332_update_items',1),
(77,'2026_01_23_172821_create_register_users_table',1),
(78,'2026_01_23_211828_update_options_in_tenants',1),
(79,'2026_01_24_173237_update_options_in_residency_users',1),
(80,'2026_01_24_191919_update_options_in_orders',1),
(81,'2026_01_25_013724_create_payment_links_table',1),
(82,'2026_01_25_143244_create_item_residency_users_table',1),
(83,'2026_01_26_113823_update_add_type_to_galleries',1),
(84,'2026_01_26_160516_update_payment_links',1),
(85,'2026_01_27_113711_update_add_user_id_to_orders',1),
(86,'2026_01_28_120823_add_fr_and_de_columns_to_tables',1),
(87,'2026_01_31_130607_add_note_to_payment_links',1),
(88,'2026_02_01_113029_create_item_packages_table',1),
(89,'2026_02_01_142839_add_package_id_to_item_residency_users_table',1),
(90,'2026_02_03_113243_create_folders_table',1),
(91,'2026_02_03_114254_change_galleries_columns_nullable',1),
(92,'2026_02_04_132643_change_lead_magnet_types_columns_nullable',1),
(93,'2026_02_04_133350_change_lead_magnets_columns_nullable',1),
(94,'2025_10_05_085942_create_countries_table',2),
(95,'2025_10_05_085950_create_states_table',2),
(96,'2025_10_05_090007_create_cities_table',2),
(97,'2026_03_11_140848_add_journey_details_to_items_table',2),
(98,'2026_03_11_140848_create_item_itineraries_table',2),
(99,'2026_03_11_162122_add_stars_to_testimonials_table',2),
(100,'2026_03_12_140050_create_packages_table',3),
(101,'2026_03_12_175600_add_hijri_dates_to_items_table',3),
(102,'2026_03_13_140730_add_package_id_to_residency_users_table',4),
(103,'2026_03_13_172520_add_fcm_token_to_users_tables',5),
(104,'2026_03_13_221629_create_notification_templates_table',6),
(105,'2026_03_15_161121_add_parent_id_to_item_types_table',7),
(106,'2026_03_15_163712_add_discount_and_stock_to_items_table',7),
(107,'2026_03_16_002650_add_used_points_to_orders_table',8),
(108,'2026_03_22_141611_make_foreign_keys_nullable_in_states_and_cities',9),
(109,'2026_03_22_144306_add_country_id_to_event_galleries_table',9),
(110,'2026_03_22_153520_create_roles_table',9),
(111,'2026_03_25_153433_add_user_id_to_items_table',10),
(112,'2026_04_17_204010_add_map_to_item_itineraries_table',11),
(113,'2026_04_17_204010_create_item_routes_table',11),
(114,'2026_04_18_210607_create_item_prices_table',12),
(115,'2026_04_18_223622_add_variation_columns_to_order_items_table',12),
(116,'2026_04_20_194941_create_item_excludes_table',13),
(117,'2026_04_22_181044_create_item_itinerary_places_table',14),
(118,'2026_04_23_170057_add_order_to_routes_and_excludes_tables',15);
/*!40000 ALTER TABLE `migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `news`
--

DROP TABLE IF EXISTS `news`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `news` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `title_ar` varchar(191) DEFAULT NULL,
  `title_en` varchar(191) DEFAULT NULL,
  `title_de` varchar(191) DEFAULT NULL,
  `title_fr` varchar(191) DEFAULT NULL,
  `slug_en` varchar(191) DEFAULT NULL,
  `slug_de` varchar(191) DEFAULT NULL,
  `slug_fr` varchar(191) DEFAULT NULL,
  `slug_ar` varchar(191) DEFAULT NULL,
  `link` varchar(191) DEFAULT NULL,
  `type` enum('locales','international') DEFAULT NULL,
  `is_feature` tinyint(4) NOT NULL DEFAULT 0,
  `short_description_ar` text DEFAULT NULL,
  `short_description_en` text DEFAULT NULL,
  `short_description_de` text DEFAULT NULL,
  `short_description_fr` text DEFAULT NULL,
  `description_ar` longtext DEFAULT NULL,
  `description_en` longtext DEFAULT NULL,
  `description_de` longtext DEFAULT NULL,
  `description_fr` longtext DEFAULT NULL,
  `banner_en` text DEFAULT NULL,
  `banner_de` varchar(191) DEFAULT NULL,
  `banner_fr` varchar(191) DEFAULT NULL,
  `banner_ar` text DEFAULT NULL,
  `meta_title_ar` varchar(191) DEFAULT NULL,
  `meta_title_en` varchar(191) DEFAULT NULL,
  `meta_title_de` varchar(191) DEFAULT NULL,
  `meta_title_fr` varchar(191) DEFAULT NULL,
  `meta_img` text DEFAULT NULL,
  `meta_description_ar` text DEFAULT NULL,
  `meta_description_en` text DEFAULT NULL,
  `meta_description_de` text DEFAULT NULL,
  `meta_description_fr` text DEFAULT NULL,
  `meta_keywords_ar` text DEFAULT NULL,
  `meta_keywords_en` text DEFAULT NULL,
  `meta_keywords_de` text DEFAULT NULL,
  `meta_keywords_fr` text DEFAULT NULL,
  `status` tinyint(4) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `order` varchar(191) DEFAULT '0',
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `news`
--

LOCK TABLES `news` WRITE;
/*!40000 ALTER TABLE `news` DISABLE KEYS */;
/*!40000 ALTER TABLE `news` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notification_templates`
--

DROP TABLE IF EXISTS `notification_templates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `notification_templates` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(191) NOT NULL,
  `body` text NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notification_templates`
--

LOCK TABLES `notification_templates` WRITE;
/*!40000 ALTER TABLE `notification_templates` DISABLE KEYS */;
INSERT INTO `notification_templates` VALUES
(1,'🌟 New Trip Alert: {trip_name} is Here!','Exciting news! We just added {trip_name} to our catalog. Book your spot now before it sells out.','2026-04-18 20:40:46','2026-04-18 20:40:46'),
(2,'🔥 Special Offer on {trip_name}!','Don\'t miss out on this amazing deal! {trip_name} is now available at a discounted rate for a limited time.','2026-04-18 20:40:46','2026-04-18 20:40:46'),
(3,'⏳ Last Chance to Book {trip_name}!','Spots are filling up fast for {trip_name}. Secure your booking today and get ready for an unforgettable experience.','2026-04-18 20:40:46','2026-04-18 20:40:46'),
(4,'🎒 Ready for an adventure? Join {trip_name}!','Pack your bags! {trip_name} is exactly what you need for your next getaway. Discover the details inside.','2026-04-18 20:40:46','2026-04-18 20:40:46'),
(5,'🌟 رحلة جديدة في انتظارك: {trip_name}!','خبر سعيد! لقد أضفنا رحلة {trip_name} إلى قائمتنا. احجز مكانك الآن قبل نفاد التذاكر.','2026-04-18 20:40:46','2026-04-18 20:40:46'),
(6,'🔥 عرض خاص ومميز على رحلة {trip_name}!','لا تفوت هذه الفرصة الرائعة! رحلة {trip_name} متاحة الآن بسعر مخفض لفترة محدودة.','2026-04-18 20:40:46','2026-04-18 20:40:46'),
(7,'⏳ الفرصة الأخيرة للانضمام إلى {trip_name}!','الأماكن تقترب من النفاد في رحلة {trip_name}. احجز مقعدك اليوم واستعد لتجربة لا تُنسى.','2026-04-18 20:40:46','2026-04-18 20:40:46'),
(8,'🎒 هل أنت مستعد للمغامرة؟ انضم إلى {trip_name}!','جهز حقائبك! رحلة {trip_name} هي ما تحتاجه لإجازتك القادمة. اكتشف التفاصيل الآن واحجز مكانك.','2026-04-18 20:40:46','2026-04-18 20:40:46');
/*!40000 ALTER TABLE `notification_templates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `offers`
--

DROP TABLE IF EXISTS `offers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `offers` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `type_offer_id` bigint(20) unsigned NOT NULL,
  `title_en` text DEFAULT NULL,
  `title_de` varchar(191) DEFAULT NULL,
  `title_fr` varchar(191) DEFAULT NULL,
  `title_ar` text DEFAULT NULL,
  `banner_en` varchar(191) DEFAULT NULL,
  `banner_de` varchar(191) DEFAULT NULL,
  `banner_fr` varchar(191) DEFAULT NULL,
  `banner_ar` varchar(191) DEFAULT NULL,
  `price` decimal(10,2) NOT NULL DEFAULT 0.00,
  `status` tinyint(4) NOT NULL DEFAULT 0,
  `meta_title_ar` varchar(191) DEFAULT NULL,
  `meta_title_en` varchar(191) DEFAULT NULL,
  `meta_title_de` varchar(191) DEFAULT NULL,
  `meta_title_fr` varchar(191) DEFAULT NULL,
  `meta_img` text DEFAULT NULL,
  `meta_description_ar` text DEFAULT NULL,
  `meta_description_en` text DEFAULT NULL,
  `meta_description_de` text DEFAULT NULL,
  `meta_description_fr` text DEFAULT NULL,
  `meta_keywords_ar` text DEFAULT NULL,
  `meta_keywords_en` text DEFAULT NULL,
  `meta_keywords_de` text DEFAULT NULL,
  `meta_keywords_fr` text DEFAULT NULL,
  `slug_en` varchar(191) DEFAULT NULL,
  `slug_de` varchar(191) DEFAULT NULL,
  `slug_fr` varchar(191) DEFAULT NULL,
  `slug_ar` varchar(191) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `is_feature` tinyint(4) NOT NULL DEFAULT 0,
  `order` varchar(191) DEFAULT '0',
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `offers_type_offer_id_foreign` (`type_offer_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `offers`
--

LOCK TABLES `offers` WRITE;
/*!40000 ALTER TABLE `offers` DISABLE KEYS */;
/*!40000 ALTER TABLE `offers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_items`
--

DROP TABLE IF EXISTS `order_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_items` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `order_id` bigint(20) unsigned NOT NULL,
  `item_id` bigint(20) unsigned DEFAULT NULL,
  `item_package_id` bigint(20) unsigned DEFAULT NULL,
  `attendees_count` int(11) NOT NULL DEFAULT 1,
  `price_per_unit` decimal(10,2) NOT NULL,
  `total` decimal(10,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `item_price_id` bigint(20) unsigned DEFAULT NULL,
  `variation_title_ar` varchar(191) DEFAULT NULL,
  `variation_title_en` varchar(191) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `order_items_order_id_foreign` (`order_id`),
  KEY `order_items_item_id_foreign` (`item_id`),
  KEY `order_items_item_price_id_foreign` (`item_price_id`)
) ENGINE=MyISAM AUTO_INCREMENT=48 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_items`
--

LOCK TABLES `order_items` WRITE;
/*!40000 ALTER TABLE `order_items` DISABLE KEYS */;
INSERT INTO `order_items` VALUES
(1,1,4,NULL,1,2000.00,2000.00,'2026-03-13 23:30:02','2026-03-13 23:30:02',NULL,NULL,NULL,NULL),
(2,2,1,NULL,1,1500.00,1500.00,'2026-03-14 04:25:48','2026-03-14 04:25:48',NULL,NULL,NULL,NULL),
(3,3,2,NULL,1,6000.00,6000.00,'2026-03-14 04:27:44','2026-03-14 04:27:44',NULL,NULL,NULL,NULL),
(4,4,4,NULL,1,2000.00,2000.00,'2026-03-14 04:29:48','2026-03-14 04:29:48',NULL,NULL,NULL,NULL),
(5,5,4,NULL,1,2000.00,2000.00,'2026-03-14 04:30:24','2026-03-14 04:30:24',NULL,NULL,NULL,NULL),
(6,6,4,NULL,1,2000.00,2000.00,'2026-03-14 04:31:02','2026-03-14 04:31:02',NULL,NULL,NULL,NULL),
(7,7,2,NULL,1,6000.00,6000.00,'2026-03-14 04:35:23','2026-03-14 04:35:23',NULL,NULL,NULL,NULL),
(8,8,3,NULL,1,6000.00,6000.00,'2026-03-14 04:37:13','2026-03-14 04:37:13',NULL,NULL,NULL,NULL),
(9,9,2,NULL,1,6000.00,6000.00,'2026-03-14 04:40:08','2026-03-14 04:40:08',NULL,NULL,NULL,NULL),
(10,10,2,NULL,1,6000.00,6000.00,'2026-03-14 04:40:35','2026-03-14 04:40:35',NULL,NULL,NULL,NULL),
(11,11,2,NULL,1,6000.00,6000.00,'2026-03-14 04:42:59','2026-03-14 04:42:59',NULL,NULL,NULL,NULL),
(12,12,2,NULL,1,6000.00,6000.00,'2026-03-14 04:43:21','2026-03-14 04:43:21',NULL,NULL,NULL,NULL),
(13,13,2,NULL,1,6000.00,6000.00,'2026-03-14 04:43:57','2026-03-14 04:43:57',NULL,NULL,NULL,NULL),
(14,14,1,NULL,1,1500.00,1500.00,'2026-03-14 04:54:57','2026-03-14 04:54:57',NULL,NULL,NULL,NULL),
(15,15,3,NULL,1,6000.00,6000.00,'2026-03-14 06:55:15','2026-03-14 06:55:15',NULL,NULL,NULL,NULL),
(16,16,3,NULL,1,6000.00,6000.00,'2026-03-14 19:26:39','2026-03-14 19:26:39',NULL,NULL,NULL,NULL),
(17,17,4,NULL,1,2000.00,2000.00,'2026-03-15 15:38:15','2026-03-15 15:38:15',NULL,NULL,NULL,NULL),
(18,18,4,NULL,1,2000.00,2000.00,'2026-03-15 16:41:23','2026-03-15 16:41:23',NULL,NULL,NULL,NULL),
(19,19,1,NULL,1,1500.00,1500.00,'2026-03-15 21:59:18','2026-03-15 21:59:18',NULL,NULL,NULL,NULL),
(20,20,4,NULL,1,2000.00,2000.00,'2026-03-15 21:59:19','2026-03-15 21:59:19',NULL,NULL,NULL,NULL),
(21,21,4,NULL,1,2000.00,2000.00,'2026-03-15 21:59:33','2026-03-15 21:59:33',NULL,NULL,NULL,NULL),
(22,22,4,NULL,1,2000.00,2000.00,'2026-03-15 22:57:18','2026-03-15 22:57:18',NULL,NULL,NULL,NULL),
(23,23,4,NULL,1,2000.00,2000.00,'2026-03-16 03:49:35','2026-03-16 03:49:35',NULL,NULL,NULL,NULL),
(24,24,3,NULL,1,1000.00,1000.00,'2026-03-16 06:14:33','2026-03-16 06:14:33',NULL,NULL,NULL,NULL),
(25,25,3,NULL,1,1000.00,1000.00,'2026-03-16 06:29:17','2026-03-16 06:29:17',NULL,NULL,NULL,NULL),
(26,26,3,NULL,1,1000.00,1000.00,'2026-03-16 06:30:17','2026-03-16 06:30:17',NULL,NULL,NULL,NULL),
(27,27,1,NULL,1,1500.00,1500.00,'2026-03-16 06:36:26','2026-03-16 06:36:26',NULL,NULL,NULL,NULL),
(28,28,3,NULL,1,1000.00,1000.00,'2026-03-16 09:21:03','2026-03-16 09:21:03',NULL,NULL,NULL,NULL),
(29,29,5,NULL,1,1000.00,1000.00,'2026-03-16 14:34:03','2026-03-16 14:34:03',NULL,NULL,NULL,NULL),
(30,30,5,NULL,1,1000.00,1000.00,'2026-03-16 14:47:25','2026-03-16 14:47:25',NULL,NULL,NULL,NULL),
(31,31,6,NULL,1,1000.00,1000.00,'2026-03-25 21:59:21','2026-03-25 21:59:21',NULL,NULL,NULL,NULL),
(32,32,1,NULL,1,5500.00,5500.00,'2026-04-05 19:28:55','2026-04-05 19:28:55',NULL,NULL,NULL,NULL),
(33,33,3,NULL,1,6000.00,6000.00,'2026-04-06 15:29:05','2026-04-06 15:29:05',NULL,NULL,NULL,NULL),
(34,34,4,NULL,1,2000.00,2000.00,'2026-04-15 14:12:43','2026-04-15 14:12:43',NULL,NULL,NULL,NULL),
(35,35,3,NULL,3,6000.00,18000.00,'2026-04-15 16:00:13','2026-04-15 16:00:13',NULL,NULL,NULL,NULL),
(36,36,3,NULL,1,500.00,500.00,'2026-04-19 18:19:01','2026-04-19 18:19:01',NULL,1,'سعر الشخص بالغرفة المفردة','Single Room Person Price'),
(37,36,3,NULL,1,1000.00,1000.00,'2026-04-19 18:19:01','2026-04-19 18:19:01',NULL,2,'سعر الشخص بالغرفة المزدوجة','Double Room Person Price'),
(38,36,3,NULL,1,1000.00,1000.00,'2026-04-19 18:19:01','2026-04-19 18:19:01',NULL,3,'سعر الشخص بالغرفة الثلاثية','Triple Room Person Price'),
(39,37,6,NULL,2,6700.00,13400.00,'2026-04-21 21:19:17','2026-04-21 21:19:17',NULL,21,'سعر الشخص بالغرفة المزدوجة','Double Room Person Price'),
(40,37,6,NULL,1,7700.00,7700.00,'2026-04-21 21:19:17','2026-04-21 21:19:17',NULL,20,'سعر الشخص بالغرفة المفردة','Single Room Person Price'),
(41,38,1,NULL,2,4900.00,9800.00,'2026-04-21 22:03:47','2026-04-21 22:03:47',NULL,23,'سعر الشخص بالغرفة المزدوجة','Double Room Person Price'),
(42,38,1,NULL,1,5900.00,5900.00,'2026-04-21 22:03:47','2026-04-21 22:03:47',NULL,22,'سعر الشخص بالغرفة المفردة','Single Room Person Price'),
(43,39,6,NULL,1,7700.00,7700.00,'2026-04-23 14:10:36','2026-04-23 14:10:36',NULL,32,'سعر الشخص بالغرفة المفردة','Single Room Person Price'),
(44,39,6,NULL,1,6700.00,6700.00,'2026-04-23 14:10:36','2026-04-23 14:10:36',NULL,33,'سعر الشخص بالغرفة المزدوجة','Double Room Person Price'),
(45,40,6,NULL,1,6700.00,6700.00,'2026-04-24 08:49:09','2026-04-24 08:49:09',NULL,65,'سعر الشخص بالغرفة المزدوجة','Double Room Person Price'),
(46,42,1,NULL,1,5900.00,5900.00,'2026-04-26 03:28:43','2026-04-26 03:28:43',NULL,76,'سعر الشخص بالغرفة المفردة','Single Room Person Price'),
(47,43,1,NULL,1,5900.00,5900.00,'2026-04-26 03:31:10','2026-04-26 03:31:10',NULL,76,'سعر الشخص بالغرفة المفردة','Single Room Person Price');
/*!40000 ALTER TABLE `order_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(191) NOT NULL,
  `email` varchar(191) NOT NULL,
  `phone` varchar(191) NOT NULL,
  `sub_total` decimal(10,2) NOT NULL,
  `discount_amount` decimal(10,2) NOT NULL DEFAULT 0.00,
  `used_points` int(11) NOT NULL DEFAULT 0,
  `total_amount` decimal(10,2) NOT NULL,
  `coupon_id` bigint(20) unsigned DEFAULT NULL,
  `payment_method` varchar(191) NOT NULL,
  `payment_status` enum('pending','paid','reviewing','rejected','canceled') NOT NULL DEFAULT 'pending',
  `transaction_token` varchar(191) DEFAULT NULL,
  `payment_proof` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `specialty` varchar(191) DEFAULT NULL,
  `country` varchar(191) DEFAULT NULL,
  `residency_user_id` bigint(20) unsigned DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `orders_coupon_id_foreign` (`coupon_id`),
  KEY `orders_residency_user_id_foreign` (`residency_user_id`)
) ENGINE=MyISAM AUTO_INCREMENT=46 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES
(1,'Ahmed Ali','ahmed@test.com','01010235689',2000.00,0.00,0,2000.00,NULL,'bank_transfer_alrajhi','pending','9mmWYi5K9B5c0HPcBQ9ykR4I3BlLi30sg5R0JMJV',NULL,'2026-03-13 23:30:02','2026-03-13 23:30:02',NULL,NULL,7,NULL),
(2,'Mohamed Abdel azeem','123medoabdo@gmail.com','01028768312',1500.00,0.00,0,1500.00,NULL,'bank_transfer_alahli','reviewing','KIe3wid9yh8Ewi01cCMG6cO5DTrlnvuPeEiXOtCN','uploads/tenant_1/payment-proofs/69b48eff85073_1773440767_receipt.jpg','2026-03-14 04:25:48','2026-03-14 04:26:07',NULL,NULL,5,NULL),
(3,'Mohamed Abdel azeem','123medoabdo@gmail.com','01028768312',6000.00,0.00,0,6000.00,NULL,'tamara','pending','CkjDTjvWPXygyrq4v5Wngei87E8F1diO6JyZsn30',NULL,'2026-03-14 04:27:44','2026-03-14 04:27:44',NULL,NULL,5,NULL),
(4,'Ahmed Ali','ahmed@test.com','01010235689',2000.00,0.00,0,2000.00,NULL,'tamara','pending','LgbJh1WsYBKNXkNxKXJBwhLjKtlqgcoYl7knK6D1',NULL,'2026-03-14 04:29:48','2026-03-14 04:29:48',NULL,NULL,7,NULL),
(5,'Ahmed Ali','ahmed@test.com','01010235689',2000.00,0.00,0,2000.00,NULL,'tamara','pending','HuGrpUWuXAbcnPayL79hilkSRKheuHG3KHnnqjxD',NULL,'2026-03-14 04:30:24','2026-03-14 04:30:24',NULL,NULL,7,NULL),
(6,'Ahmed Ali','ahmed@test.com','01010235689',2000.00,0.00,0,2000.00,NULL,'tamara','pending','nsm23k1DmOjuRI565bU6KWGi4zZoUYYYkVEEUXYU',NULL,'2026-03-14 04:31:02','2026-03-14 04:31:02',NULL,NULL,7,NULL),
(7,'Mohamed Abdel azeem','123medoabdo@gmail.com','01028768312',6000.00,0.00,0,6000.00,NULL,'bank_transfer_alahli','reviewing','j0qNbSpUcT6on4ALTpdXtjV5RcL4MvNONCayrw2o','uploads/tenant_1/payment-proofs/69b49133a3cb1_1773441331_receipt.webp','2026-03-14 04:35:23','2026-03-14 04:35:31',NULL,NULL,5,NULL),
(8,'Mohamed Abdel azeem','123medoabdo@gmail.com','01028768312',6000.00,0.00,0,6000.00,NULL,'bank_transfer_alahli','reviewing','OzJF9E7yqgt6YueeSg4tXopiVh5ZyHGZaKgUIyRL','uploads/tenant_1/payment-proofs/69b491a0a9be8_1773441440_receipt.webp','2026-03-14 04:37:13','2026-03-14 04:37:20',NULL,NULL,5,NULL),
(9,'Mohamed Abdel azeem','123medoabdo@gmail.com','01028768312',6000.00,0.00,0,6000.00,NULL,'bank_transfer_alahli','pending','PNm1z2poI9YraGHAKUBKXCOJXmpo8LA93FJhZtSr',NULL,'2026-03-14 04:40:08','2026-03-14 04:40:08',NULL,NULL,5,NULL),
(10,'Mohamed Abdel azeem','123medoabdo@gmail.com','01028768312',6000.00,0.00,0,6000.00,NULL,'bank_transfer_alrajhi','pending','rG7W7eOHbv1pdhh8i75A9dLJcsrjyrg2gv0bJ7tD',NULL,'2026-03-14 04:40:35','2026-03-14 04:40:35',NULL,NULL,5,NULL),
(11,'Mohamed Abdel azeem','123medoabdo@gmail.com','01028768312',6000.00,0.00,0,6000.00,NULL,'bank_transfer_alrajhi','pending','KsEelSmXvKZhFeVrkuw19aaZblcVMdwk9jD5e61L',NULL,'2026-03-14 04:42:59','2026-03-14 04:42:59',NULL,NULL,5,NULL),
(12,'Mohamed Abdel azeem','123medoabdo@gmail.com','01028768312',6000.00,0.00,0,6000.00,NULL,'bank_transfer_alrajhi','pending','v9HTID0yqCQE21bfcY6WHcqP7PbyO6jWxqtHDpRz',NULL,'2026-03-14 04:43:21','2026-03-14 04:43:21',NULL,NULL,5,NULL),
(13,'Mohamed Abdel azeem','123medoabdo@gmail.com','01028768312',6000.00,0.00,0,6000.00,NULL,'bank_transfer_alrajhi','pending','ZEhcrwBCEhY1lKgqTb92BMsjQvpSvO1uiU5yqbbD',NULL,'2026-03-14 04:43:57','2026-03-14 04:43:57',NULL,NULL,5,NULL),
(14,'Mohamed Abdel azeem','123medoabdo@gmail.com','01028768312',1500.00,0.00,0,1500.00,NULL,'bank_transfer_alahli','reviewing','K9ulrAOIP2MlX5bpXUBiDVSMS3UFYNdgy5TVyCCm','uploads/tenant_1/payment-proofs/69b495d4a79d9_1773442516_receipt.jpg','2026-03-14 04:54:57','2026-03-14 04:55:16',NULL,NULL,5,NULL),
(15,'Mohamed Abdel azeem','123medoabdo@gmail.com','01028768312',6000.00,0.00,0,6000.00,NULL,'bank_transfer_alahli','reviewing','cNqVvs9VPJJoAt87eUG3r4opzqITAL466SrxmCBf','uploads/tenant_1/payment-proofs/69b4b21ecf949_1773449758_receipt.jpg','2026-03-14 06:55:15','2026-03-14 06:55:58',NULL,NULL,5,NULL),
(16,'Mohamed Abdel azeem','123medoabdo@gmail.com','01028768312',6000.00,0.00,0,6000.00,NULL,'bank_transfer_alahli','paid','CrbgdFGNFSzDWkEIMEGPVoXH7ZuSXoA2YBoXZzG7','uploads/tenant_1/payment-proofs/69b5621706170_1773494807_receipt.webp','2026-03-14 19:26:39','2026-03-14 19:38:24',NULL,NULL,5,NULL),
(17,'تو','tawheedkortam1@gmail.com','01027582666',2000.00,0.00,0,2000.00,NULL,'bank_transfer_alahli','pending','QOJuetBoYHe3wq10XqbJwMLzAM7NdgurzhIJWb99',NULL,'2026-03-15 15:38:15','2026-03-15 15:38:15',NULL,NULL,1,NULL),
(18,'ta','tawheedkortam1@gmail.com','01027582666',2000.00,0.00,0,2000.00,NULL,'tamara','pending','NcpXA180ACln3ENyRJphX4rgFJkQdxDru0BF8qi3',NULL,'2026-03-15 16:41:23','2026-03-15 16:41:23',NULL,NULL,1,NULL),
(19,'اي','tawheedkortam1@gmail.com','01027582666',1500.00,0.00,0,1500.00,NULL,'bank_transfer_alahli','reviewing','tfYIN3NGrYKtZvEzvnPwzl4ZhA4MUe3pCXlHPbFq','uploads/tenant_1/payment-proofs/69b6d78914c93_1773590409_receipt.jpg','2026-03-15 21:59:18','2026-03-15 22:00:09',NULL,NULL,1,NULL),
(20,'مدحت','medhat.kortam@gmail.com','0543125788',2000.00,0.00,0,2000.00,NULL,'bank_transfer_alahli','pending','MwIoE1NpH8pNC5O3eXE0gGjYjqhyQw7MsdKJ52iS',NULL,'2026-03-15 21:59:19','2026-03-15 21:59:19',NULL,NULL,8,NULL),
(21,'مدحت','medhat.kortam@gmail.com','0543125788',2000.00,0.00,0,2000.00,NULL,'bank_transfer_alahli','pending','RXFtuDQ2dNHV7GO1mZEed57E14X3U5PAGIMUqGc4',NULL,'2026-03-15 21:59:33','2026-03-15 21:59:33',NULL,NULL,8,NULL),
(22,'mo saeed','mo@gmail.com','01092338086',2000.00,0.00,0,2000.00,NULL,'bank_transfer_alahli','pending','SZDjvsQrqoStRiS20rPunBhtWRD8y9DvfVFY5KWW',NULL,'2026-03-15 22:57:17','2026-03-15 22:57:18',NULL,NULL,9,NULL),
(23,'mo saeed','mohamedsaeed00451@gmail.com','01010235689',2000.00,0.00,0,2000.00,NULL,'tamara','pending','HE4HkdGAwLFDWwB7aCbNJiN8rGl0fFEv4zqzuhw1',NULL,'2026-03-16 03:49:35','2026-03-16 03:49:35',NULL,NULL,2,NULL),
(24,'Mohamed Abdel azeem','123medoabdo@gmail.com','01028768312',1000.00,0.00,0,1000.00,NULL,'bank_transfer_alahli','pending','CJWKDRE2aaJU2kgioRuywplnsTKEZSDKCYHfT06A',NULL,'2026-03-16 06:14:33','2026-03-16 06:14:33',NULL,NULL,5,NULL),
(25,'Mohamed Abdel azeem','123medoabdo@gmail.com','01028768312',1000.00,9.90,99,990.10,NULL,'bank_transfer_alahli','reviewing','xEY0NMLJXOs4nDo2gNWPyRxTVoERKX3CgpZRNGhX','uploads/tenant_1/payment-proofs/69b74eeb2b9c6_1773620971_receipt.webp','2026-03-16 06:29:17','2026-03-16 06:29:31',NULL,NULL,5,NULL),
(26,'Mohamed Abdel azeem','123medoabdo@gmail.com','01028768312',1000.00,0.00,0,1000.00,NULL,'tamara','pending','ksgL751ziIWIV6cyDFygEXjI3ApwCAJijAvryv6h',NULL,'2026-03-16 06:30:17','2026-03-16 06:30:17',NULL,NULL,5,NULL),
(27,'Mohamed Abdel azeem','123medoabdo@gmail.com','01028768312',1500.00,0.00,0,1500.00,NULL,'tamara','pending','poCTxmHYhcc94R3u2wx9R1IJMVGWJ21O3sguKOPE',NULL,'2026-03-16 06:36:25','2026-03-16 06:36:26',NULL,NULL,5,NULL),
(28,'Mohamed Abdel azeem','123medoabdo@gmail.com','01028768312',1000.00,0.00,0,1000.00,NULL,'tamara','pending','jgi3xWvzwUv9vceXGByqtvNnlGwQGPFdV5twOcAn',NULL,'2026-03-16 09:20:57','2026-03-16 09:21:03',NULL,NULL,5,NULL),
(29,'ta','tawheedkortam1@gmail.com','01027582666',1000.00,0.00,0,1000.00,NULL,'bank_transfer_alahli','pending','gZC6hNLwyNcxQTvjQTC91vvXTDuqzb9chMDjUz1p',NULL,'2026-03-16 14:34:02','2026-03-16 14:34:03',NULL,NULL,1,NULL),
(30,'ta','tawheedkortam1@gmail.com','01027582666',1000.00,0.00,0,1000.00,NULL,'bank_transfer_alahli','pending','1tZYrdEWSdTrVm73kkOKG6IpKDNrj2CFCmc61YPp',NULL,'2026-03-16 14:47:22','2026-03-16 14:47:25',NULL,NULL,1,NULL),
(31,'Mohamed Abdel azeem','123medoabdo@gmail.com','01028768312',1000.00,0.00,0,1000.00,NULL,'bank_transfer_alahli','paid','B0WwZDCVt4vBSRkgggg0n3UNyg11hs6YpdWjd8r5','uploads/tenant_1/payment-proofs/69c406627932b_1774454370_receipt.jpg','2026-03-25 21:59:21','2026-03-25 22:00:53',NULL,NULL,5,NULL),
(32,'Medhat Kortam','medhat.kortam@gmail.com','01008144777',5500.00,0.00,0,5500.00,NULL,'bank_transfer_alahli','pending','XVdsGEPvHcTa9cSe85UVB6NDbAhD0yf0t4f4niB9',NULL,'2026-04-05 19:28:55','2026-04-05 19:28:55',NULL,NULL,8,NULL),
(33,'Mohamed Abdel azeem','123medoabdo@gmail.com','01028768312',6000.00,0.00,0,6000.00,NULL,'bank_transfer_alahli','pending','fA08uWRnD9KMVHTAoymgTXGlc8QazgeegSWbJJTN',NULL,'2026-04-06 15:29:05','2026-04-06 15:29:05',NULL,NULL,5,NULL),
(34,'Mohamed Abdel azeem','123medoabdo@gmail.com','01028768312',2000.00,90.00,900,1910.00,NULL,'bank_transfer_alahli','reviewing','oaxEeqPsTw1PhdyavkmOTHx0GMrRkDKfEYpRCNIv','uploads/tenant_1/payment-proofs/69df488b0cd46_1776240779_receipt.jpg','2026-04-15 14:12:43','2026-04-15 14:12:59',NULL,NULL,5,NULL),
(35,'Mohamed Abdel azeem','123medoabdo@gmail.com','01028768312',18000.00,0.00,0,18000.00,NULL,'bank_transfer_alahli','reviewing','nEwk1nrRsm710kmhtmDF1nutE66Fit3vwVGCsr24','uploads/tenant_1/payment-proofs/69df61b8175a4_1776247224_receipt.png','2026-04-15 16:00:13','2026-04-15 16:00:24',NULL,NULL,5,NULL),
(36,'Mohamed Abdel azeem','123medoabdo@gmail.com','01028768312',2500.00,0.00,0,2500.00,NULL,'bank_transfer_alahli','reviewing','kSbGfL8wFwYyxob3wMrCugFLTDqrSJBntakIBuc0','uploads/tenant_1/payment-proofs/69e4c845e4485_1776601157_receipt.webp','2026-04-19 18:19:01','2026-04-19 18:19:18',NULL,NULL,5,NULL),
(37,'medhat','medhat.kortam@gmail.com','051234567',21100.00,0.00,0,21100.00,NULL,'bank_transfer_alahli','reviewing','i9OOXtviGhUxQqExMj39gotapnybR2F8RQsa4n9V','uploads/tenant_1/payment-proofs/69e795947ccb5_1776784788_receipt.jpg','2026-04-21 21:19:17','2026-04-21 21:19:48',NULL,NULL,8,NULL),
(38,'medhat','medhat.kortam@gmail.com','051234567',15700.00,0.00,0,15700.00,NULL,'bank_transfer_alahli','reviewing','d82iNgMQxTBbkA3B03sFrCvWCGbbcJf4uSDlloNq','uploads/tenant_1/payment-proofs/69e7a006d3c18_1776787462_receipt.jpeg','2026-04-21 22:03:47','2026-04-21 22:04:22',NULL,NULL,8,NULL),
(39,'Tawheed Kortam','tawheedkortam1@gmail.com','010 27582666',14400.00,0.00,0,14400.00,NULL,'bank_transfer_alahli','pending','XSWqvD0F2azeto62PuBCtGUozgFt9nl6UwEe5QyE',NULL,'2026-04-23 14:10:36','2026-04-23 14:10:36',NULL,NULL,1,NULL),
(40,'Mohamed Abdel azeem','123medoabdo@gmail.com','01028768312',6700.00,0.00,0,6700.00,NULL,'bank_transfer_alahli','reviewing','nIus7Yx2bWW0veWrz1Cb05lBbAsGjCFXuf8BEDlF','uploads/tenant_1/payment-proofs/69eacc29abee4_1776995369_receipt.jpg','2026-04-24 08:49:09','2026-04-24 08:49:29',NULL,NULL,5,NULL),
(41,'mo saeed','mohamedsaeed00451@gmail.com','01010235689',0.00,0.00,0,0.00,NULL,'bank_transfer_alrajhi','pending','4XD0HajJOk9VK4uvKvbF5zkM2biKSqVlP0FH8i58',NULL,'2026-04-25 21:13:42','2026-04-25 21:13:42',NULL,NULL,2,NULL),
(42,'علي','tawheedkortam1@gmail.com','01027582666',5900.00,0.00,0,5900.00,NULL,'tamara','pending','iCodVWVMZaMlitAJ3F4SrLNyMJgFTNUnwR7VJwxt',NULL,'2026-04-26 03:28:43','2026-04-26 03:28:43',NULL,NULL,1,NULL),
(43,'علي','tawheedkortam1@gmail.com','01027582666',5900.00,0.00,0,5900.00,NULL,'tamara','pending','H3kWIXDZ627FtTodJbYwQ5a4c4Iyi5mc5WaoDpNV',NULL,'2026-04-26 03:31:10','2026-04-26 03:31:10',NULL,NULL,1,NULL),
(44,'mo saeed','mohamedsaeed00451@gmail.com','01010235689',0.00,0.00,0,0.00,NULL,'bank_transfer_alrajhi','pending','trHdorQqXc4aSra5Mmatbw6Y21XZNHpEvl0FceuM',NULL,'2026-04-26 04:01:39','2026-04-26 04:01:39',NULL,NULL,2,NULL),
(45,'mo saeed','mohamedsaeed00451@gmail.com','01010235689',0.00,0.00,0,0.00,NULL,'bank_transfer_alrajhi','pending','PrJByUzBbBt5jxXQGKg4eHZLjpwJ8yWG3AvySMOF',NULL,'2026-04-26 20:57:49','2026-04-26 20:57:49',NULL,NULL,2,NULL);
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `packages`
--

DROP TABLE IF EXISTS `packages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `packages` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name_ar` varchar(191) DEFAULT NULL,
  `name_en` varchar(191) DEFAULT NULL,
  `price` decimal(10,2) NOT NULL DEFAULT 0.00,
  `features` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`features`)),
  `icon` varchar(191) DEFAULT NULL,
  `points_multiplier` decimal(5,2) NOT NULL DEFAULT 1.00,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `packages`
--

LOCK TABLES `packages` WRITE;
/*!40000 ALTER TABLE `packages` DISABLE KEYS */;
INSERT INTO `packages` VALUES
(21,'الفضية','Silver',0.00,'[{\"en\":\"Basic Support\",\"ar\":\"\\u062f\\u0639\\u0645 \\u0641\\u0646\\u064a \\u0623\\u0633\\u0627\\u0633\\u064a\"},{\"en\":\"Standard Points\",\"ar\":\"\\u0646\\u0642\\u0627\\u0637 \\u0642\\u064a\\u0627\\u0633\\u064a\\u0629\"}]','fas fa-medal',1.00,NULL,'2026-04-18 20:40:46','2026-04-18 20:40:46'),
(22,'الذهبية','Gold',100.00,'[{\"en\":\"Priority Support\",\"ar\":\"\\u062f\\u0639\\u0645 \\u0641\\u0646\\u064a \\u0628\\u0623\\u0648\\u0644\\u0648\\u064a\\u0629\"},{\"en\":\"1.5x Points Multiplier\",\"ar\":\"\\u0645\\u0636\\u0627\\u0639\\u0641\\u0629 \\u0627\\u0644\\u0646\\u0642\\u0627\\u0637 1.5x\"}]','fas fa-crown',1.50,NULL,'2026-04-18 20:40:46','2026-04-18 20:40:46'),
(23,'البلاتينية','Platinum',250.00,'[{\"en\":\"24\\/7 VIP Support\",\"ar\":\"\\u062f\\u0639\\u0645 VIP \\u0639\\u0644\\u0649 \\u0645\\u062f\\u0627\\u0631 \\u0627\\u0644\\u0633\\u0627\\u0639\\u0629\"},{\"en\":\"2x Points Multiplier\",\"ar\":\"\\u0645\\u0636\\u0627\\u0639\\u0641\\u0629 \\u0627\\u0644\\u0646\\u0642\\u0627\\u0637 2x\"}]','fas fa-gem',2.00,NULL,'2026-04-18 20:40:46','2026-04-18 20:40:46'),
(24,'الماسية','Diamond',500.00,'[{\"en\":\"Dedicated Account Manager\",\"ar\":\"\\u0645\\u062f\\u064a\\u0631 \\u062d\\u0633\\u0627\\u0628 \\u0645\\u062e\\u0635\\u0635\"},{\"en\":\"3x Points Multiplier\",\"ar\":\"\\u0645\\u0636\\u0627\\u0639\\u0641\\u0629 \\u0627\\u0644\\u0646\\u0642\\u0627\\u0637 3x\"}]','fas fa-trophy',3.00,NULL,'2026-04-18 20:40:46','2026-04-18 20:40:46');
/*!40000 ALTER TABLE `packages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `password_reset_codes`
--

DROP TABLE IF EXISTS `password_reset_codes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `password_reset_codes` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `email` varchar(191) NOT NULL,
  `code` varchar(191) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `password_reset_codes_email_index` (`email`)
) ENGINE=MyISAM AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `password_reset_codes`
--

LOCK TABLES `password_reset_codes` WRITE;
/*!40000 ALTER TABLE `password_reset_codes` DISABLE KEYS */;
INSERT INTO `password_reset_codes` VALUES
(1,'123medoabdo@gmail.com','282012','2026-03-14 04:12:31','2026-04-20 16:43:22'),
(2,'mohamedsaeed00451@gmail.com','990011','2026-03-16 04:15:23','2026-03-16 04:17:05'),
(3,'mohamedsaeed00451@gmail.com','178939','2026-03-16 04:17:05',NULL),
(4,'tawheedkortam1@gmail.com','125007','2026-03-16 04:34:15','2026-03-16 04:39:08'),
(5,'tawheedkortam1@gmail.com','496650','2026-03-16 04:39:08','2026-03-16 04:41:07'),
(6,'tawheedkortam1@gmail.com','605519','2026-03-16 04:41:07','2026-03-16 04:42:43'),
(7,'tawheedkortam1@gmail.com','514977','2026-03-16 04:42:43','2026-03-16 04:48:14'),
(8,'tawheedkortam1@gmail.com','154586','2026-03-16 04:48:14','2026-03-16 04:53:18'),
(9,'tawheedkortam1@gmail.com','199166','2026-03-16 04:53:18','2026-03-16 04:56:02'),
(10,'tawheedkortam1@gmail.com','488652','2026-03-16 04:56:03','2026-03-16 04:59:53'),
(11,'tawheedkortam1@gmail.com','586161','2026-03-16 04:59:54','2026-03-16 05:01:02'),
(12,'tawheedkortam1@gmail.com','959153','2026-03-16 05:01:55','2026-03-16 05:02:45'),
(13,'tawheedkortam1@gmail.com','102565','2026-03-16 13:37:48','2026-03-16 13:39:52'),
(14,'tawheedkortam1@gmail.com','610343','2026-03-16 13:50:29','2026-03-16 13:50:53'),
(15,'tawheedkortam1@gmail.com','591874','2026-03-16 13:52:42','2026-03-16 13:55:57'),
(16,'tawheedkortam1@gmail.com','294979','2026-03-16 13:55:57','2026-03-16 13:56:32'),
(17,'tawheedkortam1@gmail.com','282707','2026-03-16 13:59:19','2026-03-16 13:59:39'),
(18,'tawheedkortam1@gmail.com','212118','2026-03-16 14:08:12','2026-03-16 14:09:23'),
(19,'tawheedkortam1@gmail.com','400531','2026-03-16 16:16:29','2026-03-16 16:17:05'),
(20,'123medoabdo@gmail.com','891818','2026-04-20 16:43:22','2026-04-20 16:43:38'),
(21,'123medoabdo@gmail.com','531634','2026-04-20 16:43:38','2026-04-20 16:48:10'),
(22,'123medoabdo@gmail.com','663115','2026-04-20 16:48:10','2026-04-20 16:52:40'),
(23,'123medoabdo@gmail.com','443597','2026-04-20 16:52:40',NULL);
/*!40000 ALTER TABLE `password_reset_codes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `password_reset_tokens`
--

DROP TABLE IF EXISTS `password_reset_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `password_reset_tokens` (
  `email` varchar(191) NOT NULL,
  `token` varchar(191) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`email`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `password_reset_tokens`
--

LOCK TABLES `password_reset_tokens` WRITE;
/*!40000 ALTER TABLE `password_reset_tokens` DISABLE KEYS */;
/*!40000 ALTER TABLE `password_reset_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `patient_education`
--

DROP TABLE IF EXISTS `patient_education`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `patient_education` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `title_ar` varchar(191) DEFAULT NULL,
  `title_en` varchar(191) DEFAULT NULL,
  `title_de` varchar(191) DEFAULT NULL,
  `title_fr` varchar(191) DEFAULT NULL,
  `slug_en` varchar(191) DEFAULT NULL,
  `slug_de` varchar(191) DEFAULT NULL,
  `slug_fr` varchar(191) DEFAULT NULL,
  `slug_ar` varchar(191) DEFAULT NULL,
  `link` varchar(191) DEFAULT NULL,
  `is_feature` tinyint(4) NOT NULL DEFAULT 0,
  `short_description_ar` text DEFAULT NULL,
  `short_description_en` text DEFAULT NULL,
  `short_description_de` text DEFAULT NULL,
  `short_description_fr` text DEFAULT NULL,
  `description_ar` longtext DEFAULT NULL,
  `description_en` longtext DEFAULT NULL,
  `description_de` longtext DEFAULT NULL,
  `description_fr` longtext DEFAULT NULL,
  `banner_en` text DEFAULT NULL,
  `banner_de` varchar(191) DEFAULT NULL,
  `banner_fr` varchar(191) DEFAULT NULL,
  `banner_ar` text DEFAULT NULL,
  `meta_title_ar` varchar(191) DEFAULT NULL,
  `meta_title_en` varchar(191) DEFAULT NULL,
  `meta_title_de` varchar(191) DEFAULT NULL,
  `meta_title_fr` varchar(191) DEFAULT NULL,
  `meta_img` text DEFAULT NULL,
  `meta_description_ar` text DEFAULT NULL,
  `meta_description_en` text DEFAULT NULL,
  `meta_description_de` text DEFAULT NULL,
  `meta_description_fr` text DEFAULT NULL,
  `meta_keywords_ar` text DEFAULT NULL,
  `meta_keywords_en` text DEFAULT NULL,
  `meta_keywords_de` text DEFAULT NULL,
  `meta_keywords_fr` text DEFAULT NULL,
  `status` tinyint(4) NOT NULL DEFAULT 0,
  `disease_type_id` bigint(20) unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `order` varchar(191) DEFAULT '0',
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `patient_education_disease_type_id_foreign` (`disease_type_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `patient_education`
--

LOCK TABLES `patient_education` WRITE;
/*!40000 ALTER TABLE `patient_education` DISABLE KEYS */;
/*!40000 ALTER TABLE `patient_education` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payment_links`
--

DROP TABLE IF EXISTS `payment_links`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `payment_links` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `uuid` char(36) NOT NULL,
  `name` varchar(191) NOT NULL,
  `email` varchar(191) NOT NULL,
  `phone` varchar(191) NOT NULL,
  `specialty` varchar(191) DEFAULT NULL,
  `country` varchar(191) DEFAULT NULL,
  `items` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`items`)),
  `amount` decimal(10,2) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `status` varchar(191) NOT NULL DEFAULT 'pending',
  `order_id` bigint(20) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `payment_links_uuid_unique` (`uuid`),
  KEY `payment_links_order_id_foreign` (`order_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payment_links`
--

LOCK TABLES `payment_links` WRITE;
/*!40000 ALTER TABLE `payment_links` DISABLE KEYS */;
/*!40000 ALTER TABLE `payment_links` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payment_methods`
--

DROP TABLE IF EXISTS `payment_methods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `payment_methods` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `title_en` varchar(191) DEFAULT NULL,
  `title_de` varchar(191) DEFAULT NULL,
  `title_fr` varchar(191) DEFAULT NULL,
  `title_ar` varchar(191) DEFAULT NULL,
  `slug_en` varchar(191) DEFAULT NULL,
  `slug_de` varchar(191) DEFAULT NULL,
  `slug_fr` varchar(191) DEFAULT NULL,
  `slug_ar` varchar(191) DEFAULT NULL,
  `banner_en` text DEFAULT NULL,
  `banner_de` varchar(191) DEFAULT NULL,
  `banner_fr` varchar(191) DEFAULT NULL,
  `banner_ar` text DEFAULT NULL,
  `code` varchar(191) NOT NULL,
  `status` tinyint(4) NOT NULL DEFAULT 0,
  `config` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`config`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `payment_methods_code_unique` (`code`),
  UNIQUE KEY `payment_methods_slug_en_unique` (`slug_en`),
  UNIQUE KEY `payment_methods_slug_ar_unique` (`slug_ar`)
) ENGINE=MyISAM AUTO_INCREMENT=54 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payment_methods`
--

LOCK TABLES `payment_methods` WRITE;
/*!40000 ALTER TABLE `payment_methods` DISABLE KEYS */;
INSERT INTO `payment_methods` VALUES
(45,'Bank Transfer - AlAhli Bank','Banküberweisung - AlAhli','Virement Bancaire - AlAhli','تحويل بنكي - البنك الأهلي','bank-transfer-alahli','bank-uberweisung-alahli','virement-bancaire-alahli','تحويل-بنكي-الاهلي','payment-methods/alahli.jpeg','payment-methods/alahli.jpeg','payment-methods/alahli.jpeg','payment-methods/alahli.jpeg','bank_transfer_alahli',1,'{\"bank_name\":\"\\u0627\\u0644\\u0628\\u0646\\u0643 \\u0627\\u0644\\u0627\\u0647\\u0644\\u064a \\u0627\\u0644\\u062a\\u062c\\u0627\\u0631\\u064a\",\"account_name\":\"\\u0645\\u0624\\u0633\\u0633\\u0629 \\u0631\\u062d\\u0644\\u062a\\u0646\\u0627 \\u0644\\u062a\\u0646\\u0638\\u064a\\u0645 \\u0627\\u0644\\u0631\\u062d\\u0644\\u0627\\u062a\",\"account_number\":\"15463733000108\",\"iban\":\"SA8910000015463733000108\",\"bank_address\":\"\\u0627\\u0644\\u0645\\u0645\\u0644\\u0643\\u0629 \\u0627\\u0644\\u0639\\u0631\\u0628\\u064a\\u0629 \\u0627\\u0644\\u0633\\u0639\\u0648\\u062f\\u064a\\u0629\",\"instructions\":\"\\u0627\\u0644\\u0631\\u062c\\u0627\\u0621 \\u0625\\u0631\\u0641\\u0627\\u0642 \\u0625\\u064a\\u0635\\u0627\\u0644 \\u0627\\u0644\\u062a\\u062d\\u0648\\u064a\\u0644 \\u0628\\u0639\\u062f \\u0625\\u062a\\u0645\\u0627\\u0645 \\u0627\\u0644\\u0639\\u0645\\u0644\\u064a\\u0629.\"}','2026-04-18 20:40:46','2026-04-18 20:40:46',NULL),
(46,'Bank Transfer - Al Rajhi Bank','Banküberweisung - Al Rajhi','Virement Bancaire - Al Rajhi','تحويل بنكي - بنك الراجحي','bank-transfer-alrajhi','bank-uberweisung-alrajhi','virement-bancaire-alrajhi','تحويل-بنكي-الراجحي','payment-methods/alrajhi.jpg','payment-methods/alrajhi.jpg','payment-methods/alrajhi.jpg','payment-methods/alrajhi.jpg','bank_transfer_alrajhi',1,'{\"bank_name\":\"\\u0628\\u0646\\u0643 \\u0627\\u0644\\u0631\\u0627\\u062c\\u062d\\u0649\",\"account_name\":\"\\u0645\\u0624\\u0633\\u0633\\u0629 \\u0631\\u062d\\u0644\\u062a\\u0646\\u0627 \\u0644\\u062a\\u0646\\u0638\\u064a\\u0645 \\u0627\\u0644\\u0631\\u062d\\u0644\\u0627\\u062a\",\"account_number\":\"551608010056607\",\"iban\":\"SA8680000551608010056607\",\"bank_address\":\"\\u0627\\u0644\\u0645\\u0645\\u0644\\u0643\\u0629 \\u0627\\u0644\\u0639\\u0631\\u0628\\u064a\\u0629 \\u0627\\u0644\\u0633\\u0639\\u0648\\u062f\\u064a\\u0629\",\"instructions\":\"\\u0627\\u0644\\u0631\\u062c\\u0627\\u0621 \\u0625\\u0631\\u0641\\u0627\\u0642 \\u0625\\u064a\\u0635\\u0627\\u0644 \\u0627\\u0644\\u062a\\u062d\\u0648\\u064a\\u0644 \\u0628\\u0639\\u062f \\u0625\\u062a\\u0645\\u0627\\u0645 \\u0627\\u0644\\u0639\\u0645\\u0644\\u064a\\u0629.\"}','2026-04-18 20:40:46','2026-04-18 20:40:46',NULL),
(47,'Tamara','Tamara','Tamara','تمارا','tamara','tamara','tamara','تمارا','payment-methods/tamara.jpeg','payment-methods/tamara.jpeg','payment-methods/tamara.jpeg','payment-methods/tamara.jpeg','tamara',1,'{\"live\":{\"base_url\":\"https:\\/\\/api.tamara.co\",\"secret_key\":\"eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhY2NvdW50SWQiOiI3YjQ2ZmM4My1kOTkzLTRkOTktYWFiZC01MDM2MTczMzYzYTIiLCJ0eXBlIjoibWVyY2hhbnQiLCJzYWx0IjoiNmI3ZDQxMjQtMjQ1NS00YTc5LTkzZjktNTE5NjU0NTVkY2UzIiwicm9sZXMiOlsiUk9MRV9NRVJDSEFOVCJdLCJpc010bHMiOmZhbHNlLCJpYXQiOjE3NzM0OTI3NzAsImlzcyI6IlRhbWFyYSBQUCJ9.YTxEeRORt7kWXvgquslP3I6CHsYhQAoAFJyKvjau9O1cbrclwo9mtiDgWKAJvppMxEbElG8nNQ6swAQgovK2ZITCC_G_96sxOMZnkhf_KKXBaLZCTltdAN8HYNgt_fz-Iy1BnPE8jDnqsYurDuIs-G7xfM7YQJREABaQr510vl6Bivqo4O6YeIjdW-Fm0_GFwb_7b5Uh2qlC9GrvQoGYtt1Kmf6d5WXSWK2LpPeGBFaLj-S_KHHazGLoypXKpdhOSq0GECLBD-cyVYLytlPgV50OYTqcgzU1Im9AsIxIpJ-K5DImHeyrp4s5hnJC_NKfvQPgwZ8rzOv_pPheTX2pBg\",\"public_key\":\"2824722a-824d-495b-b9fc-617d59652200\"},\"test\":{\"base_url\":\"https:\\/\\/api-sandbox.tamara.co\",\"secret_key\":\"sk_test_0190e4e4-432b-0f64-4717-30d5d415747f\",\"public_key\":\"pk_test_0190e4e4-432b-0f64-4717-30d5109dbe3d\"},\"mode\":\"test\"}','2026-04-18 20:40:46','2026-04-18 20:40:46',NULL),
(48,'Moyasar (Mada, Apple Pay, STC Pay, Visa)','Moyasar (Mada, Apple Pay, STC Pay)','Moyasar (Mada, Apple Pay, STC Pay)','ميسر (مدى، أبل باي، STC Pay، فيزا)','moyasar','moyasar','moyasar','ميسر','payment-methods/moyasar.png','payment-methods/moyasar.png','payment-methods/moyasar.png','payment-methods/moyasar.png','moyasar',0,'{\"live\":{\"secret_key\":\"sk_live_...\",\"publishable_key\":\"pk_live_...\"},\"test\":{\"secret_key\":\"sk_test_...\",\"publishable_key\":\"pk_test_...\"},\"mode\":\"test\"}','2026-04-18 20:40:46','2026-04-18 20:40:46',NULL),
(49,'Vodafone Cash','Vodafone Cash','Vodafone Cash','فودافون كاش','vodafone-cash','vodafone-cash','vodafone-cash','فودافون-كاش','payment-methods/vodafone.png','payment-methods/vodafone.png','payment-methods/vodafone.png','payment-methods/vodafone.png','wallet_vodafone',0,'{\"wallet_number\":\"010XXXXXXXX\",\"account_name\":\"\\u0627\\u0633\\u0645 \\u0635\\u0627\\u062d\\u0628 \\u0627\\u0644\\u0645\\u062d\\u0641\\u0638\\u0629\",\"instructions\":\"\\u0628\\u0631\\u062c\\u0627\\u0621 \\u062a\\u062d\\u0648\\u064a\\u0644 \\u0627\\u0644\\u0645\\u0628\\u0644\\u063a \\u0639\\u0644\\u0649 \\u0647\\u0630\\u0627 \\u0627\\u0644\\u0631\\u0642\\u0645\\u060c \\u062b\\u0645 \\u0625\\u0631\\u0641\\u0627\\u0642 \\u0635\\u0648\\u0631\\u0629 (\\u0633\\u0643\\u0631\\u064a\\u0646 \\u0634\\u0648\\u062a) \\u0644\\u0631\\u0633\\u0627\\u0644\\u0629 \\u062a\\u0623\\u0643\\u064a\\u062f \\u0627\\u0644\\u062a\\u062d\\u0648\\u064a\\u0644.\"}','2026-04-18 20:40:46','2026-04-18 20:40:46',NULL),
(50,'Etisalat Cash','Etisalat Cash','Etisalat Cash','اتصالات كاش','etisalat-cash','etisalat-cash','etisalat-cash','اتصالات-كاش','payment-methods/etisalat.png','payment-methods/etisalat.png','payment-methods/etisalat.png','payment-methods/etisalat.png','wallet_etisalat',0,'{\"wallet_number\":\"011XXXXXXXX\",\"account_name\":\"\\u0627\\u0633\\u0645 \\u0635\\u0627\\u062d\\u0628 \\u0627\\u0644\\u0645\\u062d\\u0641\\u0638\\u0629\",\"instructions\":\"\\u0628\\u0631\\u062c\\u0627\\u0621 \\u062a\\u062d\\u0648\\u064a\\u0644 \\u0627\\u0644\\u0645\\u0628\\u0644\\u063a \\u0639\\u0644\\u0649 \\u0647\\u0630\\u0627 \\u0627\\u0644\\u0631\\u0642\\u0645\\u060c \\u062b\\u0645 \\u0625\\u0631\\u0641\\u0627\\u0642 \\u0635\\u0648\\u0631\\u0629 (\\u0633\\u0643\\u0631\\u064a\\u0646 \\u0634\\u0648\\u062a) \\u0644\\u0631\\u0633\\u0627\\u0644\\u0629 \\u062a\\u0623\\u0643\\u064a\\u062f \\u0627\\u0644\\u062a\\u062d\\u0648\\u064a\\u0644.\"}','2026-04-18 20:40:46','2026-04-18 20:40:46',NULL),
(51,'Orange Cash','Orange Cash','Orange Cash','أورانج كاش','orange-cash','orange-cash','orange-cash','اورانج-كاش','payment-methods/orange.png','payment-methods/orange.png','payment-methods/orange.png','payment-methods/orange.png','wallet_orange',0,'{\"wallet_number\":\"012XXXXXXXX\",\"account_name\":\"\\u0627\\u0633\\u0645 \\u0635\\u0627\\u062d\\u0628 \\u0627\\u0644\\u0645\\u062d\\u0641\\u0638\\u0629\",\"instructions\":\"\\u0628\\u0631\\u062c\\u0627\\u0621 \\u062a\\u062d\\u0648\\u064a\\u0644 \\u0627\\u0644\\u0645\\u0628\\u0644\\u063a \\u0639\\u0644\\u0649 \\u0647\\u0630\\u0627 \\u0627\\u0644\\u0631\\u0642\\u0645\\u060c \\u062b\\u0645 \\u0625\\u0631\\u0641\\u0627\\u0642 \\u0635\\u0648\\u0631\\u0629 (\\u0633\\u0643\\u0631\\u064a\\u0646 \\u0634\\u0648\\u062a) \\u0644\\u0631\\u0633\\u0627\\u0644\\u0629 \\u062a\\u0623\\u0643\\u064a\\u062f \\u0627\\u0644\\u062a\\u062d\\u0648\\u064a\\u0644.\"}','2026-04-18 20:40:46','2026-04-18 20:40:46',NULL),
(52,'WE Pay','WE Pay','WE Pay','وي باي','we-pay','we-pay','we-pay','وي-باي','payment-methods/we.png','payment-methods/we.png','payment-methods/we.png','payment-methods/we.png','wallet_we',0,'{\"wallet_number\":\"015XXXXXXXX\",\"account_name\":\"\\u0627\\u0633\\u0645 \\u0635\\u0627\\u062d\\u0628 \\u0627\\u0644\\u0645\\u062d\\u0641\\u0638\\u0629\",\"instructions\":\"\\u0628\\u0631\\u062c\\u0627\\u0621 \\u062a\\u062d\\u0648\\u064a\\u0644 \\u0627\\u0644\\u0645\\u0628\\u0644\\u063a \\u0639\\u0644\\u0649 \\u0647\\u0630\\u0627 \\u0627\\u0644\\u0631\\u0642\\u0645\\u060c \\u062b\\u0645 \\u0625\\u0631\\u0641\\u0627\\u0642 \\u0635\\u0648\\u0631\\u0629 (\\u0633\\u0643\\u0631\\u064a\\u0646 \\u0634\\u0648\\u062a) \\u0644\\u0631\\u0633\\u0627\\u0644\\u0629 \\u062a\\u0623\\u0643\\u064a\\u062f \\u0627\\u0644\\u062a\\u062d\\u0648\\u064a\\u0644.\"}','2026-04-18 20:40:46','2026-04-18 20:40:46',NULL),
(53,'InstaPay','InstaPay','InstaPay','إنستا باي','instapay','instapay','instapay','انستا-باي','payment-methods/instapay.png','payment-methods/instapay.png','payment-methods/instapay.png','payment-methods/instapay.png','instapay',0,'{\"instapay_address\":\"username@instapay\",\"mobile_number\":\"01XXXXXXXXX\",\"account_name\":\"\\u0627\\u0633\\u0645 \\u0627\\u0644\\u062d\\u0633\\u0627\\u0628\",\"instructions\":\"\\u0628\\u0631\\u062c\\u0627\\u0621 \\u0627\\u0644\\u062a\\u062d\\u0648\\u064a\\u0644 \\u0639\\u0644\\u0649 \\u0639\\u0646\\u0648\\u0627\\u0646 \\u0625\\u0646\\u0633\\u062a\\u0627 \\u0628\\u0627\\u064a \\u0627\\u0644\\u0645\\u0648\\u0636\\u062d \\u0623\\u0648 \\u0631\\u0642\\u0645 \\u0627\\u0644\\u0645\\u0648\\u0628\\u0627\\u064a\\u0644\\u060c \\u0648\\u0625\\u0631\\u0641\\u0627\\u0642 \\u0625\\u064a\\u0635\\u0627\\u0644 \\u0627\\u0644\\u062a\\u062d\\u0648\\u064a\\u0644.\"}','2026-04-18 20:40:46','2026-04-18 20:40:46',NULL);
/*!40000 ALTER TABLE `payment_methods` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `personal_access_tokens`
--

DROP TABLE IF EXISTS `personal_access_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `personal_access_tokens` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `tokenable_type` varchar(191) NOT NULL,
  `tokenable_id` bigint(20) unsigned NOT NULL,
  `name` varchar(191) NOT NULL,
  `token` varchar(64) NOT NULL,
  `abilities` text DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`)
) ENGINE=MyISAM AUTO_INCREMENT=162 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `personal_access_tokens`
--

LOCK TABLES `personal_access_tokens` WRITE;
/*!40000 ALTER TABLE `personal_access_tokens` DISABLE KEYS */;
INSERT INTO `personal_access_tokens` VALUES
(123,'App\\Models\\ResidencyUser',11,'api-token','1f3b280eebeab331ea3e909de009dddedb4c9f696ddbe4df6130e7ec4211fb9c','[\"*\"]','2026-03-16 21:20:17',NULL,'2026-03-16 21:13:00','2026-03-16 21:20:17'),
(49,'App\\Models\\ResidencyUser',2,'api-token','e13efdf614621fe710260154e6132d54c9c3db656ec4f03d10c252883f2dc831','[\"*\"]',NULL,NULL,'2026-03-13 04:44:49','2026-03-13 04:44:49'),
(41,'App\\Models\\ResidencyUser',4,'api-token','d25b3fb9970659af28f0870b8141616fdf888c1034806fef6cdb6290f09b7a85','[\"*\"]',NULL,NULL,'2026-03-13 04:41:49','2026-03-13 04:41:49'),
(161,'App\\Models\\ResidencyUser',5,'api-token','162d6b254c5f21bb82275e639e9b2955089687f9586861735905fdfb958ba14a','[\"*\"]','2026-04-26 18:37:08',NULL,'2026-04-26 18:36:49','2026-04-26 18:37:08'),
(64,'App\\Models\\ResidencyUser',6,'api-token','c85d916f25e576abe59f5a9e3f3fee675c065044d203e2aedb1bea7319726632','[\"*\"]',NULL,NULL,'2026-03-13 04:51:20','2026-03-13 04:51:20'),
(128,'App\\Models\\ResidencyUser',1,'api-token','fb1de9bffac3d0c026032638aa8bf806bc37ceab4e2443692a27cded9f3e4810','[\"*\"]','2026-04-27 02:51:14',NULL,'2026-03-17 18:56:26','2026-04-27 02:51:14'),
(158,'App\\Models\\ResidencyUser',13,'api-token','766d90a85bd6ae9291ddfdcd68c9a11c407789e89eab43061bcfc51c59dcd394','[\"*\"]','2026-04-21 17:12:06',NULL,'2026-04-21 12:15:14','2026-04-21 17:12:06'),
(153,'App\\Models\\ResidencyUser',8,'api-token','c969c2079b74b3ada76db7af3058782336857b514f834c6eb6b6bcccea9f8c2e','[\"*\"]','2026-04-26 19:09:30',NULL,'2026-04-20 03:37:45','2026-04-26 19:09:30');
/*!40000 ALTER TABLE `personal_access_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `portfolio_categories`
--

DROP TABLE IF EXISTS `portfolio_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `portfolio_categories` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name_en` varchar(191) DEFAULT NULL,
  `name_de` varchar(191) DEFAULT NULL,
  `name_fr` varchar(191) DEFAULT NULL,
  `name_ar` varchar(191) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `portfolio_categories`
--

LOCK TABLES `portfolio_categories` WRITE;
/*!40000 ALTER TABLE `portfolio_categories` DISABLE KEYS */;
/*!40000 ALTER TABLE `portfolio_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `portfolios`
--

DROP TABLE IF EXISTS `portfolios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `portfolios` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name_en` varchar(191) DEFAULT NULL,
  `name_de` varchar(191) DEFAULT NULL,
  `name_fr` varchar(191) DEFAULT NULL,
  `name_ar` varchar(191) DEFAULT NULL,
  `slug_en` varchar(191) DEFAULT NULL,
  `slug_de` varchar(191) DEFAULT NULL,
  `slug_fr` varchar(191) DEFAULT NULL,
  `slug_ar` varchar(191) DEFAULT NULL,
  `link` varchar(191) DEFAULT NULL,
  `short_description_ar` text DEFAULT NULL,
  `short_description_en` text DEFAULT NULL,
  `short_description_de` text DEFAULT NULL,
  `short_description_fr` text DEFAULT NULL,
  `description_ar` longtext DEFAULT NULL,
  `description_en` longtext DEFAULT NULL,
  `description_de` longtext DEFAULT NULL,
  `description_fr` longtext DEFAULT NULL,
  `img` text DEFAULT NULL,
  `meta_title_ar` varchar(191) DEFAULT NULL,
  `meta_title_en` varchar(191) DEFAULT NULL,
  `meta_title_de` varchar(191) DEFAULT NULL,
  `meta_title_fr` varchar(191) DEFAULT NULL,
  `meta_img` text DEFAULT NULL,
  `meta_description_ar` text DEFAULT NULL,
  `meta_description_en` text DEFAULT NULL,
  `meta_description_de` text DEFAULT NULL,
  `meta_description_fr` text DEFAULT NULL,
  `meta_keywords_ar` text DEFAULT NULL,
  `meta_keywords_en` text DEFAULT NULL,
  `meta_keywords_de` text DEFAULT NULL,
  `meta_keywords_fr` text DEFAULT NULL,
  `status` tinyint(4) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `portfolio_category_id` bigint(20) unsigned DEFAULT NULL,
  `order` varchar(191) DEFAULT '0',
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `portfolios_portfolio_category_id_foreign` (`portfolio_category_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `portfolios`
--

LOCK TABLES `portfolios` WRITE;
/*!40000 ALTER TABLE `portfolios` DISABLE KEYS */;
/*!40000 ALTER TABLE `portfolios` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `protocols`
--

DROP TABLE IF EXISTS `protocols`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `protocols` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `title_ar` varchar(191) DEFAULT NULL,
  `title_en` varchar(191) DEFAULT NULL,
  `slug_en` varchar(191) DEFAULT NULL,
  `slug_ar` varchar(191) DEFAULT NULL,
  `link` varchar(191) DEFAULT NULL,
  `is_feature` tinyint(4) NOT NULL DEFAULT 0,
  `short_description_ar` text DEFAULT NULL,
  `short_description_en` text DEFAULT NULL,
  `description_ar` longtext DEFAULT NULL,
  `description_en` longtext DEFAULT NULL,
  `banner_en` text DEFAULT NULL,
  `banner_ar` text DEFAULT NULL,
  `meta_title_ar` varchar(191) DEFAULT NULL,
  `meta_title_en` varchar(191) DEFAULT NULL,
  `meta_img` text DEFAULT NULL,
  `meta_description_ar` text DEFAULT NULL,
  `meta_description_en` text DEFAULT NULL,
  `meta_keywords_ar` text DEFAULT NULL,
  `meta_keywords_en` text DEFAULT NULL,
  `status` tinyint(4) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `order` varchar(191) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `protocols`
--

LOCK TABLES `protocols` WRITE;
/*!40000 ALTER TABLE `protocols` DISABLE KEYS */;
/*!40000 ALTER TABLE `protocols` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `register_users`
--

DROP TABLE IF EXISTS `register_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `register_users` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(191) NOT NULL,
  `email` varchar(191) NOT NULL,
  `phone` varchar(191) NOT NULL,
  `specialty` varchar(191) NOT NULL,
  `country` varchar(191) NOT NULL,
  `reply` text DEFAULT NULL,
  `item_id` bigint(20) unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `register_users_item_id_foreign` (`item_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `register_users`
--

LOCK TABLES `register_users` WRITE;
/*!40000 ALTER TABLE `register_users` DISABLE KEYS */;
/*!40000 ALTER TABLE `register_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `residency_programs`
--

DROP TABLE IF EXISTS `residency_programs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `residency_programs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `title_ar` varchar(191) DEFAULT NULL,
  `title_en` varchar(191) DEFAULT NULL,
  `title_de` varchar(191) DEFAULT NULL,
  `title_fr` varchar(191) DEFAULT NULL,
  `slug_en` varchar(191) DEFAULT NULL,
  `slug_de` varchar(191) DEFAULT NULL,
  `slug_fr` varchar(191) DEFAULT NULL,
  `slug_ar` varchar(191) DEFAULT NULL,
  `link` varchar(191) DEFAULT NULL,
  `is_feature` tinyint(4) NOT NULL DEFAULT 0,
  `short_description_ar` text DEFAULT NULL,
  `short_description_en` text DEFAULT NULL,
  `short_description_de` text DEFAULT NULL,
  `short_description_fr` text DEFAULT NULL,
  `description_ar` longtext DEFAULT NULL,
  `description_en` longtext DEFAULT NULL,
  `description_de` longtext DEFAULT NULL,
  `description_fr` longtext DEFAULT NULL,
  `banner_en` text DEFAULT NULL,
  `banner_de` varchar(191) DEFAULT NULL,
  `banner_fr` varchar(191) DEFAULT NULL,
  `banner_ar` text DEFAULT NULL,
  `meta_title_ar` varchar(191) DEFAULT NULL,
  `meta_title_en` varchar(191) DEFAULT NULL,
  `meta_title_de` varchar(191) DEFAULT NULL,
  `meta_title_fr` varchar(191) DEFAULT NULL,
  `meta_img` text DEFAULT NULL,
  `meta_description_ar` text DEFAULT NULL,
  `meta_description_en` text DEFAULT NULL,
  `meta_description_de` text DEFAULT NULL,
  `meta_description_fr` text DEFAULT NULL,
  `meta_keywords_ar` text DEFAULT NULL,
  `meta_keywords_en` text DEFAULT NULL,
  `meta_keywords_de` text DEFAULT NULL,
  `meta_keywords_fr` text DEFAULT NULL,
  `status` tinyint(4) NOT NULL DEFAULT 0,
  `disease_type_id` bigint(20) unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `order` varchar(191) DEFAULT '0',
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `residency_programs_disease_type_id_foreign` (`disease_type_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `residency_programs`
--

LOCK TABLES `residency_programs` WRITE;
/*!40000 ALTER TABLE `residency_programs` DISABLE KEYS */;
/*!40000 ALTER TABLE `residency_programs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `residency_users`
--

DROP TABLE IF EXISTS `residency_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `residency_users` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(191) NOT NULL,
  `email` varchar(191) NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(191) NOT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `phone` varchar(191) DEFAULT NULL,
  `specialty` varchar(191) DEFAULT NULL,
  `country` varchar(191) DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `package_id` bigint(20) unsigned DEFAULT NULL,
  `earned_points` decimal(10,2) NOT NULL DEFAULT 0.00,
  `available_points` decimal(10,2) NOT NULL DEFAULT 0.00,
  `used_points` decimal(10,2) NOT NULL DEFAULT 0.00,
  `fcm_token` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `residency_users_email_unique` (`email`),
  KEY `residency_users_package_id_foreign` (`package_id`)
) ENGINE=MyISAM AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `residency_users`
--

LOCK TABLES `residency_users` WRITE;
/*!40000 ALTER TABLE `residency_users` DISABLE KEYS */;
INSERT INTO `residency_users` VALUES
(1,'توحيد','tawheedkortam1@gmail.com',NULL,'$2y$12$VN5liV4zm5TjIiAR/eky8uXjzNwk7QvCszk97qvAp7x7kEPfCiPZe',NULL,'2026-03-11 20:48:17','2026-03-17 16:58:22',NULL,NULL,NULL,NULL,1,0.00,0.00,0.00,'e9RSQpbzRICS54ujLZ_RqQ:APA91bGcfJk_hamKoCAkvtqaYRy-OgloYcoJC0-rvHZ16BE1kkT8s2FRIz3nCE-Qg30ffGy68q_nG4s-avB2OdLypSTj28kD6S_tkBmVZQBoeXe2fruhu94'),
(2,'Mohamed','mohamedsaeed00451@gmail.com',NULL,'$2y$12$gYRHqzM2JIsNBQsgUc6J.uBip/eTWvWBCYZBlOffKCSy26SkEAHeW',NULL,'2026-03-13 03:22:22','2026-03-13 21:09:33','01028768312',NULL,NULL,NULL,1,0.00,0.00,0.00,NULL),
(3,'Mohamed Abdel azeem','123mohamedeldeb02@gmail.com',NULL,'$2y$12$6SNGpm3GwO/tAf5i9E5XxO2wuHx07.xk.haT1enA0swWcol1xKfTy',NULL,'2026-03-13 03:55:01','2026-04-20 16:40:46','01028768312',NULL,NULL,'2026-04-20 16:40:46',1,0.00,0.00,0.00,NULL),
(4,'Mohamed Abdel azeem','123mohamedeldeb@gmail.com',NULL,'$2y$12$Oev826BygcrOybDn965DuOUQ25JyR.TcDs0aNr.qUFxYfR4i6KmBq',NULL,'2026-03-13 04:41:49','2026-04-20 16:40:57','01028768312',NULL,NULL,'2026-04-20 16:40:57',1,0.00,0.00,0.00,NULL),
(5,'Mohamed Abdel azeem','123medoabdo@gmail.com',NULL,'$2y$12$d93DNENZ46UY7WUjexewCu6jhvh6btKRnFGmfhYfmekm6Qg.wMTmi',NULL,'2026-03-13 04:48:05','2026-04-20 16:41:11','01028768312',NULL,NULL,NULL,21,999.00,0.00,0.00,NULL),
(6,'Mohamed Abdel azeem','12medoabdo@gmail.com',NULL,'$2y$12$UFWvptTNG5k.OWDeWIuvUeO.ml.HRPdZq5vFfp2CB/8OhOiw8Azg.',NULL,'2026-03-13 04:48:22','2026-04-20 16:39:54','01028768312',NULL,NULL,'2026-04-20 16:39:54',1,0.00,0.00,0.00,NULL),
(7,'Ahmed Ali','ahmed@test.com',NULL,'$2y$12$cYqDkZQeADMXCOCjtXtSR.0GgFGkd/G/UjUQk56ECBpldPWXHjvAa',NULL,'2026-03-13 23:30:02','2026-03-13 23:30:02','01010235689',NULL,NULL,NULL,1,0.00,0.00,0.00,NULL),
(8,'medhat','medhat.kortam@gmail.com',NULL,'$2y$12$PmSGLFaFC9lfd3Xlt.2McOii830/mkoC.XyOwK4pv8LUkQbuyOLWO',NULL,'2026-03-14 00:32:07','2026-03-14 00:32:07','051234567',NULL,NULL,NULL,1,0.00,0.00,0.00,NULL),
(9,'mo saeed','mo@gmail.com',NULL,'$2y$12$hbshuDcoREBU4q6gGWWVv.J0yCAy2Igh7mFG3g4bcSJjTEWh5B7jC',NULL,'2026-03-15 22:57:18','2026-03-15 22:57:18','01092338086',NULL,NULL,NULL,5,0.00,0.00,0.00,NULL),
(10,'mo test','email@gmail.con',NULL,'$2y$12$0XOa4Zi3O.J.kU2kaUYz3OYjuQnU6HF85SnOm9KHi0J85SQ4rzMgO',NULL,'2026-03-15 23:00:28','2026-03-15 23:00:28','01092338086',NULL,NULL,NULL,5,0.00,0.00,0.00,NULL),
(11,'shohdy','shohdykortam@gmail.com',NULL,'$2y$12$kzxsxtROlVUc8uju.dyFm.aKhWBv50Vso7ntL0lemJm1qWrXLV8BS',NULL,'2026-03-16 21:09:13','2026-03-16 21:09:13','01027582666',NULL,NULL,NULL,13,0.00,0.00,0.00,NULL),
(12,'Mohamed Abdel azeem','23medoabdo@gmail.com',NULL,'$2y$12$nhpcE7TBRnuF.zecCNyo8uYJOIskANYOQq0hojAUL50ZrbqvisuSm',NULL,'2026-04-20 03:37:42','2026-04-20 16:39:48','01028768312',NULL,NULL,'2026-04-20 16:39:48',21,0.00,0.00,0.00,NULL),
(13,'احمد كمال اسماعيل','aheadkmlma0555056185@gmail.com',NULL,'$2y$12$w0.rq21k5eD4w2NlR3el6OyeMP.z46k4aNm3TPVOwoAKahQZD14Dq',NULL,'2026-04-21 12:15:14','2026-04-21 12:15:14','0555056185',NULL,NULL,NULL,21,0.00,0.00,0.00,NULL);
/*!40000 ALTER TABLE `residency_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(191) NOT NULL,
  `permissions` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`permissions`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES
(1,'Admin','[\"manage_blogs\",\"manage_trips\",\"manage_locations\",\"manage_customers\",\"manage_notifications\",\"manage_payments\",\"manage_website\",\"manage_settings\",\"manage_staff\"]','2026-03-23 21:10:36','2026-03-23 21:10:36'),
(2,'editor','[\"manage_trips\"]','2026-03-25 21:53:52','2026-03-25 21:53:52');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sessions`
--

DROP TABLE IF EXISTS `sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `sessions` (
  `id` varchar(191) NOT NULL,
  `user_id` bigint(20) unsigned DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `payload` longtext NOT NULL,
  `last_activity` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sessions_user_id_index` (`user_id`),
  KEY `sessions_last_activity_index` (`last_activity`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sessions`
--

LOCK TABLES `sessions` WRITE;
/*!40000 ALTER TABLE `sessions` DISABLE KEYS */;
INSERT INTO `sessions` VALUES
('VCwzajy4asdsy8naMNlGgoGl51XHTnBZ90SUccmu',1,'196.136.73.191','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36','YTo2OntzOjY6Il90b2tlbiI7czo0MDoiYVJpMHU3eFVyUEZZZUJaY3ZVTlpsMDJONzMwNmVVYVFVaDZKUFRrTiI7czozOiJ1cmwiO2E6MDp7fXM6OToiX3ByZXZpb3VzIjthOjI6e3M6MzoidXJsIjtzOjM3OiJodHRwczovL2FkbWluLnJlaGx0bmEuY29tL2FkbWluL2l0ZW1zIjtzOjU6InJvdXRlIjtzOjExOiJpdGVtcy5pbmRleCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fXM6NTA6ImxvZ2luX3dlYl81OWJhMzZhZGRjMmIyZjk0MDE1ODBmMDE0YzdmNThlYTRlMzA5ODlkIjtpOjE7czo5OiJ0ZW5hbnRfaWQiO2k6MTt9',1777206237),
('NU29KDii2Th0BCbkoawo2I35c9QCeP7z3YZ7Og2y',1,'154.239.116.232','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36','YTo1OntzOjY6Il90b2tlbiI7czo0MDoieVJHUzR6T2MzUkY3Zm0waVFYaTFOVkVuVnlvRnd4TkR2SjhWN3Q5TCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDE6Imh0dHBzOi8vYWRtaW4ucmVobHRuYS5jb20vYWRtaW4vZGFzaGJvYXJkIjtzOjU6InJvdXRlIjtzOjk6ImRhc2hib2FyZCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fXM6NTA6ImxvZ2luX3dlYl81OWJhMzZhZGRjMmIyZjk0MDE1ODBmMDE0YzdmNThlYTRlMzA5ODlkIjtpOjE7czo5OiJ0ZW5hbnRfaWQiO2k6MTt9',1777217168),
('pu1D7ZMbHRMs51TjNKWshAic8drtYxaRoSSWhBio',1,'41.239.76.101','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36','YTo2OntzOjY6Il90b2tlbiI7czo0MDoiTzlCVTg1R1FIR3hPOTVmdXByVDNibnl6ZHRQMGNYTHVFZDdod2JCVyI7czozOiJ1cmwiO2E6MDp7fXM6OToiX3ByZXZpb3VzIjthOjI6e3M6MzoidXJsIjtzOjM3OiJodHRwczovL2FkbWluLnJlaGx0bmEuY29tL2FkbWluL2l0ZW1zIjtzOjU6InJvdXRlIjtzOjExOiJpdGVtcy5pbmRleCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fXM6NTA6ImxvZ2luX3dlYl81OWJhMzZhZGRjMmIyZjk0MDE1ODBmMDE0YzdmNThlYTRlMzA5ODlkIjtpOjE7czo5OiJ0ZW5hbnRfaWQiO2k6MTt9',1777218198),
('mLfaXbyPI6QqqS2iMUpISCUc8iulEPrTQVZ5iOtZ',NULL,'149.57.180.55','Mozilla/5.0 (X11; Linux i686; rv:109.0) Gecko/20100101 Firefox/120.0','YTozOntzOjY6Il90b2tlbiI7czo0MDoiWTdmVGc0dmIwVnhHWVdocFI5aUExM21DNUN4M0d3N3A4OXY2QnRCayI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzU6Imh0dHBzOi8vd3d3LmFkbWluLnJlaGx0bmEuY29tL2FkbWluIjtzOjU6InJvdXRlIjtzOjE2OiJhZG1pbi5sb2dpbi5mb3JtIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==',1777259327),
('NdGg5ooHjEvvRcyt1ZEjwhPTnJJjl4oYvt6xuvp9',NULL,'23.27.145.141','Mozilla/5.0 (X11; Linux i686; rv:109.0) Gecko/20100101 Firefox/120.0','YTozOntzOjY6Il90b2tlbiI7czo0MDoia0JoUU42QUliTEczV1cxTW9LN0tqMzl0aWs2NlQ4T2J2M0w5YU5DWiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHBzOi8vYWRtaW4ucmVobHRuYS5jb20vYWRtaW4iO3M6NToicm91dGUiO3M6MTY6ImFkbWluLmxvZ2luLmZvcm0iO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19',1777259504);
/*!40000 ALTER TABLE `sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `settings`
--

DROP TABLE IF EXISTS `settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `settings` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `key` varchar(191) NOT NULL,
  `value` varchar(191) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `settings`
--

LOCK TABLES `settings` WRITE;
/*!40000 ALTER TABLE `settings` DISABLE KEYS */;
INSERT INTO `settings` VALUES
(1,'active_langs','[\"ar\",\"en\"]','2026-03-10 20:56:21','2026-03-10 20:56:21',NULL),
(2,'site_address_ar','[]','2026-03-10 20:56:21','2026-04-22 03:08:40',NULL),
(3,'site_address_en','[\"Al-Madinah Al-Munawarah Rd, As Salamah, Jeddah 23437, Saudi Arabia\"]','2026-03-10 20:56:21','2026-04-21 15:27:38',NULL),
(4,'site_address_fr','[]','2026-03-10 20:56:21','2026-03-10 20:56:21',NULL),
(5,'site_address_de','[]','2026-03-10 20:56:21','2026-03-10 20:56:21',NULL),
(6,'facebook','[\"https:\\/\\/web.facebook.com\\/rehlatforfun\"]','2026-03-10 20:56:21','2026-03-25 20:51:32',NULL),
(7,'instagram','[\"https:\\/\\/www.instagram.com\\/rehltna\\/\"]','2026-03-10 20:56:21','2026-03-25 19:46:49',NULL),
(8,'twitter','[\"https:\\/\\/x.com\\/rehltna1?s=21\"]','2026-03-10 20:56:21','2026-04-21 15:27:38',NULL),
(9,'whatsapp','[\"01028768312\"]','2026-03-10 20:56:21','2026-04-22 03:11:09',NULL),
(10,'linkedin','[\"https:\\/\\/maps.app.goo.gl\\/jAKq2GsvFrkE4SaP9\"]','2026-03-10 20:56:21','2026-04-21 15:27:38',NULL),
(11,'youtube','[\"https:\\/\\/www.youtube.com\\/@%D9%85%D8%A4%D8%B3%D8%B3%D8%A9%D8%B1%D8%AD%D9%84%D8%AA%D9%86%D8%A7%D9%84%D8%AA%D9%86%D8%B8%D9%8A%D9%85%D8%A7%D9%84%D8%B1%D8%AD%D9%84%D8%A7%D8%AA\"]','2026-03-10 20:56:21','2026-04-21 15:29:30',NULL),
(12,'site_name_ar','رحلتنا','2026-03-10 20:57:40','2026-03-10 20:57:40',NULL),
(13,'site_name_en','Rehltna','2026-03-10 20:57:40','2026-03-10 20:57:40',NULL),
(14,'site_email','rehltna2020@gmail.com','2026-03-10 21:17:23','2026-04-21 15:15:29',NULL),
(15,'site_phone','+966551933635','2026-03-10 21:17:23','2026-04-24 02:13:22',NULL),
(16,'main_logo_light','/uploads/tenant_1/general/69b03956cbdab_1773156694_general.png','2026-03-10 21:20:10','2026-03-10 21:31:47',NULL),
(17,'main_logo_dark','/uploads/tenant_1/general/69b03956cbdab_1773156694_general.png','2026-03-10 21:20:10','2026-03-10 21:31:47',NULL),
(18,'favicon','/uploads/tenant_1/general/69b03956cbdab_1773156694_general.png','2026-03-10 21:20:10','2026-03-10 21:31:47',NULL),
(19,'payment_success_url','http://localhost:3000/invoice','2026-03-16 06:23:24','2026-03-16 06:23:24',NULL),
(20,'payment_failed_url','http://localhost:3000/payment-failed','2026-03-16 06:23:24','2026-03-16 06:23:24',NULL),
(21,'payment_cancel_url','http://localhost:3000/payment-canceled','2026-03-16 06:23:24','2026-03-16 06:23:24',NULL);
/*!40000 ALTER TABLE `settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `site_maps`
--

DROP TABLE IF EXISTS `site_maps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `site_maps` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(191) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `site_maps`
--

LOCK TABLES `site_maps` WRITE;
/*!40000 ALTER TABLE `site_maps` DISABLE KEYS */;
/*!40000 ALTER TABLE `site_maps` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sliders`
--

DROP TABLE IF EXISTS `sliders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `sliders` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `title_en` varchar(191) DEFAULT NULL,
  `title_de` varchar(191) DEFAULT NULL,
  `title_fr` varchar(191) DEFAULT NULL,
  `title_ar` varchar(191) DEFAULT NULL,
  `banner_en` varchar(191) DEFAULT NULL,
  `banner_de` varchar(191) DEFAULT NULL,
  `banner_fr` varchar(191) DEFAULT NULL,
  `banner_ar` varchar(191) DEFAULT NULL,
  `status` tinyint(4) NOT NULL DEFAULT 0,
  `link` text DEFAULT NULL,
  `order` varchar(191) DEFAULT NULL,
  `meta_title_ar` varchar(191) DEFAULT NULL,
  `meta_title_en` varchar(191) DEFAULT NULL,
  `meta_title_de` varchar(191) DEFAULT NULL,
  `meta_title_fr` varchar(191) DEFAULT NULL,
  `meta_img` text DEFAULT NULL,
  `meta_description_ar` text DEFAULT NULL,
  `meta_description_en` text DEFAULT NULL,
  `meta_description_de` text DEFAULT NULL,
  `meta_description_fr` text DEFAULT NULL,
  `meta_keywords_ar` text DEFAULT NULL,
  `meta_keywords_en` text DEFAULT NULL,
  `meta_keywords_de` text DEFAULT NULL,
  `meta_keywords_fr` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sliders`
--

LOCK TABLES `sliders` WRITE;
/*!40000 ALTER TABLE `sliders` DISABLE KEYS */;
INSERT INTO `sliders` VALUES
(1,'Let’s Enjoy Your Trip With Rehltna',NULL,NULL,'استمتع بتجربة سفر مميزة مع رحلتنا','/uploads/tenant_1/general/69b03d8219765_1773157762_general.webp',NULL,NULL,'/uploads/tenant_1/general/69b03d8219765_1773157762_general.webp',1,'https://google.com','1','استمتع بتجربة سفر مميزة مع رحلتنا','Let’s Enjoy Your Trip With Rehltna',NULL,NULL,'/uploads/tenant_1/general/69b03d8201c59_1773157762_general.webp','\"اكتشف آفاقًا جديدة معنا. عِش الراحة والمغامرة ورحلات لا تُنسى. اكتشف التوازن المثالي بين الاسترخاء والإثارة في كل رحلة.\"','\"Explore new horizons with us. Experience comfort, adventure, and unforgettable journeys. Discover the perfect balance between relaxation and excitement on every trip.\"',NULL,NULL,'استمتع بتجربة سفر مميزة مع رحلتنا','Let’s Enjoy Your Trip With Rehltna',NULL,NULL,'2026-03-10 21:54:01','2026-03-30 18:00:15',NULL),
(2,'Uncover Your Next Adventure Trip',NULL,NULL,'\"اكتشف مغامرتك القادمة\"','/uploads/tenant_1/general/69b03d821860b_1773157762_general.webp',NULL,NULL,'/uploads/tenant_1/general/69b03d821860b_1773157762_general.webp',1,'https://youtu.be','2','اكتشف مغامرتك القادمة','Uncover Your Next Adventure Trip',NULL,NULL,'/uploads/tenant_1/general/69b03d8217b09_1773157762_general.webp','\"انطلق في رحلات لا تُنسى مليئة بالمغامرة والاكتشاف. دع كل رحلة تمنحك تجارب جديدة وذكريات تدوم.\"','\"Embark on unforgettable journeys filled with adventure and discovery. Let every trip bring new experiences and lasting memories.\"',NULL,NULL,'\"انطلق في رحلات لا تُنسى مليئة بالمغامرة والاكتشاف. دع كل رحلة تمنحك تجارب جديدة وذكريات تدوم.\"','\"Embark on unforgettable journeys filled with adventure and discovery. Let every trip bring new experiences and lasting memories.\"',NULL,NULL,'2026-03-10 23:02:17','2026-03-10 23:02:17',NULL);
/*!40000 ALTER TABLE `sliders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `states`
--

DROP TABLE IF EXISTS `states`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `states` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `country_id` bigint(20) unsigned DEFAULT NULL,
  `title_en` varchar(191) NOT NULL,
  `title_ar` varchar(191) NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `states_country_id_foreign` (`country_id`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `states`
--

LOCK TABLES `states` WRITE;
/*!40000 ALTER TABLE `states` DISABLE KEYS */;
INSERT INTO `states` VALUES
(1,1,'cairo','القاهره',1,'2026-03-12 18:50:43','2026-03-12 18:50:43'),
(2,3,'Istanboul','اسطنبول',1,'2026-03-19 16:37:01','2026-03-19 16:37:01'),
(3,3,'Bursa','بورصة',1,'2026-03-19 16:37:47','2026-03-19 16:37:47'),
(4,3,'Sapanca','صبنجة',1,'2026-03-19 16:38:24','2026-03-19 16:38:24');
/*!40000 ALTER TABLE `states` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `subscribes`
--

DROP TABLE IF EXISTS `subscribes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `subscribes` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `email` varchar(191) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `subscribes_email_unique` (`email`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `subscribes`
--

LOCK TABLES `subscribes` WRITE;
/*!40000 ALTER TABLE `subscribes` DISABLE KEYS */;
INSERT INTO `subscribes` VALUES
(1,'123medoabdo@gmail.com','2026-03-11 02:51:15','2026-03-11 02:51:15',NULL);
/*!40000 ALTER TABLE `subscribes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tenants`
--

DROP TABLE IF EXISTS `tenants`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tenants` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(191) NOT NULL,
  `image` text NOT NULL,
  `db_host` varchar(191) NOT NULL DEFAULT '127.0.0.1',
  `db_port` varchar(191) NOT NULL DEFAULT '3306',
  `db_name` varchar(191) NOT NULL,
  `db_username` varchar(191) NOT NULL,
  `db_password` varchar(191) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `options` text DEFAULT 'home,social_integration,blogs,offers,ai_settings,sitemaps,items,jobs,contact,payment_methods,coupons,orders,subscribes,sliders,portfolios,custom_pages,testimonials,leads,settings,failed_jobs,events,events_galleries,news,members,disease_types,patients,residencies,protocols,clinical_publications,register_users',
  `site_url` text DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tenants`
--

LOCK TABLES `tenants` WRITE;
/*!40000 ALTER TABLE `tenants` DISABLE KEYS */;
INSERT INTO `tenants` VALUES
(1,'Rehltna','rehltna.jpeg','127.0.0.1','3306','rehltwoz_rehltna','rehltwoz_rehltna','~{xEmcj6X+4d','2026-03-10 20:50:30','2026-04-18 20:40:46','home,social_integration,blogs,ai_settings,sitemaps,items,contact,payment_methods,orders,subscribes,sliders,events_galleries,residency_users,custom_pages,testimonials,images_uploader,settings,countries,states,cities,failed_jobs,packages,coupons,notifications,notification_templates,employees,role_permissions','https://rehltna.albab-company.com/',NULL);
/*!40000 ALTER TABLE `tenants` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `testimonials`
--

DROP TABLE IF EXISTS `testimonials`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `testimonials` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(191) NOT NULL,
  `email` varchar(191) DEFAULT NULL,
  `image` varchar(191) DEFAULT NULL,
  `testimonial` text NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `stars` int(11) NOT NULL DEFAULT 5,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `testimonials`
--

LOCK TABLES `testimonials` WRITE;
/*!40000 ALTER TABLE `testimonials` DISABLE KEYS */;
INSERT INTO `testimonials` VALUES
(1,'Mohamed Abdul Azeem','123medoabdo@gmail.com','/uploads/tenant_1/general/69b32503b20f6_1773348099_general.jpeg','<p>الشركه دي صح الصح والناس دي صح الصح والكبده دي صح الصح</p>',1,'2026-03-13 02:42:12','2026-04-20 02:00:33','2026-04-20 02:00:33',5),
(2,'Mohamed Abdel azeem','123medoabdo@gmail.com','/uploads/tenant_1/general/69b32503b20f6_1773348099_general.jpeg','<p>الناس دي صح الصح والشركه مريحه في التعامل</p>',1,'2026-03-13 02:42:52','2026-03-16 19:02:12','2026-03-16 19:02:12',4),
(3,'ali hassan','123medoabdo@gmail.com','/uploads/tenant_1/general/69b3257847da2_1773348216_general.png','<p>السلام عليكم ادامكم الله بالصحه والعافيه&nbsp;</p>',1,'2026-03-13 02:43:42','2026-03-13 02:43:42',NULL,5),
(4,'سعد القحطاني','medoabdo@gmail.com','/uploads/tenant_1/general/69b325bb09802_1773348283_general.webp','<p>الشركه مره كويسه ومريحه كفو والله</p>',1,'2026-03-13 02:44:48','2026-03-13 02:44:48',NULL,4),
(5,'محمد','123medoabdo@gmail.com','uploads/tenant_1/testimonials/69b42a6b88f91_1773415019_testimonial.jpg','بببببببببببببببب',1,'2026-03-13 21:16:59','2026-03-16 18:58:17','2026-03-16 18:58:17',5),
(6,'مدحت','123medoabdo@gmail.com','uploads/tenant_1/testimonials/69b42e2512874_1773415973_testimonial.jpg','ناس كويسه',1,'2026-03-13 21:32:53','2026-03-16 18:58:17','2026-03-16 18:58:17',5),
(7,'عععععع','123medoabdo@gmail.com','uploads/tenant_1/testimonials/69b42e8565c21_1773416069_testimonial.jpg','عععععععععععع',1,'2026-03-13 21:34:29','2026-03-16 18:58:17','2026-03-16 18:58:17',5),
(8,'uuuu','123medoabdo@gmail.com',NULL,'gggggggggggggggggggg',1,'2026-03-13 21:36:35','2026-03-25 18:54:52','2026-03-25 18:54:52',5);
/*!40000 ALTER TABLE `testimonials` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `type_offers`
--

DROP TABLE IF EXISTS `type_offers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `type_offers` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `title_en` varchar(191) DEFAULT NULL,
  `title_de` varchar(191) DEFAULT NULL,
  `title_fr` varchar(191) DEFAULT NULL,
  `title_ar` varchar(191) DEFAULT NULL,
  `short_description_en` text DEFAULT NULL,
  `short_description_de` text DEFAULT NULL,
  `short_description_fr` text DEFAULT NULL,
  `short_description_ar` text DEFAULT NULL,
  `meta_title_ar` varchar(191) DEFAULT NULL,
  `meta_title_en` varchar(191) DEFAULT NULL,
  `meta_title_de` varchar(191) DEFAULT NULL,
  `meta_title_fr` varchar(191) DEFAULT NULL,
  `meta_img` text DEFAULT NULL,
  `meta_description_ar` text DEFAULT NULL,
  `meta_description_en` text DEFAULT NULL,
  `meta_description_de` text DEFAULT NULL,
  `meta_description_fr` text DEFAULT NULL,
  `meta_keywords_ar` text DEFAULT NULL,
  `meta_keywords_en` text DEFAULT NULL,
  `meta_keywords_de` text DEFAULT NULL,
  `meta_keywords_fr` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `type_offers`
--

LOCK TABLES `type_offers` WRITE;
/*!40000 ALTER TABLE `type_offers` DISABLE KEYS */;
/*!40000 ALTER TABLE `type_offers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(191) NOT NULL,
  `email` varchar(191) NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(191) NOT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `role` enum('admin','user') NOT NULL DEFAULT 'admin',
  `role_id` bigint(20) unsigned DEFAULT NULL,
  `tenant_id` bigint(20) unsigned DEFAULT NULL,
  `tour_step` varchar(191) DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `fcm_token` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_email_unique` (`email`),
  KEY `users_tenant_id_foreign` (`tenant_id`),
  KEY `users_role_id_foreign` (`role_id`)
) ENGINE=MyISAM AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES
(1,'Admin Rehltna Panel','admin@rehltna-panel.com','2026-04-18 20:40:46','$2y$12$XjgzZ5fukfiQlLKQqOQi/usVosxlE56evG0yUsNo9Byg5XiLTmngO',NULL,'2026-03-10 20:50:31','2026-04-18 20:40:46','admin',1,1,NULL,NULL,NULL),
(2,'moahmed','123medoabdo@gmail.com',NULL,'$2y$12$yMT1hQVxgUjP9lUGDX6ySezbFbY.AIam8tSLT2MXESamun/DR7w7S',NULL,'2026-03-25 21:54:43','2026-03-25 21:54:43','user',2,1,NULL,NULL,NULL),
(3,'medhat','medhat.kortam@gmail.com',NULL,'$2y$12$JajISEHlFSABs3clkqqZN.q.u67pu.jQ14icIQIvif9MISDe7cSDG',NULL,'2026-04-20 01:13:28','2026-04-20 01:13:28','user',2,1,NULL,NULL,NULL),
(4,'habiba@gmail.com','habiba@gmail.com',NULL,'$2y$12$z0ZwPlS.40QgUxZ8O47mFOAt4UTxD31rBbNzDJEkJMbCdvzaIwM92',NULL,'2026-04-20 01:14:07','2026-04-20 01:14:07','user',2,1,NULL,NULL,NULL),
(5,'amira@gmail.com','amira@gmail',NULL,'$2y$12$TyPcpUzImApKddSf0QbqTugnzHo5KOsxoCAGlVrX3sRiFwZsYXJaq',NULL,'2026-04-20 01:14:37','2026-04-20 01:14:37','user',2,1,NULL,NULL,NULL),
(6,'mostafa@rehltna-panel.com','mostafa@gmail.com',NULL,'$2y$12$JhNUPXDHZuATYijbA7RC6ODxEkOVyV5DKFKE/ruOS35wf/EvFUN2u',NULL,'2026-04-21 02:23:05','2026-04-21 02:23:05','user',2,1,NULL,NULL,NULL),
(7,'Sahar','sahar@gmail.com',NULL,'$2y$12$I4vbeb5YyiAQ0Ypdy9EPyOA4uZt6F.edvXE/0YA.EMQnVlmm4y2mS',NULL,'2026-04-21 02:23:38','2026-04-21 02:23:38','user',2,1,NULL,NULL,NULL);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*M!100616 SET NOTE_VERBOSITY=@OLD_NOTE_VERBOSITY */;

-- Dump completed on 2026-04-27  6:47:21
