import { router, promptAction } from '@kit.ArkUI';

@Entry
@Component
export struct Index {
  @State passwordState: boolean = false
  @State account: string = '' // 用户当前输入的账号
  @State password: string = '' // 用户当前输入的密码
  @State isAgreeProtocol: boolean = false

  // 核心新增：绑定全局存储的注册账号和密码（自动同步注册数据）
  @StorageProp("globalAccount") registerAccount: string = ""; // 注册时存入的全局账号
  @StorageProp("globalPassword") registerPassword: string = ""; // 注册时存入的全局密码

  build() {
    Column() {
      Image($r('app.media.login'))
        .width(250)
        .height(240)

      Row() {
        TextInput({
          placeholder: '请输入您的账号'
        })
          .layoutWeight(1)
          .backgroundColor('#fff')
          .onChange((value: string) => {
            this.account = value;
          })
      }
      .width('100%')
      .height(40)
      .backgroundColor('#fff')
      .borderRadius(20)

      TextInput({
        placeholder: '请输入您的密码'
      })
        .placeholderColor('#666')
        .height(40)
        .margin({ top: 20 })
        .width('100%')
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

      Row() {
        Checkbox()
          .width(10)
          .margin({ top: 6 })
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
      }
      .alignItems(VerticalAlign.Top)
      .margin({ top: 20 })

      Button('登录')
        .width('100%')
        .fontColor("black")
        .backgroundColor("#D7EDA2")
        .margin({ top: 20 })
        .onClick(() => {
          if (!this.isAgreeProtocol) {
            promptAction.showToast({
              message: '请先阅读并同意用户协议',
              duration: 2000,
            });
            return;
          }

          // 调用修改后的动态校验方法
          if (this.validateCredentials()) {
            this.navigateToNextPage();
          } else {
            promptAction.showToast({
              message: '账号或密码错误（或未注册）',
              duration: 2000
            });
            console.error('账号或密码错误，或用户未注册');
          }
        })

      Row({ space: 15 }) {
        Text('新用户注册').fontSize(14).fontColor('#666')
      }
      .margin({ top: 20 })
      .gesture(
        TapGesture({ count: 1 })
          .onAction(() => {
            router.pushUrl({
              url: 'pages/login/register'
            }).catch((error: Error) => {
              console.error('路由跳转失败:', error.message);
            });
          }))

      Blank()

      Column() {
        Row() {
          Image($r('app.media.Memory_qq')).width(30)
          Image($r('app.media.Memory_weiXin')).width(30).fillColor('#5ea14f')
          Image($r('app.media.Memory_bo')).width(30).fillColor('#5cacf3')
        }
        .margin({ bottom: 2 })
        .justifyContent(FlexAlign.SpaceAround)
        .width('100%')
        Text('其他登录方式')
          .fontSize(14)
          .height(22)
          .fontColor('#666')
          .margin({ bottom: 10 })
      }
      .width('100%')
    }
    .padding(20)
    .width('100%')
    .height('100%')
  }

  // 核心修改：替换原有固定值校验，改为动态比对全局注册数据
  validateCredentials(): boolean {
    // 第一步：先判断是否有注册数据（避免未注册时校验）
    if (!this.registerAccount.trim() || !this.registerPassword.trim()) {
      console.error('暂无注册数据，请先注册');
      return false;
    }

    // 第二步：动态比对当前输入的账号密码 与 全局注册的账号密码
    const inputAccount = this.account.trim();
    const inputPassword = this.password.trim();

    // 比对一致返回true（登录成功），不一致返回false（登录失败）
    return inputAccount === this.registerAccount && inputPassword === this.registerPassword;
  }

  // 原有跳转逻辑不变（登录成功后更新全局登录状态）
  navigateToNextPage() {
    try {
      const trimmedAccount = this.account.trim();

      // 更新全局登录状态为已登录
      AppStorage.Set('globalIsLogin', true);
      // 保存当前登录的账号到全局状态（用于我的页面显示）
      AppStorage.Set('currentLoginAccount', trimmedAccount);
      // 同步全局账号密码（确保一致性）
      AppStorage.Set('globalAccount', trimmedAccount);
      AppStorage.Set('globalPassword', this.password.trim());

      console.log('登录成功，账号保存到全局状态:', trimmedAccount);

      router.pushUrl({ url: 'pages/TabUIPage' });
      console.log('登录成功，跳转首页');
    } catch (error) {
      console.error('跳转失败：', error);
      promptAction.showToast({
        message: '页面跳转失败，请检查配置',
        duration: 2000
      });
    }
  }
}