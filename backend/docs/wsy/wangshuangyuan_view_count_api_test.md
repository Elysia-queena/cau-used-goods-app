# 商品浏览量接口测试说明

## 一、测试范围

本说明用于测试商品详情接口的浏览量统计逻辑：

```http
GET /products/:id
```

本次重点验证：

- 买家首次访问在售商品，浏览量增加；
- 同一用户 1 小时内重复访问同一商品，浏览量不重复增加；
- 未认证普通用户访问在售商品，浏览量增加；
- 卖家本人访问自己的商品，浏览量不增加；
- 管理员访问商品，浏览量不增加；
- 未登录请求可以查看商品详情，但浏览量不增加；
- 非在售或已删除商品不增加浏览量。

## 二、测试前准备

### 2.1 启动后端服务

确保后端服务已启动，默认地址：

```text
http://127.0.0.1:8080
```

以下 PowerShell 示例统一使用：

```powershell
$baseUrl = "http://127.0.0.1:8080"
```

### 2.2 准备测试商品

在数据库中查询一个在售商品：

```sql
SELECT id, seller_id, title, status, is_deleted, view_count
FROM products
WHERE status = 'ON_SALE' AND is_deleted = 0
LIMIT 5;
```

记录：

```text
productId = 商品 id
sellerId = 商品 seller_id
beforeViewCount = 当前 view_count
```

后续示例假设：

```text
productId = 7
sellerId = 3
```

实际测试时请替换为本地数据库中的真实 ID。

### 2.3 准备测试账号

至少需要以下账号：

| 账号类型 | 要求 |
| --- | --- |
| 买家账号 | 普通用户，不能是该商品卖家 |
| 未认证账号 | 普通用户，`auth_status` 不是 `VERIFIED`，不能是该商品卖家 |
| 卖家账号 | 用户 ID 等于该商品 `seller_id` |
| 管理员账号 | `role` 为 `ADMIN` 或 `SUPER_ADMIN` |

如果使用开发登录接口，可参考：

```powershell
$buyerLogin = Invoke-RestMethod `
  -Method Post `
  -Uri "$baseUrl/auth/dev-login" `
  -ContentType "application/json" `
  -Body '{"openid":"dev_buyer_view_count_001","role":"USER"}'

$buyerToken = $buyerLogin.data.token
$buyerHeaders = @{ Authorization = "Bearer $buyerToken" }
```

管理员账号示例：

```powershell
$adminLogin = Invoke-RestMethod `
  -Method Post `
  -Uri "$baseUrl/auth/dev-login" `
  -ContentType "application/json" `
  -Body '{"openid":"dev_admin_view_count_001","role":"ADMIN"}'

$adminToken = $adminLogin.data.token
$adminHeaders = @{ Authorization = "Bearer $adminToken" }
```

说明：如果本地开发登录接口不可用，请使用项目实际登录流程获取 token。

## 三、辅助 SQL

### 3.1 查询商品浏览量

```sql
SELECT id, seller_id, title, status, is_deleted, view_count
FROM products
WHERE id = 7;
```

### 3.2 查询浏览历史

```sql
SELECT id, user_id, product_id, create_time
FROM browse_history
WHERE product_id = 5
ORDER BY create_time DESC;
```

### 3.3 清理某个用户的浏览历史

为了重复验证“首次访问增加浏览量”，可在本地测试数据库中清理指定记录：

```sql
DELETE FROM browse_history
WHERE user_id = 用户ID AND product_id = 7;
```

注意：只建议在本地测试数据库执行，不要在生产数据中执行。

## 四、测试用例

### TC-01 买家首次访问在售商品，浏览量增加

请求：

```powershell
Invoke-RestMethod `
  -Method Get `
  -Uri "$baseUrl/products/7" `
  -Headers $buyerHeaders
```

预期结果：

- 接口返回成功；
- 返回商品详情；
- `products.view_count` 比请求前增加 1；
- `browse_history` 新增一条该买家访问该商品的记录。

验证 SQL：

```sql
SELECT id, view_count
FROM products
WHERE id = 7;

SELECT id, user_id, product_id, create_time
FROM browse_history
WHERE product_id = 7
ORDER BY create_time DESC;
```

### TC-02 同一买家 1 小时内重复访问，不重复增加

连续再次请求：

```powershell
Invoke-RestMethod `
  -Method Get `
  -Uri "$baseUrl/products/7" `
  -Headers $buyerHeaders
```

预期结果：

- 接口返回成功；
- `products.view_count` 不变；
- `browse_history` 不新增新的有效记录。

### TC-03 未认证普通用户访问，浏览量增加

使用未认证普通用户 token 请求：

```powershell
Invoke-RestMethod `
  -Method Get `
  -Uri "$baseUrl/products/7" `
  -Headers $unverifiedHeaders
```

预期结果：

- 接口返回成功；
- 如果该用户 1 小时内未浏览过该商品，则 `products.view_count + 1`；
- `browse_history` 新增该用户的浏览记录。

说明：未认证用户在当前业务中相当于游客浏览行为，因此可以计入浏览量。

### TC-04 卖家本人访问自己的商品，浏览量不增加

使用该商品卖家的 token 请求：

```powershell
Invoke-RestMethod `
  -Method Get `
  -Uri "$baseUrl/products/7" `
  -Headers $sellerHeaders
```

预期结果：

- 接口返回成功；
- `products.view_count` 不变；
- `browse_history` 不新增该卖家访问该商品的记录。

### TC-05 管理员访问商品，浏览量不增加

使用管理员 token 请求：

```powershell
Invoke-RestMethod `
  -Method Get `
  -Uri "$baseUrl/products/7" `
  -Headers $adminHeaders
```

预期结果：

- 接口返回成功；
- `products.view_count` 不变；
- `browse_history` 不新增管理员访问该商品的记录。

### TC-06 未登录访问商品详情，浏览量不增加

不携带 token 请求：

```powershell
Invoke-RestMethod `
  -Method Get `
  -Uri "$baseUrl/products/7"
```

预期结果：

- 接口返回成功；
- 商品详情可正常查看；
- `products.view_count` 不变；
- `browse_history` 不新增记录。

### TC-07 访问非在售商品，浏览量不增加

先准备一个非在售商品，例如：

```sql
SELECT id, status, is_deleted, view_count
FROM products
WHERE status <> 'ON_SALE' OR is_deleted = 1
LIMIT 5;
```

请求：

```powershell
Invoke-RestMethod `
  -Method Get `
  -Uri "$baseUrl/products/非在售商品ID" `
  -Headers $buyerHeaders
```

预期结果：

- 普通详情接口返回不可用或 404；
- `products.view_count` 不变；
- `browse_history` 不新增记录。


## 五、注意事项

- 测试时要使用真实存在的商品 ID 和用户 token。
- 买家、未认证用户、卖家、管理员必须是不同测试身份。
- 如果同一用户已经在 1 小时内浏览过商品，需要清理 `browse_history` 或更换测试用户。
