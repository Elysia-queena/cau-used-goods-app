-- ============================================================
-- CAU 二手交易平台：二级分类 + 敏感词初始化脚本（增强版）
-- 适用数据库：MySQL 5.7+
-- 适用库名：cau_used_goods
--
-- 使用方式：
--   mysql -u root -p cau_used_goods < scripts\sql\seed_categories_sensitive_words_v2.sql
--
-- 说明：
--   1. 会先保证一级分类存在，再插入更完整的二级分类；
--   2. 使用 ON DUPLICATE KEY UPDATE，重复执行不会重复插入；
--   3. 适配 categories 表唯一键：uk_categories_parent_name(parent_id, name)；
--   4. 适配 sensitive_words 表唯一键：uk_sensitive_words_word(word)；
--   5. create_by 设为 NULL，避免依赖管理员用户 ID。
-- ============================================================

USE `cau_used_goods`;

START TRANSACTION;

-- ============================================================
-- 一、一级分类初始化
-- ============================================================

INSERT INTO `categories` (`name`, `parent_id`, `sort_order`, `status`)
VALUES
  ('教材资料', 0, 10, 'ENABLED'),
  ('电子产品', 0, 20, 'ENABLED'),
  ('生活用品', 0, 30, 'ENABLED'),
  ('服饰鞋包', 0, 40, 'ENABLED'),
  ('运动户外', 0, 50, 'ENABLED'),
  ('其他', 0, 999, 'ENABLED')
ON DUPLICATE KEY UPDATE
  `sort_order` = VALUES(`sort_order`),
  `status` = VALUES(`status`),
  `update_time` = CURRENT_TIMESTAMP;

SET @cat_books := (SELECT `id` FROM `categories` WHERE `parent_id` = 0 AND `name` = '教材资料' LIMIT 1);
SET @cat_electronics := (SELECT `id` FROM `categories` WHERE `parent_id` = 0 AND `name` = '电子产品' LIMIT 1);
SET @cat_life := (SELECT `id` FROM `categories` WHERE `parent_id` = 0 AND `name` = '生活用品' LIMIT 1);
SET @cat_clothing := (SELECT `id` FROM `categories` WHERE `parent_id` = 0 AND `name` = '服饰鞋包' LIMIT 1);
SET @cat_sports := (SELECT `id` FROM `categories` WHERE `parent_id` = 0 AND `name` = '运动户外' LIMIT 1);
SET @cat_other := (SELECT `id` FROM `categories` WHERE `parent_id` = 0 AND `name` = '其他' LIMIT 1);

-- ============================================================
-- 二、二级分类初始化（增强版：每个一级分类 10 个左右）
-- ============================================================

-- 1. 教材资料
INSERT INTO `categories` (`name`, `parent_id`, `sort_order`, `status`)
VALUES
  ('公共课教材', @cat_books, 101, 'ENABLED'),
  ('专业课教材', @cat_books, 102, 'ENABLED'),
  ('考研资料', @cat_books, 103, 'ENABLED'),
  ('考证资料', @cat_books, 104, 'ENABLED'),
  ('外语学习', @cat_books, 105, 'ENABLED'),
  ('课程笔记', @cat_books, 106, 'ENABLED'),
  ('实验报告资料', @cat_books, 107, 'ENABLED'),
  ('课外读物', @cat_books, 108, 'ENABLED'),
  ('教辅习题', @cat_books, 109, 'ENABLED'),
  ('打印复印资料', @cat_books, 110, 'ENABLED')
ON DUPLICATE KEY UPDATE
  `sort_order` = VALUES(`sort_order`),
  `status` = VALUES(`status`),
  `update_time` = CURRENT_TIMESTAMP;

-- 2. 电子产品
INSERT INTO `categories` (`name`, `parent_id`, `sort_order`, `status`)
VALUES
  ('手机通讯', @cat_electronics, 201, 'ENABLED'),
  ('电脑笔记本', @cat_electronics, 202, 'ENABLED'),
  ('平板设备', @cat_electronics, 203, 'ENABLED'),
  ('耳机音响', @cat_electronics, 204, 'ENABLED'),
  ('相机摄影', @cat_electronics, 205, 'ENABLED'),
  ('键盘鼠标', @cat_electronics, 206, 'ENABLED'),
  ('充电器线材', @cat_electronics, 207, 'ENABLED'),
  ('存储设备', @cat_electronics, 208, 'ENABLED'),
  ('智能穿戴', @cat_electronics, 209, 'ENABLED'),
  ('数码配件', @cat_electronics, 210, 'ENABLED')
