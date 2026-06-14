package user

import (
	"context"
	"database/sql"
	"errors"
	"fmt"
)

func (r *Repository) FindPublicProfile(ctx context.Context, userID uint64) (*PublicProfile, error) {
	var item PublicProfile
	var authStatus, accountStatus string
	if err := r.db.QueryRowContext(ctx, `
		SELECT id, nickname, avatar_url, auth_status, account_status
		FROM users
		WHERE id = ?
		  AND is_deleted = 0
		  AND account_status IN ('NORMAL', 'DISABLED')
		LIMIT 1
	`, userID).Scan(&item.ID, &item.Nickname, &item.AvatarURL, &authStatus, &accountStatus); err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			return nil, nil
		}
		return nil, fmt.Errorf("find public profile: %w", err)
	}
	item.AuthStatus = authStatus
	item.TradeAvailable = accountStatus == accountStatusNormal
	return &item, nil
}

func (r *Repository) PublicHomepageStats(ctx context.Context, userID uint64) (PublicHomepageStats, error) {
	var stats PublicHomepageStats
	if err := r.db.QueryRowContext(ctx, `
		SELECT COUNT(*)
		FROM products
		WHERE seller_id = ? AND status = 'ON_SALE' AND is_deleted = 0
	`, userID).Scan(&stats.OnSaleProductCount); err != nil {
		return PublicHomepageStats{}, fmt.Errorf("count public homepage products: %w", err)
	}
	if err := r.db.QueryRowContext(ctx, `
		SELECT COUNT(*)
		FROM orders
		WHERE seller_id = ? AND status = 'COMPLETED'
	`, userID).Scan(&stats.CompletedOrderCount); err != nil {
		return PublicHomepageStats{}, fmt.Errorf("count public homepage completed orders: %w", err)
	}

	var averageRating sql.NullFloat64
	if err := r.db.QueryRowContext(ctx, `
		SELECT COUNT(*), AVG(rating)
		FROM reviews
		WHERE seller_id = ? AND status = 'NORMAL' AND is_deleted = 0
	`, userID).Scan(&stats.ReviewReceivedCount, &averageRating); err != nil {
		return PublicHomepageStats{}, fmt.Errorf("count public homepage reviews: %w", err)
	}
	if averageRating.Valid {
		stats.AverageRating = &averageRating.Float64
	}
	return stats, nil
}

func (r *Repository) ListPublicHomepageProducts(ctx context.Context, userID uint64, page, pageSize int) ([]UserProductItem, int, error) {
	const whereSQL = " WHERE p.seller_id = ? AND p.status = 'ON_SALE' AND p.is_deleted = 0"
	var total int
	if err := r.db.QueryRowContext(ctx, "SELECT COUNT(*) FROM products p"+whereSQL, userID).Scan(&total); err != nil {
		return nil, 0, fmt.Errorf("count public homepage products: %w", err)
	}
	rows, err := r.db.QueryContext(ctx, `
SELECT p.id, p.title, p.price, p.status, p.view_count, p.favorite_count,
       DATE_FORMAT(p.create_time, '%Y-%m-%d %H:%i:%s'),
       (SELECT image_url FROM product_images pi WHERE pi.product_id = p.id ORDER BY pi.sort_order, pi.id LIMIT 1)
FROM products p`+whereSQL+`
ORDER BY p.create_time DESC, p.id DESC
LIMIT ? OFFSET ?`, userID, pageSize, (page-1)*pageSize)
	if err != nil {
		return nil, 0, fmt.Errorf("list public homepage products: %w", err)
	}
	defer rows.Close()

	items := make([]UserProductItem, 0)
	for rows.Next() {
		var item UserProductItem
		if err := rows.Scan(&item.ID, &item.Title, &item.Price, &item.Status, &item.ViewCount, &item.FavoriteCount, &item.CreateTime, &item.ImageURL); err != nil {
			return nil, 0, fmt.Errorf("scan public homepage product: %w", err)
		}
		items = append(items, item)
	}
	if err := rows.Err(); err != nil {
		return nil, 0, fmt.Errorf("iterate public homepage products: %w", err)
	}
	return items, total, nil
}

func (r *Repository) FindRestriction(ctx context.Context, userID uint64) (*Restriction, error) {
	var item Restriction
	if err := r.db.QueryRowContext(ctx, `SELECT account_status FROM users WHERE id = ? LIMIT 1`, userID).Scan(&item.AccountStatus); err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			return nil, nil
		}
		return nil, fmt.Errorf("find account restriction: %w", err)
	}
	if item.AccountStatus != accountStatusDisabled && item.AccountStatus != accountStatusBanned {
		return &item, nil
	}

	var relatedID sql.NullInt64
	var operationType, reason, relatedType, createTime sql.NullString
	err := r.db.QueryRowContext(ctx, `
		SELECT operation_type, description, related_type, related_id,
		       DATE_FORMAT(create_time, '%Y-%m-%d %H:%i:%s')
		FROM admin_logs
		WHERE target_type = 'USER'
		  AND target_id = ?
		  AND operation_type IN ('USER_DISABLE', 'USER_BAN')
		ORDER BY create_time DESC, id DESC
		LIMIT 1
	`, userID).Scan(&operationType, &reason, &relatedType, &relatedID, &createTime)
	if err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			return &item, nil
		}
		return nil, fmt.Errorf("find restriction reason: %w", err)
	}
	item.OperationType = nullStringPtr(operationType)
	item.Reason = nullStringPtr(reason)
	item.RelatedType = nullStringPtr(relatedType)
	item.CreateTime = nullStringPtr(createTime)
	if relatedID.Valid {
		value := uint64(relatedID.Int64)
		item.RelatedID = &value
	}
	return &item, nil
}
