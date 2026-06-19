# 商品图片删除与替换接口测试说明

## 1. 测试范围

本文档用于规范测试商品图片相关的两个接口：

```http
DELETE /products/:id/images/:imageId
PUT    /products/:id/images
```

接口说明：

- 删除单张图片：按图片 ID 删除某个商品下的一张图片。
- 替换图片：清空商品原有图片，并按请求体中的图片 URL 列表重新写入。

## 2. 基础信息

- 后端基础地址：`http://127.0.0.1:8080`
- 数据格式：`application/json`
- 鉴权方式：JWT Token
- 权限要求：登录用户 + 已完成学生认证
- 业务权限：只能操作自己发布的商品

请求头示例：

```http
Authorization: Bearer <token>
Content-Type: application/json
```

PowerShell 公共变量：

```powershell
$baseUrl = "http://127.0.0.1:8080"
$token = "这里替换为卖家用户token"
$headers = @{
  Authorization = "Bearer $token"
  "Content-Type" = "application/json"
}
```

## 3. 测试前准备

### 3.1 准备测试商品

测试商品需要满足：

- 商品存在；
- `is_deleted = 0`；
- 商品状态不是 `SOLD`、`DELETED`；
- 当前 token 对应用户是商品卖家；
- 当前用户已完成学生认证。

查询可用商品：

```sql
SELECT id, seller_id, title, status, is_deleted
FROM products
WHERE is_deleted = 0
  AND status IN ('ON_SALE', 'OFF_SHELF', 'LOCKED')
ORDER BY id DESC
LIMIT 10;
```

后续示例假设：

```text
productId = 6
sellerId = 当前登录用户ID
```

实际测试时请替换成本地真实数据。

### 3.2 准备图片 URL

可以先通过上传图片接口获取图片 URL：

```powershell
Invoke-RestMethod `
  -Method Post `
  -Uri "$baseUrl/upload/image" `
  -Headers @{ Authorization = "Bearer $token" } `
  -Form @{ file = Get-Item "C:\Users\Public\Pictures\test.png" }
```

也可以使用已经存在的图片 URL，例如：

```text
/uploads/products/test1.jpg
/uploads/products/test2.jpg
/uploads/products/test3.jpg
```

### 3.3 绑定初始图片

如果商品没有图片，可先绑定图片：

```powershell
Invoke-RestMethod `
  -Method Post `
  -Uri "$baseUrl/products/6/images" `
  -Headers $headers `
  -Body '{"images":["/uploads/products/test1.jpg","/uploads/products/test2.jpg"]}'
```

查询图片记录：

```sql
SELECT id, product_id, image_url, sort_order, create_time
FROM product_images
WHERE product_id = 6
ORDER BY sort_order ASC, id ASC;
```

记录其中一个 `id` 作为 `imageId`。

## 4. 删除单张图片接口

### 4.1 接口说明

```http
DELETE /products/:id/images/:imageId
```

路径参数：

| 参数 | 类型 | 必填 | 说明 |
| --- | --- | --- | --- |
| `id` | number | 是 | 商品 ID |
| `imageId` | number | 是 | 商品图片 ID |

请求体：无。

成功返回：

```json
{
  "code": 0,
  "message": "success",
  "data": {
    "id": 6,
    "imageId": 12
  }
}
```

### 4.2 TC-DI-01 删除自己的商品图片成功

前置条件：

- 当前 token 对应用户是商品卖家；
- 商品状态不是 `SOLD`、`DELETED`；
- `product_images` 中存在 `product_id = 6` 且 `id = 12` 的图片。

请求：

```powershell
Invoke-RestMethod `
  -Method Delete `
  -Uri "$baseUrl/products/6/images/12" `
  -Headers $headers
```

预期结果：

- HTTP 状态码为 200；
- `code = 0`；
- 返回的 `id = 6`；
- 返回的 `imageId = 12`；
- 数据库中该图片记录被删除。

验证 SQL：

```sql
SELECT id, product_id, image_url
FROM product_images
WHERE id = 12 AND product_id = 6;
```

预期查询结果为空。

### 4.3 TC-DI-02 删除不存在的图片失败

请求：

```powershell
Invoke-RestMethod `
  -Method Delete `
  -Uri "$baseUrl/products/6/images/999999" `
  -Headers $headers
```

