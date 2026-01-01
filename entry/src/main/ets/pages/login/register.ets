import { router, promptAction } from '@kit.ArkUI';

@Entry
@Component
export struct RegisterPage {
  // 注册所需状态变量
  @State userName: string = '' // 用户名
  @State account: string = '' // 账号
  @State password: string = '' // 密码
  @State confirmPassword: string = '' // 重复密码
  @State gender: string = '' // 性别（男/女）
  @State passwordState: boolean = false // 密码显示状态
  @State confirmPwdState: boolean = false // 重复密码显示状态
  @State isAgreeProtocol: boolean = false // 协议勾选状态

  build() {
    Column() {
      // Logo区域：居中显示，增加底部间距，视觉更舒展
      Image($r('app.media.login'))
        .width(250)
        .height(240)
        .alignSelf(ItemAlign.Center) // 强制居中，适配不同屏幕
        .margin({ bottom: 30 }) // 增加底部间距，与输入框区域分隔更清晰

      // 输入框区域：统一包裹，规整对齐，间距统一
      Column({ space: 20 }) { // 统一设置输入框之间的间距，替代单独margin
        // 1. 用户名输入框：增加内边距，文字不贴边
        TextInput({
          placeholder: '请输入您的用户名'
        })
          .width('100%')
          .height(40)
          .padding({ left: 15, right: 15 }) // 新增内边距，输入体验更好
          .backgroundColor('#fff')
          .borderRadius(20)
          .onChange((value: string) => {
            this.userName = value;
          })

        // 2. 账号输入框：与用户名样式完全统一
        TextInput({
          placeholder: '请输入您的账号'
        })
          .width('100%')
          .height(40)
          .padding({ left: 15, right: 15 })
          .backgroundColor('#fff')
          .borderRadius(20)
          .onChange((value: string) => {
            this.account = value;
          })

        // 3. 密码输入框：保留原有功能，增加内边距
        TextInput({
          placeholder: '请输入您的密码'
        })
          .placeholderColor('#666')
          .width('100%')
          .height(40)
          .padding({ left: 15, right: 15 })
          .backgroundColor('#fff')
          .borderRadius(20)
          .type(InputType.Password)
          .maxLength(9)
          .showPasswordIcon(true)
          .showPassword(this.passwordState)
          .onSecurityStateChange(((isShowPassword: boolean) => {
            this.passwordState = isShowPassword
          }))
          .onChange((value: string) => {
            this.password = value;
          })

        // 4. 重复密码输入框：样式统一，增加内边距
        TextInput({
          placeholder: '请再次输入您的密码'
        })
          .placeholderColor('#666')
          .width('100%')
          .height(40)
          .padding({ left: 15, right: 15 })
          .backgroundColor('#fff')
          .borderRadius(20)
          .type(InputType.Password)
          .maxLength(9)
          .showPasswordIcon(true)
          .showPassword(this.confirmPwdState)
          .onSecurityStateChange(((isShowPassword: boolean) => {
            this.confirmPwdState = isShowPassword
          }))
          .onChange((value: string) => {
            this.confirmPassword = value;
          })
      }
      .width('100%') // 输入框区域撑满父容器，对齐更规整
      .margin({ bottom: 20 }) // 与性别选择区域分隔

      // 5. 性别选择：优化间距，对齐更美观，区分度更高
      Row() {
        Text('性别：')
          .fontSize(14)
          .fontWeight(FontWeight.Medium) // 加粗标题，区分度更高
          .fontColor('#333') // 加深字体颜色，更醒目
          .margin({ right: 15 }) // 调整与单选框的间距

        // 男性单选框：优化与文本的间距
        Radio({ value: 'male', group: 'genderGroup' })
          .checked(false)
          .margin({ right: 8 }) // 单选框与文字间距更合理
          .onChange((checked: boolean) => {
            if (checked) {
              this.gender = '男';
            }
          })
        Text('男')
          .fontSize(14)
          .fontColor('#666')
          .margin({ right: 40 }) // 调整男女选项的间距

        // 女性单选框：优化与文本的间距
        Radio({ value: 'female', group: 'genderGroup' })
          .checked(false)
          .margin({ right: 8 })
          .onChange((checked: boolean) => {
            if (checked) {
              this.gender = '女';
            }
          })
        Text('女')
          .fontSize(14)
          .fontColor('#666')
      }
      .alignItems(VerticalAlign.Center)
      .width('100%')
      .justifyContent(FlexAlign.Start) // 靠左对齐，更规整
      .margin({ bottom: 20 }) // 与协议勾选区域分隔

      // 协议勾选：优化对齐，防止文本溢出
      Row() {
        Checkbox()
          .width(14) // 适当放大复选框，更易点击
          .height(14)
          .margin({ top: 3, right: 10 }) // 优化与文本的间距，对齐更精准
          .onChange((checked: boolean) => {
            this.isAgreeProtocol = checked;
          })
        Text() {
          Span('我已经阅读同意')
          Span('《心情记录》').fontColor('#3274f6')
          Span('《心情记录用户服务协议》').fontColor('#3274f6')
        }
        .fontSize(12)
        .fontColor('#666')
        .lineHeight(20)
        .maxLines(2) // 限制最大行数，防止文本溢出屏幕
        .textAlign(TextAlign.Start)
      }
      .alignItems(VerticalAlign.Center) // 垂直居中，更美观
      .width('100%')
      .margin({ bottom: 25 }) // 与注册按钮分隔更清晰

      // 注册按钮：优化样式，增加点击反馈（视觉）
      Button('注册')
        .width('100%')
        .height(45) // 适当加高按钮，更易点击
        .fontSize(16) // 加大字体，更醒目
        .fontColor("black")
        .backgroundColor("#D7EDA2")
        .borderRadius(22) // 圆角与按钮高度匹配，更圆润
        .margin({ bottom: 20 })
        .onClick(() => {
          // 原有校验逻辑不变
          if (!this.validateRequiredFields()) {
            return;
          }
          if (!this.validatePasswordConsistency()) {
            return;
          }
          if (!this.isAgreeProtocol) {
            promptAction.showToast({
              message: '请先阅读并同意用户协议',
              duration: 2000,
            });
            return;
          }

          promptAction.showToast({
            message: '注册成功！',
            duration: 2000,
          });
          console.log('注册成功，账号：', this.account, '用户名：', this.userName);
          this.navigateToLoginPage();
        })

      // 返回登录链接：优化样式，增加点击反馈
      Text('已有账号？返回登录')
        .fontSize(14)
        .fontColor('#3274f6')
        .alignSelf(ItemAlign.Center) // 居中显示，更美观
        .margin({ bottom: 40 })
        .onClick(() => {
          this.navigateToLoginPage();
        })
        .gesture(
          TapGesture()
            .onAction(() => {}) // 空手势，提升点击体验
        )

      // 填充组件：自动填充空白，让底部布局更均衡
      Blank()

    }
    .padding(25) // 适当加大页面内边距，更舒展
    .width('100%')
    .height('100%')
    .backgroundColor('#f8f8f8') // 新增页面背景色，避免纯白单调
  }