ON DUPLICATE KEY UPDATE
  `sort_order` = VALUES(`sort_order`),
  `status` = VALUES(`status`),
  `update_time` = CURRENT_TIMESTAMP;

-- 3. 生活用品
INSERT INTO `categories` (`name`, `parent_id`, `sort_order`, `status`)
VALUES
  ('宿舍用品', @cat_life, 301, 'ENABLED'),
  ('学习文具', @cat_life, 302, 'ENABLED'),
  ('收纳整理', @cat_life, 303, 'ENABLED'),
  ('台灯照明', @cat_life, 304, 'ENABLED'),
  ('小家电', @cat_life, 305, 'ENABLED'),
  ('厨具餐具', @cat_life, 306, 'ENABLED'),
  ('清洁用品', @cat_life, 307, 'ENABLED'),
  ('床上用品', @cat_life, 308, 'ENABLED'),
  ('美妆个护', @cat_life, 309, 'ENABLED'),
  ('日用杂物', @cat_life, 310, 'ENABLED')
ON DUPLICATE KEY UPDATE
  `sort_order` = VALUES(`sort_order`),
  `status` = VALUES(`status`),
  `update_time` = CURRENT_TIMESTAMP;

-- 4. 服饰鞋包
INSERT INTO `categories` (`name`, `parent_id`, `sort_order`, `status`)
VALUES
  ('男装', @cat_clothing, 401, 'ENABLED'),
  ('女装', @cat_clothing, 402, 'ENABLED'),
  ('鞋靴', @cat_clothing, 403, 'ENABLED'),
  ('箱包', @cat_clothing, 404, 'ENABLED'),
  ('帽子围巾', @cat_clothing, 405, 'ENABLED'),
  ('手表饰品', @cat_clothing, 406, 'ENABLED'),
  ('正装礼服', @cat_clothing, 407, 'ENABLED'),
  ('运动服饰', @cat_clothing, 408, 'ENABLED'),
  ('校服院服', @cat_clothing, 409, 'ENABLED'),
  ('其他配饰', @cat_clothing, 410, 'ENABLED')
ON DUPLICATE KEY UPDATE
  `sort_order` = VALUES(`sort_order`),
  `status` = VALUES(`status`),
  `update_time` = CURRENT_TIMESTAMP;

-- 5. 运动户外
INSERT INTO `categories` (`name`, `parent_id`, `sort_order`, `status`)
VALUES
  ('球类用品', @cat_sports, 501, 'ENABLED'),
  ('健身器材', @cat_sports, 502, 'ENABLED'),
  ('户外装备', @cat_sports, 503, 'ENABLED'),
  ('骑行装备', @cat_sports, 504, 'ENABLED'),
  ('运动护具', @cat_sports, 505, 'ENABLED'),
  ('瑜伽舞蹈', @cat_sports, 506, 'ENABLED'),
  ('游泳用品', @cat_sports, 507, 'ENABLED'),
  ('校园代步', @cat_sports, 508, 'ENABLED'),
  ('运动鞋服', @cat_sports, 509, 'ENABLED'),
  ('露营旅行', @cat_sports, 510, 'ENABLED')
ON DUPLICATE KEY UPDATE
  `sort_order` = VALUES(`sort_order`),
  `status` = VALUES(`status`),
  `update_time` = CURRENT_TIMESTAMP;

-- 6. 其他
INSERT INTO `categories` (`name`, `parent_id`, `sort_order`, `status`)
VALUES
  ('票券卡券', @cat_other, 901, 'ENABLED'),
  ('虚拟资料', @cat_other, 902, 'ENABLED'),
  ('乐器器材', @cat_other, 903, 'ENABLED'),
  ('宠物用品', @cat_other, 904, 'ENABLED'),
  ('手工艺品', @cat_other, 905, 'ENABLED'),
  ('模型玩具', @cat_other, 906, 'ENABLED'),
  ('活动周边', @cat_other, 907, 'ENABLED'),
  ('租借服务', @cat_other, 908, 'ENABLED'),
  ('闲置赠送', @cat_other, 909, 'ENABLED'),
  ('其他闲置', @cat_other, 999, 'ENABLED')
