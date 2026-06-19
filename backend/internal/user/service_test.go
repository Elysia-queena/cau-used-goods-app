package user

import (
	"context"
	"testing"

	"cau-used-goods-app/backend/internal/message"
)

type captureMessageNotifier struct {
	inputs []message.CreateMessageInput
}

func (n *captureMessageNotifier) Create(ctx context.Context, input message.CreateMessageInput) (uint64, error) {
	n.inputs = append(n.inputs, input)
	return uint64(len(n.inputs)), nil
}

func TestNotifyStudentVerificationResultCreatesSystemNotice(t *testing.T) {
	notifier := &captureMessageNotifier{}
	service := &Service{messages: notifier}

	service.notifyStudentVerificationResult(context.Background(), 9, ReviewStudentVerificationInput{
		UserID:      12,
		AuthStatus:  authStatusVerified,
		Description: "学生认证审核通过",
	})

	if len(notifier.inputs) != 1 {
		t.Fatalf("expected 1 message, got %d", len(notifier.inputs))
	}
	got := notifier.inputs[0]
	if got.ReceiverID != 12 {
		t.Fatalf("ReceiverID = %d, want 12", got.ReceiverID)
	}
	if got.SenderID == nil || *got.SenderID != 9 {
		t.Fatalf("SenderID = %v, want 9", got.SenderID)
	}
	if got.MessageType != message.MessageTypeSystemNotice {
		t.Fatalf("MessageType = %q, want %q", got.MessageType, message.MessageTypeSystemNotice)
	}
	if got.Title != "学生认证审核结果" {
		t.Fatalf("Title = %q", got.Title)
	}
	if got.Content != "你的学生认证已通过，现在可以正常使用发布、收藏、预约和举报等功能。" {
		t.Fatalf("Content = %q", got.Content)
	}
	if got.RelatedType == nil || *got.RelatedType != message.RelatedTypeUser {
		t.Fatalf("RelatedType = %v, want USER", got.RelatedType)
	}
	if got.RelatedID == nil || *got.RelatedID != 12 {
		t.Fatalf("RelatedID = %v, want 12", got.RelatedID)
	}
}

func TestBuildStudentVerificationResultContent(t *testing.T) {
	tests := []struct {
		name        string
		authStatus  string
		description string
		want        string
	}{
		{
			name:        "verified default",
			authStatus:  authStatusVerified,
			description: "学生认证审核通过",
			want:        "你的学生认证已通过，现在可以正常使用发布、收藏、预约和举报等功能。",
		},
		{
			name:        "verified custom",
			authStatus:  authStatusVerified,
			description: "资料真实有效",
			want:        "你的学生认证已通过。资料真实有效",
		},
		{
			name:        "rejected with reason",
			authStatus:  authStatusRejected,
			description: "学号照片不清晰",
			want:        "你的学生认证未通过。学号照片不清晰",
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got := buildStudentVerificationResultContent(tt.authStatus, tt.description)
			if got != tt.want {
				t.Fatalf("content = %q, want %q", got, tt.want)
			}
		})
	}
}

func TestNotifyStudentVerificationResultSkipsMissingNotifier(t *testing.T) {
	service := &Service{}
	service.notifyStudentVerificationResult(context.Background(), 9, ReviewStudentVerificationInput{
		UserID:      12,
		AuthStatus:  authStatusRejected,
		Description: "资料不完整",
	})
}
