# 王双媛聊天模块开发说明

## 一、模块目标

聊天模块用于支持前端商品详情页底部的“联系商家”功能。

用户在商品详情页点击“联系商家”后，后端根据当前用户和商品卖家创建或复用一条聊天会话，前端再跳转到聊天页，通过会话 ID 拉取消息、发送消息、标记已读。

本模块实现的是平台内聊天，不展示手机号，不依赖电话联系。

## 二、代码位置

```text
backend/internal/chat/
backend/cmd/server/main.go
backend/scripts/sql/schema.sql
```

新增模块文件：

```text
backend/internal/chat/model.go
backend/internal/chat/repository.go
backend/internal/chat/service.go
backend/internal/chat/handler.go
backend/internal/chat/router.go
```

## 三、关联数据表

### 3.1 chat_conversations

`chat_conversations` 是聊天会话表，表示“某个买家和某个卖家围绕某个商品建立的一条聊天”。

主要用途：

- 支持聊天列表展示。
- 记录商品、买家、卖家三者关系。
- 记录最后一条消息摘要。
- 记录买家和卖家的未读数量。

核心字段：

```text
id                    会话 ID
product_id            商品 ID
buyer_id              买家用户 ID
seller_id             卖家用户 ID
last_message_id       最后一条消息 ID
last_message_content  最后一条消息内容
last_message_time     最后一条消息时间
buyer_unread_count    买家未读数
seller_unread_count   卖家未读数
buyer_hidden_at        买家隐藏会话时间，NULL 表示买家侧可见
seller_hidden_at       卖家隐藏会话时间，NULL 表示卖家侧可见
status                会话状态，ACTIVE / CLOSED
```

唯一约束：

```text
product_id + buyer_id + seller_id 唯一
```

这样可以避免同一个买家对同一个商品重复创建多个会话。

隐藏字段说明：

- `buyer_hidden_at` / `seller_hidden_at` 只控制某一方聊天列表是否显示该会话。
- 用户删除聊天会话时只设置自己一侧的隐藏时间，不删除会话和聊天消息。
- 隐藏状态不影响另一方，也不代表会话业务关闭。
- 若会话仍为 `ACTIVE`，且对方成功发送新消息，系统应清空接收方对应的隐藏时间，使会话重新出现在接收方聊天列表中。

### 3.2 chat_messages

`chat_messages` 是聊天消息表，表示某条会话中的每一条具体消息。

主要用途：

- 存储聊天框中的消息记录。
- 记录发送人、接收人、消息内容、已读状态。

核心字段：

```text
id               消息 ID
conversation_id  会话 ID
sender_id        发送人 ID
receiver_id      接收人 ID
content          消息内容
message_type     消息类型，目前为 TEXT
read_status      已读状态，UNREAD / READ
create_time      发送时间
```

## 四、接口列表

聊天模块统一路由前缀：

```text
/chat
```

所有接口都需要：

```text
登录 JWT
学生认证 auth_status = VERIFIED
账号正常 account_status = NORMAL
```

### 4.1 创建或获取会话

```http
POST /chat/conversations
```

请求体：

```json
{
  "productId": 12
}
```

业务规则：

- 当前用户必须登录并完成学生认证。
- 商品必须存在。
- 原则上只有 `ON_SALE` 商品允许创建新会话。
- 商品为 `LOCKED`、`OFF_SHELF`、`SOLD`、`DELETED` 时不能创建新会话。
- 当前用户不能联系自己发布的商品。
- 如果会话已经存在，直接返回已有会话。
- 如果会话不存在，创建新会话。

返回示例：

```json
{
  "id": 5,
  "productId": 12,
  "buyerId": 8,
  "sellerId": 3,
  "buyerUnreadCount": 0,
  "sellerUnreadCount": 0,
  "status": "ACTIVE",
  "createTime": "2026-06-03 15:20:00",
  "updateTime": "2026-06-03 15:20:00"
}
```

前端使用方式：

```text
商品详情页点击“联系商家”
-> POST /chat/conversations
-> 取返回的 id
-> 跳转 /pages/chat/chat?conversationId=id
```

### 4.2 查询我的会话列表

```http
GET /chat/conversations?page=1&pageSize=20
```

返回字段说明：

```text
productTitle          商品标题
productImage          商品首图
targetUserId          对方用户 ID
targetNickname        对方昵称
lastMessageContent    最后一条消息
lastMessageTime       最后聊天时间
unreadCount           当前登录用户的未读数
```

返回示例：

```json
{
  "items": [
    {
      "id": 5,
      "productId": 12,
      "buyerId": 8,
      "sellerId": 3,
      "lastMessageContent": "你好，这个还在吗？",
      "lastMessageTime": "2026-06-03 15:22:00",
      "buyerUnreadCount": 0,
      "sellerUnreadCount": 1,
      "status": "ACTIVE",
      "productTitle": "高等数学教材",
      "productImage": "/uploads/product/demo.jpg",
      "targetUserId": 3,
      "targetNickname": "卖家昵称",
      "unreadCount": 0
    }
  ],
  "total": 1,
  "page": 1,
  "pageSize": 20
}
```

### 4.3 查询会话消息

```http
GET /chat/conversations/:id/messages?page=1&pageSize=30
```

业务规则：

- 当前用户必须是该会话的买家或卖家。
- 非会话参与人访问返回 `403 permission denied`。

返回示例：

```json
{
  "items": [
    {
      "id": 101,
      "conversationId": 5,
      "senderId": 8,
      "receiverId": 3,
      "content": "你好，这个还在吗？",
      "messageType": "TEXT",
      "readStatus": "UNREAD",
      "createTime": "2026-06-03 15:22:00"
    }
  ],
  "total": 1,
  "page": 1,
  "pageSize": 30
}
```