ON DUPLICATE KEY UPDATE
  `sort_order` = VALUES(`sort_order`),
  `status` = VALUES(`status`),
  `update_time` = CURRENT_TIMESTAMP;

-- ============================================================
-- 三、敏感词初始化（增强版）
-- word_type:
--   FORBIDDEN：禁止发布，命中后应阻断提交
--   RISK：风险提示，可进入审核或提示用户修改
-- ============================================================

INSERT INTO `sensitive_words` (`word`, `word_type`, `status`, `create_by`)
VALUES
  -- 交易安全/诈骗风险
  ('私下交易', 'RISK', 'ENABLED', NULL),
  ('线下转账', 'RISK', 'ENABLED', NULL),
  ('先款后货', 'RISK', 'ENABLED', NULL),
  ('先付定金', 'RISK', 'ENABLED', NULL),
  ('提前打款', 'RISK', 'ENABLED', NULL),
  ('加微信交易', 'RISK', 'ENABLED', NULL),
  ('加QQ交易', 'RISK', 'ENABLED', NULL),
  ('绕过平台', 'RISK', 'ENABLED', NULL),
  ('不走平台', 'RISK', 'ENABLED', NULL),
  ('保证赚钱', 'RISK', 'ENABLED', NULL),
  ('稳赚不赔', 'RISK', 'ENABLED', NULL),
  ('内部渠道', 'RISK', 'ENABLED', NULL),
  ('低价代购', 'RISK', 'ENABLED', NULL),
  ('刷单', 'FORBIDDEN', 'ENABLED', NULL),
  ('刷信誉', 'FORBIDDEN', 'ENABLED', NULL),
  ('套现', 'FORBIDDEN', 'ENABLED', NULL),
  ('洗钱', 'FORBIDDEN', 'ENABLED', NULL),
  ('跑分', 'FORBIDDEN', 'ENABLED', NULL),
  ('薅羊毛项目', 'RISK', 'ENABLED', NULL),

  -- 账号/证件/隐私类
  ('身份证出售', 'FORBIDDEN', 'ENABLED', NULL),
  ('学生证出售', 'FORBIDDEN', 'ENABLED', NULL),
  ('校园卡出售', 'FORBIDDEN', 'ENABLED', NULL),
  ('银行卡出售', 'FORBIDDEN', 'ENABLED', NULL),
  ('电话卡出售', 'FORBIDDEN', 'ENABLED', NULL),
  ('手机号出售', 'FORBIDDEN', 'ENABLED', NULL),
  ('账号买卖', 'FORBIDDEN', 'ENABLED', NULL),
  ('游戏账号买卖', 'RISK', 'ENABLED', NULL),
  ('代实名', 'FORBIDDEN', 'ENABLED', NULL),
  ('代认证', 'FORBIDDEN', 'ENABLED', NULL),
  ('个人信息出售', 'FORBIDDEN', 'ENABLED', NULL),
  ('隐私照片', 'FORBIDDEN', 'ENABLED', NULL),

  -- 学术诚信类
  ('代写论文', 'FORBIDDEN', 'ENABLED', NULL),
  ('代写作业', 'FORBIDDEN', 'ENABLED', NULL),
  ('代做作业', 'FORBIDDEN', 'ENABLED', NULL),
  ('代考试', 'FORBIDDEN', 'ENABLED', NULL),
  ('替考', 'FORBIDDEN', 'ENABLED', NULL),
  ('论文代发', 'FORBIDDEN', 'ENABLED', NULL),
  ('毕业设计代做', 'FORBIDDEN', 'ENABLED', NULL),
  ('实验报告代写', 'FORBIDDEN', 'ENABLED', NULL),
  ('课程设计代做', 'FORBIDDEN', 'ENABLED', NULL),
  ('包过考试', 'FORBIDDEN', 'ENABLED', NULL),
  ('答案出售', 'FORBIDDEN', 'ENABLED', NULL),
  ('考试答案', 'FORBIDDEN', 'ENABLED', NULL),

  -- 平台禁售/风险商品类
  ('处方药', 'FORBIDDEN', 'ENABLED', NULL),
  ('违禁药品', 'FORBIDDEN', 'ENABLED', NULL),
  ('管制刀具', 'FORBIDDEN', 'ENABLED', NULL),
  ('仿真枪', 'FORBIDDEN', 'ENABLED', NULL),
  ('烟草', 'FORBIDDEN', 'ENABLED', NULL),
  ('香烟', 'FORBIDDEN', 'ENABLED', NULL),
  ('电子烟', 'FORBIDDEN', 'ENABLED', NULL),
  ('酒水转让', 'FORBIDDEN', 'ENABLED', NULL),
  ('白酒转让', 'FORBIDDEN', 'ENABLED', NULL),
  ('彩票', 'FORBIDDEN', 'ENABLED', NULL),
  ('博彩', 'FORBIDDEN', 'ENABLED', NULL),
  ('赌博', 'FORBIDDEN', 'ENABLED', NULL),
  ('成人用品', 'FORBIDDEN', 'ENABLED', NULL),
  ('危险化学品', 'FORBIDDEN', 'ENABLED', NULL),
  ('宠物活体', 'RISK', 'ENABLED', NULL),

  -- 侵权/盗版类
  ('盗版软件', 'FORBIDDEN', 'ENABLED', NULL),
  ('破解软件', 'FORBIDDEN', 'ENABLED', NULL),
  ('破解版', 'FORBIDDEN', 'ENABLED', NULL),
  ('盗版课程', 'FORBIDDEN', 'ENABLED', NULL),
  ('破解网课', 'FORBIDDEN', 'ENABLED', NULL),
  ('盗版电子书', 'FORBIDDEN', 'ENABLED', NULL),
  ('盗版教材', 'FORBIDDEN', 'ENABLED', NULL),
  ('外挂', 'FORBIDDEN', 'ENABLED', NULL),
  ('游戏外挂', 'FORBIDDEN', 'ENABLED', NULL),
  ('盗号工具', 'FORBIDDEN', 'ENABLED', NULL),

  -- 违规金融/贷款类
  ('校园贷', 'FORBIDDEN', 'ENABLED', NULL),
  ('高利贷', 'FORBIDDEN', 'ENABLED', NULL),
  ('裸贷', 'FORBIDDEN', 'ENABLED', NULL),
  ('借贷中介', 'FORBIDDEN', 'ENABLED', NULL),
  ('贷款套现', 'FORBIDDEN', 'ENABLED', NULL),
  ('信用卡套现', 'FORBIDDEN', 'ENABLED', NULL),

  -- 虚假宣传/服务风险类
  ('包过', 'RISK', 'ENABLED', NULL),
  ('全网最低', 'RISK', 'ENABLED', NULL),
  ('假一赔十', 'RISK', 'ENABLED', NULL),
  ('无理由退款保证', 'RISK', 'ENABLED', NULL),
  ('绝对正品', 'RISK', 'ENABLED', NULL),
  ('官方内部价', 'RISK', 'ENABLED', NULL),
  ('低价秒杀', 'RISK', 'ENABLED', NULL),
  ('限时返利', 'RISK', 'ENABLED', NULL),

  -- 人身攻击/不文明用语
  ('傻逼', 'FORBIDDEN', 'ENABLED', NULL),
  ('垃圾人', 'RISK', 'ENABLED', NULL),
  ('滚蛋', 'RISK', 'ENABLED', NULL),
  ('骗子死全家', 'FORBIDDEN', 'ENABLED', NULL),
  ('脑残', 'RISK', 'ENABLED', NULL),
  ('废物', 'RISK', 'ENABLED', NULL),
  ('去死', 'FORBIDDEN', 'ENABLED', NULL),
  ('辱骂', 'RISK', 'ENABLED', NULL)
ON DUPLICATE KEY UPDATE
  `word_type` = VALUES(`word_type`),
  `status` = VALUES(`status`),
  `update_time` = CURRENT_TIMESTAMP;

COMMIT;

-- ============================================================
-- 四、验证语句
-- ============================================================

SELECT
  p.`id` AS parent_id,
  p.`name` AS parent_name,
  c.`id` AS child_id,
  c.`name` AS child_name,
  c.`sort_order`,
  c.`status`
FROM `categories` p
LEFT JOIN `categories` c ON c.`parent_id` = p.`id`
WHERE p.`parent_id` = 0
ORDER BY p.`sort_order`, c.`sort_order`;

SELECT
  `word_type`,
  `status`,
  COUNT(*) AS word_count
FROM `sensitive_words`
GROUP BY `word_type`, `status`
ORDER BY `word_type`, `status`;
