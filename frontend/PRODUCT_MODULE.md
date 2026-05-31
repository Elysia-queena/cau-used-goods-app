# 商品流前端模块说明

## 已实现范围

- 首页：搜索入口、分类入口、商品卡片列表、触底分页、下拉刷新。
- 搜索结果页：关键词、分类、价格区间、成色、排序、分页和空状态。
- 商品详情页：图片轮播、商品信息、面交地点、卖家脱敏信息、收藏/举报/预约入口。
- 发布页：表单校验、最多 9 张图片、单图 5 MB 限制、图片删除、AI 标题优化、AI 描述生成。
- 数据层：Pinia 商品状态、统一 API 封装、mock 数据和真实后端切换开关。

消息页和个人页目前只提供底部导航占位，用于保证商品流页面可以独立运行。订单预约、收藏、举报和用户中心的真实业务由对应模块接入。

## 本地运行

```bash
npm install
npm run dev:h5
```

构建微信小程序：

```bash
npm run dev:mp-weixin
```

然后使用微信开发者工具导入 `dist/dev/mp-weixin`。

## Mock 与后端联调

开发阶段默认启用 mock 数据：

```js
// src/config/index.js
export const USE_MOCK = true
```

后端接口准备完成后，将其改为 `false`，并修改：

```js
export const API_BASE_URL = 'http://localhost:8080/api'
```

真机调试时不能直接使用 `localhost`，需要替换为可访问的 HTTPS 地址或局域网地址，并根据微信小程序要求配置合法域名。

## 期望后端接口

```text
GET  /categories
GET  /products
GET  /products/:id
POST /products
POST /upload/products
POST /ai/optimize-title
POST /ai/generate-description
```

商品列表查询参数：

```text
keyword
categoryId
minPrice
maxPrice
conditionLevel
sort
page
pageSize
```

统一响应结构：

```json
{
  "code": 0,
  "message": "success",
  "data": {},
  "timestamp": "2026-05-31 12:00:00",
  "requestId": "optional"
}
```

## 待组内确认

1. 首页是否展示 `LOCKED` 商品。目前 mock 中会展示，并禁用预约入口。
2. 图片上传接口是否直接返回 `imageUrl`。当前发布流程先上传图片，再提交 URL 数组。
3. AI 接口供应商和最终字段名。页面已按“失败不影响手动发布”处理。
4. 预约、收藏和举报页面的最终跳转路径，由其他成员提供后替换详情页中的占位提示。