### 4.4 发送消息

```http
POST /chat/conversations/:id/messages
```

请求体：

```json
{
  "content": "你好，这个商品还在吗？"
}
```

业务规则：

- 当前用户必须是该会话的买家或卖家。
- 会话状态必须是 `ACTIVE`。
- 已建立会话能否继续发送消息由 `chat_conversations.status` 决定，不因商品后续变为 `LOCKED`、`SOLD` 或 `OFF_SHELF` 而自动禁止发送消息。
- 会话变为 `CLOSED` 后，只允许查看历史消息，不允许继续发送。
- 消息内容不能为空。
- 消息内容最多 500 个字符。
- 后端自动判断接收人。
- 插入消息后自动更新会话最后消息和对方未读数。
- 如果接收方此前隐藏了该会话，发送成功后应清空接收方对应的 `hidden_at`。

返回示例：

```json
{
  "id": 101,
  "conversationId": 5,
  "senderId": 8,
  "receiverId": 3,
  "content": "你好，这个商品还在吗？",
  "messageType": "TEXT",
  "readStatus": "UNREAD",
  "createTime": "2026-06-03 15:22:00"
}
```

### 4.5 标记会话已读

```http
PUT /chat/conversations/:id/read
```

业务规则：

- 当前用户必须是该会话的买家或卖家。
- 将当前用户作为接收人的未读消息改为 `READ`。
- 清空当前用户在该会话中的未读数。

返回示例：

```json
{
  "read": true,
  "count": 2
}
```

`count` 表示本次被标记为已读的消息数量。

### 4.6 删除/隐藏会话

```http
DELETE /chat/conversations/:id
```

业务规则：

- 当前用户必须是该会话的买家或卖家。
- 删除会话只隐藏当前用户一侧，不物理删除 `chat_conversations`。
- 不删除 `chat_messages` 中的聊天消息。
- 不影响另一方聊天列表。
- 当前用户是买家时设置 `buyer_hidden_at = NOW()`，并清空 `buyer_unread_count`。
- 当前用户是卖家时设置 `seller_hidden_at = NOW()`，并清空 `seller_unread_count`。
- 不修改 `status`。`status=CLOSED` 表示业务关闭，不表示用户删除会话。

返回示例：

```json
{
  "deleted": true
}
```

会话列表过滤规则：

```text
买家视角：buyer_hidden_at IS NULL
卖家视角：seller_hidden_at IS NULL
```

重新显示规则：

```text
若会话仍为 ACTIVE，且对方成功发送新消息，系统清空接收方对应的 hidden_at。
```

当前版本不提供单条聊天消息删除，也不提供清空聊天记录。聊天消息保留用于纠纷、举报、申诉和后续后台排查。

## 五、权限设计

### 5.1 登录与认证

路由注册时使用：

```go
group.Use(authMiddleware, verifiedMiddleware)
```

因此聊天接口要求：

```text
必须登录
必须完成学生认证
账号状态必须 NORMAL
```

### 5.2 会话权限

会话访问统一校验：

```text
conversation.buyer_id == currentUserId
或
conversation.seller_id == currentUserId
```

非会话参与人不能：

- 查看消息。
- 发送消息。
- 标记已读。

### 5.3 商品限制

创建会话时限制：

```text
不能联系自己的商品
商品不存在不能创建
商品 LOCKED / OFF_SHELF / SOLD / DELETED 不能创建新会话
```

### 5.4 商品状态、会话状态和隐藏状态分离

聊天模块采用商品状态、会话状态和用户隐藏状态相互分离的控制方式。

- 商品状态控制能否创建新会话。原则上只有 `ON_SALE` 商品允许买家发起新会话；商品 `LOCKED`、`SOLD`、`OFF_SHELF` 或 `DELETED` 后，不再允许其他用户新建会话。
- `chat_conversations.status` 控制已有会话能否继续发送消息。`ACTIVE` 状态允许买卖双方继续沟通，不因商品后续变为 `LOCKED`、`SOLD` 或 `OFF_SHELF` 而自动禁止发送；`CLOSED` 状态只允许查看历史消息，不允许继续发送。
- `buyer_hidden_at` / `seller_hidden_at` 控制会话是否在当前用户聊天列表中显示。隐藏是“我不想看见”，`CLOSED` 是“双方不能再聊”。

## 六、和现有 messages 模块的区别

`messages` 模块用于系统通知，例如：

- 订单创建通知。
- 订单确认通知。
- 举报处理通知。
- 系统公告通知。

`chat` 模块用于用户之间的连续聊天，例如：

- 商品详情页联系商家。
- 买家和卖家围绕商品沟通。
- 聊天列表和聊天框展示。

两者不建议合并。

## 七、前端联调建议

商品详情页按钮：

```text
联系商家
```

点击后调用：

```http
POST /chat/conversations
```

拿到返回：

```text
data.id
```

跳转聊天页：

```text
/pages/chat/chat?conversationId=5
```

聊天页进入后：

```text
GET /chat/conversations/:id/messages
PUT /chat/conversations/:id/read
```

发送消息：

```text
POST /chat/conversations/:id/messages
```

聊天列表页：

```text
GET /chat/conversations
```

## 八、后续可扩展点

当前版本只支持文本消息。

后续可以扩展：

- 图片消息。
- 商品卡片消息。
- 订单卡片消息。
- WebSocket 实时推送。
- 消息撤回。
- 屏蔽用户。
- 管理员查看违规聊天记录。

当前第一版先使用 HTTP 轮询或进入页面刷新消息即可。
