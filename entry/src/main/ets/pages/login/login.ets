
import { router, promptAction } from '@kit.ArkUI';

@Entry
@Component
export struct Index {
  @State passwordState: boolean = false
  @State account: string = ''
  @State password: string = ''
  // 新增：协议勾选状态（默认未勾选）
  @State isAgreeProtocol: boolean = false

  build() {
    Column() {
      // logo图标
      Image($r('app.media.Music_cover'))
        .width(250)
        .height(240)

      // 账号输入框（保留原有逻辑）
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

      // 密码输入框（保留原有逻辑）
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

      // 已阅读并同意（核心修改：给Checkbox绑定状态）
      Row() {
        Checkbox()
          .width(10)
          .margin({ top: 6 })
          // 绑定勾选状态变量：勾选/取消时更新isAgreeProtocol
          .onChange((checked: boolean) => {
            this.isAgreeProtocol = checked;
          })
        // 协议文本（保留原有样式）
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

      // 登录按钮（核心修改：增加协议勾选校验）
      Button('登录')
        .width('100%')
        .backgroundColor('#c02839')
        .margin({ top: 20 })
        .onClick(() => {
          // 第一步：校验是否勾选协议
          if (!this.isAgreeProtocol) {
            // 未勾选：弹出Toast提示
            promptAction.showToast({
              message: '请先阅读并同意用户协议', // 提示文本
              duration: 2000, // 提示显示时长（毫秒）
            });
            return; // 终止后续逻辑
          }

          // 第二步：校验账号密码
          if (this.validateCredentials()) {
            this.navigateToNextPage(); // 验证通过：跳转页面
          } else {
            // 账号密码错误：弹出提示
            promptAction.showToast({
              message: '账号或密码错误',
              duration: 2000
            });
            console.error('账号或密码错误');
          }
        })

      // 新用户注册等链接（保留原有逻辑）
      Row({ space: 15 }) {
        Text('新用户注册').fontSize(14).fontColor('#666')
        Text('无法登录').fontSize(14).fontColor('#666')
      }
      .margin({ top: 20 })

      // 填充组件
      Blank()

      // 其他登录方式（保留原有逻辑）
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

  // 账号密码验证逻辑（保留原有）
  validateCredentials(): boolean {
    if (this.account === '123456' && this.password === '123456') {
      return true;
    } else {
      return false;
    }
  }

  // 跳转逻辑（保留，若路由仍有问题可参考上一轮的路径/API修正）
  navigateToNextPage() {
    // 增加错误捕获，避免跳转失败无提示
    try {
      router.pushUrl({ url: 'pages/TabUIPage' });
      console.log('跳转成功');
    } catch (error) {
      console.error('跳转失败：', error);
      promptAction.showToast({
        message: '页面跳转失败，请检查配置',
        duration: 2000
      });
    }
  }
}

