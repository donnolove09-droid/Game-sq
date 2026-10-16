#import <UIKit/UIKit.h>

static NSString * const kAvatarURL = @"https://i.ibb.co/vxBgZzCS/60892235-5-A0-C-4558-AD38-47-C6873-C11-F4.png";
static UIImageView *gAvatarView = nil;
static BOOL gDidReplace = NO;

static void FindAndReplace99(UIView *view) {
    if (!view || gDidReplace) return;

    for (UIView *sub in view.subviews) {
        // Nhận diện nút 99
        if (sub.layer.cornerRadius >= 8.0 && sub.layer.borderWidth >= 1.0) {
            
            // Xóa nội dung cũ
            for (UIView *child in [sub.subviews copy]) {
                [child removeFromSuperview];
            }
            
            if ([sub isKindOfClass:[UIButton class]]) {
                UIButton *btn = (UIButton *)sub;
                [btn setTitle:nil forState:UIControlStateNormal];
                [btn setImage:nil forState:UIControlStateNormal];
                [btn setBackgroundImage:nil forState:UIControlStateNormal];
            }

            // Tạo avatar
            if (!gAvatarView) {
                gAvatarView = [[UIImageView alloc] initWithFrame:sub.bounds];
                gAvatarView.contentMode = UIViewContentModeScaleAspectFill;
                gAvatarView.clipsToBounds = YES;
                gAvatarView.layer.cornerRadius = sub.bounds.size.width / 2.0;
                gAvatarView.userInteractionEnabled = YES;
                gAvatarView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

                // Load ảnh
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:kAvatarURL]];
                    if (data) {
                        UIImage *img = [UIImage imageWithData:data];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            gAvatarView.image = img;
                        });
                    }
                });
            }

            gAvatarView.frame = sub.bounds;
            [sub addSubview:gAvatarView];

            // === QUAN TRỌNG: Giữ hành vi bấm mở menu ===
            // Chuyển touch từ avatar về nút gốc
            gAvatarView.userInteractionEnabled = NO;   // để touch đi xuyên xuống nút gốc
            sub.userInteractionEnabled = YES;

            gDidReplace = YES;
            return;
        }
        
        FindAndReplace99(sub);
    }
}

%hook UIApplication

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    BOOL result = %orig;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (UIWindow *window in [UIApplication sharedApplication].windows) {
            FindAndReplace99(window);
        }
    });
    
    return result;
}

%end

%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (!gDidReplace) {
            for (UIWindow *window in [UIApplication sharedApplication].windows) {
                FindAndReplace99(window);
            }
        }
    });
}