预期结果：

- 请求失败；
- 返回错误响应；
- 商品原有图片不变。

### 4.4 TC-DI-03 非卖家删除图片失败

使用非卖家用户 token：

```powershell
$otherHeaders = @{
  Authorization = "Bearer 非卖家用户token"
  "Content-Type" = "application/json"
}

Invoke-RestMethod `
  -Method Delete `
  -Uri "$baseUrl/products/6/images/12" `
  -Headers $otherHeaders
```

预期结果：

- 请求失败；
- 返回无权限相关错误；
- 数据库图片记录不变。

### 4.5 TC-DI-04 未登录删除图片失败

请求：

```powershell
Invoke-RestMethod `
  -Method Delete `
  -Uri "$baseUrl/products/6/images/12"
```

预期结果：

- 返回 401；
- 图片记录不变。

### 4.6 TC-DI-05 商品已售出或删除时删除图片失败

前置条件：

- 商品状态为 `SOLD` 或 `DELETED`。

请求：

```powershell
Invoke-RestMethod `
  -Method Delete `
  -Uri "$baseUrl/products/6/images/12" `
  -Headers $headers
```

预期结果：

- 请求失败；
- 图片记录不变。

## 5. 替换图片接口

### 5.1 接口说明

```http
PUT /products/:id/images
```

路径参数：

| 参数 | 类型 | 必填 | 说明 |
| --- | --- | --- | --- |
| `id` | number | 是 | 商品 ID |

请求体：

| 参数 | 类型 | 必填 | 说明 |
| --- | --- | --- | --- |
| `images` | string[] | 是 | 新图片 URL 列表，最多 9 张 |

请求示例：

```json
{
  "images": [
    "/uploads/products/test-new-1.jpg",
    "/uploads/products/test-new-2.jpg"
  ]
}
```

成功返回：

```json
{
  "code": 0,
  "message": "success",
  "data": {
    "id": 6,
    "images": [
      "/uploads/products/test-new-1.jpg",
      "/uploads/products/test-new-2.jpg"
    ]
  }
}
```

### 5.2 TC-RI-01 替换自己的商品图片成功

前置条件：

- 当前 token 对应用户是商品卖家；
- 商品状态不是 `SOLD`、`DELETED`。

请求：

```powershell
Invoke-RestMethod `
  -Method Put `
  -Uri "$baseUrl/products/6/images" `
  -Headers $headers `
  -Body '{"images":["/uploads/products/test-new-1.jpg","/uploads/products/test-new-2.jpg"]}'
```

预期结果：

- HTTP 状态码为 200；
- `code = 0`；
- 返回 `id = 6`；
- 返回 `images` 与请求体一致；
- 数据库中商品原图片全部被删除；
- 数据库中新图片按请求顺序写入；
- `sort_order` 从 0 开始递增。

验证 SQL：

```sql
SELECT id, product_id, image_url, sort_order
FROM product_images
WHERE product_id = 6
ORDER BY sort_order ASC, id ASC;
```

预期结果：

| image_url | sort_order |
| --- | --- |
| `/uploads/products/test-new-1.jpg` | 0 |
| `/uploads/products/test-new-2.jpg` | 1 |

### 5.3 TC-RI-02 替换为空数组成功

说明：当前后端允许 `images` 为空数组，此操作等价于清空商品图片。

请求：

```powershell
Invoke-RestMethod `
  -Method Put `
  -Uri "$baseUrl/products/6/images" `
  -Headers $headers `
  -Body '{"images":[]}'
```

预期结果：

- 接口返回成功；
- 返回 `images = []`；
- `product_images` 中该商品图片记录为空。

验证 SQL：

```sql
SELECT COUNT(*) AS image_count
FROM product_images
WHERE product_id = 6;
```

预期 `image_count = 0`。

### 5.4 TC-RI-03 图片数量超过 9 张失败

请求：

```powershell
Invoke-RestMethod `
  -Method Put `
  -Uri "$baseUrl/products/6/images" `
  -Headers $headers `
  -Body '{"images":["/uploads/products/1.jpg","/uploads/products/2.jpg","/uploads/products/3.jpg","/uploads/products/4.jpg","/uploads/products/5.jpg","/uploads/products/6.jpg","/uploads/products/7.jpg","/uploads/products/8.jpg","/uploads/products/9.jpg","/uploads/products/10.jpg"]}'
```