  // 校验必填字段（原有逻辑不变）
  validateRequiredFields(): boolean {
    if (!this.userName.trim()) {
      promptAction.showToast({
        message: '请输入用户名',
        duration: 2000,
      });
      return false;
    }
    if (!this.account.trim()) {
      promptAction.showToast({
        message: '请输入账号',
        duration: 2000,
      });
      return false;
    }
    if (!this.password.trim()) {
      promptAction.showToast({
        message: '请输入密码',
        duration: 2000,
      });
      return false;
    }
    if (!this.confirmPassword.trim()) {
      promptAction.showToast({
        message: '请再次输入密码',
        duration: 2000,
      });
      return false;
    }
    if (!this.gender) {
      promptAction.showToast({
        message: '请选择性别',
        duration: 2000,
      });
      return false;
    }
    return true;
  }

  // 校验密码与重复密码是否一致（原有逻辑不变）
  validatePasswordConsistency(): boolean {
    if (this.password !== this.confirmPassword) {
      promptAction.showToast({
        message: '两次输入的密码不一致',
        duration: 2000,
      });
      console.error('密码与重复密码不一致');
      return false;
    }
    return true;
  }

  // 跳转回登录页（原有逻辑不变）
  navigateToLoginPage() {
    try {
      const trimmedUserName = this.userName.trim();
      const trimmedAccount = this.account.trim();
      const trimmedPassword = this.password.trim();

      // 核心修改：将所有注册数据存入 AppStorage 全局存储
      // 用户基本信息
      AppStorage.Set('globalUserName', trimmedUserName);   // 用户名
      AppStorage.Set('globalAccount', trimmedAccount);     // 账号
      AppStorage.Set('globalGender', this.gender);         // 性别
      AppStorage.Set('globalPassword', trimmedPassword);   // 密码

      // 我的页面需要的额外信息
      AppStorage.Set('currentLoginUserName', trimmedUserName);  // 当前登录用户名
      AppStorage.Set('currentLoginAccount', trimmedAccount);    // 当前登录账号
      AppStorage.Set('currentLoginGender', this.gender);        // 当前登录性别

      // 注册后默认未登录，需用户手动登录
      AppStorage.Set('globalIsLogin', false);

      console.log('注册数据已全局存储：', {
        userName: trimmedUserName,
        account: trimmedAccount,
        gender: this.gender
      });

      // 跳转登录页
      router.pushUrl({ url: 'pages/login/login' });
      console.log('注册数据已全局存储，跳转登录页成功');
    } catch (error) {
      console.error('跳转登录页失败：', error);
      promptAction.showToast({
        message: '跳转失败，请检查配置',
        duration: 2000,
      });
    }
  }
}