预期结果：

- 请求失败；
- 返回错误响应；
- 数据库原图片列表不变。

### 5.5 TC-RI-04 请求体格式错误失败

请求：

```powershell
Invoke-RestMethod `
  -Method Put `
  -Uri "$baseUrl/products/6/images" `
  -Headers $headers `
  -Body '{"images":"not-array"}'
```

预期结果：

- 请求失败；
- 返回 `invalid request body`；
- 数据库原图片列表不变。

### 5.6 TC-RI-05 非卖家替换图片失败

请求：

```powershell
Invoke-RestMethod `
  -Method Put `
  -Uri "$baseUrl/products/6/images" `
  -Headers $otherHeaders `
  -Body '{"images":["/uploads/products/other-user.jpg"]}'
```

预期结果：

- 请求失败；
- 返回无权限相关错误；
- 数据库原图片列表不变。

### 5.7 TC-RI-06 未登录替换图片失败

请求：

```powershell
Invoke-RestMethod `
  -Method Put `
  -Uri "$baseUrl/products/6/images" `
  -Headers @{ "Content-Type" = "application/json" } `
  -Body '{"images":["/uploads/products/no-token.jpg"]}'
```

预期结果：

- 返回 401；
- 数据库原图片列表不变。

### 5.8 TC-RI-07 商品已售出或删除时替换图片失败

前置条件：

- 商品状态为 `SOLD` 或 `DELETED`。

请求：

```powershell
Invoke-RestMethod `
  -Method Put `
  -Uri "$baseUrl/products/6/images" `
  -Headers $headers `
  -Body '{"images":["/uploads/products/sold-product.jpg"]}'
```

预期结果：

- 请求失败；
- 数据库原图片列表不变。

## 6. 数据库检查语句

### 6.1 查看商品状态和卖家

```sql
SELECT id, seller_id, title, status, is_deleted
FROM products
WHERE id = 6;
```

### 6.2 查看商品图片

```sql
SELECT id, product_id, image_url, sort_order, create_time
FROM product_images
WHERE product_id = 6
ORDER BY sort_order ASC, id ASC;
```

### 6.3 查看当前用户认证状态

```sql
SELECT id, role, auth_status, account_status, is_deleted
FROM users
WHERE id = 当前用户ID;
```

## 7. 测试结果记录模板

| 用例编号 | 测试内容 | 请求用户 | 预期结果 | 实际结果 | 是否通过 |
| --- | --- | --- | --- | --- | --- |
| TC-DI-01 | 删除自己的商品图片成功 | 卖家 | 成功删除指定图片 |  |  |
| TC-DI-02 | 删除不存在图片 | 卖家 | 失败，图片不变 |  |  |
| TC-DI-03 | 非卖家删除图片 | 非卖家 | 失败，图片不变 |  |  |
| TC-DI-04 | 未登录删除图片 | 无 token | 401，图片不变 |  |  |
| TC-DI-05 | 已售出或删除商品删除图片 | 卖家 | 失败，图片不变 |  |  |
| TC-RI-01 | 替换自己的商品图片成功 | 卖家 | 成功替换图片 |  |  |
| TC-RI-02 | 替换为空数组 | 卖家 | 成功清空图片 |  |  |
| TC-RI-03 | 图片数量超过 9 张 | 卖家 | 失败，图片不变 |  |  |
| TC-RI-04 | 请求体格式错误 | 卖家 | 失败，图片不变 |  |  |
| TC-RI-05 | 非卖家替换图片 | 非卖家 | 失败，图片不变 |  |  |
| TC-RI-06 | 未登录替换图片 | 无 token | 401，图片不变 |  |  |
| TC-RI-07 | 已售出或删除商品替换图片 | 卖家 | 失败，图片不变 |  |  |

## 8. 注意事项

- 删除单张图片使用的是图片表 `product_images.id`，不是图片 URL。
- 替换图片会先删除该商品所有旧图片，再写入新图片列表。
- 替换接口当前允许传入空数组，表示清空商品图片。
- 图片数量最多 9 张。
- 两个接口都要求当前用户是商品卖家，且用户已完成学生认证。
- 商品状态为 `SOLD` 或 `DELETED` 时，不允许删除或替换图片。
